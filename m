Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795609332;
	b=R98iqDOR4b6FEklwQnIln9ZO18QXFSlALkpUNRYpVvODtV1inw4dtd2D/N7wuIaBqytn
	 KqlSi4nMynLKfoM6h0+G+Fohf8mKjn9KgI5GiiFGvV0kHf0rWdMWi8Hgeu/9DhKaZD47Y
	 3h25vIExX6t2AtvmlG2H6xtfABNWhawCDsqPNOwUhoYcOz/KZ0enFyzuovJEDLADZPdLf
	 Tb5eAdmseyqy0SizGvZNt5CdGFuHUARlAKtIBIy+sSC+X3bNaT6ShIPxgnqycmsmV70CC
	 0UffBmbd0aGX+Q/eB8uc3ABtS9qbzxmXS99JXg0DT+rPjuGYDRzh3/8MhCx/wb2qEng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609332;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=plD5DGsLLNUSzhUEvx//2Hg9CMxEI6UfZA8JvxMWMb0=;
	b=RHBTaKoRIxpWjO8igbzMYMqjYayKi5XdBnaQyUNv3CXvAAkS6yDS7sc8Jnj2ogAtMOca
	 awJJkqYosoAuBUVH58z0J7f3x/nCONqWTw7EAAGU3Tr4/lVqOXW+/9rIYQy9srlkhSrVZ
	 9MrfIlSDfcOIkQf4PzV/qY1bWDQxEXU3Gsle2hMtJD3EG7nO9M4m9rnmZ0aScqczX75pN
	 6Lqz/1rtwGPJfzr//957lQIH5CSCl3TPy2HApjhkwVi5G6JGTl02TRVurRISiASVmtZRG
	 EAHgVBEqCRpPCNPSMinTRvKqJIGNlpXTtbqA1cz3lVLsae7mpUuxAK/b1Ob6vwCew3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOM6KNYE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C33606A33E
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 12:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOM6KNYE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EF51F000C4;
	Wed, 25 Nov 2026 12:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795609331;
	bh=plD5DGsLLNUSzhUEvx//2Hg9CMxEI6UfZA8JvxMWMb0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=NOM6KNYE33nBJhguGAkBEmT7/0QQm10LIHWY/nK0VmLWtE28FZAwkTurEPlkS8f3R
	 BF2oAnp+Q3L0VLTWj7jUmvYJomzNfFgvtKG6XOZDK4y0QHcXWEHTzvMuqmY++62n0e
	 E2Mn0TDUQXjrC8zhkCmXtBX7hQ5hHwbAl4VkkLOvDMsXmj39toPfLICXxbNiQRlIGj
	 ESF7dnfGr82I/IyFnDgKcqZadErlZyQmNigyR5j8PftiuKsVxN+t91IGk0jfg/f9Um
	 7xDV9M7MTQJTH/vTAWHN7XksofoHVGRR3EI8LZ76NmOWGQY82Vg9HHglq7p2ciOHIp
	 jzE90jWx22/bA==
From: Leon Romanovsky <leon@kernel.org>
To: bharat@chelsio.com, jgg@ziepe.ca, dledford@redhat.com, 
 larrystevenwise@gmail.com, Wanhui Fu <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123040458.1880180-1-fuwh1120@163.com>
References: <20261123040458.1880180-1-fuwh1120@163.com>
Subject: Re: [PATCH v2] infiniband: cxgb4: Add cleanup on failure path in
 c4iw_init_module()
Message-Id: <179560932862.1208987.5526626773090506781.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 07:22:08 -0500
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


On Mon, 23 Nov 2026 12:04:58 +0800, Wanhui Fu wrote:
> Add c4iw_cm_term() and debugfs_remove_recursive() if reg_workq is
> not allocated successfully to release memory.

Applied, thanks!

[1/1] infiniband: cxgb4: Add cleanup on failure path in c4iw_init_module()
      https://git.kernel.org/rdma/rdma/c/bd37bd5f363037

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

