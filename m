From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not copy uninitialized data in
 ibv_cmd_modify_qp
Date: Sun, 25 Dec 2016 09:42:43 +0200
Message-ID: <20161225074243.GA14356@mtr-leonro.local>
References: <20161222221334.GA15907@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161222221334.GA15907-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2016 at 03:13:34PM -0700, Jason Gunthorpe wrote:
> Valgrind reports:
>
> ==1196== Syscall param write(buf) points to uninitialised byte(s)
> ==1196==    at 0x506250D: ??? (syscall-template.S:84)
> ==1196==    by 0x527756F: ibv_cmd_modify_qp (cmd.c:1291)
> ==1196==    by 0x8008D74: mlx4_modify_qp (verbs.c:820)
> ==1196==    by 0x527E4F4: ibv_modify_qp@@IBVERBS_1.1 (verbs.c:561)
> ==1196==    by 0x4E3FAB3: ucma_modify_qp_err.isra.6 (cma.c:1115)
> ==1196==    by 0x4E41D56: rdma_get_cm_event.part.15 (cma.c:2180)
> ==1196==    by 0x402CF0: cm_thread (rping.c:576)
> ==1196==    by 0x5059709: start_thread (pthread_create.c:333)
> ==1196==    by 0x558A82C: clone (clone.S:109)
> ==1196==  Address 0x9847980 is on thread 2's stack
> ==1196==  in frame #2, created by mlx4_modify_qp (verbs.c:775)
>
> This is because of code like this:
>
>         struct ibv_qp_attr qp_attr;
>         qp_attr.qp_state = IBV_QPS_ERR;
>         return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE));
>
> Always pass 0 into the kernel for for attributes that are not requested
> to be modified.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libibverbs/cmd.c | 170 +++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 121 insertions(+), 49 deletions(-)
>
> Shown with rping
>
> Please double check my if's.. I followed the man page
>
> I think there will be other cases where we do this wrong as well :\
>
> diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
> index 38061892da0de0..a702d67b05f2a3 100644
> --- a/libibverbs/cmd.c
> +++ b/libibverbs/cmd.c
> @@ -1221,55 +1221,127 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
>  {
>  	IBV_INIT_CMD(cmd, cmd_size, MODIFY_QP);

I didn't check all ibv_* commands but for ibv_cmd_modify_qp callers, there are no callers
which change cmd before this call. It looks like it is safe to replace all cmd->* = 0 with
one global memset(). Maybe it is safe to put this memset in IBV_INIT_CMD too.

>
> -	cmd->qp_handle 		 = qp->handle;
> -	cmd->attr_mask 		 = attr_mask;
> -	cmd->qkey 		 = attr->qkey;
> -	cmd->rq_psn 		 = attr->rq_psn;
> -	cmd->sq_psn 		 = attr->sq_psn;
> -	cmd->dest_qp_num 	 = attr->dest_qp_num;
> -	cmd->qp_access_flags 	 = attr->qp_access_flags;
> -	cmd->pkey_index		 = attr->pkey_index;
> -	cmd->alt_pkey_index 	 = attr->alt_pkey_index;
> -	cmd->qp_state 		 = attr->qp_state;
> -	cmd->cur_qp_state 	 = attr->cur_qp_state;
> -	cmd->path_mtu 		 = attr->path_mtu;
> -	cmd->path_mig_state 	 = attr->path_mig_state;
> -	cmd->en_sqd_async_notify = attr->en_sqd_async_notify;
> -	cmd->max_rd_atomic 	 = attr->max_rd_atomic;
> -	cmd->max_dest_rd_atomic  = attr->max_dest_rd_atomic;
> -	cmd->min_rnr_timer 	 = attr->min_rnr_timer;
> -	cmd->port_num 		 = attr->port_num;
> -	cmd->timeout 		 = attr->timeout;
> -	cmd->retry_cnt 		 = attr->retry_cnt;
> -	cmd->rnr_retry 		 = attr->rnr_retry;
> -	cmd->alt_port_num 	 = attr->alt_port_num;
> -	cmd->alt_timeout 	 = attr->alt_timeout;
> -
> -	memcpy(cmd->dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
> -	cmd->dest.flow_label 	    = attr->ah_attr.grh.flow_label;
> -	cmd->dest.dlid 		    = attr->ah_attr.dlid;
> -	cmd->dest.reserved	    = 0;
> -	cmd->dest.sgid_index 	    = attr->ah_attr.grh.sgid_index;
> -	cmd->dest.hop_limit 	    = attr->ah_attr.grh.hop_limit;
> -	cmd->dest.traffic_class     = attr->ah_attr.grh.traffic_class;
> -	cmd->dest.sl 		    = attr->ah_attr.sl;
> -	cmd->dest.src_path_bits     = attr->ah_attr.src_path_bits;
> -	cmd->dest.static_rate 	    = attr->ah_attr.static_rate;
> -	cmd->dest.is_global 	    = attr->ah_attr.is_global;
> -	cmd->dest.port_num 	    = attr->ah_attr.port_num;
> -
> -	memcpy(cmd->alt_dest.dgid, attr->alt_ah_attr.grh.dgid.raw, 16);
> -	cmd->alt_dest.flow_label    = attr->alt_ah_attr.grh.flow_label;
> -	cmd->alt_dest.dlid 	    = attr->alt_ah_attr.dlid;
> -	cmd->alt_dest.reserved	    = 0;
> -	cmd->alt_dest.sgid_index    = attr->alt_ah_attr.grh.sgid_index;
> -	cmd->alt_dest.hop_limit     = attr->alt_ah_attr.grh.hop_limit;
> -	cmd->alt_dest.traffic_class = attr->alt_ah_attr.grh.traffic_class;
> -	cmd->alt_dest.sl 	    = attr->alt_ah_attr.sl;
> -	cmd->alt_dest.src_path_bits = attr->alt_ah_attr.src_path_bits;
> -	cmd->alt_dest.static_rate   = attr->alt_ah_attr.static_rate;
> -	cmd->alt_dest.is_global     = attr->alt_ah_attr.is_global;
> -	cmd->alt_dest.port_num 	    = attr->alt_ah_attr.port_num;
> +	cmd->qp_handle = qp->handle;
> +	cmd->attr_mask = attr_mask;
> +
> +	if (attr_mask & IBV_QP_STATE)
> +		cmd->qp_state = attr->qp_state;
> +	else
> +		cmd->qp_state = 0;
> +
> +	if (attr_mask & IBV_QP_CUR_STATE)
> +		cmd->cur_qp_state = attr->cur_qp_state;
> +	else
> +		cmd->cur_qp_state = 0;
> +
> +	if (attr_mask & IBV_QP_EN_SQD_ASYNC_NOTIFY)
> +		cmd->en_sqd_async_notify = attr->en_sqd_async_notify;
> +	else
> +		cmd->en_sqd_async_notify = 0;
> +
> +	if (attr_mask & IBV_QP_ACCESS_FLAGS)
> +		cmd->qp_access_flags = attr->qp_access_flags;
> +	else
> +		cmd->qp_access_flags = 0;
> +	if (attr_mask & IBV_QP_PKEY_INDEX)
> +		cmd->pkey_index = attr->pkey_index;
> +	else
> +		cmd->pkey_index = 0;
> +	if (attr_mask & IBV_QP_PORT)
> +		cmd->port_num = attr->port_num;
> +	else
> +		cmd->port_num = 0;
> +	if (attr_mask & IBV_QP_QKEY)
> +		cmd->qkey = attr->qkey;
> +	else
> +		cmd->qkey = 0;
> +
> +	if (attr_mask & IBV_QP_AV) {
> +		memcpy(cmd->dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
> +		cmd->dest.flow_label = attr->ah_attr.grh.flow_label;
> +		cmd->dest.dlid = attr->ah_attr.dlid;
> +		cmd->dest.reserved = 0;
> +		cmd->dest.sgid_index = attr->ah_attr.grh.sgid_index;
> +		cmd->dest.hop_limit = attr->ah_attr.grh.hop_limit;
> +		cmd->dest.traffic_class = attr->ah_attr.grh.traffic_class;
> +		cmd->dest.sl = attr->ah_attr.sl;
> +		cmd->dest.src_path_bits = attr->ah_attr.src_path_bits;
> +		cmd->dest.static_rate = attr->ah_attr.static_rate;
> +		cmd->dest.is_global = attr->ah_attr.is_global;
> +		cmd->dest.port_num = attr->ah_attr.port_num;
> +	} else
> +		memset(&cmd->dest, 0, sizeof(cmd->dest));
> +
> +	if (attr_mask & IBV_QP_PATH_MTU)
> +		cmd->path_mtu = attr->path_mtu;
> +	else
> +		cmd->path_mtu = 0;
> +	if (attr_mask & IBV_QP_TIMEOUT)
> +		cmd->timeout = attr->timeout;
> +	else
> +		cmd->timeout = 0;
> +	if (attr_mask & IBV_QP_RETRY_CNT)
> +		cmd->retry_cnt = attr->retry_cnt;
> +	else
> +		cmd->retry_cnt = 0;
> +	if (attr_mask & IBV_QP_RNR_RETRY)
> +		cmd->rnr_retry = attr->rnr_retry;
> +	else
> +		cmd->rnr_retry = 0;
> +	if (attr_mask & IBV_QP_RQ_PSN)
> +		cmd->rq_psn = attr->rq_psn;
> +	else
> +		cmd->rq_psn = 0;
> +	if (attr_mask & IBV_QP_MAX_QP_RD_ATOMIC)
> +		cmd->max_rd_atomic = attr->max_rd_atomic;
> +	else
> +		cmd->max_rd_atomic = 0;
> +
> +	if (attr_mask & IBV_QP_ALT_PATH) {
> +		cmd->alt_pkey_index = attr->alt_pkey_index;
> +		cmd->alt_port_num = attr->alt_port_num;
> +		cmd->alt_timeout = attr->alt_timeout;
> +
> +		memcpy(cmd->alt_dest.dgid, attr->alt_ah_attr.grh.dgid.raw, 16);
> +		cmd->alt_dest.flow_label = attr->alt_ah_attr.grh.flow_label;
> +		cmd->alt_dest.dlid = attr->alt_ah_attr.dlid;
> +		cmd->alt_dest.reserved = 0;
> +		cmd->alt_dest.sgid_index = attr->alt_ah_attr.grh.sgid_index;
> +		cmd->alt_dest.hop_limit = attr->alt_ah_attr.grh.hop_limit;
> +		cmd->alt_dest.traffic_class =
> +		    attr->alt_ah_attr.grh.traffic_class;
> +		cmd->alt_dest.sl = attr->alt_ah_attr.sl;
> +		cmd->alt_dest.src_path_bits = attr->alt_ah_attr.src_path_bits;
> +		cmd->alt_dest.static_rate = attr->alt_ah_attr.static_rate;
> +		cmd->alt_dest.is_global = attr->alt_ah_attr.is_global;
> +		cmd->alt_dest.port_num = attr->alt_ah_attr.port_num;
> +	} else {
> +		cmd->alt_pkey_index = 0;
> +		cmd->alt_port_num = 0;
> +		cmd->alt_timeout = 0;
> +		memset(&cmd->alt_dest, 0, sizeof(cmd->alt_dest));
> +	}
> +
> +	if (attr_mask & IBV_QP_MIN_RNR_TIMER)
> +		cmd->min_rnr_timer = attr->min_rnr_timer;
> +	else
> +		cmd->min_rnr_timer = 0;
> +	if (attr_mask & IBV_QP_SQ_PSN)
> +		cmd->sq_psn = attr->sq_psn;
> +	else
> +		cmd->sq_psn = 0;
> +	if (attr_mask & IBV_QP_MAX_DEST_RD_ATOMIC)
> +		cmd->max_dest_rd_atomic = attr->max_dest_rd_atomic;
> +	else
> +		cmd->max_dest_rd_atomic = 0;
> +	if (attr_mask & IBV_QP_PATH_MIG_STATE)
> +		cmd->path_mig_state = attr->path_mig_state;
> +	else
> +		cmd->path_mig_state = 0;
> +	if (attr_mask & IBV_QP_DEST_QPN)
> +		cmd->dest_qp_num = attr->dest_qp_num;
> +	else
> +		cmd->dest_qp_num = 0;
>
>  	cmd->reserved[0] = cmd->reserved[1] = 0;
>
> --
> 2.7.4

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhfeHIACgkQ5GN7iDZy
WKdBaRAAh2MTY5PV/2eBBAd17WsaBeQYQur/TF2DqTkGfMZCmXb1+3xQjsu4/mQG
zXnlrvLQKzib5x1miyXivyV4KQoWOIeZ55Q7hIysCDllCpokDdwRdABKEIS4HqR/
aPr26vhvOqODZLKosgjSMYMmV6oW1+/4hGCIpkV0NpS308mEk3LXNJFonxszG+Q3
9onaK3FyK2VLpuysHkdQEUbaWAb39p/cj5Zp7uNoNKovan8EpLC5+5Ad4A4espfo
61KkNA+Ub9itEFzh83GMCoUUj1r5Ult2TwXMkvQcTaThAGU82s0AtvgefGGdywKe
EGJi2YRRNdBl/iFUn3T84FLhhbVwWRkyATwsy38qIft29gQ20h4g0oWwZg8noChl
D3U8Vms1/fF9oDup0CJA6b1hb80Pd7Du+3r6coUCNyEzMulHPvF/Zhl8ocpFLoFA
OycNEr8LY7mjaV7LfGjdMjiiVJvFU6vezLavWzRcH+KU1Y4ojDXcXMNGP+5xtE/b
ItuZxpo+35qJov84suUu3tXd1E5QpmGiCPX5NYzN3JIhE22Nomx4CNJlx1UuKQmd
uIHJA2CTF5NDNleOItXQJ92p1cj2NXotaj7rHocRSmuxgb4V/SIjKg1EjB+exyXG
sivoutt5JgE9gRwbHt5DfLg9DvUkKF/SX593vsaNOz8Kk97hYn0=
=xJ9k
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
