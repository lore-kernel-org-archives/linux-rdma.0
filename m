From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Tue, 20 Jul 2010 15:50:05 -0500
Message-ID: <4C460BFD.5010707@opengridcomputing.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com> <20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com> <4C45E701.7030501@opengridcomputing.com> <20100720184620.GJ7920@obsidianresearch.com> <4C45F6F5.6050008@opengridcomputing.com> <20100720203044.GK7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100720203044.GK7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Tue, Jul 20, 2010 at 02:20:21PM -0500, Steve Wise wrote:
>
>   
>> I guess it should be using the oif from the cm_id?
>>     
>
> Not sure exactly what is best here :|
>
>   
>>> So, looks like there is a larger cleanup here, if the RDMACM holds the
>>> dst and has functions to freshen it/track it then the iwarp driver
>>> should rely on the RDMACM to manage the dst..
>>>
>>> In other words, moving the dst handling from iwch_cm into RDMACM would
>>> also mostly satisfy why Or is trying to do.
>>>
>>> Does that make sense to you Steve?
>>>   
>>>       
>> Yes, in principle. 
>>
>> If you want to move all this into the RDMACM, then an interface must be  
>> devised so the drivers can tell the RDMACM that an offload connection is  
>> failing and probably needs ND/NUD done.  Or some such feedback  
>> interface.  And the RDMACM needs to call the devices if something  
>> changes like routing redirects I guess.   
>>     
>
> I think if RDMACM manages the dst and lets the devices access it then
> all the existing netdev infrastructure for poking at a dst should be
> available to the device?
>   


Yes. But I'm not sure exactly how the logic I described previous for 
cxgb* would be handled in the design being ironed out here.



>   
>> You might want the device to specify whether it wants the rdma-cm to
>> handle all this or not.  Some devices might be better able to handle
>> this stuff.
>>     
>
> ?? either you integrate with netdev in this area or your device is
> broken :( :( Ie doing ND under the covers is broken, it breaks corner
> case netdev ND management stuff like static ND entries. Same for ICMP
> redirects, same for route lookups and caching, same for route PMTU
> .. :(
>
> IMHO, going down the path of integration is all or nothing, you don't
> get to support things like Amasso doing seperate ND while providing
> much fuller integration for cxgb. That just creates a huge complex
> mess for end users.
>
>   


Guess you'd have to remove the Ammasso driver then. ;)


>>> How does the cxgb3 driver know when to update the HW if the dst/nd
>>> entries change?
>>>       
>
>   
>> It uses netevents.  See nb_callback() in
>> drivers/net/cxgb3/cxgb3_offload.c.
>>     
>
> What about route table changes?
>
>   

Currently route table changes don't have any affect on existing 
connections. Only new connections would be affected.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
