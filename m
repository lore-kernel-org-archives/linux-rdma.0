Return-Path: <SRS0=yC1B=ZO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E16DC432C0
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 06:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D46E2068F
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 06:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403027;
	bh=+WTmaawSFZUDjVsY9VTEerUrq2y3yubX2tca8Lyc2ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TGfdYxkyXLZimj9S2BaR/UNlXW5QW/FHnVRxC1/8NXI0zl1ZdeEkJWbeb0mx7nESA
	 uWuOKj2gkqKsbmMSTg3MZH0o1IOrehrgA2Me9N3FTS+RlRqPjvMHNMNo5LGqmP1EJM
	 iEtH7sRRsrVLhzf2MRZFxXArEX+5YXyDIV1bwXlg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfKVF4w (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728874AbfKVF4v (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E05F20717;
        Fri, 22 Nov 2019 05:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402211;
        bh=+WTmaawSFZUDjVsY9VTEerUrq2y3yubX2tca8Lyc2ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSafoTyNRSDs6gaU9SjUdySTpScY+5s/l7ll1AcBk8h1qpGZluGnTfJNfJgbsiiad
         1e5HQPQk9lEFWtXax/iK71+PxZwl9QHQf/XH3YztLoo7rYyMHaWm5j6r4TBb0nIK+A
         uktYZePvICVzSD1OvThq9TweFHoEBqjJw8TR/8Kk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Sergey Gorenko <sergeygo@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Laurence Oberman <loberman@redhat.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 059/127] RDMA/srp: Propagate ib_post_send() failures to the SCSI mid-layer
Date:   Fri, 22 Nov 2019 00:54:37 -0500
Message-Id: <20191122055544.3299-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2ee00f6a98c36f7e4ba07cc33f24cc5a69060cc9 ]

This patch avoids that the SCSI mid-layer keeps retrying forever if
ib_post_send() fails. This was discovered while testing immediate
data support and passing a too large num_sge value to ib_post_send().

Cc: Sergey Gorenko <sergeygo@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3f5b5893792cd..9f7287f45d06f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2210,6 +2210,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	if (srp_post_send(ch, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
+		scmnd->result = DID_ERROR << 16;
 		goto err_unmap;
 	}
 
-- 
2.20.1

