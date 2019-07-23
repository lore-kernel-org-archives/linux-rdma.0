Return-Path: <SRS0=t5r7=VU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA33C76186
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 19:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B123321849
	for <linux-rdma@archiver.kernel.org>; Tue, 23 Jul 2019 19:11:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nWdCiu9T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfGWTLj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 15:11:39 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45405 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729398AbfGWTLi (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 23 Jul 2019 15:11:38 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so31952268qkj.12
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jul 2019 12:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=87P5WFocleGvD2O2qMV/feWCHz3XYiwRpTioiMBhAAo=;
        b=nWdCiu9T2QYKLRgouKh9b77PDMUV56+Ye+JHs8Ec0NQYA06TlzJzWbLg/+PsY0xK/p
         KDiZhdZGt+NQzCWNZ4r5gXbmPFRO/YS9Cv58zXEZ5X8adYVddX21IzN6J0lccRcNQiB6
         CI5abnN5XonwJxdIXaqVBNE4Duv/H0rc5LUVrdl/CKo9oX+89+Xklb2aSrpTKzeJuNYG
         S+fVtRSqUTFaUO64tkThAy4QTsorDEQE6m08RE+48nBOj8YkJUvdBsNV7Ovv0hvKxf/m
         Fpor0K+kdFMNIDPUA2x6F8S/zNARRjg09PzcAIvSmr0n7ds/q0BMKTRhQhNZs71KQd8k
         nhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=87P5WFocleGvD2O2qMV/feWCHz3XYiwRpTioiMBhAAo=;
        b=ukiyH+dvItygsMbTbF2A2ChsthbvqtHV7wW48Dw/JCUuCz2+zE1aB8j2+12bMfYEk8
         YHy61cScw/eVHWHe4DfnBHRM90Lwekch8N5cLmTBg17yZ5EUPJIKHwcnJDZRTDfeO2BY
         spDmRS0Mn6OqmBWQF4kK5+TIK2+VBfW1XiNrv8MEmX0k1I//15l+Z59A+QPu/bUQDhaL
         oKLBhkwsEZuOfBOrkCPP+Hd8C7AZol9eTFVvaG2LPCinnIMJYAoSw4mjGR6jXVNOZcw/
         DpRNP1+d6+sGZuJThWPoLLxAwZNzcT3k7YBtaRTfbib56C/melh0Lq+R16Hu71Msi1bf
         3bJg==
X-Gm-Message-State: APjAAAUwlfpAcq64tps2aPrMvb3u/1NZtuukaTFBq94ox0upcRgY8lAV
        iXlMBOIDo9X1VJ39UF3EUiObr1C10FRyPg==
X-Google-Smtp-Source: APXvYqyNyQM9dLjqsKFAw1Z0NrxOktAl8gQ2nXjcP56/yEjKBHexvdKx0S7Hhz4sE6ECU6ZIIE8G7w==
X-Received: by 2002:ae9:e411:: with SMTP id q17mr48933653qkc.465.1563909097826;
        Tue, 23 Jul 2019 12:11:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id n27sm13864570qkk.35.2019.07.23.12.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jul 2019 12:11:37 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hq02e-000443-Bc; Tue, 23 Jul 2019 16:01:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH rdma-core 03/19] build/cbuild: Remove docker-gc
Date:   Tue, 23 Jul 2019 16:01:21 -0300
Message-Id: <20190723190137.15370-4-jgg@ziepe.ca>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190723190137.15370-1-jgg@ziepe.ca>
References: <20190723190137.15370-1-jgg@ziepe.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

This is now part of standard docker via the command:
   docker system prune

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 buildlib/cbuild | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 83ada8ee44aa5e..7f93baa82b1959 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -1084,20 +1084,6 @@ def cmd_make_dist_tar(args):
         with open(os.path.join(args.script_pwd,args.tarfn),"w") as F:
             subprocess.check_call(["gzip","-9c",tmp_tarfn],stdout=F);
 
-# -------------------------------------------------------------------------
-def args_docker_gc(parser):
-    pass;
-def cmd_docker_gc(args):
-    """Run garbage collection on docker images and containers."""
-
-    containers = set(docker_cmd_str(args,"ps","-a","-q","--filter","status=exited").split());
-    images = set(docker_cmd_str(args,"images","-q","--filter","dangling=true").split());
-
-    if containers:
-        docker_cmd(args,"rm",*sorted(containers));
-    if images:
-        docker_cmd(args,"rmi",*sorted(images));
-
 # -------------------------------------------------------------------------
 
 if __name__ == '__main__':
-- 
2.22.0

