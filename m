Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559572;
	b=fj/2qQdjACgxzfb8yPeDb2Yd8p//hekqBmNBa2+xkkLeDbDX9PW+/p5UxI/nOPAO7mDy
	 7GisyEiNqVH9PrFLcFpKGvWXCudCGdM/yumqt2eyAG3jzlNH3LGvgim5H7RFp0ZqwhOa1
	 ChQttspdadJWwzmVsahH2pZuSK8QuEa+fB7dBB4xWE96nUaqgBnQUiSI8BQtKynFcpmKe
	 0p6tjJ6FRxFVfkEp0b3qezs3rbeON7g74OYtz1z2gxMEVgP/LqzgJTqPMgxLw/Gk9pBqT
	 JeRW9kYLddlM5/QT5uOMv9rJRR8LnucOHhMtfr8+UaUlgUzRZCt13cnduhpNQt4dDpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559572;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BZEuLb6vL1SNAJfPSplcjdpbUuSaN0mNUZiorsQ0OXk=;
	b=ay8A3bDIlU92kRwFPZwZPE1g3IvHsEUnJw2tXMl1rRsRs6WUw8fAG2kcyhtFQ30+txOa
	 2GZH08dIw4cDTtXVfzNIfD87MMXatcF1Cl7bU0/qqO3TdyQEGZSxjYIRRQ44D0Spt251F
	 ZKN5zYjqGM3Mk/XER1r1DBMKLkANRWjfC8kyl6vVJWC8wCGvjxL0+HWZT8Yfiw/lRqFlh
	 H4nP6f287sU/OLE488GNTbTIgyaabV9/9dCZF0HbJ/0Nv+PhHLbXF02AEGUZRdLQNv13Y
	 IQ+bx8cNV3eU7LOohr/pWRcQphY/dfedNTKw5jsO9qwgE2VamVg+c/MeDnfipRe9NRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJkMmtAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38BD606A89E
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJkMmtAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88681F000C6;
	Fri, 13 Nov 2026 08:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794559572;
	bh=BZEuLb6vL1SNAJfPSplcjdpbUuSaN0mNUZiorsQ0OXk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TJkMmtAs8WQNo96BSWiZEVn7eOGkEgi0WzNww5bdFEKi0vjslzZHG7uxh01XdeCjo
	 MFZyZxDbA8SMrszchNU95Wvp8A2C7lqpanLujOXtnI+h6DlnaULePxQhcTcH/Lz4tQ
	 IMr330v6R1cOLD9UM1Do65PEyyRV9AuVx4aXhsVOeibrofxCLj/TOvA5sYUw1bVmFc
	 e5eO5K78Ui82/otw0JrsfQs5giQ66VYVJtvnGnNy0WuagRTso7qNsCeaAHLUwuVVAA
	 T7qHFsMlHnvl+vs2HQwMM2Nt8qYz9Yl3dXgj0sXQZdYTD5EjcqW4YxMJpof0umol5W
	 pv38zTkj5b6sg==
Message-ID: <sashiko-outbox-212459@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/3] scsi: target: Clear all control read scatterlist
 entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yong Liu" <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261113083848.1517595-3-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
 <20261112094138.1390409-1-pkfxxxing@gmail.com>
 <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
 <20261113083848.1517595-3-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 08:46:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> __target_submit() only clears the first scatterlist entry of a control
> read buffer supplied by a fabric driver. Control CDB handlers can leave
> response bytes untouched, so later entries can retain stale kernel data
> that is returned to the initiator.
>=20
> Clear every supplied scatterlist entry before command execution. Use
> sg_zero_buffer() so entries spanning multiple pages are handled as well.
> Keep clearing the full entries, including any part beyond data_length,
> as the existing code does for the first entry.
>=20
> Fixes: 944981c7e106 ("target: Add control CDB READ payload zero work-arou=
nd")
> Cc: stable@vger.kernel.org
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Yong Liu <pkfxxxing@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113083848.1517=
595-1-pkfxxxing@gmail.com?part=3D2

