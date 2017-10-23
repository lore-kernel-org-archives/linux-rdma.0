From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Mon, 23 Oct 2017 08:54:50 +0300
Message-ID: <20171023055450.GB2106@mtr-leonro.local>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
 <3F128C9216C9B84BB6ED23EF16290AFB6347E3BF@CRSMSX101.amr.corp.intel.com>
 <20171020162017.GZ2106@mtr-leonro.local>
 <3F128C9216C9B84BB6ED23EF16290AFB6347E59B@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oYrjhH26xX5Rz9aF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB6347E59B-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oYrjhH26xX5Rz9aF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 20, 2017 at 07:04:33PM +0000, Wan, Kaike wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > Sent: Friday, October 20, 2017 12:20 PM
> > To: Wan, Kaike
> > Cc: Ruhl, Michael J; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> > misinterpreted flag
> >
> > On Fri, Oct 20, 2017 at 12:18:02PM +0000, Wan, Kaike wrote:
> > > The nlmsg_flags from 0x100 and up have always been overloaded for
> > different requests, as shown in include/uapi/linux/netlink.h:
> >
> > Exactly, they are overloaded in include/uapi/linux/netlink.h where all nlmsg
> > flags are declared and not in some random rdma*.h file.
>
> Since they are known to be overloaded, how could you depend on the flags to make decision for all requests/responses?

Sorry for applying common sense for the RDMA subsystem. The netlink structures are declared
and exported to users in one specific file, the structure, flags and defines belong to netdev
subsystem and were not supposed to be overwritten by other users.

>
> The reason for defining RDMA_NL_LS_F_ERR in include/uapi/rdma/rdma_netlink is that all LS related defines and structures are defined in the file. It is true that it can lead to misuse, just like the current code. However, the defines in include/uapi/linux/netlink.h un-mistakenly indicate that those bits can be overloaded.

We are talking about theoretical case, the current LS implementation
will stay as is, so no worries.

>
> >
> > But it is not my main point.
> >
> > My main point is lack of usage of NLMSG_ERROR messages to inform about
> > errors, exactly as kernel informs users about errors in netlink, but in the
> > opposite direction.
>
> The difference is that the LS needs all the original information (request type, client index, msg_seq, etc) to match the response with the original request. Therefore, the easiest thing to do is to return the response with the original info plus an error flag, instead of using the NLMSG_ERROR message.
>

Just wanted to mention that NLMSG_ERROR is netlink message type and it
carries all other information except message type.

> > > >
> > > > In meanwhile, can we implement dummy dumpit functions for the LS,
> > > > which reuse ib_nl_is_good_ip_resp?
> > >
> > > Why do you want to jump all the dump hoops instead of directly calling the
> > response handler? LS is different from other netlink channels in that it sends
> > request from kernel to user space and receives responses from it instead of
> > the other way around. Consequently, the handling of netlink responses may
> > be different from handing requests from user space.
> > >
> >
> > Doesn't the part of email below answers on the question "why"?
>
> No. A response should not necessarily be processed the same as a request.

Right, and I expected to see complete mirror of kernel-to-user
communication in respect to LS user-to-kernel communication.

>
> >
> > > >
> > > > I prefer this solution over yours, because it doesn't mix
> > > > LS-specifics with general decision function and leaves LS anomalies in the
> > LS-relevant code.
> >
> >
> > > >
> > > > And returning 0 in absence of dumpit function as a response with
> > > > NLM_F_DUMP flag is wrong. User should be aware of the fact that
> > > > something wrong was with his request.
> > > >
> > > > Thanks
> > > >
> > >

--oYrjhH26xX5Rz9aF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnthCoACgkQ5GN7iDZy
WKdP0RAAi3N8BDhnUFJXWduGvnMUAVehu4Ix0MIx4GbXksL/sxH3iLkseAByccmn
5rKycQB28ygbj2HlDTq2g7/be1y2ShzG2L4prBC01RORTNKAcqquZ+pBX92vuKTZ
HqSFaG94vSbb8S5nDEdw6hqJ8b4RzrTxzYwAlEBqgoxX0YIzJiQVBTSV9wi52f5u
RO2W5Rf/aw8jx+wEzeyWlP2EexkduIFKwKyyI5izSTqwcr38J6dQ7qVF7TtocMRc
gFFm6Q7iyBMMjvF55Cd3oUaPCVe43jp0A220EGJeO77nJJFBcij8u9aPXYV5RTvt
X7pTtJ+E6+V+Ca1MM7nhpkUrvAJEYkxJCK2Eggd+f/w+ugRU4gQJYCeHd0BOnbqD
u2s6DBcKJnXjAuwe/Lwz32/Nh/oDUI/7KcCAf/VH9TmiHGq59YA7cSGzAuXCBSGq
pXn8AWN6Q4XA8eRsymQqvGEsN9sLVGv7jLVXox7j5c2SxebA3ZvrBVmJZRZtZJbw
jshgWQbRlwDr4Ed1HVg6RB+EA7W2zHxeiMtruhzyysjbiqkWK4gvTWBEOclxQOjR
wZoYAjo0P9Q7RyKKPm2nhBEjKrX26dB4RILXW8hTgPqmlSTYu9CJZK1b5j5cTsVe
XowKlHYGrvFGp7ua9kxSzVGO2FC/+uWTJo031MFlveBra2UssV0=
=4322
-----END PGP SIGNATURE-----

--oYrjhH26xX5Rz9aF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
