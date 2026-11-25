Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613405;
	b=TkD3IPasAZPXTfg8WWMtrvrlVEVw6JsjKij3o+Ha9JyvSJ+Y/RlymiMWWtGX6fH9Zaa8
	 cbKrjjprRx4vecvAJM89+9AdAV4TTjJOpKVAz5p/dutGRyaXTtN1/75a41tFkZFp0KkVz
	 zFq6XyelWXUoaEbwFAO6aQjeykgcekdLNdFiciaJFIJY2/yBwWXLKeIKzkAcVsGoDQepQ
	 sBmnUns9dYqoHPIQTbp7LwRi5iWtb7wMXTmqhrMAIQ68/2bMhoRqhm9FVAH/yAJXc2mAd
	 1azNLlrkTTdmbsax7wzTHYzLQAhZSAYtu0EtbJblQ3ChxxMSD6I8pswiFRtj2T2YqMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613405;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Pf4uS3I7wwsUUdx1um4Usa4TVPRmkNShyHI9NvAdmg4=;
	b=hIRbpVX+20P2l2LHv2eB98MVYvuphHM4wKi5bqsDAyEpxyltGs6xLN6SSq0EmnM/QihE
	 7bq6wH/iIK3GuQBl5O1DohCbWlmrEEPw2IG1TQHgY7QTjb43NkgHj5ZLlkWT1BAwdFIEJ
	 NQOhNujsaGYN7Ldx5iEfMwGtfiPMO9QHQLf7iD/1Xjppyjz6Fth95WUYUXo9IHXbhdKmO
	 JQ0W+tNl/CoE7lexuqcEkaw7BnhD4Ry3yH+h9w6uwJvMfvUCpiNBMvj86qBhoOZAcPk1U
	 sgo2yU7AnhmYInmmnjXwM91WmXW7ksBUfqowZDayqb6c602x4B53oPakvUiUrm4rZ5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P9iInEy1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05CF606A326;
	Wed, 25 Nov 2026 13:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P9iInEy1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C8B1F000C4;
	Wed, 25 Nov 2026 13:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613405;
	bh=Pf4uS3I7wwsUUdx1um4Usa4TVPRmkNShyHI9NvAdmg4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=P9iInEy1HCjBmzH6lOD4Tp374oRgIOajOAhhcXA0PvaRVEuw/4D42AR4Nco7260th
	 nDFhUE7PmctzBfGbr30mVFLb07KAKCIG4oQjTDOFAmV3+KtaLPJYH8k1tpzpor0PQm
	 zXt2zIxxb6P/u7kzDjH+Fr0O/2JPEiLTchO6ZD/GKdwqnxMrQWPSaVeg2NCsSAfvK6
	 a5tywe56x/OIwCfPyzbsguNfoleX+S28EfVtpKu0XLp8jyT35a2YixwvYeKnf6TRCQ
	 Iy3hjGqnLgEC40vGDBIPezvQ6vfv/52acJ8M/W1pNlS7h4t5OH5ymXYd/rIzeeA1y1
	 tOsEiwIzMda6w==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120140605.62810-1-astellman@stellman-greene.com>
References: <20261120140605.62810-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc v2] RDMA/siw: Reject opcodes a user send queue
 may not use
Message-Id: <179561340245.1224497.977752339581598768.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 08:30:02 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 20 Nov 2026 09:06:05 -0500, Andrew Stellman wrote:
> A user QP's send queue is mapped into the process, and
> siw_activate_tx_from_sq() only checks that an SQE's opcode is below
> SIW_NUM_OPCODES. siw-abi.h marks SIW_OP_INVAL_STAG and SIW_OP_REG_MR as
> valid for in-kernel clients only, but a user process can still post
> them. For SIW_OP_REG_MR, siw_fastreg_mr() then uses the user supplied
> base_mr value as a kernel pointer to a struct ib_mr.
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Reject opcodes a user send queue may not use
      https://git.kernel.org/rdma/rdma/c/94e81a1f3ffabb

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

