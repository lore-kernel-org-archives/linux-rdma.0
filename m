Return-Path: <SRS0=g0/n=BF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A89AC433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 26 Jul 2020 02:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D590206D7
	for <linux-rdma@archiver.kernel.org>; Sun, 26 Jul 2020 02:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/Y4CcDR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgGZC2o (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 25 Jul 2020 22:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgGZC2n (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 25 Jul 2020 22:28:43 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B476BC0619D2;
        Sat, 25 Jul 2020 19:28:43 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so12333400qkg.5;
        Sat, 25 Jul 2020 19:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4RfkvlMt2rThYkklpBMRg3zwGuy1XZ+sZK1Hvc1Zws8=;
        b=K/Y4CcDRyCp8X8+LBwvI77yMPhDNYMu5OIkLphXaFjLvLFUoaLUZ7Um2xZ384bUFJr
         9kWU+QsNe+XFzYY4NGXk+b5XYpAjxwVplrp0ZnCq4gH4RAghgzoiOyAjUYCAxHMB1gGQ
         M3TdfUxgrOEEX1m9zqMWhWeo83I0rANSgTZD3qWKbRE6GJQoe5bqFeh1tIBq4S/L37iC
         e10A2X/xcfoWI8gDoXPtUzOli4jnil7PkoohG4YcE1Mrz+HlTNzsiBUcI9bxOxgjEM49
         kQ3v4NxRxKwgC/UYEHZBUwzgayUuaaunIPUHOgkOZlmp0VXsaTqU02EDLtXJOsenTIuB
         kq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4RfkvlMt2rThYkklpBMRg3zwGuy1XZ+sZK1Hvc1Zws8=;
        b=hfysgWyFyIO9icNrac+QavWoqDXc0bpBXVBEWsEbUHlMSDz3nvw4TKVi4Hz//Zsn5l
         +cJVRhWASFN/wytNxJD5b6kokB0MX7tHb/HjG/54n9uM3hMquG32Szaa1/dNLgMLC/om
         j04vDraLFLJDBlRxrSq9S8PBVy6SgttWR7SVrwRxlve2gdQMvRS81Ez2I4l+eessRiWW
         3ymw0BjQFWEL7tv1PGri8rBVZQK/JfARUrsbtVZvVM070RSCtHF9zDa+GOSx+SQH+uj5
         tocUcKKQQ3ak5+zMUcVeVqYOvJD1Gt/10Ygzkf+cTCdY6RuGazdy2YGqKTqST9NQZaSH
         Or5Q==
X-Gm-Message-State: AOAM531J4+FKzkn9uxKfhdZ3ZlQFKIQN56YKcARalCtUWD5h8IZ/q1RX
        Cy+t86FOXGzXZFVxfinF6A==
X-Google-Smtp-Source: ABdhPJwzZVg3MNUXqS+wa+k0VLYtFF6fVCt3zo5divFq0l52ko+Cw1GX/Gak4/JDH4PGLtaCJ1J7aQ==
X-Received: by 2002:a05:620a:5f7:: with SMTP id z23mr1413433qkg.206.1595730522804;
        Sat, 25 Jul 2020 19:28:42 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id z197sm13512785qkb.66.2020.07.25.19.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 19:28:42 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH v2] infiniband: Prevent uninit-value in ucma_accept()
Date:   Sat, 25 Jul 2020 22:27:16 -0400
Message-Id: <20200726022716.635727-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200725220203.624557-1-yepeilin.cs@gmail.com>
References: <20200725220203.624557-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

ucma_accept() is reading uninitialized memory when `in_len` is
less than `offsetof(struct rdma_ucm_accept, ece)`. Fix it.

Reported-and-tested-by: syzbot+086ab5ca9eafd2379aa6@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=0bce3bb68cb383fce92f78444e3ef77c764b60ad
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Change in v2:
    - syzbot has reported this bug as "KMSAN: uninit-value in xa_load".
      Add "Reported-and-tested-by:" and "Link:" tags for it.

 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index a591fdccdce0..842d297903c0 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1134,7 +1134,7 @@ static ssize_t ucma_listen(struct ucma_file *file, const char __user *inbuf,
 static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 			   int in_len, int out_len)
 {
-	struct rdma_ucm_accept cmd;
+	struct rdma_ucm_accept cmd = {};
 	struct rdma_conn_param conn_param;
 	struct rdma_ucm_ece ece = {};
 	struct ucma_context *ctx;
-- 
2.25.1

