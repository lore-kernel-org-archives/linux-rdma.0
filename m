Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02419C433FE
	for <linux-rdma@archiver.kernel.org>; Sun, 12 Sep 2021 18:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC13D61051
	for <linux-rdma@archiver.kernel.org>; Sun, 12 Sep 2021 18:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhILSQt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 12 Sep 2021 14:16:49 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:34440 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234945AbhILSQr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 12 Sep 2021 14:16:47 -0400
Received: from dhcp-10-192-206-197.iig.avagotech.net.net (dhcp-10-123-156-118.dhcp.broadcom.net [10.123.156.118])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id F2A1680F2;
        Sun, 12 Sep 2021 11:15:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com F2A1680F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1631470533;
        bh=Yo3QOKSaBtvOj2BjCXSB1E5jgTKyvw9iHkWdTYESOhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN3YZRTAkjbuGjuQBu2l3qo/pRRFNxZnIoHgVDyktyZK/HGoZHEy/dFMy5tjNnAC8
         rqYJHxZbwYxwQo2JYVXy/bJjZPIPkGGMw+IGeDKxCvzHTYABshwtaPYUshuac3kDO/
         OlWIfBQz008ySl7ot621m69KuLzH9CIyrZzdiRLY=
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     dledford@redhat.com, jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 02/12] RDMA/bnxt_re: Update statistics counter name
Date:   Sun, 12 Sep 2021 11:15:16 -0700
Message-Id: <1631470526-22228-3-git-send-email-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1631470526-22228-1-git-send-email-selvin.xavier@broadcom.com>
References: <1631470526-22228-1-git-send-email-selvin.xavier@broadcom.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Update a statistics counter name as the interface
structure got updated.

Fixes: 9d6b648c3112 ("bnxt_en: Update firmware interface spec to 1.10.1.65.")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 4 ++--
 drivers/infiniband/hw/bnxt_re/hw_counters.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 7e6dcf3..1c06c9c 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -70,7 +70,7 @@ static const char * const bnxt_re_stat_name[] = {
 	[BNXT_RE_TX_PKTS]		=  "tx_pkts",
 	[BNXT_RE_TX_BYTES]		=  "tx_bytes",
 	[BNXT_RE_RECOVERABLE_ERRORS]	=  "recoverable_errors",
-	[BNXT_RE_RX_DROPS]		=  "rx_roce_drops",
+	[BNXT_RE_RX_ERRORS]		=  "rx_roce_errors",
 	[BNXT_RE_RX_DISCARDS]		=  "rx_roce_discards",
 	[BNXT_RE_TO_RETRANSMITS]        = "to_retransmits",
 	[BNXT_RE_SEQ_ERR_NAKS_RCVD]     = "seq_err_naks_rcvd",
@@ -273,7 +273,7 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 	if (hw_stats) {
 		stats->value[BNXT_RE_RECOVERABLE_ERRORS] =
 			le64_to_cpu(hw_stats->tx_bcast_pkts);
-		stats->value[BNXT_RE_RX_DROPS] =
+		stats->value[BNXT_RE_RX_ERRORS] =
 			le64_to_cpu(hw_stats->rx_error_pkts);
 		stats->value[BNXT_RE_RX_DISCARDS] =
 			le64_to_cpu(hw_stats->rx_discard_pkts);
diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.h b/drivers/infiniband/hw/bnxt_re/hw_counters.h
index d65be4c..7943b2c 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.h
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.h
@@ -53,7 +53,7 @@ enum bnxt_re_hw_stats {
 	BNXT_RE_TX_PKTS,
 	BNXT_RE_TX_BYTES,
 	BNXT_RE_RECOVERABLE_ERRORS,
-	BNXT_RE_RX_DROPS,
+	BNXT_RE_RX_ERRORS,
 	BNXT_RE_RX_DISCARDS,
 	BNXT_RE_TO_RETRANSMITS,
 	BNXT_RE_SEQ_ERR_NAKS_RCVD,
-- 
2.5.5

