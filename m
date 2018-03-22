From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v4 4/6] infiniband: cxgb4: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Thu, 22 Mar 2018 17:27:56 -0400
Message-ID: <f676414b-20b7-d724-4fcd-d2b4c24259b5@codeaurora.org>
References: <1521514068-8856-5-git-send-email-okaya@codeaurora.org>
 <201803221430.P43GJl9U%fengguang.wu@intel.com>
 <3664b253c730dbf83f4528acaedb3a88@codeaurora.org>
 <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
 <03d201d3c1eb$b71fb460$255f1d20$@opengridcomputing.com>
 <83484a3f-d3f7-d763-e4f8-e4fec3bb8cc2@codeaurora.org>
 <52cbc9d7-5a6b-5c8b-b930-058f5be62079@opengridcomputing.com>
 <BY2PR1201MB098352CB012D8AE8084882F3C8A90@BY2PR1201MB0983.namprd12.prod.outlook.com>
 <20180322201649.GC9469@ziepe.ca>
 <BY2PR1201MB098367F8F217A8BF66AE68B6C8A90@BY2PR1201MB0983.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BY2PR1201MB098367F8F217A8BF66AE68B6C8A90@BY2PR1201MB0983.namprd12.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Leedom <leedom@chelsio.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: SWise OGC <swise@opengridcomputing.com>, 'kbuild test robot' <lkp@intel.com>, "kbuild-all@01.org" <kbuild-all@01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "sulrich@codeaurora.org" <sulrich@codeaurora.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Steve Wise <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Werner <werner@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On 3/22/2018 4:45 PM, Casey Leedom wrote:
> Yes, but ...
> 
> For instance, I see that the x86 writel() has "memory" in its asm(), which
> prevents GCC from reordering generated instructions.  And it ~looks like~
> arm64 ~sort of~ gets that with the inclusion of __iowmb() (which translates
> to wmb() then dsb(st) which finally holds the GCC "memory" barrier).  Is
> this part of the documented semantic of the writel_relaxed()?  The PowerPC
> stuff simply defines writel_relaxed() as writel() and I can't find the
> bottom of that Rabbit Hole ...
> 

This is changing. See "RFC on writel and writel_relaxed" thread. PowerPC 
maintainers are looking for a way to implement this.

What matters is the description in the barriers document. See also 
section "MMIO access primitives" here about mmiowb()

https://lwn.net/Articles/697539/


> I'm guessing~ that this line in the documentation ~may~ imply the GCC
> ordering:
> 
>      ... Note that relaxed accesses to
>      the same peripheral are guaranteed to be ordered with respect to each
>      other. ...
> 

This can be a compiler barrier for some arches and/or can be architecturally 
guaranteed as in ARM64's device nGnRE mapping (non-gathering non-reordering with
early acknowledgment).

Both writel() and writel_relaxed() need to guarantee ordering with respect to
what HW observes for writes. 

They have different guarantees regarding the code surrounding write like you
identified.

> In any case, we really only have a few places where we (the various Chelsio
> drivers) need to worry about this: the "Fast Paths" where we have a lot of
> I/O to the device.  I think we should leave everything else alone.

makes sense

> 
> Casey
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
