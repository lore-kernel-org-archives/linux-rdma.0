From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2] libibmad: Add NodeRecord query API
Date: Thu, 14 Feb 2013 18:44:42 -0800
Message-ID: <20130214184442.955559f1ffc96fd3d2412bc8@llnl.gov>
References: <511C367D.9020904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511C367D.9020904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 13 Feb 2013 19:57:33 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> Change since v1:
> Added change to libibmad.ver
> 
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 0694dc4..18ba6d8 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -65,6 +65,7 @@ BEGIN_C_DECLS
>  #define IB_PC_DATA_SZ		(IB_MAD_SIZE - IB_PC_DATA_OFFS)
>  #define IB_SA_MCM_RECSZ		53
>  #define IB_SA_PR_RECSZ		64
> +#define IB_SA_NR_RECSZ		108
>  #define IB_SA_GIR_RECSZ		72
>  #define IB_BM_DATA_OFFS		64
>  #define IB_BM_DATA_SZ		(IB_MAD_SIZE - IB_BM_DATA_OFFS)
> @@ -1519,6 +1520,9 @@ MAD_EXPORT int ib_path_query_via(const struct
> ibmad_port *srcport,
>  				 ibmad_gid_t srcgid, ibmad_gid_t destgid,
>  				 ib_portid_t * sm_id, void *buf);
>  	/* returns lid */
> +MAD_EXPORT int ib_node_query_via(const struct ibmad_port *srcport,
> +				 uint64_t guid, ib_portid_t * sm_id,
> +				 void *buf);
> 
>  /* resolve.c */
>  MAD_EXPORT int ib_resolve_smlid(ib_portid_t * sm_id, int timeout)
> DEPRECATED;
> diff --git a/libibmad.ver b/libibmad.ver
> index 7315f62..11698ff 100644
> --- a/libibmad.ver
> +++ b/libibmad.ver
> @@ -6,4 +6,4 @@
>  # API_REV - advance on any added API
>  # RUNNING_REV - advance any change to the vendor files
>  # AGE - number of backward versions the API still supports
> -LIBVERSION=8:1:3
> +LIBVERSION=9:0:4
> diff --git a/src/libibmad.map b/src/libibmad.map
> index a4d4418..5ad3dba 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -148,5 +148,6 @@ IBMAD_1.3 {
>  		cc_config_status_via;
>  		smp_mkey_get;
>  		smp_mkey_set;
> +		ib_node_query_via;
>  	local: *;
>  };
> diff --git a/src/sa.c b/src/sa.c
> index a9a93cc..352ed9f 100644
> --- a/src/sa.c
> +++ b/src/sa.c
> @@ -145,3 +145,47 @@ int ib_path_query(ibmad_gid_t srcgid, ibmad_gid_t
> destgid, ib_portid_t * sm_id,
>  {
>  	return ib_path_query_via(ibmp, srcgid, destgid, sm_id, buf);
>  }
> +
> +/* NodeRecord */
> +#define IB_NR_COMPMASK_LID				(1ull<<0)
> +#define IB_NR_COMPMASK_RESERVED1			(1ull<<1)
> +#define IB_NR_COMPMASK_BASEVERSION			(1ull<<2)
> +#define IB_NR_COMPMASK_CLASSVERSION			(1ull<<3)
> +#define IB_NR_COMPMASK_NODETYPE				(1ull<<4)
> +#define IB_NR_COMPMASK_NUMPORTS				(1ull<<5)
> +#define IB_NR_COMPMASK_SYSIMAGEGUID			(1ull<<6)
> +#define IB_NR_COMPMASK_NODEGUID				(1ull<<7)
> +#define IB_NR_COMPMASK_PORTGUID				(1ull<<8)
> +#define IB_NR_COMPMASK_PARTCAP				(1ull<<9)
> +#define IB_NR_COMPMASK_DEVID				(1ull<<10)
> +#define IB_NR_COMPMASK_REV				(1ull<<11)
> +#define IB_NR_COMPMASK_PORTNUM				(1ull<<12)
> +#define IB_NR_COMPMASK_VENDID				(1ull<<13)
> +#define IB_NR_COMPMASK_NODEDESC				(1ull<<14)
> +
> +#define IB_NR_DEF_MASK IB_NR_COMPMASK_PORTGUID
> +
> +int ib_node_query_via(const struct ibmad_port *srcport, uint64_t guid,
> +		      ib_portid_t * sm_id, void *buf)
> +{
> +	ib_sa_call_t sa = { 0 };
> +	uint8_t *p;
> +
> +	memset(&sa, 0, sizeof sa);
> +	sa.method = IB_MAD_METHOD_GET;
> +	sa.attrid = IB_SA_ATTR_NODERECORD;
> +	sa.mask = IB_NR_DEF_MASK;
> +	sa.trid = mad_trid();
> +
> +	memset(buf, 0, IB_SA_NR_RECSZ);
> +
> +	mad_encode_field(buf, IB_SA_NR_PORT_GUID_F, &guid);
> +
> +	p = sa_rpc_call(srcport, buf, sm_id, &sa, 0);
> +	if (!p) {
> +		IBWARN("sa call node_query failed");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
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
