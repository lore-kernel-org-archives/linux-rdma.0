From: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
Date: Fri, 13 Nov 2015 18:07:48 +0530
Message-ID: <1447418268-3177-1-git-send-email-saurabh.truth@gmail.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB1857D86D@CRSMSX101.amr.corp.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB1857D86D-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 13 Nov 2015  at 10:47:52 +0000, Wan, Kaike wrote:
> I don't think so.
> The following patch has rendered this patch unnecessary:
> https://patchwork.kernel.org/patch/7526811/
> Kaike

OK, could you please use "Reported-by" tag of my name in your patch

Regards,
Saurabh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
