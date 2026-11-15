Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749136;
	b=Huo4q8sZuzNhq9iEshOw3XNbZaVEJDNQ5ygHYl6IyiA2Aq1BXXIua7Y8BzVXL8bBE7c6
	 sQkKzy5BRNkDqEa5Gz/UV5ZzLGxYnfwnJxwf+g8Hzu9usVT33kznFh1nVwBt5+xQTQWh1
	 tMeSTvzMmnbM9BN7arTvO5arq9Z+yz+ag/4ZSd4yMtL3ODtE2sdtyg0HVHKwxABTKBb/I
	 eoFqfmjapmtafgaPnk++8JXGy06ClUYmuAmT1zUarEzG6g7IJYTJsP01aZBgSt4Xk/t7T
	 zZjC2lfCXafs+KiQgFAGM959gOxhr/wEQhyF6So7/36X8RA6AEHkUZxRFeyoqY5yHkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749136;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=3yaLh8HZvDvcHsFzqRw29DroL2qOToEPrETKS7oqVCA=;
	b=xuiLI+f1tPEWd+vGcQ+PqElS0gqs3LrIaS7L9k6MP4PI9LVuJhhdSmc2HleTRA/cs2y+
	 tbeeYNOq1Q7mcbqevGNq2NEqDNmwjO0PDifDeq7MTYCEyTBKipUpfCx/o0iN+joxb4J1J
	 v1yPs8TO6efTXnlxTkpTJdeP5ZyGVcCYqtheCSvKUCpLuT9dfERUsROUQ9sSPZvn63gRn
	 6eSF0oa04nZfE/b6gZjvTEVEut5e21yEBdC79pUzBhzBdtMOFRUWTS9l1DbFpZnEJ0s74
	 AVdL0LKXcmjodWQbVcqbH7jSPOC5OC9GLcJRs9/y5WbGPsR8WWXbq02evxE49Dag8Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HKSwtZAp;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DCC606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93DCC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HKSwtZAp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794749134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=3yaLh8HZvDvcHsFzqRw29DroL2qOToEPrETKS7oqVCA=;
	b=HKSwtZApNUqFexSn/JJGJEKf4U/ChWqX7/D/I9D4VN4rBhp0p8tUJfxnayCbMhqT7Q2Fby
	W6MLA5drT4j38K+8wtmbBcqfigQuKScJGl4D8W+iJQeEd/C622dk1h2koFDA9pWldpbp3s
	9SeSYcpqmtT6Y/D8A2qNKE4a3KSgGYU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-261-sBKeRBPbNeiXKeoQscWcBA-1; Sun,
 15 Nov 2026 08:25:30 -0500
X-MC-Unique: sBKeRBPbNeiXKeoQscWcBA-1
X-Mimecast-MFC-AGG-ID: sBKeRBPbNeiXKeoQscWcBA_1794749129
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4D041956042;
	Sun, 15 Nov 2026 13:25:28 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D36691956087;
	Sun, 15 Nov 2026 13:25:26 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sun, 15 Nov 2026 14:25:28 +0100 (CET)
Date: Sun, 15 Nov 2026 14:25:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2 net-next 5/5] net/rds: remove dead sysctl declarations
Message-ID: <avmyxTOuUkKnOaM5@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Several sysctl variables are declared in ib.h and rds.h but are never
defined or used; git-grep finds nothing.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib.h  | 1 -
 net/rds/rds.h | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 1901226368c9..a7f0005c5a0f 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -448,7 +448,6 @@ void rds_ib_sysctl_exit(void);
 extern unsigned long rds_ib_sysctl_max_send_wr;
 extern unsigned long rds_ib_sysctl_max_recv_wr;
 extern unsigned long rds_ib_sysctl_max_unsig_wrs;
-extern unsigned long rds_ib_sysctl_max_unsig_bytes;
 extern unsigned long rds_ib_sysctl_max_recv_allocation;
 extern unsigned int rds_ib_sysctl_flow_control;
 
diff --git a/net/rds/rds.h b/net/rds/rds.h
index e3937c1ff3a1..2d061b16966e 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -1027,16 +1027,11 @@ void rds_stats_info_copy(struct rds_info_iterator *iter,
 /* sysctl.c */
 int rds_sysctl_init(void);
 void rds_sysctl_exit(void);
-extern unsigned long rds_sysctl_sndbuf_min;
-extern unsigned long rds_sysctl_sndbuf_default;
-extern unsigned long rds_sysctl_sndbuf_max;
 extern unsigned long rds_sysctl_reconnect_min_jiffies;
 extern unsigned long rds_sysctl_reconnect_max_jiffies;
 extern unsigned int  rds_sysctl_max_unacked_packets;
 extern unsigned int  rds_sysctl_max_unacked_bytes;
 extern unsigned int  rds_sysctl_ping_enable;
-extern unsigned long rds_sysctl_trace_flags;
-extern unsigned int  rds_sysctl_trace_level;
 
 /* threads.c */
 int rds_threads_init(void);
-- 
2.55.0

