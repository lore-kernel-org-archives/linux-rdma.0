Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749122;
	b=j840wxO1BPsNO9IWkgbYv9xXCAHXI+RZhovh0HFCPGWY7jB1ikl7QAa0R7YOPXh6/tbP
	 tUnKw04mg5EqSVh0NdQytRao16IBgGhuSDbjmUFfAeixOjEbuYUuBKrJiDwNiX7W+VUse
	 BjQ0vL/XrbBXfZbSX9vwiSwBCApJzxAth5pWkWllu/akfeqbDVobAsSk7BPNUpDJV0D/N
	 d6Wh34/xziRCHJIAZvdxygBqEYSKehLJxq3YUJwnNIG+yWL6QEe2qApRN2UHUrhgH/Z7n
	 Wu0nK+tBYsuPD0DVlzD+VavV/mibvX9jBFxeZTs65RFNv8I7l+XH3ncp7ZTJMKU3pTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749122;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=AiQ5wrvFieNnTCG1Tf/m6yKrCPM1+sW4ILDN0hGiB+0=;
	b=34R2P9g+yJEj4eEQrxmMR1EgupxKj/d9jbC3DdyeD0eVdEkOT/rqMS1bsntLk9PW/aIV
	 YtW9V1O9Rt3BphafV6gVt7s0jcVCp1Nhs2gA5bcjmve0USAAxk1kfH6ENx4P8rw4kiqMN
	 wNcK1YixjjcmVqQktTUO963TsH1gnS/vgSE4t/1ioAC5/W4ApUZsXekhyfN/0btQjGkbb
	 UPa3ZNd5tUdYkZlcKXCkM7XvmCXF3211sNRwDCGyR6bdRKVRR9bZ7/s0hlVfIZoyKvZjq
	 L2+3eD53YLM7G+7HII++J1Yx8+KxWvb+0OJRKW2X1qCUpQs8FPGLcv5mAzTklIOSSIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bvhVotQk;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F3606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 838F3606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bvhVotQk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794749120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=AiQ5wrvFieNnTCG1Tf/m6yKrCPM1+sW4ILDN0hGiB+0=;
	b=bvhVotQkBhoIq+GflG+Qfs8GY2+y5Tf5NWmy3IiDLYxF7PDpkCYNm+QvSNQ7XguEnS71tu
	FfwPzM4qsRwaeAUt0J9k481OIsmOZ7ZaZwJiSQjypAoKAjHcceaqYY4J0mr5nTjW5NgIZJ
	xUIfmhie+DTfnvtZ7YxtprRLAzeX4E8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-lK_6369-NVevFtflPlchgw-1; Sun,
 15 Nov 2026 08:25:16 -0500
X-MC-Unique: lK_6369-NVevFtflPlchgw-1
X-Mimecast-MFC-AGG-ID: lK_6369-NVevFtflPlchgw_1794749115
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 036F018004DA;
	Sun, 15 Nov 2026 13:25:15 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id DC68030001B9;
	Sun, 15 Nov 2026 13:25:12 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sun, 15 Nov 2026 14:25:14 +0100 (CET)
Date: Sun, 15 Nov 2026 14:25:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2 net-next 1/5] net/rds/sysctl.c: move sysctl-only code
 under CONFIG_SYSCTL
Message-ID: <avmyt194jNI6Le17@redhat.com>
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
wrap it in #ifdef CONFIG_SYSCTL. rds_sysctl_init() no longer needs the
IS_ENABLED() check.

Add the corresponding init/exit stubs for the CONFIG_SYSCTL=n case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>
---
 net/rds/sysctl.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
index 968d6279bbd3..47e8782b1aa3 100644
--- a/net/rds/sysctl.c
+++ b/net/rds/sysctl.c
@@ -36,11 +36,6 @@
 
 #include "rds.h"
 
-static struct ctl_table_header *rds_sysctl_reg_table;
-
-static unsigned long rds_sysctl_reconnect_min = 1;
-static unsigned long rds_sysctl_reconnect_max = ~0UL;
-
 unsigned long rds_sysctl_reconnect_min_jiffies;
 unsigned long rds_sysctl_reconnect_max_jiffies = HZ;
 
@@ -49,6 +44,10 @@ unsigned int  rds_sysctl_max_unacked_bytes = (16 << 20);
 
 unsigned int rds_sysctl_ping_enable = 1;
 
+#ifdef CONFIG_SYSCTL
+static unsigned long rds_sysctl_reconnect_min = 1;
+static unsigned long rds_sysctl_reconnect_max = ~0UL;
+
 static struct ctl_table rds_sysctl_rds_table[] = {
 	{
 		.procname       = "reconnect_min_delay_ms",
@@ -91,6 +90,8 @@ static struct ctl_table rds_sysctl_rds_table[] = {
 	},
 };
 
+static struct ctl_table_header *rds_sysctl_reg_table;
+
 void rds_sysctl_exit(void)
 {
 	unregister_net_sysctl_table(rds_sysctl_reg_table);
@@ -103,7 +104,20 @@ int rds_sysctl_init(void)
 
 	rds_sysctl_reg_table =
 		register_net_sysctl(&init_net, "net/rds", rds_sysctl_rds_table);
-	if (!rds_sysctl_reg_table && IS_ENABLED(CONFIG_SYSCTL))
+	if (!rds_sysctl_reg_table)
 		return -ENOMEM;
 	return 0;
 }
+
+#else
+
+int rds_sysctl_init(void)
+{
+	rds_sysctl_reconnect_min_jiffies = msecs_to_jiffies(1);
+	return 0;
+}
+
+void rds_sysctl_exit(void)
+{
+}
+#endif
-- 
2.55.0

