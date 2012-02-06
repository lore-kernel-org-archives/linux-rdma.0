From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages() parameters
Date: Mon, 6 Feb 2012 09:39:42 -0800
Message-ID: <CAL1RGDVSBb1DVsfvuz=ijRZX06crsqQfKoXWJ+6FO4xi3aYyTg@mail.gmail.com>
References: <1327557574-6125-1-git-send-email-roland@kernel.org>
 <alpine.LSU.2.00.1201261133230.1369@eggly.anvils> <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com>
 <alpine.LSU.2.00.1201271458130.3402@eggly.anvils> <CAL1RGDXqguZ2QKV=yjLXtk2n_Ag4Nf3CW+kF2BFQFR4ySTNaRA@mail.gmail.com>
 <alpine.LSU.2.00.1201301217530.4505@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1201301217530.4505-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry for the slow reply, I got caught in other business...

On Mon, Jan 30, 2012 at 12:34 PM, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
> The hardest part about implementing that is deciding what snappy
> name to give the FOLL_ flag.

Yes... FOLL_SOFT_COW ?  FOLL_READONLY_COW ?
(plus a good comment explaining it I guess)

>> I don't think we want to do the "force" semantics or deal with the
>> VM_MAYWRITE possiblity -- the access we give the hardware on
>> behalf of userspace should just match the access that userspace
>> actually has. =A0It seems that if we don't try to get pages for writ=
ing
>> when VM_WRITE isn't set, we don't need force anymore.
>
> I suspect you never needed or wanted the weird force behaviour on
> shared maywrite, but that you did need the force COW behaviour on
> private currently-unwritable maywrite. =A0You (or your forebears)
> defined that interface to use the force flag, I'm guessing it was
> for a reason; now you want to change it not to use the force flag,
> and it sounds good, but I'm afraid you'll discover down the line
> what the force flag was for.

Actually I think I understand why the original code passed !write
as the force parameter.

If the user is registering memory with read-only access, there are
two common cases.  Possibly the underlying memory really has
a read-only mapping, but probably more often it is just an ordinary
buffer allocated in userspace with malloc() or the like.

In the second case, it's quite likely we have a read/write mapping
of anonymous pages.  We'll expose it read-only for RDMA but the
userspace process will write data into the memory via ordinary CPU
access.  However, if we do ibv_reg_mr() before initializing the memory
it's quite possible that the mapping actually points to the zero page,
waiting for a CPU write to trigger a COW.

So in the second case, doing GUP without the write flag will leave
the COW untriggered, and we'll end up mapping the zero page to
the hardware, and RDMA won't read the data that userspace actually
writes.  So (without GUP extension as we're discussing in this thread)
we're forced to pass write=3D=3D1 to GUP, even if we expect hardware
to only do reads.

But if we pass write=3D=3D1, then GUP on the first case (mapping that
is genuinely read-only) will fail, unless we pass force=3D=3D1 too.  Bu=
t
this should only succeed if we're going to only access the memory
read-only, so we should set force to !writable-access-by-rdma.

Which I think explains why the code is the way it is.  But clearly
we could do better if we had a better way of telling GUP our real
intentions -- ie the FOLL_READONLY_COW flag.

> Can you, for example, enforce the permissions set up by the user?
> I mean, if they do the ibv_reg_mr() on a private readonly area,
> so __get_user_pages with the FOLL_APPROPRIATELY flag will fault
> in ZERO_PAGEs, can you enforce that RDMA will never spray data
> into those pages?

Yes, the access flags passed into ibv_reg_mr() are enforced by
the RDMA hardware, so if no write access is request, no write
access is possible.

And presumably if we do GUP with write=3D=3D1, force=3D=3D0 that will
fail on a read-only mapping?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
