Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6D33F1052
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 05:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790661351; cv=none; b=A6lw6CtMzmCi4EQM3cvzVb8WhobML69tFIRO5TA2qKiPZ8a974/29uSpycBZs8GN5jM94I6L0yXh6X9YjAT8AEskA7Ajv41DHhzBg9uFtosM1YeU1gQHpK8BjJYrGRt7NowGOd/5ORT8cDJMZ4Qc7Pfn4rMiXR6pWZzIONBfic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790661351; c=relaxed/simple;
	bh=HG5S70xbE5XYrm5P93YWSLsARKkUX0Gz3zzYIJ94NGg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DMZLtO7Hw0a6pQy1/mD+NQzIMdPHymN0lKpS2iD/+dC8vbP5W1RfJ98LuCdSjTm0eEuF1tTvgsvVIyluFk19WBCV/gi30wrsoPNgXRZy1BNryCZyE7Bp2+l98DcC2Hj2T6kfHJJ0OG81E6HPo+FTUrrt3ZqNJ0JYVxsfxFkm/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBfuKp/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBfuKp/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5705F1F000FF;
	Tue, 29 Sep 2026 05:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790661349;
	bh=6pHHzViNRqYCjnDvja1F/6BFtgGvzPPRWRhhQEA5vko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XBfuKp/U3knWgcVSUFEamZDs1OWzaE+mSL6pUHBumWPc4lKQMUWe6aLHRJXmvc0R/
	 YoavIjrJ9oEq9xDanSeUh1tCG6tPITCo57Bv9Z/g0McVazsaEekc201vWQDX7GwihT
	 QAE0Hv1zYvobk9favftt4Y9DWdKmZEKpFz3BBZFY7GXqWQSpzzrvKTKdiosQ2bVWvG
	 WBPUJcB5SvZGFBIcDpH8dviRc8PsMzr+oBic02zm7gIDy9x2K4WDdeobqqIoPUBtlR
	 O+m6XImdQZobACPh0mJJEe8QckcuMeE3AqDcXrkSQoo6t2aV8kR2BLXykuMlZzwBia
	 162+0bhnMvqIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Reject a zero queue_depth in the
 connection response
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260929054222.1576877-1-yhlee@isslab.korea.ac.kr>
References: <20260929054222.1576877-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 05:55:48 +0000
Message-Id: <20260929055549.5705F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rtrs_rdma_conn_established() stores the queue_depth the server advertises
> in its cid 0 connection response without checking that it is usable.  The
> only bound it ever had was an upper one, dropped in commit 0e8558476faf
> ("RDMA/rtrs: Avoid Wtautological-constant-out-of-range-compare") because
> it cannot fail for a u16; a lower bound was never there.  A server that
> reports zero therefore leaves clt_path->queue_depth at 0, and setting up
> the first I/O connection trips
>=20
> 	if (WARN_ON(!clt_path->queue_depth))
>=20
> in create_con_cq_qp().  The connect is aborted, but the peer has already
> tainted the kernel, and on a kernel built with panic_on_warn it panics
> outright -- all from one field in the response to a connect.
>=20
> The rbufs array is sized from the same value one statement earlier, so it
> [ ... ]
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: https://lore.kernel.org/linux-rdma/CA+0ovCg_sG8gaZXXj9zmOrpxRt=3D=
8+-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929054222.1576=
877-1-yhlee@isslab.korea.ac.kr?part=3D1

