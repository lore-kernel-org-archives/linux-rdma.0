Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79022C433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Feb 2021 13:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236ED64EB8
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Feb 2021 13:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBINMK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhBINLx (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 9 Feb 2021 08:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F4264ECB;
        Tue,  9 Feb 2021 13:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612876273;
        bh=mq/ywroL3r1LhGpoKQ8X+tQCU9hQV0yV+sfIi3ZLdwQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lNGHusaNbjGjfb/8C1/CnHa78J5LtpGL9ZHH6b7uJCD6OXzLcXp2cgoMSXBo0Dp4o
         h+UAC0ok0UrSItFKuYB7owIo9n7uIduolTpVDpyW0b5/tM7u4K+nKE3qthkLX6yclg
         kkmWlBnrnoL4cN5BEtAEdvkGHeQaW0jmL6ODPtpp+by3MzDcmde/D1d9nTF0OV3S49
         zazkQuTJnXnx48ed3nYoiYTy61PCCjTuSwt9bB0P9NNB0VnfFsEd41PcLeNFFg61bn
         wJZ5CVbw7CsVwBVAmArIlLtZhizADeSlU5g2lTWTdIiBO+I9JbwYnq+GLLdgEpjn6U
         HWlZMIPXS5AlA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/2] Real time/free running timestamp support
Date:   Tue,  9 Feb 2021 15:11:05 +0200
Message-Id: <20210209131107.698833-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Add an extra timestamp format for mlx5_ib device.

Thanks

Aharon Landau (2):
  net/mlx5: Add new timestamp mode bits
  RDMA/mlx5: Fail QP creation if the device can not support the CQE TS

 drivers/infiniband/hw/mlx5/qp.c | 104 +++++++++++++++++++++++++++++---
 include/linux/mlx5/mlx5_ifc.h   |  54 +++++++++++++++--
 2 files changed, 145 insertions(+), 13 deletions(-)

--
2.29.2

