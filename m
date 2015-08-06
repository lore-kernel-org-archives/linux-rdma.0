From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Wed, 5 Aug 2015 17:19:10 -0700
Message-ID: <55C2A7FE.7020904@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150803152420.GA24193@infradead.org>
 <55BFB40F.8000500@sandisk.com> <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
 <55C2912A.50709@sandisk.com> <20150806001006.GD2483@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150806001006.GD2483-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/05/2015 05:10 PM, Jason Gunthorpe wrote:
> On Wed, Aug 05, 2015 at 03:41:46PM -0700, Bart Van Assche wrote:
>> Regarding the discussion in 2011 about FMR
>> (http://thread.gmane.org/gmane.linux.drivers.rdma/7149): since in 2011
>> nobody recalled the root cause of the issue with non-page aligned FMR my
>> proposal is to drop the page alignment check and if any issues occur to
>> introduce a blacklist for the SRP target devices that have trouble with
>> this.
>
> Nice find, that sounds like a solid plan.
>
> That looks like it leaves only the srp_map_data flow and the error case
> flow in srp_map_sg as remaining problems for the rkey patch? Any
> thoughts on adressing those?

Hello Jason,

A few experimental and untested patches are available for review at 
https://github.com/bvanassche/linux/tree/srp-initiator-for-next-experimental.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
