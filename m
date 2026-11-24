Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530722;
	b=b5N7NrR95957og9kxbDLbBXduorw9SpwZNh4xyRicsUGyGWISYtx+hmgQJe115ySDRuX
	 N7A6CMMTKlZqtqoW9LSxtxo2Qo1ZNLjnNCRxAL1FH09hEjuK9VK0sa3uzUrkr/t//H6nN
	 9oZpOJOptJvis9iY2AQZqhWvJv7tCGjlXqIpZZ4xxqHZYGywNWjIfnK2exLFpJkcpYLkI
	 oRD0Ix/+lQfRus5zwz5qwDL+Czjcs1twTt/LcJLgd3aj6YJf/1YhyAhjGSts9I8dw5G3W
	 zFgUikFoD5ob95kaSCCwi5cqSC1dP5PduyEFJscmSFD0xfvNyZEPtCRXrHDLzV608Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530722;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dAalStsyfXudMpg2j2V+fdfxbWvoIc3klIPMOpbgtew=;
	b=UonqAGCLccmexzncPdXEgbeoQ0UFQXRbu7vWjGS/W6d+Kh/RF29VJHeuYreKOJ+a+yp+
	 wP7GejT+zwKCVmRWIygWtvle75nDmYDwKeLYaf0VbQO2OGPfy++Umh86+Ir7DRbcDAKoy
	 jtM1YUNNvEDYFPiwEZWI54k39mUuPpO2l56st7Cm0ahA/hITkbztCCdjeUNb9wmWmCEyS
	 W4vHWedcDjJM02i7VnlnYcIviC6q2U26Yo2LdbLW5j8x04LSI4Sf/YkdrLtrfD8Qf+wSa
	 rRHRPgIR/1J9C9RZveiFuxjXUw7eHcjvsAmD7hDml6XJxzje11cmrCrSaGiRaVNBw9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cN6AA1Jo;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D533606A326
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D533606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cN6AA1Jo
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a06e79e152so2191359b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795530722; x=1796135522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dAalStsyfXudMpg2j2V+fdfxbWvoIc3klIPMOpbgtew=;
        b=cN6AA1Jo5PTed4Fuh1Z32tEBYOm+rwHdXRbPRhYueW20CqSPtk5CMVk+ar2L4h8YfR
         YDfoP1ddutTvohm8JkfBJLQP0L/rIc9rfdbeXoNlv3i9kStKCiUWl/2Sh+S6aZ7Oh0nI
         uiHQ6sCsJF7cXiyTzuRvHbYEFWH8L0zvTYAIn9VvopHd/ImDLgymUzizDWmswczd6OoC
         95DbOCDWTgzTefd+29AaCAuvjTrJjaRcqjUhesHuJlSjw/59rnscG053hvpwnIKHtUp4
         uROQuVFyxnBuPUVhEMOF6213D+8WP86Q6TxVERdTqqEF4/BA1Jq46UwVUH0b+LX+qI2s
         r32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530722; x=1796135522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dAalStsyfXudMpg2j2V+fdfxbWvoIc3klIPMOpbgtew=;
        b=RbezuC0xjTjL/+F3tEVD+2whiQ7EzJmPfOdceLq2EW61+BLqb6zu5p5aRByBnjFv0K
         if9Flhp0lhwwIDvpMDWrx7Ge9q3VeTcxM4qpdqPhkZpTn+kVb7LEaZZhDjS07kilaub3
         uG+wcr/qtGVwtLot2+doGrsos76D6p9if/SQ+MKYV1bP6vUEX9UUtyXvdEXbSty2dwK7
         DTXpHqXGSGLUxDhAfUKneAf0LJk4UIBoSO88nLDJug94mjazpTAHb6PhZ4Ig7YxWAF7N
         iy4N3SKAvr7sS3zngRwXkIyelNPo/dhhL2QWfGrmLyV0v4PK4RO/R14AE/0Mce3GId+d
         5SdQ==
X-Forwarded-Encrypted: i=1; AL+hErGANDgyUXlHt4fZDw5bfYjrpgfMpDtZr4fuUt+J4oSGMo73IkjeCtNFQJTCQrj6PwVYfyQni5ZRxutZ@vger.kernel.org
X-Gm-Message-State: APuU4Z9WmuazbuGUcX1p/WpCWxG60c0N4awssqHWLjSL8D6KlY40rrF8
	0dTx3Z57/d5tguT/rx400mNkY87dPdAo/3FGmRskYy6f390ZfVoaR1hu
X-Gm-Gg: AZFdTZec9q+VMxjWETKK8Ovnczd+TcZMpIUC+JCD8sJmkj5/XnZZEfpi36q5HjrzbpX
	XQwF7PRFJbVTUBaJRiCOY8FbozEDeVsi4y7lLagX54Y9GsthjEXmreUBu0sDqRNt4HldAPybg00
	rJx9VmhuJk/1eFWQOyZIQIJO3HdWxwU8Kub9F7XETmLnDuvSFKh2KXb/CFZKO1wC9HBII51bUyZ
	QgJ1GMNwGhHmQ56qpJD5Zgbl3k/ZnLCZPgltgpeiRdzJdkmmMXQE+v1IsJfe2kBJAoNZBB3ZWFq
	J2Y0RUzXRw6NOItUgNWI7YBZaJWPr3Y1LZFavsIL3jYcRLy7iurpTkcC1HflZ1JIaGoeBKhNmUr
	gllKw4+RzOTwhuAFIRBqTSCo2WunyqxXMxfVtkcknOqgCIYrZozrW0WjVxIPBX2TOf+Q3kG6/Kp
	T8RdGu7tjee3RYIhD3+GdJbP17adHNMps/uKx1VrXXhDdlD1Z0d5GLNNxNBKM/a2UYuTLuWUfwh
	jN0OXFvxDbSxNEn6ILKNdQCLD7JzkQBqpxtpby1Pjj9oL0dprTKJqVXGYT5VsOKFcOONuxSXO7J
	FBkT7oCSsIuQ0GaalLr8CSWLXdFJ7T3T8mWUtcX0IaBB25UDnVrIrE5DZmdO4qIihR/zyDug4Lt
	mDXphIaD7Dw==
X-Received: by 2002:a05:6a20:a107:b0:3de:b0cc:b0ed with SMTP id adf61e73a8af0-4014c94a7aemr14594290637.18.1795530721628;
        Tue, 24 Nov 2026 06:32:01 -0800 (PST)
Received: from cps-manycore-1 ([147.46.174.222])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc8829sm7171737a12.8.2026.11.24.06.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:32:01 -0800 (PST)
From: Sechang Lim <rhkrqnwk98@gmail.com>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Amery Hung <ameryhung@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	David Vernet <void@manifault.com>,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH bpf 3/3] net/smc: bpf: Reject sleepable programs in smc_hs_ctrl
Date: Tue, 24 Nov 2026 14:31:15 +0000
Message-ID: <20261124143123.1182108-4-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
References: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
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

An smc_hs_ctrl program can be loaded with BPF_F_SLEEPABLE, but
smc_call_hsbpf() calls syn_option and synack_option under
rcu_read_lock().

bpf_smc_hs_ctrl_ops has no check_member, so nothing rejects such a
program. Add one that rejects sleepable programs.

Fixes: 15f295f55656 ("net/smc: bpf: Introduce generic hook for handshake flow")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
 net/smc/smc_hs_bpf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/smc/smc_hs_bpf.c b/net/smc/smc_hs_bpf.c
index 063d23d85850..66cf5143109a 100644
--- a/net/smc/smc_hs_bpf.c
+++ b/net/smc/smc_hs_bpf.c
@@ -82,6 +82,16 @@ static void smc_bpf_hs_ctrl_unreg(void *kdata, struct bpf_link *link)
 	smc_hs_ctrl_unreg(kdata);
 }
 
+static int smc_bpf_hs_ctrl_check_member(const struct btf_type *t,
+					const struct btf_member *member,
+					const struct bpf_prog *prog)
+{
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int smc_bpf_hs_ctrl_init_member(const struct btf_type *t,
 				       const struct btf_member *member,
 				       void *kdata, const void *udata)
@@ -130,6 +140,7 @@ static struct bpf_struct_ops bpf_smc_hs_ctrl_ops = {
 	.unreg		= smc_bpf_hs_ctrl_unreg,
 	.cfi_stubs	= &__smc_bpf_hs_ctrl,
 	.verifier_ops	= &smc_bpf_verifier_ops,
+	.check_member	= smc_bpf_hs_ctrl_check_member,
 	.init_member	= smc_bpf_hs_ctrl_init_member,
 	.owner		= THIS_MODULE,
 };
-- 
2.56.1

