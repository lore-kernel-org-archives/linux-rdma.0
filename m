Received: from mail-oa2-f0.google.com (mail-oa2-f0.google.com [74.125.231.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB81B3AEB29
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791477653; cv=none; b=sbTT/PM/rF+RAyCzDQCf0UhSMJhQ+E0nALI5JfoXpMUChoSwPI1UCg0DqpI/KofGOSZg/sC6QtX22woDfSMvHrOnyr6e6CUEw2r9qXH6LyOF+AfSnV50uwYzNHdH6/fArtbREXkLRAGcAHIz/NrbE17UyzDBpBd1pGBAIbff3+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791477653; c=relaxed/simple;
	bh=imWuqE76DrVJWZgCKyCFc7MWU5CZeZEyrJt3Q6oHClQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=djJ1oSSJlC0Td0ecCAEF2Pno/7A7MJgBcwauGKRMYCjwq9O1/o6PNP44ESNmPFMLmSYLagcbl8Nt6HGPAhqnEkvXdVjKECVC2apl56tuaCFYBB0M70Ss/h2hKyjXoVKGpbVsNLNPnF61epX3sICBpSGKhQboO/HjFoayg+I4S6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+CYnki3; arc=none smtp.client-ip=74.125.231.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+CYnki3"
Received: by mail-oa2-f0.google.com with SMTP id 586e51a60fabf-44cdbcd53b8so1403907fac.0
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 09:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791477650; x=1792082450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HXq065e6nI28MxLdaLNxE40ltfZ0a3n1jeYu75IbvbU=;
        b=K+CYnki3ljfXAE3w7bhJEn7+yVxxIJgBa/NrLODm4Fs9gBhHngPjEkPCoRRNL3GzYn
         Vkb6dSVIjQF9gu0GRky5QNjkoxu3Qy3wl35CTm4INWra1fET4e45I/99XIoT/nO3v9G/
         NTLvR6CUsayYkNzzrIW7Mid7vXHbtkGE67J8OhSAg9QHf8h39kqJtJZmy3kfAIIKSxm6
         48KgYM/2beDck1BkkXfPRneMA6rhjZUkdXFVVkbuvozVpELS/4bA7h7UEoP9VKrHYORZ
         RFYx1DoqrgJLn8M33tYKAmA6rkuP2Qjg+5Lk9p7MfXIpKN4eOEWDYDcBn8S3xC4qWuOX
         qUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791477650; x=1792082450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HXq065e6nI28MxLdaLNxE40ltfZ0a3n1jeYu75IbvbU=;
        b=g3tEX6EaB6BIJ7b9kiY3v3OkcfhO8Tji40wp94S/99d3MgMgWlRLxxice/tJN8p1TQ
         ZoQI36g5nNxZ1UM0AQPE256eFFG+YJi+09RBZEV1awZCD2SCRcLOcAknXe6ru2vy7enU
         tbONzAiGTQSjdquYBLuK/I7NZCcPuB838Rj1jWHew9mQ/Hr5yz+lh+15sPkiZsXeBmNb
         qE+Ocs3N4XwKMPBLCRWthCgWHxMr+8UiBk8nC8pt73BANc9RYwT1X91ISdbxveaUDLG7
         5oDK6K25byzwWFh99aCNBjn1SgL6FGS8x+1inIQWH/mFDpYlbZPX8Es+wORbjURuxsIf
         BptQ==
X-Forwarded-Encrypted: i=1; AKwUvBxuzeutyIoLbmfET/EWznJq7ZEIWHm/tMp/9RCLGlMuxQvYVenvQLNv8rInaQUDgWMct33ncgSfegFQ@vger.kernel.org
X-Gm-Message-State: AFuF++kt97UXtVazLi1TftgGMZt6kSjKN0AQUBI5stMDTyfp9eiX2tBb
	0XuZGweYG972q78cQxvqq44SY++MgyLVgTr6stna2lmvZC+A0hSu69Ym
X-Gm-Gg: AYBFou1Fsb8Vsy6+/f4EplTIBVfz5XrzZqmfpNY8jpVf3D+xS9swXiIQyJtqDtCoSiz
	IZlRGq6h/bqSoNe3nHgeG77cvSl/bsafLUnwhgiFwiiHcYFDOEEwnZrqOaCjnE+c7+j4tzXYgxl
	Ln2Lgdbe0H27KfvmiZc/ncol98YLfi1k/2QIq97LvsRbiHay+P6fXZIJNyJ2kcR+//2ct5AN0ga
	fT92+pRUUL0PXKwKD9I3R3DKplucmXBdti5oAqKfuDrBww1/ZxfIPIZRGKIs2r8h9IzlK/mArWH
	kjkxNNZyc9xdf8jiDvWqDMuTQSqr/EwSSPediqmRkjo5Lik/339+uf2d/d6gnP8KcKHH07iOJlE
	arRQY9MGD96VOL98J0SqDRBQBAmkM+vB/s+i5WG+ABfD/uzOqI+EbGENfiEHk4G6/cCCSeyCrRA
	VEmy5lfzpzMZAk+iV7XgHM+CtEi0uOL7YNZQDFCtHPdbD2a6Kht4ns1Y7usKPK7hkHkudKtO9TU
	4tMWQxo7LTxmVhn0yWF9zCqOw8yo2IWSwwpjA==
X-Received: by 2002:a05:6870:568b:b0:475:e0a7:9f2f with SMTP id 586e51a60fabf-4a2595b8b6cmr5129058fac.29.1791477650369;
        Thu, 08 Oct 2026 09:40:50 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.36])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a274ca5a26sm3560744fac.17.2026.10.08.09.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 09:40:48 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] rds: fix out-of-bounds conn_path walk in peer gen update
Date: Fri,  9 Oct 2026 00:40:41 +0800
Message-ID: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A connection on the IB transport (t_mp_capable unset) is allocated
with exactly one rds_conn_path slot, yet the peer's genetic number
update routine is hardcoded to walk RDS_MPATH_WORKERS entries whenever
the peer announces a non-zero gen number that differs from the one we
cached.  Everything past the first entry lands on whatever happens to
follow the single-slot array in the same slab slot group, and the loop
then reads and modifies struct fields there (lock acquired,
cp_next_tx_seq cleared, retransmit list inspected).  A malicious peer
can therefore force consecutive out-of-bounds writes into neighbouring
kmalloc-512 objects (KASAN: "Write of size 4 in
_raw_spin_lock_irqsave").

The allocation and the walk now agree on the same expression
(trans->t_mp_capable ? RDS_MPATH_WORKERS : 1), so the loop can never
outlive the array regardless of what the peer reports.

This vulnerability was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: ba3d1f480c7a ("net/rds: size a connection's path set by the transport it ends up with")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/rds/recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -144,7 +144,8 @@
 	if (peer_gen_num != 0) {
 		if (conn->c_peer_gen_num != 0 &&
 		    peer_gen_num != conn->c_peer_gen_num) {
-			for (i = 0; i < RDS_MPATH_WORKERS; i++) {
+			for (i = 0; i < (conn->c_trans->t_mp_capable ?
+			     RDS_MPATH_WORKERS : 1); i++) {
 				struct rds_conn_path *cp;

 				cp = &conn->c_path[i];
--
2.43.7
