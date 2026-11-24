Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530709;
	b=GjN+dALmQ4gcAbFQtXjRdc1eHK1uDAOFf4unveQ+Cr5m9d2XnueOw/kwI58iiZsj0d97
	 Rj2L022hPBKbphwn3HEIt2FhvGqPLuxuQKEAeScXdDwPd7o7TLfRx1RRRDUlI7He3zlXX
	 b5Bey6q224OFZ+ushglhncEl7B/nhM2bMLSclGxYkHU2FKONjo90FQaWVFt7iV0P1u3vs
	 wEgLMOnPP+XRNZZ6DNMTBKWFhyqxL6ta8ROyycCABeAsfWzraA8EmxRogdPFKBbzKjDnV
	 tNIdVpIDdtAWdfajKRHN0HQhkN4ZCrw1N47nGFGiOGpX9sVTatz6Fpj2vSOpO1KfYSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530709;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5nQK3hY4QWxDiFxG2TVLn0sC87qjDF+NBgRn5G+iKQ=;
	b=lUCMGedqSfKthJH/mm4YRzycXn9tjz1+DZy6FjKDRWyWmfm5GJ8doAiAmF8zCC8YBamp
	 9+HsNXFL/ftXPDzpw31J3hW6opPV4hcT0fmV6zZsP8AmwqH4rBwQfZFFVse4KKeqSNnLp
	 bwVDvFfhfFoTx4XNiIfhwcTXN9xRYZKV0ZQH/PmqO38z+Kf+KAFNEitu6vLvcbR4ILLfc
	 MbLCV9notmFPJUo9ByKWuCezmUrUY6Tb/v2tVwfG3/jbAcy66fu7HjOFl6mW5RgH2dt8K
	 QSXjoEbWaCFsiV8tOMzwYj8GBLfHIzCPsnpwvd1BV6lqajHc47lY/WNahpwd090J6rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AjEHrqNg;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CCD606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47CCD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AjEHrqNg
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cddc597d062so2720843a12.3
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795530707; x=1796135507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e5nQK3hY4QWxDiFxG2TVLn0sC87qjDF+NBgRn5G+iKQ=;
        b=AjEHrqNgifqF8aPJ7EKJgLp2n35585eq5Lo7NlPgH7Ksj/AuHveZRs0v1+Jj/5Nk9K
         j+m9et26cCVsmUDROlNzguXU7+UAqRX9pNQL7hFerUbgazOwkPflbu4D2dCjEP9v318U
         qcBx5MXmk2SpLe7MhVmj7Gg5OXUqpZfTEYnUYDHGv+r2p9Hz6irlHYxkFGj8qj5h0SFY
         ovU0WeZu93+hL/FsH3taW3Bhd0qh6DJ7hxj19t4Nklc1hcnuguD/v+Bn9VvF03I+OyBm
         TOnOR0wxs8IQjc4nt34T2dTC9NQjZ8PdbM9CZoI00jbSq0z1/poyerK/kqKvJhrtWaIx
         ZxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530707; x=1796135507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e5nQK3hY4QWxDiFxG2TVLn0sC87qjDF+NBgRn5G+iKQ=;
        b=tQLwoPgxPI6gWd+qbsiK0qGC59QwANOVQbTqe1Of5+rfwKv/JaL1o+nWS/6qCnhyPD
         18GEjsIxpKrNlahQwQHM4mKag9R6cy3vZKUTK+r9ynEEqPST4HheKyEcSrY4uavOM9C3
         t2/k13yZk4ujZaqeqEFpMz+7nCQUA+ieLfYFjcIIcKPYfDrL2BpGSEhgZmo3tAXscfhy
         bWzKATb6iZMcj2zq93DvW6GQioKQDJ2r81IQIogw/JQ9KO+q67dsq5KPYAGDHiorU8hE
         +GKwWYvrb3cbJ9PiujfI6zrmxEol7zRQIajqHsyT5GPDeY1w+SXJ/CAX1uGNpmnX6BGr
         HlWQ==
X-Forwarded-Encrypted: i=1; AL+hErFvA2G3wtm34iXxcxUo8R4mHAJJVyg62YD/brrYG2ID+m+7gJD8Law1QKrnptdR3yA5QkaeKT3PE4HA@vger.kernel.org
X-Gm-Message-State: APuU4Z+Px2AlgMOMVDCzDWRoCcklsEzJK6FYDpYiLJPpaA5bzQu1lpLn
	fe4gjODla4DDvhbegGTnqfe1FqO1TLu+Aw93TcqoE/zfnb+1r+Mf06Uj
X-Gm-Gg: AZFdTZcPGYIOdS+EQUduEBzwu4AIfwxM+/70HHz1G4OWn5QKP35Yx6wj3JfF+HGVelZ
	gaMXV1il0wDPCo09G8590HnidTEp6uJsFmbWEB7NI0LVXvGGX7t7Xz0uQNGbLsGbQTYJV/E8koE
	6K4c2ZSH4xJRjCu1KXot2DBZgkWGLSU9fVL5tUGfG0GKABZvIkrfgwMn+omOxBOdEYa7fIA6cL0
	iV/2c8GW4PjU32R0kJP0ehVwEplwLAV4VzwjPOb9q+QvrcLk15FodqGQtOD+BQQFfcTgMme+tUB
	EGHzBsmDkc/HsXu8iipuPljWRSkCOo5VML3Vhe6zXpIQuin3DGOh7HHjVqHc23cdHOMxf/hB7Wt
	UUUgyTcZxAE0g8ZpDc9epjw/aCvq+qao9mA/6lN+sL1tPCphV4WNX2fF628tTHLss764OaNlP4E
	EzwH8q1ZSMRbcWT7B+s/2SePuNZ7QD42YNbnJEha1nuSr1lEw5TQ3N0g2faH8wwky6GtNmSeq+6
	64Fz441uIJ64OdymR+9rW/PuTX0I3Jzh1uq7lCIpEOR005AviQdu3QtC8A5nvieRDnyQngQXaZL
	vvLLcFM09lmQ1WiCpDu/v/AHEK36tRO5ZVc17Q8ukyXtVc0jDwM9BGGMeYaObwGhzXfcdW5bUxA
	V7Ss05MvxXA==
X-Received: by 2002:a17:90b:1d03:b0:3b1:96fe:f5d2 with SMTP id 98e67ed59e1d1-3b41c9bacc7mr14862324a91.65.1795530707373;
        Tue, 24 Nov 2026 06:31:47 -0800 (PST)
Received: from cps-manycore-1 ([147.46.174.222])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc8829sm7171737a12.8.2026.11.24.06.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:31:47 -0800 (PST)
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
Subject: [PATCH bpf 1/3] bpf: Reject sleepable programs in bpf-tcp-cc
Date: Tue, 24 Nov 2026 14:31:13 +0000
Message-ID: <20261124143123.1182108-2-rhkrqnwk98@gmail.com>
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

A bpf-tcp-cc program can be loaded with BPF_F_SLEEPABLE, but the TCP
stack calls the congestion control ops in atomic context. For example,
tcp_set_ca_state() is called from tcp_v4_syn_recv_sock() in softirq with
the socket spinlock held.

bpf_tcp_congestion_ops has no check_member, so nothing rejects such a
program. Add one that rejects sleepable programs.

Fixes: 1e12d3ef47d2 ("bpf: Allow BPF_PROG_TYPE_STRUCT_OPS programs to be sleepable")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
 net/ipv4/bpf_tcp_ca.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 2a71dc81562f..acd5e84a3dd9 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -208,6 +208,16 @@ static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
 	.btf_struct_access	= bpf_tcp_ca_btf_struct_access,
 };
 
+static int bpf_tcp_ca_check_member(const struct btf_type *t,
+				   const struct btf_member *member,
+				   const struct bpf_prog *prog)
+{
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int bpf_tcp_ca_init_member(const struct btf_type *t,
 				  const struct btf_member *member,
 				  void *kdata, const void *udata)
@@ -335,6 +345,7 @@ static struct bpf_struct_ops bpf_tcp_congestion_ops = {
 	.reg = bpf_tcp_ca_reg,
 	.unreg = bpf_tcp_ca_unreg,
 	.update = bpf_tcp_ca_update,
+	.check_member = bpf_tcp_ca_check_member,
 	.init_member = bpf_tcp_ca_init_member,
 	.init = bpf_tcp_ca_init,
 	.validate = bpf_tcp_ca_validate,
-- 
2.56.1

