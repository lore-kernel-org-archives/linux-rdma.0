From: Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] libibverbs: Add support for XRC QPs
Date: Thu, 16 Jun 2011 13:04:19 +0300
Message-ID: <201106161304.19939.dotanb@sw.voltaire.com>
References: <1828884A29C6694DAF28B7E6B8A8237302124E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302124E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.
I noticed minor issue:

> @@ -564,6 +597,16 @@ struct ibv_srq {
>  	pthread_mutex_t		mutex;
>  	pthread_cond_t		cond;
>  	uint32_t		events_completed;
> +
> +	/* Following fields only available if device supports extensions */
> +	enum ibv_srq_type	srq_type;
> +	union {
> +		struct {
> +			uint32_t	 srq_num;
> +			struct ibv_xrcd *xrcd;
> +			struct ibv_cq   *cq;
> +		} xrc;
> +	} ext;
>  };

Should the following struct be used instead of the suggested struct above? 

	struct {
		struct ibv_xrcd *xrcd;
		struct ibv_cq   *cq;
		uint32_t	 srq_num;
	} xrc;

(attributes were rearranged according to their size).


Thanks
Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
