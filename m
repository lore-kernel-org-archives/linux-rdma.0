Return-Path: <SRS0=4UPP=ZL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE78EC432C0
	for <linux-rdma@archiver.kernel.org>; Tue, 19 Nov 2019 15:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7393D222A2
	for <linux-rdma@archiver.kernel.org>; Tue, 19 Nov 2019 15:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NI/yJRu0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfKSPtO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:49:14 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44102 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfKSPtN (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 19 Nov 2019 10:49:13 -0500
Received: by mail-pg1-f194.google.com with SMTP id e6so3571168pgi.11
        for <linux-rdma@vger.kernel.org>; Tue, 19 Nov 2019 07:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YWn6yk1DNCxd+z0CL4IqbmxrCUlVTDHdYgOM3PrHPuA=;
        b=NI/yJRu0TXahVCFln3IX0R92SKlTi6azDM+0bYNL8GKF/WmUN6oDDFSNt2yJXWfugU
         lbqQbC/Xt7kODSZ+AVwpwdnmS6MDvaRrLVpRdQOGmcNOtYb9co57ow44ba3Vaiib8AvS
         N4z/MqHdZI7B9Wo6b6CslxkRDqceWeKYfBvp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YWn6yk1DNCxd+z0CL4IqbmxrCUlVTDHdYgOM3PrHPuA=;
        b=eSf5qK3S+ZahfwWUdSSSumjCToJtvHQZqlhk8efRHHXG48SuQeWa7woYYZOd2tq9ot
         jYkht63b2yD5sr81WsufZKiRARnoSgcJL10WCGNP9/sLocWADFZ9DZ12QY0rFYlsJgkI
         Wwf7aC1Oo48C/C5PsGxTnf/mHj1Pp6tpb2JP3s/IbfY2cEyGnI5hPdrjbM8VYigswe4d
         rj38QnrHwhqFpqYwCQOXaSqiHPGk/XsS1P3QqNa7aGPitMLrLsbe+v+NH22L6wu6Hxev
         kiNgo7LxxkG4V1WKpBoDu9Juw8RgSG61x9P6F3Planf1f5ITEC4geIsFOIvty467+zcF
         jYJQ==
X-Gm-Message-State: APjAAAWm2diwbphZc8S3+92vmNkM0gtWt7LL7NtekUAi7wcQYr8r+RZi
        elpURJtBiUYt9Ti4AhdRQtNLgg==
X-Google-Smtp-Source: APXvYqzRp5f6jbiu5KIa3L3xZDREWBNZ9VADpIVasi8Of2v2oTKUoGSRqx9CvB2yu4VGG6XAcHs73Q==
X-Received: by 2002:a62:5585:: with SMTP id j127mr1747744pfb.236.1574178552998;
        Tue, 19 Nov 2019 07:49:12 -0800 (PST)
Received: from neo00-el73.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 10sm24263620pgs.11.2019.11.19.07.49.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 07:49:12 -0800 (PST)
From:   Devesh Sharma <devesh.sharma@broadcom.com>
To:     dledford@redhat.com, jgg@mellanox.com
Cc:     linux-rdma@vger.kernel.org,
        Devesh Sharma <devesh.sharma@broadcom.com>
Subject: [PATCH for-rc 0/3] Broadcom's roce dirver bug fixes
Date:   Tue, 19 Nov 2019 10:48:48 -0500
Message-Id: <1574178531-15898-1-git-send-email-devesh.sharma@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series contain 3 patches patch 1 and patch 2 are specific to
Gen P5 devices. Patch 3 is a generic fix to silence few sparse
warnings.

changes for V0 to V1
 - originally this series had only 1 patch which is the first patch.
 - Added Fixes tag on the first patch.
 - added two more patches to fix other quick bug fixes.

Devesh Sharma (2):
  RDMA/bnxt_re: fix stat push into dma buffer on gen p5 devices
  RDMA/bnxt_re: fix sparse warnings

Luke Starrett (1):
  RDMA/bnxt_re: Fix chip number validation Broadcom's Gen P5 series

 drivers/infiniband/hw/bnxt_re/main.c      | 9 +++++----
 drivers/infiniband/hw/bnxt_re/qplib_res.h | 8 ++++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
1.8.3.1

