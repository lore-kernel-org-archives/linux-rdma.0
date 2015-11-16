From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 4/9] IB: remove in-kernel support for memory windows
Date: Mon, 16 Nov 2015 18:02:58 +0100
Message-ID: <20151116170258.GA32300@lst.de>
References: <1447610762-3781-1-git-send-email-hch@lst.de> <1447610762-3781-5-git-send-email-hch@lst.de> <564A0B96.5010703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564A0B96.5010703-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2015 at 07:00:06PM +0200, Sagi Grimberg wrote:
>
>> Remove the unused ib_allow_mw and ib_bind_mw functions, remove the
>> unused IB_WR_BIND_MW and IB_WC_BIND_MW opcodes and move ib_dealloc_mw
>> into the uverbs module.
>>
>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>
> Will the user-space drivers posting via uverbs (qib, hfi, rxe) need the
> post_send interface?

BIND_MW hasn't ever been supported through post_send as far as I can
tell, and started explicitly rejecting it a while ago.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
