Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637194;
	b=O4WPbAl90MXqTP7KTF1AtM2Vnt28JYoL/4vedd/on24T9wy7KaVjcpJo7gTdoQ29hokY
	 9aum1VnMrI98sAfie8UYMr1L9t84zHPk5aIewOoJe9Inw1IBR2hC3Z15zxm3iT6f/AHj2
	 2iq6Us7FhSy802pIpUOjWDv9dkHLKqpKKe6DULvXVitKTGVqdFBfSyzVrtcuUl73jHjdJ
	 OGR3UnFuaGaLNm4F6msWOJRBeP/jRI+SZZzUcVOM8/9mEXwGgvrrfx9rpKLha6JcNtVe+
	 ayXRrxya6g5t/A1RKIimk7Q7CYuZjkzjuTGR6pAy1lEMAVnJAIqvQv42Tp+Gik6Bhyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637194;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EGk51I8do2kx5m1tjTDYfkh3cqLIM3UkQ2CPBxDibrk=;
	b=aJ263dsgcFKT13qza1nHYznDEGB1kpjWDmlkMKUISi0z2onB6jsUEmiIQrfBXD6gdNsz
	 NP87pruoQVGchOV43VlnBFVTgsXYXzywRxa/iOt648mZv+k+7dmBAe98BNQXWE7akc+tJ
	 wo19SXWD2ReMPGE0ApwFU74XkHfm97YWG6DIoNLzet1iy+dOzVUEN4PwTPk0SSNr50Grg
	 m2pA/uoqWuwEfZxWwPrPwpB7141+DaB1do+Z3kgC9IgPBh1cD0KfAbZRqYC1hxFPLcWzz
	 Htqt57Zh3ikvlITOwgWS9FhWFsG5Kdg+QoD45mnpNrcesyN4s1AAc5aRTkz8a2htfRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=At1f3h3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C30606B0E5
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=At1f3h3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C701F00A1C;
	Mon,  2 Nov 2026 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637193;
	bh=EGk51I8do2kx5m1tjTDYfkh3cqLIM3UkQ2CPBxDibrk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=At1f3h3gZ+SWrCaxUYWfH7jin4M28TxhgsILOrYx73O/VGfdKVipYX+mL8QG5fDT0
	 uSMCtpse4W3+u94kbXwZpeH520pAJ7SGAZ/KYi5BZvuUj7HRfivXXpc0lzsQplnCpL
	 MoPckZJXTTWYSJ9umjQx66W7tv+8lImnPgwldu3Ap008jGIvBc2TguWE3gjft+e+eQ
	 tIPcC2j+hunwLH9BeN4snV9sraOVas42n7Q9WE/BqOhyebKLjev7LbeAALwukGRPpd
	 fG5x8SqCXHuinrPcNrLjCVURqOR9ABmo9099QT61sWnE18yqNitGUQxTGxlGL4LNlv
	 KHZ2VBat2pwgw==
Message-ID: <sashiko-outbox-193753@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 4/9] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-5-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:33:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
> packet, message, and frame counters for use by work requests.
>=20
> Arm the requester receive queue at the initial PSN so that a CQE is
> generated when the specified PSN is acknowledged, indicating send
> completions.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D4

