Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582297;
	b=PibnxOJRZNsRHxhi/yibYW7pim0R7UbFSH9Ai9HVcmT9eqNB+jLx3oqhEBU5U3+1YSRF
	 z8EUBzL6oTRGHmTv3J4qiuJaCFEnoPyoJPaNuMBDUklzshxicq+zmcOD6s4m/WFc7GDBq
	 7Hnz1NMCyp/UXUzbd4GDb0wPZVNFiu12Sq4DviJV6h/gxm73FI9MkC1zfAth/Xsha831w
	 QvQIdmw9q1Nqb0yvyNNfGAKdIe0wgCLCMk8EjJYRXnuOki5ibBeUDqMbXNicMpyFMQHHP
	 EqwOFj5GWRiZoWDvwPYq9n3jOAk/yelcQob3Tv1LFOq0L7oRRMVklb/ye+gd9j5fwZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XO4TrpK9P96uCfE9RUiQZD2WOyvv7UkLXAlskXveiYg=;
	b=TGnBZQBRRXaHzZxdSpFZ5pz2w+EZmxcwyV2/ojv1SrhpJ9br9Id2bKY7puHPCUxqhbAI
	 HBCSPkKJIRdyWE00ZYseb8hQZ5T5F6+UUFt9XAaFWKpP551K3IZBzQWydAXvG6FPsWArY
	 1m3DRVD9k1mMq/67iPxBEnvxbMbOHLMRzDvPIebItwPiVpCcIdKFJh7CH7v7oxRiOJM3d
	 uV0DAymTZ05rOQo+MAywN5P6m2CqxLa6HlfUQgxSHQdyc+Q8+5gLgeyFLR1bafi9wan5a
	 0YcOXQxdP8b+gSnzoyhOnd8JiCR5Z5kCvnTndL/RdLmPjV0FtsT53rTvpv8MwKEuMbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=McoupJE6;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C7606A321
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 04:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 992C7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=McoupJE6
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b3a42a4bcdso2223965a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 20:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795582296; x=1796187096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XO4TrpK9P96uCfE9RUiQZD2WOyvv7UkLXAlskXveiYg=;
        b=McoupJE6wFfgw5zfTpObm4Yqn1QNI/cTFKc6lB8T6YoB0iuTcnCCjvOMj3Ch8puAnA
         DyUDOkRXRv95zl1I73oN+tePX2MBItkbp6/x2/RhD70SiwnW2UZBU3rlFkqmDIKkfmvH
         fxMHfYQ79v23fyyi1XvIHiN+uXteKV5jCoURlmhFsvXxRAfIr2cdchzTYPUgEdNjf40F
         7lsKXVSVgrvWTkiRDIInkGPU3Ap9hglh5xTrgOxmBnXQTzRaIyw/bSpO1NK+F/BIu5zX
         YBCX7iMYxRv9R+k3Tatp1CGyXzzc/0OkiIg7AnZZ/8U+gtwnIkEONyabaf2owP4oP2yr
         +Edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795582296; x=1796187096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XO4TrpK9P96uCfE9RUiQZD2WOyvv7UkLXAlskXveiYg=;
        b=eMK9UgnQh580wRwXhakOdjlE5eErx2SO5Ar/e/lKqKrkLbdkl5ZGFYi4rlMxwJZ5Eq
         dSZjc6EBBtV4IX4poZ4Gmk4D2nShXTRX4SCi8VpSmqwydRTdVYXTscldw0y04VQT5MMM
         8MBT1WQTdFFseGBQACSIp5xreMVGvRI3N4B1+JwM7iH0AJkl7gXE1iUg00l6tHaQg+zm
         w0OoR23zjNViptXM2Ob06Ar7ADDAuCNjZ8k9z9DjFlWNOyf3qVi2rsGF/HP+gb1OBZpt
         4F/4ObS9ur4AqT94Qym4N9PjXtYOPk2EDroC5HfaM5s0Q9evideN2cU2IPR0uUX52uTz
         xE9Q==
X-Forwarded-Encrypted: i=1; AL+hErEwVdsNPgpPKfkzoRNTIq3F4NCHuPijzjRpLgICYbBKS7EHwGvndgZUQ5aZgH/Qx88YY700ekb53oxX@vger.kernel.org
X-Gm-Message-State: APuU4Z8+/oQzJz/SqOYg0xHPkQ5bLnKbin/OfEBsvMTPaLqoJlMMn5yO
	E1hElLxMQ1D2pDJzmJS+fwaGnJFfk/RsUxbUvlEBW2/9XQZwGgLrRpMf
X-Gm-Gg: AZFdTZfY1XqnlDzjm10JrdnAsupXodKV1c/G2hGPB6zfVk7WD32Q2sz2RCvgH6qj/Tg
	JEMag/nbXldz2qZauO830iSl/34lqq75Fr1aZ7I9IxLeeuVV7bxZcu7qOEt1pjYvRe4rAaCZ0iY
	m66pIJLYU0SZC/biMuWYByyF7+KRPSff19rzifojeAKJlrqTTZ1YtI/PsvtlIUKvZvzcXNE5cJo
	cJjulebw6bdKX9fG3GPrtEJMmTUYHQq6Cgu+6xb7n5lXrfHcRziP52b50vKyGpnC/yZZShO40aj
	dsrPnHfasD7ofEHnd9t/mK1aHOueT/DFWRWxsCAFN2y92CNPcr+rV/5wdOetEjS6wKBD8i2bI0U
	6ePk99aoS3n8YlG70w1IkzOPXBGrkzWR38s6SYrcQ4BChzGEkXV8VR5DriVlfdYnXKPoTfkh+A3
	QoCykyKNjqg9UKZNpAP1cUTtJ0raSydSueMvyWZHOi0EWdSESU2fEk5onN+2nbSKMx06Z+2Ie2c
	ChBdLl7tEMr3LjiRi4KVvSnwZtmKPwhJgfAfI2OuCXlMiDm1+J0rrW4wPvYKLsGssl6G/3NLH1u
	B2cPK2RGn69rHVg5UkEU9rji1EqRmGu4EbWmyR9idFM8n+HxizVsnffCBEqI4nM5
X-Received: by 2002:a17:90b:4ccb:b0:3b0:9183:23ef with SMTP id 98e67ed59e1d1-3b41c7b67femr15911910a91.3.1795582295961;
        Tue, 24 Nov 2026 20:51:35 -0800 (PST)
Received: from cps-manycore-1 ([147.46.174.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4b3c71192sm9457209a91.5.2026.11.24.20.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 20:51:35 -0800 (PST)
From: Sechang Lim <rhkrqnwk98@gmail.com>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Amery Hung <ameryhung@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
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
Subject: [PATCH bpf-next v2] bpf: Reject sleepable struct_ops programs without check_member
Date: Wed, 25 Nov 2026 04:50:52 +0000
Message-ID: <20261125045105.2326120-1-rhkrqnwk98@gmail.com>
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
struct_ops to reject that in check_member. tcp_congestion_ops, Qdisc_ops
and smc_hs_ctrl have no check_member, although the kernel calls most of
their members in softirq, under a spinlock or under rcu_read_lock(). A
sleepable program attached there is entered through
__bpf_prog_enter_sleepable(), and lockdep reports "BUG: Invalid wait
context".

Reject sleepable programs in the verifier when the struct_ops has no
check_member, and drop the check in bpf_tcp_ops that is now the
default. Qdisc_ops init and destroy run under rtnl and can sleep, so
give bpf qdisc a check_member that still allows sleepable programs
there.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
v2:
- Fix the default in check_struct_ops_btf_id() (Alexei)
- Keep sleepable Qdisc_ops init and destroy (Alexei)
- Target bpf-next

v1: https://lore.kernel.org/bpf/20261124143123.1182108-1-rhkrqnwk98@gmail.com/

 include/linux/bpf.h    |  3 ++-
 kernel/bpf/verifier.c  |  4 ++++
 net/ipv4/bpf_tcp_ops.c | 11 -----------
 net/sched/bpf_qdisc.c  | 19 +++++++++++++++++++
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4e9a4d15af0e..95835534b065 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2253,7 +2253,8 @@ struct btf_member;
  * @check_member: When defined, a callback invoked by the verifier to allow
  *		  the subsystem to determine if an entry in the struct_ops map
  *		  is valid. A nonzero return value means that the map is
- *		  invalid and should be rejected by the verifier.
+ *		  invalid and should be rejected by the verifier. When not
+ *		  defined, the verifier rejects sleepable progs.
  * @init_member: A callback that is invoked for each member of the struct_ops
  *		 map to allow the subsystem to initialize the member. A nonzero
  *		 value means the member could not be initialized. This callback
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e7013ed8cadd..8c7e43220df3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23934,6 +23934,10 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 				mname, st_ops->name);
 			return err;
 		}
+	} else if (prog->sleepable) {
+		verbose(env, "member %s of struct %s cannot be sleepable\n",
+			mname, st_ops->name);
+		return -EINVAL;
 	}
 
 	if (prog->aux->priv_stack_requested && !bpf_jit_supports_private_stack()) {
diff --git a/net/ipv4/bpf_tcp_ops.c b/net/ipv4/bpf_tcp_ops.c
index 2ba73dd6c52c..4e54165a3928 100644
--- a/net/ipv4/bpf_tcp_ops.c
+++ b/net/ipv4/bpf_tcp_ops.c
@@ -301,16 +301,6 @@ static int bpf_tcp_ops_init_member(const struct btf_type *t,
 	return 0;
 }
 
-static int bpf_tcp_ops_check_member(const struct btf_type *t,
-				    const struct btf_member *member,
-				    const struct bpf_prog *prog)
-{
-	if (prog->sleepable)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int bpf_tcp_ops_init(struct btf *btf)
 {
 	return 0;
@@ -329,7 +319,6 @@ static const struct bpf_verifier_ops bpf_tcp_ops_verifier = {
 static struct bpf_struct_ops bpf_tcp_ops = {
 	.verifier_ops = &bpf_tcp_ops_verifier,
 	.init_member = bpf_tcp_ops_init_member,
-	.check_member = bpf_tcp_ops_check_member,
 	.init = bpf_tcp_ops_init,
 	.validate = bpf_tcp_ops_validate,
 	.name = "bpf_tcp_ops",
diff --git a/net/sched/bpf_qdisc.c b/net/sched/bpf_qdisc.c
index 5691c13781a8..61a19713c5ec 100644
--- a/net/sched/bpf_qdisc.c
+++ b/net/sched/bpf_qdisc.c
@@ -356,6 +356,24 @@ static const struct bpf_verifier_ops bpf_qdisc_verifier_ops = {
 	.gen_epilogue		= bpf_qdisc_gen_epilogue,
 };
 
+static int bpf_qdisc_check_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  const struct bpf_prog *prog)
+{
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct Qdisc_ops, init):
+	case offsetof(struct Qdisc_ops, destroy):
+		break;
+	default:
+		if (prog->sleepable)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int bpf_qdisc_init_member(const struct btf_type *t,
 				 const struct btf_member *member,
 				 void *kdata, const void *udata)
@@ -446,6 +464,7 @@ static struct bpf_struct_ops bpf_Qdisc_ops = {
 	.reg = bpf_qdisc_reg,
 	.unreg = bpf_qdisc_unreg,
 	.validate = bpf_qdisc_validate,
+	.check_member = bpf_qdisc_check_member,
 	.init_member = bpf_qdisc_init_member,
 	.init = bpf_qdisc_init,
 	.name = "Qdisc_ops",
-- 
2.56.1

