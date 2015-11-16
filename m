From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/9] IB: remove in-kernel support for memory windows
Date: Mon, 16 Nov 2015 19:00:06 +0200
Message-ID: <564A0B96.5010703@dev.mellanox.co.il>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
 <1447610762-3781-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447610762-3781-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Remove the unused ib_allow_mw and ib_bind_mw functions, remove the
> unused IB_WR_BIND_MW and IB_WC_BIND_MW opcodes and move ib_dealloc_mw
> into the uverbs module.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Will the user-space drivers posting via uverbs (qib, hfi, rxe) need the
post_send interface?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
