From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/isert: properly type the login buffer
Date: Tue, 16 Feb 2016 06:40:58 +0200
Message-ID: <20160216044058.GA27580@leon.nu>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-2-git-send-email-hch@lst.de>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455567060-18381-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 15, 2016 at 09:10:57PM +0100, Christoph Hellwig wrote:
>  
> -	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
> -					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
> -	if (!isert_conn->login_buf) {
> -		isert_err("Unable to allocate isert_conn->login_buf\n");
> +	isert_conn->login_req_buf =
> +		kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
> +	if (!isert_conn->login_req_buf) {
> +		isert_err("Unable to allocate isert_conn->login_req_buf\n");

Please don't print additional allocation failure messages after
kzalloc/kmalloc.

It is relevant to all places in this patch.

>  		return -ENOMEM;
>  	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
