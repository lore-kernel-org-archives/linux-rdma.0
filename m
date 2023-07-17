Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27DDC001DC
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Jul 2023 19:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjGQTfw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGQTfv (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 17 Jul 2023 15:35:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD3FF94;
        Mon, 17 Jul 2023 12:35:49 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 47DE521C79F7; Mon, 17 Jul 2023 12:35:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 47DE521C79F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1689622549;
        bh=bRJBnZIyqX5lWmieXAT5ZWBktdQw7iN0MiN86gS1bd0=;
        h=From:To:Cc:Subject:Date:From;
        b=FSes38XLYRvwpgBOLXqCMKTllE5Fn+meWS17Z7wLy4WuBJ2bJZ3G+l6hAcXCJ3F25
         azrdSglq7K4YZOdoKS3vngSVIaD4GS6ZIofZXh254RVWJAibOqPV2C+dLX4bDL6zfB
         IYQ7LEUPISs1Xzs+/vopNwzUNYYimufW4X8f+q/8=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Shradha Gupta <shradhagupta@linux.microsoft.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: [PATCH net-next v5 0/2] net: mana: Fix doorbell access for receive queues
Date:   Mon, 17 Jul 2023 12:35:37 -0700
Message-Id: <1689622539-5334-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Long Li <longli@microsoft.com>

This patchset fixes the issues discovered during 200G physical link
tests. It fixes doorbell usage and WQE format for receive queues.

Long Li (2):
  net: mana: Batch ringing RX queue doorbell on receiving packets
  net: mana: Use the correct WQE count for ringing RQ doorbell

 drivers/net/ethernet/microsoft/mana/gdma_main.c |  5 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 10 ++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.34.1

