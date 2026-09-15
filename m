Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA8F4A49B1;
	Tue, 15 Sep 2026 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472687; cv=none; b=iBeoNNeqMPCYbzOVN0Nc1tD5ynU24pl6M60xAaPuWJhRybIoHTBSk8NuZy2shmTO/Wek0FXJDZYsa6xpmAfsXxWh4h9Eed2+mjiopPN2XDq0lpP1gZOwIxsdRaH3wEsznsRWoINYO5kP0WH3/jK9TUzBUcM+MyiN8fuSaxbWOeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472687; c=relaxed/simple;
	bh=GvhpuUbC0L03A+cxBQNJFpAw3lYVurMJDVoMIPwYJ9s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AGHv9yr1md0G9+hr38w+6OH2LAzfM5L5L9EQ+sBFd8DNFQa/Z1hUbP6ex8J8YSLM1tXXZuK1Adjcz+NhIn8yY2gmGD/wAYi+Wm4hoivebRR4QF8rVbXYTlmrwRKq3IZVK+1D7NjHk7ccsYLpooc//y4ORmkehYSazoHsXCZaju0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMBs/2sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMBs/2sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66FA1F00893;
	Tue, 15 Sep 2026 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472686;
	bh=y4QTAEullyvf1LwAhwtL5n0UdicfZrJiGsKbYB+xjJc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UMBs/2szWVBjw9Fb36ddkHoDU4L6bzOm/Lkatf+6OSeZfdZJXOZgR/y/6gOc9QarF
	 PGzBtHIm5ipIbLYJMOwyEssKZUBmZskpN+iWeA7IaexZn0FqDTz+yckaSdu3c8Q/hL
	 MVw3W5Z3IYPnpUugbWRDkO0G7160ZppeshHYBIagwBPphHhwj5421skgDufPjcmUH1
	 XSxTd2P6Y7nVdAOi+csKqoZCkzNN35oOXZKdLGlbtvPmpr70T3MCrO9V1MipjMZyPR
	 MNXb6b0dn0vbNwLiYipBOpafOdSWrBPyTKAb5BJRMJhQSRwO3ueHRs2dvBCAFSdSOA
	 xE0yIU+fAqy+Q==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Long Li <longli@kernel.org>
Cc: weh@microsoft.com, kotaranov@microsoft.com, linux-rdma@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260915043121.10370-1-longli@kernel.org>
References: <20260915043121.10370-1-longli@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: hand over MANA RDMA driver to Wei Hu
Message-Id: <178947268361.1248043.8254467416222689342.b4-ty@kernel.org>
Date: Tue, 15 Sep 2026 07:44:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 14 Sep 2026 21:31:21 -0700, Long Li wrote:
> Wei Hu takes over maintainership of the Microsoft MANA RDMA driver.

Applied, thanks!

[1/1] MAINTAINERS: hand over MANA RDMA driver to Wei Hu
      https://git.kernel.org/rdma/rdma/c/18922a5387b65d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

