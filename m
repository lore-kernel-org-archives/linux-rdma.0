From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 21:34:44 -0700 (Pacific Daylight Time)
Message-ID: <Pine.WNT.4.64.1006112117160.6192@PPWASKIE-MOBL2.amr.corp.intel.com>
References: <20100611124746.GA2292@CTUNG-MOBL1> <adapqzxy2sb.fsf@roland-alpha.cisco.com>
 <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com>
 <4C12A6E8.5040400@opengridcomputing.com> <adamxv1w7cb.fsf@roland-alpha.cisco.com>
 <20100611224126.GA4630@obsidianresearch.com> <4C12C971.4000909@opengridcomputing.com>
 <20100612000431.GC4630@obsidianresearch.com> <4C12E073.2040008@opengridcomputing.com>
 <20100612015652.GA7648@obsidianresearch.com> <4C12EC89.1030305@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C12EC89.1030305-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 11 Jun 2010, Steve Wise wrote:

> Jason Gunthorpe wrote:
>> On Fri, Jun 11, 2010 at 08:18:43PM -0500, Steve Wise wrote:
>>
>>
>>> Further, its not even needed for IB, just iWARP.  That's an unnecessary
>>> admin pain IMO.
>>>
>>
>> IB already completely seperates from the host stack, that is why it
>> isn't effected by this problem. It has both a seperate port numbering
>> space (in rdma cm) and a separate addressing space (GID).
>>
>>
>
> By virtue of being a different L4 transport.   iWARP uses TCP as the L4
> and thus has these issues.
>
> Also, from an application perspective,  IB has IP addresses that are
> shared with the TCP stack and the RDMA stack.  So it still appears as
> integrated.  At least with librdmacm applications...
>
>> The entire problem with iWARP is that it is trying to not be
>> seperate, unlike IB. So.. simple answer: use a seperate IP, or use a
>> seperate port space (ie don't use the TCP protocol number).
>>
>

That's right.  iWARP isn't trying to be seperate.  It's trying to converge 
traffic on a single link.  People are doing this all over the place with 
Data Center Bridging (IEEE 802.1Qaz).  It results in easier data center 
deployments, less switches, less cables, less cost, etc., etc.

The fundamental problem here is certain people in the networking community 
don't believe in RDMA or iWARP.  This leads to exactly what's going on 
here, which is the lack of discussion to come up with a better approach if 
people are opposed to this one.  The iWARP community is highlighting a 
limitation with how the protocol is designed, they're trying to fix it, 
and the response is "don't do that."  We need technical guidance if people 
are opposed.

Other protocols are also running over networking today, such as iSCSI and 
FCoE.  These happily co-exist with other L2->L4 protocols in the stack. 
This iWARP patch allows iWARP to happily co-exist on a TCP connection, and 
does *not* negatively affect the networking stack at all.

> Change the iWARP specification?  I don't think that's a simple answer. :)
>
>
>> ROCEE won't have this problem either..

Obviously...it's running over Ethernet.  This doesn't help the discussion 
at hand one bit.  It's comparing apples to oranges.

>>> iWARP should and can easily co-exist with the host TCP by sharing
>>> the port space.  But, as Roland stated already, maybe the only way
>>> forward it to get end-user pressure applied at the appropriate
>>> places! :)
>>>
>>
>> *shrug* This isn't going to happen until netdev decides to design-in
>> statefull offload. I doubt that is going to happen any time
>> soon. I've already seen Linux max out 40GE on benchmarks, so it is
>> hard to see what the driver would be.

I beg to differ.  I work in the Ethernet division at Intel, and have been 
working with 10GbE devices for the past few years.  I can easily scale 
Nehalem-EX systems beyond 100 GbE with hand-tuning of NUMA alignment, 
interrupt affinity, and flow/application affinity.  Linux is more than 
capable of scaling.  The question isn't about netdev adding stateful 
offloads; this patch isn't doing anything like that one bit.  The iWARP 
hardware knows which ports are in use for iWARP connections, and delivers 
those packets to the QP's that need it.  Those then interact directly with 
the RDMA stack.  No hooks in netdev needed.

The base argument is Dave Miller doesn't like RDMA or iWARP.  I completely 
respect Dave's opinions, but in this case, I don't think it's his call, 
since this patch is completely isolated to the IB tree and the RDMA stack. 
Not including this will directly affect anyone using iWARP with Linux. 
Hopefully those people will chime in at some point, but I'm not sure that 
will help because the arguments so far against this have been somewhat 
irrational, and nothing technical-oriented.

Cheers,
-PJ Waskiewicz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
