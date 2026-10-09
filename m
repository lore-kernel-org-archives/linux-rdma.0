Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995643BF660
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579846; cv=none; b=YNATgom5PMckrtjGpzFnkvTBdoP42d+hITZDf9yXUJGW46QSN2UCMVFiZhNMq0ekbZZKvGHCqiarKSaYr7P2YlcUzpSOuVYiJZCXXc9CcPKP+nwIaBFPEER/JsC4H3f6/dWrIfc909Z3YH3ot1mUSy+AMxrafrBZiBDUm3jQe7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579846; c=relaxed/simple;
	bh=YGw67n7KXVr1p0Vf3Prwc6SapfjvuIfQnO/vRFAKCg4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IQdwx48q7fSzK+UttWEBix7YiteWQePA+BcSJX8H5MfU4DNBa73JQ+WMrrJv+k4/59k6oLxY4cj9AyzIRMdubvvGrRkh6laxZf7TiwuV4exqrsFj5U1TVu8+T9FiZZtYkBVyo7DSiGsrVM/KKdgHr3z8oiM2CkPFvFiPrU0s7uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kifFBi/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kifFBi/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B501F00893;
	Fri,  9 Oct 2026 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579845;
	bh=C+iGm3rETZHxl0S6PJ5ZBGEn6TjvxY5fdrEq/NVDoyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kifFBi/XOQy0j8U/dD3anF3ruxwyZ4k6hF5ND57qfo0m3bQf0FXPqDuEFQJgXWwnZ
	 B9gGXctxgo8dyFOkvbrrJ0lPfTNm4DZSIglYCl42IiVje7j1fhWkhNw4Is3ouMNCE3
	 cBvc3+mE0IyMkTm9iz86s5AYFwSJXPSTMoBxMbKVypuySa+/BSYQZQt8IDxWji4sRN
	 e05A72DpMRrMKRmV0Rd2ekbhffMq+R3Smos9I7UEoc3hgQHsWqXHJswYhVrpZ7deUt
	 i64zwPVuaf5ki69cJnpAqnIYeKVgL98dYDtf2W4tQ2nDIzkph/7y33CA70gD+BGhpa
	 dGzVhQuFBN8xg==
Message-ID: <sashiko-outbox-166077@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 10/10] net: skbuff: don't reset truesize in
 skb_condense() if the pull fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-10-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-10-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:04:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> skb_condense() pulls all of the frag data into the head and then sets
> truesize to cover just the head, but it ignores the return value of
> __pskb_pull_tail().  If the pull failed, the frags would still be
> attached and truesize would undercount them.
>=20
> It can't fail today.  The caller has checked that the head has room,
> that the skb isn't cloned and that the frags are readable, and pulling
> all of data_len eats every frag_list skb whole, so nothing is
> allocated.  Check the result anyway and leave the skb alone on
> failure, so this stays correct if any of that changes.  Use
> __skb_linearize(), which is what this pull is.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D10

