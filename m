Return-Path: <SRS0=fSJB=EM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BF7C56201
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Nov 2020 18:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD78721D46
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Nov 2020 18:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KCAgJkpP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgKFSUP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 6 Nov 2020 13:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgKFSUN (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 6 Nov 2020 13:20:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC7C0613CF;
        Fri,  6 Nov 2020 10:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mhhxrFElh9XAgV4r8RFj88/oUF482qQDia6CDAfPp3A=; b=KCAgJkpPBd9RbBwfVfsiJt0bEJ
        vxkKj002ZBPd2P4huLXRf8se6b/AMgfHdQC4Jif8H9VV11DJTges84PlTFMq9Gxd6mEGgewd6tjni
        nDf7nkqnXhZzn+juogWqBHHKuId1j3g+1qtmG4XtBTUy6DDpC8W14PhXMUSBV0k6AVTssAr63HWo6
        6OWkHKrcXo1uJc0JjuvSdpWcXlfZ5Kzr45BEUEV/eMt6dU6eC7x9IP5DFWL6bvH4I4ZWFanhg2CYU
        Pz1ARAf3UPw/f2fJrrD89wiVfEzmsglTYRLYVvoesZu2zKuVIfY3wO0o+9Wf3caS8D42QR0HBVref
        7x/GANHQ==;
Received: from [2001:4bb8:184:9a8d:9e34:f7f4:e59e:ad6f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kb6Kt-0005cf-2Y; Fri, 06 Nov 2020 18:19:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Zhu Yanjun <yanjunz@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: remove dma_virt_ops v2
Date:   Fri,  6 Nov 2020 19:19:31 +0100
Message-Id: <20201106181941.1878556-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Jason,

this series switches the RDMA core to opencode the special case of
devices bypassing the DMA mapping in the RDMA ULPs.  The virt ops
have caused a bit of trouble due to the P2P code node working with
them due to the fact that we'd do two dma mapping iterations for a
single I/O, but also are a bit of layering violation and lead to
more code than necessary.

Tested with nvme-rdma over rxe.

Note that the rds changes are untested, as I could not find any
simple rds test setup.

Changes since v2:
 - simplify the INFINIBAND_VIRT_DMA dependencies
 - add a ib_uses_virt_dma helper
 - use ib_uses_virt_dma in nvmet-rdma to disable p2p for virt_dma devices
 - use ib_dma_max_seg_size in umem
 - stop using dmapool in rds

Changes since v1:
 - disable software RDMA drivers for highmem configs
 - update the PCI commit logs
