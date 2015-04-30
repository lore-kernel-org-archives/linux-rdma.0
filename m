From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v7 00/23] IB/Verbs: IB Management Helpers
Date: Thu, 30 Apr 2015 11:23:26 +0300
Message-ID: <5541E67E.4030906@mellanox.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
	 <1430324895.102408.23.camel@redhat.com> <5541C044.7090800@mellanox.com>
 <1430377216.102408.47.camel@redhat.com> <5541D8CB.8050305@mellanox.com>
 <5541E3BE.2080708@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541E3BE.2080708-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/30/2015 11:11 AM, Michael Wang wrote:
> On 04/30/2015 09:24 AM, Or Gerlitz wrote:
>> >On 4/30/2015 10:00 AM, Doug Ledford wrote:
>>> >>So, short answer:
>>> >>
>>> >>--cc list options: include all interested parties
>>> >>git log messages: include relevant parties
>> >
>> >makes sense. Michael, please address in your next reposting of the series.
> I'm planning to merge 15~23 into one so the long CC could make more sense.

I disagree, but let's handle the 1~14 portion of the series 1st (see below)

>
> And these:
>
> Cc: Hal Rosenstock<hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey<tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford<dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny<ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> All seems like necessary to be included in the tag list for future trace, could we reserve them in the new 16 patches?

No, Doug will add his signature as he's the maintainer, so no need to 
have  him twice.  The other folks there acted as reviewers on this 
series and you are not supposed to add the reviewers as Cc to the 
commits. Just avoid this long listing and put your signature, when 
people send reviewed-by or acked-by it's handled by patchworks.

Patch #1 is the actual new enhancement, right?  maybe you can have long 
Cc list there, if you really want.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
