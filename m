From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Unable to Connect Using Active Speed 2.5 Gbps and Active Width
 of 1
Date: Mon, 28 Mar 2011 16:18:23 -0400
Message-ID: <4D90ED0F.8010101@dev.mellanox.co.il>
References: <loom.20110328T194956-774@post.gmane.org> <4D90D9A2.7000107@dev.mellanox.co.il> <loom.20110328T210350-244@post.gmane.org> <4D90DF38.1060407@dev.mellanox.co.il> <loom.20110328T212117-950@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110328T212117-950-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/28/2011 3:26 PM, Alan Cook wrote:
> Hal Rosenstock<hal@...>  writes:
>>
>> LinkWidthEnabled is 1X or 4X and not just 1X. That's because there's no
>> force_link_width option in OpenSM so I think the width you set is
>> getting overwritten much like the speed was earlier until you discovered
>> force_link_speed 0.
>
> But I see LinkWidthActive set to 1X, which as I understood denoted the width
> currently being used.

Yes as long as a renegotiation occurred after the enabled width was changed.

> If I set LinkWidthActive to 4X, I am able to transfer
> just fine.
>
> Also, I do see LinkWidthEnabled being changed from "1X" to "1X or 4X" (most
> likely by OpenSM as you suggest), but only after the link is up and active.

If it's changed after the link is up and no renegotiation occurs, then 
this is a don't care as you indicate/

> I am able to transfer at 5 Gbps 1X and 10 Gbps 1X, just not 2.5 Gbps 1X.

I don't have a theory for why only that combo would fail. Do you have 
any other HCA types to try ?

>>
>> Also, is this b2b HCAs or is there a switch in the topology ?
>>
>
> It's b2b HCAs, no switch.

I think ibportstate uses combine routing which is problematic if 
directed at HCA.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
