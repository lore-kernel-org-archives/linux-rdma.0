Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5484BC01E;
	Wed, 22 Jul 2026 08:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710566; cv=none; b=pHcg/FHXLJOJDCTJmJQvt3ec0cY+NRcMU/jsBWoK1Mtnq9mYNT7H/mcb/H7HQx7ORqSyy3z27M1zxF/ZU85tA0xIHs0Rkxafqu4tLW3NNtNcUYIUI5+ect1HS0Hfxw1fO0tr8RdhzySEVYgYfUIoxN9bu1a5Yuh7MWeiCvxPDJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710566; c=relaxed/simple;
	bh=8FYohXCq0j2UgDUaG3RzcjaVIspzxN+jA4YwBSr75R8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AL26iHMibKnAyqB7QOCU8j5rEkgSJkZ9sD043PLer0Irh5lE+NHmWYdJK9qFe6GFXnBde14bAPBxwmfAzADeI2GMppERZCQo8IVXnoZp2SLm38mXQv+A5z1AH7eGDmkEcIOS4HrcSJWkKD7bq7jGG5uC6syqRF/wAl/pngus5B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ha3a7mAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ha3a7mAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF621F00A3A;
	Wed, 22 Jul 2026 08:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710564;
	bh=bTJMluchcrE6hHiA8pBG5EhxTL8zwcrvufjL5nSKtgo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ha3a7mATyCbt8nnftvtWRdWF06V1/wTj06F4qHPdv2JhTihq8LgwL18AiLVCYnrlk
	 R6CuiLAZ7kRSyFT4aqymfWQyCVfTq35KyCzBwW4JiKI5pPnS5ORLzV2Bkz4IDrcKgz
	 7oh0G8Ae9UXQPK817WZVWOngeXLWUxk2CH5qPc5OwE5sF3yXox7jvT9mH3UEqstYSP
	 7NlHgymHNn79Sgi2vbH9WcQXo0za6cqbz1J91tMTGbkiL4Ln2cR1Ye8LpSutYtYBUu
	 QVcyJs+5XEVrheVpogEpdKCgZ7RJSFGcbkW2zJOV2wE5uy4AP/+ZnZWrBE2V8u+wvF
	 RFfm4vB//AWsA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, brett.creeley@amd.com, andrew+netdev@lunn.ch, 
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
 pabeni@redhat.com, Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
In-Reply-To: <20260610154216.712374-1-abhijit.gangurde@amd.com>
References: <20260610154216.712374-1-abhijit.gangurde@amd.com>
Subject: Re: [for-next v4 0/5] ionic: RDMA completion timestamping support
Message-Id: <178471056142.2829425.6080653566344979344.b4-ty@kernel.org>
Date: Wed, 22 Jul 2026 04:56:01 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 10 Jun 2026 21:12:11 +0530, Abhijit Gangurde wrote:
> This series adds RDMA completion timestamp support for ionic.
> 
> It enables PHC registration for RDMA timestamp capability, exposes a PHC
> state page for safe user-space reads, maps that PHC state through RDMA
> ucontext mmap, and extends the RDMA CQE format to carry completion
> timestamps.
> 
> [...]

Applied, thanks!

[1/5] net: ionic: register PHC for rdma timestamping
      https://git.kernel.org/rdma/rdma/c/8aae47a046439b
[2/5] net: ionic: Add PHC state page for user space access
      https://git.kernel.org/rdma/rdma/c/02e643e22a4403
[3/5] RDMA/ionic: map PHC state into user space
      https://git.kernel.org/rdma/rdma/c/7462d18889bf5d
[4/5] RDMA/ionic: add completion timestamp to CQE format
      https://git.kernel.org/rdma/rdma/c/8ba049504671fe
[5/5] RDMA/mlx5: move mlx5 clock info to common struct ib_uverbs_clock_info
      https://git.kernel.org/rdma/rdma/c/63d6c2d10c15ba

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

