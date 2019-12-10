Return-Path: <SRS0=zY9Z=2A=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36208C00454
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Dec 2019 21:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3C620838
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Dec 2019 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576012477;
	bh=/ksDbFlGRX6NYNxfX+vFNg4/P4WU9zfrrWSCuSQmOYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vdpDhOrbSL6K8RDBRo7vga4xv/Nrc3r6lL7fyucaYCmYrUX/lPsI4Q4IAJ6TW5n97
	 IKxAKJeXNx33QvV+SXRXgZGoa3WaOT3vymGlOFFzB8zEiKd07Q1UsSADJD37FbA99B
	 l60srUeFbf3Ri0X6PH0r+Tld520ba93l5ZDH0lMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfLJVO0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Dec 2019 16:14:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbfLJVNz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EC4920838;
        Tue, 10 Dec 2019 21:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012435;
        bh=/ksDbFlGRX6NYNxfX+vFNg4/P4WU9zfrrWSCuSQmOYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gt0UIjSvfwlxG0jy64tMAUFt0MhwbRtwyeZ01yz8ExwOwPRpSZJmQjcC3RWiYDIOW
         9OzKNxg5lo9mW2CxQyaIwlboVE8NMagUv37YRs5HToy7cr6c0ztZM8PCv5LTZnHV5p
         Ckz7eTnSNfcEkeDBB1BvHRlneD/eTwrsLcC4/3i0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Starrett <luke.starrett@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 347/350] RDMA/bnxt_re: Fix chip number validation Broadcom's Gen P5 series
Date:   Tue, 10 Dec 2019 16:07:32 -0500
Message-Id: <20191210210735.9077-308-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Luke Starrett <luke.starrett@broadcom.com>

[ Upstream commit e284b159c6881c8bec9713daba2653268f4c4948 ]

In the first version of Gen P5 ASIC, chip-id was always set to 0x1750 for
all adaptor port configurations. This has been fixed in the new chip rev.

Due to this missing fix users are not able to use adaptors based on latest
chip rev of Broadcom's Gen P5 adaptors.

Fixes: ae8637e13185 ("RDMA/bnxt_re: Add chip context to identify 57500 series")
Link: https://lore.kernel.org/r/1574317343-23300-2-git-send-email-devesh.sharma@broadcom.com
Signed-off-by: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Luke Starrett <luke.starrett@broadcom.com>
Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index fbda11a7ab1aa..aaa76d7921857 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -186,7 +186,9 @@ struct bnxt_qplib_chip_ctx {
 	u8	chip_metal;
 };
 
-#define CHIP_NUM_57500          0x1750
+#define CHIP_NUM_57508		0x1750
+#define CHIP_NUM_57504		0x1751
+#define CHIP_NUM_57502		0x1752
 
 struct bnxt_qplib_res {
 	struct pci_dev			*pdev;
@@ -203,7 +205,9 @@ struct bnxt_qplib_res {
 
 static inline bool bnxt_qplib_is_chip_gen_p5(struct bnxt_qplib_chip_ctx *cctx)
 {
-	return (cctx->chip_num == CHIP_NUM_57500);
+	return (cctx->chip_num == CHIP_NUM_57508 ||
+		cctx->chip_num == CHIP_NUM_57504 ||
+		cctx->chip_num == CHIP_NUM_57502);
 }
 
 static inline u8 bnxt_qplib_get_hwq_type(struct bnxt_qplib_res *res)
-- 
2.20.1

