Return-Path: <SRS0=U2Q+=AF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F36C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Jun 2020 07:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C1C20707
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Jun 2020 07:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592982037;
	bh=MIORqyQDwLsFzQLTTBHEauugveavFQz8SerbM8rtl4c=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2ugEheYIrdzjmGBAr6gyoVU3mJdF5w6dFWRw8XgDht6Hp0lSh2YBhOkAn1bwULWn8
	 4yQr+2hII7gppeHNf3FYAy5sx2Iyg61Ya7Oty9yOuesTcjiWbvfDSubQInt0pRXDWW
	 HB/JN87zP7Wy7UDJxmvbV+8DA7OueU4wvkWknRNs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbgFXHAg (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgFXHAg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 24 Jun 2020 03:00:36 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C57C206E2;
        Wed, 24 Jun 2020 07:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592982036;
        bh=MIORqyQDwLsFzQLTTBHEauugveavFQz8SerbM8rtl4c=;
        h=From:To:Cc:Subject:Date:From;
        b=mqGVCjA/KKAd//EiphSQXXVNg3iPvbOjzH+EUAGaxUO4a2ak+rFoJQ0lwdoL6UuJw
         5DniX135rKCdm/+9wR8hVkTW1ghxczqPniWoSu19hRMtUoizlUQAWygMUHSoyss9yz
         E6rfrrv7DaqkeRDN/0YYZSTu5yI0Qa8hqbWGnkYM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH wip/jgg-next] fixup! RDMA: Add support to dump resource tracker in RAW format
Date:   Wed, 24 Jun 2020 10:00:31 +0300
Message-Id: <20200624070031.1436711-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Rebase error against
https://lore.kernel.org/r/20200507062942.98305-1-leon@kernel.org

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 904e91061f9c..1051b5622b62 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1301,8 +1301,6 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	has_cap_net_admin = netlink_capable(skb, CAP_NET_ADMIN);

 	ret = fill_func(msg, has_cap_net_admin, res, port);
-
-	rdma_restrack_put(res);
 	if (ret)
 		goto err_free;

--
2.26.2

