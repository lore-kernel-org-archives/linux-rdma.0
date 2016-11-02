From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] IB/core: Support rate limit for packet
 pacing
Date: Wed, 2 Nov 2016 17:35:07 +0200
Message-ID: <20161102153507.GF3617@leon.nu>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1477909297-14491-3-git-send-email-leon@kernel.org>
 <20161101100607.GB3727@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l+RjsdkfuJDA0G6K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161101100607.GB3727-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--l+RjsdkfuJDA0G6K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 12:06:08PM +0200, Yuval Shaia wrote:
> Two (extremely) minor suggestions inline.
>
> Yuval
>
> On Mon, Oct 31, 2016 at 12:21:35PM +0200, Leon Romanovsky wrote:
> > From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add new member rate_limit to ib_qp_attr, it shows the packet pacing rate
>
> Suggesting to replace with:
> Add new member rate_limit to ib_qp_attr which holds the packet pacing rate
>
> > in Kbps, 0 means unlimited.
> >
> > IB_QP_RATE_LIMIT is added to ib_attr_mask, and it could be used by RAW
>
> Suggesting to replace with:
> IB_QP_RATE_LIMIT is added to ib_attr_mask and could be used by RAW
>
> > QPs when changing QP state from RTR to RTS, RTS to RTS.
> >
> > Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks Yuval,

Doug,
What do you expect from us? respin of this patch?

Thanks

--l+RjsdkfuJDA0G6K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGgerAAoJEORje4g2clinSu0P/02Pahf+WnxlfbIQlFBa3Efy
llmTWBFydgQmVX8W6xNXVUquj7Ei7xoTnBwM9CoKr9JjkspxYLfsm1Ih5U37nSUD
39OOkCS1ZXvrF3gtM2+K2qbqo6zizQe55/0JLc+U6Im5Vdf1EsA8HLMjHgkgDZE5
rYyrn4ZKDDuadI0fKqkhB1jYABNEbt1d0hrASI3FgB+dgo1S6FTacKZQ5ApLlNFC
IJAdYWTt69CVTBt7kwoa74eYV9Ups48CShRXJQ7qGcKCDibKt709NfpESCYARPaX
i2JVQr6IqXGoPX/UmJIh3r+ZsVBfgr4r0X0AWt2ZYDmV/cbuMno+xoIQ18LjbCyM
/1KquQiReHmw7CCWxwcB8VhBNMORnbBA/Yqdrz+RPI5mi5+IU8hIpQ7Gg7R7VbEO
FrYsL+2MvZDOLnVetJmpr31UuTTMqFBVRcdP3UVtf4aIqPkV/OvXYmffDpH7AL9g
gN8cbnInCPBSrvoQPGKOE67MAJ3RGtjSsnPIjw7Yf6x6uC6zPCKqHxpYXYXqmzIm
lBPOI3xBJcZXHUtaPd4WvxngPwAdgJjxbcFFl16ql5AE3sTut0tPDGOBtoGIKSSX
ACgYGcPVXzlumghIiIhc1ClQMKL9Eak3XwypYR7RiY2t5QupwOujSS1ABVW/2Qsh
wvu9gQ/p3jk1l8BRRgtt
=UicJ
-----END PGP SIGNATURE-----

--l+RjsdkfuJDA0G6K--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
