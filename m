Return-Path: <SRS0=PR/X=XE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66240C00307
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Sep 2019 09:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4470D21924
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Sep 2019 09:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389624AbfIIJHT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 9 Sep 2019 05:07:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48367 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389599AbfIIJHT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 9 Sep 2019 05:07:19 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from noaos@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 9 Sep 2019 12:07:16 +0300
Received: from reg-l-vrt-059-007.mtl.labs.mlnx (reg-l-vrt-059-007.mtl.labs.mlnx [10.135.59.7])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8997Fp6028426;
        Mon, 9 Sep 2019 12:07:16 +0300
From:   Noa Osherovich <noaos@mellanox.com>
To:     dledford@redhat.com, jgg@mellanox.com, leonro@mellanox.com
Cc:     linux-rdma@vger.kernel.org, Maxim Chicherin <maximc@mellanox.com>
Subject: [PATCH rdma-core 08/12] Documentation: Document creation of XRCD and SRQ
Date:   Mon,  9 Sep 2019 12:07:08 +0300
Message-Id: <20190909090712.11029-9-noaos@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190909090712.11029-1-noaos@mellanox.com>
References: <20190909090712.11029-1-noaos@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maxim Chicherin <maximc@mellanox.com>

Add code snippets to demonstrate creation of XRCD and SRQ.

Signed-off-by: Maxim Chicherin <maximc@mellanox.com>
---
 Documentation/pyverbs.md | 51 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 mode change 100644 => 100755 Documentation/pyverbs.md

diff --git a/Documentation/pyverbs.md b/Documentation/pyverbs.md
old mode 100644
new mode 100755
index 22c51868e025..29ab9592c53c
--- a/Documentation/pyverbs.md
+++ b/Documentation/pyverbs.md
@@ -339,3 +339,54 @@ wr = pwr.SendWR()
 wr.set_wr_ud(ah, 0x1101, 0) # in real life, use real values
 udqp.post_send(wr)
 ```
+
+##### XRCD
+The following code demonstrates creation of an XRCD object.
+```python
+from pyverbs.xrcd import XRCD, XRCDInitAttr
+import pyverbs.device as d
+import pyverbs.enums as e
+import stat
+import os
+
+
+ctx = d.Context(name='ibp0s8f0')
+xrcd_fd = os.open('/tmp/xrcd', os.O_RDONLY | os.O_CREAT,
+                  stat.S_IRUSR | stat.S_IRGRP)
+init = XRCDInitAttr(e.IBV_XRCD_INIT_ATTR_FD | e.IBV_XRCD_INIT_ATTR_OFLAGS,
+                    os.O_CREAT, xrcd_fd)
+xrcd = XRCD(ctx, init)
+```
+
+##### SRQ
+The following code snippet will demonstrate creation of an XRC SRQ object.
+For more complex examples, please see pyverbs/tests/test_odp.
+```python
+from pyverbs.xrcd import XRCD, XRCDInitAttr
+from pyverbs.srq import SRQ, SrqInitAttrEx
+import pyverbs.device as d
+import pyverbs.enums as e
+from pyverbs.cq import CQ
+from pyverbs.pd import PD
+import stat
+import os
+
+
+ctx = d.Context(name='ibp0s8f0')
+pd = PD(ctx)
+cq = CQ(ctx, 100, None, None, 0)
+xrcd_fd = os.open('/tmp/xrcd', os.O_RDONLY | os.O_CREAT,
+                  stat.S_IRUSR | stat.S_IRGRP)
+init = XRCDInitAttr(e.IBV_XRCD_INIT_ATTR_FD | e.IBV_XRCD_INIT_ATTR_OFLAGS,
+                    os.O_CREAT, xrcd_fd)
+xrcd = XRCD(ctx, init)
+
+srq_attr = SrqInitAttrEx(max_wr=10)
+srq_attr.srq_type = e.IBV_SRQT_XRC
+srq_attr.pd = pd
+srq_attr.xrcd = xrcd
+srq_attr.cq = cq
+srq_attr.comp_mask = e.IBV_SRQ_INIT_ATTR_TYPE | e.IBV_SRQ_INIT_ATTR_PD | \
+                     e.IBV_SRQ_INIT_ATTR_CQ | e.IBV_SRQ_INIT_ATTR_XRCD
+srq = SRQ(ctx, srq_attr)
+```
-- 
2.21.0

