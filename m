Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DDF3DD86C
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567231; cv=none; b=q6ilvTxM8IcdEyObTuO8SIXy0aSnTBt/FzZIr7FZKmDLwKUqhL8lWPXjzrxwRzGNik3JiOTPdKeBGcjefjIrWZuKEa8+Zc4q3OMPaHqtx9UJaeo8wmqpigtGbS0k5Cae1glfX3CJ+FetEguNEjPgT6ON2K2dbV980HrI1SpmD2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567231; c=relaxed/simple;
	bh=zCVW2IYo8PGZoSGY31blwJ6D1vzdZza57sAWSwUPRm0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Iq8cxfQRNF7I8piapFZCdtYf9obmk0so34pW53DVYe99KUaYOcH/4grOt4ePaQ+wxvjGG357Pkejcj7RxYqITJEm4Lvwny0GahjytzElLIfnlpiDG/bgkKBbny+vPa/SeshiM2pGHX5Jn6bY407td+rqHpUxC1y5Wh/SqacRzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C68aykEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C68aykEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6461B1F000FF;
	Wed, 16 Sep 2026 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567229;
	bh=zCVW2IYo8PGZoSGY31blwJ6D1vzdZza57sAWSwUPRm0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C68aykEGMCafcm+5Tfjq3LqS2W4XPm0Dg1Cs/Fn6FnuEvUicIIDjJdordDkqx/6OR
	 AYGLr1z+nSNFsj4AYZTBD0IDBDQgLMDZwoQiuqxVk5d5Dee0DDtod29PpjA/hOUhv4
	 UaMfpiliU9V/2Mth61bcIyyWNHLNeP0v4RVr+9LVQvIQa39NsWgKztMgdRtc2Ukq2o
	 cla9/pkgXlRnkRtnyCwX3fWUjNErG73SObE6r5S1O1XGJRPUAq9j/Ani8mPtU3jt2S
	 m0YdQCB87I8rtNH18hZeKZ9caB6hz0IHey2keFfnEHChqvLJYrE2/BKmEBRnu9/x/D
	 H6AvNPGx6usaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 4/5] RDMA/mana_ib: Make kernel CQ arming
 robust
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916134835.2380971-5-kotaranov@linux.microsoft.com>
References: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
 <20260916134835.2380971-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 14:00:28 +0000
Message-Id: <20260916140029.6461B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Track CQ polling credits across owner-bit wraps and serialize arming
> with polling under cq_lock. Check the relevant owner bits before
> advancing an outstanding arm, and update the hardware consumer position
> when polling exhausts its credits.
>=20
> Expose the allocated CQ capacity to the core. Pull the explicit-index
> GDMA doorbell helper and its declaration forward here because CQ arming
> is its first consumer; ordinary GDMA doorbells retain their zero client
> offset. RC-specific PSN doorbell use is introduced later.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916134835.2380=
971-1-kotaranov@linux.microsoft.com?part=3D4

