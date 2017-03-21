From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v1 02/14] svcrdma: Add svc_rdma_map_reply_hdr()
Date: Tue, 21 Mar 2017 19:54:44 +0200
Message-ID: <f5000e25-6ca1-fc24-35c0-6089cf50923c@grimberg.me>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
 <20170316155242.4482.64809.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316155242.4482.64809.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>  	svc_rdma_build_send_wr(ctxt, 1);
>  	ret = svc_rdma_send(rdma, &ctxt->send_wr);
>  	if (ret) {
> +		svc_rdma_unmap_dma(ctxt);
> +		svc_rdma_put_context(ctxt, 1);
>  		ret = -EIO;
> -		goto out_unmap;
>  	}

Any specific reason to not go with the goto scheme?
Can't this function grow more error paths in the future?

btw, I'm assuming svc_rdma_unmap_dma() is the opposite of
svc_rdma_map_reply_hdr() ?
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
