Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795554399;
	b=MzPdB067X3/HciKQSbRQeJElqc7tp2xXJaCAINlgEKtXoaSNHmLPv4NP7EY7fO5aSAdk
	 wS25SdU+DlYYkyW7aG+ocPI8cmvMcVIIRcDor6qx9m31NeTMZiRMQKVLKzGyIKWqkNemc
	 G/A4xWyEc3JVfyynKkFg7y+ok6XOPpy48n01ipQXnn8r+g64XM5jtmAcJBnrsgDlLI74U
	 d/TukhzB9aBVeAftW+c38Ydeabs9xmONWZMGDAFSTwL+nzj1SZz/BQxVrbdsARuhNnCIH
	 2WbsgeIYA5Q/MqxTley0Dq5bEzTMcP2NC6hKFFxEcyHAIb8qEsS92kux7tIIATYB+Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=H+UnSX/PqY8z8gSxSr8JwMySn7nrmtRIZfAK3roY4J8=;
	b=kGLRytiw0xdLGoWP5GNTTS3G+l68hotjdywNGRGz8rOpWWId6c/ZQYYFaRYpmCfOsQVX
	 skvGAsfHQe4uQ/2Js5pHolBQbsnDt2HSCLsLQ5SnuSdsXGBc44xi9IKh99aGwBfEkPe98
	 3K568wb+ALyf7VIyvhBLpV/eqzhmgvu7auh3YQYwIpyhWlgJSW9zfM00oq7lEdbUbFA+D
	 dOs9VdE36FfEz8hkXGcu5S2ivzamFQnIFcYdCE+byQUAC3yTfCT4BmTVUGKfifO/4zqpz
	 pOeLNVlO/7Be5Ww8mdhWrSGPAwBhRsBIPiAleq+Mss5zep+OPHtpZrkWS58cbuG0hhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sfOV8cdi;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BDF606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 21:06:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17BDF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sfOV8cdi
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f0481b35c9so28863785ad.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 13:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795554398; x=1796159198; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H+UnSX/PqY8z8gSxSr8JwMySn7nrmtRIZfAK3roY4J8=;
        b=sfOV8cdi5VcmHLGRH5NTHwYZRQT9RsIrKksMA7txdbiosbMCbAQYV26IZcKiFHrh78
         OByVPKUKC2iks63XrrC/Vob67keyfOpbI6AbSWcYctfLseA5aUgfWDbB0gH+cP57XeoA
         HvYK8D4gxMFmG/IbCgHoizXNsJHuIc0uS90lHnWUYkQTFKsY0cqGvWtkcp/we4+H9Dml
         ZqZ8Icv5JY3kGArOdcvJEGfXB8rVyNRzUQF6m2c+ikoo0q7uSSctQ9gNmyyWp1FzBX/n
         5Q/n/05PPX0eFxw0iPGlyFxRtWQQ4HKHXIw1X56qMeyAeIZyUluqHvCCAf18OM8Wonzf
         4H9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795554398; x=1796159198;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H+UnSX/PqY8z8gSxSr8JwMySn7nrmtRIZfAK3roY4J8=;
        b=lEy6/RTd5w3MMhJFQIb02zDqoTV/psqBZ7p8+f8V1QfnO1wwwyTSMl6UuoqHU7BGc2
         GkxyO2EtQLkekR62Yv0ENqTqqomitZAK1LJBV3aTlTMMRRONAiapZK/8SpiyIAAoGYEp
         r4NsRfMIkPLBcKPIsmmFFSB+OqNTjAPsfSGmpCJOJV1J5hb3teK17dP9XSU2TpuG9R5J
         RPYPwHQ8pxjUe8vgHySj3He5eEA+JaVGrZeDlASs1aTO9IOfvj2fttV0CFnVVTiXWOBF
         Oi46bNViuU3cHU4NmDicuFnJK2ZZCudJXGMC5NVTWcCFjkEosc7ZTwLp48KkJodGEsP0
         2ASg==
X-Forwarded-Encrypted: i=1; AL+hErFBa/nZ+oXbbQivjlJndfOUKklkMPLM1dOUxGH9EssXYkUobjUwh39WHqp6w45C1liw/9MpMHgvnVby@vger.kernel.org
X-Gm-Message-State: APuU4Z9ufLhJtQmHmXkeBsDjNPqh3FHL4zlmyvorprUqHuOgcEY3PCif
	4zTZ4Zvo/FI8rEsfDXJkD2EQDSQxsVCbfbbjsoU5o681gA7yU/7k7i6y
X-Gm-Gg: AZFdTZc+MaGuta3yDK6/OKXPudVUuRcXcZIronf4y1IwSKZA3fxYSOZcX/iheLaRVaj
	n2jDXf4xom761ZWGs+1pnKY+NUkpCnlR06lEHUByBUgcddYGlj1Nkh9XL1aLoZBKVNG64ld/5Bf
	524/V3QSk65puiowzhBzjvwYiQcqOiToUtYtNK5vMioCVOVJ3uy09ZPBaTYLTAJ4HRd9ChE87BC
	5lfut3KSkASVnvOkLNXKrOZTXw6IwQhbBX+PXBn8CtzEErBqXTfRDs7nwNZCNYv8Bn7HjkZYoS2
	KyiLyPKITevDcFzdVufQLezeIYuXV8iPHzsE0iNlrO4UxWuizrXHbzVZkrROQrzGNVztDW4EcID
	GB7JmBMizCu/tnx2gWogElmRZDvEO4oBuyPL//9Gbq0NBRlgY6o7g+wxbhvt22nCMKdStIOSrlG
	Ej/JRvOqnAtaHLHHxwI5ZgjJaTXmoFCq59ryGCcxGJ6u6mxtUjZTpCH+JGModcrprcqIFitqRUs
	InoHnHlQplcGNmb8Lm2p4GOkZHKQN4EWcZRHPYfmCHj7h+d8+Cvn2WUwG4ZGYvgQOMzYg85BmSH
	q9FGwt7GnY29GNk0BlpEWtV+XfJQCjS++wuCS0UfhA+n6JCRNg+HfhtvEpDbj5fJ4kVYbAJEgyw
	178AGGfafq3VMF3Z/9/YTdYR/6Ozx9S9BGg==
X-Received: by 2002:a17:90b:4d0a:b0:3ac:ea3b:f28b with SMTP id 98e67ed59e1d1-3b41c9cd21fmr13382679a91.24.1795554398193;
        Tue, 24 Nov 2026 13:06:38 -0800 (PST)
Received: from localhost ([153.61.198.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad46ef5sm24095661a91.8.2026.11.24.13.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 13:06:37 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 21:06:37 +0000
Message-Id: <DN3QWUNLDYAP.1RWBZ8RJH1QSY@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, "Eric Dumazet"
 <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni"
 <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>, "Jamal Hadi Salim"
 <jhs@mojatatu.com>, "Jiri Pirko" <jiri@resnulli.us>, "Amery Hung"
 <ameryhung@gmail.com>, "Cong Wang" <xiyou.wangcong@gmail.com>,
 =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, "Dust Li" <dust.li@linux.alibaba.com>,
 "Sidraya Jayagond" <sidraya@linux.ibm.com>, "Mahanta Jambigi"
 <mjambigi@linux.ibm.com>, "Tony Lu" <tonylu@linux.alibaba.com>, "Wen Gu"
 <guwen@linux.alibaba.com>, "David Vernet" <void@manifault.com>,
 <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <linux-s390@vger.kernel.org>
Subject: Re: [PATCH bpf 0/3] bpf: Reject sleepable struct_ops programs in
 atomic context
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Sechang Lim" <rhkrqnwk98@gmail.com>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>, "Martin
 KaFai Lau" <martin.lau@linux.dev>
In-Reply-To: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
References: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, Nov 24, 2026 at 06:31 AM Sechang Lim <rhkrqnwk98@gmail.com> wrote:
> atomic context. tcp_congestion_ops, Qdisc_ops and smc_hs_ctrl have no
> check_member, although the kernel calls their members in softirq, under
> a spinlock or under rcu_read_lock(). A sleepable program attached there

Not all of them. Qdisc_ops init and destroy run under rtnl and can sleep:

  qdisc_create_dflt()
    qdisc_alloc()                 kzalloc_node() with GFP_KERNEL
    ops->init(sch, NULL, extack)  no lock taken in between
  __qdisc_destroy()
    ops->destroy(qdisc)           fq_codel_destroy() takes a mutex here

A sleepable init is valid today. bpf_arena_alloc_pages() uses GFP_KERNEL
there instead of alloc_pages_nolock(). Patch 2 rejects such progs.

> This series adds a check_member that rejects sleepable programs to each
> of them, like bpf_tcp_ops does.

That makes four copies of one function. The default is the bug.
bpf_tcp_ops v2 and blk-iocost v1 missed the same check:
https://lore.kernel.org/bpf/20260623175006.3136053-12-ameryhung@gmail.com/
https://lore.kernel.org/bpf/178889947167.2.9168058946538747939@kernel.org/

Fix it once in check_struct_ops_btf_id(). Patches 1 and 3 go away.
sched_ext, hid, io_uring, binfmt_misc and bpf_dummy_ops have
check_member already, so they keep their sleepable progs.
A struct_ops with check_member still has to test prog->sleepable itself.

In place of the series.

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1dd9db1..f7c7380 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2209,7 +2209,8 @@ struct btf_member;
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
index 01a74e1..42a90c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22244,6 +22244,10 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
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
index 2ba73dd..4e54165 100644
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
index 5691c13..61a1971 100644
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

Pls target bpf-next.

pw-bot: cr
