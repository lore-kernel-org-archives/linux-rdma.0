From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Tue, 8 Mar 2016 10:53:34 -0700
Message-ID: <20160308175334.GB10805@obsidianresearch.com>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com>
 <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 04:24:51PM +0530, Devesh Sharma wrote:

> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -962,9 +962,9 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
> >                 list_del(&file->list);
> >                 file->is_closed = 1;
> >         }
> > -       mutex_unlock(&file->device->lists_mutex);
> >         if (ucontext)
> >                 ib_uverbs_cleanup_ucontext(file, ucontext);
> > +       mutex_unlock(&file->device->lists_mutex);
> >
> >
> > ??
> 
> There is following comment about list_mutex in uverbs_main.c around
> line number 1200:
> /* We must release the mutex before going ahead and calling
>  * disassociate_ucontext. disassociate_ucontext might end up
>  * indirectly calling uverbs_close, for example due to freeing
>  * the resources (e.g mmput).
>  */

Okay, now I remember this discussion, and being unhappy about this
during review.

However, this comment is talking about disassociate_ucontext, the bug
is with ib_uverbs_cleanup_ucontext. We can't re-entre uverbs_close
while we are already in uverbs_close, so that doesn't explain why it
cannot be in the mutex.

So, Yishai, what is the problem with the above lock placement?

The only issue you raised was with multi-file close concurrency, and
that is trivially solved with another mutex.

I'd rather see another mutex added then this ugly add-hoc
srcu/completion thing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
