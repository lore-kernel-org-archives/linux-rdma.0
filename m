From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Mon, 12 Oct 2015 16:42:12 +0200
Message-ID: <20151012144212.GB24770@lst.de>
References: <1444633078-27166-1-git-send-email-hch@lst.de> <561B7CAE.3040505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561B7CAE.3040505-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2015 at 12:26:06PM +0300, Sagi Grimberg wrote:
> First go with this looks OK for mlx4. mlx5 needs the below incremental
> patch to be folded in.
>
> we need dev->ib_dev.max_pkeys set when get_port_caps() is called.

Thanks, I've folded your patch and force pushed out the updated tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
