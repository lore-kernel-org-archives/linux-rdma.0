From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/20] RDMA/hns: Add hip08 RoCE driver support
Date: Mon, 25 Sep 2017 14:18:56 +0800
Message-ID: <59C89FD0.9050606@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/8/30 17:22, Wei Hu (Xavier) wrote:
> This patchset adds support for the HiSilicon RoCE engine in the hip08
> SoC.
>
> The driver is refactored so it can support both platform and pci device.
> And hip08 RoCE engine is a pci device, hip06 RoCE engine is a platform
> device.
>
> New hardware layer file hns_roce_hw_v2.c is added for hw v2 support,
> which also includes pci device probing and initialization.
>
> Common functionality is still in hns-roce driver, along with device
> initialization.
>
> This patchset depends on hns3 NIC driver which had been accepted by David,
> and is based on for-next branch of the repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
Hi, Doug
     The dependent hns3 NIC driver had been merged into Linus' v4.14-rc1.
     Thanks.

     Regards
Wei Hu
> Shaobo Xu (3):
>    RDMA/hns: Add the interfaces to support multi hop addressing for the
>      contexts in hip08
>    RDMA/hns: Update the interfaces for MTT/CQE multi hop addressing in
>      hip08
>    RDMA/hns: Split CQE from MTT in hip08
>
> Wei Hu (Xavier) (17):
>    RDMA/hns: Split hw v1 driver from hns roce driver
>    RDMA/hns: Move priv in order to add multiple hns_roce support
>    RDMA/hns: Initialize the PCI device for hip08 RoCE
>    RDMA/hns: Modify assignment device variable to support both PCI device
>      and platform device
>    RDMA/hns: Add command queue support for hip08 RoCE driver
>    RDMA/hns: Add profile support for hip08 driver
>    RDMA/hns: Add mailbox's implementation for hip08 RoCE driver
>    RDMA/hns: Configure BT BA and BT attribute for the contexts in hip08
>    RDMA/hns: Support multi hop addressing for PBL in hip08
>    RDMA/hns: Configure mac&gid and user access region for hip08 RoCE
>      driver
>    RDMA/hns: Add CQ operations support for hip08 RoCE driver
>    RDMA/hns: Add QP operations support for hip08 SoC
>    RDMA/hns: Add support for processing send wr and receive wr
>    RDMA/hns: Configure the MTPT in hip08
>    RDMA/hns: Add releasing resource operation in error branch
>    RDMA/hns: Replace condition statement using hardware version
>      information
>    RDMA/hns: Fix inconsistent warning
>
>   drivers/infiniband/hw/hns/Kconfig           |   25 +-
>   drivers/infiniband/hw/hns/Makefile          |    8 +-
>   drivers/infiniband/hw/hns/hns_roce_ah.c     |    2 +-
>   drivers/infiniband/hw/hns/hns_roce_alloc.c  |    8 +-
>   drivers/infiniband/hw/hns/hns_roce_cmd.c    |  107 +-
>   drivers/infiniband/hw/hns/hns_roce_cmd.h    |   50 +
>   drivers/infiniband/hw/hns/hns_roce_common.h |   23 +
>   drivers/infiniband/hw/hns/hns_roce_cq.c     |   72 +-
>   drivers/infiniband/hw/hns/hns_roce_device.h |   98 +-
>   drivers/infiniband/hw/hns/hns_roce_hem.c    |  699 +++++-
>   drivers/infiniband/hw/hns/hns_roce_hem.h    |   32 +-
>   drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  401 +++-
>   drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |    5 +
>   drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 3128 +++++++++++++++++++++++++++
>   drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 1165 ++++++++++
>   drivers/infiniband/hw/hns/hns_roce_main.c   |  324 +--
>   drivers/infiniband/hw/hns/hns_roce_mr.c     |  513 ++++-
>   drivers/infiniband/hw/hns/hns_roce_pd.c     |   20 +-
>   drivers/infiniband/hw/hns/hns_roce_qp.c     |  179 +-
>   19 files changed, 6318 insertions(+), 541 deletions(-)
>   create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>   create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.h
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
