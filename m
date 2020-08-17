Return-Path: <SRS0=H3r4=B3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291B5C433E1
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Aug 2020 08:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB98220658
	for <linux-rdma@archiver.kernel.org>; Mon, 17 Aug 2020 08:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/4vmlNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHQIYx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgHQIYt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 17 Aug 2020 04:24:49 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3626C061388;
        Mon, 17 Aug 2020 01:24:49 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so7757002pgi.9;
        Mon, 17 Aug 2020 01:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5PXZFWOz2tb3F9fmRx1vDun4xD0bjs7mYvEnyzTCjpQ=;
        b=M/4vmlNWT6Gz+srqGzE/Hgm9csAqwc3+cbN/peKcOXhAxssJyRMgIL9InVoGwrP8cR
         XkTwAtO7sEr6w9WQO5CTKp0EZLfhVJg1hmPV/ONGhK04kcc7dFjCI4yuZzt7wH+yMPvI
         hTTIoYk+WoBAvFvFIkMTuiRGZnoHphTvUMevo4u19SGTOJez/q8XmJ0zQexoY8GVvsfV
         iaAhwMs4O8aTFxkHEG2HzfulWQ21enJjHBGHGj9bxuKr1azYF1iYKxUgCg7I8g13yZIz
         yACbWPBG1dD3c2xapLYUJr/n+SlUBQfRihlqVHfN4O+Cs3+Q+3BiR7ZJ5EhNz+bCWCV6
         xQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5PXZFWOz2tb3F9fmRx1vDun4xD0bjs7mYvEnyzTCjpQ=;
        b=gY+QipL7yJHjrvd4mjammUxP9Q0zE6+zlrga+9KaxEMl9gghBRy9NEQKl6gu7HOv+0
         OctM/bVmHQYr+f8HWKYgcH+gnPYMo8HompG5cqyVqfd/HG9jnMWyOLVnaiCgkelmsO3j
         K16GHJEg20rgUARjCSBkxfBePPfvKFJbyeDbqCnfTiwSC6jg2oApHMATRVC7LQUS//We
         a/0dW01/BdrC8dN3z5QyH7K0YCN7aT4Go88N9mirflLobYK+hRSGHyuoC+rMhpzILorp
         FsMNy70eQaZ+4aTBSeLoc3tsvk7bdjaMMhrhtvTPtx68BlU2sU0wUSOlzssNwDQFZwM+
         GYlg==
X-Gm-Message-State: AOAM5314RgXAALNgrVW9ydH3wkSiw90ave5nERofmfvvUY8H1c+ajrNJ
        jZEPTq+GUXkSltzRWmY0pbI=
X-Google-Smtp-Source: ABdhPJyxLtMMUfDCIVstyRxRcFSNlMMYFU2cAWVhiSHZPutOYLsNLsGg0f03p0A0H3087YVwgqvTWA==
X-Received: by 2002:a62:7644:: with SMTP id r65mr10455149pfc.271.1597652689287;
        Mon, 17 Aug 2020 01:24:49 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:24:48 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 00/20] ethernet: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:13 +0530
Message-Id: <20200817082434.21176-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts 
all the crypto modules to use the new tasklet_setup() API


Allen Pais (20):
  ethernet: alteon: convert tasklets to use new tasklet_setup() API
  ethernet: amd: convert tasklets to use new tasklet_setup() API
  broadcom: cnic: convert tasklets to use new tasklet_setup() API
  ethernet: cadence: convert tasklets to use new tasklet_setup() API
  ethernet: cavium: convert tasklets to use new tasklet_setup() API
  ethernet: chelsio: convert tasklets to use new tasklet_setup() API
  ethernet: dlink: convert tasklets to use new tasklet_setup() API
  ethernet: hinic: convert tasklets to use new tasklet_setup() API
  ethernet: ehea: convert tasklets to use new tasklet_setup() API
  ethernet: ibmvnic: convert tasklets to use new tasklet_setup() API
  ethernet: jme: convert tasklets to use new tasklet_setup() API
  ethernet: marvell: convert tasklets to use new tasklet_setup() API
  ethernet: mellanox: convert tasklets to use new tasklet_setup() API
  ethernet: micrel: convert tasklets to use new tasklet_setup() API
  ethernet: natsemi: convert tasklets to use new tasklet_setup() API
  ethernet: netronome: convert tasklets to use new tasklet_setup() API
  ethernet: ni: convert tasklets to use new tasklet_setup() API
  ethernet: qlogic: convert tasklets to use new tasklet_setup() API
  ethernet: silan: convert tasklets to use new tasklet_setup() API
  ethernet: smsc: convert tasklets to use new tasklet_setup() API

 drivers/net/ethernet/alteon/acenic.c          |  9 +++--
 drivers/net/ethernet/alteon/acenic.h          |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 19 +++++----
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c      | 11 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c     | 11 +++--
 drivers/net/ethernet/broadcom/cnic.c          | 18 ++++-----
 drivers/net/ethernet/cadence/macb_main.c      |  7 ++--
 .../net/ethernet/cavium/liquidio/lio_main.c   | 12 +++---
 .../ethernet/cavium/liquidio/octeon_main.h    |  1 +
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  8 ++--
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 10 ++---
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +-
 .../ethernet/cavium/thunder/nicvf_queues.h    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       | 12 ++++--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      | 14 +++----
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 12 +++---
 drivers/net/ethernet/dlink/sundance.c         | 20 +++++-----
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  7 ++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  7 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  7 ++--
 drivers/net/ethernet/jme.c                    | 40 ++++++++-----------
 drivers/net/ethernet/marvell/skge.c           |  6 +--
 drivers/net/ethernet/mellanox/mlx4/cq.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c       |  3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  7 ++--
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 12 +++---
 drivers/net/ethernet/micrel/ks8842.c          | 19 ++++-----
 drivers/net/ethernet/micrel/ksz884x.c         | 14 +++----
 drivers/net/ethernet/natsemi/ns83820.c        |  8 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 ++--
 drivers/net/ethernet/ni/nixge.c               |  7 ++--
 drivers/net/ethernet/qlogic/qed/qed.h         |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 27 ++-----------
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 14 +++----
 drivers/net/ethernet/silan/sc92031.c          | 11 ++---
 drivers/net/ethernet/smsc/smc91x.c            | 10 ++---
 41 files changed, 178 insertions(+), 219 deletions(-)

-- 
2.17.1

