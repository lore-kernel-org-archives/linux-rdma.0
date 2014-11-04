From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/addr: Improve address resolution callback scheduling
Date: Tue, 4 Nov 2014 06:28:57 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DFE135@ORSMSX109.amr.corp.intel.com>
References: <1414593124-9060-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414593124-9060-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Olga Shern <olgas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Kehati <ork-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Or Kehati <ork-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> As of the callback model, the address resolution logic always does
> context switch to a work-queue to deliver the address resolution event.
> 
> When the IP address is already cached in the system arp table,
> we're going through the following call chain:
> 
> rdma_resolve_ip --> addr_resolve (cache hit) -->
> 
> which ends up with doing:
> 
> queue_req --> set_timeout (now) --> mod_delayed_work(,, delay=1)
> 
> We actually do realize that the timeout should be zero, but the
> code forces it to a minimum of one jiffie.
> 
> Using one jiffie as the minimum delay value results in a less optimized
> scheduling of executing this work item by the workqueue, which on the
> below testbed costs about 3-4ms out of 12ms total time.
> 
> To fix that, we let the minimum delay to be zero. Note that the
> connect step times change too, as there are address resolution
> calls from that flow.
> 
> The results were taken from running both client and server on the
> same node, over mlx4 RoCE port.
> 
> before -->
> step              total ms     max ms     min us  us / conn
> create id    :        0.01       0.01       6.00       6.00
> resolve addr :        4.02       4.01    4013.00    4016.00
> resolve route:        0.18       0.18     182.00     183.00
> create qp    :        1.15       1.15    1150.00    1150.00
> connect      :        6.73       6.73    6730.00    6731.00
> disconnect   :        0.55       0.55     549.00     550.00
> destroy      :        0.01       0.01       9.00       9.00
> 
> after -->
> step              total ms     max ms     min us  us / conn
> create id    :        0.01       0.01       6.00       6.00
> resolve addr :        0.05       0.05      49.00      52.00
> resolve route:        0.21       0.21     207.00     208.00
> create qp    :        1.10       1.10    1104.00    1104.00
> connect      :        1.22       1.22    1220.00    1221.00
> disconnect   :        0.71       0.71     713.00     713.00
> destroy      :        0.01       0.01       9.00       9.00
> 
> Signed-off-by: Or Kehati <ork-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
