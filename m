Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856408;
	b=XbFm/3djFSd0w7kaV4HhstVZFXitTdJHfZ3J99/it4xgnnZw3hjrEo8oPNM1uBSXTVar
	 tu59jWRU7potmm0EbkUFU3AQurSRDk23/j+xUkfwKvgC8M69CUhByts3gCZv7SQD/d9hX
	 eeaSlaHKle5twQv2X6RmRcnnHihRq7iScQFwaTEHhCgebQUOMg3d1nd94LEkeZv9Rg2/e
	 j4mDPvOMxOCDal9NZ2XQhnrh8XOnTvVc63cb9gzerxJfXwm66MczSAW+dK6UXr9C/ES9u
	 ZuajzqTnHVt+MBFgiXQUWmct/gyslR24J+PYNEXj+MxJY2O0DYuAtGbj17qZ6lfVKZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856408;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Scanned-By;
	bh=wl2V31FB132pnOHEDteyCX2x15/r+yvjr9u9jlR6QE8=;
	b=kfefl6Y/5FsCmb1n7oMnuu0Mpe6VwrbXsr86a7mdXWUwfxYmRZcwdL3Xhsil5o+L+/m+
	 CMAefYdjly93QXNE2USe+bKe0AzXocYx6IyYBW+8J97J3MPpXbC01WNyhvzeG5SM77dm6
	 0l/m9gDbxmYhTL/5P7WtN1Tw5UwkbXV1a399kh9rHkytR/52z+CDGXfdt5K1DwXg+gHhT
	 fvngcpkQPGi320oEvNRHsefEDEr/GM5QW6gnUh1uhrYv1yxfgAywT6mSl6WTKVigIUkhy
	 mB8lpiIwW+Mzx5vz+k7YGspWEqFqzrfkF1YB+PE7HwgUwZHVEN1kJg449BgtUeBeRog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MWJowujP;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B8606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 15:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC7B8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MWJowujP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792856406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wl2V31FB132pnOHEDteyCX2x15/r+yvjr9u9jlR6QE8=;
	b=MWJowujPvB6EcAviNCKy9U5M6gefwLhsTYRS9T5DLRHgxxvyvOX1RUXg4jR5T66epWLuOm
	XRENDdfCkvwPnyBte60wnH0dErk9alqICp/+xZ+ZcAAM0a+8EWYT0xbpomeYA5aEVdINLa
	77jd9vTA2fHJmsMF1tZqqw2ZZptmIM4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-ZIwB8MQkOT6BvLMlBz147A-1; Sat,
 24 Oct 2026 11:40:03 -0400
X-MC-Unique: ZIwB8MQkOT6BvLMlBz147A-1
X-Mimecast-MFC-AGG-ID: ZIwB8MQkOT6BvLMlBz147A_1792856402
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E20111954B1E;
	Sat, 24 Oct 2026 15:40:01 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C3FC33000738;
	Sat, 24 Oct 2026 15:39:59 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sat, 24 Oct 2026 17:40:01 +0200 (CEST)
Date: Sat, 24 Oct 2026 17:39:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Joel Granados <joel.granados@kernel.org>
Cc: pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH 0/5] net/rds: move sysctl-only code under CONFIG_SYSCTL
Message-ID: <atzRTslzb6CAKPKX@redhat.com>
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

On top of

	[PATCH net 0/2] net/rds: fix init failures leaving built-in transports on a dead core
	https://lore.kernel.org/all/20261021195837.142802-1-achender@kernel.org/

Allison, Joel, I am sending this mostly to "complete" the previous discussions.
I won't argue if you think these cleanups do not make a lot of sense.

And of course, I can't test them. I just verified that the kernel with
CONFIG_RDS CONFIG_RDS_RDMA CONFIG_RDS_TCP CONFIG_RDS_DEBUG builds with
or without CONFIG_SYSCTL.

However, I decided to abuse sashiko.dev and sent the cumulative "not
for inclusion" patch, sashiko didn't find any problem:

	[PATCH] net/rds: move the sysctl code under ifdef(SYSCTL)
	https://sashiko.dev/#/patchset/atyHdPlxALv0Nnyj%40redhat.com

Oleg.

 net/rds/ib.h        |   1 -
 net/rds/ib_sysctl.c |  33 +++++---
 net/rds/rds.h       |   5 --
 net/rds/sysctl.c    |  26 ++++--
 net/rds/tcp.c       | 230 ++++++++++++++++++++++++++++------------------------
 net/rds/tcp.h       |   2 +
 6 files changed, 168 insertions(+), 129 deletions(-)

