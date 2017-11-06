From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: remove BUG_ON() usage.
Date: Mon, 6 Nov 2017 09:23:48 -0500
Message-ID: <e0576722-2c47-9020-34b4-dea7983600a9@intel.com>
References: <20171103195527.E4AE72BC82@smtp.opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103195527.E4AE72BC82-ff04S8wfc4plDsoTORJclLwze2ij/50Q0E9HWUfgJXw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/2/2017 5:11 PM, Steve Wise wrote:
> iw_cxgb4 has many BUG_ON()s that were left over from various enhancemnets
> made over the years.  Almost all of them should just be removed.  Some,
> however indicate a ULP usage error and can be handled w/o bringing down
> the system.
> 
> If the condition cannot happen with correctly implemented cxgb4 sw/fw,
> then remove the BUG_ON.
> 
> If the condition indicates a misbehaving ULP (like CQ overflows), add
> proper recovery logic.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c       | 25 +++++++++----------------
>   drivers/infiniband/hw/cxgb4/cq.c       | 10 ----------
>   drivers/infiniband/hw/cxgb4/id_table.c |  1 -
>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 -
>   drivers/infiniband/hw/cxgb4/provider.c |  4 ++--
>   drivers/infiniband/hw/cxgb4/qp.c       |  3 ---
>   drivers/infiniband/hw/cxgb4/t4.h       |  7 ++-----
>   7 files changed, 13 insertions(+), 38 deletions(-)

Awesome to see these go away.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
