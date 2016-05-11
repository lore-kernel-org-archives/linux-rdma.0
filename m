From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fix srp_create_target() error handling
Date: Wed, 11 May 2016 10:39:19 +0300
Message-ID: <20160511073919.GD25215@leon.nu>
References: <573278D9.4050908@sandisk.com>
 <57327940.3030206@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57327940.3030206-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 10, 2016 at 05:13:52PM -0700, Bart Van Assche wrote:
> Avoid that the following kernel oops occurs if memory pool
> allocation fails:
>=20
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa048d0a0>] ib_drain_rq+0x0/0x20 [ib_core]
> Call Trace:
>  [<ffffffffa04af386>] srp_create_target+0xca6/0x13a9 [ib_srp]
>  [<ffffffff813cc863>] dev_attr_store+0x13/0x20
>  [<ffffffff81214b50>] sysfs_kf_write+0x40/0x50
>  [<ffffffff81213f1c>] kernfs_fop_write+0x13c/0x180
>  [<ffffffff81197683>] __vfs_write+0x23/0xf0
>  [<ffffffff81198744>] vfs_write+0xa4/0x1a0
>  [<ffffffff81199a44>] SyS_write+0x44/0xa0
>  [<ffffffff8159e3e9>] entry_SYSCALL_64_fastpath+0x1c/0xac
>=20
> Fixes: 1dc7b1f10dcb ("IB/srp: use the new CQ API")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.5+

Looks good,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMuGnAAoJEORje4g2clinEeYQAM8tbad+TBJsQYNlukmk8YXU
4decSzgacZsoBq3NFBtmlckqNrPNeQwZuJlhx89vmEh4mLFOE6MQ972w9O+NHR+P
RGQ422OATfxmUZXcm+AHi06re/qIHFV8s32WG1/Ril5FkLZqRq57CVCq+tTtU/Kt
nPTd0RgX3Kf4uRYxXMBRFXByC9Xk+T9HxCMdXjAYOV9v8Z+DV2cSF61zdx5V+lUC
3yAr31WHL6ydist95AvaBXbo9xJX3sEIunS5LvjDINmQlPm9HyW0AhOkuPL+pl2w
B99NvJ3pcxZunZKulXjP4yoitq1c03r22lbrTgBm2b38Ja/3WiDdE84zp8t1O5af
L9d6etOUqBsh6t32xajZJTPYFqGS7IJLgu1kFrRb4BeLz5dmk7A2R+77N6G23hS4
zENE0NklP3geMNhimsFJMAdBGpGtRx/U/qfy+uFiZw9i6hPcRhpkELZQRJAEmlsn
xRGNQ5TF7kfd5OnlalrL4D4z32T33oRYSNuCbwFLh5dbXjudd9fKEX9I8FQC3vZo
bVVlgF9L3wyyDgdOqcnZO/gRiTyVA/lkubbAuZPiZ1ivKTKRl3hS+qRbV1hqUL/6
le8t29kwSFgyD8KHR2FDmbgNMu0xS5YBupW5gjFJh2VRgJjy8Leh+69XSHY22tdS
oyr8/YGseegKq6KrbIJi
=jF/m
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
