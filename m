Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BDD233956;
	Sun,  6 Sep 2026 07:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788681176; cv=none; b=UwCr8QIyMU+piVLBHk0oRdAVZn80mPKvne34c2n6u41k8thje37MJlx3HGeJUN/x9oSod8pVCg7AcrJJvjtfR3BeBEuhqhiiL8j6zS11wSqz0hMzxme5P3iNDFiXkZnnNOI0HGsMuikqVS4j585OP5dSi9L8dsre8tAJpE3+5V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788681176; c=relaxed/simple;
	bh=P3qjsHRey6k6CAd1A45tqlzYNNUdQHRA64ZVUxyG6aw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gs9DeM45C7s/jtZy+in5yaVgGGbZ25Xbl9A3P4bUKVm7MOZFbkDjVYWpF7xRaKqZrUWzt2M6+6WAhxmjXLYmDRUSqbZdYQXvkkUOlRILPLuJ1bUhW8gQBD0T0DsxZ+HfeFGHtmKQ9TvpPRAp/PiBfULrqGBUAgMmn/DkJdwwxV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1259D1F00A3A;
	Sun,  6 Sep 2026 07:52:53 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Mustafa Ismail <mustafa.ismail@intel.com>, 
 Shiraz Saleem <shiraz.saleem@intel.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
References: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] RDMA/irdma: Preserve fast-registration
 IOVAs and simplify SQ posting
Message-Id: <178868117171.3930746.2340527924980038360.b4-ty@nvidia.com>
Date: Sun, 06 Sep 2026 03:52:51 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 03 Sep 2026 14:38:58 +0300, Leon Romanovsky wrote:
> Fast-registration IOVAs are u64 hardware values, but irdma passes them
> through pointer-sized types. This truncates the upper bits on 32-bit
> kernels and can program the wrong WQE base address.
> 
> Preserve the full IOVA throughout fast registration. Also remove post_sq
> controls from QP flush and fast registration because every current call
> path requests the corresponding send queue to be posted.
> 
> [...]

Applied, thanks!

[1/2] RDMA/irdma: Preserve fast-registration IOVA on 32-bit
      https://git.kernel.org/rdma/rdma/c/c470050f2a7a77
[2/2] RDMA/irdma: Remove unused post_sq arguments
      https://git.kernel.org/rdma/rdma/c/4a93466061d38f

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

