From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Tue, 22 Dec 2015 16:42:40 +0200
Message-ID: <56796160.60007@mellanox.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
 <5678F907.7080300@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5678F907.7080300-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/22/2015 9:17 AM, Or Gerlitz wrote:
> On 12/21/2015 5:01 PM, Matan Barak wrote:
>> This patch fixes a bug in VPI systems, where the first port is 
>> configured
>> as IB and the second one is configured as Ethernet. In this case, if 
>> the rdma_id isn't bounded to a port, cma_match_net_dev will try to 
>> verify that the first port is a RoCE port and fail. This is fixed by 
>> passing the port of the incoming request.
>
> OK -- we have another bug down there, cma loopback doesn't work, same 
> reject reason (below).This happens in both VPI and non-VPI 
> configurations.
>
> Works well with 4.2.3

I made more checks with the 4.2.3 kernel (before all the IB core/cache 
changes that went in 4.3) -- rdma-cm loopback does work as long as there 
are active IB ports in the system. When there are no active IB ports, 
but rather only Eth ports (VPI or plain Eth), rping fails:

# rping -d -v -c -a 127.0.0.1 -C 1
created cm_id 0x6087d0
cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x6087d0 (parent)
rdma_resolve_route: No such device


so it seems we had something there before the 4.3 changes.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
