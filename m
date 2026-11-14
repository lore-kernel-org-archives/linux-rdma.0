Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794665699;
	b=M7vr4gyPutrTsTlYsceULCQe3Irq/6b4Ogzvuy0qM87Qapt+fUQVD1NHdCTugSyk1WsA
	 d7gJrxzB8Oi2J5KmijtHMCo/1SEloZhz/z3bJ1DupZHtcKn8Peo1CYecChZGw0LEJLhGj
	 GE5dvU5PazKACAzetEOMsz/HGMhdctrGPC9Qix1A7/H+cQs6P7/DaAm2mvPntNhy6V+IG
	 qojtT5VnNzCkdTSqgpodz8uY/gPB1aJijDuivKi+pbkxXVuUzkEQeFD9F2bqaI/dw70aF
	 4BWOINxACJZ9wr9nE+9NtZIdIyAeqKXZv7+TOTK+cpgDAIFt8pTuE6muAliBWSRI/rQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794665699;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=G4u5AhIOFg3Un7/OVQVhcKducbdMvClYNxtPBHy/Mz8=;
	b=sEuU+jJJn0Oc7TmwbmdQWL1/wFJIwOROre9o/noRGqBjAQ/RWjayleGV7wFAzPbGoQiK
	 H/1RCrKeCumsW090xPo7Ji7NDy6M5fet15Qqqnt95l8loYH0CR4eLFPHyDg/ieRZmiXcS
	 bOyU0wP7dkFAJtT0TmX0pmdkY8rCoRwRw9auQMwrYbCeoDQtvDEbkD5nxJ9c4HEJsITr6
	 fVPOnm5OJgxPOdfJ9SZYI5ppEwf+KBEvIq3ObDpqDboLXPyH5Qn9u+v0e3HeZ3KZmODNq
	 x58t2/l2xUBUHXo6+SRQ+1Zc8LHIWyoeljZdXDKJ1C3rM/XmCaLnlF2y6smG8giz5og==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="hVrZ/rGO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F85E606A327;
	Sat, 14 Nov 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVrZ/rGO
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794665699;
	b=RvjmogUU3g74TpbeFcqom0zbCVG3TzvQ9Iw2LdjpiS1XOLDYqrvrwCx7tYxI2ZesHdL4
	 WVwKA7MU1iUq7IuFqk3EvIuOOHmhGeiEfLxLYw6fa/palMSFFv3eM8qu81H2JNUH8ZXuz
	 lKMGiAFBIhPInKv9mJlUjMz+0boxtybX/LfcgLGlVgs3/hLtStg4IBNHm1gOm8NMQ4gk1
	 t5lO756i75ViDcind1tXnmVgrUVs5TikMSiThLXqgkFR0jrwSeCV7pCXicE0C+2zyro2q
	 9UO7YFHHzcIuD1zQnQvCe7DYc2Ch4GdEJs/pJGOegS+i1gMdHREpa3PXHbfZyCSGZqg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794665699;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=G4u5AhIOFg3Un7/OVQVhcKducbdMvClYNxtPBHy/Mz8=;
	b=iz/ge9ybdGVyeJt70tfC4QYFyn9WqD9vIwIsKgIBquHrhd6uKCscsldbmIx9tOhNSeus
	 uo25VkuyITZVfvzQMHSqPtVXWbJt8/MH7VN0Uv+gOUenYX/iYYZs1XgZuy0ajsUSHUSUO
	 R3X4HZoSwF0m9aOWdHxBOpWHHbX1DDsk2OninsBIwvLdGvs0J0j1n2nsantP3Il57HKHu
	 rlSbTkW8+mHXCzAIviAsbtXj7Eb1amOpdvEpuZCC3XTxMkHH6QYQTsE9a0ycvgS6uUDYG
	 TF53FzUgWt3exG88UDNnDuA/xx2XZp/wVe+RB+ogt0xB29S17eSVQGmA1tF+M7QBDrg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5B0DB1F000C4;
	Sat, 14 Nov 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794665698;
	bh=G4u5AhIOFg3Un7/OVQVhcKducbdMvClYNxtPBHy/Mz8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=hVrZ/rGO3odB2su7yszr8y9pYB3O5fkkH6BnS1a8frqlgG1e6wpck42mn/s7IFZnM
	 WlwVnCJVjRVLrN0fkai0ez2ltB16WTXLJg5vxTMfBNoaZcOnQ/NVVJKEB7mXq3Lm4x
	 M+akdMp+bkgOHLSNAM2avjj134+t930xXgIYcPrMVsVVdm2l6zejyT00d1seEYdmNW
	 pg9WLRd46Zf4QI4j759AcmsWTV2WhTnPK0Iqylp7rxhjmvvRJtlhIy1uQ7qXgiT8WG
	 FBhyBLR5kUwJUqHUAiFaZKtfP4pEs7IJCRprXj7ASv8RyVYoZZEZHEIyQgt2SqwVoy
	 TPP7CukSQJCUA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CA43649DC2;
	Sat, 14 Nov 2026 14:14:57 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 14 Nov 2026 09:14:58 -0500
Subject: [PATCH net] net/smc: set the lkey of every SGE in
 smcr_tx_rdma_writes()
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-b4-disp-dd99cd41-v1-1-009e1c022346@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQqDMBAAvyJ77oIbEyH9SumhZte6PaSStaUg/
 t1ojzMws4JJUTG4NisU+arpO1egSwNpeuSnoHJlcK3ricjj4JHVZmSOMbEndL4fKcRAoWOo2Vx
 k1N+5vEGWBe5/aZ/hJWk5ZrBtO8eVIEx5AAAA
X-Change-ID: 20261114-b4-disp-dd99cd41-246f1595153d
To: Eric Dumazet <edumazet@kernel.org>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dust Li <dust.li@linux.alibaba.com>
Cc: Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, 
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Wen Gu <guwen@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794665697; l=3051;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=dkZIYkWO+afWCtaRXB6rlTNCb1w2kuhU8KVl6AzBpmo=;
 b=Fm8nUYS5YgF6A3OcDnR5fkM8Orc+GUr95QOvYntRgXnITsnFV4EDHR4MiR8VzCWTYThWu/cjf
 Zs0fz8/hNPpB+OWQnISb0UUVBidefyMvTCFi4cHl1aZbeW+xNJm+A35
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smcr_tx_rdma_writes() sets the lkey of an SGE only for a virtually
contiguous send buffer; for a physically contiguous one it leaves the
lkey the work request slot already holds. With net.smc.smcr_buf_type=2
a send buffer falls back to vzalloc() when alloc_pages() fails, so one
link carries both kinds, and a slot last used by a virtually contiguous
buffer posts the DMA address of a physically contiguous one under the
earlier buffer's MR lkey. That write fails, the link goes down and,
with no link to switch to, the link group is terminated with all of
its connections.

Set the lkey on both branches: the MR's for a virtually contiguous
buffer, local_dma_lkey otherwise.

Fixes: b8d199451c99 ("net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Repro on SMC-Rv2 with soft-RoCE (rxe) over a veth pair between two
namespaces, one link, 64 KiB send buffers; smc.ko built from the
base-commit below, with and without the patch, on a v7.4-rc2 KASAN
kernel. smcr_buf_type=2 is set in init_net, where the rxe devices are.
A test-only knob in smc.ko fails alloc_pages() for the server's first
send buffer, so connection A gets a virtually contiguous send buffer
and connection B a physically contiguous one. The server sends 1 MiB on
A, then 1 MiB on B, in 16 KiB writes.

Unpatched, B's first RDMA write is posted with the lkey of A's MR
(recorded by test code added to smc.ko). None of its 16384 bytes reach
the peer, though send() returned 16384. The write and the CDC message
behind it both complete with IB_WC_WR_FLUSH_ERR. By reading rxe (not
measured), the requester rejects the write, puts the QP in the error
state and flushes the send queue. The link goes down and the link group
is terminated, so A is aborted too: its next send() fails with EPIPE.
Patched, both streams arrive intact and the link stays up. Both builds
also deliver both streams intact with smcr_buf_type=0, with
smcr_buf_type=1, and with smcr_buf_type=2 without the knob. No KASAN
splat in any run.
---
 net/smc/smc_tx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 0f0c6df3bf2c..2c8bcaccad83 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -393,9 +393,9 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 			sge[srcchunk].addr = conn->sndbuf_desc->is_vm ?
 				(virt_addr + src_off) : (base_addr + src_off);
 			sge[srcchunk].length = src_len;
-			if (conn->sndbuf_desc->is_vm)
-				sge[srcchunk].lkey =
-					conn->sndbuf_desc->mr[link->link_idx]->lkey;
+			sge[srcchunk].lkey = conn->sndbuf_desc->is_vm ?
+				conn->sndbuf_desc->mr[link->link_idx]->lkey :
+				link->roce_pd->local_dma_lkey;
 			num_sges++;
 
 			src_off += src_len;

---
base-commit: ead6fa9a0ab194f02a2f36d634b193e9c5f9a1c6
change-id: 20261114-b4-disp-dd99cd41-246f1595153d

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


