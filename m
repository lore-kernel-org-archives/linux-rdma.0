From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib/core: Protect QP mcast list
Date: Wed, 21 Dec 2011 09:10:24 +0200
Message-ID: <20111221071024.GA27134@mtldesk30>
References: <20111219070952.GA11530@mtldesk30>
 <CAL1RGDUpqz+26fKcHj=0NbNqU_8vYV6zOresyYzFZTasGwD_oA@mail.gmail.com>
 <CAL3tnx7u9_Yrqr0QZ=c2tKnJtyFe97XR2QKh0=DQuP77XYn9Kg@mail.gmail.com>
 <CAL1RGDUdrAK20fTOQUTgBHw-PnPjkojC8hE7oAePd=NCLSnGrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUdrAK20fTOQUTgBHw-PnPjkojC8hE7oAePd=NCLSnGrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 20, 2011 at 04:36:35PM -0800, Roland Dreier wrote:
> On Mon, Dec 19, 2011 at 11:19 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > I considered this but that means that you serialize attach/detach
> > operations at ib core. Using a spinlock to protect the list allows
> > more concurrency. After all, we hit this bug since concurrency of such
> > operations occur in real life applications.
> 
> Looking closer at it, I don't see how we can avoid serializing multicast
> operations.
> 
> At least, I don't see how your proposed patch can work for all the crazy
> things userspace might do.
> 
> For example suppose two threads join the same QP to the same MCG at
> the same time.  In that case it might happen that both threads check the
> list and don't find the group there, since you drop the lock before the
> actual low-level verbs attach (and you don't and can't hold the lock across
> that sleeping call).
> 
> In that case both calls to attach will succeed (underlying verb is
> idempotent) and the membership info will be added to the list twice.
> 
> Then all sorts of problems ensue, eg a detach will succeed but only
> remove one list entry, and so a subsequent re-attach will silently do
> nothing.
> 
> Also I'm sure racing attach/detach can get into trouble too, eg
> detach succeeds but list entry ends up still on the list.
> 
> I don't see any obvious way to close all these holes except to
> make sure that adding/removing a list entry is done atomically
> along with the actual attach/detach operation -- ie hold some
> sort of sleepable lock (like an rwsem) across checking the list,
> doing the attach/detach and doing the list add/remove.
> 

I see...
I think there is not much point in introducing a new semaphore. We can
simply use the existing rw_semaphore. This requires defining
idr_write_qp and put_qp_write. I will prepare a patch and run some
testing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
