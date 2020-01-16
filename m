Return-Path: <SRS0=Ta2D=3F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C427DC33CB3
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 16:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE072073A
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579193436;
	bh=Nh1lPVksc84cfRqDmjNinvlnaUTlHFl1OIphF9v5p9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=B0P5odqMd8HGXHi3AvAR3hKAVYOLjD8n9ziwl5nT+Bagg24mEpCJC9YtCYXDKQBfG
	 VTXp/XvEJM+BhO9Zz3JoXE+0P3PhVTH7/rRqLMLjNrQ8U6jURnElTSXwWKDDQs9WOb
	 n5RD4HDUTVIGWtDV/y6mt9UY9oyrZnrcT8gLlTkY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgAPQr3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgAPQr3 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA7B2176D;
        Thu, 16 Jan 2020 16:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193248;
        bh=Nh1lPVksc84cfRqDmjNinvlnaUTlHFl1OIphF9v5p9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6FQj2Lo3fGrfFqXZ2oHMqVUzxIg2Dsu2EzX9dR/6lZuMMmZGtkwqjAgm28sZGUUd
         TneuxG9iimgjgdco0R2rTdBNxq32HmxoC+WBt4jiR2+jXUKNaP360g3taadFhDxUnJ
         UjGoEHDLL/FMK13b5MnTvf961jXVCYPmIxiBZanY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 054/205] RDMA/hns: Release qp resources when failed to destroy qp
Date:   Thu, 16 Jan 2020 11:40:29 -0500
Message-Id: <20200116164300.6705-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit d302c6e3a6895608a5856bc708c47bda1770b24d ]

Even if no response from hardware, we should make sure that qp related
resources are released to avoid memory leaks.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Link: https://lore.kernel.org/r/1570584110-3659-1-git-send-email-liweihang@hisilicon.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index e82567fcdeb7..926cb97483f9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4650,16 +4650,14 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 {
 	struct hns_roce_cq *send_cq, *recv_cq;
 	struct ib_device *ibdev = &hr_dev->ib_dev;
-	int ret;
+	int ret = 0;
 
 	if (hr_qp->ibqp.qp_type == IB_QPT_RC && hr_qp->state != IB_QPS_RESET) {
 		/* Modify qp to reset before destroying qp */
 		ret = hns_roce_v2_modify_qp(&hr_qp->ibqp, NULL, 0,
 					    hr_qp->state, IB_QPS_RESET);
-		if (ret) {
+		if (ret)
 			ibdev_err(ibdev, "modify QP to Reset failed.\n");
-			return ret;
-		}
 	}
 
 	send_cq = to_hr_cq(hr_qp->ibqp.send_cq);
@@ -4715,7 +4713,7 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 		kfree(hr_qp->rq_inl_buf.wqe_list);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
@@ -4725,11 +4723,9 @@ static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	int ret;
 
 	ret = hns_roce_v2_destroy_qp_common(hr_dev, hr_qp, udata);
-	if (ret) {
+	if (ret)
 		ibdev_err(&hr_dev->ib_dev, "Destroy qp 0x%06lx failed(%d)\n",
 			  hr_qp->qpn, ret);
-		return ret;
-	}
 
 	if (hr_qp->ibqp.qp_type == IB_QPT_GSI)
 		kfree(hr_to_hr_sqp(hr_qp));
-- 
2.20.1

