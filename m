From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 01/13] svcrdma: Move send_wr to svc_rdma_op_ctxt
Date: Thu, 30 Mar 2017 05:06:39 -0700
Message-ID: <20170330120639.GA31144@infradead.org>
References: <20170327132329.5585.98465.stgit@klimt.1015granger.net>
 <20170327134802.5585.70150.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170327134802.5585.70150.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +	svc_rdma_build_send_wr(ctxt, sge_no);
> +	send_wr = &ctxt->send_wr;
> +	if (inv_rkey) {
> +		send_wr->opcode = IB_WR_SEND_WITH_INV;
> +		send_wr->ex.invalidate_rkey = inv_rkey;
> +	}

Seems a bit odd to overwrite the work that svc_rdma_build_send_wr in
the caller.  I would propbably add this work to svc_rdma_build_send_wr.

Also any reason svc_rdma_build_send_wr can't call svc_rdma_send
directly (although it would probably need a new name then)?
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
