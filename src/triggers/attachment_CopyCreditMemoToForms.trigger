trigger attachment_CopyCreditMemoToForms on Attachment (after update) {
   for (Integer i = 0 ; i < trigger.new.size(); i++) {
      if (trigger.isInsert || trigger.isUpdate) {
         List<Attachment> attachments = Trigger.new;
         for (Attachment attachment : attachments) {
            if (attachment.Name == 'Rendered_View.html') {
               CopyAttachmentTriggerHandler.updateFields(attachment.Id);
            }
         }
      }
   }
}