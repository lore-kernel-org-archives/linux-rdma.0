From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 03:25:37 -0800
Message-ID: <20151110112537.GA8991@infradead.org>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447152255-28231-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 12:44:13PM +0200, Sagi Grimberg wrote:
> Different devices may require different access permissions
> for rdma reads e.g. for Infiniband devices, local write access
> suffices while iWARP devices require remote write permissions as
> well.
> 
> This situation generates extra logic for ULPs that need to be aware
> of the underlying device to determine rdma read access. Instead,
> add a device attribute for ULPs to use without being aware of the
> underlying device.
> 
> Also, set rdma_read_access_flags in the relevant device drivers:
> mlx4, mlx5, qib, ocrdma, nes: IB_ACCESS_LOCAL_WRITE
> cxgb3, cxgb4, hfi: IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE

>From all I can tell nes also is a iWarp driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
