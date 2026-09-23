Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563AB3B1EC7;
	Wed, 23 Sep 2026 08:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152522; cv=none; b=tmOLrgoSfmCA4ohT9IggPtd94RA3xOE9MqYdva2OqqWgtS462YsAezjaiQPPCFwrKAcm6oLw3ryF7MjQcPKMfANoaep3LbULfuNqTrmB2eTEb/LXEju9FTaLXtSujOOjwohWQYVQk7Bsx4urdpVtxF0YEempB7IG5H8kBk3wwqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152522; c=relaxed/simple;
	bh=oDtGgCBdiS3RC9RfkN1ZeYrUnFaetez+1nncJ2VTo1o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FTnmi8Zuys81bpVIN3cKENcget+bpB2GK9vbRvz/WKDZSx2o7ioiUDc09ha8yXo9qEqjWHYpuNoAPGSsAfh+LNsDnXA4SoZJpbj6Pac2Ojb9ab5RZWBaIWREtsEpduRiVvzXiSqi+Ft7k92N0wWRm5rvXrk8EVxFzsN5qg3QaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfumYxx3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfumYxx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B721F000FF;
	Wed, 23 Sep 2026 08:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152510;
	bh=T6Ne6eqsw1loN8AooeZoLwwXfDU8uQj6Wuodb6LkCp8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kfumYxx3LBekwwh3fz8SxHxJ9OxRitvND3lEakpY7bL7dyVeRXtLu7ocg1WhaSHUt
	 amsnjw1MTVsbpsOJe3QQha9OMF3U3OCbKFOuKkxIXMD8sk5q1j/DAbyCdXo3qX6WOA
	 kvgpM9fuMh8y1Q8edy8bLuZlth9HEf9r1hxlN38YWvx0oqB63VczHjG8bU34kho+F0
	 ieCP6I+XPdzRSCuseg1jC9pHoeHZqQMG+1QLLpGsBbNMVw+b/ePVoFevO2HhjK2Ysa
	 TOndw8tMaHJpaQsvtu/Qk1eGIG/rE6J4NXNTImXR8fwivjj3uPiz+DANhHX1cvG1S6
	 suU0hc9y4OWEA==
From: Leon Romanovsky <leon@kernel.org>
To: bernard.metzler@linux.dev, Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260916184400.2093106-1-vulab@iscas.ac.cn>
References: <20260916184400.2093106-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH 7/7] RDMA/siw: Fix qp use-after-free in
 siw_get_base_qp()
Message-Id: <179015250789.3394760.13528866578642274394.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 04:35:07 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 18:44:00 +0000, Wentao Liang wrote:
> The reference taken by siw_qp_id2obj() is dropped before the address
> of the embedded ib_qp is taken from the QP.  If that reference was
> the last one the QP is freed and the pointer returned to the iwarp
> core is dangling; the core only pins the QP with iw_add_ref() after
> the call has returned.
> 
> Copy the pointer while the reference is still held.
> 
> [...]

Applied, thanks!

[7/7] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
      https://git.kernel.org/rdma/rdma/c/ef15197f81ffed

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

