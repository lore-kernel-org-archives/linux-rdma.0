From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our
 get_user_pages() parameters
Date: Mon, 30 Jan 2012 21:20:13 +0100
Message-ID: <20120130202013.GJ30782@redhat.com>
References: <1327557574-6125-1-git-send-email-roland@kernel.org>
 <alpine.LSU.2.00.1201261133230.1369@eggly.anvils>
 <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com>
 <alpine.LSU.2.00.1201271458130.3402@eggly.anvils>
 <CAL1RGDXqguZ2QKV=yjLXtk2n_Ag4Nf3CW+kF2BFQFR4ySTNaRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDXqguZ2QKV=yjLXtk2n_Ag4Nf3CW+kF2BFQFR4ySTNaRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

On Mon, Jan 30, 2012 at 11:16:04AM -0800, Roland Dreier wrote:
> I have no idea of the history there... probably could be changed with
> no problems.
>=20
> However, get_user_pages has this comment:
>=20
>  * @force:	whether to force write access even if user mapping is
>  *		readonly. This will result in the page being COWed even
>  *		in MAP_SHARED mappings. You do not want this.
>=20
> but I don't see where in the code FOLL_FORCE does COW
> for MAP_SHARED mappings.  But on the OTOH I don't see
> why we set force in the first place.  Why wouldn't we respect
> the user's mapping permissions.

I think it does, because pte_write cannot set if VM_WRITE is not set,
so then do_wp_page will be called if only VM_MAYWRITE is set.

force should only be needed by gdb, to modify .text, nothing else.

But for your usage, or anything that doesn't need to go around
userland "robusteness" permission for debugging purposes, it shouldn't
be needed.

> > I feel you're trying to handle two very different cases (rdma into
> > user-supplied anonymous memory, and exporting driver memory to the
> > user) with the same set of args to get_user_pages(). =A0In fact, I
> > don't even see why you need get_user_pages() at all when exporting
> > driver memory to the user. =A0Ah, perhaps you don't, but you do wan=
t
> > your standard access method (which already involves GUP) not to
> > mess up when applied to such a mapping - is that it?
>=20
> Exactly.  Right now we have the libibverbs userspace API, which
> basically lets userspace create an abstract "memory region" (MR)
> that is then given to the RDMA hardware to do IO on.  Userspace does
>=20
>     mr =3D ibv_reg_mr(..., buf, size, access_flags);
>=20
> where access flags say whether we're going to let the hardware
> read and/or write the memory.
>=20
> Ideally userspace should not have to know where the memory
> underlying its "buf" came from or what type of mapping it is.
>=20
> Certainly there are still more unresolved issues around the case
> where userspace wants to map, say, part of a GPUs PCI memory
> (which won't have any underlying page structs at all), but I'm at
> least hoping we can come up with a way to handle both anonymous
> private maps (which will be COWed from the zero page when
> the memory is touched for writing) and shared mappings of kernel
> memory exported by a driver's mmap method.

If you map it with an mmap(PROT_READ|PROT_WRITE), force or not force
won't change a thing in terms of cows. Just make sure you map your
control memory right, then safely remove force=3D1 and you won't get th=
e
control page cowed by mistake. Then if you map it with MAP_SHARED it
won't be mapped read-only by fork() (leading to either parent or child
losing the control on the device), Hugh already suggested you to use
MAP_SHARED instead of MAP_PRIVATE.

Also I'm assuming the control memory is in ram not mmio space because
gup shouldn't mess with mmio space (which should be mapped with
VM_PFN_MAP and VM_IO in fact, to allow gup abort before it touches
anything).

> So I guess I'm left thinking that it seems at least plausible that
> what we want is a new FOLL_ flag for __get_user_pages() that triggers
> COW exactly on the pages that userspace might trigger COW on,
> and avoids COW otherwise -- ie do FOLL_WRITE exactly for the
> pages that have VM_WRITE in their mapping.

Well, that's the force=3D0 behavior, it should be like userland.

force bypass it and allows to write in a way that should instead
-EFAULT if it was userland writing to it (but for example in .text, it
doesn't overwrite pagecache of the binary, or it'd screw every other
instance of the executable, but it cows it so it then can modify .text
for gdb).

If you don't use force, the cowing behavior should be identical to
userland (except you'll get -EFAULT as retval, instead of
of a sigsegv raised).

> I don't think we want to do the "force" semantics or deal with the
> VM_MAYWRITE possiblity -- the access we give the hardware on
> behalf of userspace should just match the access that userspace
> actually has.  It seems that if we don't try to get pages for writing
> when VM_WRITE isn't set, we don't need force anymore.

Agreed. I guess you just need to map the control buffer in a way that
if userland writes to it, won't cow it? So then if gup tries to write
to it, it won't cow it? Still it sounds weird that gup writes to the
control buffer of the card, maybe you should do a check on the pages
returned by gup and verify they're not the control buffer before
allowing DMA to those?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
