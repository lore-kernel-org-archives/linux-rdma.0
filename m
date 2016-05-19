From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 14:57:53 -0600
Message-ID: <20160519205753.GB1074@obsidianresearch.com>
References: <20160518220302.81260E09E9@smtp.ogc.us>
 <20160518222857.GB23835@obsidianresearch.com>
 <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
 <20160519180552.GA26130@obsidianresearch.com>
 <573E1EC3.5000907@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <573E1EC3.5000907-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 01:14:59PM -0700, Bart Van Assche wrote:
> On 05/19/2016 11:05 AM, Jason Gunthorpe wrote:
> >This is the mapping that matches the definitions of the barriers:
> >
> >  wmb can be memory_order_release
> >  rmb can be memory_order_acquire
> >  mb can be memory_order_seq_cst
> 
> This is not correct. Acquire and release, at least as defined by
> Gharachorloo in 1991, have another meaning than the mentioned barrier
> instructions. Acquire and release are labels that can be applied to load and
> store instructions respectively.

C11 uses a common language for the coherency requirement in multiple
contexts
- Load/store
- fence (ie a barrier)
- exchanges
- bit set/test

In a load/store context the ordering is associated with a single
memory op, like your paper describes. In the fence context there is no
memory op, the ordering acts on all memory ops..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
