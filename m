From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2 2/2] libibmad: Added smp_query/set _status_via
 functions
Date: Fri, 8 Apr 2011 15:31:38 -0700
Message-ID: <20110408153138.509cfbc5.weiny2@llnl.gov>
References: <4D9B6C40.5010801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D9B6C40.5010801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks applied,
Ira

On Tue, 5 Apr 2011 12:23:44 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> The smp_query/set functions do not return the MAD status.
> The new extended API allows getting the SMP MAD status, and
> to differentiate between timeout on MAD response and response
> with bad status.
> 
> Signed-off-by: Oren Kladnitsky <orenk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Change since v1:
> Proper formatting
> 
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index a0b368a..5d18ec3 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
> - * Copyright (c) 2009-2010 Mellanox Technologies LTD.  All rights reserved.
> + * Copyright (c) 2009-2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -981,6 +981,14 @@ MAD_EXPORT uint8_t *smp_query_via(void *buf, ib_portid_t * id, unsigned attrid,
>  MAD_EXPORT uint8_t *smp_set_via(void *buf, ib_portid_t * id, unsigned attrid,
>  				unsigned mod, unsigned timeout,
>  				const struct ibmad_port *srcport);
> +MAD_EXPORT uint8_t *smp_query_status_via(void *rcvbuf, ib_portid_t * portid,
> +					 unsigned attrid, unsigned mod,
> +					 unsigned timeout, int *rstatus,
> +					 const struct ibmad_port *srcport);
> +MAD_EXPORT uint8_t *smp_set_status_via(void *data, ib_portid_t * portid,
> +				       unsigned attrid, unsigned mod,
> +				       unsigned timeout, int *rstatus,
> +				       const struct ibmad_port *srcport);
>  
>  /* sa.c */
>  uint8_t *sa_call(void *rcvbuf, ib_portid_t * portid, ib_sa_call_t * sa,
> diff --git a/src/libibmad.map b/src/libibmad.map
> index 5778e3e..1e6a028 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -101,7 +101,9 @@ IBMAD_1.3 {
>  		ib_vendor_call;
>  		ib_vendor_call_via;
>  		smp_query_via;
> +		smp_query_status_via;
>  		smp_set_via;
> +		smp_set_status_via;
>  		ib_path_query_via;
>  		ib_resolve_smlid_via;
>  		ib_resolve_guid_via;
> diff --git a/src/rpc.c b/src/rpc.c
> index c5246fe..a702046 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -1,6 +1,7 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
> + * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -243,6 +244,8 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
>  			redirect = 0;
>  	}
>  
> +	rpc->rstatus = status;
> +
>  	if (status != 0) {
>  		ERRS("MAD completed with error status 0x%x; dport (%s)",
>  		     status, portid2str(dport));
> diff --git a/src/smp.c b/src/smp.c
> index 3ff58ce..a337663 100644
> --- a/src/smp.c
> +++ b/src/smp.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
> + * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -45,11 +46,12 @@
>  #undef DEBUG
>  #define DEBUG 	if (ibdebug)	IBWARN
>  
> -uint8_t *smp_set_via(void *data, ib_portid_t * portid, unsigned attrid,
> -		     unsigned mod, unsigned timeout,
> -		     const struct ibmad_port *srcport)
> +uint8_t *smp_set_status_via(void *data, ib_portid_t * portid, unsigned attrid,
> +			    unsigned mod, unsigned timeout, int *rstatus,
> +			    const struct ibmad_port *srcport)
>  {
>  	ib_rpc_t rpc = { 0 };
> +	uint8_t *res;
>  
>  	DEBUG("attr 0x%x mod 0x%x route %s", attrid, mod, portid2str(portid));
>  	if ((portid->lid <= 0) ||
> @@ -69,7 +71,18 @@ uint8_t *smp_set_via(void *data, ib_portid_t * portid, unsigned attrid,
>  	portid->sl = 0;
>  	portid->qp = 0;
>  
> -	return mad_rpc(srcport, &rpc, portid, data, data);
> +	res = mad_rpc(srcport, &rpc, portid, data, data);
> +	if (rstatus)
> +		*rstatus = rpc.rstatus;
> +	return res;
> +}
> +
> +uint8_t *smp_set_via(void *data, ib_portid_t * portid, unsigned attrid,
> +		     unsigned mod, unsigned timeout,
> +		     const struct ibmad_port *srcport)
> +{
> +	return smp_set_status_via(data, portid, attrid, mod, timeout, NULL,
> +				  srcport);
>  }
>  
>  uint8_t *smp_set(void *data, ib_portid_t * portid, unsigned attrid,
> @@ -78,11 +91,12 @@ uint8_t *smp_set(void *data, ib_portid_t * portid, unsigned attrid,
>  	return smp_set_via(data, portid, attrid, mod, timeout, ibmp);
>  }
>  
> -uint8_t *smp_query_via(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
> -		       unsigned mod, unsigned timeout,
> -		       const struct ibmad_port * srcport)
> +uint8_t *smp_query_status_via(void *rcvbuf, ib_portid_t * portid,
> +			      unsigned attrid, unsigned mod, unsigned timeout,
> +			      int *rstatus, const struct ibmad_port * srcport)
>  {
>  	ib_rpc_t rpc = { 0 };
> +	uint8_t *res;
>  
>  	DEBUG("attr 0x%x mod 0x%x route %s", attrid, mod, portid2str(portid));
>  	rpc.method = IB_MAD_METHOD_GET;
> @@ -102,7 +116,18 @@ uint8_t *smp_query_via(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
>  	portid->sl = 0;
>  	portid->qp = 0;
>  
> -	return mad_rpc(srcport, &rpc, portid, rcvbuf, rcvbuf);
> +	res = mad_rpc(srcport, &rpc, portid, rcvbuf, rcvbuf);
> +	if (rstatus)
> +		*rstatus = rpc.rstatus;
> +	return res;
> +}
> +
> +uint8_t *smp_query_via(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
> +		       unsigned mod, unsigned timeout,
> +		       const struct ibmad_port * srcport)
> +{
> +	return smp_query_status_via(rcvbuf, portid, attrid, mod, timeout, NULL,
> +				    srcport);
>  }
>  
>  uint8_t *smp_query(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
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
