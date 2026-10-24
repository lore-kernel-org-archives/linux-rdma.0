Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856476;
	b=I6g7IgJayNxlg9h7t8/50u1qtQygpCTSpPAYG0vz74z5AxjOSabxwjRuuYf35DNqjo6d
	 F1kc26znXLzD7lOhcQ22YqFOgid+zmoabLtNp//sCukisvHJhG1x0uCdp12ezZ+Re8hv6
	 5qk0stQoMd3mD1OUYC21UmZzDvXUsCP/0fqb8rfCtIG8gV1dKq1SIxZZfSEuH5NBp3RCi
	 GedYru884RewzXCMkisGzhTL1YfshC+ZxvyPDOl9mw6YvWfOjjj0mQhJq6QHCtVfbwwTk
	 SDW0tKag3DryA8rOp9+3mcBVtotUNDHGRsJQKelT7lFPzU2wP0W+ghp+cKsNr4ZiwpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856476;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=XYJ1aweQMbcRyljqpWl8FVZYxGmybu8MN0szrcmcXEk=;
	b=XR8ynQkLEIe9aw9lZfkrZqHbanhGcWqs2OsUo4vbx+9wZ8lsh7to1bft0LI7ceuPOLX1
	 zWKv6GzkZR8hGtnm1OBz2J8FF0Ai8ou+HfHN6wAKino3cP5eepyZJI22Lctr2vC0Xp+PU
	 oHX0toRYgZoa/3Kz8Dl/jP4RCMqigQCY9oPjZ2qAmiMnv4TMhOIb+hxXvxBe1a8Ui2sop
	 JLV+0gSiQtT0265w742GUxXq5MY/AyCWHQNfqPXT0M6hEJHpstSDT3aC5NCTy19UGHx3+
	 2QGO5K3O/x370iWoRQKWIW4va8DgwCvW8CLB12tu47QDFh3CZ2ZJu2TJcBp8tLoZqIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CSzLuXL5;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74FB606A322
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 15:41:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B74FB606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CSzLuXL5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792856475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=XYJ1aweQMbcRyljqpWl8FVZYxGmybu8MN0szrcmcXEk=;
	b=CSzLuXL5gJID4e9DrNLsg2tNqQ/qlnlxTdZkK72jQffDkT7B+NaN4C9wsuFvvkeGobZOXW
	Y5GDFS+461D13/34SA9WOYAEeIWvAYzOglNyv4bb+skWU12jpwBAOotR4gLq1Csytiqcwu
	+Rcx+O5bXGbsIEt17Kt7W636ruonmB0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-Li08pFrkNfGMK8xBU30H-A-1; Sat,
 24 Oct 2026 11:41:11 -0400
X-MC-Unique: Li08pFrkNfGMK8xBU30H-A-1
X-Mimecast-MFC-AGG-ID: Li08pFrkNfGMK8xBU30H-A_1792856470
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 087DF1800597;
	Sat, 24 Oct 2026 15:41:10 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CFB167E0;
	Sat, 24 Oct 2026 15:41:07 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sat, 24 Oct 2026 17:41:09 +0200 (CEST)
Date: Sat, 24 Oct 2026 17:41:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Joel Granados <joel.granados@kernel.org>
Cc: pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH 5/5] net/rds: remove dead sysctl declarations
Message-ID: <atzRktas9C-LDkV5@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Several sysctl variables are declared in ib.h and rds.h but are never
defined or used; git-grep finds nothing.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
index b7ef7c8b1e03..17d5eb6069f6 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -1025,16 +1025,11 @@ void rds_stats_info_copy(struct rds_info_iterator *iter,
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

