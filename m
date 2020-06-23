Return-Path: <SRS0=OzSu=AE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D56C433E0
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jun 2020 11:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF582072E
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jun 2020 11:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592911851;
	bh=8/vjl5AC/yKs/tlckxNmIkt9dH63zMIT6hMHVnBEvfA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=GNngFNpGlzWtyW176duTxjIXHSvPhEzcyVM7vQgNaEI/1TMJ5mpZQSQT3PRET2S1c
	 1Ou+nlXoggRujwnITV/4J6eYFXLZTjsBsEszRZ2zdZnuEW6iTw9xUyHjkcDQU2SRhz
	 Il59Q7c7xtLMO3cNdcXRpKY26ln0PLDEAhcJvRB0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbgFWLav (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732374AbgFWLat (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jun 2020 07:30:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECDE20702;
        Tue, 23 Jun 2020 11:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592911849;
        bh=8/vjl5AC/yKs/tlckxNmIkt9dH63zMIT6hMHVnBEvfA=;
        h=From:To:Cc:Subject:Date:From;
        b=zHiGxKWMOmTB0sEvb2NhmJpux28jXWnXJy9fUpuo5Jnr+JKjcwXXJFoP3+23yuGBJ
         mFdrr0CSI5HDP1HLdzOJjd2lckgarWHCrjIW9+KIGgoMUnH4hiwmXdnTB+F+HgO1/h
         so9L/xkcOMd460D86De4zzT3g74xESsvvNFsw9I4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: [PATCH rdma-next v3 00/11] RAW format dumps through RDMAtool
Date:   Tue, 23 Jun 2020 14:30:32 +0300
Message-Id: <20200623113043.1228482-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v3:
 * Rewrote query interface in patch "RDMA: Add support to dump resource
   tracker in RAW format"
v2:
https://lore.kernel.org/linux-rdma/20200616104006.2425549-1-leon@kernel.org
 * Converted to specific nldev ops for RAW.
 * Rebased on top of v5.8-rc1.
v1:
https://lore.kernel.org/linux-rdma/20200527135408.480878-1-leon@kernel.org
 * Maor dropped controversial change to dummy interface.
v0:
https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org

------------------------------------------------------------------------------

Hi,

The following series adds support to get the RDMA resource data in RAW
format. The main motivation for doing this is to enable vendors to return
the entire QP/CQ/MR data without a need from the vendor to set each
field separately.

Thanks


Maor Gottlieb (11):
  net/mlx5: Export resource dump interface
  net/mlx5: Add support in query QP, CQ and MKEY segments
  RDMA/core: Don't call fill_res_entry for PD
  RDMA: Add dedicated MR resource tracker function
  RDMA: Add a dedicated CQ resource tracker function
  RDMA: Add dedicated QP resource tracker function
  RDMA: Add dedicated CM_ID resource tracker function
  RDMA: Add support to dump resource tracker in RAW format
  RDMA/mlx5: Add support to get QP resource in RAW format
  RDMA/mlx5: Add support to get CQ resource in RAW format
  RDMA/mlx5: Add support to get MR resource in RAW format

 drivers/infiniband/core/device.c              |  10 +-
 drivers/infiniband/core/nldev.c               | 214 ++++++++++--------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |   7 +-
 drivers/infiniband/hw/cxgb4/provider.c        |  11 +-
 drivers/infiniband/hw/cxgb4/restrack.c        |  24 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
 drivers/infiniband/hw/hns/hns_roce_main.c     |   2 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c |  14 +-
 drivers/infiniband/hw/mlx5/main.c             |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   9 +-
 drivers/infiniband/hw/mlx5/restrack.c         | 105 +++++++--
 .../mellanox/mlx5/core/diag/rsc_dump.c        |   6 +
 .../mellanox/mlx5/core/diag/rsc_dump.h        |  33 +--
 .../diag => include/linux/mlx5}/rsc_dump.h    |  25 +-
 include/rdma/ib_verbs.h                       |  13 +-
 include/uapi/rdma/rdma_netlink.h              |   8 +
 16 files changed, 279 insertions(+), 213 deletions(-)
 copy {drivers/net/ethernet/mellanox/mlx5/core/diag => include/linux/mlx5}/rsc_dump.h (68%)

--
2.26.2

