Return-Path: <SRS0=uWV+=4X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157BBC3F2D1
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Mar 2020 01:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D01AD208CD
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Mar 2020 01:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583456808;
	bh=aURKFQvIjafRMU6Gm9pVZS/vH2n9loe7wUOjvdcmpyE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=rHlOoVvSOV6QESPVUrt/NCkodJEHaRksqDY+FLKBeG90qxXdddHvhPvxF+BXc0kv2
	 Ml0BmVdY7tTJLxFh5QOqiVarZf+1dthVJdgovfH07BsS4ycUEi63GL+HuGmQQo/2VP
	 b0yHvwrrLuFftpFCydnFRXX2OA+nWMGazMYMX3aU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCFBGs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgCFBGs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Mar 2020 20:06:48 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93F1E2073D;
        Fri,  6 Mar 2020 01:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583456807;
        bh=aURKFQvIjafRMU6Gm9pVZS/vH2n9loe7wUOjvdcmpyE=;
        h=From:To:Cc:Subject:Date:From;
        b=nZh9xR/GftMO+mns/iZyIOCijIKiV5pzhuM8uhqpdqNMC0UUIetUleJVhk9rH3zNV
         tDem9k+/iCMlcptF6njn8k/0dxNSKdQVYGfSV5bbW94TEGe6ZiksF8h4/sWgjRVmRU
         1+v8Gf/HcPBmIfo/WUOwPUqjSAdXOEFyOZU/agVo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-um@lists.infradead.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org, edumazet@google.com,
        jasowang@redhat.com, mkubecek@suse.cz, hayeswang@realtek.com,
        doshir@vmware.com, pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/7] ethtool: consolidate irq coalescing - other drivers
Date:   Thu,  5 Mar 2020 17:05:55 -0800
Message-Id: <20200306010602.1620354-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi!

Convert more drivers following the groundwork laid in a recent
patch set [1]. The aim of the effort is to consolidate irq
coalescing parameter validation in the core.

This set converts all the drivers outside of drivers/net/ethernet.

Only vmxnet3 them was checking unsupported parameters.

The aim is to merge this via the net-next tree so we can
convert all drivers and make the checking mandatory.

[1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/

Jakub Kicinski (7):
  um: reject unsupported coalescing params
  RDMA/ipoib: reject unsupported coalescing params
  tun: reject unsupported coalescing params
  r8152: reject unsupported coalescing params
  vmxnet3: let core reject the unsupported coalescing parameters
  staging: qlge: reject unsupported coalescing params
  wil6210: reject unsupported coalescing params

 arch/um/drivers/vector_kern.c                |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |  2 ++
 drivers/net/tun.c                            |  1 +
 drivers/net/usb/r8152.c                      |  1 +
 drivers/net/vmxnet3/vmxnet3_ethtool.c        | 24 +++-----------------
 drivers/net/wireless/ath/wil6210/ethtool.c   |  1 +
 drivers/staging/qlge/qlge_ethtool.c          |  2 ++
 7 files changed, 11 insertions(+), 21 deletions(-)

-- 
2.24.1

