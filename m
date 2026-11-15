Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749122;
	b=E5S5bK8JyYioFZdBpUIlTDcKt1EOMXwJGCQ1crmVi1T8C7P1kewo6MDuo7/9YrOSHcYE
	 2r8UeTVNtQh/U/w//n9K66rp+E9mlfIDwatib0rWqIVC0eR09yzh+2Sl+GmmPMZY3ACkU
	 /TZaOc6REozD8qhNo6TduUx/jLN6yfifCqr5wk/3vMVmyWAC1solC7wneto/3Zq0VNHKe
	 UZ24xIL4zYqjpWmLMCRokCXppoVJ8Vey/ioDeWSkL4fKP8xcTAcmWz1EFwR4/uq/H6lsS
	 j6vmrbJr3YstFJWoN2B2rlkDoMR54utq8+AwI4w9o7IeQzm5xp4AEmfaAnX+u0e4EhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749122;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=pXZoABMJxnv660Z8EavSHK9f3CBrQH3Sb4rvVymGMpo=;
	b=ncAl7uxQCuTcQ1l5+2ZDVQ9sX/f1viq3J3bTPHy2Ojdr85F186mPzqrAFpy9+kIjD18T
	 mZsJXbbIu5frJB6RqZ51UWk1fWs7O3CW3LaUA222od7r5Ib4DOSVRfaMN/hhlliLk4djN
	 11RgT+dkqdkn2rNMdidFiq3S+/Uz5/crLbUwFp+IZ1NwnnnVkzYjALTXK3hd+HHt75eT+
	 9a/ZXKHAu3WDZanJgCl7KrFDfbQORhfx3wuq6rjguZXrDmAw2BYwyT8/zo+0p735Ihigg
	 C6cYGQUMEy38bHQN3F+AYAWhEtNei3DCdwto8gMAimt8lG+EVSECwd9IaLPP8S8RRPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eNZx+eAD;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047F1606A32F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 047F1606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eNZx+eAD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794749121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=pXZoABMJxnv660Z8EavSHK9f3CBrQH3Sb4rvVymGMpo=;
	b=eNZx+eADrbWn4LEAebq/D22FDjF9JYBxAqxAQWaO8QcWAA1mSOCWOmjhqum97/b6bDWjMk
	XVmPo3rp/MJVn99qrdgISSmccIdrmipIU/vIEwQx5m7Xm6lUg7AdFv5Ozbk5XOffVUMi/k
	j/Ytho1qUVobr3jGWHiehOp9lR3Yvak=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-tmEBoLgnN0m2AEUkmSZkrQ-1; Sun,
 15 Nov 2026 08:25:19 -0500
X-MC-Unique: tmEBoLgnN0m2AEUkmSZkrQ-1
X-Mimecast-MFC-AGG-ID: tmEBoLgnN0m2AEUkmSZkrQ_1794749118
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59C9A180035E;
	Sun, 15 Nov 2026 13:25:18 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3DD0C30001BE;
	Sun, 15 Nov 2026 13:25:16 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sun, 15 Nov 2026 14:25:18 +0100 (CET)
Date: Sun, 15 Nov 2026 14:25:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2 net-next 2/5] net/rds/ib_sysctl.c: move sysctl-only code
 under CONFIG_SYSCTL
Message-ID: <avmyu2SQTjdC_jjd@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avmymGvelu00X5EH@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Collect all code used only when CONFIG_SYSCTL=y into a single block and
wrap it in #ifdef CONFIG_SYSCTL. rds_ib_sysctl_init() no longer needs the
IS_ENABLED() check.

Add the corresponding init/exit stubs for the CONFIG_SYSCTL=n case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_sysctl.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
index bc97a3eecad6..0b336ff03ae9 100644
--- a/net/rds/ib_sysctl.c
+++ b/net/rds/ib_sysctl.c
@@ -36,19 +36,10 @@
 
 #include "ib.h"
 
-static struct ctl_table_header *rds_ib_sysctl_hdr;
-
 unsigned long rds_ib_sysctl_max_send_wr = RDS_IB_DEFAULT_SEND_WR;
 unsigned long rds_ib_sysctl_max_recv_wr = RDS_IB_DEFAULT_RECV_WR;
 unsigned long rds_ib_sysctl_max_recv_allocation = (128 * 1024 * 1024) / RDS_FRAG_SIZE;
-static unsigned long rds_ib_sysctl_max_wr_min = 1;
-/* hardware will fail CQ creation long before this */
-static unsigned long rds_ib_sysctl_max_wr_max = (u32)~0;
-
 unsigned long rds_ib_sysctl_max_unsig_wrs = 16;
-static unsigned long rds_ib_sysctl_max_unsig_wr_min = 1;
-static unsigned long rds_ib_sysctl_max_unsig_wr_max = 64;
-
 /*
  * This sysctl does nothing.
  *
@@ -61,6 +52,14 @@ static unsigned long rds_ib_sysctl_max_unsig_wr_max = 64;
  */
 unsigned int rds_ib_sysctl_flow_control = 0;
 
+#ifdef CONFIG_SYSCTL
+static unsigned long rds_ib_sysctl_max_wr_min = 1;
+/* hardware will fail CQ creation long before this */
+static unsigned long rds_ib_sysctl_max_wr_max = (u32)~0;
+
+static unsigned long rds_ib_sysctl_max_unsig_wr_min = 1;
+static unsigned long rds_ib_sysctl_max_unsig_wr_max = 64;
+
 static struct ctl_table rds_ib_sysctl_table[] = {
 	{
 		.procname       = "max_send_wr",
@@ -105,6 +104,8 @@ static struct ctl_table rds_ib_sysctl_table[] = {
 	},
 };
 
+static struct ctl_table_header *rds_ib_sysctl_hdr;
+
 void rds_ib_sysctl_exit(void)
 {
 	if (rds_ib_sysctl_hdr)
@@ -114,7 +115,19 @@ void rds_ib_sysctl_exit(void)
 int rds_ib_sysctl_init(void)
 {
 	rds_ib_sysctl_hdr = register_net_sysctl(&init_net, "net/rds/ib", rds_ib_sysctl_table);
-	if (!rds_ib_sysctl_hdr && IS_ENABLED(CONFIG_SYSCTL))
+	if (!rds_ib_sysctl_hdr)
 		return -ENOMEM;
 	return 0;
 }
+
+#else
+
+int rds_ib_sysctl_init(void)
+{
+	return 0;
+}
+
+void rds_ib_sysctl_exit(void)
+{
+}
+#endif
-- 
2.55.0

