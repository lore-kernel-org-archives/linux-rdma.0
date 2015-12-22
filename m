From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Tue, 22 Dec 2015 09:17:27 +0200
Message-ID: <5678F907.7080300@mellanox.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450710084-22547-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/21/2015 5:01 PM, Matan Barak wrote:
> This patch fixes a bug in VPI systems, where the first port is configured
> as IB and the second one is configured as Ethernet. In this case, if the rdma_id isn't bounded to a port, cma_match_net_dev will try to verify that the first port is a RoCE port and fail. This is fixed by passing the port of the incoming request.

OK -- we have another bug down there, cma loopback doesn't work, same 
reject reason (below).This happens in both VPI and non-VPI configurations.

Works well with 4.2.3

Or.


$ rping -d -v -c -a 127.0.0.1 -C 1
verbose
client
count 1
created cm_id 0x6087d0
cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x6087d0 (parent)
cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x6087d0 (parent)
rdma_resolve_addr - rdma_resolve_route successful
created pd 0x60e5f0
created channel 0x608250
created cq 0x608a20
created qp 0x6082e0
rping_setup_buffers called on cb 0x606010
allocated & registered buffers...
cq_thread started.
wait for CONNECTED state 10
cma_event type RDMA_CM_EVENT_REJECTED cma_id 0x6087d0 (parent)
cma event RDMA_CM_EVENT_REJECTED, error 28
connect error -1
rping_free_buffers called on cb 0x606010
destroy cm_id 0x6087d0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
