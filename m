Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1105476FD;
	Tue, 13 Oct 2026 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922369; cv=none; b=XXozII/1ga+UgKoX9gMVJhmjiKLLosfEttCEZJuUTbyi70/5YBS8gSywRYDmCw+8xWH+enZUIeiY8LmEXHaTVjQ5WqJFjPKKvRYtW0S2VRTlUdbVbl0kdOyp4bHWOKDrX4rdK/letDVQSU7pKeGGiRCAynIkFe1IDBuolBj6A70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922369; c=relaxed/simple;
	bh=Lnl0XF0TzVvqTKPExTtZgk/B+UiY8r13RpWybMJhiPw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rtBfnY7aj16nO9aUOYjui/xUXOaUB+fHiYqlpth00GGVy/PLSW05nwLQ2+0MjtmSN9rHvjU+JRHPzlt7zdg0JTE/d0z/nee6hvYJPqBzBOPmeE0MF/Uh6E1A5bcCRAI+0w7S+GY27dvsWauH/mMa7b+6a4YqobGkr0q0QdH88As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnOYDFpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnOYDFpj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F4F6C4AF0B;
	Tue, 13 Oct 2026 20:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791922369;
	bh=Lnl0XF0TzVvqTKPExTtZgk/B+UiY8r13RpWybMJhiPw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GnOYDFpjhvSyr3njOPOq8O4vq7VeLn/PamIVQT88WkeWfJMK/H+I3U+JIzEqA3RLN
	 jS6y79JeJqKCUcrTdfzZeEYHInSCLs3lM9w5jy3Oa5q6YyIhTXOzQv4DVDNjdYgUE2
	 IvzcIshWzFv9nwBJ8VrQLZ/k9ZwbEjtXe8lONh6zrvXAWmE+Wjd6AqYzAPSfz1MiV1
	 8os/BiPWmPdUxrxIIgaLwmVeAVztzSbFcErLZYHQm+ZZsAy4OyrCpkNOMpM92K6AaY
	 br1q9ji6HPE/BLFo68C28e2O41nMkdN3yQ249hWi3dSL3hjYXuHQ0kwQrkvkaFrq0+
	 x9JWbdlW5EKcg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83121CC6B1A;
	Tue, 13 Oct 2026 20:12:49 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Tue, 13 Oct 2026 15:12:50 -0500
Subject: [PATCH net v7 3/4] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-disp-f345196c-v7-3-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
In-Reply-To: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
To: "D. Wythe" <alibuda@linux.alibaba.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, Dust Li <dust.li@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, 
 linux-kernel@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Ursula Braun <ubraun@linux.ibm.com>, linux-rdma@vger.kernel.org, 
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, 
 Wen Gu <guwen@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791922368; l=2633;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=lUNbhzoLihltUOk3ECDO1KVY6cuHiA2nFGBtBf+62Cw=;
 b=jBsmKMJF65B6v5ECU9jhYs9tNrifsJ6m5nxP3hCM8A6y28WYuNNyFQzcThBMat0T39Q/yDNFJ
 7T7FooC6YHmDPp8YBC6Ik2CWrgAoBgFK8GJzkoLXJyzuvHurRBoFaAo
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

conn->sndbuf_space can run past the send buffer. After an SMC-R link
failover, a late completion from the old link can move tx_curs_fin back,
and the next completion credits the same bytes again; across the ring
end, smc_curs_diff() credits the step back itself as more than a whole
ring, so even with a conforming peer sndbuf_space can reach three times
the buffer. The failover catch-up and SMC-D DMB merge (only the loopback
device today) also credit it from the peer's consumer cursor without a
bound. smc_tx_sendmsg() takes it as the write space, and the second
chunk of its copy writes past the send buffer.

Clamp writespace, which sizes the copy, to sndbuf_desc->len, negative
values included, so the copy stays in the send buffer.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
This keeps the copy inside the send buffer but does not undo the
over-credit, so after such a failover send() can still overwrite data in
the buffer that the peer has not received yet (by inspection; not
tested). Fixing the credit in smc_cdc_tx_handler() needs a cursor
compare that survives the u16 wrap rollover, which smc_curs_comp() does
not do, so it is left out here. A negative value maps to len, not 0,
since 0 would make the send loop spin.
---
 net/smc/smc_tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 3144b4b1fe29..58d9dfdcdf33 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -233,6 +233,14 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		/* initialize variables for 1st iteration of subsequent loop */
 		/* could be just 1 byte, even after smc_tx_wait above */
 		writespace = atomic_read(&conn->sndbuf_space);
+		/* sndbuf_space can be out of range: late completions of an
+		 * old SMC-R link credit it again after a failover, and with
+		 * SMC-D DMB merge it follows the peer's consumer cursor.
+		 * Bound writespace, which sizes the copy; a negative value
+		 * would become huge in the size_t min_t() below.
+		 */
+		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
+			writespace = conn->sndbuf_desc->len;
 		/* not more than what user space asked for */
 		copylen = min_t(size_t, send_remaining, writespace);
 		/* determine start of sndbuf */

-- 
2.56.0


