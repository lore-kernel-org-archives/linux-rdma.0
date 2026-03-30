Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FD33CE49C
	for <linux-rdma@vger.kernel.org>; Mon, 30 Mar 2026 12:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873681; cv=none; b=bVux1kCc5tTK/eD5EhB3J+yaKl0xUJaW2h8Kwqce3ZLfVlU9qtrddDByHVDeSJ+Gup1lRoDUftPx5zwFNhG1aJLkvYxWT4T+nJtktNFrD9YnTrwnZP1O855+YtvZB+ekoW8EluDf6qHsp3gZJ/iVnwopmGv1Eq1HFL5/jVBApU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873681; c=relaxed/simple;
	bh=1uxJ0UjV1G4S7C+2pfSx86fcX9uBM8TLtYD6EcnxhSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q6HWZfFrfAcKJ1A0WCti3p518yPvIdJM0Sy6ZosJN78YvOw4uY1cA/qGdK7xJRrc0GOtqxk4bOoGfvZjjZClDffOd7bwW7N9ykxG/Cy8OntEbtmnfTABifUyUCp2lEfOUHJIw053oXmjfwU1q49CZs3xRNOH3VaBzpXBm/zANwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8501960A55; Mon, 30 Mar 2026 14:27:56 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH rdma] RDMA/core: prefer NLA_NUL_STRING
Date: Mon, 30 Mar 2026 14:27:39 +0200
Message-ID: <20260330122742.13315-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These attributes are evaluated as c-string (passed to strcmp), but
NLA_STRING doesn't check for the presence of a \0 terminator.

Either this needs to switch to nla_strcmp() and needs to adjust printf
fmt specifier to not use plain %s, or this needs to use NLA_NUL_STRING.

As the code has been this way for long time, it seems to me that
userspace does include the terminating nul, even tough its not enforced
so far, and thus NLA_NUL_STRING use is the simpler solution.

Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 compile tested only.

 drivers/infiniband/core/iwpm_msg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 69c85249b465..4625abd29ac0 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -365,9 +365,9 @@ int iwpm_remove_mapping(struct sockaddr_storage *local_addr, u8 nl_client)
 /* netlink attribute policy for the received response to register pid request */
 static const struct nla_policy resp_reg_policy[IWPM_NLA_RREG_PID_MAX] = {
 	[IWPM_NLA_RREG_PID_SEQ]     = { .type = NLA_U32 },
-	[IWPM_NLA_RREG_IBDEV_NAME]  = { .type = NLA_STRING,
+	[IWPM_NLA_RREG_IBDEV_NAME]  = { .type = NLA_NUL_STRING,
 					.len = IWPM_DEVNAME_SIZE - 1 },
-	[IWPM_NLA_RREG_ULIB_NAME]   = { .type = NLA_STRING,
+	[IWPM_NLA_RREG_ULIB_NAME]   = { .type = NLA_NUL_STRING,
 					.len = IWPM_ULIBNAME_SIZE - 1 },
 	[IWPM_NLA_RREG_ULIB_VER]    = { .type = NLA_U16 },
 	[IWPM_NLA_RREG_PID_ERR]     = { .type = NLA_U16 }
@@ -677,7 +677,7 @@ int iwpm_remote_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 
 /* netlink attribute policy for the received request for mapping info */
 static const struct nla_policy resp_mapinfo_policy[IWPM_NLA_MAPINFO_REQ_MAX] = {
-	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_STRING,
+	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_NUL_STRING,
 					.len = IWPM_ULIBNAME_SIZE - 1 },
 	[IWPM_NLA_MAPINFO_ULIB_VER]  = { .type = NLA_U16 }
 };
-- 
2.52.0

