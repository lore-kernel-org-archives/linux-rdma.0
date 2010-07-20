From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Tue, 20 Jul 2010 14:20:21 -0500
Message-ID: <4C45F6F5.6050008@opengridcomputing.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com> <20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com> <4C45E701.7030501@opengridcomputing.com> <20100720184620.GJ7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100720184620.GJ7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Tue, Jul 20, 2010 at 01:12:17PM -0500, Steve Wise wrote:
>
>   
>> The cxgb* drivers actually reference the neigh and dst structs until the  
>> offload connection is gone.  Also if the the offloaded connection has  
>> problems transmitting (due to a L2 address change, for example), then  
>> the driver will initiate ND again by calling neigh_event_send().  See  
>> t4_l2t_send_event() in l2t.c which is called by the iwarp driver in  
>> peer_abort() from iwch_cm.c when the HW tells us its retransmitting too  
>> much.
>>     
> 0
> That strikes me as mildly scary.. The cxgb can't possibly get the
> right dst (ie, the same dst that the RDMA CM got) in all the corner
> cases? Ie how can setting oif to 0 in iwch_cm.c:find_route be right??
>
>   


I guess it should be using the oif from the cm_id?


> So, looks like there is a larger cleanup here, if the RDMACM holds the
> dst and has functions to freshen it/track it then the iwarp driver
> should rely on the RDMACM to manage the dst..
>
> In other words, moving the dst handling from iwch_cm into RDMACM would
> also mostly satisfy why Or is trying to do.
>
> Does that make sense to you Steve?
>   

Yes, in principle. 

If you want to move all this into the RDMACM, then an interface must be 
devised so the drivers can tell the RDMACM that an offload connection is 
failing and probably needs ND/NUD done.  Or some such feedback 
interface.  And the RDMACM needs to call the devices if something 
changes like routing redirects I guess.   You might want the device to 
specify whether it wants the rdma-cm to handle all this or not.  Some 
devices might be better able to handle this stuff.


> How does the cxgb3 driver know when to update the HW if the dst/nd
> entries change?
>   

It uses netevents.  See nb_callback() in drivers/net/cxgb3/cxgb3_offload.c.



> Jason
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
