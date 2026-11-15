Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749089;
	b=q/r8J8+5vE5E7D0kSQLhOB+nrFq2Bo5sRG5tYuVI0YbJ5rU+VmVWoCNj71WRlZb1ymnp
	 HNB0iM04uyn/qfOGKPdrlzyZL+XWgdixa607NvxPew8lrbCo82voAITBUBOerR7Z2YbbL
	 rDu4UpJR2QatRRd2/WoNTgKmebjrpzFrbtEb3j4Oy1NCcVW235nfU5n9MKfiqBmEXIYAH
	 jF6DTwas8iQyMLPYlX0ttv7rprrBdbq8DggDwU7YqJW5fTLMJ5ABQC8GWUltUTkkraSg0
	 PDFDrA3ypIFEXp64K1Geib+wWN3KVMjNYhWeCDLq82mrhiL5tID+0is833YN7T26v6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749089;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Scanned-By;
	bh=VTcvXdmY523c7IwXtXWkhth4SRtYhV4Dr8uIsB5kB5E=;
	b=X3JHY5eDbOVnoi/Bfw3MjXbuvcl3UD3lTqjLNzcp4GSs1HcDfRMtKLuDDyNpo32kyjLJ
	 0NP1KQ1PP8yTIdYN2yybTDoZCHL4YQzidl1WN0c6oy8NHcp+xHODC0MVjWRLf78xp7JQI
	 nljsVBfMPuXfJks28IzlpHfE6M3Y4wlUhLhuzzSChbyWkgDq3WZ2M574GlsKJ8nARhbqK
	 TZYVE5In/UalucO8J1AnaTHbEp5AoGQ40kevYfHe2Sn+Xzk7vNlDpMPWlZlqjBsbBd/lJ
	 gvQ5RCYoIuRO15g69+B2HqgVVt6NdyK/XtZpMBTaDFCYlfvBa+o2QOcEehegYakWktQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1t3YpIL;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A917A606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A917A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1t3YpIL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794749087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=VTcvXdmY523c7IwXtXWkhth4SRtYhV4Dr8uIsB5kB5E=;
	b=Y1t3YpILvTC/OLaMf0Q2akFnN6vr1IYIirxlbt9oq8wwznAkQZttHCB9HUfc76i59B0FM4
	Bs5HVeM+H98ZSf05Rp7ENBsmluWhlTQqQCViQHF3eFQZHzwZ4nCqODTQBQ0mywdKOO/HaX
	02P2p1O/Afrail3m3azbMXiBMlb99qw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-NFyHoO_NMJK367sy937hKA-1; Sun,
 15 Nov 2026 08:24:46 -0500
X-MC-Unique: NFyHoO_NMJK367sy937hKA-1
X-Mimecast-MFC-AGG-ID: NFyHoO_NMJK367sy937hKA_1794749084
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9642319560A7;
	Sun, 15 Nov 2026 13:24:44 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 567FB30001B9;
	Sun, 15 Nov 2026 13:24:42 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sun, 15 Nov 2026 14:24:44 +0100 (CET)
Date: Sun, 15 Nov 2026 14:24:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2 net-next 0/5] net/rds: move sysctl-only code under
 CONFIG_SYSCTL
Message-ID: <avmymGvelu00X5EH@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Compile tested with CONFIG_RDS CONFIG_RDS_RDMA CONFIG_RDS_TCP CONFIG_RDS_DEBUG,
the kernel builds with or without CONFIG_SYSCTL.

v2: rebased on net-next/main, added the acks from Allison (thanks!)

Oleg.
---

 net/rds/ib.h        |   1 -
 net/rds/ib_sysctl.c |  33 +++++---
 net/rds/rds.h       |   5 --
 net/rds/sysctl.c    |  26 ++++--
 net/rds/tcp.c       | 230 ++++++++++++++++++++++++++++------------------------
 net/rds/tcp.h       |   2 +
 6 files changed, 168 insertions(+), 129 deletions(-)
---
base-commit: 6964ff21c5d8b75649211a52dbfd92753e605649

