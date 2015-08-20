From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Thu, 20 Aug 2015 11:49:55 +0300
Message-ID: <55D594B3.7090807@dev.mellanox.co.il>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-2-git-send-email-hch@lst.de>
 <20150819174614.GC22646@obsidianresearch.com> <20150819174802.GA13875@lst.de>
 <20150819175425.GE22646@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150819175425.GE22646-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/19/2015 8:54 PM, Jason Gunthorpe wrote:
> On Wed, Aug 19, 2015 at 07:48:02PM +0200, Christoph Hellwig wrote:
>> On Wed, Aug 19, 2015 at 11:46:14AM -0600, Jason Gunthorpe wrote:
>>> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>>
>>> AFAIK, this path is rarely (never?) actually used. I think all the
>>> drivers we have can post directly from userspace.
>>
>> Oh, interesting.  Is there any chance to deprecate it?  Not having
>> to care for the uvers command would really help with some of the
>> upcoming changes I have in my mind.
>
> Hmm, we'd need a survey of the userspace side to see if it is rarely
> or never...
>
> And we'd have to talk to the soft XXX guys to see if they plan to use
> it..

Checked in librxe (user-space softroce). Looks like posts are going via
this path...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
