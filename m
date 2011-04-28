From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2 1/3] libibmad: Distinguish timed out from other errors
Date: Thu, 28 Apr 2011 14:19:51 -0700
Message-ID: <20110428141951.10718efc.weiny2@llnl.gov>
References: <4DB7FA95.9090206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB7FA95.9090206-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 27 Apr 2011 04:14:29 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Add ib_rpc_v1_t structure like ib_rpc_t structure
> with additional error field like errno.
> 
> mgtclass is only a byte so use next nibble to indicate
> rpc version. Original rpc version is 0; now adding version 1.
> 
> In mad_rpc code, make sure error is cleared and
> in _do_madrpc, set ETIMEDOUT.
> 
> error field could also be used to distinguish other errors if needed.
> 
> Bump library version accordingly.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 5d18ec3..be85ed6 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -46,6 +46,9 @@
>  #endif				/* __cplusplus */
>  
>  BEGIN_C_DECLS
> +#define IB_MAD_RPC_VERSION_MASK	0x0f00
> +#define IB_MAD_RPC_VERSION1	(1<<8)
> +
>  #define IB_SUBNET_PATH_HOPS_MAX	64
>  #define IB_DEFAULT_SUBN_PREFIX	0xfe80000000000000ULL
>  #define IB_DEFAULT_QP1_QKEY	0x80010000
> @@ -235,6 +238,22 @@ typedef struct {
>  	uint32_t oui;		/* for vendor range 2 mads */
>  } ib_rpc_t;
>  
> +typedef struct {
> +	int mgtclass;
> +	int method;
> +	ib_attr_t attr;
> +	uint32_t rstatus;	/* return status */
> +	int dataoffs;
> +	int datasz;
> +	uint64_t mkey;
> +	uint64_t trid;		/* used for out mad if nonzero, return real val */
> +	uint64_t mask;		/* for sa mads */
> +	unsigned recsz;		/* for sa mads (attribute offset) */
> +	int timeout;
> +	uint32_t oui;		/* for vendor range 2 mads */
> +	int error;		/* errno */
> +} ib_rpc_v1_t;
> +
>  typedef struct portid {
>  	int lid;		/* lid or 0 if directed route */
>  	ib_dr_path_t drpath;
> diff --git a/libibmad.ver b/libibmad.ver
> index 857a99b..9a10851 100644
> --- a/libibmad.ver
> +++ b/libibmad.ver
> @@ -6,4 +6,4 @@
>  # API_REV - advance on any added API
>  # RUNNING_REV - advance any change to the vendor files
>  # AGE - number of backward versions the API still supports
> -LIBVERSION=6:2:1
> +LIBVERSION=7:2:2
> diff --git a/src/mad.c b/src/mad.c
> index acd0e85..463c61d 100644
> --- a/src/mad.c
> +++ b/src/mad.c
> @@ -1,6 +1,7 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
> + * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -83,12 +84,12 @@ void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
>  	mad_set_field(buf, 0, IB_MAD_METHOD_F, rpc->method);
>  	mad_set_field(buf, 0, IB_MAD_RESPONSE_F, is_resp ? 1 : 0);
>  	mad_set_field(buf, 0, IB_MAD_CLASSVER_F,
> -		      rpc->mgtclass == IB_SA_CLASS ? 2 : 1);
> -	mad_set_field(buf, 0, IB_MAD_MGMTCLASS_F, rpc->mgtclass);
> +		      (rpc->mgtclass & 0xff) == IB_SA_CLASS ? 2 : 1);
> +	mad_set_field(buf, 0, IB_MAD_MGMTCLASS_F, rpc->mgtclass & 0xff);
>  	mad_set_field(buf, 0, IB_MAD_BASEVER_F, 1);
>  
>  	/* second word */
> -	if (rpc->mgtclass == IB_SMI_DIRECT_CLASS) {
> +	if ((rpc->mgtclass & 0xff) == IB_SMI_DIRECT_CLASS) {
>  		if (!drpath) {
>  			IBWARN("encoding dr mad without drpath (null)");
>  			return NULL;
> @@ -116,7 +117,7 @@ void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
>  	/* words 7,8 */
>  	mad_set_field64(buf, 0, IB_MAD_MKEY_F, rpc->mkey);
>  
> -	if (rpc->mgtclass == IB_SMI_DIRECT_CLASS) {
> +	if ((rpc->mgtclass & 0xff) == IB_SMI_DIRECT_CLASS) {
>  		/* word 9 */
>  		mad_set_field(buf, 0, IB_DRSMP_DRDLID_F,
>  			      drpath->drdlid ? drpath->drdlid : 0xffff);
> @@ -130,14 +131,14 @@ void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
>  			mad_set_array(buf, 0, IB_DRSMP_PATH_F, drpath->p);
>  	}
>  
> -	if (rpc->mgtclass == IB_SA_CLASS)
> +	if ((rpc->mgtclass & 0xff) == IB_SA_CLASS)
>  		mad_set_field64(buf, 0, IB_SA_COMPMASK_F, rpc->mask);
>  
>  	if (data)
>  		memcpy((char *)buf + rpc->dataoffs, data, rpc->datasz);
>  
>  	/* vendor mads range 2 */
> -	if (mad_is_vendor_range2(rpc->mgtclass))
> +	if (mad_is_vendor_range2(rpc->mgtclass & 0xff))
>  		mad_set_field(buf, 0, IB_VEND2_OUI_F, rpc->oui);
>  
>  	return (uint8_t *) buf + IB_MAD_SIZE;
> @@ -147,9 +148,9 @@ int mad_build_pkt(void *umad, ib_rpc_t * rpc, ib_portid_t * dport,
>  		  ib_rmpp_hdr_t * rmpp, void *data)
>  {
>  	uint8_t *p, *mad;
> -	int lid_routed = rpc->mgtclass != IB_SMI_DIRECT_CLASS;
> -	int is_smi = (rpc->mgtclass == IB_SMI_CLASS ||
> -		      rpc->mgtclass == IB_SMI_DIRECT_CLASS);
> +	int lid_routed = (rpc->mgtclass & 0xff) != IB_SMI_DIRECT_CLASS;
> +	int is_smi = ((rpc->mgtclass & 0xff) == IB_SMI_CLASS ||
> +		      (rpc->mgtclass & 0xff) == IB_SMI_DIRECT_CLASS);
>  	struct ib_mad_addr addr;
>  
>  	if (!is_smi)
> diff --git a/src/rpc.c b/src/rpc.c
> index a702046..88e43e7 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -127,7 +127,7 @@ int mad_rpc_class_agent(struct ibmad_port *port, int class)
>  
>  static int
>  _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
> -	   int timeout, int max_retries)
> +	   int timeout, int max_retries, int *p_error)
>  {
>  	uint32_t trid;		/* only low 32 bits */
>  	int retries;
> @@ -182,6 +182,7 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
>  			return length;
>  	}
>  
> +	*p_error = ETIMEDOUT;
>  	ERRS("timeout after %d retries, %d ms", retries, timeout * retries);
>  	return -1;
>  }
> @@ -213,7 +214,11 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
>  	int status, len;
>  	uint8_t sndbuf[1024], rcvbuf[1024], *mad;
>  	int redirect = 1;
> +	ib_rpc_v1_t *rpcv1 = (ib_rpc_v1_t *)rpc;
> +	int error = 0;
>  
> +	if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
> +		rpcv1->error = 0;
>  	while (redirect) {
>  		len = 0;
>  		memset(sndbuf, 0, umad_size() + IB_MAD_SIZE);
> @@ -222,9 +227,12 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
>  			return NULL;
>  
>  		if ((len = _do_madrpc(port->port_id, sndbuf, rcvbuf,
> -				      port->class_agents[rpc->mgtclass],
> +				      port->class_agents[rpc->mgtclass & 0xff],
>  				      len, mad_get_timeout(port, rpc->timeout),
> -				      mad_get_retries(port))) < 0) {
> +				      mad_get_retries(port), &error)) < 0) {
> +			if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) ==
> +			    IB_MAD_RPC_VERSION1)
> +				rpcv1->error = error;
>  			IBWARN("_do_madrpc failed; dport (%s)",
>  			       portid2str(dport));
>  			return NULL;
> @@ -244,6 +252,8 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
>  			redirect = 0;
>  	}
>  
> +	if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
> +		rpcv1->error = error;
>  	rpc->rstatus = status;
>  
>  	if (status != 0) {
> @@ -268,22 +278,31 @@ void *mad_rpc_rmpp(const struct ibmad_port *port, ib_rpc_t * rpc,
>  {
>  	int status, len;
>  	uint8_t sndbuf[1024], rcvbuf[1024], *mad;
> +	ib_rpc_v1_t *rpcv1 = (ib_rpc_v1_t *)rpc;
> +	int error = 0;
>  
>  	memset(sndbuf, 0, umad_size() + IB_MAD_SIZE);
>  
>  	DEBUG("rmpp %p data %p", rmpp, data);
>  
> +	if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
> +		rpcv1->error = 0;
>  	if ((len = mad_build_pkt(sndbuf, rpc, dport, rmpp, data)) < 0)
>  		return NULL;
>  
>  	if ((len = _do_madrpc(port->port_id, sndbuf, rcvbuf,
> -			      port->class_agents[rpc->mgtclass],
> +			      port->class_agents[rpc->mgtclass & 0xff],
>  			      len, mad_get_timeout(port, rpc->timeout),
> -			      mad_get_retries(port))) < 0) {
> +			      mad_get_retries(port), &error)) < 0) {
> +		if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
> +			rpcv1->error = error;
>  		IBWARN("_do_madrpc failed; dport (%s)", portid2str(dport));
>  		return NULL;
>  	}
>  
> +	if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
> +		rpcv1->error = error;
> +
>  	mad = umad_get_mad(rcvbuf);
>  
>  	if ((status = mad_get_field(mad, 0, IB_MAD_STATUS_F)) != 0) {
> diff --git a/src/serv.c b/src/serv.c
> index df61f25..2e3b7ef 100644
> --- a/src/serv.c
> +++ b/src/serv.c
> @@ -72,7 +72,7 @@ int mad_send_via(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
>  		      (char *)umad_get_mad(umad) + rpc->dataoffs, rpc->datasz);
>  	}
>  
> -	if (umad_send(srcport->port_id, srcport->class_agents[rpc->mgtclass],
> +	if (umad_send(srcport->port_id, srcport->class_agents[rpc->mgtclass & 0xff],
>  		      umad, IB_MAD_SIZE, mad_get_timeout(srcport, rpc->timeout),
>  		      0) < 0) {
>  		IBWARN("send failed; %m");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
