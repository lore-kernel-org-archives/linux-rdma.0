Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530715;
	b=YoAKEog7zrZ3UorPe1p8gbJKlvC1thJ1m54JODzhOh/KhqXRl+7rUYvKHPyE6qIfHJaa
	 i2WwO3935QaxgFscSAPhH6CQtpjx4r0GcH1H7kiX+Up/J3yCJwmNzWyrMSJdMWq+2MBqc
	 qn87Q/2UwIevDnpHNnPvPMFXuHr8lM+L0K+FwlAqymxkSNwXEFWJnT0CMAYpFA3C2T9N5
	 5SyF6XOKW5hJ+9+2tGmLdYXiClfgcFHt3nwtmgtberjIABV25VMWYd1xpZxG+9dTIM3SF
	 H9KoLluHevpdigIv92lQGJyHWjCEX51s6wrKJM7MKs8WFmYIfKrQaJkJqZ3dHrc88tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530715;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZ2nv19VYG29QEUsKhjFZiIjPyzoB2HzMjwa1gkZtBE=;
	b=DQyGvw9W8AzS93ndcHdBE3436+8P3mKeW06g9ZIFSJintR3FGT5LU9QZi6Bj70RBdF2W
	 XAj+oXyvbTjac6054pxpz0B4z3YZZ7wgSTDwzrXnzOBwsbfwrmgSShK3pYm0y80tK1TPI
	 cawVXObrDCBLaKObybsTU/U6Wd0BK1/eyXu/lQFoHLYbE15DJNufs/3tyVYpaNI0UHhfZ
	 txFgrrZ4DnUuqlQ4zHfnm0S83pykZeO0TLGDNkvlFDyOmiMi4avr9LmY2bJrV+hPFbFnV
	 G2IoNZlSR5kWwjZhQIv/EuZmAsLTYHS7kOOUlfCL+rCbkHnApQoRf0dO/kePsQ5509Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eZFPSpwn;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC1606A329
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DCC1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eZFPSpwn
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b155f50c24so3727330a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795530714; x=1796135514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uZ2nv19VYG29QEUsKhjFZiIjPyzoB2HzMjwa1gkZtBE=;
        b=eZFPSpwn+EWv3WI7oq8FlcFGbwsio7In32Q9BXJj5JT7LzvUi+kuUNm1OptvAjCIym
         aF8gEZ7GN0JzTzjRlSQ3RzWTQdd1+ELxeIAcrsblcQ1cDQsbrRnXpt+qp6NBBwMlAAlI
         8dmX7Soe+UgAiA/D0pjjKxJ71j8a3BiSOsVHvYDirhOXjv2CCz65FPRAx2J+gZxPH3X/
         Wfji9sW+KxmqfmoK0xns6FC+klWB+WlypOLzUqUiwa+utnziBtEUEndtzhsyOeCrhJMH
         CUAU99cpqBKX1trCjELPtos3AEXJ5UWjnA8HDPZIaR5qYjzl/vWzUSFJR2woUvkguqGi
         L9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530714; x=1796135514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uZ2nv19VYG29QEUsKhjFZiIjPyzoB2HzMjwa1gkZtBE=;
        b=hXBIbfFp/Xe06ux500Su113J8y+lOg8bgQIWnrRULHqOaAcqbu3OvhzqodkS4UQWbb
         J0LmK+mqD2OskIw1HHb5I/gKcagvPQhp+TFIwY9TLUkkPLGzA4vUr7haJ67snMIFbE8Q
         k9o4q831fYvPZAK9qWV4mmX53aGUofCc/FYEWjrUfLkhpR/SbrDK/mVRqcx2jRL8e6KW
         ykJOEu4qpuQVuDmYpkLw+22g2BkwmvbgpPqv1vaK0id7Svy4Pk9HjnxPyF0SrlJ2m0z1
         TKi0roqGJ6W2HXwW4azHh63rdTvUroHGnmFu7nmBDinE6BYsU7Pp/i8Nz/4zdDQ7Pnvo
         dohQ==
X-Forwarded-Encrypted: i=1; AL+hErGeRAsL8q6xfDGlIWsCi9AGwFaJJVqyxSooT/VJedyZz/hbLmzcrkkGK10LiX1ywXfSfoIPu3JKStDD@vger.kernel.org
X-Gm-Message-State: APuU4Z84iPqIiiljpOHqHiRkD9X1y2eSJwBkwA/2V4W1gbFCSeEjw3Wd
	IENq/kfZKD7/SxS8Y1CMhoUPTNgODyEn35hOFt3fQ2RjPdryY3F+Rjax
X-Gm-Gg: AZFdTZekCsUDNquMSnzXuzD5NiYpKG32dHR047AJtb6sAmcv+8MH+nQTQ8vLQy6W7hJ
	4p91pnQ0U8JEm0ASgMoqkb5n6yMrRXWdO592kxx+1BPiH9T+H8UvOiti38euVmnzPJzqo/JHvI0
	NMiqxfaLaJNa+ySFibsxyfhpncaFzqODixM3Rbbx0LGCe6SPMYWSX8dPckdD7aOCI5WVYtVj65f
	k6s4GGPk4PwciXpfFZqZ5w9RmIn43Lt6U3IzOkGiGyS/7Z9RR1SKU07z7iNX8it6uhOxm1k90Zk
	AAslafPFspCsrzZE7L5VpROmVPtIU2G5fMUQI7089isC0Tk2iDmlO/pZCyNzqkx2pdGPi5gUV5W
	ylWS8sTPriMVyKpNDA2s7/wCGzQr2ry85QtrwKjagJeswosvIEtvjetDVS1z/mArgjk0Upckkw3
	M64mAfgGnaVCXJmTTTEVM45jieMbx7PRKUKX6tlqn5jKwqHYzGUwDOrdPFX9yW5wCon2lKsU4WP
	QplWczDrXb9QWqAQ8O/4lCpmKVM+Y1eIkELcGj8AHFuUXn1coGMS5yQfrCRG0YvymHZeQlKxJy5
	oNMeZA/pVnC3tO0SPqxtJKGQ/CM9DWdTC9glRZld7oWAtOL6TmDRCvbfGHu/p2bc
X-Received: by 2002:a17:90b:4ad2:b0:3a4:7730:33dd with SMTP id 98e67ed59e1d1-3b41c99525fmr14250279a91.58.1795530714346;
        Tue, 24 Nov 2026 06:31:54 -0800 (PST)
Received: from cps-manycore-1 ([147.46.174.222])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc8829sm7171737a12.8.2026.11.24.06.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:31:53 -0800 (PST)
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
Subject: [PATCH bpf 2/3] bpf: net_sched: Reject sleepable programs in bpf qdisc
Date: Tue, 24 Nov 2026 14:31:14 +0000
Message-ID: <20261124143123.1182108-3-rhkrqnwk98@gmail.com>
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

A bpf qdisc program can be loaded with BPF_F_SLEEPABLE, but enqueue and
dequeue run with the qdisc root lock held and BH disabled.

bpf_Qdisc_ops has no check_member, so nothing rejects such a program.
Add one that rejects sleepable programs.

Fixes: c8240344956e ("bpf: net_sched: Support implementation of Qdisc_ops in bpf")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
 net/sched/bpf_qdisc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sched/bpf_qdisc.c b/net/sched/bpf_qdisc.c
index 5691c13781a8..3dbe52a04fa2 100644
--- a/net/sched/bpf_qdisc.c
+++ b/net/sched/bpf_qdisc.c
@@ -356,6 +356,16 @@ static const struct bpf_verifier_ops bpf_qdisc_verifier_ops = {
 	.gen_epilogue		= bpf_qdisc_gen_epilogue,
 };
 
+static int bpf_qdisc_check_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  const struct bpf_prog *prog)
+{
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int bpf_qdisc_init_member(const struct btf_type *t,
 				 const struct btf_member *member,
 				 void *kdata, const void *udata)
@@ -446,6 +456,7 @@ static struct bpf_struct_ops bpf_Qdisc_ops = {
 	.reg = bpf_qdisc_reg,
 	.unreg = bpf_qdisc_unreg,
 	.validate = bpf_qdisc_validate,
+	.check_member = bpf_qdisc_check_member,
 	.init_member = bpf_qdisc_init_member,
 	.init = bpf_qdisc_init,
 	.name = "Qdisc_ops",
-- 
2.56.1

