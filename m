Return-Path: <SRS0=wxv4=55=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F979C2BBFD
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 06:41:00 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD58E20737
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Apr 2020 06:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD58E20737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-rdma-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgDMGk5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Apr 2020 02:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbgDMGk5 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 13 Apr 2020 02:40:57 -0400
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DA5C008678
        for <linux-rdma@vger.kernel.org>; Sun, 12 Apr 2020 23:40:56 -0700 (PDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 61C96ECC34ED64DCCF28;
        Mon, 13 Apr 2020 14:40:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Apr 2020 14:40:41 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/6] RDMA/hns: Codes optimization
Date:   Mon, 13 Apr 2020 14:40:36 +0800
Message-ID: <1586760042-40516-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series optimize some codes in hns drivers. The first two patches are
mainly to remove unnecessary memset(), and the others use map table to
simplify the conversion of values.

Lang Cheng (4):
  RDMA/hns: Simplify the qp state convert code
  RDMA/hns: Simplify the cqe code of poll cq
  RDMA/hns: Simplify the state judgment code of qp
  RDMA/hns: Simplify the status judgment code of hns_roce_v1_m_qp()

Lijun Ou (2):
  RDMA/hns: Optimize hns_roce_config_link_table()
  RDMA/hns: Optimize hns_roce_v2_set_mac()

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |  42 +++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 269 +++++++++++++----------------
 2 files changed, 150 insertions(+), 161 deletions(-)

-- 
2.8.1

