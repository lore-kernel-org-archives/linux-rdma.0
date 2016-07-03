From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/3] IB/core: Add optional AV attribute for Raw
 Packet QP in INIT to RTR
Date: Mon, 4 Jul 2016 00:51:00 +0300
Message-ID: <CAJ3xEMiaD99d96RKGwD3OpgEOn0RXjXoaRuFWT6PJdXQSOo5rQ@mail.gmail.com>
References: <1467549727-23479-1-git-send-email-leon@kernel.org> <1467549727-23479-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467549727-23479-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 3, 2016 at 3:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> In order to configure QoS for Raw Packet QP, the user passes the SL
> in the AV attribute when modifying the QP from INIT to RTR state.
>
> This SL is used later on to set the Ethernet Priority of the QP.
>
> Until today, we couldn't pass the AV attribute for Raw Packet QP
> because it was blocked in the QP state transition matrix. This
> patch adds the AV as optional in INIT to RTR.
>
> Fixes: 8a51866f0810 ('IB: Add ib_modify_qp_is_ok() library function')

This commit is 10y old and was done way before RAW Packet QP was added
to the kernel, please fix your Fixes: line...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
