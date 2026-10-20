Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792483802;
	b=3bQ3tsN42EEKXMrVbfb3DaY5w+4HLSOB4qNReTv+H+MYlxUAolfFfh5syA1QaoYFI29L
	 v9syfeEOkSauHuh8XPlo1TOVOcL3SsMBbtLmIq2s0vVCMEoHWEpt6e4z4m6+Itca4E5hp
	 zZjSf4nX9u1rcSy8lyQg8x3/ekNliIH/hDih8rDZ33RzXEEoCgKKMbMlrzUE5lV604xNE
	 KNRKae4OiCfKeQkPfm7qk8jGT84NPTZdSERTmmI1NErAVUihxh07BNPND9wvNWVpHzdE4
	 hjgZYDm59sJi+oV16yHNRHCbLqibvGCbyDrPpCS12UMk36UDJYkHB0qpBXfK8Ebwmig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792483802;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EWV6FSv/Ni2ldH0E5SGhtEzZMq0MqmbdtbeYmF5DHUg=;
	b=dJRH1eho0UeTr/LH4x9a+dh7lWgqtgcVrFu+exLxyV0OBJAYPJ2J/d20mwglPOk/8L/8
	 85KWUBvSUtBMT9tXvxdPaSBW9ldFcycCGNW4F9EPVExtjNXBhwn1BGPoIbQiQKZCdbU3G
	 4eF/PVfXU10WSaCahiEBi49Ge5Vxm2mSSf8fmezMc2kZzt3KAAWqGQZVK05iIsdUkjWb/
	 wy2KrIfmCN4JUuiq0w97clHVLCalJeMbeMtPwzEZ3YhBMByaGhJIts3m4zr9R1Vy6HRA2
	 Hd3pIqMdZE7ID4uVYY7WgF62WLY73yrfjfgvwR/+zHG820fiwLWi+f56adlCQOPcvtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pkutgyj4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBCF606A332
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pkutgyj4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7502C1F000CA;
	Tue, 20 Oct 2026 08:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792483801;
	bh=EWV6FSv/Ni2ldH0E5SGhtEzZMq0MqmbdtbeYmF5DHUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pkutgyj4uozxM8TeCErHlHfaLkCqomZ4/lSvAUsoO52A7WujhHixIQR+EA/g7dFtl
	 eJt9ZraCoJbxY12qu9ZjHuElLNQvFRYjUxKa1QiVcaQ539kzw1JzcKwPjzBHFPQiLr
	 X4CjFudiU1+YNbjIFYsPAfMHap9SVG+e/E+xBVsoJjYeVqoVj6IgONrrPoLGXu3z3q
	 K7hZDLCc2yauWtkKMBThmeUQNcnBTri6iP571UN6s1SgrIs0+sBxIvO+yEvgi0jH8I
	 BmfLAQtK/y6jg6ZHO+L9f+ySVQ39qzV8ZigIqK0PdHDJgMVh42xapCYfeTjoF926WS
	 xA6erFaO+7mxg==
Message-ID: <sashiko-outbox-178485@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 01/13] RDMA/core: widen the uverbs object
 key
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-1-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-1-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:10:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Three more core objects would leave drivers nine object keys, and mlx5
> alone uses ten. Add a bit to the object key.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D1

