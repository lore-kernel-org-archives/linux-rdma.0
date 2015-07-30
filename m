From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/22] IB/iser: Get rid of un-maintained counters
Date: Thu, 30 Jul 2015 13:20:23 +0300
Message-ID: <CAJ3xEMj6Pupc0+ZqKEaB86kTcJq3P=Z1EoiH-EHzWuaznw48bQ@mail.gmail.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
	<1438243595-32288-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-6-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 11:06 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> We don't update those anywhere in the code and they
> seem pretty useless (no one seem to care about those).
>
> qp_tx_queue_full: We never should get this

why?

> fmr_map_not_avail: We can never get to this

why? if for some reason fmr pool thread which does unmapping on the
background is slowed/delayed? or the
device firmware/hardware is in troubles?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
