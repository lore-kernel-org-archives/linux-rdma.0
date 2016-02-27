From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Destage hfi1 driver and fix a few bugs
Date: Sat, 27 Feb 2016 13:18:56 -0500
Message-ID: <20160227181855.GA25390@phlsvsds.ph.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com> <20160226222104.GA8736@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160226222104.GA8736-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 26, 2016 at 03:21:04PM -0700, Jason Gunthorpe wrote:
>On Fri, Feb 26, 2016 at 01:33:02PM -0800, Dennis Dalessandro wrote:
>> We believe the TODO list has been satisfied for the hfi1 driver. The main item
>> was removing the code duplication between hfi1 and qib. That has been handled by
>> the introduction of rdmavt in previously posted patch series.
>
>How many lines were actually merged? It still looks like there is lots
>of duplication.

Jason,

Fair question. It's difficult to say how many lines were merged. Not sure 
that is the best metric to use. I suppose one could 'wc -l' the files.  
However the key take away here is that the high level verbs functionality 
and data structures have been moved to rdmavt, things like the qp, ah, cq,
etc. Some things, for instance the MAD processing, were not moved because it
is very different between hfi1 and qib.

The code which is left that is similar between the qib and hfi1 drivers has 
subtle differences which are very important to performance. This mainly 
consists of the code to put the packets on the wire. We are investigating 
how best, if at all, to incorporate that into rdmavt. We have to be very 
careful here, not only for the performance impact, but adding this into 
rdmavt makes it very Intel centric rather than the generic verbs library it 
wants to be.

Our hope is to go with the nearly 300 patches pending for rdmavt and hfi1 
for 4.6 and incrementally work on adding other things in subsequent 
releases. There is a lot of code, a lot of things are changing and it's 
probably best to let things settle out for 4.6.

The code is cleaned up from a style point of view, the checkpatch issues etc 
are dealt with. We have moved the verbs functionality to rdmavt. We feel 
it's appropriate to move out of staging at this point.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
