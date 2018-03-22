From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v4 4/6] infiniband: cxgb4: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Thu, 22 Mar 2018 10:33:11 -0400
Message-ID: <507571ad-b6a5-7020-45fa-609b44e0166b@codeaurora.org>
References: <1521514068-8856-5-git-send-email-okaya@codeaurora.org>
 <201803221430.P43GJl9U%fengguang.wu@intel.com>
 <3664b253c730dbf83f4528acaedb3a88@codeaurora.org>
 <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

One more time hopefully without HTML this time.


On 03/22/2018 08:48 AM, okaya@codeaurora.org wrote:
>> Can you remove the writeq change if it is too late for me to fix?
>>
>> This is an infrastructural issue on xtensa arch.
>>
>> Probably, it won't get fixed today.
>
> AFAIS, even writeq won't compile on this arch. I started questioning 
> this build test.

I found out that the solution is this:

#include <linux/io-64-nonatomic-hi-lo.h>

https://patchwork.ozlabs.org/patch/511801/

I did a compile test with this change on xtensa and it passed. I'll 
repost with the added diff.

+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -46,7 +46,7 @@
  #include <linux/timer.h>
  #include <linux/io.h>
  #include <linux/workqueue.h>
-
+#include <linux/io-64-nonatomic-hi-lo.h>
  #include <asm/byteorder.h>

  #include <net/net_namespace.h>
