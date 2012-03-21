From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH 4/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 13:16:44 -0500
Message-ID: <4F6A1B0C.2010505@systemfabricworks.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com> <1332283154-16369-2-git-send-email-parav.pandit@emulex.com> <1332283154-16369-3-git-send-email-parav.pandit@emulex.com> <1332283154-16369-4-git-send-email-parav.pandit@emulex.com> <a5e59a7c-d6ff-4c78-89a7-fad7492260b0@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a5e59a7c-d6ff-4c78-89a7-fad7492260b0-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/20/2012 05:39 PM, parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:
> From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

> +
> +int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev *dev, int fr_mr, u32 lkey)
> +{
> +	int status = -ENOMEM;
> +	struct ocrdma_dealloc_lkey *cmd;
> +
> +	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_DEALLOC_LKEY, sizeof(*cmd));
> +	if (!cmd)
> +		return -ENOMEM;
> +	cmd->lkey = lkey;
> +	cmd->rsvd_frmr = fr_mr ? 1 : 0;
> +	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> +	if (status)
> +		goto mbx_err;
> +mbx_err:

Missing return before the tag ? Or unnecessary goto.

> +	kfree(cmd);
> +	return status;
> +}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
