From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2 for-next 4/8] RDMA/hns: Set mask for destination qp
 field of qp context assignment
Date: Fri, 29 Sep 2017 12:05:19 -0400
Message-ID: <1506701119.2919.26.camel@redhat.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
         <1506697814-98432-5-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506697814-98432-5-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-29 at 23:10 +0800, Wei Hu (Xavier) wrote:
> From: Lijun Ou <oulijun@huawei.com>
> 
> When only set IB_QP_DEST_QPN flag for attr_mask, the operation of
> assigning the dest_qp_num for dest_qp field of qp context is valid.

This commit message reads poorly.  I reworded it.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
