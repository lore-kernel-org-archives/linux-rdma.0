Return-Path: <SRS0=oVUF=XT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0002C432C1
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Sep 2019 07:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C86214DA
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Sep 2019 07:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569311967;
	bh=bdO8JTpq5jJ5+vPBQJrBJ9wjel6a8nTRp5YTjLF0o1g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=yrNka6OF3bhv+R6gHUUyVL+Ui3BqbOUYz8IlVGc1OOBW78/peQB9WkeDCvrsuTw0n
	 VgOY7yTFZfpuLlVKNxtpBWjrptV7jb+u3/Tnm5fXRn5KbrSW5hsBUJ85orCatyOkMp
	 iFUeK9AmPhG8l7mHVMs+RXkbaQKlcKKY1hzO3MJQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406009AbfIXH71 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405186AbfIXH71 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 24 Sep 2019 03:59:27 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0221207FD;
        Tue, 24 Sep 2019 07:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569311966;
        bh=bdO8JTpq5jJ5+vPBQJrBJ9wjel6a8nTRp5YTjLF0o1g=;
        h=From:To:Cc:Subject:Date:From;
        b=f3KWws/CkrHj/XMpyyx9IAymW8FdHRuBeBH2a8bM9n4XBZkq7UGrVBVuLZ+WZ8kJz
         fXjru4xXeUhDmN2OGzE5ScoUVXwb024h91SJCorze9V5Ir1BA8X/VGvc6vwOMlVf0M
         ZKGFnVq6d+eGu4jto5ywqjdsPSTmVS+sb1WHZsVo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH rdma-core] cbuild: Run gpg with a home directy in the tmpdir
Date:   Tue, 24 Sep 2019 10:59:21 +0300
Message-Id: <20190924075921.15830-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

To avoid interaction with the user's gpg home directory.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 buildlib/cbuild | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index c9522841d..742a9e225 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -221,13 +221,15 @@ class APTEnvironment(Environment):
         # key for the toolchain ppa.  Fetch it in the host and just import the
         # gpg data directly into the trusted keyring.
         kb = os.path.join(tmpdir,"%s.kb.gpg"%(keyid));
-        subprocess.check_call(["gpg","--no-default-keyring","--keyring",kb,"--always-trust",
-                               "--recv-key",keyid]);
+        env = {k:v for k,v in os.environ.items()};
+        env["HOME"] = tmpdir;
+        subprocess.check_call(["gpg","--keyserver", "keyserver.ubuntu.com", "--no-default-keyring","--keyring",kb,"--always-trust",
+                               "--recv-key",keyid],env=env);
         kr = os.path.join(gpgd,"%s.gpg"%(keyid));
         with open(kr,"wb") as F:
             F.write(subprocess.check_output(["gpg","--no-default-keyring",
                                              "--keyring",kb,
-                                             "--export",keyid]));
+                                             "--export",keyid],env=env));
         os.unlink(kb);
 
         self.add_source_list(tmpdir,keyid + ".list",srcline);
-- 
2.20.1

