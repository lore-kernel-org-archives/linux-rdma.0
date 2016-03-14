From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Mon, 14 Mar 2016 11:10:33 +0530
Message-ID: <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com> <20160312204502.GA8346@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160312204502.GA8346-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 13, 2016 at 2:15 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Sat, Mar 12, 2016 at 10:18:47AM -0500, Devesh Sharma wrote:
> > CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> I'm still pretty convinced this is wrong... But even still:
>
> > @@ -954,6 +955,17 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
> >       struct ib_uverbs_file *file = filp->private_data;
> >       struct ib_uverbs_device *dev = file->device;
> >       struct ib_ucontext *ucontext = NULL;
> > +     struct ib_device *ib_dev;
> > +     int srcu_key;
> > +
> > +     srcu_key = srcu_read_lock(&dev->disassociate_srcu);
> > +     ib_dev = srcu_dereference(dev->ib_dev,
> > +                               &dev->disassociate_srcu);
> > +     if (!ib_dev) {
> > +             srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
> > +             wait_for_completion(&file->fcomp);
> > +             goto out;
>
> This jumps over this:

I am not sure, to my mind kref_put(...,ib_uverbs_release_file) should
also be skipped. Because,
by putting an wait_for_completion(), this context is effectively
waiting for ib_uverbs_cleanup_ucontext
to finish cleaning up this file pointer. if the other thread is
cleaning up, why do I need to put the kerf again?

>
> >       if (file->async_file)
> >               kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
>
> Which doesn't seem right.
>
> As I've said, I'm not sure how this is any different from using
> lists_mutex. The wait_for_completion will still block and deadlock if
> ib_uverbs_close is entered during the disassociate flow.

Taking list-mutex is not stopping ib_dev pointer to become NULL, while
if we split the mutex
and wait_for_completion(), then effectively we are trying to sync
ib_uverb_close() and
remove_one() in such a way that no ib_uverb_close context hit ib_dev = NULL

I hope I was able to put the situation in simpler words?

Can you please explain how it can lead to a deadlock?


>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
