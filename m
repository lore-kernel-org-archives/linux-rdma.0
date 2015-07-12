From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 04/12] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Sun, 12 Jul 2015 17:31:45 +0300
Message-ID: <55A27A51.9010203@dev.mellanox.co.il>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204218.26247.67243.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204218.26247.67243.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 11:42 PM, Chuck Lever wrote:
> All HCA providers have an ib_get_dma_mr() verb. Thus
> rpcrdma_ia_open() will either grab the device's local_dma_key if one
> is available, or it will call ib_get_dma_mr() which is a 100%
> guaranteed fallback. There is never any need to use the
> ib_reg_phys_mr() code path in rpcrdma_register_internal(), so it can
> be removed.
>
> The remaining logic in rpcrdma_{de}register_internal() is folded
> into rpcrdma_{alloc,free}_regbuf().
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Like,

Reviewed-By: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
