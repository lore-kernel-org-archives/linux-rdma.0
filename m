Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604293;
	b=zUOSUlVOJiWJ3IBcDVw63SusZE4c3EVB1TwNj/BeMXdvGfRi7NGVYUZmdmWFTxDOE0H3
	 RTbGLop32R6Qe6qFhrFcPraE/llB42OnL5lIe7mU63Shm5eK1cEEOM/I8VDxErhx9b7tI
	 4Zjxek12MnVT0CrrqGvXfmLC01E76fIbXjn0jHWKI5ISxJx8Yttefs9xrc6ltUvMJUM4v
	 IrVT9+HGbClYSe6YLpFmZ8Bn681rbZqIdsBX0lro2/NCV8Ctw6m3mrcbjBlrmu/YAZjVQ
	 YC3NuYVtDMlJP0KoVgbRlKzugW5N6KhtCXnpbPOKj5UkK48dVxN5KYDoBSS12En12dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ZpL07KDDvB0JLojCSM2iYx41Asq0nHhWJ0VD/dVjgwU=;
	b=Ac7R4rBKQUrNp4h8oFjv12aWQnPo74XRJ/nfdxaRHk5qkN5cn7o93U9lg26DdqBTwe4l
	 nL54mcgQDnc3OlqkE6pM/sH95CbMswjB2y0aA3QDSWEr98rz2aaw4D/Me0w9YyOVVL0ue
	 lQX4vaPrDg133KP6u4Um+zvDFOiX3LLLLlW7ZOghEYIN04OfpNPR4nRCshQK+aWqrLOj7
	 9dzV92Jir2rQr26AskfYTLYb7NaMukZ78fjjScH0fIBHRjbTmb/AUghJss0DzfUVRqMOe
	 JzMSQF4S1oN/qOf1UVFH5U/iBQw8LtLDYHbWXbz9d4coyHjbgjmncJHlKgpu7sSexXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=mMiOgPrg;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32791606A31B
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 17:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32791606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=mMiOgPrg
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91b9e758c50so1271756d6.1
        for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 10:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1792604291; x=1793209091; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZpL07KDDvB0JLojCSM2iYx41Asq0nHhWJ0VD/dVjgwU=;
        b=mMiOgPrgNzqKNXmYt8A83QEFWXZOMSxa18d4faFbG7kl3lGzDx/C71M0pWmnWIYuzg
         a7Zpc+eHncuWDIJKhjdz7xlpwBKCm8lXGEFOUio2lhgwW/pIL9sSGkHErWdyttr3f5eY
         wXSAKCMLO6SXGO/F8kNtreUlCIonTxXIyxoESqR4EGuLg3Sh9IwCu/gh+PGClITYNQHe
         sB05LRiQ3IYBrl8jlDVADHq04tWSHo4X2PTxCQ5BMPHomjDt9lkDAgkMbdGqNE3umb/a
         BeVC77pIT/PXcxLzhyj6oLfgdBHBJG4XtAXZawY9Ui9dxU8L2MX8H6W6NuquZPuLbiST
         cyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604291; x=1793209091;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZpL07KDDvB0JLojCSM2iYx41Asq0nHhWJ0VD/dVjgwU=;
        b=bncs+/4uk+aSNUgYuaFRFLZt8vxqna7o8FKQ/miXukS3xU44dY+h+Z1XjbBksj8/sl
         Y7eBd9kv2di7p7AGDunDpMnnxoPEWg/AX0KW0FPRNCTCSkBDQdP3Sy5nncv0drwRdY6R
         dz1DSWbLLEC/Ayg/geQHhal3zyPvGwpcVLH6X9KDSmxkRGiL6yRU7IINiWVRx18y9wEm
         Rw5nFtQzjeWlpzkllAM+lWNqRtkGEizBJKPsOzqPSNrPePzMWzI4kuj6x7icxdSUuD0E
         uVlwAqSTEoNO01acDgnZDH8jvS5wE66f/E4/MJV2BwpFMA3b7GNdJapjiRnVnhxuLXt0
         bGAQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJn7YClCMngXws4jXwrM8wQKE3KRzm/9JJRzrDmBNatvj8IUVIl5qOJa59geX+cK8bELHNqgzr7IUO@vger.kernel.org
X-Gm-Message-State: AFq9FYJxNgDCuEYKuIhhtxv4Xc3vYj10Azjbl1BVUj17z7MOTptiu4Gf
	ltBDy27mj4EdOprJvHaf5akU80D2vPnup6ZSWF37LqFdUA2nHn3BiOQUQ4/9ZVJAETo=
X-Gm-Gg: AYBFou16T9QRd9Kp4NALlpYcz8huSR/s/uSCLVbavpnwmxm0oWF/RVSoWxcFB6LanEA
	t0qVmhIJznp05GcEaZxPjqMR4BlOI6SrrNDYWTnYjgGv33BOutn4k/74mOfibC9kgWv4bRcnf+K
	bb4LXWGibUbiT13um51UbcOpJTyyykDwUPo9u6/zUOwBErfkQa5anu/luko2XWPcAn3Wch1Vcmt
	j7Eto39wz2Fsn6StlAWbzPkvWpFcWvvQ3Jh+EGWRocd5Mz83FFswrH49H5RZgOYPT2KJ9A4YF/f
	W8kYMrLoXETPGpqFzB6aY3hWD9wXjZwawHHJClQH3/VSzLkGSEPDfBBk33JTN+u+w3mP+lexB/+
	fVidfkq5a9lxCLRR3BAtm9egooNM7bNuDswczavgq8dCiIofZPHijVt9BTNnz+cRbLxoPfQ2wQY
	2RWe6lsXOkB+7CHKW1M0OwY1WGPELfh7dZHmdW1Af9ZEDp1Q6iQ7mzpVgjXYDA1er18kyNbI6G8
	fBB+pAkBhKlPSpjmO4/b2pEeVYZAivffHsFYXU3D8qi3v9EjBOmMbjGwz1ERfAxknABvzZo1Rh2
	KNZUKAmjQOLHkBmB4g==
X-Received: by 2002:ad4:5d6c:0:b0:914:40f4:d4b9 with SMTP id 6a1803df08f44-91c23247957mr871416d6.12.1792604290972;
        Wed, 21 Oct 2026 10:38:10 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c18d79a36sm15125286d6.44.2026.10.21.10.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:38:07 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 21 Oct 2026 17:37:24 +0000
Subject: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
X-B4-Tracking: v=1; b=H4sIAFP42GoC/3WNQQ7CIBBFr9LM2omFYEm8inExwCgYxAaoadL07
 oKuXb6Xn/c3KJwDFzgPG2R+hxJeqYE4DGA9pTtjcI1BjnISoxRoFD7jemKsPjM5dphoDlgqxYj
 ajSSU1ZNWDlpiznwL6zd/gcQVrj9ZFvNgW3u4zwwVRpMpWd9Vx+PfE9j3DzT0O9m2AAAA
X-Change-ID: 20261021-b4-mlx5e-threaded-napi-stall-7d0a14c7674d
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Lunn <andrew+netdev@lunn.ch>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1792604274; l=3889;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=qElMGrxeAGeukURkquwi/PR2v1Qn9tNPTt6tEdR0tHI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QC0vkVXx9j9CX12TOZHH20weU7r3Ab2olSeV8e7W0srpTDnyOKmO9p1mltiRKVxjHlIzAgkO0aH
 zT4FoaFoKKgQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With threaded NAPI an mlx5e channel can stop receiving when a burst of
traffic ends. It stays dead for minutes on an idle machine, while the
connections hashed to it time out.

When mlx5e_napi_poll() has more to do, it checks that it runs on a CPU of
its interrupt's affinity mask. If it does not, it takes the affinity to
have been changed: it completes the NAPI after at most budget - 1 packets
and arms the CQs, so that the next interrupt moves the poll to the new CPU.

A NAPI thread runs wherever the scheduler puts it, so with threaded NAPI a
busy queue takes this path at nearly every poll. That costs an interrupt
for every 64 packets. Worse, it counts on an interrupt for the CQEs that
are still in the CQ when it is armed, and none comes: the next event is
raised by the next new completion. While packets keep arriving this goes
unnoticed. When a flood stops, what is in the CQ stays there, and is worked
off one poll of 64 packets per new arrival. If the RQ has run dry as well,
arrivals are dropped (rx_out_of_buffer) and bring no completion either.

Seen on a 50 Gbit/s port (firmware 22.47.1088) with 63 channels, threaded
NAPI and rx-usecs 64: a CPU-bound task bound to each of the 128 CPUs and
32 Gbit/s of UDP in 8 flows for 7 seconds, then both stopped. After the
second round one channel had 0 polls and 0 events for 150 seconds on an
idle machine, while TCP connections hashed to it timed out and
rx_out_of_buffer counted their SYNs. Later arrivals took it 16 polls and
1018 packets further, it stood still again for 14 seconds, and another 93
polls and 5917 packets emptied it. In a longer test 22 of 48 iperf3 runs
failed with "unable to connect stream: Connection timed out", with no ping
to the same address lost.

i40e and iavf force an interrupt at this point, and mlx5e does for XSK.
Doing that here would cure the stall and keep the interrupt per 64 packets.

Fix by going on polling when the NAPI is threaded. With that, 8 of 8
rounds leave every channel alive, ch_aff_change stays 0, rx_out_of_buffer
does not move once the flood is over, none of the 48 runs fails, and the
interrupts taken during the flood halve.

Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
I hit this while comparing threaded NAPI with softirq on two bare metal
machines.  The runs in the changelog are from a 7.3-rc5 based kernel, with
and without this change.  The patch applies to net unchanged, there I've
only compiled it.

I don't have the PRM, so "arming the CQ raises no event for the CQEs that
are already there" is what the counters showed and not something I checked
against the documentation.
---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 185105606469..3142e90e68ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -207,7 +207,14 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 				rq);
 
 	if (busy) {
-		if (likely(mlx5e_channel_no_affinity_change(c))) {
+		/* A NAPI thread runs where the scheduler puts it, which says
+		 * nothing about the affinity of the interrupt. Completing here
+		 * would leave the CQEs that are pending to the next interrupt,
+		 * and arming the CQs raises none for those, only for a new
+		 * completion.
+		 */
+		if (likely(mlx5e_channel_no_affinity_change(c)) ||
+		    test_bit(NAPI_STATE_THREADED, &napi->state)) {
 			work_done = budget;
 			goto out;
 		}

---
base-commit: abeacca61eea4f6803df4a595b656ea45c2d3249
change-id: 20261021-b4-mlx5e-threaded-napi-stall-7d0a14c7674d

