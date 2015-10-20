From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Tue, 20 Oct 2015 15:00:57 +0300
Message-ID: <56262CF9.1040509@dev.mellanox.co.il>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
 <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151012144212.GB24770-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So this patch seems to work well for me. I've ran some kernel
applications (ipoib, iser, srp, nfs) and a user-space application
(ibsrpdm) over mlx4/mlx5 and didn't spot any issues.

I think this is very useful to have and I'd love having it in 4.4,
does anyone have any other comments on this patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
