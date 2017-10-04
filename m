From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/hns: return 0 rather than return a garbage status
 value
Date: Wed, 04 Oct 2017 14:40:43 -0400
Message-ID: <1507142443.46071.0.camel@redhat.com>
References: <20170929201308.4704-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170929201308.4704-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-29 at 21:13 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> For the case where hr_qp->state == IB_QPS_RESET, an uninitialized
> value in ret is being returned by function hns_roce_v2_query_qp.
> Fix this by setting ret to 0 for this specific return condition.
> 
> Detected by CoverityScan, CID#1457203 ("Unitialized scalar variable")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
