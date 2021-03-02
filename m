Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9ADC433DB
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Mar 2021 17:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BFB64F2C
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Mar 2021 17:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579820AbhCBRKa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Mar 2021 12:10:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12668 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344662AbhCBMyG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 2 Mar 2021 07:54:06 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqcRt3NtJzlRyZ;
        Tue,  2 Mar 2021 20:50:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 20:52:37 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <dledford@redhat.com>, <linux-rdma@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH rdma-core 0/5] libhns: Support XRC on HIP09
Date:   Tue, 2 Mar 2021 20:50:19 +0800
Message-ID: <1614689424-27154-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The HIP09 supports XRC transport service, it greatly saves the number of
QPs required to connect all processes in a large cluster.

This series first adds support of ibv_create_qp/srq_ex which are necessary
interfaces for XRC, fixes an issue about CQ locks that is also required,
then XRC is fully supported at last.

Lang Cheng (1):
  libhns: Support ibv_create_qp_ex

Weihang Li (2):
  Update kernel headers
  libhns: Avoid accessing NULL pointer when locking/unlocking CQ

Wenpeng Liang (2):
  libhns: Support ibv_create_srq_ex
  libhns: Add support for XRC for HIP09

 kernel-headers/rdma/hns-abi.h    |   2 +
 providers/hns/hns_roce_u.c       |  28 ++-
 providers/hns/hns_roce_u.h       |  40 +++-
 providers/hns/hns_roce_u_abi.h   |  11 +-
 providers/hns/hns_roce_u_hw_v1.c |  18 +-
 providers/hns/hns_roce_u_hw_v2.c | 159 +++++++++-----
 providers/hns/hns_roce_u_hw_v2.h |   1 +
 providers/hns/hns_roce_u_verbs.c | 455 +++++++++++++++++++++++++++++++--------
 8 files changed, 546 insertions(+), 168 deletions(-)

-- 
2.8.1

