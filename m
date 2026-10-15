Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D083F459AE4;
	Thu, 15 Oct 2026 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072785; cv=none; b=dzfvMfyNaQM1M1/Hm0lERs4pDxnV8SYxKT3LPUwt4hRCrbUOqYpX+xB6VT7yvV1nuLGJlHBDme4wXapVo/OeUd3/YaBA2hCEL0SlFvkdIuIFic+o1Jk4U4fSCznKD7cQTVJ/vHVp82EMko52InA1cuqKE062FjQCc7UIUc3PY/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072785; c=relaxed/simple;
	bh=+9HdNSHfLiiJzdYlgSQJsrh0WvfKNdhu1oCprw1Mq18=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=W9w4DKFHoPXMb0i328Ka005BYGt6fu8uM3HgJpNH5gBGtzhVLlgo2BGjvmI8AWQ+SiGLpX0OPaPGeZWpjJlCaNTjdJuuX64N4xsxxN5bmXEzWVJMqdVeGRE28dEcmoW4eRq2mwcrfPeTbEiXRmbnU+358d3JqL97Q/OSUTKB6BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFOQdrK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFOQdrK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C511F000C4;
	Thu, 15 Oct 2026 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072784;
	bh=JtZBjs+ch+LJKm1LnlvbsXMkOqdWgFdx8fGComAtFqA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QFOQdrK6cFuMZEBcrYntPLQAWGBRSS/rRC4ENbCJgT7GTJfOypy9I+paHIzeblhiS
	 U1m9vc/CwbkfaoS/NvO6o7qeIuWq5Wxi8OkTOLLCbF3Y37XRgT9vZ0edErcfgkVyXj
	 GOKJLZzhUHh/Bz2gN8qYQ98w//YByd+UaXYxe72WFly8zjbEW6Cp4kvv7WQzUryDJz
	 RfmFD8oAX9xuodP7wSepVkV4EB+GQ3YwPLG8ol/n9JPdKrHBhfQTi6H39jE89CHEn+
	 wVTtfgJCME4wT2pXUNILtta4D0pq6SDfRFvpHy9OsuP9FnQd0sCNCEu18jj44ROBk2
	 dnnhsWHC+d0MA==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Youngsung Ahn <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261001152426.3259522-1-ays511.kr@gmail.com>
References: <20261001152426.3259522-1-ays511.kr@gmail.com>
Subject: Re: [PATCH v2] RDMA/rxe: reject IB_WR_REG_MR from user QPs in
 rxe_reg_fast_mr()
Message-Id: <179207278185.164616.15512589953168258959.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 09:59:41 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 02 Oct 2026 00:24:26 +0900, Youngsung Ahn wrote:
> IB_WR_REG_MR is documented as kernel-only ("can not be issued by
> userspace"), but nothing enforces it.
> rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
> a QP type userspace can create, so a user QP that writes
> opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
> rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
> the ring-supplied fields:
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
      https://git.kernel.org/rdma/rdma/c/33afe9909f213d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

