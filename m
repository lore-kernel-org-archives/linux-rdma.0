From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: trivial fix of spelling mistake on "argument"
Date: Fri, 13 May 2016 15:34:56 -0400
Message-ID: <712fbfbf-dce1-f5a2-380a-fa2843813f7b@redhat.com>
References: <1461612410-27604-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ha7MvkiF32QvWxrJintANnhr0vobKteLu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461612410-27604-1-git-send-email-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ha7MvkiF32QvWxrJintANnhr0vobKteLu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/25/2016 03:26 PM, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>=20
> fix spelling mistake, argumant -> argument
>=20
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> index f014eaf..b01ef6e 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1601,7 +1601,7 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp=
, struct ib_flow_attr *flow_att
>  	else if (ret =3D=3D -ENXIO)
>  		pr_err("Device managed flow steering is disabled. Fail to register n=
etwork rule.\n");
>  	else if (ret)
> -		pr_err("Invalid argumant. Fail to register network rule.\n");
> +		pr_err("Invalid argument. Fail to register network rule.\n");
> =20
>  	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
>  	return ret;
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Ha7MvkiF32QvWxrJintANnhr0vobKteLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNixgAAoJELgmozMOVy/dxs8P/R4I9UxoLoJkPZ1DmkNsVOEe
XzFhT2Wf2oEzveKgcnSm+eu5C5+NSWst1eGYJoCv9TEB33ORI6pqiukDx170xwlZ
dPDvKOySCEmHyj4rM+QgSdHvyTFkXM2rLyqznoF3SMV2T/jNPwiNtomlGZuR9CCB
bNThagYMbd1JLWrbmZr2DhhxxD5udr1BIWVVfCklnM9ULasiWcko9vnqacTAI8bc
wEcMEfmSD3+eOHPOeqXNIE2mtuKhMQH0dm/5+zL1p+zfxc4VK9n4kGM6ZePLA4Mp
37uDjFa1XUoQAd7BJptTqp1gvsfpTY+oh63cRVSMLyWerCsaTOYyKEQDpw8dEgRb
SnuI+/xiptn0YTp1TTNqlEJIb1CitAZBb826XdDoPjYMPbSFtSTclXN0xVLKZ+Cx
Z8gbemRbP5dxYPmZfwmcMPr/PSTV1roER1SgvH26XkmAkaVRhMddgGV11bFGtiHA
wjVOuQ9XATOOkEmBkpuTG8CnOtHvq07T57g/Q8N0cWUusAHGCQdhxAJ/VYSsLzEg
Lz1wFj8owEvBa06qyl+gFAAM37HU63z/CRYhl9V2Mv2aspDZFQDZtTrko4yPHmBw
c7a2lCGG8mtiZSS7AB3gxoDUMMIW6VAZtkscqkXxINZ6YAuCBMuL/dspFrbIc8Zj
e7PgDeubhQlMN4VhWvp/
=fSFJ
-----END PGP SIGNATURE-----

--Ha7MvkiF32QvWxrJintANnhr0vobKteLu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
