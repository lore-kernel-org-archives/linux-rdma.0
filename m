From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Fri, 09 Mar 2012 07:59:58 -0500
Message-ID: <4F59FECE.4030107@dev.mellanox.co.il>
References: <1331064594.10889.8.camel@auk75.llnl.gov> <1331071949.17729.11.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331071949.17729.11.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/6/2012 5:12 PM, Jim Foraker wrote:

What mkey model is being proposed here ? It looks to me like it is a
single mkey for all ports in the subnet which is the simplest but least
flexible model. If so, I think we need something more flexible as IBA
allows each port to have it's own different mkey.

> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/infiniband/mad.h |    2 ++
>  src/libibmad.map         |    2 ++
>  src/mad_internal.h       |    1 +
>  src/smp.c                |   12 ++++++++++++
>  4 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 5d62307..278b9bc 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -1489,6 +1489,8 @@ MAD_EXPORT uint8_t *smp_set_status_via(void *data, ib_portid_t * portid,
>  				       unsigned attrid, unsigned mod,
>  				       unsigned timeout, int *rstatus,
>  				       const struct ibmad_port *srcport);
> +MAD_EXPORT void smp_mkey_set(struct ibmad_port *srcport, uint64_t mkey);
> +MAD_EXPORT uint64_t smp_mkey_get(const struct ibmad_port *srcport);
>  
>  /* cc.c */
>  MAD_EXPORT void *cc_query_status_via(void *rcvbuf, ib_portid_t * portid,
> diff --git a/src/libibmad.map b/src/libibmad.map
> index 7c7587b..a4d4418 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -146,5 +146,7 @@ IBMAD_1.3 {
>  		mad_dump_port_ext_speeds_counters;
>  		cc_query_status_via;
>  		cc_config_status_via;
> +		smp_mkey_get;
> +		smp_mkey_set;
>  	local: *;
>  };
> diff --git a/src/mad_internal.h b/src/mad_internal.h
> index 3c32d10..5deac27 100644
> --- a/src/mad_internal.h
> +++ b/src/mad_internal.h
> @@ -40,6 +40,7 @@ struct ibmad_port {
>  	int port_id;		/* file descriptor returned by umad_open() */
>  	int class_agents[MAX_CLASS];	/* class2agent mapper */
>  	int timeout, retries;
> +	uint64_t smp_mkey;

Is this mkey for this port or all ports in the subnet ? Looks to me from
usage that it's all ports in the subnet.

-- Hal

>  };
>  
>  extern struct ibmad_port *ibmp;
> diff --git a/src/smp.c b/src/smp.c
> index a337663..14c74ed 100644
> --- a/src/smp.c
> +++ b/src/smp.c
> @@ -46,6 +46,16 @@
>  #undef DEBUG
>  #define DEBUG 	if (ibdebug)	IBWARN
>  
> +void smp_mkey_set(struct ibmad_port *srcport, uint64_t mkey)
> +{
> +	srcport->smp_mkey = mkey;
> +}
> +
> +uint64_t smp_mkey_get(const struct ibmad_port *srcport)
> +{
> +	return srcport->smp_mkey;
> +}
> +
>  uint8_t *smp_set_status_via(void *data, ib_portid_t * portid, unsigned attrid,
>  			    unsigned mod, unsigned timeout, int *rstatus,
>  			    const struct ibmad_port *srcport)
> @@ -67,6 +77,7 @@ uint8_t *smp_set_status_via(void *data, ib_portid_t * portid, unsigned attrid,
>  	rpc.timeout = timeout;
>  	rpc.datasz = IB_SMP_DATA_SIZE;
>  	rpc.dataoffs = IB_SMP_DATA_OFFS;
> +	rpc.mkey = srcport->smp_mkey;
>  
>  	portid->sl = 0;
>  	portid->qp = 0;
> @@ -105,6 +116,7 @@ uint8_t *smp_query_status_via(void *rcvbuf, ib_portid_t * portid,
>  	rpc.timeout = timeout;
>  	rpc.datasz = IB_SMP_DATA_SIZE;
>  	rpc.dataoffs = IB_SMP_DATA_OFFS;
> +	rpc.mkey = srcport->smp_mkey;
>  
>  	if ((portid->lid <= 0) ||
>  	    (portid->drpath.drslid == 0xffff) ||

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
