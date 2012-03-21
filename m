From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH 6/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 12:42:38 -0500
Message-ID: <4F6A130E.2030602@systemfabricworks.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com> <1332283154-16369-2-git-send-email-parav.pandit@emulex.com> <1332283154-16369-3-git-send-email-parav.pandit@emulex.com> <1332283154-16369-4-git-send-email-parav.pandit@emulex.com> <1332283154-16369-5-git-send-email-parav.pandit@emulex.com> <1332283154-16369-6-git-send-email-parav.pandit@emulex.com> <5abe3043-81f8-448a-9e55-b29e23f4eb9a@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5abe3043-81f8-448a-9e55-b29e23f4eb9a-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/20/2012 05:39 PM, parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:
> +struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *ibpd, int acc)
> +{
> +	struct ocrdma_mr *mr;
> +
> +	mr = ocrdma_alloc_lkey(ibpd, acc, 0, OCRDMA_ADDR_CHECK_DISABLE);
> +	if (!mr)
> +		return ERR_PTR(-ENOMEM);

ocrdma_alloc_lkey does not return NULL on error.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
