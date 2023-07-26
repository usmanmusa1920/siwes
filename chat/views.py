from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from .models import Message
from .forms import MessageForm
from administrator.all_models import TrainingStudent


User = get_user_model()


@login_required
def request_to_change_acceptance_letter(request):
    """request to change acceptance letter base on student level"""
    if request.user.is_student:
        student = TrainingStudent.objects.filter(student=request.user).first()
        train_coord = User.objects.filter(
            identification_num=student.student_training_coordinator.identification_num
        ).first()

        # blocking from sending another request if already sent one
        if Message.objects.filter(
            from_sender=request.user, to_receiver=train_coord, is_request_to_change_img=True, req_level=student.level).last():
            messages.warning(
            request, f'You already sent request to change your {student.level}, level acceptance letter has been sent to your coordinator')
            return redirect(reverse('chat:send_message', kwargs={'user_id': train_coord.identification_num}))
        
        # sending new message request to chnage acceptance letter, if not sent already
        msg_req = Message(
            from_sender=request.user, to_receiver=train_coord, is_request_to_change_img=True, req_level=student.level, message=f'Request to change acceptance letter ({student.level}) level')
        msg_req.save()

        messages.success(
            request, f'Your request to change your {student.level}, level acceptance letter has been sent to your coordinator')
        return redirect(reverse('chat:send_message', kwargs={'user_id': train_coord.identification_num}))
    return False


@login_required
def approve_request(request, msg_id):
    """approved student request to change acceptance letter"""
    if request.user.is_coordinator:
        msg = Message.objects.get(id=msg_id)

        # capturing the sender and the receiver in other to filter the message, base on who is the sender and who is the receiver for the loop below. instaed of capturing it randomly
        sender = msg.from_sender # student
        receiver = msg.to_receiver # coordinator

        # making all messages (is_approved_request=True) and (is_request_to_change_img=False) that a student sent to his/her coordinator
        for req_msg in Message.objects.filter(from_sender=sender, to_receiver=receiver):
            req_msg.is_approved_request = True
            req_msg.is_request_to_change_img = False
            req_msg.save()
        messages.success(
            request, f'You just approved a request of {msg.from_sender.first_name}, to change his/her acceptance letter')
        return redirect(reverse('chat:send_message', kwargs={'user_id': sender.identification_num}))
    return False


@login_required
def decline_request(request, msg_id):
    """decline student request to change acceptance letter"""
    if request.user.is_coordinator:
        msg = Message.objects.get(id=msg_id)
        
        # capturing the sender and the receiver in other to filter the message, base on who is the sender and who is the receiver for the loop below. instaed of capturing it randomly
        sender = msg.from_sender # student
        receiver = msg.to_receiver # coordinator

        # making all messages (is_approved_request=False) and (is_request_to_change_img=False) that a student sent to his/her coordinator
        for req_msg in Message.objects.filter(from_sender=sender, to_receiver=receiver):
            req_msg.is_approved_request = False
            req_msg.is_request_to_change_img = False
            req_msg.save()
        messages.success(
            request, f'You just declined a request of {msg.from_sender.first_name}, to change his/her acceptance letter')
        return redirect(reverse('chat:send_message', kwargs={'user_id': sender.identification_num}))
    return False


@login_required
def notification(request):
    """notification view"""

    # Filtering a multiple query that will retrieve messages that:

    # the receiver of it (messages) is the current user, the is_msg_added=False, and the is_new_message=False, OR
    # the receiver of it (messages) is the current user, the is_msg_added=True, and the is_msg_replied=False, OR

    # the sender of it (messages) is the current user, the is_msg_added=False, and the is_new_message=False, OR
    # the sender of it (messages) is the current user, the is_msg_added=True, and the is_msg_replied=False.

    msgs_filter = Message.objects.filter(to_receiver=request.user.id, is_msg_added=False, is_new_message=False).order_by('-timestamp') | Message.objects.filter(to_receiver=request.user.id, is_msg_added=True, is_msg_replied=False).order_by('-timestamp') | Message.objects.filter(from_sender=request.user.id, is_msg_added=False, is_new_message=False).order_by('-timestamp') | Message.objects.filter(from_sender=request.user.id, is_msg_added=True, is_msg_replied=False).order_by('-timestamp')
    
    paginator = Paginator(msgs_filter, 10)
    page = request.GET.get('page')
    msgs = paginator.get_page(page)
    
    context = {
        'msgs': msgs,
    }
    return render(request, 'chat/notification.html', context)


@login_required
def send_message(request, user_id):
    """send message view"""

    # student instance, it will only be true if the logged in user is a student, since all student user is marked as is_stdent=True when registering him/her.
    student = TrainingStudent.objects.filter(student=request.user).first()

    # This one we filter a user by his id (user_id), which will allow us to goto his/her message page.
    msg_receiver = User.objects.get(identification_num=user_id)

    # condition to indicate a student request to change acceptance letter is approved or not. Also in the first if statement is for coordinator, while the later is for the student that send the request.
    if request.user.is_coordinator:
        # filtering student request
        request_to_change = Message.objects.filter(to_receiver=request.user, from_sender=msg_receiver, is_request_to_change_img=True, is_approved_request=False).last()

        # since this condition is for coordinator so we make student to be None to avoid error, because it did nothing as far as the logged in user is coordinator..
        is_approved_student_request = None
    elif request.user.is_student:
        # filtering student request
        request_to_change = Message.objects.filter(to_receiver=msg_receiver, from_sender=request.user, is_request_to_change_img=True, is_approved_request=False).last()

        # since this condition is for student so we filter the student from student table, so that to make it as the keyword within the route for changing his new acceptance letter if approved by his coordinator.
        is_approved_student_request = Message.objects.filter(to_receiver=msg_receiver, from_sender=request.user, is_request_to_change_img=False, is_approved_request=True).last()
    
    # This try block we check if there is any message where the receiver of it is the current user (the last message of the query set).
    try:
        is_seen = Message.objects.filter(to_receiver=request.user.id, from_sender=msg_receiver).last()
        if is_seen.to_receiver == request.user:
            # At this one we filter messages where the receiver is the current user and the is_view of the message is equal to False
            is_msg_view = Message.objects.filter(to_receiver=request.user.id, from_sender=msg_receiver, is_view=False)
        
            # Here we do a for loop in which it will make all messages where the receiver is the current user and the is_view=False, then it will make the is_view from False to True (is_view=True)
            for msg in is_msg_view:
                msg.is_view = True
                msg.save()
    except:
        pass

    # filtering messages where the receiver is the current user and the sender is the user we are in his message page OR vice versal
    msg = Message.objects.filter(Q(from_sender=request.user, to_receiver=msg_receiver) | Q(from_sender=msg_receiver, to_receiver=request.user)).all().order_by('-timestamp')

    # This is the pagination of the above query set (msg)
    paginator = Paginator(msg, 6)
    page = request.GET.get('page')
    message = paginator.get_page(page)

    # It is the context of the message paginator
    context = {'message':message}

    if request.method == 'POST':
        form = MessageForm(request.POST, request.FILES)
        if form.is_valid():
            # Checking if the cleaned_data of image == None and cleaned_dat of message == empty to avoid sending empty message.
            if form.cleaned_data.get('image') == None and form.cleaned_data.get('message') == '':
                messages.warning(request, f'You can\'t send space (empty)')
                return redirect(reverse('chat:send_message', kwargs={'user_id':user_id}))
            
            # Here it will try by filtering Messages where the sender is the current logged in user and the receiver is the one you are in his messages page
            try:
                get_msgs_1 = Message.objects.filter(
                    from_sender=request.user.id, to_receiver=msg_receiver).last()
                if get_msgs_1.from_sender == request.user:
                    
                    # This is if whether the previous messages are not marked as is_new_message=True, then the below condition will make them as (is_new_message=True)
                    is_new_msg = Message.objects.filter(
                        from_sender=request.user.id, to_receiver=msg_receiver, is_msg_added=False, is_new_message=False) | Message.objects.filter(from_sender=request.user.id, to_receiver=msg_receiver, is_msg_added=True, is_new_message=False)
                    
                    for msg in is_new_msg:
                        msg.is_new_message = True
                        msg.save()
            except:
                pass

            # Here it will try by filtering Messages where the receiver is the current logged in user and the sender is the the one you are in his messages page
            try:
                get_msgs_2 = Message.objects.filter(
                    to_receiver=request.user.id, from_sender=msg_receiver).last()
                if get_msgs_2.to_receiver == request.user:

                    # This is filtering if the message is_msg_replied=False
                    is_replied_msg = Message.objects.filter(
                        to_receiver=request.user.id, from_sender=msg_receiver, is_msg_replied=False)
                    
                    # This for loop mark all the above messages queries (is_replied_msg), is_msg_replied=True, is_msg_added=True
                    for msg in is_replied_msg:
                        msg.is_msg_replied = True
                        msg.is_msg_added = True
                        msg.save()
            except:
                pass
            
            # assign the sender, receiver, and last save the message
            instance = form.save(commit=False)
            instance.to_receiver = msg_receiver
            instance.from_sender = request.user
            instance.save()
          
        return redirect(reverse('chat:send_message', kwargs={'user_id':user_id}))
    context = {
        'message': message,
        'msg_receiver': msg_receiver,
        'student': student,
        'request_to_change': request_to_change,
        'is_approved_student_request': is_approved_student_request,
    }
    return render(request, 'chat/message.html', context)
