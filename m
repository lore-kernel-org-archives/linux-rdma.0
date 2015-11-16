From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/9] IB: remove in-kernel support for memory windows
Date: Mon, 16 Nov 2015 20:33:43 +0200
Message-ID: <564A2187.3060000@dev.mellanox.co.il>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
 <1447610762-3781-5-git-send-email-hch@lst.de>
 <564A0B96.5010703@dev.mellanox.co.il> <20151116170258.GA32300@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151116170258.GA32300-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 16/11/2015 19:02, Christoph Hellwig wrote:
> On Mon, Nov 16, 2015 at 07:00:06PM +0200, Sagi Grimberg wrote:
>>
>>> Remove the unused ib_allow_mw and ib_bind_mw functions, remove the
>>> unused IB_WR_BIND_MW and IB_WC_BIND_MW opcodes and move ib_dealloc_mw
>>> into the uverbs module.
>>>
>>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>>
>> Will the user-space drivers posting via uverbs (qib, hfi, rxe) need the
>> post_send interface?
>
> BIND_MW hasn't ever been supported through post_send as far as I can
> tell, and started explicitly rejecting it a while ago.

I think there are users for bind_mw in user-space, and I think there is
code that should go upstream soon. The question is weather qib/hfi/rxe
will need it anytime soon (otherwise we can restore them later on as
uverbs support does not exist anyway...)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
