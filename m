From: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA CM EVENT rejected with status = 4 (timeout)
Date: Fri, 23 Aug 2013 12:42:24 -0700
Message-ID: <CABqF1pZPX_WovmcgQ37LXnzXUYw+ADUxx=v7a6Ao_Rr15WmgcQ@mail.gmail.com>
References: <CABqF1pZSmv1S-07pGxwoSaLB7zYWRhuFxiAtz6S-hFYtyEOY5w@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA7FBA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA7FBA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,
Can you point me to the patch that fixes this..? I am using ofed 1.5.5 bits...

-Lokesh


On Fri, Aug 23, 2013 at 12:27 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> P1-> addr_resolve()
>>       select(cm_event_fd)
>>       gets RDMA_CM_ADDR_RESOLVED
>>
>>        rout_resolve()
>>        gets RDMA_CM_ROUTE_RESOLVE
>>
>>        connect():
>>
>> P2: Gets Connect request
>>
>> P1: -> Dies
>
> When process 1 dies after trying to establish a connection, this generates a connection reject.  This notifies the remote side that the connection request has been aborted.
>
> The destruction of the cm_id on process 2 should remove all unreported events for that id.
>
> There was a kernel bug that could result in reporting events like you are seeing, but that was fixed a while ago.  If you're running an older kernel, this could be the reason you see the unexpected event.
>
> - Sean



-- 
Lokesh Agarwal
Member of Technical Staff
Oracle Corporation
400 Oracle Pkwy, #1347
Redwood City
94065
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
