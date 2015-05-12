From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Tue, 12 May 2015 16:33:51 +0300
Message-ID: <5552013F.6060008@dev.mellanox.co.il>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com>	<1431432329-859-2-git-send-email-sagig@mellanox.com> <CAJ3xEMhOnrZJrUfwtMs7Tod7YeGy_Be6yF543+xds_05hO-F-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhOnrZJrUfwtMs7Tod7YeGy_Be6yF543+xds_05hO-F-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/12/2015 3:59 PM, Or Gerlitz wrote:
> On Tue, May 12, 2015 at 3:05 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Some of us keep revisiting the code to decode enumerations that
>> appear in out logs. Let's borrow the nice logging helpers that
>> exists in xprtrdma and rds for CMA events, IB events and WC statuses.
>
> [...]
>
>> +static const char * const cma_events[] = {
>> +       [RDMA_CM_EVENT_ADDR_RESOLVED]   = "ADDR_RESOLVED",
>> +       [RDMA_CM_EVENT_ADDR_ERROR]      = "ADDR_ERROR",
>> +       [RDMA_CM_EVENT_ROUTE_RESOLVED]  = "ROUTE_RESOLVED",
>> +       [RDMA_CM_EVENT_ROUTE_ERROR]     = "ROUTE_ERROR",
>> +       [RDMA_CM_EVENT_CONNECT_REQUEST] = "CONNECT_REQUEST",
>> +       [RDMA_CM_EVENT_CONNECT_RESPONSE]= "CONNECT_RESPONSE",
>> +       [RDMA_CM_EVENT_CONNECT_ERROR]   = "CONNECT_ERROR",
>> +       [RDMA_CM_EVENT_UNREACHABLE]     = "UNREACHABLE",
>> +       [RDMA_CM_EVENT_REJECTED]        = "REJECTED",
>> +       [RDMA_CM_EVENT_ESTABLISHED]     = "ESTABLISHED",
>> +       [RDMA_CM_EVENT_DISCONNECTED]    = "DISCONNECTED",
>> +       [RDMA_CM_EVENT_DEVICE_REMOVAL]  = "DEVICE_REMOVAL",
>> +       [RDMA_CM_EVENT_MULTICAST_JOIN]  = "MULTICAST_JOIN",
>> +       [RDMA_CM_EVENT_MULTICAST_ERROR] = "MULTICAST_ERROR",
>> +       [RDMA_CM_EVENT_ADDR_CHANGE]     = "ADDR_CHANGE",
>> +       [RDMA_CM_EVENT_TIMEWAIT_EXIT]   = "TIMEWAIT_EXIT",
>> +};
>
> Sagi,
>
> My vote goes to using easy-to-digest human-readable non-capital
> letters strings here and
> elsewhere (IB events, etc),  as done today by the NFS code and
> generally by errno based
> helpers such as strerror, e.g
>
> "address resolved"
> "address error"
> "route resolved"
>
> Will be happy to hear what others think

Let's do that before I post v6...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
