From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 6/6] IB/uapi: expose device capability flags
Date: Thu, 31 Dec 2015 17:17:44 +0200
Message-ID: <56854718.7080505@mellanox.com>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450967967-12479-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 24/12/2015 16:39, Christoph Hellwig wrote:
> Expose the device capability flags which can be queried through uverbs in
> the uapi headers.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h      | 94 +++++++++++++++-----------------------------
>  include/uapi/rdma/ib_verbs.h | 66 +++++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+), 62 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 48bfcf5..b8d4113 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -151,68 +151,38 @@ enum rdma_link_layer {
>  };
>  
>  enum ib_device_cap_flags {
> -	IB_DEVICE_RESIZE_MAX_WR			= (1 << 0),
> -	IB_DEVICE_BAD_PKEY_CNTR			= (1 << 1),
> -	IB_DEVICE_BAD_QKEY_CNTR			= (1 << 2),
> -	IB_DEVICE_RAW_MULTI			= (1 << 3),
> -	IB_DEVICE_AUTO_PATH_MIG			= (1 << 4),
> -	IB_DEVICE_CHANGE_PHY_PORT		= (1 << 5),
> -	IB_DEVICE_UD_AV_PORT_ENFORCE		= (1 << 6),
> -	IB_DEVICE_CURR_QP_STATE_MOD		= (1 << 7),
> -	IB_DEVICE_SHUTDOWN_PORT			= (1 << 8),
> -	IB_DEVICE_INIT_TYPE			= (1 << 9),
> -	IB_DEVICE_PORT_ACTIVE_EVENT		= (1 << 10),
> -	IB_DEVICE_SYS_IMAGE_GUID		= (1 << 11),
> -	IB_DEVICE_RC_RNR_NAK_GEN		= (1 << 12),
> -	IB_DEVICE_SRQ_RESIZE			= (1 << 13),
> -	IB_DEVICE_N_NOTIFY_CQ			= (1 << 14),
> -
> -	/*
> -	 * This device supports a per-device lkey or stag that can be
> -	 * used without performing a memory registration for the local
> -	 * memory.  Note that ULPs should never check this flag, but
> -	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> -	 * which will always contain a usable lkey.
> -	 */
> -	IB_DEVICE_LOCAL_DMA_LKEY		= (1 << 15),
> -	IB_DEVICE_RESERVED /* old SEND_W_INV */	= (1 << 16),

Was this ever used by user-space? If so, I think there should be a 
comment saying that bit 16 is reserved, perhaps pointing to commit 
0f39cf3d54e6 ("IB/core: Add support for "send with invalidate" work 
requests").

> +	/*
> +	 * This device supports a per-device lkey or stag that can be
> +	 * used without performing a memory registration for the local
> +	 * memory.  Note that ULPs should never check this flag, but
> +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> +	 * which will always contain a usable lkey.
> +	 */
> +	IB_UVERBS_DEVICE_LOCAL_DMA_LKEY		= (1 << 15),
I don't think user-space should be able to use local_dma_lkey.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
