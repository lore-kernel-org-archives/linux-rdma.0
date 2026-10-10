Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9F41B8EB
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616310; cv=none; b=CSsT4X/g+G9z9HKNx/fzIBg//RPDXT7aP4p94hrpt4m0tgoua16SqnrC0En9Xs703/dQBusc7y+9gohNW5XRtKVdRhaQ4l+8vwBULL5NyCt5jVnSC3cD4MvXTzqHDT5SbuF+dIY+HY7pSs1E0yO6QpYwNYCxiBCFQyjRZQ/My+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616310; c=relaxed/simple;
	bh=V3l6bNfq29d3gFO3MArceXS5uBSSiIheasLUdhMgAQo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UIqCHaf6dl1Q2Nqr5HVR+DLgGwyvm/6t20nK9vrhskNfNekAHV0VuYZJGd6N31+5ZFXsN0oFFEcH9ty83tw46H75I+VxTMqJhfyHbRm3iEIyu3SXQcdxGAz8L+UzZ0SUxQaJmyakPA4Wd5+8yj0LStV9hp3WZUMuOmAC8U+YxO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HG6230ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HG6230ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212F21F000FF;
	Sat, 10 Oct 2026 07:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616308;
	bh=V3l6bNfq29d3gFO3MArceXS5uBSSiIheasLUdhMgAQo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HG6230ut1kIhFuU9JRrpW1Fw6nORLObDGq8NoAQj3prgKdCwA3L8EI7JFSb+4WbFo
	 TjUMa6lTj9CsYdQJoOGyhNGew+Skgm1uxABbFdOLlD89eVtFu91mEFw3WFcehS4jLp
	 XOhLdH69ofcV/cIqejPKtBUTg4jTMyMiBaFxSe3HpvbeUmqD5T+k7Rt6fnVUpdhfxB
	 xPLUc/K6sT8TWW+kKRR27lX2XA2knIEkH1lNU++DoQLT6D4qsw+yvEtcLSPaZZtkha
	 5P0pdaGD03Fy3x7zJCzaRwVetZ4/8rFTzo9ZI279AwEp+nMcIy/jSJ23DzvMUvXygA
	 p0CJxejR1X1wA==
Message-ID: <sashiko-outbox-166301@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 03/10] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-4-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:11:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D3

