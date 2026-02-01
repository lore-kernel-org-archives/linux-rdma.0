Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11160220F2C;
	Sun,  1 Feb 2026 13:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769953468; cv=none; b=tao6YygB2Eow7ZLBh+KBpGy3VbwPG7u+FBsFG9DIWY3HxG2p6LvICZ83oAzv1kWZoVc/M5h5WKMaBYXBlw49Mu5zpTCWOdpyk8+q2CjPUfWG8AiHVvvzaINiWcrlwv6NxwdAIVJeZrSFlejUQbGVx/p58+CVQilkj6N1y/tSSCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769953468; c=relaxed/simple;
	bh=iX0Wpy+C2uu4hAGwB5wLM6IaqNU3J1ElwyuRx/OJTYY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ncODf1fVKO76kyKi+PRmWGmBvTII4Kmf23Hk8bGCygttMlOqcFJNiFcJF8GCq3eeJsrrlCUBML1KMGp7awLwTXCYPOWNMv+Kb2N1/26GCnw9FaH96N3+weyuRB9TRMc4DZzw/o2KFovhxWaLUEkNSIsK0fen7h5IfPjucQJbD+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUooHzRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUooHzRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483B9C19425;
	Sun,  1 Feb 2026 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769953467;
	bh=iX0Wpy+C2uu4hAGwB5wLM6IaqNU3J1ElwyuRx/OJTYY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JUooHzRpzlDltlJM6c2unFs9vEQ4AIEymWhhykae+4fzvDRyA4lzONn+EUQ1nMiBo
	 OdEc5wAgq//pCwk2nrLCu0JF3IgCQiakaUIrduabW74MPjUJ6r3UYZ3TiLejEzjDXb
	 E4QV5M3FSXIeZP6GeJG8X5/UxRmIRNBPcwVAa4G6n9BN3hWBi8Spe8WDYJehS9UIAI
	 cJAFdD1XsPDHjHUtRObFcIMbFsM/o7w3aVaear7egQIb7wdd79RWIpC/i+RrpEWAG7
	 dliPgOJPKcaTWaN6ulWU4XxomLAsO0gRpjjbXwRGjUnsVGXXgry1WMfrLE0XVfY6P+
	 wnZJr+lNpGF4w==
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>, 
 Konstantin Taranov <kotaranov@microsoft.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260128-get-maintainers-fix-v1-1-fc5e58ce9f02@nvidia.com>
References: <20260128-get-maintainers-fix-v1-1-fc5e58ce9f02@nvidia.com>
Subject: Re: [PATCH rdma-next] MAINTAINERS: Drop RDMA files from Hyper-V
 section
Message-Id: <176995346474.83171.17339165461770494871.b4-ty@kernel.org>
Date: Sun, 01 Feb 2026 08:44:24 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Wed, 28 Jan 2026 11:55:25 +0200, Leon Romanovsky wrote:
> MAINTAINERS entries are organized by subsystem ownership, and the RDMA
> files belong under drivers/infiniband. Remove the overly broad mana_ib
> entries from the Hyper-V section, and instead add the Hyper-V mailing list
> to CC on mana_ib patches.
> 
> This makes get_maintainer.pl behave more sensibly when running it on
> mana_ib patches.
> 
> [...]

Applied, thanks!

[1/1] MAINTAINERS: Drop RDMA files from Hyper-V section
      https://git.kernel.org/rdma/rdma/c/e5b0cfa32b1c3e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

