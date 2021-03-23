Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729E8C433DB
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Mar 2021 02:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 294D8619A5
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Mar 2021 02:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCWCGM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 22 Mar 2021 22:06:12 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:58482 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCWCGJ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 22 Mar 2021 22:06:09 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2021 22:06:08 EDT
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 03FD3980304;
        Tue, 23 Mar 2021 10:00:27 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: ethernet: indir_table.h is included twice
Date:   Tue, 23 Mar 2021 10:00:12 +0800
Message-Id: <20210323020013.138697-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQ01MTRgaSkJMGR9KVkpNSk1PTU9DSUNJT01VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PE06Sww6ND8IMDotPhoVGhAv
        IwMKCQtVSlVKTUpNT01PQ0lDTUpCVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKQ0lLNwY+
X-HM-Tid: 0a785ccfd716d992kuws03fd3980304
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

indir_table.h has been included at line 41, so remove 
the duplicate one at line 43.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94cb0217b4f3..aba13e5af216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -40,7 +40,6 @@
 #include "eswitch.h"
 #include "esw/indir_table.h"
 #include "esw/acl/ofld.h"
-#include "esw/indir_table.h"
 #include "rdma.h"
 #include "en.h"
 #include "fs_core.h"
-- 
2.25.1

