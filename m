Return-Path: <SRS0=N7RC=7W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8193EC433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 00:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5218720775
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 00:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591662223;
	bh=KBWPKQIt+taU0zd7eRyOsTlZM6WJYJezUwbGQz12dok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vhJKsf0OEQPdMPE1XjQHRo0PF2Jkaj0TblTDOptdk+wO1gOXgHq0dmw/q8Nq7itvC
	 0sp9FX6zEYN3hIzvWcrYQsAlogG16AB/CpzaiZXTaSkIQosw1YFKiB/eGsnEaCLncq
	 IPUisgdkYgnOTmXsE1NLsjjFcDGws14TN0S1Z2Ec=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgFIAXe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgFHXRO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547DB20814;
        Mon,  8 Jun 2020 23:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658234;
        bh=KBWPKQIt+taU0zd7eRyOsTlZM6WJYJezUwbGQz12dok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHrY81JpL3hSq+U158CKO36Ix9ZDYor+ACNG9GJ4GWHL+xBlJncV/SIWHAO2n1k5S
         f8pdMdhBCnprKx1Rc/FRWr7uRWW2Vojy+yACi8wyHfF4fmEZGTIGWz4USS1ag7Msvv
         nxAomsPv4W9+gwzwV8uiDLq6XWbe60VT5XturwWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 246/606] net/mlx4_core: fix a memory leak bug.
Date:   Mon,  8 Jun 2020 19:06:11 -0400
Message-Id: <20200608231211.3363633-246-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit febfd9d3c7f74063e8e630b15413ca91b567f963 upstream.

In function mlx4_opreq_action(), pointer "mailbox" is not released,
when mlx4_cmd_box() return and error, causing a memory leak bug.
Fix this issue by going to "out" label, mlx4_free_cmd_mailbox() can
free this pointer.

Fixes: fe6f700d6cbb ("net/mlx4_core: Respond to operation request by firmware")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 6e501af0e532..f6ff9620a137 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2734,7 +2734,7 @@ void mlx4_opreq_action(struct work_struct *work)
 		if (err) {
 			mlx4_err(dev, "Failed to retrieve required operation: %d\n",
 				 err);
-			return;
+			goto out;
 		}
 		MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);
 		MLX4_GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);
-- 
2.25.1

