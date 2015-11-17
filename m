From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-next 07/10] iser-target: Declare correct flags when
 accepting a connection
Date: Tue, 17 Nov 2015 01:03:25 -0800
Message-ID: <20151117090325.GE19578@infradead.org>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-8-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447691861-3796-8-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +	struct iser_cm_hdr rsp_hdr;
>  
>  	memset(&cp, 0, sizeof(struct rdma_conn_param));
>  	cp.initiator_depth = isert_conn->initiator_depth;
>  	cp.retry_count = 7;
>  	cp.rnr_retry_count = 7;
>  
> +	memset(&rsp_hdr, 0, sizeof(rsp_hdr));
> +	rsp_hdr.flags = (ISERT_ZBVA_NOT_USED | ISERT_SEND_W_INV_NOT_USED);
> +	cp.private_data = (void *)&rsp_hdr;
> +	cp.private_data_len = sizeof(rsp_hdr);

Btw, where does iser_cm_hdr and these flags come from?  I can't find
anything like this in RFC7145.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
