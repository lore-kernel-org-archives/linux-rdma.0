Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E453546E2
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 18:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620843; cv=none; b=s+rYUl2RolX8lN6CNub2q/Jq1T/Dr00aSB9OypRoLrml4Mvt3qhty29LYJ0hi/zS99j37kZUxciBjNbRe5PU9pYUMGk0m6P3W1Pr3jQPmJkFL6SdqcFcVnvpB/0GNbQsOhs/vdvGZ5VgtdqBsOxfCm9nveVLmE0QExLDr2duIbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620843; c=relaxed/simple;
	bh=N7xxpLCDtvkY5KrTLNkVCZEgbhxqnazj4mfPy8Cklns=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dRMbjBjJL8j2d/MyGLe+UBpblFv9yKlUxX4AnUEIPCO7h16U9LiQcn5SH/oszwS4n1gvPAVSlcyg9W3GY7s1/lsvDmqMjKTCDye4EFt0xvsCRE9E1Ro5P/G/oC/bZJ5QUpsuhCPQLoMQSSNu75dKFav142JgE5hK8wOB3yc3qGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wlez07gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wlez07gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E51F000FF;
	Mon, 28 Sep 2026 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620841;
	bh=CumnertMJq7l7M2gfIqmVf5W37IwJ9+GEJ6yVI1/u1I=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=Wlez07guOOvke4tqqslZ/CwdwAnQeC3y5/5ebx/6JljLHqvHTlVYX4pnXGvgTPiVQ
	 Tblr6OSLeMoAenZEGKw6/nEtDTU/uMCoH9xp8x2bMX8Y1it8US04kGFfb9NQ1werBA
	 CwI1aGVnlEVy2qKbhuX5wrw8H4Q2Muzu7MuTAv6rB/7kO4MPWnmGT56/SLiM+pqPgG
	 Pz/hPvu1qQCJRrXiZctWv42AjE+N+/GzCov/h7i3aT9rWxUBmqWR2TiumOWa0lhfQo
	 pb2vV0BD0umU1/mGgh8G8GSy30tVmKZ8ptLqcsyqPEpyrQIdc8dktsM/fSmGzKVppH
	 1u6LPhikHq8IA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260919100848.2442-1-lirongqing@baidu.com>
References: <20260919100848.2442-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mlx5: Restore mr->pi_mr after temporary
 stack-local assignment
Message-Id: <179062083904.3937767.17612040683390790738.b4-ty@kernel.org>
Date: Mon, 28 Sep 2026 14:40:39 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 19 Sep 2026 18:08:48 +0800, lirongqing wrote:
> In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
> optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
> so set_pi_umr_wr can read it during this call. The pointer is never
> restored, so after the function returns mr->pi_mr dangles at a freed stack
> frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
> remapping reads the stale pointer and dereferences it.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
      https://git.kernel.org/rdma/rdma/c/9728effe43d8fc

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

