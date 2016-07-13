From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 7/8] RDMA/core: Change locking of ib_uobject
Date: Wed, 13 Jul 2016 11:16:57 -0600
Message-ID: <20160713171657.GB19657@obsidianresearch.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-8-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467293971-25688-8-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 04:39:30PM +0300, Matan Barak wrote:
> This patch presents some concept about lockless scheme. It's only
> intended to open discussion and still misses some crucial parts.

It isn't really lockless, is it? I gather the intent is to remove the
per-uobj lock(s) and replace with a ucontext rwsem?

> Every ib_uobject has a usecnt atomic variable. Single rwsem in
> ib_uverbs_file (protect destruction of device from execution of
> commands).
> 
> For every command execution:
>   a. Check if device is available (as of today, with srcu)
>   b. Take down_read(&file->close_sem)
>   c. <User is now protected from closing the process and ib-dev
>      destruction>
>   d. When an object is used -> use uverbs_lock_object function
>      implemented in this patch.
>        i .If the object isn't available (-EBUSY)

I'd like to see a detailed list of all the calls that change from
blocking to EBUSY with this approach.

I also think this should be stand-alone as part of the uobject rework
series.. Again it seems like this benifits any approach.

uverbs_lock_object is in an different patch in the series..

I'm always nervous when I see people create their own locks with
atomics. Don't do that. That is a rw lock using try_lock.

>   e. Unlock with uverbs_unlock_object (implemented in this patch)
>   f. Release up_read(&file->close_sem)

g. release srcu

If the close_sem is always being held, then I suspect we can drop SRCU
as well??

> ib_uobjects are lockless. If two commands are executed in
> parallel and one need exclusive access (WRITE/DESTROY) -> one
> command will fail. User-space needs to either synchronize or do
> something productive with the failure.

I think this can work for destroy, but I have a hard time seeing how
it is going to be OK for WRITE/MODIFY/etc operations.

eg rereg_mr holds the write lock, I'm not sure I'm comfortable seeing
that be allowed to fail ..

> @@ -308,8 +298,8 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
>  	if (!uobj)
>  		return -ENOMEM;
>  
> -	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
> -	down_write(&uobj->mutex);
> +	down_read(&file->close_sem);
> +	init_uobj(uobj, 0, file->ucontext);

Seeing this pattern in your patches really makes me wonder.. What is
the down_write even doing at that point???

        uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
        init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
        down_write(&uobj->mutex);

init_uobj doesn't add the memory to any lists or anything. How could
another thread get access to the pointer and contend on the mutex?

I guess it is because later we do:

        ret = idr_add_uobj(&ib_uverbs_pd_idr, uobj);

While holding the lock. But that is a really ugly API. Nothing should be
added to the idr until it is 100% initialized, so we don't need
concurrency protection. What is the write lock doing at that point??

This whole flow should be simplified, which will make the locking
requirements a lot clearer.

  uobj = uobj_alloc(file->ucontext, 0, sizeof(*uobj));
  [.. full setup ..]
  uobj_activate(uobj); // live = 1, list_add_tail, idr_add

  resp.handle = uobj->id;
  copy_to_user(..);

  put_uobj(uobj);
  return ret;

err1:
  uobj_deactivate(uobj);
err2:
  put_obj(uobj);

I would do the above sort of restructuring as another (mergable, even)
patch, then rip out the locking.

Also, I think the destruction should be equally cleaned up. If you
introduce a patch with actual ops and a destroy function pointer
per-type then a centralized destruct call can be implemented that does
the correct lock, wrapping the functionc all. Again this would be a
nice clean up to have distinct from the ioctl stuff...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
