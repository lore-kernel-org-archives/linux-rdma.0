From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/2] IB/hns: Fine-tuning for two function implementations
Date: Thu, 20 Apr 2017 16:32:22 -0400
Message-ID: <1492720342.3041.11.camel@redhat.com>
References: <4863af1d-ca80-1818-213e-7eadda35e8a1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4863af1d-ca80-1818-213e-7eadda35e8a1@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Wei Hu <xavier.huwei@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-16 at 10:00 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 16 Feb 2017 09:55:43 +0100
> 
> A few update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (2):
>   Use kmalloc_array() in hns_roce_cmd_use_events()
>   Use kcalloc() in hns_roce_buddy_init()
> 
>  drivers/infiniband/hw/hns/hns_roce_cmd.c |  6 +++---
>  drivers/infiniband/hw/hns/hns_roce_mr.c  | 11 ++++++-----
>  2 files changed, 9 insertions(+), 8 deletions(-)

Series applied, thanks.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

