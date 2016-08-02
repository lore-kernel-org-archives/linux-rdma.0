From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Delete an unnecessary check before the
 function call "sc_return_credits"
Date: Tue, 02 Aug 2016 15:38:41 -0400
Message-ID: <1470166721.18081.39.camel@redhat.com>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net>
	 <cd93853f-c315-eceb-347d-3bbb5ac9fb82@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-km/OJ+e38SsI1Q6SnoWa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd93853f-c315-eceb-347d-3bbb5ac9fb82-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-km/OJ+e38SsI1Q6SnoWa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-07-23 at 09:42 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sat, 23 Jul 2016 08:30:52 +0200
>=20
> The sc_return_credits() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call is not
> needed.
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/hw/hfi1/file_ops.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c
> b/drivers/infiniband/hw/hfi1/file_ops.c
> index c702a00..32c19fa 100644
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -228,7 +228,7 @@ static long hfi1_file_ioctl(struct file *fp,
> unsigned int cmd,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0sizeof(struct hfi1_base_info));
> =C2=A0		break;
> =C2=A0	case HFI1_IOCTL_CREDIT_UPD:
> -		if (uctxt && uctxt->sc)
> +		if (uctxt)
> =C2=A0			sc_return_credits(uctxt->sc);
> =C2=A0		break;
> =C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-km/OJ+e38SsI1Q6SnoWa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPbBAAoJELgmozMOVy/dPg4QALDYShPk6EcWTV3uf49HON3L
ZBjnOsz46PMoGHXbeFqurwqHql3H4IWVSE2En5k1ovdsDhMqXgE7yj7wqr4tRhEA
4czCjUOzDKcBFyOBiSIxbfSpprNMhxMt1Zu4ZS50RhvYdPzOoLXd+yFfB1G5SYpn
72kGDQOcnmdV+HsSQMfFZrDipNgj+bqWjmv8NmRxkBHApnqVyebdYEIjmNAdRa4g
knxvLIdROPUWtFdh6v5iJ/w7oTSibpYQ0WeTrLfbajafeLDNFhIpfGSZ6vbK5fK0
l4+03pCIvh/6K/7EZhHyfqs7HvltkPMW3/piIEpkKrUnWqdzHmNRp4nN9k0wEd8K
Qa/n3g6V1qmKN0b5LvMWNgNZhoI1lJma8TD2JrIosX9PZ0v5bDoJAyj0gE9ipcoX
hk2utB/BjsCxgByQOxWm0rhqhX1Tx8mf0aLLsLziSaclzmcGpmeCczxuJyqgyVuz
ismrxppe3ZCaQ+9TpBcFILSp+Dx9RirfeRLAuvWwrdPcGNu5tDGr/GQEonpjV22m
OpGUhbckgCi3vzyGYnRXlb56yYSUys4CnI38TeLZJbl8z8sWYQZeR7cbEWpUNXvR
dMegTs00WQDOoPoeYubeSshPTWKyjIjbnjNBKJXsJYYeF5bJq1vyqu3EjT7W9xRd
6335ma5TMiWSUMmVgFEK
=73D9
-----END PGP SIGNATURE-----

--=-km/OJ+e38SsI1Q6SnoWa--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
