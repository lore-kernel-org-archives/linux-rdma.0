Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AFE36607F;
	Sun, 22 Mar 2026 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774203128; cv=none; b=mBeaiVvyikdInl7wZcYpkAcU5az28Cgkp9IpnTaqoATBTBRdijjkwvvylJab9cW0MYD6CcGTM9ValSTiXWqKTz6JRDzeLVGGaV5Fme5MzjAiZCFs0vs8608R1iyj35bRWZlHO0i8BuG4AAriPATrdEZ2aYci1roMAbG8jcWCtQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774203128; c=relaxed/simple;
	bh=xOndbYxRpVjnFwP18gaefNn7SXBjELpRuvWU0AEZJcc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kAMiDeN7YDowF8RtEXjYt7To7r19VVuzFpu3+amjohAmJajLJMrS4K5sDtnAEUSeWZef4TWIR4znPM0ORPCx9f4kflzSdnittT7b/yaD95TtwZK75P3RsK13a2Zvdndb5qHo1AhfoBNRxAhvpHLALJ9fuJDKhEE+B3BQh2cmXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgQ41Kmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgQ41Kmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC74EC19424;
	Sun, 22 Mar 2026 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774203127;
	bh=xOndbYxRpVjnFwP18gaefNn7SXBjELpRuvWU0AEZJcc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=lgQ41KmtB1V6zd5e/aVer5Gy38RBnqW7h0sLeCV9tTVNmsj5h2LmabOmFHugfvWE0
	 QO/rZDXhFV8wQ5BK4QD9887jkUz1+/XMim6SJkJ04hP3Ji7S8/FkgarulZ7WI2xdJP
	 VnoZ6FU6xyRZiB/9ZsJStpbcZ9+GaKg3ePX7x2bH6pVpamai1FW9j74YBTiGoSblhO
	 7cntRp+grUlrtwZmwSZQyfJeMvnZjq7I8IHriBLue8c+ws21XoPpjH+a96b4NRe/6q
	 FKx+u1axmM33+7xoaUlCaOPEoJUcWpj8eAeIwFTNmi8t8BjFQ2S+O4g/ZUDs26ugsH
	 3IT/FE6GpVYFA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Krzysztof Czurylo <krzysztof.czurylo@intel.com>, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Zhu Yanjun <zyjzyj2000@gmail.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260319-resize_cq-cqe-v1-1-b78c6efc1def@nvidia.com>
References: <20260319-resize_cq-cqe-v1-1-b78c6efc1def@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA: Properly propagate the number of CQEs
 as unsigned int
Message-Id: <177420312305.2040745.701939084442446542.b4-ty@kernel.org>
Date: Sun, 22 Mar 2026 14:12:03 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 19 Mar 2026 17:22:21 +0200, Leon Romanovsky wrote:
> Instead of checking whether the number of CQEs is negative or zero, fix the
> .resize_user_cq() declaration to use unsigned int. This better reflects the
> expected value range. The sanity check is then handled correctly in ib_uvbers.

Applied, thanks!

[1/1] RDMA: Properly propagate the number of CQEs as unsigned int
      https://git.kernel.org/rdma/rdma/c/e8b64a452d0b30

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

