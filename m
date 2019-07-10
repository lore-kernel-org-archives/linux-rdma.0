Return-Path: <SRS0=nSk8=VH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05235C74A21
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 14:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCF1820651
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 14:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfGJOb5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Jul 2019 10:31:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47973 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726617AbfGJOb5 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 10 Jul 2019 10:31:57 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from noaos@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 17:31:51 +0300
Received: from reg-l-vrt-059-007.mtl.labs.mlnx (reg-l-vrt-059-007.mtl.labs.mlnx [10.135.59.7])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6AEVpIi004077;
        Wed, 10 Jul 2019 17:31:51 +0300
From:   Noa Osherovich <noaos@mellanox.com>
To:     dledford@redhat.com, jgg@mellanox.com, leonro@mellanox.com
Cc:     linux-rdma@vger.kernel.org, Noa Osherovich <noaos@mellanox.com>
Subject: [PATCH rdma-core 0/4] pyverbs fixes
Date:   Wed, 10 Jul 2019 17:22:47 +0300
Message-Id: <20190710142251.9396-1-noaos@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The following is a series of fixes to pyverbs:
The first two patches clean the compilation warning introduces in
Fedora 30.
The third patch fixes a wrong casting.
The last one fixes the handling of bad work requests in post send and
post recv operations.

Maxim Chicherin (1):
  pyverbs: Avoid casting pointers to object type

Noa Osherovich (3):
  pyverbs: Fix Cython future warning during build
  build: Remove warning-causing compilation flag from pyverbs
  pyverbs: Fix assignments of bad work requests

 CMakeLists.txt                   |  7 +++++
 buildlib/pyverbs_functions.cmake |  7 ++++-
 pyverbs/addr.pxd                 |  2 ++
 pyverbs/base.pxd                 |  2 ++
 pyverbs/cq.pxd                   |  3 ++
 pyverbs/cq.pyx                   | 23 ++------------
 pyverbs/device.pxd               |  2 ++
 pyverbs/libibverbs_enums.pxd     |  3 ++
 pyverbs/mr.pxd                   |  2 ++
 pyverbs/pd.pxd                   |  3 ++
 pyverbs/pd.pyx                   |  4 ---
 pyverbs/qp.pxd                   |  3 ++
 pyverbs/qp.pyx                   | 54 ++++++++++++++++++--------------
 pyverbs/wr.pxd                   |  2 ++
 pyverbs/wr.pyx                   | 17 +++-------
 15 files changed, 73 insertions(+), 61 deletions(-)

-- 
2.21.0

