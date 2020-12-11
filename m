Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF48C1B0D8
	for <linux-rdma@archiver.kernel.org>; Fri, 11 Dec 2020 01:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEEB923D97
	for <linux-rdma@archiver.kernel.org>; Fri, 11 Dec 2020 01:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390401AbgLKBkn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Dec 2020 20:40:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8981 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390250AbgLKBkO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 10 Dec 2020 20:40:14 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CsYNT30QjzhqT7;
        Fri, 11 Dec 2020 09:39:05 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 09:39:23 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v5 for-next 04/11] RDMA/hns: Avoid filling sl in high 3 bits of vlan_id
Date:   Fri, 11 Dec 2020 09:37:30 +0800
Message-ID: <1607650657-35992-5-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1607650657-35992-1-git-send-email-liweihang@huawei.com>
References: <1607650657-35992-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Only the low 12 bits of vlan_id is valid, and service level has been filled
in Address Vector. So there is no need to fill sl in vlan_id in Address
Vector.

Fixes: 7406c0036f85 ("RDMA/hns: Only record vlan info for HIP08")
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index c9a44db..cc258ed 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -36,9 +36,6 @@
 #include <rdma/ib_cache.h>
 #include "hns_roce_device.h"
 
-#define VLAN_SL_MASK 7
-#define VLAN_SL_SHIFT 13
-
 static inline u16 get_ah_udp_sport(const struct rdma_ah_attr *ah_attr)
 {
 	u32 fl = ah_attr->grh.flow_label;
@@ -84,18 +81,12 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 
 	/* HIP08 needs to record vlan info in Address Vector */
 	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08) {
-		ah->av.vlan_en = 0;
-
 		ret = rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr,
 					      &ah->av.vlan_id, NULL);
 		if (ret)
 			return ret;
 
-		if (ah->av.vlan_id < VLAN_N_VID) {
-			ah->av.vlan_en = 1;
-			ah->av.vlan_id |= (rdma_ah_get_sl(ah_attr) & VLAN_SL_MASK) <<
-					  VLAN_SL_SHIFT;
-		}
+		ah->av.vlan_en = ah->av.vlan_id < VLAN_N_VID;
 	}
 
 	return ret;
-- 
2.8.1

