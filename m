From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 19:35:16 +0200
Message-ID: <20171114173516.GZ18825@mtr-leonro.local>
References: <20171113144024.26655-1-leon@kernel.org>
 <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local>
 <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TvNyW/zmhQDwPqM/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--TvNyW/zmhQDwPqM/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 06:04:07PM +0200, Or Gerlitz wrote:
> On Tue, Nov 14, 2017 at 11:56 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On Tue, Nov 14, 2017 at 10:51:31AM +0200, Or Gerlitz wrote:
>
> >> what didn't work exactly?
>
> > Started from compilation, continued to wrong data presented.
> > There is no need to carry 7-years old code, which no one cares about it.
>
> The cma kernel code doesn't compile for seven years, impossible.. you
> are referring maybe to some user-space code. Re presenting wrong data,
> again, you mean the user-space code or the kernel code sending wrong
> data to user-space? please be precise.

User-space application didn't compile and kernel sent wrong data.

Can you help me to find an answer to my initial question?
Are you using this CMA netlink interface? yes/no?
Do you know anyone who is using this interface? yes/no?

Thanks

>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TvNyW/zmhQDwPqM/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLKVMACgkQ5GN7iDZy
WKeh1BAAxKPPhzt13v0Unv+M9YcN5yVi1p/AXQQxHFptclyyaurelIDGjaC4x7rx
vgb/+OFedcJgo1VppWI0vV2U4H5IEed2ZWzaZPvc2zV/BzDj6N+bbEYw1lrTuAim
sIXGXc674g9IZVHPD0upcMuqfexTXc/Y+an8HEFYwelSH0eFHat1GGbxLf0OghSg
YZAanqJKdbE2R+w88S4jc660u11+1YPHsoHuUuNOFZo4gWw+rEe8SdrvspP13HEM
sfBNohvgYPxCeLRbfy6iPkW4tJTig5knXnLGp2ldB4BsnUomJ2kfcSrpPoIwxmJq
ZahTrLfvgVpzzKyKIrMBAV5rlc59/ePXfFowAiTCcyBN+3my87E4ujt2Mcb99h0U
nO91xfsa3Ux+XEYL14dYjXuQKwLpUnZNWBXJu+piP2isY7VfbGFzdCS8IRqF/bsU
qJrKIin9/f6Bp8zIaOpvX9PM4CtVGKnQqslMSGdKmGy3BPRXjbVAlzbMyjBFvILk
gIzHy+4Atndy2PO+XL5bEDhlsdbjWXydyHdulDSCA2eMzoY+bihVfp50By0EeHgJ
S7YttcKR4fKQfBd/vDS5gb6yDxe+89/r0HzVs1JD2uBf2zwOo0JEmClmQLjAfW5f
6Bsw0rTezNUrDnSLB4Cesy8/LYpIMyRDXfmb+3Qs0RBR3BZuTiY=
=G13T
-----END PGP SIGNATURE-----

--TvNyW/zmhQDwPqM/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
