From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Revise eq support for hip06 & hip08
Date: Mon, 4 Dec 2017 17:33:17 +0800
Message-ID: <4636858b-4ae8-e37e-d2d3-44441560f266@huawei.com>
References: <1510651577-20794-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510651577-20794-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Should I make some changes for this patch-set for the further review?

Regards


On 2017/11/14 17:26, Yixian Liu wrote:
> This patch-set refactor eq code for hip06 and add eq
> support for hip08.
> 
> Yixian Liu (2):
>   RDMA/hns: Refactor eq code for hip06
>   RDMA/hns: Add eq support of hip08
> 
>  drivers/infiniband/hw/hns/Makefile          |    2 +-
>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |    1 +
>  drivers/infiniband/hw/hns/hns_roce_cmd.h    |   10 +
>  drivers/infiniband/hw/hns/hns_roce_common.h |   11 +
>  drivers/infiniband/hw/hns/hns_roce_cq.c     |   19 +-
>  drivers/infiniband/hw/hns/hns_roce_device.h |   83 +-
>  drivers/infiniband/hw/hns/hns_roce_eq.c     |  759 -----------------
>  drivers/infiniband/hw/hns/hns_roce_eq.h     |  134 ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  740 ++++++++++++++++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |   44 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 1177 ++++++++++++++++++++++++++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  192 ++++-
>  drivers/infiniband/hw/hns/hns_roce_main.c   |   16 +-
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |    1 +
>  14 files changed, 2251 insertions(+), 938 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.c
>  delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.h
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
