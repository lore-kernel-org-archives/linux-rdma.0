Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402215;
	b=OrDH/ibPccXw1TbO2KvVpGn9bXLlHx0/uy6kjBkZQKL0y7ZRs8YxiUoC6sNbOCvtlzZK
	 yDCHPaCutTl62ITCcNOi/FuqaKdQvjWylEDFB0F44inNCfzN/UKv+efkZxaCOruOTdcA3
	 MKtViulgtD8H1brCusqvHthTmINTIEOS564v+hgZcdpyqknu8nD4+V61HtFaMXsIS8vVM
	 DdGyByvnr01ZYHZF6e6rZnntBDQsUN0K4d65DfjdyKF2vvg/txaRxi1vtJwQC1Gj0oqdl
	 3wxVA8RAkJdnSTZNjVwl8fHvZl66tMMxV5AmyT3G6h0cjGqP8LnsUYxhGJbXdSK99AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402215;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=6YmO+MoEE0ce5P3MUBMcliy9K3KCnXGyVw8iCLp6D8w=;
	b=EuB2EVt/qwl2J1MxxIrrgFq25fEbSXeFBmoD8a7YlgoZcL5HEUv3A0ZQfH2VmaunlExU
	 2yYIBASLRpMEIxRl6ZQ2uaZY0e9uxQ0qbQAhHxByWJ/mNDPghbUaOMPLAX8T8zXV688Cu
	 1zUFXK9/lwOgfsUmnN1Kee63AI9hsIEMSJZfyKUG93fJthvw0WV+LaW4C2idDueuYbPrq
	 ioNi+GBh7Kdiz/+RhwhVtSDZwgCEvp7Ehn2kQmstmw9qxeOgo9/ryktjrbRSKEgUjaf8L
	 hxhr5dUblluKegYUNLp0abwdqdcUx6TNbL92y1J8wCsifndygwC44Nqe+GIv4FNmUyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8lCtOCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD96606A31C;
	Wed, 11 Nov 2026 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8lCtOCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E99C1F00A05;
	Wed, 11 Nov 2026 13:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402215;
	bh=6YmO+MoEE0ce5P3MUBMcliy9K3KCnXGyVw8iCLp6D8w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=M8lCtOCMs+ipL0JNSRuUd+G2YyETYvnrZkrFcUvQU3ffGQ4gcqm2xLyUM+Daf21Vv
	 P5ZU684C7BmWCOu6KmkawX0sMKHpPlW7no1JkweVEizdrHMtsqWix/lIOZ3uYGGMsr
	 jY58lWscPa5ZcbczPddGp+cE76N+7FQnlMVcit47V0FR/CqqPxHMd1C3lgjb/fSClE
	 KMnm1XFsAeH8oEvWxktoUEhT0d6BZtCbD/TqqajxL2h0zYyvPdBXdsxRVWHaTECj/+
	 hypVk9HG7x4HESRjiN0ZXxCrf6bGAU20jDv8TwMm1slMpaVDy6O6JaP9Rw/WhRj/HE
	 HS0U8OImF1DOg==
From: Leon Romanovsky <leon@kernel.org>
To: Chengyu Liu <lui2012qwq@gmail.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261105042922.14733-1-lui2012qwq@gmail.com>
References: <20261105042922.14733-1-lui2012qwq@gmail.com>
Subject: Re: [PATCH v3] RDMA/ipoib: cancel the AH reaper synchronously on
 teardown
Message-Id: <179440221192.582485.13243946413799722882.b4-ty@kernel.org>
Date: Wed, 11 Nov 2026 08:03:31 -0500
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


On Thu, 05 Nov 2026 12:29:22 +0800, Chengyu Liu wrote:
> ipoib_stop_ah_reaper() uses cancel_delayed_work(), which cannot stop a
> callback that is already running.  ipoib_reap_ah() re-arms itself after
> an unlocked test_bit(IPOIB_STOP_REAPER) check, so a callback that has
> passed the check but has not re-armed yet still queues the delayed work
> after the "stop":
> 
>   CPU0 (reaper)                     CPU1 (stop/teardown)
>   test_bit(STOP_REAPER) == 0
>                                     set_bit(STOP_REAPER)
>                                     cancel_delayed_work()  (no-op)
>                                     ... destroy_workqueue(priv->wq)
>   queue_delayed_work(priv->wq, ...)  <- delayed work sits on the timer
> 
> [...]

Applied, thanks!

[1/1] RDMA/ipoib: cancel the AH reaper synchronously on teardown
      https://git.kernel.org/rdma/rdma/c/36d1eca030a37b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

