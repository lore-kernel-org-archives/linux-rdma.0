From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] IB/cxgb4: use skb_put_zero()/__skb_put_zero
Date: Sat, 28 Apr 2018 06:53:37 -0500
Message-ID: <004f01d3dee7$8b5c4cd0$a214e670$@opengridcomputing.com>
References: <20180428073106.14696-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180428073106.14696-1-yuehaibing@huawei.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'YueHaibing' <yuehaibing@huawei.com>, swise@chelsio.com, dledford@redhat.com, jgg@ziepe.ca, monis@mellanox.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: YueHaibing <yuehaibing@huawei.com>
> Sent: Saturday, April 28, 2018 2:31 AM
> To: swise@chelsio.com; dledford@redhat.com; jgg@ziepe.ca;
> monis@mellanox.com
> Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; YueHaibing
> <yuehaibing@huawei.com>
> Subject: [PATCH] IB/cxgb4: use skb_put_zero()/__skb_put_zero
> 
> Use the recently introduced helper to replace the pattern of
> skb_put_zero/__skb_put() && memset().
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks ok.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
