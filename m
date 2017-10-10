From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe
 to use
Date: Tue, 10 Oct 2017 21:08:09 +0300
Message-ID: <20171010180809.GI2106@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-41-bart.vanassche@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3442AAD2@fmsmsx120.amr.corp.intel.com>
 <1507648081.2815.5.camel@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3442ADF5@fmsmsx120.amr.corp.intel.com>
 <1507658390.2815.48.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FUFe+yI/t+r3nyH4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507658390.2815.48.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FUFe+yI/t+r3nyH4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10, 2017 at 05:59:51PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 15:36 +0000, Marciniszyn, Mike wrote:
> > Bart wrote:
> > > How about dropping this patch and replacing it with a patch that remo=
ves all
> > > uses of qib_inc_eeprom_err()?
> >
> > I'm fine with that too.
>
> How about the patch below?
>
> Thanks,
>
> Bart.
>
>
> Subject: [PATCH] IB/qib: Remove the qib_inc_eeprom_err() macro
>
> Since the body of the qib_inc_eeprom_err() macro is empty, remove
> the invocations of this macro.
>
> References: commit 18c0b82a3e45 (" IB/qib: Do not write EEPROM")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib.h         |  1 -
>  drivers/infiniband/hw/qib/qib_iba6120.c | 11 -----------
>  drivers/infiniband/hw/qib/qib_iba7220.c | 10 ----------
>  drivers/infiniband/hw/qib/qib_iba7322.c |  6 +-----
>  4 files changed, 1 insertion(+), 27 deletions(-)
>
> diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/=
qib.h
> index 1167a9c1776b..1869fce0ba00 100644
> --- a/drivers/infiniband/hw/qib/qib.h
> +++ b/drivers/infiniband/hw/qib/qib.h
> @@ -1297,7 +1297,6 @@ int qib_twsi_blk_rd(struct qib_devdata *dd, int dev=
, int addr, void *buffer,
>  int qib_twsi_blk_wr(struct qib_devdata *dd, int dev, int addr,
>  		    const void *buffer, int len);
>  void qib_get_eeprom_info(struct qib_devdata *);
> -#define qib_inc_eeprom_err(dd, eidx, incr)
>  void qib_dump_lookup_output_queue(struct qib_devdata *);
>  void qib_force_pio_avail_update(struct qib_devdata *);
>  void qib_clear_symerror_on_linkup(unsigned long opaque);
> diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband=
/hw/qib/qib_iba6120.c
> index c4a4c57e0f0a..e0b52bab6f34 100644
> --- a/drivers/infiniband/hw/qib/qib_iba6120.c
> +++ b/drivers/infiniband/hw/qib/qib_iba6120.c
> @@ -748,7 +748,6 @@ static void qib_handle_6120_hwerrors(struct qib_devda=
ta *dd, char *msg,
>  	u32 bits, ctrl;
>  	int isfatal =3D 0;
>  	char *bitsmsg;
> -	int log_idx;
>
>  	hwerrs =3D qib_read_kreg64(dd, kr_hwerrstatus);
>  	if (!hwerrs)
> @@ -770,11 +769,6 @@ static void qib_handle_6120_hwerrors(struct qib_devd=
ata *dd, char *msg,
>
>  	hwerrs &=3D dd->cspec->hwerrmask;
>
> -	/* We log some errors to EEPROM, check if we have any of those. */
> -	for (log_idx =3D 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -		if (hwerrs & dd->eep_st_masks[log_idx].hwerrs_to_log)

Does it mean that you can get rid of eep_st_masks and QIB_EEP_LOG_CNT too?

> -			qib_inc_eeprom_err(dd, log_idx, 1);
> -
>  	/*
>  	 * Make sure we get this much out, unless told to be quiet,
>  	 * or it's occurred within the last 5 seconds.
> @@ -1004,7 +998,6 @@ static void handle_6120_errors(struct qib_devdata *d=
d, u64 errs)
>  	char *msg;
>  	u64 ignore_this_time =3D 0;
>  	u64 iserr =3D 0;
> -	int log_idx;
>  	struct qib_pportdata *ppd =3D dd->pport;
>  	u64 mask;
>
> @@ -1015,10 +1008,6 @@ static void handle_6120_errors(struct qib_devdata =
*dd, u64 errs)
>  	/* do these first, they are most important */
>  	if (errs & ERR_MASK(HardwareErr))
>  		qib_handle_6120_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
> -	else
> -		for (log_idx =3D 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
> -				qib_inc_eeprom_err(dd, log_idx, 1);
>
>  	if (errs & ~IB_E_BITSEXTANT)
>  		qib_dev_err(dd,
> diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband=
/hw/qib/qib_iba7220.c
> index 78ce79be4120..75f2cfd0d272 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7220.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7220.c
> @@ -1094,7 +1094,6 @@ static void handle_7220_errors(struct qib_devdata *=
dd, u64 errs)
>  	char *msg;
>  	u64 ignore_this_time =3D 0;
>  	u64 iserr =3D 0;
> -	int log_idx;
>  	struct qib_pportdata *ppd =3D dd->pport;
>  	u64 mask;
>
> @@ -1105,10 +1104,6 @@ static void handle_7220_errors(struct qib_devdata =
*dd, u64 errs)
>  	/* do these first, they are most important */
>  	if (errs & ERR_MASK(HardwareErr))
>  		qib_7220_handle_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
> -	else
> -		for (log_idx =3D 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
> -				qib_inc_eeprom_err(dd, log_idx, 1);
>
>  	if (errs & QLOGIC_IB_E_SDMAERRS)
>  		sdma_7220_errors(ppd, errs);
> @@ -1302,7 +1297,6 @@ static void qib_7220_handle_hwerrors(struct qib_dev=
data *dd, char *msg,
>  	u32 bits, ctrl;
>  	int isfatal =3D 0;
>  	char *bitsmsg;
> -	int log_idx;
>
>  	hwerrs =3D qib_read_kreg64(dd, kr_hwerrstatus);
>  	if (!hwerrs)
> @@ -1326,10 +1320,6 @@ static void qib_7220_handle_hwerrors(struct qib_de=
vdata *dd, char *msg,
>
>  	hwerrs &=3D dd->cspec->hwerrmask;
>
> -	/* We log some errors to EEPROM, check if we have any of those. */
> -	for (log_idx =3D 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -		if (hwerrs & dd->eep_st_masks[log_idx].hwerrs_to_log)
> -			qib_inc_eeprom_err(dd, log_idx, 1);
>  	if (hwerrs & ~(TXEMEMPARITYERR_PIOBUF | TXEMEMPARITYERR_PIOPBC |
>  		       RXE_PARITY))
>  		qib_devinfo(dd->pcidev,
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband=
/hw/qib/qib_iba7322.c
> index 4d02cffe4e03..77217fae9c06 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -1644,7 +1644,6 @@ static noinline void handle_7322_errors(struct qib_=
devdata *dd)
>  	u64 iserr =3D 0;
>  	u64 errs;
>  	u64 mask;
> -	int log_idx;
>
>  	qib_stats.sps_errints++;
>  	errs =3D qib_read_kreg64(dd, kr_errstatus);
> @@ -1662,10 +1661,7 @@ static noinline void handle_7322_errors(struct qib=
_devdata *dd)
>  	if (errs & QIB_E_HARDWARE) {
>  		*msg =3D '\0';
>  		qib_7322_handle_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
> -	} else
> -		for (log_idx =3D 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
> -				qib_inc_eeprom_err(dd, log_idx, 1);
> +	}
>
>  	if (errs & QIB_E_SPKTERRS) {
>  		qib_disarm_7322_senderrbufs(dd->pport);
> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{??=D9=9A?{ay?=1D=CA=87=DA=
=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2j"?=
?!

--FUFe+yI/t+r3nyH4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlndDIkACgkQ5GN7iDZy
WKebghAAsW9GCYQV2oAc8joIvY5NDHpGRu/pfGo+b+Ts4tpqJpBDFLkpbF3CXZ3o
e1hG05InR4pyiGHu55nxWIIh77jGGfRt4sgZYfh/Gs6dWtvrv+ik+UlOcXJjwRuI
3ISbKSzBVX66cR5F7x7Y9a2rueC8IEXv5G0I8zkgXGIyNc946k+zY8L64/ryXXWz
y71AhNhW0mxm8jB8ADnhGmCgUYySyg3vpgVQ7iUQ9m5moY6bqUVsHSvBSvLF5ZWt
cE3eDTMaQy43jJTJAdNp9HrMyRtogtZI4V4AaR+Bsi/+jhmEiwiJd0PGZ8MsD+SY
aGBnfRmZtk0Hb6VDs2pVG0/khHt5+JXJuMENMtyptFiKDa7iuIA5k/QZAX+Vl2QV
YfLcyo5X02WQySjkJsE2MdfO2FHzX6g26CzYVDJIVFbnBY+BizYmTgClttUgP3W/
drRBq8gBFuBFziNwJJUaZfyheTxbm0anShhVA+XXDb4aCp2zUWi/z1SXvY1LGAjF
NkUwL765cOAYoy5nlEes5innkZI9KxdiDPw58vLPQLRYUp4R/Uinbmx0Jjubhl5+
KjBImREEUQ/cFrAc9nIGZldKQLWnxDXKXKNVQvtxV/0z+mocsGRLeIPKJGou7KzL
RR068vGxy3sZ8kFdt1jpYC1yFrqivTUVNiIU+9waljj9x4n/2l8=
=Lp6z
-----END PGP SIGNATURE-----

--FUFe+yI/t+r3nyH4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
