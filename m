Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810629;
	b=BZA9T4S+lPV6afJKPnj6mTYuL4d89xaZdb3iGm7v6Xqr6KI8hYjoI0JjtCat1/YDLTxm
	 UWsJcCzQSTDvaXpLX859oZN7lquG/4ewQfgkTz8u2ozzIpzTIjQRMqTFkotjyHe22MrLV
	 PXqMyt4LLy/ASrJu0cO+Y1QKBwxekcEY6+1cDyP9ozdtBgHetV9UZJ0xNesyca7tJ/1Mr
	 BI2zBcwtaTUCyrVJ+CxW6Mam/CSy7B3swU/evlRFjVA7f8oS8tpv8eWD9DiFS65wJg+Rx
	 pS76sgW80TmPZ7Jed3+32mqbjxpbxNHGz3rNZ+3BT1Sz4SkBbdJe0rf3Jn6b0Xtnk2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810629;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+p1o1z/h2i5hKsIeByOnH+ShNrDmNqFaZXZAN2mJ+lU=;
	b=HmQGNnxAWbyqxKk+y2zjy0SHmNgN/Ya5th0hgYrq4Hvq27UB4Qcm6stlYxcR1PBxnrzq
	 QS0N+lMLW2WpNye8CHvDPQCC8btUA1PWTpaMHJnt6aMEakZr9ZU8MZavWGLvtGfYkbmDZ
	 u3sPtQZ9K41jdNIIriFtHYCMHGLSQLIjVYiqV4FEYBA4/0VTY7TQLpwL/7ldORY7pdIxQ
	 6ZAl/rIZCYkFRjKB/Br2jNwX+SSbWvaebM6iA7qDGCChJ7A0eERUEBW7/Nppcrw3jfZJV
	 F8dZ901dTII3OV9Od3j+v3pc31abYFFkwxWwHpCbPIZ/QEjIvrH0EdVTOa11WYaOp3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVS1sdlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60073606A337
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVS1sdlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256131F0093A;
	Wed,  4 Nov 2026 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810629;
	bh=+p1o1z/h2i5hKsIeByOnH+ShNrDmNqFaZXZAN2mJ+lU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eVS1sdlb16tXhVuI6NxXVNlBb/o+Zx0auUm049v73O/5j2UMb5mBr6Y0+s0R+f7H2
	 EeW/Nmq/RThnS8DT1isCSSI8vxv1Bna8qog3X12Dsb1bX4TJfkqHbCk0lyWh9I1JqK
	 nVhlowUFgVxepYIz/mADUrtQ2zPbMsS4hYN8e/+P9l23rfoXWDD/KUBrlPXVeIFaxU
	 XStH3H7JxYsbbnorM0bvkc0rCb3cEt27hZj4F+5Xg1NoaY8GnA/I5qd1FmdNYYaKWQ
	 ZOqaJZjvHV2+QUBsJXZMX2RhPXVQ4IV0qIOTH16v7A1fHYQy5Tnq9H5oWH7ddfiThL
	 HN6TnG/jIfiJQ==
Message-ID: <sashiko-outbox-197667@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 14/23] RDMA/mlx5: Block generic CQ poll path
 in adversarial mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-15-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-15-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5_poll_one() trusts the CQE content, so it must not run on a CQE
> from an untrusted NIC. In adversarial mode no CQ needs it: the UMR CQ
> has its own poll_one that validates the CQE, kernel ULPs don't bind to
> the device, and user CQs are polled by userspace. Refuse it there, so
> an unexpected caller, such as the uverbs POLL_CQ command, finds the CQ
> empty and no CQE is interpreted.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D14

