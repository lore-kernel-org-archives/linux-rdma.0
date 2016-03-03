From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Convert UMR CQ to new CQ API
Date: Thu, 3 Mar 2016 11:06:27 +0200
Message-ID: <56D7FE93.9020503@dev.mellanox.co.il>
References: <1456565984-28998-1-git-send-email-hch@lst.de>
 <1456565984-28998-2-git-send-email-hch@lst.de>
 <56D2D731.5060904@dev.mellanox.co.il> <56D3F1EA.9090800@mellanox.com>
 <20160303083822.GB13828@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160303083822.GB13828-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Thanks for the review Haggai.  I noticed I left a stray
> ib_req_notify_cq in the code, which is harmless but not needed with
> the new API.  Patch with that one line updated below.
>
> Doug, can you picks this up for the mlx5 branch?

The patch looks fine to me too,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
