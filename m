From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/isert: Convert to new CQ API
Date: Wed, 24 Feb 2016 18:01:27 +0200
Message-ID: <56CDD3D7.7060408@dev.mellanox.co.il>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456148958-27973-4-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> -isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
> +isert_print_wc(struct ib_wc *wc)
> +{
> +	if (wc->status != IB_WC_WR_FLUSH_ERR)
> +		isert_err("%s (%d): cqe 0x%p vend_err %x\n",
> +			  ib_wc_status_msg(wc->status), wc->status,
> +			  wc->wr_cqe, wc->vendor_err);
> +	else
> +		isert_dbg("%s (%d): cqe 0x%p\n",
> +			  ib_wc_status_msg(wc->status), wc->status,
> +			  wc->wr_cqe);
> +
> +}

I don't find the wr_cqe address all that useful. I modified
isert_print_wc to get a error type instead ("send", "recv", "rdma
write"...) sounds fine?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
