From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] RDMA/cxgb4: remove redundant null pointer check before
 kfree_skb
Date: Thu, 20 Sep 2018 09:26:28 -0500
Message-ID: <bed2c4a0-cb14-83cf-ad90-ce4e7def8b1a@opengridcomputing.com>
References: <1537437162-42846-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537437162-42846-1-git-send-email-zhongjiang@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>, swise@chelsio.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 9/20/2018 4:52 AM, zhong jiang wrote:
> kfree_skb has taken the null pointer into account. hence it is safe
> to remove the redundant null pointer check before kfree_skb.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 3 +--
>  drivers/infiniband/hw/cxgb4/qp.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)

Acked-by: Steve Wise <swise@opengridcomputing.com>
