Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794428913;
	b=YALKlVqeR1yilXLkk9//j6ZCZUuIomJVXi6//MTAH8Ts5rt1A457HL6P61DV8ljs9oPt
	 6bKSEQVgDzfVsbepzXmbprxmmvwT75SjBrYvD5m0ZRoFrL+UpElnQ0Dbfc5lYoL+oxxGI
	 z0KjpxDj9OGmWD36yXdWXF5+LN0Dzv4dAFN8SuZm0OKA6cRJh25oIOT/lVMx7tEW+vJ5X
	 3RqzeX6n8S5+0KGlPPLerhXKdYiHvv7wrL9t/s5Pc4FW2fG8vYoZ4C5YmVk7K9W2OhmG/
	 gGMa0JDcZXWVVKcJH6bKu/TL5J15nJ8duqBOWzMHf7otx2vHBTL8ALj2IR8JYk95nUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794428913;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=66fuXiduK3IeRm3mD9KEzj6ZCYStXeHjOEc3p2JBPkg=;
	b=RtawUi1XuJyEzY0tnoRmBuKVW4h73NsyMqFTmMKiuxQ8mdMzto/I+VjV9qwofYzKzWKu
	 18A1yVZC4yIaY4iwTZjCC9ZOhzZqEbG0ScB6SK8TJHxxRnFt3YrXLgv5PJwguWRwA/j3E
	 i1WoZMZxJFpHF66FbnTWq9B9id9cjdN9gtphz7bfnkpwUMbpiq9YMLYeum0aqbbLw3uVW
	 kJbKdE2cCZB4hA396VgcTNZ1qgPC798On2A4GuVTr3SKCxL7hQxbvt8+cgNLe0o3uryPd
	 wiRFP/5JtL/fLQWxetI05ot7qai2DFavMZnaZFrNQ74H/y2gbdDQ+K4fAmCN+baUGTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSu7JKrA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90806606A31C;
	Wed, 11 Nov 2026 20:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSu7JKrA
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794428913;
	b=YNFG+6LDS0C8Eic9oiZ2dfbHzzIPt12vDf3JTU16/92RSXjCWg1JAV4+v/7+yqLDdh7M
	 +RRyBvRpY1QLPZloOnesSTKJqDfDVGP+qZPZEjxwDbSMf+AuQIygpZWv2B+KcAdWWXJMu
	 zn0EDokBp8D4crNsBPoqQ/1wVpD0QqVU69SvgZFKbfTxDk32SELAzOIK99oi7cY1JkYiw
	 90regsMKJMj+I8fSsJIA3hZ98tA/hR1IDp7SNt5S2B9/fnWN5r1l4KlxL3mKEscFnm/Po
	 LGRxGetoSRlxONaedyIi9KujjCiwb9oMWItG+cO91bq7vPE18NQF3nQLr7MMkE+sDqg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794428913;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=66fuXiduK3IeRm3mD9KEzj6ZCYStXeHjOEc3p2JBPkg=;
	b=ycSmbH21SWyg4E4zENF8tTOP/GdZ6T796ykxKstFjo4J64kxgDKmTAqdvZ+3Uzk+CiKJ
	 Mw539ncD1trLmEr40iFsc+2bCpmUm7Yvpwbgj1gzlh0O/vW1HrxlWLJqtiVpOpZgWSHjp
	 SQp9NSNz0hhrthc5CdNeAIX9OKZ0os5S51pssUKramH7LlYyVA8wUuSxuO4fU6Dj2OPxw
	 eyuZFQIiwfGXwgFzjBRFBi+6onF7wHTr+j3L2t+bk/JzlDzDvqbZqyWiL/Tuc2TslRD+S
	 TComZk87GgAxfopHgRJP+Vp/zFuAqpWcbNPkUDJJpEgkTMbzAmNmFJJ2E8m4QtRCKfQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 987571F00A05;
	Wed, 11 Nov 2026 20:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794428913;
	bh=66fuXiduK3IeRm3mD9KEzj6ZCYStXeHjOEc3p2JBPkg=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=VSu7JKrAcTjUUhdknDtyNrjQLTkAvg6wDreqhXiwqbvcIINRKZL5lKpBCyBva3ux9
	 mxXwJSgOK3n3XE0M8A6aVPt3QQ0BR1D0qFyuwFfA7jde5vYXEWZ1mO5PKDtPeHEKUm
	 jAL8g/ZwB2GadwFoaIisHyWj2b7pCzUlYPGD65gekml5ipkJwH46Y84lBOTL0JXuZc
	 h6gHehnFOij6G7i6vxVNYtzc/P5YvpORLnOebuV1JSy2xJMu8qpW2rShQhlp7T3yE+
	 JFIYnLByWcrY+6+96r62WKc3AJ2DTm+QkTYFww93CcTM1wRpk9TfvzF3kWA2dWVPfP
	 gEIyiRO9pqvVQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F16BF490E0;
	Wed, 11 Nov 2026 20:28:31 +0000 (UTC)
From: Weidong Wang via B4 Relay <devnull+weidongw.illinois.edu@kernel.org>
Date: Wed, 11 Nov 2026 14:27:28 -0600
Subject: [PATCH net] net/rds: tcp: bound the message length announced by
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
Message-Id: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
X-B4-Tracking: v=1; b=H4sIALDP9GoC/yWMQQ7CIBQFr0LeWhKgoMarGBdt+S3fBRp+NSakd
 y+2y5lMpkKoMAluqqLQl4VfuYE9KYypzzNpjo3hjDtba41Oxl+0UI46NBei9+7qOrT+XWji3/6
 6I9OCxyHlMzxpXP4XrOsGARgGNHIAAAA=
X-Change-ID: 20261110-h047-send-52025d442823
To: Allison Henderson <achender@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Zijie Zhao <zijie4@illinois.edu>, 
 Weidong Wang <weidongw@illinois.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794428911; l=3897;
 i=weidongw@illinois.edu; s=20261108; h=from:subject:message-id;
 bh=1rMOxnrBK7wy6KAVesScdDJ1MghCm+cPgQRTPaFaXQk=;
 b=VbzedWxmkJGCPF1wkXLDwAkKq6e+6vzQkgf60JbkS/QnFUdwExDzi+sEynvRmZIazgJr+hAUm
 zNPE4eTD8fdDAPomMgp9MWq9GHCrxhcxnQHdRYj14lPjYILvT/GJmto
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
limit on receive and drop the connection when a header exceeds it. That
limit has been enforced on send since v4.11; a peer running an older
kernel could still send larger messages over TCP, and such connections
are now dropped.

The issue was discovered by an AI code review agent (an LLM-based
bug-finding tool developed by Zijie Zhao and the submitter) and
confirmed by triggering it on an unmodified kernel, without error
injection, on x86_64 under QEMU: a plain TCP client in a second network
namespace connects to the rds_tcp listener (port 16385), sends one RDS
header with h_len = 0xffffffff and then 1 GiB of payload. The receiver
held about 1.1 GiB until the connection was closed; the same 1 GiB sent
as 1 MiB messages held about 60 MiB.

With this patch the connection is dropped right after the header and
nothing is held, while the 1 MiB messages are processed as before. The
RDS selftest (tools/testing/selftests/net/rds, rds_run.sh -T tcp, also
with -l 10 -c 10 -u 10) passes with the patch applied.

The reproducer, fix and changelog were drafted with AI assistance
(Claude), then reviewed and tested by the submitter.

Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Cc: stable@vger.kernel.org
Cc: Zijie Zhao <zijie4@illinois.edu>
Signed-off-by: Weidong Wang <weidongw@illinois.edu>
---
Tested on v7.4-rc1 (05441d697f7f) and on net (ae89f2724e), x86_64,
KASAN, QEMU/KVM, 3 GiB guest. Setup: rds_tcp listener in the initial
netns (10.0.0.2); a plain TCP client (no AF_RDS) in a second netns
(10.0.0.1) over a veth pair.

                   1 GiB after one header     1 GiB as 1 MiB
                   with h_len = 0xffffffff    messages (control)
  unpatched        ~1.1 GiB held until close  ~60 MiB
  patched          connection reset after     ~60 MiB, processed
                   the header, nothing held   as before

selftests/net/rds: rds_run.sh -T tcp and rds_run.sh -T tcp -l 10 -c 10
-u 10 pass on both trees with the patch. No KASAN/UBSAN reports;
checkpatch clean.

The limit is per connection; a peer with several source addresses gets
one connection per address. The reproducer is not attached (AI-found
issue, see security-bugs.rst) and can be shared on request.
---
 net/rds/tcp_recv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index ffe843ca2..29db73df8 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -213,6 +213,20 @@ static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
 			}
 		}
 
+		/*
+		 * The payload is queued on tinc until the whole message has
+		 * arrived, so a peer must not announce more than a sender is
+		 * allowed to send. Check on every pass, not only when the
+		 * header completes: the drop is asynchronous and more data
+		 * can arrive before the connection is shut down.
+		 */
+		if (!tc->t_tinc_hdr_rem &&
+		    tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE) {
+			rds_conn_path_drop(cp, false);
+			desc->error = -EPROTO;
+			goto out;
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


