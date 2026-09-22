Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C432F260C;
	Tue, 22 Sep 2026 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082914; cv=none; b=jVTOS4q8Vd/JUE9hHjN1RjazKTM8Jh4sIeawX9qQxbjfa9vl7aIDeV1jo2SX9mCun+IrlfgC+jdnaLQr/x0AA+XeqfsYUQbBP9TnCXUVPTHCcFgRYY6j4I1DDqFkKwg6KkTIA8vIBaB0jwxZ+TYuG1f28d+7D26nIULpI7J4soQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082914; c=relaxed/simple;
	bh=CWqKBopev0DtqoTGjObPQvbDogwg603nphg8euSqWN8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NwQk1VlB4lLm/FbvzBU4aGvzsrBm9DPmC9uosqozjcg857ZCKAtUi8uAMKb0T5ZjFxiqwsP2Fe+7UfDBdYJ+1OHVmJvn9vwHo8F8mpzZCgGXOAo0eSSAq+AkB7Mj8agXTtLELSedOLNQpS4j7hcOT3dPGtqAo/g+XR6/JJKuP1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gw+gsEEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gw+gsEEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DD91F000FF;
	Tue, 22 Sep 2026 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790082913;
	bh=A2GjMlZydqdG8KlmnrTtS91yqc6IaV8j4mtQvdX7USE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gw+gsEEp1ReAwh7I/Cg9V58ERQAjG1y5v1S/xRrsF7TTzdHhaC1GFUbLEPW6p7hXK
	 Al0YFgMAjgOVrulywncA3KEcuXV7JM6/2Nkc8c1h+trb5/Mh/XfX+y7S7zKR2TDSVU
	 hPGP7hc0lHM9C2DQLO1l7dMCTnqby3mrqLVxXev8FVRDNv8SWSHKoUzduaYFtHMc7x
	 g/PpS2GVYVJKe1jXATN8Dryg8orAZL7MXE3AMKXh0MnxPcatQ3D24Q6kP0k8Mt1vx+
	 7qmv2hIofOsGqaORX5Yjc9Oxdp7Ze5FpkZWkpdfSu/4j9AlNZIdi1LNs59Laa3u3wE
	 RG5jGOP5nsolA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev
In-Reply-To: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
References: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] RDMA: Use unsigned comparison in CQ
 cleanup loops
Message-Id: <179008291023.3238769.13558406499996514040.b4-ty@kernel.org>
Date: Tue, 22 Sep 2026 09:15:10 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 15 Sep 2026 18:33:27 +0300, Edward Srouji wrote:
> mlx5, mlx4, mthca and hns all sweep the CQ backwards when cleaning
> completions for a QP that is being destroyed, using the same open-coded
> loop (mlx5 shown):
> 	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0)
> Both indexes are free running u32 counters, so the comparison has to be
> done modulo 2^32. Casting each operand to int and subtracting does not
> do that: the subtraction overflows once the two indexes straddle 2^31,
> which is undefined behaviour, and a compiler that assumes signed
> overflow cannot occur is free to fold the expression into a plain signed
> comparison that is not wraparound safe.
> This is not a fix. The kernel is built with -fno-strict-overflow, so
> gcc and clang both retain the subtraction, the generated code is
> unaffected, and there is no known user-visible impact.  The casts buy
> nothing, though, and the correctness of these loops should not rest on
> a build flag. The series drops the arithmetic instead:
> 	while (prod_index != cq->mcq.cons_index) {
> 		--prod_index;
> 		...
> No functional change intended.
> 
> [...]

Applied, thanks!

[1/4] RDMA/mlx5: Use unsigned comparison in the CQ cleanup loop
      https://git.kernel.org/rdma/rdma/c/c6aa5feb521066
[2/4] RDMA/mlx4: Use unsigned comparison in the CQ cleanup loop
      https://git.kernel.org/rdma/rdma/c/c5fe428bb23edc
[3/4] RDMA/mthca: Use unsigned comparison in the CQ cleanup loop
      https://git.kernel.org/rdma/rdma/c/b934024d3aafb9
[4/4] RDMA/hns: Use unsigned comparison in the CQ cleanup loop
      https://git.kernel.org/rdma/rdma/c/ebb65190349537

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

