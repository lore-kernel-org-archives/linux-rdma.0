From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libcxgb4: fixes for debug build
Date: Thu, 15 Dec 2016 16:27:46 -0500
Message-ID: <dfa27f80-04c0-f67d-15b7-61376f9af779@redhat.com>
References: <20161215212201.AAA3BE08C3@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ertScuM2820kHP9b9fsUD5vXeEigfjcVS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161215212201.AAA3BE08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ertScuM2820kHP9b9fsUD5vXeEigfjcVS
Content-Type: multipart/mixed; boundary="mXPUmEeFbP9X0DbSvnnHF0P2OwmBq46sm";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <dfa27f80-04c0-f67d-15b7-61376f9af779-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libcxgb4: fixes for debug build
References: <20161215212201.AAA3BE08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
In-Reply-To: <20161215212201.AAA3BE08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>

--mXPUmEeFbP9X0DbSvnnHF0P2OwmBq46sm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/15/2016 4:19 PM, Steve Wise wrote:
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  providers/cxgb4/dev.c      | 14 +++++++-------
>  providers/cxgb4/libcxgb4.h |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
> index 69b04ac..3d903e8 100644
> --- a/providers/cxgb4/dev.c
> +++ b/providers/cxgb4/dev.c
> @@ -239,7 +239,7 @@ static void dump_cq(struct c4iw_cq *chp)
>                  chp->cq.cqid, chp->cq.queue, chp->cq.cidx,
>  	 	chp->cq.sw_queue, chp->cq.sw_cidx, chp->cq.sw_pidx, chp->cq.sw_in_u=
se,
>                  chp->cq.size, chp->cq.error, chp->cq.gen, chp->cq.cidx=
_inc, be64_to_cpu(chp->cq.bits_type_ts),
> -		t4_cq_notempty(&chp->cq) || (chp->iq ? t4_iq_notempty(chp->iq) : 0))=
;
> +		t4_cq_notempty(&chp->cq));
> =20
>  	for (i=3D0; i < chp->cq.size; i++) {
>  		u64 *p =3D (u64 *)(chp->cq.queue + i);
> @@ -310,10 +310,10 @@ static void dump_qp(struct c4iw_qp *qhp)
>  			swsqe->opcode,
>  			swsqe->complete,
>  			swsqe->signaled,
> -			cpu_to_be64(swsqe->cqe.u.flits[0]),
> -			cpu_to_be64(swsqe->cqe.u.flits[1]),
> -			cpu_to_be64((u64)swsqe->cqe.reserved),
> -			cpu_to_be64(swsqe->cqe.bits_type_ts));
> +			cpu_to_be64(((uint64_t *)&swsqe->cqe)[0]),
> +			cpu_to_be64(((uint64_t *)&swsqe->cqe)[1]),
> +			cpu_to_be64(((uint64_t *)&swsqe->cqe)[2]),
> +			cpu_to_be64(((uint64_t *)&swsqe->cqe)[3]));
>  		if (++cidx =3D=3D qhp->wq.sq.size)
>  			cidx =3D 0;
>  	}
> @@ -359,7 +359,7 @@ static void dump_qp(struct c4iw_qp *qhp)
>  	}
>  }
> =20
> -void dump_state()
> +void dump_state(void)
>  {
>  	struct c4iw_dev *dev;
>  	int i;
> @@ -462,7 +462,7 @@ found:
>  	}
> =20
>  	PDBG("%s found vendor %d device %d type %d\n",
> -	     __FUNCTION__, vendor, device, hca_table[i].chip_version);
> +	     __FUNCTION__, vendor, device, CHELSIO_CHIP_VERSION(hca_table[i].=
device >> 8));
> =20
>  	dev =3D calloc(1, sizeof *dev);
>  	if (!dev) {
> diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
> index 9a4bc98..3b75661 100644
> --- a/providers/cxgb4/libcxgb4.h
> +++ b/providers/cxgb4/libcxgb4.h
> @@ -260,7 +260,7 @@ extern struct c4iw_stats c4iw_stats;
>  #endif
> =20
>  #ifdef STALL_DETECTION
> -void dump_state();
> +void dump_state(void);
>  extern int stall_to;
>  #endif
> =20
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--mXPUmEeFbP9X0DbSvnnHF0P2OwmBq46sm--

--ertScuM2820kHP9b9fsUD5vXeEigfjcVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUwrSAAoJELgmozMOVy/dGj0P/2k//p/lMah5xE9lnUP9Gnq/
yH3Fyej/8vMEagrLVTmMjNGx479IRJ+NZAvVk10aMQQRaVDYInRlw6WJ4JX7TCPB
fPGzN/cxj/mkaPmZxUO8SANGyNehVi54WTDb/2T8S/IdCHH6FfzuWhrfe6oMIqv9
aeTlZ+IL10nVMeCl1AlfHeQ/v6/Lll29NFZmQL7VyhvhLi0uGXdhmDe15tgG5/ge
rkQYIjD/h0o9giRtVAfNZadFWCtdo1VM0zjYfh3n3zmd3u3434zptN50dYa7b9Jm
k7q5MyPB/9eT+Puyvtu/d5Bnevhx1LoWPbWerIFQILWXyRFJs/V05P0Epei0F4m6
ehUu7qc/dAQMOklGIgeDYfnoa1ebJ7d9kas/2THXp2NjDrC8WN43uv4nGbVIU4XL
ITupgwhf6TNslM0rLZKKv7y8iq7YFDwIK0U4k1GmYx4IQXuyKaC2WibY4K1nb7li
1soUA3jcAJLcMw/nNcdQN/8e53me98XSyyAv2cLqDTHe7yxjTlO95ZO2Py0OGc6b
r6OrQnMkcwf6S9OpC5fXaumnSQs06TKersNebIiXjaz71bmsa5Gk1pHVwyJ3yfOM
/4eQEfZ+RzBIXLs6M2NijFzIoXvi9dNyfutebTyqdVF9jISqDracE8rxL80GrmPF
KtP3FCTkdbxGZLdcfC1l
=KYhS
-----END PGP SIGNATURE-----

--ertScuM2820kHP9b9fsUD5vXeEigfjcVS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
