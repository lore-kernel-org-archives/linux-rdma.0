Return-Path: <SRS0=0Liq=A6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2D1C433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 19 Jul 2020 06:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FCCD207DA
	for <linux-rdma@archiver.kernel.org>; Sun, 19 Jul 2020 06:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595138607;
	bh=5r4ndYrrAdlYXN5OgGxy/O51eiQUBWMK9MagzRG85us=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=D6nKh/fnLJz75f+ZCYTlttXhJGkKnEARCaFUL9AIiIhWfRCP0zN+M4Vq8cpyBbpis
	 wcpiwNym3WTdPh6v/QRKJxjwxhHehnGWlyC2I1y6CyX50phf8znhGHgGusH44m0L34
	 V9KprFG5CzOnuWeoX2PwazYpr5KMQc1SceUUCQL0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgGSGD0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 19 Jul 2020 02:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgGSGD0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 19 Jul 2020 02:03:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18D0120738;
        Sun, 19 Jul 2020 06:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595138605;
        bh=5r4ndYrrAdlYXN5OgGxy/O51eiQUBWMK9MagzRG85us=;
        h=From:To:Cc:Subject:Date:From;
        b=RQVKSv9XLAP1sRQ12O2hEesTqr8AKRt8sE8Vy8IwBNC/VPaTDIxbXdEHsF1pbUuP7
         iQmdTrf9ji2pEzWEsByjwl2JJ7vy+H3pEX+4PDgm83NY0V+8saa0SJsA1itSfD75im
         3MkVywp4d1UwxowLJGCWfmE9wOSYk6sribUSqzBA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 0/2] Fix warnings reported by kbuild
Date:   Sun, 19 Jul 2020 09:03:17 +0300
Message-Id: <20200719060319.77603-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

There are two change as were reported by kbuild. They are not important
enough to have Fixes line.

Thanks

Leon Romanovsky (2):
  RDMA/uverbs: Remove redundant assignments
  RDMA/uverbs: Silence shiftTooManyBitsSigned warning

 drivers/infiniband/core/uverbs_cmd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--
2.26.2

