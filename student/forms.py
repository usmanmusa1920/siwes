from django import forms
from django.contrib.auth import get_user_model
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.all_models import(
    Session, Faculty, Department, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, WeekScannedImage, CommentOnLogbook, StudentResult
)


User = get_user_model()


class UploadAcceptanceLetter(forms.ModelForm):
    class Meta:
        model = AcceptanceLetter
        fields = ['image']


class UploadLogbookEntry(forms.ModelForm):
    class Meta:
        model = WeekScannedLogbook
        fields = ['title', 'text']


class UploadLogbookImage(forms.ModelForm):
    class Meta:
        model = WeekScannedImage
        fields = ['image']


class LogbookEntryComment(forms.ModelForm):
    class Meta:
        model = CommentOnLogbook
        fields = ['grade', 'comment']
