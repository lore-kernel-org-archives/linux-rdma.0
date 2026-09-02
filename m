Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CEA4ACC6F
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366436; cv=none; b=Zd+ThPGhDC1owCayPLsc3zeGKdMcF1g3RXUGSEuuznLotFmoMq7P6hq0um9RkEWje6Li4XMeqdNOjCnt5K/B5T2Qchmsn6pUeSBkDeAkUmUeRg4TRHzyEv2ftcnk6CeQwt8GxBIQbCJEhAiMa1GtSkwx/xpOwhOhuF+g5Y7kh54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366436; c=relaxed/simple;
	bh=MxFjTpM+yqUOV97JPhfYCmb1s3VIjF8XTEy4Zw4sUJg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OaHAFuMBHmbhwwCdHxC5YW2jy/wyuQDKAo5yn6W8mTG9iqjzngbFCEbRAjWuNyoj5CrH/zkRDA/e0ofqHB2jccPzjHPrFr3sK7iDYitov8OCODnsAQbkR1kKnUh4ZFJUWCUsbNIck+MfS6NOwmvkEgazmWCjReg/rlipZbJoIW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iApOZ3Is; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iApOZ3Is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D379B1F000E9;
	Wed,  2 Sep 2026 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366434;
	bh=SSVTMOrqe8O4DDoF+fJdKQkKZxZjR5CxU0QS0PDU6cQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iApOZ3IsRQLU4XhG/N61WoZ/1lMm0HwLvjVW6LLvCuXTt8pJfkY0/3BuHQ3aMpduB
	 3GpdOE0/r9gdYjnD3telBMe+b89m5ukHTtBoKoHNZNI3kk8u2cEqKoLXBoP5af4QpJ
	 B6uPk9n+BnaYGjLBqwRmP63V8Xkv5X+/KX1uxvbzsDN66QuOzC053uFjRjyqjrt2Tt
	 RxYeVHkYIfGwQBs4zq3b/BfUB6m/WE0pj+RRhAaVNx94GLU6gkkDFmsinjcEXsugCv
	 M7xwlKW8lKlzZddhEBu59tmk/5A7vp1OHO4XHMx3fS2uujpCePR9JzX1RvU6GY6zkb
	 NA90Jvm3cQb5g==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260901160014.2026285-1-jmoroni@google.com>
References: <20260901160014.2026285-1-jmoroni@google.com>
Subject: Re: [PATCH] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
Message-Id: <178836643149.2567489.7327807470560660676.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 12:27:11 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 01 Sep 2026 16:00:14 +0000, Jacob Moroni wrote:
> Enforce local fence for IB_WR_REG_MR to avoid spurious
> FASTREG_VALID_MKEY async events during heavy invalidation
> and registration activity.
> 
> Commit 69e8e429bca2 ("RDMA/irdma: Enforce local fence for LOCAL_INV WRs")
> was very similar, but was not sufficient to prevent all occurrences
> of these async events.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
      https://git.kernel.org/rdma/rdma/c/3fb905f07ea45b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

