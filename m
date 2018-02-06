From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/3] Several fixes for hns
Date: Tue, 6 Feb 2018 20:34:16 +0800
Message-ID: <1517920459-93900-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset include three fixes for hns driver. the first patch
mainly matched with IB protocol. the second patch fix the bug
with freeing memory by __get_free_pages. the last patch mainly
fix the bug when changed the hw mac address.

Lijun Ou (2):
  RDMA/hns: Fix a bug with modifying mac address
  RDMA/hns: Use free_pages function instead of free_page

Yixian Liu (1):
  RDMA/hns: Fix QP state judgement before receiving work requests

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c  | 3 ++-
 drivers/infiniband/hw/hns/hns_roce_mr.c    | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
