From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: max_inline_data in ibv_rc_pingpong
Date: Sun, 25 Dec 2016 17:51:41 +0200
Message-ID: <a412a47f-74ad-cc09-4003-11b93e59f5f8@dev.mellanox.co.il>
References: <SN1PR07MB22079DB9A8D87699539DBB01F8970@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB22079DB9A8D87699539DBB01F8970-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/25/2016 1:48 PM, Amrani, Ram wrote:
> Hi Yishay, Doug,
> I've noticed something irregular in ibv_rc_pingpong and I see that you are listed as the maintainers of libibverbs.
> It seems that max_inline_data isn't configured prior to invoking ibv_create_qp(), but it is queried directly after.
> This means that for a value of zero it will always be zero, or very small, depending on the vendor implementation.
> Is there some background I'm missing?

Based on man page cap is an in/out structure
"..the values will be greater than or equal to the values requested".

The below example demonstrates a case that there is enough space for 
using inline data for the given input size. It may happen as of some 
alignment on the WQE calculated size and is based on vendor implementation.

In a real application usually an explicit value is set before calling 
ibv_create_qp to achieve a size that is required by the application for 
its needs.

>         {
>                 struct ibv_qp_attr attr;
>                 struct ibv_qp_init_attr init_attr = {
>                         .send_cq = ctx->cq,
>                         .recv_cq = ctx->cq,
>                         .cap     = {
>                                 .max_send_wr  = 1,
>                                 .max_recv_wr  = rx_depth,
>                                 .max_send_sge = 1,
>                                 .max_recv_sge = 1
>                         },
>                         .qp_type = IBV_QPT_RC
>                 };
>
>                 ctx->qp = ibv_create_qp(ctx->pd, &init_attr);
>                 if (!ctx->qp)  {
>                         fprintf(stderr, "Couldn't create QP\n");
>                         goto clean_cq;
>                 }
>
>                 ibv_query_qp(ctx->qp, &attr, IBV_QP_CAP, &init_attr);
>                 if (init_attr.cap.max_inline_data >= size) {
>                         ctx->send_flags |= IBV_SEND_INLINE;
>                 }
>         }
>
>
> Thanks,
> Ram
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
