Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730034D3B2;
	Wed,  9 Sep 2026 03:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925971; cv=none; b=O6XhZ5LoCJZe7fVJ6nCjzsHOgYH6bAxIm0DOdfiG8whepJSRmc0tbwt0b4NGxs7F2BKZIAIpVAXK/QHLz1JwyhrbYIZyufqj76iCMR8qynb7yr7jNLUTGSoQsBoBwv3ZYe7SxntVSjo53SVMWWlZk8ym2vXJ4eKsX2E7aTVtNBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925971; c=relaxed/simple;
	bh=XCJ8TWSB8VRpkriHoACFAKkBUqsIVFe2pUbCLKkQWEs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RUU+Y5pJU4LKxrsHlPY5SwRFIBf4U+7+oPFFitAjKqDXfV1Qy37mFxOPHv2/R+QpdpkzQRNalEvBLDntRhlF5zsj0QhjeIDdgPX7OPEhNHHqtu9cy1+DGy/esDLT6OLCsYEj+XtDXBq1l4FhAlgYvofhIdL+rT4hAfEKVcO3MNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EaFBDhqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EaFBDhqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA30E1F00A3D;
	Wed,  9 Sep 2026 03:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788925969;
	bh=XCJ8TWSB8VRpkriHoACFAKkBUqsIVFe2pUbCLKkQWEs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EaFBDhqdUChS960/LyN32R5xP3iNmr91u79XkAuyYv9k1CJWzTc2FeyNtlzGZplwt
	 P+zF9mSlr1s1kiA5lYHcIWcZSb23hFO/16Y+lUXNBWuudgb+YXSqeYmIkSu35a6vkM
	 YMlVrM5LOnjp9U0YBdH0gbMWYI20fGC5ppaKkC1zZSLxrxb6KtR05Xpt2OBZ2LB+Q3
	 fCOQsOay4m/Fr8WhXfJf7/hMXWZgWeVfG8I5HMy77gAaXJg9x3FAs4EqNM/2Zm6RwL
	 xLru0sOfwU9wr1wRSwIqamAg2cmB4eOPn9/xVztCiN8NzWWsSW8BHGWVR7sDRHBXCe
	 K/nFMG9FyIRoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260908035201.402424-3-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
 <20260908035201.402424-3-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:52:48 +0000
Message-Id: <20260909035248.BA30E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add per-slot locking, sender/response references and a responded flag;
> make ctx->error signed. Stop copying after buffer withdrawal or completio=
n.
> Return a response recorded at the timeout check instead of -ETIMEDOUT,
> without shortening later waits.
>=20
> Ignore zero timeout-query replies; asynchronous updates remain unfiltered.
> Timed-out slots remain reusable; the next patch adds quarantine.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908035201.4024=
24-1-longli@microsoft.com?part=3D2

