From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: rdma_connect() "timeout"
Date: Wed, 18 Jul 2012 17:12:52 +0200
Message-ID: <1342624372.19395.35.camel@test.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Is there a way to setup the timeout in rdma_connect() ?

I'm testing something not really useful: to trigger connection error,
I'm asking to connect to the network address or the broadcast address,
for example 10.0.0.0/8 or 10.255.255.255/8.

I'm creating an RDMA_CM identifier for the RDMA_PS_TCP port space.

rdma_resolve_addr() is OK, I'm getting RDMA_CM_EVENT_ADDR_RESOLVED
event.
rdma_resolve_route() is OK, I'm getting RDMA_CM_EVENT_ROUTE_RESOLVED
event.
rdma_connect() is OK ... but I'm getting RDMA_CM_EVENT_UNREACHABLE event
about 98 seconds after calling rdma_connect().

And 98 seconds is a bit longer than I expected.

Is there a way to change the CM parameters ? e.g. "Service Timeout" to
wait for moving from "REP wait" state to "Timeout" state, and the number
of send "REQ" retries (From 12.9.5 "Communication Establishement and
Release - Active") ?

Is struct rdma_conn_param.retry_count the number of "REQ" retries ?
According to the manpage, it seems it doesn't apply to CM.

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
