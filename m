Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4C13AD1C;
	Tue, 14 Jul 2026 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046054; cv=none; b=Vr5LIiD4yxFM8XtTB1SAYWnu5dJB/6QvaAglbec3dAmBjwLU/NMzSR4bfJK8R/zrdEDio+b8dyunbHX/Llaiebx6LCQdzpF94kGnXx2ad2gacFRZ2IPRy5nIxAVelS48vKXsSTLPStU0K6M/EL4Y7GOgzOudzGrythRt+CzLNBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046054; c=relaxed/simple;
	bh=e+W3ydYo5hqo1n1JHrVTRBBxe/WDbbgTlNposaeYIic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgvWz69owq182gL1CMhT75BqYn2Oo/lYaPE4ZP6kdKbcVb9P9j0v1XXULeTkhnP1T/RcA/YSdIYBYg8/TTH5CkHAJdKEGUd2Z5hjGsMOxviceIeFzZOZNK8C1Kyd1NJVzoaH6oKrB5RHg3IBogcvJMvVYvLghdjYg+7Wv1gqjNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mVPloanl; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mVPloanl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784046043; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=L5HDedMOkOv2o1qYbYljTVZQzB0Jz5OVt0Sh6QKTHBo=;
	b=mVPloanlYZWJSONEEZCOS648Un42/XvTxr7VTNll9htZC4ARFOxm/o89ayuXcax015kt08bDjLnnRzqHXIJWQ++f5KMjBtqoKh6LJPm2Hp9GU0rQjuLJ6eu8EKda1Acp2S7DHos4+CGG/tPeCrTqM16Q8goxYUnwHkGaVbYMbLQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X75Dk4z_1784046042;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X75Dk4z_1784046042 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 00:20:43 +0800
Date: Wed, 15 Jul 2026 00:20:42 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: hexlabsecurity@proton.me, "David S. Miller" <davem@davemloft.net>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Eric Dumazet <edumazet@google.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Ursula Braun <ubraun@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Message-ID: <alZh2puH6EMlyE__@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
 <20260705-b4-disp-28a1bbca-v4-3-be089b98acc6@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705-b4-disp-28a1bbca-v4-3-be089b98acc6@proton.me>

On 2026-07-05 02:54:07, Bryam Vargas via B4 Relay wrote:
>From: Bryam Vargas <hexlabsecurity@proton.me>
>
>On the SMC-D DMB-merge (nocopy) path, smc_cdc_msg_recv_action()
>advances conn->sndbuf_space from the peer's wire-controlled consumer
>cursor via smc_curs_diff(), which can return more than sndbuf_desc->len;
>a forged cursor drives sndbuf_space past the send buffer, and over many
>CDC messages overflows the signed counter negative. smc_tx_sendmsg()
>reads it as the write space and does a wrap-around copy whose second
>chunk is not re-bounded to sndbuf_desc->len, spilling the local
>sender's outbound data past the send buffer at a peer-controlled
>length: a heap out-of-bounds write. The nearby len > sndbuf_desc->len
>test only feeds SMC_STAT_RMB_TX_SIZE_SMALL on the user length; it does
>not bound the copy.
>
>Bound the write space to sndbuf_desc->len at the consumer, treating a
>negative (sign-overflowed) value as out of range too, so the copy can
>never exceed the ring. This enforces the documented
>0 <= sndbuf_space <= sndbuf_desc->len invariant where it is race-free
>against the CDC tasklet; conforming peers are unaffected.
>
>Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
>Cc: stable@vger.kernel.org
>Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust


>---
> net/smc/smc_tx.c | 13 +++++++++++++
> 1 file changed, 13 insertions(+)
>
>diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
>index 3144b4b1fe29..5916f02060fb 100644
>--- a/net/smc/smc_tx.c
>+++ b/net/smc/smc_tx.c
>@@ -233,6 +233,19 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
> 		/* initialize variables for 1st iteration of subsequent loop */
> 		/* could be just 1 byte, even after smc_tx_wait above */
> 		writespace = atomic_read(&conn->sndbuf_space);
>+		/* sndbuf_space is advanced from the peer's wire-controlled
>+		 * consumer cursor on the SMC-D DMB-merge path; a forged cursor
>+		 * can inflate it past the send buffer, or overflow the signed
>+		 * accumulator to a negative value across many CDC messages
>+		 * (which a plain "> len" check would miss before the size_t
>+		 * cast below turns it huge).  Bound it to the send buffer in
>+		 * either case so the wrap-around write cannot run past
>+		 * sndbuf_desc->len.  This enforces the documented
>+		 * 0 <= sndbuf_space <= sndbuf_desc->len invariant at the
>+		 * producer, race-free against the CDC tasklet.
>+		 */
>+		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
>+			writespace = conn->sndbuf_desc->len;
> 		/* not more than what user space asked for */
> 		copylen = min_t(size_t, send_remaining, writespace);
> 		/* determine start of sndbuf */
>
>-- 
>2.43.0
>
