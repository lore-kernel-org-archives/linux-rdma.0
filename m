Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104515;
	b=MSfHInNPaD6I0r11rJ7EQxPd7urYtf9ktFvDa1NpZtLg5y0dEISfzIbdle1H5cOobxe6
	 0euc/Wdv9BYoMXqqx85r9cA0uX1aI5O3jTBMwkn+9GBvCOETw6XzyuCVrf2A0g2/GxC7b
	 rmWGW21Bv5vdM4UdaBxXxo+StdNnxzEeHNSmdNZzLg8I/v6NdqGho67FKoHwRP1G+qNua
	 Wa75HA68Q+DrkSIzvcNh6aIScXEUPtYZeOpAiwtbVk21PPx9q3dcoQjBrDI+rCo7AHjhT
	 MFRA4OPUMei8LBZb1RiPnyvNBQDk1ahSf4an7zxvxJrKaDpb6n5pxq6arLGEPQJe18w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bZfjBB+NvI1E2Soa/17thc1NgrU0Uw+IcpLMdQOiwS4=;
	b=cMbVyfiFQ2ptG09lN6XIk2JJGuXDRvk1Edlmq6UGP2x+FuysRaGEtX/RLE4o90E8M6Mw
	 XtcpNcRCJvT+UOhtK3zU0jx1aJ6ZNXWbdAgob7pHoSftUKr7glDj7ihdyWJjWucyrqgpo
	 zcBAEQ9h2/nnwoNv5e/2axr/T8UCWBhpVkwdYVHwtYakw3FaAh+K/+G/412TlBKRtzZ8E
	 kk1aqWJT+382i7tIMgHOVszIbaBg7dbC42mpNf83+FMc5zrWvxs/RIV1NXtFSSM27w7qL
	 cOpiQKaOS6xXyxyDTSwaSGhKyry6rpqP1yC+oDX7OGs8Nv3EnkGkvyZAPKATBW0/0SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nNuRkuX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FFC606A326;
	Thu, 19 Nov 2026 16:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nNuRkuX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEFA1F000C4;
	Thu, 19 Nov 2026 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104514;
	bh=bZfjBB+NvI1E2Soa/17thc1NgrU0Uw+IcpLMdQOiwS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNuRkuX51N5XiRgXUvS6KHv4gd9qFf+Uf5fJi9cZJ3U3fgkogv3awgA1TDbA0Tjdk
	 efWw6KMXDi3i8XekPuqVyddrUnjcExDDQ5XPfAuEeijPI09TMbP2QkYsEpJKTCvQV0
	 PfTQkQE7nWE3nAEWAh0GlnKHf/x49fnPsx/k1jPvzKhaMaeMSct5oJlleJ8BtvyTth
	 I/HCGzxRTv2y50fJ+gc9H0iKDdHfVh9mnLaGy2Rt5MuvkTGF7c4aPAzD9m1syZgknJ
	 0cdFih1yBVezqNq/GJ2OE/6Py4KhXk5bbaT1rrxIq23JYc4YxUxSr1TzjgYLmCROmv
	 P8g4EwhpVUMBw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	leon@kernel.org,
	jgg@ziepe.ca,
	kaishen@linux.alibaba.com,
	linux-rdma@vger.kernel.org,
	Cheng Xu <chengyou@linux.alibaba.com>
Subject: Re: [PATCH 6.1.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Thu, 19 Nov 2026 11:08:03 -0500
Message-ID: <2026-11-19-1-daily-reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118032858.92963-1-chengyou@linux.alibaba.com>
References: <20261118032858.92963-1-chengyou@linux.alibaba.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
