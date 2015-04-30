From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v7 04/23] IB/Verbs: Reform IB-core cm
Date: Thu, 30 Apr 2015 09:28:04 +0200
Message-ID: <5541D984.1010808@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>	<1430233823-7075-5-git-send-email-yun.wang@profitbricks.com>	<CAJ3xEMhOg1xh5dXburjavqcy3crwWs6OoF2qEojiDxDhT-MCDw@mail.gmail.com>	<55408ADB.1020602@profitbricks.com> <CAJ3xEMgjj8sdF1Lfqshj_4uLkc5CtrYqg8RpEP0+V=QD_Pg+=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgjj8sdF1Lfqshj_4uLkc5CtrYqg8RpEP0+V=QD_Pg+=w@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/29/2015 05:48 PM, Or Gerlitz wrote:
[snip]
> 
>>
>> I think the CC list is not that big for a patch set covered such a wide
>> range, isn't it :-P
> 
> Maybe it's a matter of taste, but for me it look way way too big. If
> you really want to have such
> a huge listing, do it in the early patches of the series where you
> introduce the new concepts, and later,on downstream patches, when you
> use it, put one person if they happen to be the author or maintainthat
> area (e.g Sean <-- CM/CMA, Doug/Erez <-- IPoIB Ira, Hal <-- MAD, Steve
> <-- IW_CM, etc)

Thanks for the suggestion, I can't callback correctly who participated
on which part of the review accurately... my bad, will take care next
time :-) and will stop add new CC from now on.

BTW, as now folks already familiar with the cap_XX stuff, may be
the last version to be applied could merge all the cap_XX into one,
after all, it's more focus on the description rather than logical,
separate cap_XX won't help easier the review anyway.

Regards,
Michael Wang

> 
> Or.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
