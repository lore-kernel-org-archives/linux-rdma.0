Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D70234EF04;
	Thu, 13 Aug 2026 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611353; cv=none; b=s6wdOIMFAXl2+YAKEnZ9dW3rXBws4sddJMMh+PdToWl8CqC9kAzaCEJGPirMyRyD85AnmjNMxs7uz6OutflBHGY58vn492Md328Ve5Hs+sk6IAsVakzWXYhfKKS8nKQWsMarvD/Dnh4SIgaIH1AAc/auYhQODjTUnbZCMM1I3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611353; c=relaxed/simple;
	bh=iVnuLWyTuZ7qYRk+UNV/PQ9F6QLC8B2odlYe1nYFztI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gVeLz/PLU5W5mNNNxDahrS/jy4dcd8zmiKL/pIgZFx+d/iaWJv9sdyiwOUIb3Uaz0VYxYpMHCK5tnoMwYmv5+RbrceR39x3DkowUykGl1jW14M8KddqYaycHy9sahQbbQB0YivHVq9pqWCz26UNXjkth6JdS/WK/OC4VIJ0Cgko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYb9sqAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYb9sqAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E6F1F00A3F;
	Thu, 13 Aug 2026 08:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611351;
	bh=7H/z3WW7JPiZQnbboKrWcO7wnpZrvxJyywY10TKA+uM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iYb9sqAppViGJqqEX7GoiGOHNAqovAxuqGBZWk0d9ZcCZA2kLesTpLGNUY6CQxXnB
	 6jBTnhUniQA9v6UGPA9hGXPSSMiLvqQy2ast/lgUR4i2K8AEqpiaASZOIix5pwGm28
	 F8NP5yNxZFx7rtdN2SjMMWjdp3pDB//pJ5K08TEHP/+uJ6x2spNZ+xlGu3rrxSx/92
	 Iae0CwRgO9T41tzzkYioFo+gsymCuHDUYiMicgOJ6QzubtwsYWtlhKWeUvt8CXByxj
	 rXjH5LAueNXf5fhmJElLXeDc+WNBH75SdtZn8ZtM6IXNoVBOToi/qTHcYJfiSbrDMI
	 QXt66cNOHIrBQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Serhat Kumral <serhatkumral1@gmail.com>
Cc: Sean Hefty <shefty@nvidia.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260806201358.147478-1-serhatkumral1@gmail.com>
References: <20260806201358.147478-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/ucma: Allow path records to exactly fit the
 output buffer
Message-Id: <178661134856.73091.4924894012699624590.b4-ty@kernel.org>
Date: Thu, 13 Aug 2026 04:55:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 06 Aug 2026 23:13:58 +0300, Serhat Kumral wrote:
> ucma_query_path() emits a path record only when the remaining output
> buffer is strictly larger than struct ib_path_rec_data. A buffer sized
> exactly for the response header and N complete records therefore gets
> only N - 1 records, while resp->num_paths still advertises N. A caller
> sizing its buffer for a single record gets a header claiming one path
> and no path data at all.
> 
> [...]

Applied, thanks!

[1/1] RDMA/ucma: Allow path records to exactly fit the output buffer
      https://git.kernel.org/rdma/rdma/c/8827f0c17f50f1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

