Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795664409;
	b=ogADhlYpoyKpNVBEHEnj5dp4E5xcV4TxGfCLBP7sQ5jflfZIjLOT31Ewbi/raKLdn80y
	 QWp8tTFNHXNrVY40SSTNKGTW55S7yEJHG4Dh+GRhAOXSPGTgZvKFbXcl5EBDFveLVCrEq
	 LlfEaoHH7Sw+rm6PL/oYSAfopgWBFmAGluSNuBflpebUwnDDpqK3A5vUVBbrXq2A9AX2q
	 5Ia21QSZXCpgSN0FwvnOyEE0sWtFR29M4+3M04dEWnkQ8W1QyX4j8ffsdHZZaOdsiK/lw
	 9zglHnoHVE6cRB6g6eiq7iKxeOvxsVZ1mB+rbXw88mN4g5xu7d0dSBwtVkqZv0NoBcQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664409;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xpvMK+HAR/nkjyHFb6+C+r7RwDLKhvISECG2WoJIKqQ=;
	b=SanocZDN4XPAvxaRwnoMkw7sHBbNMwBuu8MdMd0kErVnB/RV+dPfhMKFrjD4aElcWzjG
	 MZ9AkG2ZpfWMO00Wq4GHnnYGBTvCy9+OVaPilUHnZCj6EpJVCWBnINs7d4WfO9WHXP5+m
	 Yzf5xF4Iq482yCEm/vz/TQqN7Md2ci9wDO7nyKCwiStab0tNcuPgNxLcGUTegRWrnCYYU
	 f0yLr/HpjDmpC30uCyadUKllcvLt6YC/n1evP1LcdHcNcE7euiIEgbbBSJEJBxcVVfIpM
	 /mc33cOmlcpqOtJ81SR0q8rEbrPTzT6dvz6hHYhD7UbD5zuN6m039u7xD8liso7+hIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mznd2Nd6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637EE606A31E;
	Thu, 26 Nov 2026 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mznd2Nd6
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795664409;
	b=bJP/Rbf+2tO4ZG0cTcrZIVkVeUYjgDBiqG05Oshlf6uQ4rdE82+dvPnT2UqKsPjHU69m
	 C7+14k3lZC9BavouBEm2SmKbQCC/bBhZ0duuSqHwsnx3tTlJ014dusKLmrcwaH6x5iHXC
	 HtKPkIrK9pMtSpDjf+92NFGnpRkp1tzjpvHKm8/QqVFb8zee0OHrdeo+tDbtzMEjhhJ0l
	 Eb1uD7E9f3iqpOkTvfAH+T9NXS5AXKHPN8M4hmMBMTy3voFuDb6XLw43jYSQiZAuG/0zG
	 OcvXGcCL95q+9cODX0UXtomlCG/8udT/zMJXQNY9X34fFDXKOy1JIWa6W2oP1rwirDQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795664409;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xpvMK+HAR/nkjyHFb6+C+r7RwDLKhvISECG2WoJIKqQ=;
	b=oB05N1thW9Rd6vfHCLPObCTRsMOO3WUxF2/MZ+afwtIyY68DjvirhqWE7vhm7tLfOH5b
	 +ExrVDMV19W7Y8LG1+l3sDOzSmcfA+UVLTQQ5e6npLwyLgk/gNHKRCcYAFW7k1yhvIxUm
	 f7iHxJzkyvA8Avd78JjM2KlpKZnT1mSNgJSDl7Q6kIgdebVDr5tds3BoKT3M5+J27zV5k
	 UC4z7sR1/qDXBBc/Wfi7ZERT2hEKtVq3Qu4N2AH1DfoR6vGFk8qRPWbfXX4S1wcDUG8Be
	 fSDGdDNuTm3dtFRHgDodBGvPv4ACSMtQHcOf0SRXuLNBT98UB28MOplBGr14SOE0O4g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3DE221F000C0;
	Thu, 26 Nov 2026 03:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664409;
	bh=xpvMK+HAR/nkjyHFb6+C+r7RwDLKhvISECG2WoJIKqQ=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=mznd2Nd6uXPQQTbeXnBsHjPH0DIpKh5lcqAyQJ1B0E0kNaLDG+H9lNVYRywNoL7jL
	 xBDLnDLQJGYN2qNdRL10yx3EQa65lpE0LvSK/LgWRVsDL20dOLQKHE8pZQIdrDm56h
	 mc7yU/n8eDl0HClaUcvmexk5uG3OlWykbp44siRRxkem49hc+vvKztwWzzT9iTSRQ8
	 6gObaZDZE2LJSzxo5jlNf0MWkFupD/qEy5xv3tSKvlSNH6+KpeycVHq+q6t/OPyrG8
	 LU3uSYGf74WmZBV9mJ5Ew0Wddlmdcqfd44lfdYZ7sxZCbG3sktPEJ/JC1f2QaFJ+/8
	 OlrVJz2pVhviw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 976604D211;
	Thu, 26 Nov 2026 03:40:03 +0000 (UTC)
From: Weidong Wang via B4 Relay <devnull+weidongw.illinois.edu@kernel.org>
Date: Wed, 25 Nov 2026 21:40:02 -0600
Subject: [PATCH net v2] net/rds: tcp: bound the message length announced by
 the peer
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
Message-Id: <20261125-h047-send-v2-1-b29031cf6b93@illinois.edu>
X-B4-Tracking: v=1; b=H4sIABGqB2sC/02NQQ6CQAxFr0K6dgwtIMSV9zAsgClSQwYyBaIh3
 N0BXbh8Py/vr6DshRWu0QqeF1EZXAA6RdB0lXuwERsYKKYLIsami9PcKDtrsrBlNk2poASCP3p
 u5XW07uB4gvI76lw/uZn2yq51otPg38fjgof8i+NffEGDhnLKq6SwddvYm/S9uEH0zHaGctu2D
 436Eq68AAAA
X-Change-ID: 20261110-h047-send-52025d442823
To: Allison Henderson <achender@kernel.org>, 
 Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Zijie Zhao <zijie4@illinois.edu>, 
 Weidong Wang <weidongw@illinois.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795664403; l=5926;
 i=weidongw@illinois.edu; s=20261108; h=from:subject:message-id;
 bh=bSkQAfudci/H1SL4hYaSArW1+3HJjjLr5iIlEdGVrd8=;
 b=tgAYzk4sJtBiOsvxlCJhJlDpdGyhvajNWsBNw2I8vnQt8m2j6IwKlScko4M0oT2Qz0/JNE+KO
 Tyols1fJOkYCU+Ox3W4JiCL0vcQaMZmNxiOW5D7RC9DpEDpKp6W8aY1
X-Developer-Key: i=weidongw@illinois.edu; a=ed25519;
 pk=DR2S1xPEa5sELrWPfOpvUphJQ2VHC+MDc/wJavE/ifg=
X-Endpoint-Received: by B4 Relay for weidongw@illinois.edu/20261108 with
 auth_id=1449
X-Original-From: Weidong Wang <weidongw@illinois.edu>
Reply-To: weidongw@illinois.edu
Content-Transfer-Encoding: 7bit

From: Weidong Wang <weidongw@illinois.edu>

rds_tcp_data_recv() takes the payload length of an incoming message from
the peer's header and queues pskb_extract() clones of the received data
on the incoming message until that many bytes have arrived. Nothing
checks the length, so a peer that announces h_len = 0xffffffff and keeps
sending makes the receiver hold up to 4 GiB per connection. The clones
are no longer on the socket's receive queue, so they are not charged to
the socket and TCP keeps the receive window open.

Senders are limited to RDS_MAX_MSG_SIZE in rds_sendmsg(). Apply the same
limit on receive: when a header exceeds it, drop the connection once,
then consume and discard the rest of the stream until the connection is
shut down. Discarding keeps the receive queue draining, so
rds_tcp_conn_path_shutdown() can finish as soon as the peer closes
instead of waiting out its 5 second limit.

RDS_MAX_MSG_SIZE has been enforced on send since v4.11; a peer running
an older kernel could still send larger messages over TCP, and such
connections are now dropped.

The issue was discovered by an AI code review agent (an LLM-based
bug-finding tool developed by Zijie Zhao and the submitter) and
confirmed by triggering it on an unmodified kernel, without error
injection, on x86_64 under QEMU: a plain TCP client in a second network
namespace connects to the rds_tcp listener (port 16385), sends one RDS
header with h_len = 0xffffffff and then 1 GiB of payload. The receiver
held about 1.1 GiB until the connection was closed; the same 1 GiB sent
as 1 MiB messages held about 60 MiB.

With this patch the connection is dropped right after the header and
nothing is held, while the 1 MiB messages are processed as before. A
client that closes on the receiver's FIN sees the shutdown complete
within milliseconds; one that keeps sending is reset at the 5 second
limit, and what it sends until then is discarded. The RDS selftest
(tools/testing/selftests/net/rds, rds_run.sh -T tcp, also with -l 10
-c 10 -u 10) passes with the patch applied.

The reproducer, fix and changelog were drafted with AI assistance
(Claude), then reviewed and tested by the submitter.

Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Cc: stable@vger.kernel.org
Cc: Zijie Zhao <zijie4@illinois.edu>
Signed-off-by: Weidong Wang <weidongw@illinois.edu>
---
Tested on v7.4-rc1 (05441d697f7f), x86_64, KASAN, QEMU/KVM, 3 GiB
guest; net/rds/tcp_recv.c is the same in net, where the patch applies
as is. Setup: rds_tcp listener in the initial netns (10.0.0.2); a plain
TCP client (no AF_RDS) in a second netns (10.0.0.1) over a veth pair.

                   1 GiB after one header     1 GiB as 1 MiB
                   with h_len = 0xffffffff    messages (control)
  unpatched        ~1.1 GiB held until close  50-80 MiB
  v2               dropped after the header,  50-80 MiB, processed
                   nothing held               as before

This client never closes, so it is reset at the 5 s shutdown limit; v2
reads and discards what it sends until then (~460 MiB here), where v1
stopped reading and let the receive window close.

Shutdown after the drop (one oversized header and 64 KiB, the client
closes as soon as it sees the receiver's FIN), timed with kprobes:

                   rds_tcp_conn_path_shutdown()   rds_conn_path_drop()
  v1               5344 ms                        62 calls
  v2               7 ms                           3 calls

A normal close (unpatched kernel, client closes first) also makes 3
rds_conn_path_drop() calls.

selftests/net/rds: rds_run.sh -T tcp and rds_run.sh -T tcp -l 10 -c 10
-u 10 pass with the patch. No KASAN/UBSAN reports; checkpatch clean.

The limit is per connection; a peer with several source addresses gets
one connection per address. The reproducer is not attached (AI-found
issue, see security-bugs.rst) and can be shared on request.

Changes in v2:
- Drop the connection once, when the oversized header completes, then
  consume and discard the rest of the stream until it is shut down. v1
  consumed nothing after the check, so the receive queue never drained:
  rds_tcp_conn_path_shutdown() ran its whole 5 s loop and each round
  called rds_conn_path_drop() again (reported by Sashiko).
- Only the TCP receive path is bounded. The IB receive path also takes
  h_len from the peer; I will look at it separately.
- Allison's Reviewed-by is not carried over, since the patch changed.
- Link to v1: https://patch.msgid.link/20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu
---
 net/rds/tcp_recv.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index ffe843ca219c..4ca25b9d25d4 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -210,9 +210,29 @@ static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
 					be32_to_cpu(tinc->ti_inc.i_hdr.h_len);
 				tinc->ti_inc.i_rx_lat_trace[RDS_MSG_RX_START] =
 					local_clock();
+				/*
+				 * The payload is queued on tinc until the
+				 * whole message has arrived, so a peer must
+				 * not announce more than a sender is allowed
+				 * to send.
+				 */
+				if (tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE)
+					rds_conn_path_drop(cp, false);
 			}
 		}
 
+		/*
+		 * After an oversized header the connection is being dropped:
+		 * consume and discard the rest of the stream until it is shut
+		 * down, so that the receive queue drains and the shutdown is
+		 * not held up.
+		 */
+		if (!tc->t_tinc_hdr_rem &&
+		    tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE) {
+			left = 0;
+			break;
+		}
+
 		if (left && tc->t_tinc_data_rem) {
 			to_copy = min(tc->t_tinc_data_rem, left);
 

---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261110-h047-send-52025d442823

Best regards,
--  
Weidong Wang <weidongw@illinois.edu>


