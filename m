Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2F9C433ED
	for <linux-rdma@archiver.kernel.org>; Sun, 18 Apr 2021 21:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78346610CB
	for <linux-rdma@archiver.kernel.org>; Sun, 18 Apr 2021 21:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhDRV02 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 18 Apr 2021 17:26:28 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:26679 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhDRV01 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 18 Apr 2021 17:26:27 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d25 with ME
        id uMRt2400521Fzsu03MRuCc; Sun, 18 Apr 2021 23:25:56 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Apr 2021 23:25:56 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        bvanassche@acm.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] workqueue: Have 'alloc_workqueue()' like macros accept a  format specifier
Date:   Sun, 18 Apr 2021 23:25:52 +0200
Message-Id: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Improve 'create_workqueue', 'create_freezable_workqueue' and
'create_singlethread_workqueue' so that they accept a format
specifier and a variable number of arguments.

This will put these macros more in line with 'alloc_ordered_workqueue' and
the underlying 'alloc_workqueue()' function.

This will also allow further code simplification.

Patch 1 is the modification of the macro.
Patch 2 is an example of simplification possible with this patch

Christophe JAILLET (2):
  workqueue: Have 'alloc_workqueue()' like macros accept a  format
    specifier
  net/mlx5: Simplify workqueue name creation

 drivers/net/ethernet/mellanox/mlx5/core/health.c |  9 +--------
 include/linux/workqueue.h                        | 14 +++++++-------
 2 files changed, 8 insertions(+), 15 deletions(-)

-- 
2.27.0

