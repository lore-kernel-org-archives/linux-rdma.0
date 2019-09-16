Return-Path: <SRS0=TGoC=XL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F248AC4CEC4
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 01:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAD852067B
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 01:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfIPBeJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 15 Sep 2019 21:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfIPBeJ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 15 Sep 2019 21:34:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F34453082B5F
        for <linux-rdma@vger.kernel.org>; Mon, 16 Sep 2019 01:34:08 +0000 (UTC)
Received: from dhcp-128-227.nay.redhat.com (unknown [10.66.128.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E09C01053B32;
        Mon, 16 Sep 2019 01:34:07 +0000 (UTC)
From:   Honggang LI <honli@redhat.com>
To:     linux-rdma@vger.kernel.org
Cc:     Honggang Li <honli@redhat.com>
Subject: [PATCH] redhat: BuildRequires python3
Date:   Mon, 16 Sep 2019 09:33:45 +0800
Message-Id: <20190916013345.8489-1-honli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 16 Sep 2019 01:34:09 +0000 (UTC)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Honggang Li <honli@redhat.com>

python2 is obsoleted by python3 in RHEL8 and Fedora-30.

Signed-off-by: Honggang Li <honli@redhat.com>
---
 redhat/rdma-core.spec | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index f07919cc..731a4e10 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -29,8 +29,12 @@ BuildRequires: systemd-devel
 BuildRequires: python3-devel
 BuildRequires: python3-Cython
 %else
+%if 0%{?rhel} == 8 || 0%{?fedora} >= 30
+BuildRequires: python3
+%else
 BuildRequires: python
 %endif
+%endif
 %if 0%{?fedora} >= 21
 BuildRequires: perl-generators
 %endif
-- 
2.21.0

