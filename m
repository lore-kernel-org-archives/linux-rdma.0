From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 1/3] verbs: Enable creating QP with a given
 source QP number
Date: Thu, 7 Sep 2017 09:16:41 -0600
Message-ID: <20170907151641.GC20644@obsidianresearch.com>
References: <1504786327-820-1-git-send-email-yishaih@mellanox.com>
 <1504786327-820-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504786327-820-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 07, 2017 at 03:12:05PM +0300, Yishai Hadas wrote:
> diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
> index 99ae497..3272c09 100644
> +++ b/libibverbs/man/ibv_create_qp_ex.3
> @@ -38,6 +38,7 @@ enum ibv_qp_create_flags create_flags;	/* Creation flags for this QP */
>  uint16_t                max_tso_header; /* Maximum TSO header size */
>  struct ibv_rwq_ind_table *rwq_ind_tbl;  /* Indirection table to be associated with the QP */
>  struct ibv_rx_hash_conf  rx_hash_conf;  /* RX hash configuration to be used */
> +uint32_t                source_qpn;     /* Source QP number, creation flag IBV_QP_CREATE_SOURCE_QPN should be set */

I think more discussion in the man page is required for this
feature. Eg that it is a SEND ONLY QP and only works for UD.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
