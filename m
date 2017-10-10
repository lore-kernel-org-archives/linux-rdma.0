From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe
 to use
Date: Tue, 10 Oct 2017 21:33:08 +0300
Message-ID: <20171010183308.GJ2106@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-41-bart.vanassche@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3442AAD2@fmsmsx120.amr.corp.intel.com>
 <1507648081.2815.5.camel@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3442ADF5@fmsmsx120.amr.corp.intel.com>
 <1507658390.2815.48.camel@wdc.com>
 <20171010180809.GI2106@mtr-leonro.local>
 <1507659918.2815.50.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fKov5AqTsvseSZ0Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507659918.2815.50.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--fKov5AqTsvseSZ0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 06:25:19PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 21:08 +0300, Leon Romanovsky wrote:
> > Does it mean that you can get rid of eep_st_masks and QIB_EEP_LOG_CNT too?
>
> I think so. Here we go ...

Thanks

>
>
> Subject: [PATCH] IB/qib: Remove remaining code related to writing the EEPROM
>
> Due to removal of the EEPROM writing code, the qib_inc_eeprom_err()
> macro became a no-op. Remove the code that calls it. Since that
> change removes all code that reads the eep_st_masks array, also
> remove the code that updates that array and the array itself.
>
> References: commit 18c0b82a3e45 (" IB/qib: Do not write EEPROM")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib.h         | 18 ------------------
>  drivers/infiniband/hw/qib/qib_iba6120.c | 25 -------------------------
>  drivers/infiniband/hw/qib/qib_iba7220.c | 20 --------------------
>  drivers/infiniband/hw/qib/qib_iba7322.c |  6 +-----
>  4 files changed, 1 insertion(+), 68 deletions(-)
>
> diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
> index 1167a9c1776b..689f5d001892 100644
> --- a/drivers/infiniband/hw/qib/qib.h
> +++ b/drivers/infiniband/hw/qib/qib.h
> @@ -101,18 +101,6 @@ extern const struct pci_error_handlers qib_pci_err_handler;
>   */
>  #define QIB_TRAFFIC_ACTIVE_THRESHOLD (2000)
>
> -/*
> - * Struct used to indicate which errors are logged in each of the
> - * error-counters that are logged to EEPROM. A counter is incremented
> - * _once_ (saturating at 255) for each event with any bits set in
> - * the error or hwerror register masks below.
> - */
> -#define QIB_EEP_LOG_CNT (4)
> -struct qib_eep_log_mask {
> -	u64 errs_to_log;
> -	u64 hwerrs_to_log;
> -};
> -
>  /*
>   * Below contains all data related to a single context (formerly called port).
>   */
> @@ -1079,11 +1067,6 @@ struct qib_devdata {
>  	/* control high-level access to EEPROM */
>  	struct mutex eep_lock;
>  	uint64_t traffic_wds;
> -	/*
> -	 * masks for which bits of errs, hwerrs that cause
> -	 * each of the counters to increment.
> -	 */
> -	struct qib_eep_log_mask eep_st_masks[QIB_EEP_LOG_CNT];
>  	struct qib_diag_client *diag_client;
>  	spinlock_t qib_diag_trans_lock; /* protect diag observer ops */
>  	struct diag_observer_list_elt *diag_observer_list;
> @@ -1297,7 +1280,6 @@ int qib_twsi_blk_rd(struct qib_devdata *dd, int dev, int addr, void *buffer,
>  int qib_twsi_blk_wr(struct qib_devdata *dd, int dev, int addr,
>  		    const void *buffer, int len);
>  void qib_get_eeprom_info(struct qib_devdata *);
> -#define qib_inc_eeprom_err(dd, eidx, incr)
>  void qib_dump_lookup_output_queue(struct qib_devdata *);
>  void qib_force_pio_avail_update(struct qib_devdata *);
>  void qib_clear_symerror_on_linkup(unsigned long opaque);
> diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
> index c4a4c57e0f0a..3c5adfa104a0 100644
> --- a/drivers/infiniband/hw/qib/qib_iba6120.c
> +++ b/drivers/infiniband/hw/qib/qib_iba6120.c
> @@ -748,7 +748,6 @@ static void qib_handle_6120_hwerrors(struct qib_devdata *dd, char *msg,
>  	u32 bits, ctrl;
>  	int isfatal = 0;
>  	char *bitsmsg;
> -	int log_idx;
>
>  	hwerrs = qib_read_kreg64(dd, kr_hwerrstatus);
>  	if (!hwerrs)
> @@ -770,11 +769,6 @@ static void qib_handle_6120_hwerrors(struct qib_devdata *dd, char *msg,
>
>  	hwerrs &= dd->cspec->hwerrmask;
>
> -	/* We log some errors to EEPROM, check if we have any of those. */
> -	for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -		if (hwerrs & dd->eep_st_masks[log_idx].hwerrs_to_log)
> -			qib_inc_eeprom_err(dd, log_idx, 1);
> -
>  	/*
>  	 * Make sure we get this much out, unless told to be quiet,
>  	 * or it's occurred within the last 5 seconds.
> @@ -1004,7 +998,6 @@ static void handle_6120_errors(struct qib_devdata *dd, u64 errs)
>  	char *msg;
>  	u64 ignore_this_time = 0;
>  	u64 iserr = 0;
> -	int log_idx;
>  	struct qib_pportdata *ppd = dd->pport;
>  	u64 mask;
>
> @@ -1015,10 +1008,6 @@ static void handle_6120_errors(struct qib_devdata *dd, u64 errs)
>  	/* do these first, they are most important */
>  	if (errs & ERR_MASK(HardwareErr))
>  		qib_handle_6120_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
> -	else
> -		for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
> -				qib_inc_eeprom_err(dd, log_idx, 1);
>
>  	if (errs & ~IB_E_BITSEXTANT)
>  		qib_dev_err(dd,
> @@ -3227,20 +3216,6 @@ static int init_6120_variables(struct qib_devdata *dd)
>  	if (qib_unordered_wc())
>  		dd->flags |= QIB_PIO_FLUSH_WC;
>
> -	/*
> -	 * EEPROM error log 0 is TXE Parity errors. 1 is RXE Parity.
> -	 * 2 is Some Misc, 3 is reserved for future.
> -	 */
> -	dd->eep_st_masks[0].hwerrs_to_log = HWE_MASK(TXEMemParityErr);
> -
> -	/* Ignore errors in PIO/PBC on systems with unordered write-combining */
> -	if (qib_unordered_wc())
> -		dd->eep_st_masks[0].hwerrs_to_log &= ~TXE_PIO_PARITY;
> -
> -	dd->eep_st_masks[1].hwerrs_to_log = HWE_MASK(RXEMemParityErr);
> -
> -	dd->eep_st_masks[2].errs_to_log = ERR_MASK(ResetNegated);
> -
>  	ret = qib_init_pportdata(ppd, dd, 0, 1);
>  	if (ret)
>  		goto bail;
> diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
> index 78ce79be4120..ceb2259a5efb 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7220.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7220.c
> @@ -1094,7 +1094,6 @@ static void handle_7220_errors(struct qib_devdata *dd, u64 errs)
>  	char *msg;
>  	u64 ignore_this_time = 0;
>  	u64 iserr = 0;
> -	int log_idx;
>  	struct qib_pportdata *ppd = dd->pport;
>  	u64 mask;
>
> @@ -1105,10 +1104,6 @@ static void handle_7220_errors(struct qib_devdata *dd, u64 errs)
>  	/* do these first, they are most important */
>  	if (errs & ERR_MASK(HardwareErr))
>  		qib_7220_handle_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
> -	else
> -		for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
> -				qib_inc_eeprom_err(dd, log_idx, 1);
>
>  	if (errs & QLOGIC_IB_E_SDMAERRS)
>  		sdma_7220_errors(ppd, errs);
> @@ -1302,7 +1297,6 @@ static void qib_7220_handle_hwerrors(struct qib_devdata *dd, char *msg,
>  	u32 bits, ctrl;
>  	int isfatal = 0;
>  	char *bitsmsg;
> -	int log_idx;
>
>  	hwerrs = qib_read_kreg64(dd, kr_hwerrstatus);
>  	if (!hwerrs)
> @@ -1326,10 +1320,6 @@ static void qib_7220_handle_hwerrors(struct qib_devdata *dd, char *msg,
>
>  	hwerrs &= dd->cspec->hwerrmask;
>
> -	/* We log some errors to EEPROM, check if we have any of those. */
> -	for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -		if (hwerrs & dd->eep_st_masks[log_idx].hwerrs_to_log)
> -			qib_inc_eeprom_err(dd, log_idx, 1);
>  	if (hwerrs & ~(TXEMEMPARITYERR_PIOBUF | TXEMEMPARITYERR_PIOPBC |
>  		       RXE_PARITY))
>  		qib_devinfo(dd->pcidev,
> @@ -4016,16 +4006,6 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
>  	dd->flags |= qib_special_trigger ?
>  		QIB_USE_SPCL_TRIG : QIB_HAS_SEND_DMA;
>
> -	/*
> -	 * EEPROM error log 0 is TXE Parity errors. 1 is RXE Parity.
> -	 * 2 is Some Misc, 3 is reserved for future.
> -	 */
> -	dd->eep_st_masks[0].hwerrs_to_log = HWE_MASK(TXEMemParityErr);
> -
> -	dd->eep_st_masks[1].hwerrs_to_log = HWE_MASK(RXEMemParityErr);
> -
> -	dd->eep_st_masks[2].errs_to_log = ERR_MASK(ResetNegated);
> -
>  	init_waitqueue_head(&cpspec->autoneg_wait);
>  	INIT_DELAYED_WORK(&cpspec->autoneg_work, autoneg_7220_work);
>
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
> index 4d02cffe4e03..77217fae9c06 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -1644,7 +1644,6 @@ static noinline void handle_7322_errors(struct qib_devdata *dd)
>  	u64 iserr = 0;
>  	u64 errs;
>  	u64 mask;
> -	int log_idx;
>
>  	qib_stats.sps_errints++;
>  	errs = qib_read_kreg64(dd, kr_errstatus);
> @@ -1662,10 +1661,7 @@ static noinline void handle_7322_errors(struct qib_devdata *dd)
>  	if (errs & QIB_E_HARDWARE) {
>  		*msg = '\0';
>  		qib_7322_handle_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
> -	} else
> -		for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
> -			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
> -				qib_inc_eeprom_err(dd, log_idx, 1);
> +	}
>
>  	if (errs & QIB_E_SPKTERRS) {
>  		qib_disarm_7322_senderrbufs(dd->pport);
> --
> 2.14.2

--fKov5AqTsvseSZ0Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlndEmQACgkQ5GN7iDZy
WKcLkw/9Fl7r4CIt5Uiblk2yt17i4fyib9zDrUl+Vh5s/I9KSOVKQJnbs37igl/T
hmbUbWY/uEjUKYnyfY8nxWnFnoXiohQAjNyYJAZo65WyJvAP7wiqUBmMGWkXcmF1
xl4SWDpCNInJnXrbYVnGDOzvDUSaPdWD08ZwmYuOTOu30oQzFxJnPC173/dPuKcj
XdBF5WLy2B0s4dZhL7QliDnolHojksBPnS9SavfU8547KPCul3x/XB+f3Y6a4iOO
lHI7Vyf0ZyZE5gMDz9QAml3xlkbV+8A97trMZ6YLrCHp6kZTNbarPw6I4W1z7qBx
1Avcb9wKi1nyIdFc7C5sqL/FAID5vJZcVYZZrN5CKo9ZtRZ+TTLTQ+egaf1y6OeD
9MG5aSdUA/VtWH8x8O4pP3AVv20in6pL0TQ7kGhezGlqpGxVETsSRPz8k5RrykxC
dU7ILm/wb+QvpRFDnotB80rKUDo8nXkFxEjvqpMBM9w5KAbqDL2khs7V4+9R2ypv
/7uZgq2BX/A6kf2p2UNUlf1SZAyUKd3eBR7jE/ckqSxLI42GSnCg5fwnDaUp1Mna
CtLekfsquTauJwDxFm55ikfOYlZLQxXurVxzN1Ey8S6KJw1llY/Gh6qiM5prodQR
ILlwmfZTee0v7loO691Byd9fATKO1LwF6RkQaURMKidTJ47n36A=
=JxKF
-----END PGP SIGNATURE-----

--fKov5AqTsvseSZ0Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
