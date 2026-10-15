Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B4C53D0C5;
	Thu, 15 Oct 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078652; cv=none; b=HuHgbP9ZyESSbEXctenRds0Gz0ZO+N+72AELsSnc6XdqclntIncbVc3iP25RtV9us2J66Q3a24p1u91kErlxqc5s9wmg1kPYko9fogUpzclys4pVu49JbVVljmfKq7rM3r1mkQyVqt+hfra0k2b25ls2TUY3xs3cdLB0InfriVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078652; c=relaxed/simple;
	bh=zJFnMO5aEPQbkNeReQgzTu1ISriPMZG1XKCnKG0S6/Q=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SqvL2ejNF+4vOB8wVeJsfiZxkaJpGX1/AZHJlgS4NJ/xNF5+yhB1/DX4d1YlPzKcJlhE1vPLORPqmhADrmtox+SxN/pd5ZC7PBlX/LsA6Anc9Ae89rpOOBsA0DN1q1n/Tzu5Y1ACWgscHxCSgWcp4wJDLutLtAesQVHAvt0RL/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMhpgi1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMhpgi1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFD21F000C4;
	Thu, 15 Oct 2026 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792078632;
	bh=v9HA8npk3DDBxyDBQw3osB7GUwG6sfJNWfam+mOhkFs=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=ZMhpgi1YgLurlMY4mTMlnw87TiDoM3rcXkLF2d+4FZ3nAPAR579wCv+06wzRMpJ/5
	 YXX2AM4zRDpO1u9J9zXwiv1Y0xYuGlIkh78eHfoxe2bHiyU1M5YlwtYguuNnKBlYzE
	 bm5p2oY5ESEBwo5tSr8pLMrKEMCWruFBUEYb1QaVhE8vXvLwLm2HqAbnGFCdXHEQzl
	 Ggq6wtYcsrojCL0Oac1Ji/XZZjqm86Mg8DW4m0cjFhAHFwZyP62ifd6X+nEYJWnMAu
	 W8bMukOMperzAfliIPevIuWqfYwTP7V+HtSM+2Ui/prBDvmjwuJwyCN9MnM6571s+A
	 bxvu8e2m7NZ4w==
From: Leon Romanovsky <leon@kernel.org>
To: yishaih@nvidia.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
In-Reply-To: <20261014121344.100048-1-praveen.kannoju@oracle.com>
References: <20261014121344.100048-1-praveen.kannoju@oracle.com>
Subject: Re: [PATCH] IB/mlx4: Avoid requeueing executing CM timeout work
Message-Id: <179207862986.254651.2841817114239793003.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 11:37:09 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 14 Oct 2026 12:13:44 +0000, Praveen Kumar Kannoju wrote:
> id->scheduled_delete is set by schedule_delayed() itself.  It is used
> in two cases after the RTU timeout support was added:
> 
> * A new id_map_entry is created, and a 60-second RTU timeout is
>   scheduled.
> * DREQ or REJ is received for an existing entry, and the normal
>   30-second teardown timeout is scheduled or adjusted.
> 
> [...]

Applied, thanks!

[1/1] IB/mlx4: Avoid requeueing executing CM timeout work
      https://git.kernel.org/rdma/rdma/c/9bcf45bfcaf83a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

