Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530701;
	b=hzU9aIB7Fu5m5xdF3RA2PyN5Q+hMRZFbooTSbU5yTVtioU7asojvWXcN77gW1Y15JY8V
	 fg5QB+Uxl8FzVWiuxQKpxI1PBk9EEEkpBpDXuoW6hf8D3jKUAEnlZZP/4LFaemWBBPLkH
	 Ek3MC8dE2H9Agvsxgu0uuIpIrSmUvvXA7bM2hSFOCbk+a4y2l622nXP/8/ix8RZZfX3n9
	 p7tJHVmDQDtKf6ROzakI25c8xzgybZSbbY5iGzA5+C4+Qt0zYy4Q00SU+xFHM/ywtWydt
	 Sbc5F4F+3TJwAAJsGQ+eACLVqGV7OXZ34KXbtaRzjYridkYH3UZt3rnv0SDzSz8ZNFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jS+nnfUP/mk+uzq1WRMmZ1+p5s6g2KJ+Zyoi13aubO8=;
	b=zTZwqvRPYzA8uC3CKSqqfPpBTT2QO8qi9ph1JkGZcVByJsIOFIzH/r+G59fHXb0FinIZ
	 m83SaLHqyK3PLcNDmpKZRcC/MGpNR6ydIpcaVBCxJMwwvxbv5swzK1oopxz/pwghnVYrV
	 uFftmrzSYiVkGlMNeoDw28hqC40GdDjdPbURmKtaVLt2ADR3ZQL/O5i3hEQ0bVK1oBliY
	 rmwgQ3GsqqPMw0yEe5R3iuAuZrK3+w3SrolEHwDP1QVIXaKDylLHlQNKnwptPGS4cTuXf
	 HX/7dN0eP45hj1GiG9zMwepyOoW3+YT8SWKZquj2Y/imRRex5i55zWaq4gGbZG9joKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pC5sINY7;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA2606A329
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51EA2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pC5sINY7
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b41188c8b9so3306761a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795530701; x=1796135501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jS+nnfUP/mk+uzq1WRMmZ1+p5s6g2KJ+Zyoi13aubO8=;
        b=pC5sINY79C+4AgNwYCHtQsgbceJxN2JL/o7ODQlGs+RCFyL09S5SBB3jb8+RV/zu4c
         uReUsgjhRD4YOTORigQTo1Hg93FhrKwIUBX/UFc54VdocQzI8ijqZYMAv2Fk60+F4r+c
         zc2B+VML47gQVM+c4GoDFitRViVwlIptdpnSB7ROGeeMOsEUGjjOsserxv+ourBDy4ZM
         lzy0PbaK2lRCbLFkXrW0LsnCL1d5wIRcXdcEJyL2x9mDvbmG9NZQmiiEPdNmz6Ssq9pZ
         ky8TZNgnZznEB6JP9HnTyhI9osqEu1BF5MF/jPp9VdywsrtelmCPrpZbFWuRqNxUpgiy
         Zqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530701; x=1796135501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jS+nnfUP/mk+uzq1WRMmZ1+p5s6g2KJ+Zyoi13aubO8=;
        b=sHusIhvvNmoDNlx2/bCccrfPnWw1CniGYwNCpPtPVC92DrG8nngU4xGzgmBve73Pj2
         VtUvE5yC97c11ty2a2GwXlRq5xyxImxjdOeyVxoAYakoLOHzTSN51sh/hpE/TGe1CcKb
         Z5l3yR+4NFwFoEa/bMLg9sO0A9UO6/UxX4rtCklOrfAHWXcHcEKiKyXM7QqlORkJmYj6
         JTTwrbDA/7u5dNfdNtEoL9d1wn4QdLk2kg64ia7mvypx0yi3h6/FKbLlQTfPPJYyHmfD
         4yjx++X5I2OiR5guBjCBVQj1zId7XNyvAdqjzbm45vqC2nmee36qPDbF2yD9NaLbn4z/
         GHXA==
X-Forwarded-Encrypted: i=1; AL+hErG4Ed9lTQUV0uFfLbMxLs7c1HdtyE0mrWFcG9sSQM8PiVEn8P5qjwDXY3S3mJQR5ywEdl4ILO4LVegZ@vger.kernel.org
X-Gm-Message-State: APuU4Z/Ywt1uBZUX0y3Cycyh0RN5S8GwWasC90y3D0YZaP6DPILu6Jp/
	CQDXXCMKz+65h02G9CcN4ee6uzXDgfjef+fsrNez33TieQ9TQ8kq4rm+
X-Gm-Gg: AZFdTZfyvPuY9rWPHwOhAP6MYm8EK+OKGdlLbWk5laq9b4U8kszeQBauqIG0t9r/GF5
	14soJaq1U5d7ZwJFzV8Hmr3Vh92BVBqktiZAsjlY4KYMG65pCnVtTF6hkW74RYZckgB3Y9FkfpP
	a8NjiBnaxC0IFl/U6SEAIW1Rw0K6+Lym5ssUDT752KUi21F46bqjP/FDckKaoyZDo0/V0U5hhaU
	9cb+Q92/AOLX4ObOMvQ9RsNppJDJT02Nlr8yQ+Ucv1FUHlD/nI2MoG22UEUSpefJPnQ5kDHtwLJ
	z33+JUmTq2+V3VCWDXym+sO3hYBjw8Tv89jdhDn+IRd6cRMchCN76E36D/ezO39dctciw1IttEz
	T5LbqBCZoFZFjFxWAF51zm1cEAFrUtlliujZeNvAisWxjkC9HSY0lOoacwTn//3nMeB1XmABjp+
	MYeEuxdNpw/7AThKnh/z0Ffj2hJfROnren4V2OpwqzH1z51EJTrjpRuceOHzlngtdk4HwyJc4vr
	rHb1FIsZFeLjJGtXFb++EMWGZe7CSB+umXb/l+q4aQry9DmBxJu8dWEriJoCoZBRiodonddNm3T
	FOtbAknjpy7f4BUNIIID+N7Vk8FAgS9JhyvkkNYamf4x4mzi8S4ZJZtiGqAAVxgv3jvI/Sne/CG
	lhssobFo/Hgk=
X-Received: by 2002:a17:90b:4d10:b0:3ae:533e:7e40 with SMTP id 98e67ed59e1d1-3b41c8d9bedmr13597888a91.23.1795530700477;
        Tue, 24 Nov 2026 06:31:40 -0800 (PST)
Received: from cps-manycore-1 ([147.46.174.222])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc8829sm7171737a12.8.2026.11.24.06.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:31:40 -0800 (PST)
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
Subject: [PATCH bpf 0/3] bpf: Reject sleepable struct_ops programs in atomic context
Date: Tue, 24 Nov 2026 14:31:12 +0000
Message-ID: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.56.1
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

Any struct_ops program can be loaded as sleepable, and it is up to each
struct_ops to reject that in check_member for members that run in
atomic context. tcp_congestion_ops, Qdisc_ops and smc_hs_ctrl have no
check_member, although the kernel calls their members in softirq, under
a spinlock or under rcu_read_lock(). A sleepable program attached there
is entered through __bpf_prog_enter_sleepable(), and lockdep reports
"BUG: Invalid wait context" at its might_fault().

This series adds a check_member that rejects sleepable programs to each
of them, like bpf_tcp_ops does.

Sechang Lim (3):
  bpf: Reject sleepable programs in bpf-tcp-cc
  bpf: net_sched: Reject sleepable programs in bpf qdisc
  net/smc: bpf: Reject sleepable programs in smc_hs_ctrl

 net/ipv4/bpf_tcp_ca.c | 11 +++++++++++
 net/sched/bpf_qdisc.c | 11 +++++++++++
 net/smc/smc_hs_bpf.c  | 11 +++++++++++
 3 files changed, 33 insertions(+)

-- 
2.56.1

