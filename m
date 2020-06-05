Return-Path: <SRS0=eUhC=7S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1CAC433DF
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Jun 2020 12:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB242070B
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Jun 2020 12:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591360245;
	bh=l4goMsgBlX7Qdo2R6HC4NAyX8/LlC3Ade5FePF2ZsME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VIzFEfXo959yhuIBuPOXVnveHMRQJx4rJPZW74J6ZbJ1nOKarVrqO9EnXkDpuEkUq
	 YteNdMpaXxjASu98UzpCVNazzCFh0ySl370xfUwdcdgz8nk8bwsdouBhsx4U3mJa9Z
	 pFVH1efHJ9V4AklqQzQSNSw1HmZf6X6+77PtR+kU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFEMZf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Jun 2020 08:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgFEMZe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B0A2075B;
        Fri,  5 Jun 2020 12:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359934;
        bh=l4goMsgBlX7Qdo2R6HC4NAyX8/LlC3Ade5FePF2ZsME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKO48Us345OfDmSot9pl9Gj3z0XcLzDYdJW6DbYpx/rMME6NQPh/hK8aw8WsztMGa
         nf9g/d4wrNwZSFs3kGg9BY6WmCQNVZz5LBj86z4AQJ+yitd0pfZoGinZReU+BcqwgQ
         fGSGPp4zDFuju//w8qwBmhhQi+tg/0GR48nXTtpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bloch <markb@mellanox.com>, Dexuan Cui <decui@microsoft.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 13/17] net/mlx5: Fix crash upon suspend/resume
Date:   Fri,  5 Jun 2020 08:25:12 -0400
Message-Id: <20200605122517.2882338-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122517.2882338-1-sashal@kernel.org>
References: <20200605122517.2882338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

[ Upstream commit 8fc3e29be9248048f449793502c15af329f35c6e ]

Currently a Linux system with the mlx5 NIC always crashes upon
hibernation - suspend/resume.

Add basic callbacks so the NIC could be suspended and resumed.

Fixes: 9603b61de1ee ("mlx5: Move pci device handling from mlx5_ib to mlx5_core")
Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 4a08e4eef283..20e12e14cfa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1552,6 +1552,22 @@ static void shutdown(struct pci_dev *pdev)
 	mlx5_pci_disable_device(dev);
 }
 
+static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	mlx5_unload_one(dev, false);
+
+	return 0;
+}
+
+static int mlx5_resume(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	return mlx5_load_one(dev, false);
+}
+
 static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_CONNECTIB) },
 	{ PCI_VDEVICE(MELLANOX, 0x1012), MLX5_PCI_DEV_IS_VF},	/* Connect-IB VF */
@@ -1595,6 +1611,8 @@ static struct pci_driver mlx5_core_driver = {
 	.id_table       = mlx5_core_pci_table,
 	.probe          = init_one,
 	.remove         = remove_one,
+	.suspend        = mlx5_suspend,
+	.resume         = mlx5_resume,
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,
-- 
2.25.1

