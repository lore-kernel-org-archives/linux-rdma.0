From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-next 00/13] IB/hfi1,core: Driver updates for 4.17
Date: Tue, 17 Apr 2018 19:40:53 -0600
Message-ID: <20180418014053.GA10098@ziepe.ca>
References: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Mariciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, Brian Welty <brian.welty@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Ashutosh Dixit <ashutosh.dixit@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 04, 2018 at 08:01:11PM -0700, Dennis Dalessandro wrote:
> Hi Jason and Doug,
> 
> Here are most of our updates for 4.17. I will follow this up with a small
> 16B series then I still have a few more patches that are waiting on
> some more thorough testing. Should be able to get them on the list tomrrow or
> Friday at the latest, wanted to get these out now. I don't think anything
> is really that scary in here.
> 
> These are mostly driver fixes. Patches 4,7,8,11, and 14 are marked stable.
> They didn't get sent for the -rc because they fix really old issues.
> 
> Patch 5 is a core fix. I should have sent it a bit sooner, sorry about that but
> it's pretty trivial so I decided to include it as well rather than wait for
> 4.18.
> 
> 
> Alex Estrin (2):
>       IB/hfi1: Complete check for locally terminated smp
>       IB/{hfi1,qib}: Add handling of kernel restart
> 
> Ashutosh Dixit (1):
>       IB/core: Fix rkey invalidation from user space into the kernel
> 
> Michael J. Ruhl (5):
>       IB/hfi1: Return actual error value from program_rcvarray()
>       IB/hfi1: Use after free race condition in send context error path
>       IB/hfi1 Use correct type for num_user_context
>       IB/hfi1: Return correct value for device state
>       IB/hfi1: Reorder incorrect send context disable
> 
> Mike Marciniszyn (3):
>       IB/hfi1: Fix handling of FECN marked multicast packet
>       IB/hfi1: Fix fault injection init/exit issues
>       IB/hfi1: Fix loss of BECN with AHG
> 
> Sebastian Sanchez (2):
>       IB/hfi1: Prevent LNI hang when LCB can't obtain lanes
>       IB/{hfi1,rdmavt,qib}: Fit kernel completions into single aligned cache-line

Many of these got comments so I'm just going to drop the
series. Please rebase and resend anything you think should go to -rc
or -next that doesn't interact with the patches being revised.

Also let me know if the next '16B' series is independent of this, if
yes I'll drop it to..

Jason
