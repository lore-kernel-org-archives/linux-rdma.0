Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924677;
	b=w64CjbvoLpBKNDfw4sdbC1SolaTgpEZJ5w3Hg1nxy3JH/T34LA8xdTQP7P2HqiH9S/Ik
	 NL7hFwQ2Jb3io1IutrbYjfYjJXS9dbUhOd8BP8Zl4oAXnx6re+5lSt7jPg9i2JEh+JAQk
	 Xo6sFb2O/lTuzBdkLlVK21EiQdyJvVUfPauoNwVEJdlQW8R8Ql0Exp3n8b/7L6I9XOLS1
	 PMJB0w1E9iRBVzQnIjYzstKRDQDIz307CvJoZju7LNbpjA9MDfd+sKhzGk8bSIeZy2hc6
	 PDNEFMTtIRdoiV00jSHUmUNoibK3ptI+uJ1ktVxlx2uj/nVpzbjn8MkYSJDB5Oz1aNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924677;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=CYpKRHB8WkESYHeiuRZUiLda/aBiY2lXVz3PlHweOig=;
	b=HNzrzFbVQ530cJ/XDC5rAz8gg1a/8Gmi9cQjkF9EwYvhGkEsun+zM5MvPx56yv4E44ld
	 OiTd8cl8PE5hx+YCLjF90/XNbwjzv4ezQyZgDxRE4ZKFEW9DAr6pbYmz/qi5QQEAUIb+l
	 6s8YfHmFrrgTdxrqaIP/KzBmOyQ2HdgDGisgEel7jxDZsW2AakjYTT6kqltELyg/P3kVx
	 J6t9d4KzAhNc58AWVcEvm8eBjU6PCaxtpgvNxjBuXQUDmg6JJ7BUfLxw+HflDU0xNwbI+
	 kwcRrukAhc0baOm9x3FJNm/Xq7YtinqG04gkOc6Ts/BKOpBUFnbJ3RtFjnDmzMZfSGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0gJVPxR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0241606BD19;
	Tue, 17 Nov 2026 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0gJVPxR
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794924677;
	b=DYzuBgR+5OBtuQPtqN8WZBR1RONE7cmPNI35wzjFnszOBYmcx+VZQx6m1W5ZHuJaa0w4
	 W63j44W120vHn7hbYruN45RWnnaBxk7/O+m304dUBC7qwhgyJHUkiWEwdqVrh63RMxmy8
	 3QzLbE80gfcIR3f9mBortrba4/X01Rqi+QUYh5dO3BCHcQOOYmQ2s9d80aiaC4qhaWvth
	 PF6lLJo7+EBQEpO9eP9AxGrBQnrWj15bYy2KRFdBjoiqeLIoTuJA3CAQv8loccIKH0OaA
	 df5Mj3XfQcFw2RiFi93zg81Ylm139T+4MXBu2tJpeFgGz6f1aYwyLLrTX+d3bBoPfkw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794924677;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=CYpKRHB8WkESYHeiuRZUiLda/aBiY2lXVz3PlHweOig=;
	b=i5DJ3bHQ1MTZGpfdB09nZ0TPxN2LGl9PNtRcUo41OP7Z8VUdS8jI17JnS9R3e5GFSaxB
	 FRtkWmmwutzuyQT48MyRWwyP9DLS7Ea4ViDCsOEOwDj4hXsJjSSjUeG4wGZvMyH7RIz/7
	 sTn0xSTpMsU6gJ/k0N8642YyE4Zq7dfMFPeKzZlJ4QpKGlCSeKBUfLGfE6P6GzFwJShKa
	 0K+hI2ifDe+W3TZmgJaToca+4RNrXJGr7A7AkBTkqOcOoqJxd9loQ3ZJmmnuAULB4oNL9
	 5J6/5lPS2KzpwwtQI+9x7RQbxBMVBR/LqkMnQ1nOUewbmcfw6ZBRcFlscFpCsty5g7w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 00B141F000C8;
	Tue, 17 Nov 2026 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794924677;
	bh=CYpKRHB8WkESYHeiuRZUiLda/aBiY2lXVz3PlHweOig=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=M0gJVPxRw9dPpZvzd3f0FCLWXcDkgRXkg/IUPOYUY4w5G92EPlqSN+w4ahb7Jc95d
	 e1ja4//yw7N6mzjHZ86SuYIUD16U6rEFREXoa4l1ALOdT+phbbUUV5S6Fd0gsa0SDO
	 XzAui4/kbCKYseWbSwn6yCM0RPGyakZmCqMjhA1v3sPl5Dt9ywOt74Jn0B8buMR4yS
	 Kvb4iMnoWFajOQ2qpWLwJJ2DmESjSA3Z85TFFhZeyS2M/JWd98HRE+G/mCXPWM0af1
	 9iq4JyK+d38AoY34nBHbZizHJFaAQ0VEINBS6WIYsNxpduRuZvFYa/lA7UZ88fGpPs
	 otayPSkxa5JjA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 773504A97A;
	Tue, 17 Nov 2026 14:11:13 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Tue, 17 Nov 2026 14:11:13 +0000
Subject: [PATCH] RDMA/iwcm: Require CAP_NET_ADMIN for iWARP port mapper
 netlink messages
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-iwpm-perm-v1-1-11f1b87d6fb3@gmail.com>
X-B4-Tracking: v=1; b=H4sIAIBg/GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Nz3czyglzdgtSiXN1UQyPz1MQ0C+O0VHMloPqCotS0zAqwWdGxEH5
 xaVJWanIJyACl2loARtq/Dm0AAAA=
X-Change-ID: 20261117-iwpm-perm-e127eaf83fe7
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924672; l=4038;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=Z9OLDut2x9uLQu+jC2FkDVbLqTc8dEpPtoaL/tSmdPY=;
 b=qaZdEPa6aL8bjtmtf0yajNyMDGE2Rx6ALVatlyYq1jbLhkYwR7J0eROfA6jMZ27l+kzCjXFG4
 Y1hkQXJ6rKSAYnsOEti5nAqQUXLJCGxvC8xUX04TCer7d0yZpIADhoM
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

The RDMA_NL_IWCM callbacks process replies and notifications from the
port mapper daemon, iwpmd, but none of them sets RDMA_NL_ADMIN_PERM:

    [RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
    [RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
    ...

so rdma_nl_rcv_msg() accepts them from any process in init_net.

iwpm_hello_cb() and iwpm_mapping_info_cb() set iwpm_user_pid to the
sender's port ID and mark the client IWPM_REG_INCOMPL, without matching
any pending kernel request. An unprivileged process can thus make
itself the daemon that the kernel sends port mapper requests to. The
mapping replies are matched against the request they answer, but
nothing checks that the sender is the port mapper, and the address a
matching reply carries is the one iw_cm_map() uses.

Set RDMA_NL_ADMIN_PERM on all iwcm callbacks, so the RDMA netlink
dispatcher requires CAP_NET_ADMIN before invoking them. This matches
the RDMA_NL_LS response handlers, which already require it, and iwpmd
runs as root.

Found with a static analysis tool and checked by hand.

Fixes: b493d91d333e ("iwcm: common code for port mapper")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
Tested under QEMU (x86_64, CONFIG_INFINIBAND=y): before this patch a
process in a child user namespace, with no CAP_NET_ADMIN over
init_user_ns, can send an RDMA_NL_IWCM message that reaches the
port-mapper callbacks; after it the dispatcher returns -EPERM. A
privileged sender still reaches them. W=1 and sparse show no new
warnings. I don't have iWARP hardware. The upstream iwpmd systemd
service runs as root without a capability bounding set, so it keeps
CAP_NET_ADMIN.

Related discussion of unprivileged access to this interface:
https://lore.kernel.org/linux-rdma/20261109200330.2361828-1-graypanda.inzag@gmail.com/
That patch fixes a REMOTE_INFO allocation leak; this one adds the
missing privilege check for all the IWCM port-mapper callbacks.
---
 drivers/infiniband/core/iwcm.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 4b05867dad89..94a92434063a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -81,14 +81,38 @@ const char *__attribute_const__ iwcm_reject_msg(int reason)
 EXPORT_SYMBOL(iwcm_reject_msg);
 
 static struct rdma_nl_cbs iwcm_nl_cb_table[RDMA_NL_IWPM_NUM_OPS] = {
-	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
-	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
-	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
-	[RDMA_NL_IWPM_REMOTE_INFO] = {.dump = iwpm_remote_info_cb},
-	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = iwpm_mapping_error_cb},
-	[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb},
-	[RDMA_NL_IWPM_MAPINFO_NUM] = {.dump = iwpm_ack_mapping_info_cb},
-	[RDMA_NL_IWPM_HELLO] = {.dump = iwpm_hello_cb}
+	[RDMA_NL_IWPM_REG_PID] = {
+		.dump = iwpm_register_pid_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_ADD_MAPPING] = {
+		.dump = iwpm_add_mapping_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_QUERY_MAPPING] = {
+		.dump = iwpm_add_and_query_mapping_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_REMOTE_INFO] = {
+		.dump = iwpm_remote_info_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_HANDLE_ERR] = {
+		.dump = iwpm_mapping_error_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_MAPINFO] = {
+		.dump = iwpm_mapping_info_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_MAPINFO_NUM] = {
+		.dump = iwpm_ack_mapping_info_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NL_IWPM_HELLO] = {
+		.dump = iwpm_hello_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
 };
 
 static struct workqueue_struct *iwcm_wq;




