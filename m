From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
Date: Thu, 15 Jan 2015 22:08:11 +0200
Message-ID: <54B81E2B.9030101@dev.mellanox.co.il>
References: <cover.1421264928.git.dledford@redhat.com>	 <DBXPR05MB067182B666A7F24EE23DC8ADB64E0@DBXPR05MB0671.eurprd05.prod.outlook.com> <1421335460.2484.21.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421335460.2484.21.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/15/2015 5:24 PM, Doug Ledford wrote:
> On Thu, 2015-01-15 at 09:19 +0000, Erez Shitrit wrote:
>> Hi Doug,
>>
>> Thank you for the quick response.
>>
>> Now I can see 2 issues, that I want to draw your attention to:
>>
>> 1. if there is a mcg that the driver failed to join, the mc_task enters to endless loop of re-queue, and the log will be full with the next messages:
>> [682560.569826] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.580136] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.590364] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.600504] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.610627] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.620769] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.631082] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.640835] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> [682560.651033] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.660758] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> [682560.670923] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.680676] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> [682560.690898] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [682560.700630] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>>
>> around 100 times a sec.
> OK, this looks like the send only joins that fail are not setting a
> fallback properly or something like that.  There is a separate bug that
> I've isolated that I'm going to fix, then I we can see if that fix
> effects things here, as it very well might.
>
>> 2. IPv6 still doesn't work for me, at the same case where it is not the first mcg in the list.
> Can you give me some sort of instructions on how to replicate your
> testing?  Things are working for me here, but I don't have a complex
> IPv6 setup and mine may be too simple to reproduce what you are seeing.
I don't have a complex setup, i have 2 devices, and i do a regular ping6 
from device with the full series in it, to some other device. nothing 
special, the only thing i can say that in the list there is one sendonly 
mcg (

ff12:601b:ffff:0000:0000:0000:0000:0016) that is at the first place in the list.
anyway, i think it connected to the first issue,because it at some endless loop with the first mcg, it doesn't have the chance to handle the other mcg's.

>
>> Thanks, Erez
>>
>> -----Original Message-----
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>> Sent: Wednesday, January 14, 2015 9:53 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> Cc: Amir Vadai; Eyal Perry; Erez Shitrit; Or Gerlitz; Doug Ledford
>> Subject: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
>>
>> This patch series fixes the multicast join behavior problems introduced by my previous patchset.  In particular, the original code did not use the send only join code from the multicast thread context, and so it did not need to restart the multicast thread.  After my previous patchset, it does get called from the thread context, and so the send only join completion areas need to restart the join thread but they don't.  This patchset makes them do so.  It then adds in some cleanups for restarting the thread, and fixes the fact that one delayed join holds up the entire list of joins.
>>
>> v3: Resend because the last send didn't register in patchworks properly
>>      (because the subject-prefix was not on all of the emails, only the
>>      first) and because the Cc: list didn't not pass from cover letter
>>      to patches
>>
>> v2: Added two new patches, the first creates a helper to restart the
>>      multicast join thread and also adds using it in the two places where
>>      it should have been used but wasn't, the second allows the joins to
>>      proceed around a delayed join instead of stalling everything.
>>
>> v1: Addressed the usage of the IPOIB_MCAST_RUN flag
>>
>> Doug Ledford (3):
>>    IB/ipoib: Fix failed multicast joins/sends
>>    IB/ipoib: Add a helper to restart the multicast task
>>    IB/ipoib: make delayed tasks not hold up everything
>>
>>   drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
>>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 94 ++++++++++++++++++--------
>>   2 files changed, 66 insertions(+), 29 deletions(-)
>>
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
