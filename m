From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Wed, 21 Jul 2010 10:48:40 -0500
Message-ID: <4C4716D8.2040902@opengridcomputing.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com>	<20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com> <4C45E701.7030501@opengridcomputing.com> <4C47053B.3000802@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C47053B.3000802-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Steve Wise wrote:
>   
>> The cxgb3/4 drivers do not set IFF_NOARP and rely on ND being done as
>> part of connection setup.  The driver will initiate ND if there isn't a
>> neigh entry available at the time the iwarp driver tries to send a SYN or SYN/ACK.  
>>     
>
> okay, understood, thanks for clarifying this out.
>
>   
>> The cxgb* drivers actually reference the neigh and dst structs until the
>> offload connection is gone.  Also if the the offloaded connection has
>> problems transmitting (due to a L2 address change, for example), then
>> the driver will initiate ND again by calling neigh_event_send().  See
>> t4_l2t_send_event() in l2t.c which is called by the iwarp driver in
>> peer_abort() from iwch_cm.c when the HW tells us its retransmitting too much.
>>     
>
> In the general case of rdma-cm consumer, e.g IB RC based and/or UD unicast based, 
> we don't have such feedback mechanism from the HW. As such, I would draw the line here around adopting into the rdma-cm the behavior of referencing the neigh and dst structures until the connection is gone (could you point on the func/path in drivers/net/cxgb3/l2t.c which does this? i wasn't sure).
>
>   


Actually the dst entry ref/deref is really done in iw_cxgb3.  The 
dst/neigh entries are referenced in iwch_connect() and pass_accept_req() 
by calling ip_route_output() via find_route().  They are released in 
__free_ep() when the endpoint is finally freed after connection shutdown.


The L2T code deals with maintaining the HW L2 entries and dealing with 
neighbour change events from the kernel.



Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
