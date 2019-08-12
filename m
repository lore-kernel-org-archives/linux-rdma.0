Return-Path: <SRS0=ZP0N=WI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9249C433FF
	for <linux-rdma@archiver.kernel.org>; Mon, 12 Aug 2019 16:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B99982070C
	for <linux-rdma@archiver.kernel.org>; Mon, 12 Aug 2019 16:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfHLQ7y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:59:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54143 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726548AbfHLQ7x (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 12 Aug 2019 12:59:53 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from haimbo@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Aug 2019 19:59:51 +0300
Received: from r-ufm115.mtr.labs.mlnx (r-ufm115.mtr.labs.mlnx [10.209.36.210])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7CGxpFw002663;
        Mon, 12 Aug 2019 19:59:51 +0300
Received: from r-ufm115.mtr.labs.mlnx (localhost [127.0.0.1])
        by r-ufm115.mtr.labs.mlnx (8.14.7/8.14.7) with ESMTP id x7CGxpDY024844;
        Mon, 12 Aug 2019 16:59:51 GMT
Received: (from haimbo@localhost)
        by r-ufm115.mtr.labs.mlnx (8.14.7/8.14.7/Submit) id x7CGxpsA024843;
        Mon, 12 Aug 2019 16:59:51 GMT
From:   Haim Boozaglo <haimbo@mellanox.com>
To:     linux-rdma@vger.kernel.org
Cc:     Haim Boozaglo <haimbo@mellanox.com>
Subject: [PATCH rdma-core 0/1] Support 128 IB devices
Date:   Mon, 12 Aug 2019 16:59:47 +0000
Message-Id: <1565629188-24799-1-git-send-email-haimbo@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series extend the maximum of available InfiniBand devices
to 128.

Thanks

Haim Boozaglo (1):
  libibumad: Support 128 devices

 libibumad/umad.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.3.1

