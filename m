From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
Date: Sun, 7 Aug 2016 16:14:19 +0300
Message-ID: <20160807131419.GS27667@leon.nu>
References: <1470445284-28970-1-git-send-email-weiyj.lk@gmail.com>
 <20160807053115.GQ27667@leon.nu>
 <087f4381-d830-fc57-ea5d-c516a1b160b5@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z+AhoeLdLI498vdY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <087f4381-d830-fc57-ea5d-c516a1b160b5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--z+AhoeLdLI498vdY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 07, 2016 at 08:19:39PM +0800, Wei Yongjun wrote:
> On 08/07/2016 01:31 PM, Leon Romanovsky wrote:
> > On Sat, Aug 06, 2016 at 01:01:24AM +0000, Wei Yongjun wrote:
> >> In case of error, the function devm_ioremap_resource() returns ERR_PTR=
()
> >> and never returns NULL. The NULL test in the return value check should
> >> be replaced with IS_ERR().
> >>
> >> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > On which branch did you base your patch?
> > It would be helpful to us if you followed SubmittionPatches document,
> > section with Fixes description. In such case "git describe" will give
> > immediate answer on my first question.
> >
> This patch is based on the linux-next.git tree.
> Fixes: 5e43122add63 ('IB/hns: Add driver files for hns RoCE driver')

This driver wasn't part of last pull request and it is worth to consult
with Doug Ledford on the plans for this driver (stay in ->next, resubmit
e.t.c).

Right now, there is no tree to apply this patch.

Thanks
>=20

--z+AhoeLdLI498vdY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXpzQrAAoJEORje4g2clinv9MQALHI2ftoPlbqME7f8Zr3O8iS
rARllZmyJjN/N4jEmBoxcCu0DZEdlhpHgs0RcarAtjiwEixr61MBUB41eeHM8z5z
8LGREKkog+4Cd8tpTcBBML3mSxZv+MzsiBtSfWWAhmg9GQg3HNkD6AW8WTj7Vgog
LOQhuI+FGN//FHUvW6SIIrpwZQYKhX+fnOwvb3d95H3TX/Vs4xbT52pDWO0xOU/a
HJi8TTozGEcnJPqgd5Gj0b4mJS7quLf+EcYOIBdcbszmbg7Hf7BOBlXeqYxiA7r0
Qa0sshtygfrL5RlFocy6Rrn9+DVFyoRUAE1kRC1psJx7vxsRE2fkRqRufuTJjwFL
yTrRJNNU3lUh+GtQlILys3VPiVknZ6kiYLMXWCs3QxxW+OgeT3i0ze33MLuzbwtD
m49mcrR3Ol7V/vDpFGo2r/+YdO7i+VW8UY4CcnfVomokXJo6JEEjqWK6MZzfe6Nv
HA1BC16+tV9+JHpBaJPE1MdvwxaFvlAUpaDWCiwu2ALYU3y9ZPvBWMZQcuBRewIX
clTRSVTbEif+/dsDkRsjoLqKmv1K9wRxV6xYZL3yq3+ktcVTrn+nawgrW5qYdwIU
fvhGJV5M0lrIU+aruHrIFe/2651yJSEhNlgW5KMPehIQZHCrTsPkbOZ7KGeolxqX
jkKc9jcjNmHr1fTaqn+J
=SEpG
-----END PGP SIGNATURE-----

--z+AhoeLdLI498vdY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
