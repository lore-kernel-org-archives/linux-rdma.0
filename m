From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Fix for notify send CQ failure messages
Date: Wed, 3 Jan 2018 11:33:05 +0200
Message-ID: <CAAk-MO_ArzS5irkN-_nt_YYL3+YgL+FpM6WLvPZfM-mKexsShg@mail.gmail.com>
References: <20180102210419.26104.32513.stgit@phlsvlogin03.ph.intel.com> <20180102212407.GA19027@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102212407.GA19027-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 2, 2018 at 11:24 PM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Jan 02, 2018 at 04:04:20PM -0500, Alex Estrin wrote:
>> If IB_CQ_REPORT_MISSED_EVENTS flag is passed in ib_req_notify_cq()
>> it may return positive value indicating non-empty CQ.
>> If return code not verified the log might be flooded with false
>> warning messages "request notify on send CQ failed".
>>
>> Fixes: commit 8966e28d2e40 ("IB/ipoib: Use NAPI in UD/TX flows")
>
> Hurm... It was right before that commit as well..
>
> Erez, why did you change it?

I don't think i changed it.

anyway, Alex's patch makes sense, even it is a rare case anyway, and
no flooded will happened.

>
> +               if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP |
> +                                    IB_CQ_REPORT_MISSED_EVENTS)) {
> +                       ipoib_warn(priv, "IPoIB/CM:request notify on send CQ failed\n");
> ...
> -                       rc = ib_req_notify_cq(priv->send_cq,
> -                               IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
> -                       if (rc < 0)
> -                               ipoib_warn(priv, "request notify on send CQ failed\n");
>
> Alex, that is not the right format for the Fixes: line..
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
