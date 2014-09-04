From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
Date: Thu, 4 Sep 2014 13:45:17 -0400
Message-ID: <20140904174517.GA2685@gmail.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
 <5405D2D8.1040700@mellanox.com>
 <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com>
 <CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com>
 <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Latchesar Ionkov <lionkov-YOWKrPYUwWM@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 03, 2014 at 02:15:51PM -0700, Roland Dreier wrote:
> > I would like to note that we at Los Alamos National Laboratory are =
very
> > interested in this functionality and it would be great if it gets a=
ccepted.
>=20
> Have you done any review or testing of these changes?  If so can you
> share the results?

So jumping in here. I am working on a similar issue, ie on a subsystem =
that
allow a device to mirror a process address space (or part of it) using =
its
own mmu and page table.

While i am aiming at providing a generic API, it is not yet fully cook =
thus
i think having a driver implement its own code in the meantime is somet=
hing
we have to live with. I am sharing the frustration of Sagi or Haggai on=
 how
hard it is to get any kind of review.

I have not yet reviewed this code but it's nearing the top of on my tod=
o list.
Even thought i am not an authoritative figure in either mm or rdma.

=46or anyone interested in taking a peak at HMM (subsystem i am working=
 on to
provide same functionality and more) :

http://marc.info/?l=3Dlinux-mm&m=3D140933942705466&w=3D4

Cheers,
J=E9r=F4me

>=20
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
