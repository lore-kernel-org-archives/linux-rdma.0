Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404805;
	b=SZX3Wf0TkiTGAG5H90tvsr3LJqvU4OT0S7EluSlNoRMRptzPY1bcDeX7IqoYaUaqMFdL
	 MLmAGTCfh6rctcfWN1Bo9HuE7x/1qfLh56GjxK+6ZGLAXtvZ1bOwtFSBik3QweF7xaral
	 kS0HJD+RWKS4YIHl/pdxby5OCytsiXxHbguQjDJx8eleg+qEfcL6GStMkIul8M6KtDYsQ
	 ctj29FyOFxj98uQPDa3HJWhxZ7huQirr15QpIZaRV3/ysK1ETDQZvRUzCcakqRwFyFBSr
	 GXwBwrlZB1FTJr4EhLwo7/ALXMg4J4bliu9XhYCOfQv4k6jjrBLuWawGuTmA0ATMVbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404805;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dbuDWF3uDG3R6V482lQT5wsQNa8lDuaN92erIxKYuhU=;
	b=Tj0MYwhooFzTWazkvqqlvj3ZRFxpjADLXnz5tAqIGbtJJ7vR+qxi4Y5Qvayo1aM+LRnQ
	 MzNIoI3kUZBlgVN47FLMbzKAbVD1CX8qn/QiYhc2TCHOCeo5QrEShy+evw9V8wxT1LX7C
	 FV6vaPqW+tnOD7I5y0J8aeYqL0/1HJZw/uPWfMrBqT3p0BAy20MyP928masH600NxdV9U
	 pPsuvXTSNIC8tinGc98Yka1u7La6UeQdGyNwhsFo1CXIMu91UzontvAkDNr7oxKAsFyiH
	 UWQ62cWJ2mlvwRD6Dwz/EOjZxdI2QIoMOAzHnqRkFD4o59gmu+kLAQ/KraNdD8+0evw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUSHb5jm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C2B606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUSHb5jm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572611F00A06;
	Wed, 11 Nov 2026 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404805;
	bh=dbuDWF3uDG3R6V482lQT5wsQNa8lDuaN92erIxKYuhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bUSHb5jmkH543rZc41BlkFbJu5jq4W/KEMbgk1KcsGM91iAtr5zQKggNZwo5WP0Fv
	 9VsUofeDSRGaWsPMbYSC2cyMHxymCPZTaavMagrqUzz3cPS9owEyw1Jlw0QVjAImby
	 x38Aoye8VPMqdfwsY5nipFpTw/B2SHt+1/6bUXhGWbtYi4yyf3GIh0OI+ePdFBG7qZ
	 c9Gjs1cm2Fe24+rHO4p+AX1Ugvg/shVFWMGq8w9/kJbpiO+ap1DKwlt62MpA2Qq60k
	 j4W+lLiNAnx3RcIZrmzimyKVoD+1V2RgECyqDfCwDnePZeqlvPqKsrg0LNjAryvPy4
	 m3m6WTr+4VsMA==
Message-ID: <sashiko-outbox-209087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 02/24] net/mlx5: Derive adversarial mode
 from CC guest memory encryption
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-3-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add mlx5_is_adversarial() to report whether the driver treats the NIC
> as untrusted. In a confidential computing guest, the hypervisor and any
> passthrough device are outside the guest's trust boundary, so the mode
> is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
>=20
> This turns adversarial mode on automatically in such guests, without
> any administrator configuration.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D2

