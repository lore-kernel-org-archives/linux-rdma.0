Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903053;
	b=0ROCZcGxevyjiMo5Fd2nv/CKQPpDnVLxy+c3NdXfpq8zU9BWmNhy+qKq+jJOijtaxtWC
	 i629dhr0cOqu91pgOk95sbAmXDzCnXztFRPb82yaZnZOdcz0lgCUj/99Rh6upCbY6SfjG
	 QXJJu7iZnSGa8Iao/8yaMiCcVMqK60A6r4yWjWKo+VEdXxUu8zThhXQBiIyu7WokY2hXP
	 AtVcL1P7nX6zdjZ/uASBMBK7Vt+dfEHWhbIyEhEdzwLqswWwa/QrhnZG4Nmyo6+BpOPyM
	 NtV8d+8BmvEFu2hNszOXBNRie0scSm7Kq3+dcoGiO33pA/UtnEdXb6A7W8xKqzQMGeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903053;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9Pr3MjKA6YJjK/9njDIZJYpU1O2AMQj9Oa0bmBPLDCU=;
	b=vEpSWy2O3GrcLHpeu6iduxyyG7XjrdixrEVN/TbU+SK4/1wmm4mSqVxGHFmGAQzNmEZx
	 1FwCTREbPJ98vBgdE2cqXbdLYgMW2PF5CNPaK4J2YOnNC7+O4Wmj69G2AGCZJtoQ5pqaK
	 EACCELluBqYei6UGUrwSemZrlYHvEaErz8cjbxayhcP5LPys7AjjtgMHD/wQL3gPpCDzq
	 ze7yDjvgjn3r2q1Yg67jghJvj/aTCUa8rDpX39OgikYjkrcdhK0yrRnAF+dPb4O4wi7f2
	 OgbCwa5fLDRRhY1BnvBzjCRk5xRuvp5EliHCZ3Zo7zYAzC6uhgErvHVfCFtjxfVgCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lN721aFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7D4606A326
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lN721aFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBD1F00919;
	Thu,  5 Nov 2026 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903052;
	bh=9Pr3MjKA6YJjK/9njDIZJYpU1O2AMQj9Oa0bmBPLDCU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lN721aFKHnasNtuyHkdEJf11duIAqa+J/97RGjbqD6eIfJMv/wD5Mpvw6qb4jpfn9
	 aK2s8zEKKKbAUVR9J4m50BhQaieus1C0JVrDGK1p7EYCq4K9QeYvhKG7V37pclCcf6
	 MkP8ZqNm2tDfKqnkVLvVnd42qPwcjIFFhcWPAPokmxDjPT4c8iD2rfMk5iyz07JVrf
	 9NAvU3oYBExOxxfOg3cOxXn1+3w4CV5YGozZbMTZIlQK1W3vy+rMe3uFns8aK4uzSw
	 W+Z+fvw/eSnBMCW6W0ZcTRuOvghmVmpe1k4pFODWWzj9O79VLiUIz/WHOEXlMQM3cv
	 +2W67VKodmnGw==
Message-ID: <sashiko-outbox-199756@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 7/9] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-8-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:24:11 +0000
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
> Decode RC receive completions, armed-PSN notifications, and MMQ
> completions. Retire requester and MMQ shadow entries using their
> sequence numbers, honor cross-queue fence dependencies, and suppress
> successful WCs for unsignaled work requests.
>=20
> On an ARMED completion, rearm the next signal PSN to generate the next
> send CQE.
>=20
> Retire acknowledged successful unsignaled WQEs even when the WC
> array is full, so they do not unnecessarily defer PSN rearming.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D7

