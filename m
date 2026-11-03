Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707678;
	b=3FDlR857AXypwqHbOzaw5nTHWDwUh36w6bqTGs+3oaggom8eXxiLBzVipmOh6Nx4JiJ/
	 +ffzmjq0RDQIMo8B0kOw68lRrs2msT5u/DCQU3q02cFj3rUo8vFggASRZTKvRy2Fhjxsc
	 6kg7dODX0lBuS7MrswRTD4gbgNUsX53CKFCWUGAA3/Vh9Fy3zbLNoIBfzw7JokICgfBpa
	 wkMD66aQJlRFwhXws9AKfyklLcKXbEAKMdhBK5JTc8/jz3ua+AylvEWli816wpiKhOWhu
	 x9jCo1wQAyAcHQgus9/pyWB7AHacP8VvZIyPAsedqeSibPgVHeSoeIQ0NlZ8SjY5e0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707678;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=XNPQI2Y8CP9QfMlYzoEokvLB7Rkkm/Px7tfgJf/37UA=;
	b=DjSRlf3JhGTUwlQDlJxBiIzzS6cw+RpHz5k09LiYOwiiQOtxMf2nSuOB3QgzpxFnMxZ/
	 lK3wEK0cIiWMnhOrp9a4Uyvn/pSSlO+/19m2ZjbIHdxnXEwcSb13sQSXrnFoGIe2By8k0
	 4sZ8lDrwSuHggzVYr0xrdzpdMpWrMaBv+Q/WETxE6Zxf2CWYb0k/xx3dteJV8JQuojt7g
	 5IfAbSh4s79G4TesBnYFniwp7reb5qF+e5Ors4kBhRpiXVMuI1R3zAX12LUFx6/AsORI4
	 uCFM18Lt5+vDbOU3N2QpKqLhbfCwZSFOCPPZVRADl26/RWHis+biSuRWdTiYIOdPS7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAwPpSKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F3A606D801
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAwPpSKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D941F00A18;
	Tue,  3 Nov 2026 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793707677;
	bh=XNPQI2Y8CP9QfMlYzoEokvLB7Rkkm/Px7tfgJf/37UA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EAwPpSKFz/k78fZ6CwRicya21V4BN6AFtSV2tDbyfGGOWIzseGQKpdDx1/7202Tjh
	 lWZFAtgdWYZsirm6G8SGUua4sUKuMpkpvmp9sOpgc7FoWSvEI65zAED8YAY/m9uEaY
	 do5qJ+F7b5F520ahixi5YStd3nb+C+FgeJ4efMnSuErkLe70bt7w7q0CyO/kjnjqtZ
	 h4mCRNS1QI7hfTuMC2dx070Kl6zwrbF9qc0GgGWx62VrIFiwKAbMBJ7KPd55L930cL
	 /EmzutrVHKi6BIJmf3KvRPH2CuAS5v9v/RHiyLwlGF9xsifWes9EC45MB4yQtAEbka
	 O254eU0+d4P8A==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com
In-Reply-To: <20261028113404.33289-1-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
Subject: Re: [PATCH for-rc 0/7] RDMA/bnxt_re: Bug fixes for RCFW completion
 handling and verbs
Message-Id: <179370767461.1719581.5785976495065285630.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 07:07:54 -0500
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


On Wed, 28 Oct 2026 04:33:57 -0700, Selvin Xavier wrote:
> This series contains a set of fixes for the bnxt_re driver.
> 
> Patches 1-4 harden the RCFW command path: they clear a stale response
> pointer when a wait ends, honor a completion that races with a wait
> timeout, ignore CQ error notifications that are not command completions,
> and drop completions for cookies with no outstanding command.
> 
> [...]

Applied, thanks!

[1/7] RDMA/bnxt_re: Clear stale RCFW resp pointer when wait ends
      https://git.kernel.org/rdma/rdma/c/756cfa339d1b11
[2/7] RDMA/bnxt_re: Honor a completion that races with a wait timeout
      https://git.kernel.org/rdma/rdma/c/5ea08e2dcf736a
[3/7] RDMA/bnxt_re: Do not treat CQ error notification as a command completion
      https://git.kernel.org/rdma/rdma/c/02df984377d143
[4/7] RDMA/bnxt_re: Drop RCFW completions for cookies with no outstanding command
      https://git.kernel.org/rdma/rdma/c/fbe33b99673d25
[5/7] RDMA/bnxt_re: Reset cqe pointer each poll_cq iteration
      https://git.kernel.org/rdma/rdma/c/f7da2c5c60017d
[6/7] RDMA/bnxt_re: Remove shared page mmap entry on alloc_ucontext failure
      https://git.kernel.org/rdma/rdma/c/6be33e5725ee7f
[7/7] RDMA/bnxt_re: Bound FRMR page list by max_num_sg
      https://git.kernel.org/rdma/rdma/c/ac39883b95322d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

