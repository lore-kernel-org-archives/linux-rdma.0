From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Wed, 24 Jun 2015 15:38:33 +0300
Message-ID: <CAJ3xEMjrVNK-APZHpU9o1diwFX99weYaUq=bFhiUmrEr41xpjA@mail.gmail.com>
References: <1432028899-15211-1-git-send-email-sagig@mellanox.com>
	<1432028899-15211-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432028899-15211-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 12:48 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> +++ b/drivers/infiniband/core/cma.c

> +const char *rdma_event_msg(enum rdma_cm_event_type event)
> +{
> +       size_t index = event;
> +
> +       return (index < ARRAY_SIZE(cma_events) && cma_events[index]) ?
> +                       cma_events[index] : "unrecognized event";
> +}
> +EXPORT_SYMBOL(rdma_event_msg);

I am getting the following warning from sparse,

drivers/infiniband/core/cma.c:87:12: error: symbol 'rdma_event_msg'
redeclared with different type (originally declared at
include/rdma/rdma_cm.h:65) - different modifiers

worth looking and fixing

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
