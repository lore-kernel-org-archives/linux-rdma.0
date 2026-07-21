Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC80340A6B;
	Tue, 21 Jul 2026 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640609; cv=none; b=UlfolcFKD/X8q5U6poxFmi5ym03RBH8nAqKI4hDMAcoUx2L4ZUX51QiM5clcYKjHBny/gPItTWCJkBXNwqpudHJmY9Ig8MLh3Rgcj9SkVwf+Da9vWMWoh9XtV4GrZf+n1zj6sILPYjxd2Aad1lqEgQI27f5NvRr8cxftEFUq+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640609; c=relaxed/simple;
	bh=bC+irATfsjw8gblexq1ymceWN06dghdE6Zs/XpdCrsw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qOQTME2HvHvH4scj1fTKtllC8cuuhXbaqj65+QXcHJx69Ij43pZmCgXvMgKPumK6OyhU0I1oyIzNF6+o15IZCoPLZPpSXHPNRNwCMdV4Uajw5/ISuilILe8EG6z0rzfD+WurYDAP6i5FPBj3IEkMZLMjd6K818DZ4v2e9nxZbXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bikk1/xS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bikk1/xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491FC1F000E9;
	Tue, 21 Jul 2026 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784640607;
	bh=1qt2xJLUKjMiN0AnoKiRd/w4v3HqmwrDt05aUPcp00c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=bikk1/xSTDWNA1da89nAXXXGiluFnABiRcwkj75dDTlXviGzLeh/Z2m5z1v+Baqow
	 NPoy/d2V3RrOdo+gB+xwuBPYJhsdhmeiFznG34ZmH2Gut1SnxHY5QIPBuCfqKAQzri
	 o5Ptez/w8JIjv7X/cJdelW3UQ8CzYUbfQpLTT1OI6ITwUu1tz4etBkx6pmweCzQ4xF
	 dmb2O16OShAiJqAK7qeyKTYHdyFlUAqQC5qxsygJipAwB+mgEqTuoJI5K/f0eXgdvm
	 vvJynE0wmKFff3jnJs25zP5FIsd8fv6q0Y3I5SYyOdiLEiq1yjaRRNaF1n/1NnY/2I
	 AyBtZYCjADz4g==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, 
 Michael Guralnik <michaelgur@nvidia.com>, 
 Edward Srouji <edwards@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, 
 Edward Adam Davis <eadavis@qq.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260720114918.70323-1-pengpeng@iscas.ac.cn>
References: <20260720114918.70323-1-pengpeng@iscas.ac.cn>
Subject: Re: [PATCH v2] RDMA/nldev: validate dynamic counter attribute
 length
Message-Id: <178464060499.2209333.12407448512827293402.b4-ty@kernel.org>
Date: Tue, 21 Jul 2026 09:30:04 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 20 Jul 2026 19:49:18 +0800, Pengpeng Hou wrote:
> RDMA_NLDEV_ATTR_STAT_HWCOUNTERS is a nested attribute whose children are
> consumed directly with nla_get_u32(). The top-level policy validates only
> the container, so it does not establish the fixed shape of each child.
> 
> Require every child payload to be exactly one u32 before reading it.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/nldev: validate dynamic counter attribute length
      https://git.kernel.org/rdma/rdma/c/74f49255492a62

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

