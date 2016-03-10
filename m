From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Thu, 10 Mar 2016 14:34:07 +0530
Message-ID: <CANjDDBj=F-LTSDMesD97CvvJQWOW6fecuDLY2a9sBZ220jMYMg@mail.gmail.com>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com> <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
 <20160308175334.GB10805@obsidianresearch.com> <56E053C8.8050008@dev.mellanox.co.il>
 <20160309190354.GD21139@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160309190354.GD21139-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 10, 2016 at 12:33 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Mar 09, 2016 at 06:48:08PM +0200, Yishai Hadas wrote:
>
>> The srcu with NULL checking by itself can prevent the race, no need for the
>> "completion" mechanism. ib_uverbs_free_hw_resources uses synchronize_srcu
>> just after that ib_dev was set to NULL as part of ib_uverbs_remove_one.
>
> No, I don't think that is true, the completion looks like it is
> actually needed because the goto out in ib_uverbs_close needs to wait
> for ib_uverbs_free_hw_resources to do the cleanups ib_uverbs_close
> skipped over before it can go ahead and kref_put things.

Yes, I agree with the above explanation. Even my testing showed evidence.

>
> So, this is too ugly, do not create a mutex out of srcu and completion.
>
> Your performance reason not to use the existing lists_mutex seems
> reasonable, so add a new cleanup mutex for this purpose.
>
> Something like this. I would also get rid of file->is_closed and use
> list_del_init & list_empty instead.

Below patch seems to be working in the code analysis. I will test though.
I would test this approach as well before posting V3.

>
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 39680aed99dd..8d192234fdd6 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -953,18 +953,20 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
>  {
>         struct ib_uverbs_file *file = filp->private_data;
>         struct ib_uverbs_device *dev = file->device;
> -       struct ib_ucontext *ucontext = NULL;
>

ib_dev pointer will not be NULL if cleanup_mutex is taken, thus no
need to check here.

>         mutex_lock(&file->device->lists_mutex);
> -       ucontext = file->ucontext;
> -       file->ucontext = NULL;
>         if (!file->is_closed) {
>                 list_del(&file->list);
>                 file->is_closed = 1;
>         }
>         mutex_unlock(&file->device->lists_mutex);
> -       if (ucontext)
> -               ib_uverbs_cleanup_ucontext(file, ucontext);
> +
> +       mutex_lock(&file->cleanup_mutex);
> +       if (file->ucontext) {
> +               ib_uverbs_cleanup_ucontext(file, file->ucontext);
> +               file->ucontext = NULL;
> +       }
> +       mutex_unlock(&file->cleanup_mutex);
>
>         if (file->async_file)
>                 kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
> @@ -1177,26 +1179,26 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
>
>         mutex_lock(&uverbs_dev->lists_mutex);
>         while (!list_empty(&uverbs_dev->uverbs_file_list)) {
> -               struct ib_ucontext *ucontext;
> -
>                 file = list_first_entry(&uverbs_dev->uverbs_file_list,
>                                         struct ib_uverbs_file, list);
>                 file->is_closed = 1;
> -               ucontext = file->ucontext;
>                 list_del(&file->list);
> -               file->ucontext = NULL;
>                 kref_get(&file->ref);
>                 mutex_unlock(&uverbs_dev->lists_mutex);
> +
>                 /* We must release the mutex before going ahead and calling
>                  * disassociate_ucontext. disassociate_ucontext might end up
>                  * indirectly calling uverbs_close, for example due to freeing
>                  * the resources (e.g mmput).
>                  */
>                 ib_uverbs_event_handler(&file->event_handler, &event);
> -               if (ucontext) {
> -                       ib_dev->disassociate_ucontext(ucontext);
> -                       ib_uverbs_cleanup_ucontext(file, ucontext);
> +               mutex_lock(&file->cleanup_mutex);
> +               if (file->ucontext) {
> +                       ib_dev->disassociate_ucontext(file->ucontext);
> +                       ib_uverbs_cleanup_ucontext(file, file->ucontext);
> +                       file->ucontext = NULL;
>                 }
> +               mutex_unlock(&file->cleanup_mutex);
>
>                 mutex_lock(&uverbs_dev->lists_mutex);
>                 kref_put(&file->ref, ib_uverbs_release_file);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
