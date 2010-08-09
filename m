From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: ucma question - backlog limit
Date: Mon, 9 Aug 2010 19:06:05 +0200
Message-ID: <OFD9132F2D.FEEEA35D-ONC125777A.005D920E-C125777A.005DF132@ch.ibm.com>
References: <4C6011F7.3060209@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C6011F7.3060209-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think that could be relaxed.
Running OFED (and softiwarp) on larger installations,
we already had to set this to some KByte...

Bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 08/09/2010 04:34:31 PM:

> Hey Sean,
>
> What is the logic behind limiting the listen backlog to 128?
>
> ------
>
> snipit from ucma.c:
>
> enum {
>          UCMA_MAX_BACKLOG        = 128
> };
>
>
> snipit from ucma_listen():
>
>          ctx->backlog = cmd.backlog > 0 && cmd.backlog <
UCMA_MAX_BACKLOG ?
>                         cmd.backlog : UCMA_MAX_BACKLOG;
> ------
>
>
>
> Thanks,
>
> Steve.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
