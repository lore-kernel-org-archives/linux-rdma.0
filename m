Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083107;
	b=I+L+N8wnA+40HFKEp/4YKSmPeGiFJdhNi1Wg7dZGgnuapKci0LZOza8vaLug0gzGCTlz
	 DcjDuD5HynCC9s4DChEBzTV1JXjo6p5+TULRTURGMMMch5+vBqXTf8kuYpEJtYSjtqzr1
	 Uikg8RVW7c/NHT2WRTiw95PVrS1vA70ygYFwr0kNfIBj8lfXr5z2Jl+9of1IlyhZHvQoA
	 1ep7ZJswq1BhhYcEJtKHgOlKSfnSWsAEPqLpfCO2/4a6Ae6zxsae37lfMXb7f+oz4/t2M
	 tWWWIxQhDgEfpsPWUXn26wjSPpP/xLGlPZbsvZRCCoUKzhtLYeRlguiVBCYx3KeSTVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083107;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=eb0Hq2eNoT1JEMioQTthbP3bvHX2O+Kvmz2eMPOKw14=;
	b=zoZXB9o8b22Yx8oVzvccZhMZr2JLVAyLu2Un37/7UzBWssET0jz2yfNDuvplrCmulTBb
	 tHdHzBB7Y195j0T26bFc5lgaSq1TvTY4xJ4mi9gEvyk6nlevZtPdBEWyQdAGAfZkHaL/b
	 53sRt5wYRoHT0fJJicZbsi9jgGp2+w1ECcWwXR1I1mGzRksrCL2586feY0EOvlfnkrmcT
	 p0KZ7VwtzZryKNp4QvEFv8Ti3/jI+B6wzKu+rUHUDCiXyQc5kWw9U+yTuXJNu+NiCDrCK
	 uv1bkrVHAeKMgCP4nMInhmWaeIZnNWHSDIZs4uUh3XooULA/KHrWuxnByFQ85nUoEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J2YdzBxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8024C606D81F;
	Sat,  7 Nov 2026 20:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J2YdzBxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4C91F008A3;
	Sat,  7 Nov 2026 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083107;
	bh=eb0Hq2eNoT1JEMioQTthbP3bvHX2O+Kvmz2eMPOKw14=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=J2YdzBxAvkVUd8/S9zlWI6CL2P83YvgQboPi4TSsTfPFN9hxj//yDezwu7R8rrrMc
	 mj0CQWKyCjIbUx/qMeJI8hTUdamy1g3ChrdwsbIxO0/wcYJJgvIV6MUTZWZCLXLMuu
	 aXE8NUdQzsEdQwdhiWTmL75mgv9v01pReDvLnc9ncXHQe/tQgXgH9Uu9EA6BVYbI2/
	 mMWRu26nEQpSpIAncZ9A+dVWySGYu4OjL7wjiKj05PkMgN17iOMqVZ3Jyka0nEeBUV
	 KECCL3NnSft4I7CoEgLLkKt3Xo/1x+34KlTRcXX+kn5RhsjkVfpbbTUI2meLKkLLfo
	 Qhc7K/yq+TacA==
Subject: Re: [PATCH rdma-next 20/23] RDMA/mlx5: Clamp log_max_* shifts in QP
 and WQ limit checks
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:05 +0000
Message-ID: <179408310595.994134.12854233732790224193@kernel.org>
In-Reply-To: <20261103163949.1554-21-yishaih@nvidia.com>
References: <20261103163949.1554-21-yishaih@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says each limit is computed from "an 8-bit
  log_max_* FW capability".

--

RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks

This commit replaces several open-coded 1 << MLX5_CAP_GEN(...) limit
calculations in drivers/infiniband/hw/mlx5/qp.c with
MLX5_CAP_GEN_LOGSZ_U32(). This avoids an undefined shift when a NIC
reports a log_max_* capability of 31 or more. The affected checks are in
set_rq_size(), calc_sq_size(), set_user_buf_size(), create_dci(),
create_user_qp(), validate_rd_atomic() and set_user_rq_size().

> Several QP and WQ size checks in qp.c compute their limit as
> 1 << cap, where cap is an 8-bit log_max_* FW capability. An untrusted
> NIC can report 31 or more, which makes the shift undefined.

[Severity: Low]
This isn't a bug, but is "an 8-bit log_max_* FW capability" accurate for
all the caps this patch touches?

In struct mlx5_ifc_cmd_hca_cap_bits in include/linux/mlx5/mlx5_ifc.h,
only log_max_qp_sz is 8 bits wide:

	u8         log_max_qp_sz[0x8];

The rd_atomic caps used by validate_rd_atomic() are 6 bits wide:

	u8         log_max_ra_req_dc[0x6];
	u8         log_max_ra_res_dc[0x6];
	u8         log_max_ra_req_qp[0x6];
	u8         log_max_ra_res_qp[0x6];

The cap used by set_user_rq_size() is 5 bits wide, so its maximum value
is exactly 31:

	u8         log_max_wq_sz[0x5];

The main point still holds, since every one of these fields can reach 31
and the shift can be undefined.

Could the wording be changed to something like "a log_max_* FW capability
of up to 8 bits"?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
