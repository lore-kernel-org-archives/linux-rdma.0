From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 27/28] IB/Verbs: Clean up rdma_ib_or_iboe()
Date: Fri, 17 Apr 2015 10:04:39 +0200
Message-ID: <5530BE97.1010501@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB85D.7010400@profitbricks.com> <20150413203350.GA20611@obsidianresearch.com> <552CDA1F.4050609@profitbricks.com> <20150416164311.GB22946@obsidianresearch.com> <005801d07870$3b2dc530$b1894f90$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005801d07870$3b2dc530$b1894f90$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Tom Tucker' <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Hoang-Nam Nguyen' <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, 'Christoph Raisch' <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, 'Mike Marciniszyn' <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Eli Cohen' <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jack Morgenstein' <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Haggai Eran' <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/16/2015 08:07 PM, Steve Wise wrote:
> 
> 
>> -----Original Message-----
>> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
>> Sent: Thursday, April 16, 2015 11:43 AM
>> To: Michael Wang
>> Cc: Roland Dreier; Sean Hefty; Hal Rosenstock; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Tom Tucker; Steve Wise;
>> Hoang-Nam Nguyen; Christoph Raisch; Mike Marciniszyn; Eli Cohen; Faisal Latif; Jack Morgenstein; Or Gerlitz; Haggai Eran; Ira
> Weiny;
>> Tom Talpey; Doug Ledford
>> Subject: Re: [PATCH v3 27/28] IB/Verbs: Clean up rdma_ib_or_iboe()
>>
>> On Tue, Apr 14, 2015 at 11:13:03AM +0200, Michael Wang wrote:
>>
>>>> I would be very happy to see a patch that adds cap_ib_smi to the
>>>> current tree and states 'This patch is tested to have no change on the
>>>> binary compilation results'
>>>
>>> There are too much reform there (per-dev to per-port), I guess the binary
>>> will changed more or less anyway...
>>
>> I think this patch series is huge, and everytime someone new looks at
>> it small functional errors seem to pop up..
>>
>> Doing something to reduce the review surface would be really helpful
>> here. Not changing the same line twice, using tools too perform these
>> transforms and then assert the patch is a NOP because .. tools. Some
>> other idea?
>>
> 
> Don't try and change everything in one giant series.   Just do some changes this cycle (keep it at < 8 or 10 patches), and do more
> later...

Actually only 1#~15# related to logical reform, rest are just replacement :-)

Me too would like to stop introducing new stuff at this moment, and focus on
the improvement of what we have already settled down.

Regards,
Michael Wang

> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
