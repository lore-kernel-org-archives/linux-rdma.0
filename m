Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7103B95FA;
	Wed, 10 Jun 2026 09:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781082594; cv=none; b=fGH0zqGNUleYbDZBHxPqnj+d2r91AkqENlZh/cu7m1ZiTjdvfdSySLqIJ9Tx9NBeZYex97iQFU1A0GnsWdJazvjQ8TL2GXbOe5YliT4Rp4rFm77aGZj3E/HycnYXVzx2aMkTc+RK2TNUZEPYnTix3VtcW3eYDOA7tw+4VpkTAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781082594; c=relaxed/simple;
	bh=Q3c0YkQ00Dg2+6RvLhcCD5TdYu6CuiF/GpPRUubdqnc=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Mpo1FZSHNzOHex76oBIFIoGRgSrRYWzTj2jH12F1/ghY4vjR6KXMnPsBKW4lmjGtU+nBT2pJgQ32jBwKJnZ/fOjjNjBAyk6QgAydytsFDZvaY6qWcY/iysVwvelB24/MYkeZtA2B6YXe2ug388owIbObKlWfz7rRgXu+9dfzcC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=BQaeTVJ9; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="BQaeTVJ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1781082581; x=1781341781;
	bh=fzpIdMYjk1mOVwb0koV+o6fWh0wxCF1fK7xFHu0BzR0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=BQaeTVJ9jWeeb5d/3JeUV/n4qPYIpqXSZ/RBvD7kGdGJ9zge+ZxHDv5UKiouq/0ID
	 TxwMpXnGPhOmcphfdSsKzNnwwosPhGsZG13UYwASSxEeNMd+0U38nhnbBg8OTGfAly
	 DPP5a75nui99/Z2PuQPrLl1Y9n88xgvuwjej5ps9HmvkgKp5lskFKtgZpYwd0g9OYD
	 XeucitQvziLXBFDKz1gj0fSljfal8WEX4F3ViY/zzFpNDjcAHnmETVEPR03uWxl1wg
	 odamJsSRfOArlQwDzLbLgpf4CVYGmNxSf0gxDOip2urExcqTh3saPkrtevOVEQ4CSt
	 2mkToif4B/u0Q==
Date: Wed, 10 Jun 2026 09:09:36 +0000
To: "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/smc: bound sndbuf_space on the SMC-D DMB-merge receive path
Message-ID: <20260610090928.192177-1-hexlabsecurity@proton.me>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 803145bfb8bf62d5bbca7acd9daaed6e63526b1b
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

When the SMC-D send buffer is merged with the peer's DMB (the nocopy
DMB-merge path), smc_cdc_msg_recv_action() advances the local send-buffer
free space from the peer's consumer cursor:

=09diff_tx =3D smc_curs_diff(conn->sndbuf_desc->len,
=09=09=09=09&conn->tx_curs_fin,
=09=09=09=09&conn->local_rx_ctrl.cons);
=09atomic_add(diff_tx, &conn->sndbuf_space);

conn->local_rx_ctrl.cons is the peer's consumer cursor, copied verbatim
from the wire by smcd_cdc_msg_to_host() with no validation.
smc_curs_diff()'s differing-wrap branch returns
(size - old.count) + new.count, which exceeds size for a forged cursor,
so a malicious peer can drive sndbuf_space past sndbuf_desc->len. The
"guarantee 0 <=3D sndbuf_space <=3D sndbuf_desc->len" comment on the
atomic_add() is not enforced.

smc_tx_sendmsg() then reads the inflated sndbuf_space as the available
write space and copies that many user bytes into the send buffer; its
two-chunk wrap-around copy bounds only the first chunk to
sndbuf_desc->len, so the second chunk (copylen - first_chunk, written at
offset 0) runs past the send buffer -- a heap out-of-bounds write of
attacker-influenced length with user-controlled content.

Enforce the documented invariant after the cursor-driven atomic_add(), as
the SMC-D receive path already does for bytes_to_rcv.

Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB=
 are merged")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
The out-of-bounds write was reproduced under KASAN by driving
smc_tx_sendmsg()'s two-chunk send-ring copy with an inflated sndbuf_space
(slab-out-of-bounds Write); with the clamp the same input keeps the copy
within sndbuf_desc->len. The DMB-merge/nocopy path that lets a peer
consumer cursor inflate sndbuf_space is reachable with the in-kernel
loopback-ism (CONFIG_SMC_LO), which advertises dmb_nocopy, on commodity
x86 -- no special hardware is required to exercise it.

 net/smc/smc_cdc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 619b3bab3824..cf8d65407ea5 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -365,6 +365,10 @@ static void smc_cdc_msg_recv_action(struct smc_sock *s=
mc,
 =09=09=09smp_mb__before_atomic();
 =09=09=09atomic_add(diff_tx, &conn->sndbuf_space);
 =09=09=09/* guarantee 0 <=3D sndbuf_space <=3D sndbuf_desc->len */
+=09=09=09if (atomic_read(&conn->sndbuf_space) >
+=09=09=09    conn->sndbuf_desc->len)
+=09=09=09=09atomic_set(&conn->sndbuf_space,
+=09=09=09=09=09   conn->sndbuf_desc->len);
 =09=09=09smp_mb__after_atomic();
 =09=09=09smc_curs_copy(&conn->tx_curs_fin,
 =09=09=09=09      &conn->local_rx_ctrl.cons, conn);
--=20
2.43.0


