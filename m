Return-Path: <SRS0=kW50=7P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C658C433DF
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 12:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E97206A4
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591102556;
	bh=h1VSlMeDOSB2oJ5fRPHYFLgzuYatrYBFJIKuKideGPg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=RswTdqmOjZNukeWiSXMU3G3fQ0VKot+U++7GnpJqTuUpj4vZazZeeNMnMqgkCSBdg
	 ftRE1/gv/dyWbfsd+6nGX7+sU34fC8Yl5qUDLSoYK0dRxZAZxUaUQbhokXR4wViaZ/
	 K0BA8DUzI+y6R4+tFugMXoGSqgcs1IRLYXejLDSA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgFBMzz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Jun 2020 08:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgFBMzz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 2 Jun 2020 08:55:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 408E320663;
        Tue,  2 Jun 2020 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591102554;
        bh=h1VSlMeDOSB2oJ5fRPHYFLgzuYatrYBFJIKuKideGPg=;
        h=From:To:Cc:Subject:Date:From;
        b=pQ0CQTSdiF9azd9rWMjMKIYNKkv6P0O5AjEEpa5DPmE5TXQvQu4Zk8fZnUR8ZHw5j
         WB8f+fjx3Z36emNlrurXTuVJFl7yKtr6/ZAFnqUNzrh4Evwuxd6wNdFNTcEDxv+Jz4
         LSJWg0Roj+P/EDQC21zPktVe3bBNNjMnP/TTtlmI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH rdma-next 0/3] mlx5 ECE fixes DC ECE code
Date:   Tue,  2 Jun 2020 15:55:45 +0300
Message-Id: <20200602125548.172654-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This are three patches which I would ask to consider for current PR
to Linus.

First two patches are fixing corner cases that are not possible
in the real life and the third patch is needed to ensure that API
toward user space is feature complete and won't need any extra
ucontext flags.

The code of third patch was already presented in v0 and v1,
but was dropped later.

Leon Romanovsky (3):
  RDMA/mlx5: Return an error if copy_to_user fails
  RDMA/mlx5: Don't rely on FW to set zeros in ECE response
  RDMA/mlx5: Return ECE DC support

 drivers/infiniband/hw/mlx5/qp.c | 59 +++++++++++++++++++++------------
 include/linux/mlx5/mlx5_ifc.h   |  5 +--
 2 files changed, 40 insertions(+), 24 deletions(-)

--
2.26.2

