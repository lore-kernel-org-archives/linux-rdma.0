Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57293EB64D8
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Jun 2023 15:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjFVPUs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjFVPUq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 22 Jun 2023 11:20:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4350919A1
        for <linux-rdma@vger.kernel.org>; Thu, 22 Jun 2023 08:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5C66617B0
        for <linux-rdma@vger.kernel.org>; Thu, 22 Jun 2023 15:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C413CC433C0;
        Thu, 22 Jun 2023 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687447245;
        bh=Ft4T15mYM44LFVGCbeCI8XWz6EdO6piD5ud1i1JpF/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YRfteNRxbyuAyuSmEMdRezIxunPEP4G28QN1jO5qOugNVMS6A7ENxVqwSPelUGmTW
         XyG5qIa8Lw2GnMMzKUy14CxDqRCBvEpDDlIDPfFDTL8/X8AREz6ysndHhOKetTfIHn
         A1dNinTADNyCBdGh/yYwSWYwBeCpwxqLionC7eCKiFjIkgVtkheDHwS7eImC/0n4Rs
         5IrNqn/2VJs/Q3tykci9cJBc5bWNnLUX/YQrLKfP3Zvh/V7s49DlAr9eB7/TH4Zsm9
         0Rd8XGDKccwtG0EIL2ibjCKVex8sSWsLs4OwZ+onkf3F7oCI01m4knWRPsoQldvkaW
         TX8w1tqf3+P3Q==
Subject: [PATCH v4 4/4] RDMA/cma: Avoid GID lookups on iWARP devices
From:   Chuck Lever <cel@kernel.org>
To:     jgg@nvidia.com
Cc:     Chuck Lever <chuck.lever@oracle.com>, tom@talpey.com,
        linux-rdma@vger.kernel.org, BMT@zurich.ibm.com,
        yanjun.zhu@linux.dev
Date:   Thu, 22 Jun 2023 11:20:43 -0400
Message-ID: <168744724392.136340.9404948097647851506.stgit@manet.1015granger.net>
In-Reply-To: <168744710872.136340.12090873711939747309.stgit@manet.1015granger.net>
References: <168744710872.136340.12090873711939747309.stgit@manet.1015granger.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

We would like to enable the use of siw on top of a VPN that is
constructed and managed via a tun device. That hasn't worked up
until now because ARPHRD_NONE devices (such as tun devices) have
no GID for the RDMA/core to look up.

But it turns out that the egress device has already been picked for
us -- no GID is necessary. addr_handler() just has to do the right
thing with it.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 drivers/infiniband/core/cma.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a1756ed1faa1..45c4544c7687 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -700,6 +700,21 @@ cma_validate_port(struct ib_device *device, u32 port,
 	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
 		goto out;
 
+	/* Linux iWARP devices have but one port */
+	if (rdma_protocol_iwarp(device, port)) {
+		sgid_attr = rdma_get_gid_attr(device, port, 0);
+		if (IS_ERR(sgid_attr))
+			goto out;
+
+		rcu_read_lock();
+		ndev = rcu_dereference(sgid_attr->ndev);
+		if (!net_eq(dev_net(ndev), dev_addr->net) ||
+		    ndev->ifindex != bound_if_index)
+			sgid_attr = ERR_PTR(-ENODEV);
+		rcu_read_unlock();
+		goto out;
+	}
+
 	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port)) {
 		ndev = dev_get_by_index(dev_addr->net, bound_if_index);
 		if (!ndev)


