Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795669254;
	b=uWhvsFLrdV6Gp2FCm1shXKarF8M/nu26C289/cFJzNmTNfOV5EzBTfE52C/4iD4K3IAJ
	 7+9Eo32h4JB01YxHNC2j27hVFjVc2wmNzSZ8NZz7D0FiLDq6FI+RJLGh34vgnuuTQu9yt
	 ZxQZzhbLlRBFfP6G0efxAHYQFmr882Ru/8WjFl6ko35SklhsfccORNjDzMyaYY2AbUB0X
	 tne4PbnQ8m2mLMMxMC6WJU67XSnNVChnPDmkwZp54gmAl3dAuTpqfuIt1F/oeOwsk4aMI
	 0EO3UEp9944UiT6OZ13ab+KidMVA08QsXUmCE3ZZSRnmYLwzlQmu0zaRNVIM1L7Gu/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795669254;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qt6soI37lMYocVLFNL76zvUtdJh9eRqE7h1DFLlToU0=;
	b=SvGcM5MMRImKsz9S6UJO4MFXtWIr1AhYy1gbqVecL0O/st4moBdgKT9nsLpgo2Pwszrr
	 E1B8gFWnoOVGkGpNzes55L8rsgAlv+vujjqRorlO1ORgP/t50zQaWt2z5tpL9cpyqiOx8
	 txp4mdng4fctuhwQK7lvCRtbzCOIvuMwbbiffofKpGJ+8enY50gnjs5XUPoQ1EgB7GwBt
	 bdSX6W8ALMf4h2ka35AVWlmmOpVY5M90AkS2Iq6qsZie+z7gKDFxkxi0IjlId2QEqpcZf
	 rOMZy2EcknI/x1EtFtXit+P1XTp35oAhemZFjuvyIkPEWoljfQHDqY8lQrYeXWvGUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lK9Teg1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41782606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 05:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lK9Teg1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE961F000C0;
	Thu, 26 Nov 2026 05:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795669253;
	bh=qt6soI37lMYocVLFNL76zvUtdJh9eRqE7h1DFLlToU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lK9Teg1t/+rM5zrmtcVrhowSzGpvP35MjSmbzW+FiaUYbBttueRaZ0yEYFqi05LCb
	 f+MffccvPelkShy7w9+ckV0oVM7X4ns52JgNddbWgm8/471+tnAS3mZXx3V7lwSzrb
	 k60K2e8bDTSbg+RhTheQYk1QeHoskcY1ffcZhQLVv6FpmxfNpDTwAW2eg8i+nGxbwm
	 voutlCeNM8hrUGVxVhRm5SGEM7p8SrczNpupMLL3dDBBayeQpgfrDMJJF2ztGQvJPq
	 nRUzMGMette42O+b8MPimHGiexImdwVXr2UzhEhXzYcb7FiQLlDk+Vv4EuIRGKOpmV
	 mY5Irr9bqeExw==
Message-ID: <sashiko-outbox-234753@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v2 0/3] RDMA/ionic: Accept CQ, SQ, and RQ rings as
 umem attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
References: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 05:00:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 3-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126044811.3458=
258-1-abhijit.gangurde@amd.com
