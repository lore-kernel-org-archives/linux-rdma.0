From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 4/6] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Thu, 22 Mar 2018 12:46:44 -0600
Message-ID: <20180322184644.GA9469@ziepe.ca>
References: <1521514068-8856-5-git-send-email-okaya@codeaurora.org>
 <201803221430.P43GJl9U%fengguang.wu@intel.com>
 <3664b253c730dbf83f4528acaedb3a88@codeaurora.org>
 <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
 <437ab002-b8db-24aa-583e-0e61d61aaa97@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <437ab002-b8db-24aa-583e-0e61d61aaa97@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 22, 2018 at 10:28:13AM -0400, Sinan Kaya wrote:
>    On 03/22/2018 08:48 AM, [1]okaya@codeaurora.org wrote:
> 
>      Jason,
>      Can you remove the writeq change if it is too late for me to fix?
>      This is an infrastructural issue on xtensa arch.
>      Probably, it won't get fixed today.

I was able to drop the patch, please resend.

>      AFAIS, even writeq won't compile on this arch. I started questioning
>      this build test.

>    I found out that the solution is this:
> #include <linux/io-64-nonatomic-hi-lo.h>

Yuk, what an ugly API..

>    [2]https://patchwork.ozlabs.org/patch/511801/
>    I did a compile test with this change on xtensa and it passed. I'll
>    repost with the added diff.
>    +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
>    @@ -46,7 +46,7 @@
>     #include <linux/timer.h>
>     #include <linux/io.h>
>     #include <linux/workqueue.h>
>    -
>    +#include <linux/io-64-nonatomic-hi-lo.h>

I think this is the wrong one. I would expect all PCI-E devices should
use lo-hi, eg writes are done in address increasing order on the bus.

This is what the PCI-E spec would require if a write were to be
fragmented so I would expect devices to handle it properly.

Steve? Any idea of specific things for this HW?

Jason
