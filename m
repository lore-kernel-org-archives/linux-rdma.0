From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Unable to Connect Using Active Speed 2.5 Gbps and Active Width
 of 1
Date: Tue, 29 Mar 2011 13:37:52 -0400
Message-ID: <4D9218F0.3020000@dev.mellanox.co.il>
References: <loom.20110328T194956-774@post.gmane.org> <4D90D9A2.7000107@dev.mellanox.co.il> <loom.20110328T210350-244@post.gmane.org> <4D90DF38.1060407@dev.mellanox.co.il> <loom.20110328T212117-950@post.gmane.org> <20110328194150.GA6205@obsidianresearch.com> <loom.20110328T220853-101@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110328T220853-101-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/28/2011 4:41 PM, Alan Cook wrote:
> Jason Gunthorpe<jgunthorpe@...>  writes:
>
>>
>> Are you using IPoIB to test your ping? You might be having multicast
>> group membership join problems due to a rate mismatch? Try one of the
>> low level verbs only diags.
>>
>
> I found the following issue when running ibdiagnet (which I had yet to run).
>
> -I---------------------------------------------------
> -I- IPoIB Subnets Check
> -I---------------------------------------------------
> -I- Subnet: IPv4 PKey:0x7fff QKey:0x00000b1b MTU:2048Byte rate:10Gbps SL:0x00
> -W- Port raid1/P1 lid=0x0002 guid=0x0002c903000aa6d7 dev=26428 can not join due
>      to rate:2.5Gbps<  group:10Gbps
> -W- Port raid2/P1 lid=0x0001 guid=0x0002c903000aa6cf dev=26428 can not join due
>      to rate:2.5Gbps<  group:10Gbps
> -W- Suboptimal rate for group. Lowest member rate:120Gbps>  group-rate:10Gbps
>
> I also changed the speed to 5 Gbps (which I thought had worked earlier) and I am
> unable to transfer using a width 1X.  I receive the same warnings as above.

The default is rate 3 (10 Gbps) so I would think anything less than that 
wouldn't work without reconfiguration.

> After doing some searching, I created a partitions.conf (which did not exist at
> configured location in opensm.conf).  I added the following line:
>
> Test,ipoib,rate=1,defmember=full:0x0002c903000aa6d7,0x0002c903000aa6cf;

How about if rather than Test, you change it to Default=0x7fff ?

> After restarting opensm.conf, I find that the above warnings in ibdiagnet no
> longer appear, but I am still unable to communicate between PCs.
>
> Did I miss something or do something incorrectly?

The above is pertinent to IPoIB ping but couldn't explain ibping lack of 
connectivity.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
