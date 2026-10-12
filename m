Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E36469841
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791813620; cv=none; b=a/aBkWu7hqKu6MqrzMGQa6eykZgCQyvzjED8WhachBZsDlKPlv/jytcG/atx3/Rn6LsU0hyxnTalgbr/4QhuZc3Xk7Y1u8/ALIhmmTPUgCVjxlZKWe7SPcdReeTCDPbNLk1zuTcBgJcu6Bpx5l1f4U3GjVZ83gMvCVkc3PabWQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791813620; c=relaxed/simple;
	bh=lybBDz2SpHePzzzZmq7fiP0RaO6y9tZ4NzKbx+PCrs0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ACr3opPyU7kbc2WSpKqYEhyIJOaX5vilP4xy60LQX4hgL1uHswynXD6JPnfnCFAGXn5TAquTC5AzqmIeHGgFvlA3qDgeL0OnrF2gG3jXtDGDddJJRBoIdGCoeoIl0zvhmCtmdynFyZk8b3Cu6/6lNJrMFWynz09pwkBs1/ESSRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lx91niCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lx91niCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4C21F0089B;
	Mon, 12 Oct 2026 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813619;
	bh=JyyzTsENnbCO7otmRslSsCr9fi12S1aPt+8lVEkaKHw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Lx91niCH6VR8iXYi7eZ2cA8Si072nf2ZwzdIrglpGZ+uNWyymgbpEAVQSGEk8s54j
	 xWhfZ9dWEyU3sgYG9dH0w8QW8Z5pjtToMlHjbjrqtcVUJWy5AHsv0D6M67En4O7CI6
	 kKPlm453OAzijL1UZeoS7G25dwlqEpGBAv34SDBBcoOlqaBUZFKE9eibx9JHPjYQ+4
	 yxJc53t289mzmE9pNXMYRO3hFE+VIeuECmg5mOpPCDzBr6poGxVcxqsZo76fPXrJG/
	 wS9kachSP0pARjH8mZPWKb5cI4XU9P9/j/D8RZES2b4iJg3/17k+mNtc0l6PJrq97r
	 vTbs49ZjD/YYA==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010194832.2415477-1-jmoroni@google.com>
References: <20261010194832.2415477-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE
 alloc
Message-Id: <179181361666.1582644.4442046994950994956.b4-ty@kernel.org>
Date: Mon, 12 Oct 2026 10:00:16 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 10 Oct 2026 19:48:32 +0000, Jacob Moroni wrote:
> The original logic would attempt to allocate PBLEs, then would
> check whether the region was contiguous _after_, and if so,
> would free the PBLEs and use a direct mapping instead.
> 
> These unnecessary temporary PBLE allocations can technically
> fail (PBLEs are a finite resource), which can cause an MR
> registration failure even if the region is contiguous and
> should have succeeded.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Check MR contiguity before PBLE alloc
      https://git.kernel.org/rdma/rdma/c/023b4b6ea490b3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

