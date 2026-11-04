Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793803504;
	b=sBdvr8cp4uxMNbAPo3ZYy9SCNVWcjsOdTNK8VP20ZJBchDJv4GWl6acvZzEFvPmsMBDm
	 xaTn87vKqiN8b1+RyHtgShSxNFL2hbynCvC2Ilsf2iXfxaYu8i+RImE7KxiAW+CM6LhHq
	 wV2WsJVbQZiX57O8TjbbLL2582LpAe2n7yej5hY1nEApA98nGaCA67yeTjK+BNYkWHP8t
	 LCcT1peScom10MzX8FceHQ16cDjWrdnc0eLe1A8Zpwig5dDTT+x4SeJ2qZgma7MhA8Agn
	 qs1Mqb+D5OhxvCHzcUYw3XXJhGRlT+Fj6rgINuymkKC+y8SG1IAw7lsQBx9DCLyYhTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793803504;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=jt0wcpXwWTYdwU/q+nbZ8GdIGbIj8h/H1Vb3JV+TNZs=;
	b=F3j930qin1nV10H883tqAkMVtKYGdWqjoYOSjjARbcv6rhNoMy9rJEZo6HmOOUMSl68a
	 R2xPtOWLCGKOwPTJ1iQ4tVxhkd7UYdqLlsScXMzppwIU4WNKSKEOyvL1aecFj/Jb42B3V
	 BHzk2Gff2HkhUlzPTw3WhzU1Q6xHX9Q77aXrFFF+C+cFI+Fdv7VDR/1ahx/41akKWGdjg
	 whNtxr16Y0hrW+T9UrZbpcB4p/gE0LqaxvWiK7BZn65yn8KMBYY6QPAG5wu/zt6xWIhqk
	 FV9efaMln0G0M0VViwe2qoKYq/mok1C3flYQHX7UlYXxJkSdxM/rXJdk8Tcbr5VFuMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nHTRUNh9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6AD606A335;
	Wed,  4 Nov 2026 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nHTRUNh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40451F000C1;
	Wed,  4 Nov 2026 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793803504;
	bh=jt0wcpXwWTYdwU/q+nbZ8GdIGbIj8h/H1Vb3JV+TNZs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nHTRUNh97C6VCInkv///KPAlUQwsu534MTakZqThEUMbwlxIuZBm8nRG47WFISf4q
	 acAyMRzIT5rCwIwUoB2QOcsb408auuIEccFhHy9YZylkQbTOn3UT3NJp4WKfOWZCuE
	 teunsJ28Bz/vBVv+Ayu1xLR9btNhvk7i5lIqI0ulJMQv/nSggD+dGnzBfg2Ix0HxWP
	 WiQWPKRjmMy5gacri56zeBFT35Q+jkkt0+QJ8IPEXgiEmmmhHs4HXs4arUIBsAANgU
	 0ae0niCJZUixH7w9nzc1WG9OAZOiUrNzKR47nZt8iyoGgf4sdo2SSFtFQff3firNwA
	 nritGu+hwc5Ig==
From: Leon Romanovsky <leon@kernel.org>
To: "Md.Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <179378222423.73361.3247716499619173751@jaeyeong.cc>
References: <179378222423.73361.3247716499619173751@jaeyeong.cc>
Subject: Re: [PATCH] RDMA/rtrs: Register client event handler after
 capability check
Message-Id: <179380350157.1760491.10198913127942404743.b4-ty@kernel.org>
Date: Wed, 04 Nov 2026 09:45:01 -0500
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
X-Mailer: b4 0.15-dev-18f8f


On Wed, 04 Nov 2026 08:50:33 +0000, Jaeyeong Lee wrote:
> rtrs_clt_ib_dev_init() registers dev->event_handler before checking
> IB_DEVICE_MEM_MGT_EXTENSIONS. If the device does not provide that
> capability, init returns -ENOTSUPP and rtrs_ib_dev_find_or_add() frees
> dev through out_free_pd without calling the deinit callback. The embedded
> event handler therefore remains on the IB device's list after its storage
> has been freed.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rtrs: Register client event handler after capability check
      https://git.kernel.org/rdma/rdma/c/90d95fbc1bcc84

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

