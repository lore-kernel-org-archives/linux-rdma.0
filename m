Return-Path: <SRS0=zY9Z=2A=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706B9C43603
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Dec 2019 22:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF6320828
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Dec 2019 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576017351;
	bh=A47+vKFAqvpWsAajzfDUfLGO+4fxidIRoS8mEKh+bEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hAHVqTLLyAw0L8R+5+aUjR6KGMyW9xnMSHBDliRRGOy6seZ96s2kwK0SGgxjQo/d/
	 e6yAOZJGW8gxbbJZCu4lq6uOqZ1LgtXYRD16YmHIoCJaoRF+Pze1MKSnhuyrTxEAGZ
	 6JT8G3l94C50cg+FIbNk5Z6T8Se+oPOkApCjXI5Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbfLJWfq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Dec 2019 17:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbfLJWea (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Dec 2019 17:34:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B886D20828;
        Tue, 10 Dec 2019 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017269;
        bh=A47+vKFAqvpWsAajzfDUfLGO+4fxidIRoS8mEKh+bEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPMdn8U69z/pjadcYEq7T+DwYN440AZRwRSk21DiCRNidcbjxSNLbmo8kxqTxAvzS
         4Igj0jlizF3ztVd1ydm4vrfIT9Mn7EVtIUqz4HapVozgJo9aiaIYJXu97CVDdSqkXe
         H+mgLme3ocgdbN+Jfx6eMRHnfYEbvGlIVhfukHfA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 61/71] RDMA/qib: Validate ->show()/store() callbacks before calling them
Date:   Tue, 10 Dec 2019 17:33:06 -0500
Message-Id: <20191210223316.14988-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 7ee23491b39259ae83899dd93b2a29ef0f22f0a7 ]

The permissions of the read-only or write-only sysfs files can be
changed (as root) and the user can then try to read a write-only file or
write to a read-only file which will lead to kernel crash here.

Protect against that by always validating the show/store callbacks.

Link: https://lore.kernel.org/r/d45cc26361a174ae12dbb86c994ef334d257924b.1573096807.git.viresh.kumar@linaro.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 81f56cdff2bc2..3ae82202cdb55 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -301,6 +301,9 @@ static ssize_t qib_portattr_show(struct kobject *kobj,
 	struct qib_pportdata *ppd =
 		container_of(kobj, struct qib_pportdata, pport_kobj);
 
+	if (!pattr->show)
+		return -EIO;
+
 	return pattr->show(ppd, buf);
 }
 
@@ -312,6 +315,9 @@ static ssize_t qib_portattr_store(struct kobject *kobj,
 	struct qib_pportdata *ppd =
 		container_of(kobj, struct qib_pportdata, pport_kobj);
 
+	if (!pattr->store)
+		return -EIO;
+
 	return pattr->store(ppd, buf, len);
 }
 
-- 
2.20.1

