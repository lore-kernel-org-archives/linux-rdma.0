From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: use RCU_INIT_POINTER() when NULLing.
Date: Mon, 2 May 2016 08:27:55 +0300
Message-ID: <20160502052755.GC10276@leon.nu>
References: <1462106131-9073-1-git-send-email-falakreyaz@gmail.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462106131-9073-1-git-send-email-falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 01, 2016 at 06:05:31PM +0530, Muhammad Falak R Wani wrote:
> It is safe to use RCU_INIT_POINTER() to NULL a pointer, instead of
> rcu_assign_pointer().
> This results in slightly smaller/faster code.
>=20
> Signed-off-by: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I'm fine with your commit message and don't need to resend, however
the statements like "smaller code" need to be supported by
=2E/scripts/bloat-o-meter and "faster code" by performance analysis.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/staging/rdma/hfi1/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1=
/init.c
> index cfcdc16..34e0f90 100644
> --- a/drivers/staging/rdma/hfi1/init.c
> +++ b/drivers/staging/rdma/hfi1/init.c
> @@ -1303,7 +1303,7 @@ static void cleanup_device_data(struct hfi1_devdata=
 *dd)
> =20
>  		spin_lock(&ppd->cc_state_lock);
>  		cc_state =3D get_cc_state(ppd);
> -		rcu_assign_pointer(ppd->cc_state, NULL);
> +		RCU_INIT_POINTER(ppd->cc_state, NULL);
>  		spin_unlock(&ppd->cc_state_lock);
> =20
>  		if (cc_state)
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXJuVbAAoJEORje4g2clinv+gP/Avy6Ojew6LJrAfIY7fr4MXo
uZakvIwjLfafxZStV+ahu7/WjGkjMmxv9HeUQL1qxxmHmtY7puxNPXivi3bK+Xp7
mIiGJ1zt2ED0MmsF4MOF1rzpgnllRqPEWHmrVsidPnLeWsHouxAmEgul9CcRNUAJ
/GUlm7AjDrq9K0Tr82fCRAdadbJApJu4j+94Ko5CfIvIThep6P5D3Mt8ur8XGjOg
UsK3C8GS8UB+oFt4Wb8pqddpvNpg5keIVlFDP+eAT+E3C8jSym39DhHpcEpgzElQ
3oaqUT6pb4qwHT8Ix6iwvlTQAfyff9STa3HrNFShRspEdjLThqhQKjFJx3876bAA
sTWdTBmW1v4jTX5S3f1Q4g49n5Llixnam5cK5Myhre40180KhEQa+OKUa+bweGPh
3yMeUQ5pxw0bzGTj7EOgOBGFLyBIwHMiVPMq22mkkWzns/lBGGPUbGltIyGRfGNs
g2TtgTyZkMbesK4K4YxktVWrNRSmR6KcLyYyGU+m7s9eIdR4KrzQO6jcR6yQqUVe
/fDpN6cCZJ3CfVcjEtfU2b7cBUnl0HVTFMTGoFAgYjtBVayarJqqODV/DrUoJQLR
foODT6B41FdNLvg3O4Pxxi/GXgEatkTqnU2LtX5XE4XNTw6u1eAHGzK/FtB5etxq
HN5dJmgMmfcGxDt1DVaB
=d9ax
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
