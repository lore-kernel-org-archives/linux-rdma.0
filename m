From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add support for congestion control config
 mads.
Date: Mon, 16 Jan 2012 15:41:09 -0800
Message-ID: <20120116154109.07a25adf.weiny2@llnl.gov>
References: <1323382174.6368.102.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323382174.6368.102.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 8 Dec 2011 14:09:34 -0800
Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks applied,
Ira

> ---
>  include/infiniband/mad.h |    5 +++++
>  src/cc.c                 |   37 +++++++++++++++++++++++++++++++++++++
>  src/libibmad.map         |    1 +
>  3 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index a94ca08..5d62307 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -1496,6 +1496,11 @@ MAD_EXPORT void *cc_query_status_via(void *rcvbuf, ib_portid_t * portid,
>  				     int *rstatus, const struct ibmad_port * srcport,
>  				     uint64_t cckey);
>  
> +MAD_EXPORT void *cc_config_status_via(void *payload, void *rcvbuf, ib_portid_t * portid,
> +				      unsigned attrid, unsigned mod, unsigned timeout,
> +				      int *rstatus, const struct ibmad_port * srcport,
> +				      uint64_t cckey);
> +
>  /* sa.c */
>  uint8_t *sa_call(void *rcvbuf, ib_portid_t * portid, ib_sa_call_t * sa,
>  		 unsigned timeout) DEPRECATED;
> diff --git a/src/cc.c b/src/cc.c
> index 36231f7..cae174e 100644
> --- a/src/cc.c
> +++ b/src/cc.c
> @@ -79,3 +79,40 @@ void *cc_query_status_via(void *rcvbuf, ib_portid_t * portid,
>  
>  	return res;
>  }
> +
> +void *cc_config_status_via(void *payload, void *rcvbuf, ib_portid_t * portid,
> +                           unsigned attrid, unsigned mod, unsigned timeout,
> +                           int *rstatus, const struct ibmad_port * srcport,
> +                           uint64_t cckey)
> +{
> +	ib_rpc_cc_t rpc = { 0 };
> +	void *res;
> +
> +	DEBUG("attr 0x%x mod 0x%x route %s", attrid, mod, portid2str(portid));
> +	rpc.method = IB_MAD_METHOD_SET;
> +	rpc.attr.id = attrid;
> +	rpc.attr.mod = mod;
> +	rpc.timeout = timeout;
> +	if (attrid == IB_CC_ATTR_CONGESTION_LOG) {
> +		rpc.datasz = IB_CC_LOG_DATA_SZ;
> +		rpc.dataoffs = IB_CC_LOG_DATA_OFFS;
> +	}
> +	else {
> +		rpc.datasz = IB_CC_DATA_SZ;
> +		rpc.dataoffs = IB_CC_DATA_OFFS;
> +	}
> +	rpc.mgtclass = IB_CC_CLASS;
> +	rpc.cckey = cckey;
> +
> +	portid->qp = 1;
> +	if (!portid->qkey)
> +		portid->qkey = IB_DEFAULT_QP1_QKEY;
> +
> +	res = mad_rpc(srcport, (ib_rpc_t *)&rpc, portid, payload, rcvbuf);
> +	if (rstatus)
> +		*rstatus = rpc.rstatus;
> +
> +	return res;
> +}
> +
> +
> diff --git a/src/libibmad.map b/src/libibmad.map
> index a64288d..7c7587b 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -145,5 +145,6 @@ IBMAD_1.3 {
>  		bm_call_via;
>  		mad_dump_port_ext_speeds_counters;
>  		cc_query_status_via;
> +		cc_config_status_via;
>  	local: *;
>  };
> -- 
> 1.7.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
