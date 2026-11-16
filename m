Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828198;
	b=1gK4xs3oGlt9w7Zk1TBWyRbffUrCFj7RyU7PEaaO14C3jJ9zIxT2s7TER+caxwVGkapm
	 h4/8wikVCrAfUIEIs+I9PPsLp3KfZPEIFbxcGzowsJ98ZN8ztgiyYX4NI9Xliakb/sFxJ
	 u3eGJQsmkB4GJ/4PHdY25KYuiDFk48uEQuyALgeen3Vwd5brvzHF7lWtNeooF9I5YDyyA
	 n+RxNmyMx+0E6/DXlvLayZ/U49xWU9AgSGLJM/d/CPo+mJtdDRGwNsSKAv+OYnBuuBwI4
	 2cyLCJ5fqKd/BHvv6LrqRaJzFbhcM/ZsofzE4mPNtI28lIniu6RjANdGshNcNkdAJoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828198;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=D2JUi7+QBgAAYJ3O8YDZlYlAorOdmrhtfQfGz28MkE4=;
	b=Chv3pWZpc7cNIFJaXzc9KqnWur8HcuWipo9pPp81418gNFSF6/EU+gq0Zrza8Ib9HiRD
	 TCjYzwzCRAE7Tor9wT5CvrSpsr/EXe4vqUPeBdTrxGLVSGN8VgSmmjfdPfufiHRuj21PD
	 V1haA62OaSNQOvC8PEuUY5gIKLy4JrnyEpETq1EhDQGyKPBhZ61CZ48KOGUfDd1Jv1DLG
	 VExY8Uslt236O7IIgj8VUeqdCq8dgu7jJCQ+34d2pMRGUaE04vvh1f7LyKtcLCPex8ZRV
	 B0a2rbqowT02/rseHZBvWJAa6bX+8Ku2Jp6NafNBg3fG5mAJi/VS8nqZUfMOWXGD8Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cXcUc8aI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243F8606A338;
	Mon, 16 Nov 2026 11:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cXcUc8aI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564041F000C4;
	Mon, 16 Nov 2026 11:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828198;
	bh=D2JUi7+QBgAAYJ3O8YDZlYlAorOdmrhtfQfGz28MkE4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cXcUc8aI6mmyyE11t4NtpOs2LYlsDkWA98/4VToyDgqq0WFdVIfMB767cYeHdTweW
	 xH2c0C0vbaoXjhRdE7Jo2UgtMQ4RJJ3IHX1GqyGyZlvm9j37UQu/6zdJeao7SgOdQE
	 bQjmLvpuixtCtWsaR+YRbLtzqdnCbK87UAzzpQVWtVJ/rV5MS2Wpe7B+lA2WaiQMSO
	 wq21lwa9fE1XDgcTkUDO3U1J4G1ROa5kKQF+t6ZbWAzX2j4Bj+VnWOS511b6t7fVaZ
	 15VmFoikbRZ0+9JEbLFPOUcswbpnpc15GyqQpxL/NzfsZD/zYflunT39ipp8lY8qye
	 JuhMROxoYiHWA==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261112023108.118187-1-zhujun2@cmss.chinamobile.com>
References: <20261112023108.118187-1-zhujun2@cmss.chinamobile.com>
Subject: Re: [PATCH] RDMA/mlx5: Return ENOMEM when allocating a MEMIC
 operation fails
Message-Id: <179482819488.1349482.5089909196004517387.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 06:23:14 -0500
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


On Thu, 12 Nov 2026 10:31:08 +0800, Zhu Jun wrote:
> When a MEMIC operation is not already mapped, map_existing_op() leaves
> err set to -ENOENT. If allocating the new operation entry then fails, the
> handler returns that stale lookup error instead of -ENOMEM.
> 
> Set err to -ENOMEM before allocating the operation entry.
> 
> OpenAI Codex assisted with analysis and patch preparation.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Return ENOMEM when allocating a MEMIC operation fails
      https://git.kernel.org/rdma/rdma/c/94d14d008d5570

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

