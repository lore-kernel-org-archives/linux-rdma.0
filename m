From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v3] IB/cxgb4: Mark symbols static for _free_qp
Date: Mon, 29 Aug 2016 09:26:01 -0500
Message-ID: <004001d20201$448119e0$cd834da0$@opengridcomputing.com>
References: <1472396231-16937-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472396231-16937-1-git-send-email-baoyou.xie@linaro.org>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Baoyou Xie' <baoyou.xie@linaro.org>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH v3] IB/cxgb4: Mark symbols static for _free_qp
> 
> We get 1 warning when build kernel with W=1:
> drivers/infiniband/hw/cxgb4/qp.c:686:6: warning: no previous prototype for
> '_free_qp' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is declared
> and don't need a declaration, but can be made static.
> so this patch marks it 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Ignore my comment on v2...

Acked-by: Steve Wise <swise@opengridcomputing.com>
