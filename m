Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444644;
	b=xAKZIpIPuiFWKFuUfEPFZ5lvmfEzM9132gPXzrOrhEw67BDJ/Dk4GBFDugMe+35W+ZkA
	 X454JShCixp5HSjAkhxhmMmoQehCDKU5jIcd+QfEVm3ux/qr68VRON14e24ts3YGIJlVw
	 Zl06c+FMFXNM/2MnDTekB6XUWUPydspROOARKLV2fTOVgyK26obiWvwGRjI2EbPT6oY0e
	 3CXDj0vjTemiS+CJDF7+bVMuWv2tVrYkPpq9J6QvcO9Ub+QfxWFCH0S07iM1Xg3QpsGdr
	 yD3WNi28Y4Sd8uQpxjxiM0rfrgJhF7CVN3vM7vbgB3WRY+o5JBIAyHrAgGPPWB+NWXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444644;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/oBn9L6dqvLgMMN36q80K6Pxs5n9XcWSkNPmKzy3EwY=;
	b=LSD1R9W++uDtF8Ccspm2wc91V6R7XCmWm0sql/Bob2h3+hmJxEmR/k1oTfe9hpuTEknj
	 BMZq3BN6+9Poh9OnZn104og+QsXoAua8gT71nll10pLNEWC47DidtjKHhykYHTZJ+UaD2
	 xs8qhK56j0ntYL3h4pzPMwitdU2XD6zMhNmNQPgYPnLrOF7er5b+1RwKPK/IiXYUpu2gq
	 LJyRa1JxZNLcBleUn75tZrsUyvp9SC55entOPExWhwXz1MfDg5kp3L75O5pF7fIORgavD
	 grXS/CYSqEkw4SAfufxIIi9q/l3DgMCX01Szs6/N78X1I59OzrRZiQJfuQs4BLB6aDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=IRYDNSD6;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A329E606A32A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A329E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=IRYDNSD6
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4a2f4ca0dcfso1937952f8f.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444642; x=1796049442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/oBn9L6dqvLgMMN36q80K6Pxs5n9XcWSkNPmKzy3EwY=;
        b=IRYDNSD6wQomEY9kCzwBS9LrTeC8HQjhoSSsCpftq4oYID6hEPK6IImBzQDqFna6ay
         WyIGxWWVmeFJu4019lvYQ46fV/z47qYADrhX2avX9WznuaLUo5+8nqDijXZg+i3icOg+
         S1PeN8IEEBaKlGUs5FBw3BdLCDRFbBT2VfGsPOR4CpGLB6JZMdQ1wOxxxcfkL1pO3krx
         PJWMneWdvaQVYVPf8JwIWH2beXbRPG1Ekzg1Wk2l9/oHqPCBG5ZVRCUjtoton7vSy9GR
         EOgT4ZEDWQO74DRHk8x2w13V4YL7SncfxNwINtLhGxrBqFK5RvVU7R/5G40He7lzC6xb
         m0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444642; x=1796049442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/oBn9L6dqvLgMMN36q80K6Pxs5n9XcWSkNPmKzy3EwY=;
        b=fvnQrNjSSUBQenRyJ1ylwNruc6bI83CzvNyPMRcLLSKpfMLionnNRvrYyKT71EvAF8
         NoH9mml4R4zllMpuK4hI6t+WY3SfZRHmRV1Jzc7KBKPVkJxTIQM3k14u5tZQ25hOh42T
         YGmTkkrd7s/PgsCaMw2IIp5DIwq3oOhTg8Y/5YpaDmzLmXkpMR8Lv2fgwDnwVsJ//shE
         zb9AL0F+mSlE9j+YifpMkFsJhPQU9xs20Tf8z+xZ6DvWHn7xIV3xTCl8afOvJwP+iv+0
         NNnAQuJI0clfgDap4LCSUmVvG8CLlcTGwHn1IrIo2qkQKRLgo34DuPZpkf5/RiFAeLcN
         Dhog==
X-Gm-Message-State: APuU4Z+rBH8CqOJ+bn2KR+o0d9uwU71DIAwvqqCYUU7qveeSkHwajz6U
	nrZhV05dsXtnz50g+rsPXIlPO89ObYw+d80NUtCmvbN9zJ8Fd05OB16PsIOpg5EmhAv9I1QQ5jC
	QaOhF0do=
X-Gm-Gg: AZFdTZe1ORzBPWx7Yhfm4PFTycDJXtGlco6kFmHm7WAH7aLc5ETIBSBpAFCLRaQCurL
	mw7Pj1tVPqhib+eLYQ0Ww/uyXiGaJMrUpgnpt+MPC1+rJkQRA0fuJPF3rDA6e6KJv4fCNI/acvj
	8uY1dUcXFZsEGfEzfkKP1lPb6DFLVRjahGilltcuCLux/N8lIpJDUmg4EK73Ev0KmkVq9weTG0N
	qvm017za4RaVtm9MYLte6jM7ZY5/m5Ft4xVapxZl93avLNFEQLm1OSX44OTR+X2pjnDoKuIOPnR
	ogE2dzndVTKXvYQECpCK1I0ZKO1YMqgvw89qri6l+2VpU6uFIbcXt0uOZ7hkJEEkKGNfH56L5gn
	Sz/KNATA/2Ls6aPL1E02tyQ8idCxs/xD3Yc/I3DxVu2JOSKY6evg7nYRqUOqyDfg9MeGC4d2+Aw
	+UGU/mETSrW7xpZJTWhGvglfHb51ibasKXcSdXAFUZEHehR8SnGEhR2vjhvI0VJeNS8tSpUbX6a
	yUhOexoYOm3+00CszpBug1N8F2HrX8D4j1/S4dtg4G7H+WZ7Lc7RFzIqoqJzon6cN3pKZ23b4gR
	MPV91TruqYAw0TuPpNKITluT1G/QPTCM6pCdIyAj5KsdPwoWjdAfIuyT7tyJkX04ORylU2ZSd4c
	uTEXEzYK8OK7aG6xN1+O/KSSG/fYsnoTvyJ8pjAwtfmglVEgLWoCqTSWs+iEouXodTlRE0HtI8x
	59lskZ19gX63Y3j+YJdESLRFqtD9EfwaJjgvx8
X-Received: by 2002:a05:600c:1546:b0:4a1:fc98:1cb1 with SMTP id 5b1f17b1804b1-4bb887c2cb0mr265781175e9.2.1795444642187;
        Mon, 23 Nov 2026 06:37:22 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:21 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Danil Kipnis <danil.kipnis1@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 1/9] RDMA/rtrs-clt: Add mpath_policy module parameter
Date: Mon, 23 Nov 2026 15:37:11 +0100
Message-ID: <20261123143719.938876-2-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123143719.938876-1-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danil Kipnis <danil.kipnis1@ionos.com>

Add a module parameter to set the default multipath policy for newly
created sessions. This simplifies configuration when all sessions should
use the same policy, allowing administrators to set the default at module
load time or boot time via kernel parameters.

The parameter accepts numeric values 0-2:
- 0: Round-robin (MP_POLICY_RR)
- 1: Minimum inflight requests (MP_POLICY_MIN_INFLIGHT) - default
- 2: Minimum latency (MP_POLICY_MIN_LATENCY)

Invalid values are clamped to the valid range. The parameter is runtime
adjustable via /sys/module/rtrs_client/parameters/mpath_policy, affecting
only newly created sessions. Existing sessions retain their current policy.

The per-session sysfs interface remains fully functional for session-
specific overrides, maintaining backward compatibility.

Signed-off-by: Danil Kipnis <danil.kipnis1@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index bf3a0377da3f..573beb5ccdf0 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -39,6 +39,13 @@
 MODULE_DESCRIPTION("RDMA Transport Client");
 MODULE_LICENSE("GPL");
 
+static int mpath_policy = MP_POLICY_MIN_INFLIGHT;
+module_param_named(mpath_policy, mpath_policy, int, 0644);
+MODULE_PARM_DESC(mpath_policy,
+		 "Default multipath policy for new sessions (default: "
+		 __stringify(MP_POLICY_MIN_INFLIGHT)
+		 " (min-inflight), 0: round-robin, 1: min-inflight, 2: min-latency)");
+
 static const struct rtrs_rdma_dev_pd_ops dev_pd_ops;
 static struct rtrs_rdma_dev_pd dev_pd = {
 	.ops = &dev_pd_ops
@@ -2758,7 +2765,7 @@ static struct rtrs_clt_sess *alloc_clt(const char *sessname, size_t paths_num,
 	clt->max_reconnect_attempts = max_reconnect_attempts;
 	clt->priv = priv;
 	clt->link_ev = link_ev;
-	clt->mp_policy = MP_POLICY_MIN_INFLIGHT;
+	clt->mp_policy = mpath_policy;
 	strscpy(clt->sessname, sessname, sizeof(clt->sessname));
 	init_waitqueue_head(&clt->permits_wait);
 	mutex_init(&clt->paths_ev_mutex);
@@ -3220,6 +3227,10 @@ static int __init rtrs_client_init(void)
 	int ret = 0;
 
 	rtrs_rdma_dev_pd_init(0, &dev_pd);
+
+	/* Validate and clamp mpath_policy to valid range */
+	mpath_policy = clamp(mpath_policy, MP_POLICY_RR, MP_POLICY_MIN_LATENCY);
+
 	ret = class_register(&rtrs_clt_dev_class);
 	if (ret) {
 		pr_err("Failed to create rtrs-client dev class\n");
-- 
2.43.0

