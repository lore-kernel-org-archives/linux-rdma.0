Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856473;
	b=zrg0MXFIo0jUq4mp6oayjc8jkZk4yf9IGTRKZQnxNe/rxG/kCFHy25aDi21Sk+t68evy
	 lvMzQQw6WJkWoWZyd/xnTbegPUsGwyR9Rr55QQxrT/WyaA4yVBexbyZiJIWmHj20Gayxr
	 ickHnwManLmQFnWaFHE0pyCa4obFAglUnLSduF1G3ocbBgeosQGry9lMMYk/Q3tC6wtG3
	 oWBJXylMvLMNQM9ej0x6uP7026Es+73f8++9BUozcaMLBevGQ9f0Q8lE9gw/qLI3JYncM
	 2JtQ83QS8Bz1WlqlzFuqADm2qIfTTWtiMGDBBFRNrlayyJHDJZRp4R+Fiq/dcWeo/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856473;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=aoHivYOiQdbOaZPXvgh0dS7cHVXJqr9Y39hFc8Y7tCE=;
	b=lrE7olYYfj4m2orGmw/eefoGvC3Jw2C95rvpSotg8d8wtl5qVmjbumMX9h/GPBU+p0tE
	 zw06eYd7BE8Zc085Jq/Q8gDt6CSam6eeSc4S9pKyIDH44jcPO74jDJC8PbKZenbOhhU+a
	 IN/7uH7vcVGAF9CHST67WtPT2KNoxMDykXy1vdn2knHgDYPZ23M6ogUUfJOYwypE7ckjQ
	 fBqr1j5DwUkKMqs8bS8OT1gS3ZC1dbZoCuUcJRloif4vR9GVRcvROyGcgaJlLh5ow+WTv
	 bxeiUzGF7acnaXXrLP/fbSohrowoJmMSbKmfzdkiXnB4n6s4wLmHck3u/FGWGkiCY2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aYyMAYSZ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F37606A335
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 15:41:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90F37606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aYyMAYSZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792856471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=aoHivYOiQdbOaZPXvgh0dS7cHVXJqr9Y39hFc8Y7tCE=;
	b=aYyMAYSZ9ry7Ve5+gwdjENF1kVycsdDvLQazZpIRTmz4bvfWgNwiP1n0QrXyeRGr7MeA2M
	1xc44kpYsvRj2GM6iL/GONsxCrl/Rssl1posUxrXrYSNsa1atLkjstkmvFlOkSIyFCpvKG
	WTL+3p/bwg1ul7bJjw9mwxLX0+KzaJs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-K2Ty4MCmMQaT-UimSTAjnw-1; Sat,
 24 Oct 2026 11:41:00 -0400
X-MC-Unique: K2Ty4MCmMQaT-UimSTAjnw-1
X-Mimecast-MFC-AGG-ID: K2Ty4MCmMQaT-UimSTAjnw_1792856459
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80AB31800578;
	Sat, 24 Oct 2026 15:40:59 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6549C1956087;
	Sat, 24 Oct 2026 15:40:57 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sat, 24 Oct 2026 17:40:59 +0200 (CEST)
Date: Sat, 24 Oct 2026 17:40:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Joel Granados <joel.granados@kernel.org>
Cc: pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH 2/5] net/rds/ib_sysctl.c: move sysctl-only code under
 CONFIG_SYSCTL
Message-ID: <atzRiBWrLVTMSrpn@redhat.com>
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
In-Reply-To: <atzRTslzb6CAKPKX@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Collect all code used only when CONFIG_SYSCTL=y into a single block and
wrap it in #ifdef CONFIG_SYSCTL. rds_ib_sysctl_init() no longer needs the
IS_ENABLED() check.

Add the corresponding init/exit stubs for the CONFIG_SYSCTL=n case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

