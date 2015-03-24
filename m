From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 10/16] xprtrdma: Add "open" memreg op
Date: Tue, 24 Mar 2015 11:29:51 -0400
Message-ID: <72FBAE8A-8117-40C6-9964-7855133AF64C@oracle.com>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212807.22783.61881.stgit@manet.1015granger.net> <EE7902D3F51F404C82415C4803930ACD5DC3A9FF@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC3A9FF-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mar 24, 2015, at 7:34 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> w=
rote:

>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
>> Sent: Saturday, March 14, 2015 2:58 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH v1 10/16] xprtrdma: Add "open" memreg op
>>=20
>> The open op determines the size of various transport data structures=
 based on
>> device capabilities and memory registration mode.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/fmr_ops.c      |   22 +++++++++++++
>> net/sunrpc/xprtrdma/frwr_ops.c     |   60
>> ++++++++++++++++++++++++++++++++++++
>> net/sunrpc/xprtrdma/physical_ops.c |   22 +++++++++++++
>> net/sunrpc/xprtrdma/verbs.c        |   54 ++------------------------=
------
>> net/sunrpc/xprtrdma/xprt_rdma.h    |    3 ++
>> 5 files changed, 110 insertions(+), 51 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr=
_ops.c
>> index 3115e4b..96e6cd3 100644
>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>> @@ -46,6 +46,27 @@ out_err:
>> 	return nsegs;
>> }
>>=20
>> +static int
>> +fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
>> +	    struct rpcrdma_create_data_internal *cdata) {
>> +	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> +	unsigned int wrs, max_wrs;
>> +
>> +	max_wrs =3D devattr->max_qp_wr;
>> +	if (cdata->max_requests > max_wrs)
>> +		cdata->max_requests =3D max_wrs;
>> +
>> +	wrs =3D cdata->max_requests;
>> +	ep->rep_attr.cap.max_send_wr =3D wrs;
>> +	ep->rep_attr.cap.max_recv_wr =3D wrs;
>> +
>> +	dprintk("RPC:       %s: pre-allocating %u send WRs, %u recv WRs\n"=
,
>> +		__func__, ep->rep_attr.cap.max_send_wr,
>> +		ep->rep_attr.cap.max_recv_wr);
>> +	return 0;
>> +}
>> +
>> /* FMR mode conveys up to 64 pages of payload per chunk segment.
>>  */
>> static size_t
>> @@ -201,6 +222,7 @@ fmr_op_destroy(struct rpcrdma_buffer *buf)  cons=
t
>> struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops =3D {
>> 	.ro_map				=3D fmr_op_map,
>> 	.ro_unmap			=3D fmr_op_unmap,
>> +	.ro_open			=3D fmr_op_open,
>> 	.ro_maxpages			=3D fmr_op_maxpages,
>> 	.ro_init			=3D fmr_op_init,
>> 	.ro_reset			=3D fmr_op_reset,
>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/fr=
wr_ops.c
>> index fc3a228..9bb4b2d 100644
>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>> @@ -93,6 +93,65 @@ __frwr_release(struct rpcrdma_mw *r)
>> 	ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
>> }
>>=20
>> +static int
>> +frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
>> +	     struct rpcrdma_create_data_internal *cdata) {
>> +	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> +	unsigned int wrs, max_wrs;
>> +	int depth =3D 7;
>> +
>> +	max_wrs =3D devattr->max_qp_wr;
>> +	if (cdata->max_requests > max_wrs)
>> +		cdata->max_requests =3D max_wrs;
>> +
>> +	wrs =3D cdata->max_requests;
>> +	ep->rep_attr.cap.max_send_wr =3D wrs;
>> +	ep->rep_attr.cap.max_recv_wr =3D wrs;
>> +
>> +	ia->ri_max_frmr_depth =3D
>> +			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
>> +			      devattr->max_fast_reg_page_list_len);
>> +	dprintk("RPC:       %s: device's max FR page list len =3D %u\n",
>> +		__func__, ia->ri_max_frmr_depth);
>> +
>> +	/* Add room for frmr register and invalidate WRs.
>> +	 * 1. FRMR reg WR for head
>> +	 * 2. FRMR invalidate WR for head
>> +	 * 3. N FRMR reg WRs for pagelist
>> +	 * 4. N FRMR invalidate WRs for pagelist
>> +	 * 5. FRMR reg WR for tail
>> +	 * 6. FRMR invalidate WR for tail
>> +	 * 7. The RDMA_SEND WR
>> +	 */
>> +
>> +	/* Calculate N if the device max FRMR depth is smaller than
>> +	 * RPCRDMA_MAX_DATA_SEGS.
>> +	 */
>> +	if (ia->ri_max_frmr_depth < RPCRDMA_MAX_DATA_SEGS) {
>> +		int delta =3D RPCRDMA_MAX_DATA_SEGS - ia-
>>> ri_max_frmr_depth;
>> +
>> +		do {
>> +			depth +=3D 2; /* FRMR reg + invalidate */
>> +			delta -=3D ia->ri_max_frmr_depth;
>> +		} while (delta > 0);
>=20
> Please add a check on ia->ri_max_frmr_depth to check it non-zero. A b=
ug in provider (if it reports max_frmr_depth =3D 0 in query_device), wo=
uld form an infinite loop here and mount will be stuck.

I=92ll include a patch to address this in the next version of this seri=
es.

>=20
>> +	}
>> +
>> +	ep->rep_attr.cap.max_send_wr *=3D depth;
>> +	if (ep->rep_attr.cap.max_send_wr > max_wrs) {
>> +		cdata->max_requests =3D max_wrs / depth;
>> +		if (!cdata->max_requests)
>> +			return -EINVAL;
>> +		ep->rep_attr.cap.max_send_wr =3D cdata->max_requests *
>> +					       depth;
>> +	}
>> +
>> +	dprintk("RPC:       %s: pre-allocating %u send WRs, %u recv WRs\n"=
,
>> +		__func__, ep->rep_attr.cap.max_send_wr,
>> +		ep->rep_attr.cap.max_recv_wr);
>> +	return 0;
>> +}
>> +
>> /* FRWR mode conveys a list of pages per chunk segment. The
>>  * maximum length of that list is the FRWR page list depth.
>>  */
>> @@ -290,6 +349,7 @@ frwr_op_destroy(struct rpcrdma_buffer *buf)  con=
st
>> struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops =3D {
>> 	.ro_map				=3D frwr_op_map,
>> 	.ro_unmap			=3D frwr_op_unmap,
>> +	.ro_open			=3D frwr_op_open,
>> 	.ro_maxpages			=3D frwr_op_maxpages,
>> 	.ro_init			=3D frwr_op_init,
>> 	.ro_reset			=3D frwr_op_reset,
>> diff --git a/net/sunrpc/xprtrdma/physical_ops.c
>> b/net/sunrpc/xprtrdma/physical_ops.c
>> index f8da8c4..0998f4f 100644
>> --- a/net/sunrpc/xprtrdma/physical_ops.c
>> +++ b/net/sunrpc/xprtrdma/physical_ops.c
>> @@ -19,6 +19,27 @@
>> # define RPCDBG_FACILITY	RPCDBG_TRANS
>> #endif
>>=20
>> +static int
>> +physical_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
>> +		 struct rpcrdma_create_data_internal *cdata) {
>> +	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> +	unsigned int wrs, max_wrs;
>> +
>> +	max_wrs =3D devattr->max_qp_wr;
>> +	if (cdata->max_requests > max_wrs)
>> +		cdata->max_requests =3D max_wrs;
>> +
>> +	wrs =3D cdata->max_requests;
>> +	ep->rep_attr.cap.max_send_wr =3D wrs;
>> +	ep->rep_attr.cap.max_recv_wr =3D wrs;
>> +
>> +	dprintk("RPC:       %s: pre-allocating %u send WRs, %u recv WRs\n"=
,
>> +		__func__, ep->rep_attr.cap.max_send_wr,
>> +		ep->rep_attr.cap.max_recv_wr);
>> +	return 0;
>> +}
>> +
>> /* PHYSICAL memory registration conveys one page per chunk segment.
>>  */
>> static size_t
>> @@ -75,6 +96,7 @@ physical_op_destroy(struct rpcrdma_buffer *buf)  c=
onst
>> struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops =3D {
>> 	.ro_map				=3D physical_op_map,
>> 	.ro_unmap			=3D physical_op_unmap,
>> +	.ro_open			=3D physical_op_open,
>> 	.ro_maxpages			=3D physical_op_maxpages,
>> 	.ro_init			=3D physical_op_init,
>> 	.ro_reset			=3D physical_op_reset,
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec index
>> dcbc736..17b2a29 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -621,11 +621,6 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, stru=
ct
>> sockaddr *addr, int memreg)
>> 			dprintk("RPC:       %s: FRMR registration "
>> 				"not supported by HCA\n", __func__);
>> 			memreg =3D RPCRDMA_MTHCAFMR;
>> -		} else {
>> -			/* Mind the ia limit on FRMR page list depth */
>> -			ia->ri_max_frmr_depth =3D min_t(unsigned int,
>> -				RPCRDMA_MAX_DATA_SEGS,
>> -				devattr->max_fast_reg_page_list_len);
>> 		}
>> 	}
>> 	if (memreg =3D=3D RPCRDMA_MTHCAFMR) {
>> @@ -734,56 +729,13 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struc=
t
>> rpcrdma_ia *ia,
>> 	struct ib_cq *sendcq, *recvcq;
>> 	int rc, err;
>>=20
>> -	/* check provider's send/recv wr limits */
>> -	if (cdata->max_requests > devattr->max_qp_wr)
>> -		cdata->max_requests =3D devattr->max_qp_wr;
>> +	rc =3D ia->ri_ops->ro_open(ia, ep, cdata);
>> +	if (rc)
>> +		return rc;
>>=20
>> 	ep->rep_attr.event_handler =3D rpcrdma_qp_async_error_upcall;
>> 	ep->rep_attr.qp_context =3D ep;
>> -	/* send_cq and recv_cq initialized below */
>> 	ep->rep_attr.srq =3D NULL;
>> -	ep->rep_attr.cap.max_send_wr =3D cdata->max_requests;
>> -	switch (ia->ri_memreg_strategy) {
>> -	case RPCRDMA_FRMR: {
>> -		int depth =3D 7;
>> -
>> -		/* Add room for frmr register and invalidate WRs.
>> -		 * 1. FRMR reg WR for head
>> -		 * 2. FRMR invalidate WR for head
>> -		 * 3. N FRMR reg WRs for pagelist
>> -		 * 4. N FRMR invalidate WRs for pagelist
>> -		 * 5. FRMR reg WR for tail
>> -		 * 6. FRMR invalidate WR for tail
>> -		 * 7. The RDMA_SEND WR
>> -		 */
>> -
>> -		/* Calculate N if the device max FRMR depth is smaller than
>> -		 * RPCRDMA_MAX_DATA_SEGS.
>> -		 */
>> -		if (ia->ri_max_frmr_depth < RPCRDMA_MAX_DATA_SEGS) {
>> -			int delta =3D RPCRDMA_MAX_DATA_SEGS -
>> -				    ia->ri_max_frmr_depth;
>> -
>> -			do {
>> -				depth +=3D 2; /* FRMR reg + invalidate */
>> -				delta -=3D ia->ri_max_frmr_depth;
>> -			} while (delta > 0);
>> -
>> -		}
>> -		ep->rep_attr.cap.max_send_wr *=3D depth;
>> -		if (ep->rep_attr.cap.max_send_wr > devattr->max_qp_wr) {
>> -			cdata->max_requests =3D devattr->max_qp_wr / depth;
>> -			if (!cdata->max_requests)
>> -				return -EINVAL;
>> -			ep->rep_attr.cap.max_send_wr =3D cdata-
>>> max_requests *
>> -						       depth;
>> -		}
>> -		break;
>> -	}
>> -	default:
>> -		break;
>> -	}
>> -	ep->rep_attr.cap.max_recv_wr =3D cdata->max_requests;
>> 	ep->rep_attr.cap.max_send_sge =3D (cdata->padding ? 4 : 2);
>> 	ep->rep_attr.cap.max_recv_sge =3D 1;
>> 	ep->rep_attr.cap.max_inline_data =3D 0;
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h
>> b/net/sunrpc/xprtrdma/xprt_rdma.h index a0e3c3e..a53a564 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -340,6 +340,9 @@ struct rpcrdma_memreg_ops {
>> 				  struct rpcrdma_mr_seg *, int, bool);
>> 	void		(*ro_unmap)(struct rpcrdma_xprt *,
>> 				    struct rpcrdma_req *, unsigned int);
>> +	int		(*ro_open)(struct rpcrdma_ia *,
>> +				   struct rpcrdma_ep *,
>> +				   struct rpcrdma_create_data_internal *);
>> 	size_t		(*ro_maxpages)(struct rpcrdma_xprt *);
>> 	int		(*ro_init)(struct rpcrdma_xprt *);
>> 	void		(*ro_reset)(struct rpcrdma_xprt *);
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
