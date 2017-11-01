From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] rdma/ib: Add trace point macros to display
 human-readable values
Date: Wed, 1 Nov 2017 08:27:43 +0200
Message-ID: <20171101062743.GO16127@mtr-leonro.local>
References: <20171030215809.31286.46685.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FgDZqiUnJxahzcFD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171030215809.31286.46685.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FgDZqiUnJxahzcFD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2017 at 06:01:23PM -0400, Chuck Lever wrote:
> These can be shared with all kernel ULPs, and more can easily be
> added as needed.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/trace/events/rdma.h |  128 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 128 insertions(+)
>  create mode 100644 include/trace/events/rdma.h
>
> Hi-
>
> I'm putting together a series of patches for v4.16 (or later) that
> add static ftrace trace points to the RPC-over-RDMA client imple-
> mentation. As part of that effort, I've constructed some trace point
> helpers that might be useful for other kernel ULPs.
>
> So far this patch adds just helpers that xprtrdma needs. It is not
> complete, but additional helpers can be introduced as they are
> needed.
>
> I'd like to hear comments about these, or please let me know if
> such helpers already exist and where xprtrdma can find them.

Bart, Steve

You attended the MS track, and for the rest of us, the quote below
sounds a little bit cryptic. Does the quote below mean that Chuck's
proposal is no-go?

=46rom LWN.net "Another attempt to address the tracepoint ABI problem" [1]

"The solution that was arrived at for now, as related by Torvalds,
 is to hold off on adding explicit tracepoints to the kernel. Instead,
 support will be added to make it easy for an application to attach a
 BPF script to any function in the kernel, with access to that function's
 arguments."

[1] https://lwn.net/Articles/737530/

Thanks

>
> Thanks!
>
>
> diff --git a/include/trace/events/rdma.h b/include/trace/events/rdma.h
> new file mode 100644
> index 0000000..9d02fbe
> --- /dev/null
> +++ b/include/trace/events/rdma.h
> @@ -0,0 +1,128 @@
> +/*
> + * Copyright (c) 2017 Oracle.  All rights reserved.
> + */
> +
> +/*
> + * enum ib_event_type, from include/rdma/ib_verbs.h
> + */
> +
> +#define IB_EVENT_LIST				\
> +	ib_event(CQ_ERR)			\
> +	ib_event(QP_FATAL)			\
> +	ib_event(QP_REQ_ERR)			\
> +	ib_event(QP_ACCESS_ERR)			\
> +	ib_event(COMM_EST)			\
> +	ib_event(SQ_DRAINED)			\
> +	ib_event(PATH_MIG)			\
> +	ib_event(PATH_MIG_ERR)			\
> +	ib_event(DEVICE_FATAL)			\
> +	ib_event(PORT_ACTIVE)			\
> +	ib_event(PORT_ERR)			\
> +	ib_event(LID_CHANGE)			\
> +	ib_event(PKEY_CHANGE)			\
> +	ib_event(SM_CHANGE)			\
> +	ib_event(SRQ_ERR)			\
> +	ib_event(SRQ_LIMIT_REACHED)		\
> +	ib_event(QP_LAST_WQE_REACHED)		\
> +	ib_event(CLIENT_REREGISTER)		\
> +	ib_event(GID_CHANGE)			\
> +	ib_event_end(WQ_FATAL)
> +
> +#undef ib_event
> +#undef ib_event_end
> +
> +#define ib_event(x)		TRACE_DEFINE_ENUM(IB_EVENT_##x);
> +#define ib_event_end(x)		TRACE_DEFINE_ENUM(IB_EVENT_##x);
> +
> +IB_EVENT_LIST
> +
> +#undef ib_event
> +#undef ib_event_end
> +
> +#define ib_event(x)		{ IB_EVENT_##x, #x },
> +#define ib_event_end(x)		{ IB_EVENT_##x, #x }
> +
> +#define rdma_show_ib_event(x) \
> +		__print_symbolic(x, IB_EVENT_LIST)
> +
> +/*
> + * enum ib_wc_status type, from include/rdma/ib_verbs.h
> + */
> +#define IB_WC_STATUS_LIST			\
> +	ib_wc_status(SUCCESS)			\
> +	ib_wc_status(LOC_LEN_ERR)		\
> +	ib_wc_status(LOC_QP_OP_ERR)		\
> +	ib_wc_status(LOC_EEC_OP_ERR)		\
> +	ib_wc_status(LOC_PROT_ERR)		\
> +	ib_wc_status(WR_FLUSH_ERR)		\
> +	ib_wc_status(MW_BIND_ERR)		\
> +	ib_wc_status(BAD_RESP_ERR)		\
> +	ib_wc_status(LOC_ACCESS_ERR)		\
> +	ib_wc_status(REM_INV_REQ_ERR)		\
> +	ib_wc_status(REM_ACCESS_ERR)		\
> +	ib_wc_status(REM_OP_ERR)		\
> +	ib_wc_status(RETRY_EXC_ERR)		\
> +	ib_wc_status(RNR_RETRY_EXC_ERR)		\
> +	ib_wc_status(LOC_RDD_VIOL_ERR)		\
> +	ib_wc_status(REM_INV_RD_REQ_ERR)	\
> +	ib_wc_status(REM_ABORT_ERR)		\
> +	ib_wc_status(INV_EECN_ERR)		\
> +	ib_wc_status(INV_EEC_STATE_ERR)		\
> +	ib_wc_status(FATAL_ERR)			\
> +	ib_wc_status(RESP_TIMEOUT_ERR)		\
> +	ib_wc_status_end(GENERAL_ERR)
> +
> +#undef ib_wc_status
> +#undef ib_wc_status_end
> +
> +#define ib_wc_status(x)		TRACE_DEFINE_ENUM(IB_WC_##x);
> +#define ib_wc_status_end(x)	TRACE_DEFINE_ENUM(IB_WC_##x);
> +
> +IB_WC_STATUS_LIST
> +
> +#undef ib_wc_status
> +#undef ib_wc_status_end
> +
> +#define ib_wc_status(x)		{ IB_WC_##x, #x },
> +#define ib_wc_status_end(x)	{ IB_WC_##x, #x }
> +
> +#define rdma_show_wc_status(x) \
> +		__print_symbolic(x, IB_WC_STATUS_LIST)
> +
> +/*
> + * enum rdma_cm_event_type, from include/rdma/rdma_cm.h
> + */
> +#define RDMA_CM_EVENT_LIST			\
> +	rdma_cm_event(ADDR_RESOLVED)		\
> +	rdma_cm_event(ADDR_ERROR)		\
> +	rdma_cm_event(ROUTE_RESOLVED)		\
> +	rdma_cm_event(ROUTE_ERROR)		\
> +	rdma_cm_event(CONNECT_REQUEST)		\
> +	rdma_cm_event(CONNECT_RESPONSE)		\
> +	rdma_cm_event(CONNECT_ERROR)		\
> +	rdma_cm_event(UNREACHABLE)		\
> +	rdma_cm_event(REJECTED)			\
> +	rdma_cm_event(ESTABLISHED)		\
> +	rdma_cm_event(DISCONNECTED)		\
> +	rdma_cm_event(DEVICE_REMOVAL)		\
> +	rdma_cm_event(MULTICAST_JOIN)		\
> +	rdma_cm_event(MULTICAST_ERROR)		\
> +	rdma_cm_event(ADDR_CHANGE)		\
> +	rdma_cm_event_end(TIMEWAIT_EXIT)
> +
> +#undef rdma_cm_event
> +#undef rdma_cm_event_end
> +
> +#define rdma_cm_event(x)	TRACE_DEFINE_ENUM(RDMA_CM_EVENT_##x);
> +#define rdma_cm_event_end(x)	TRACE_DEFINE_ENUM(RDMA_CM_EVENT_##x);
> +
> +RDMA_CM_EVENT_LIST
> +
> +#undef rdma_cm_event
> +#undef rdma_cm_event_end
> +
> +#define rdma_cm_event(x)	{ RDMA_CM_EVENT_##x, #x },
> +#define rdma_cm_event_end(x)	{ RDMA_CM_EVENT_##x, #x }
> +
> +#define rdma_show_cm_event(x) \
> +		__print_symbolic(x, RDMA_CM_EVENT_LIST)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--FgDZqiUnJxahzcFD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln5aV4ACgkQ5GN7iDZy
WKdmvg//WNouEKIfdiVnNByufGCvn05LrJmjvZ5mMpJI2CyWQLozzUqJ7fGRuhDk
rGqjTHk2uiBAjNybUbd1uxRyr3mRWGD+k6nu7Xfsh7Nsi+akZQx8Pldeg1VJgdd1
Hdtc5q6xvo6sWGDOeYIBTyMs5bAWBKmzWGxDE/w3SDYTiA4JsjlYkKaNJEAjACfo
LVwLVNDAfplJOrpq0BoKxm0tcfXYxhoGIQjl6/kQ8jVM+8xBtszllJmz5Znhlj9z
gO57fVU+BWRLMRtJQpZN5GQ9webB9QBUG88oz6b6e0HwVBc/EFJBh0dYXl/TRKsP
oOrz1s5YxfZQp+WgTiEJ+UdTcHnR2Q6L1WvnsGswnIGMgZFn+Bpu8duN4jhgV8iE
cPd2/uoUrpVsoZXIgap+o0oYOV4qBPCnP8hlerCiueN7FjyFu9AlH3Ertkl/K6c9
WhdqvqAspEewce+enmtP3uYvWNNigUgbDTz9wxLDpwU3bOQ5pBO+iL19iFALmbju
VHR+hhf+0XfnoScM6Im/6TDSdAUMmwfLeBwRPcL0Z+JoyT8CS62Mbq0D5bI1+RBr
wbQEc8GP4oLh/iHY7wOPfSzLDGsQ3MaGK5Gyn6A11v6sRFT11ka8+Tt4BFvQGWqh
yAuSgtaxZcECk/Hwo9BgsNOXMydhqtapYtUJsXlMqEJG1CO3jdE=
=ip7u
-----END PGP SIGNATURE-----

--FgDZqiUnJxahzcFD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
