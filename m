Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682156;
	b=EewjoJuGbj/11TzBlhbv3pDPQOBl9a1uaJlANPacw2znaNFpmWoh8OFsBUXm7r7sn0qc
	 dQGqONat7eCyAedc/voG4q2BOgSfvgJjcSbBygFPBUXl+toJJ30ZubZOrc+yWGogIjodW
	 PnZWsDhAL/jJt6+g673K3BUc0O4fnk6bU4pw50Ouz/I4P+FrjyarwG/0K+0k3S9jBoUjl
	 Bx+NqFhJ8+cFGSONeLVKtIsKGGeckNpsUTlfr4oQKMX8akVL87nCZKHIDlxb3OLaLniMP
	 IKPOD/2ewElv8oq+OKf4ASiN5P4JBmSQUfSCZ4lBP+evwFBAYnVyd4GFR23Wpmnk3xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9tIR3eP8Amclh0ByaXer9SBdGF399JPEoUEerG1hdUQ=;
	b=K6/Uyx5xHoBosRu5Pf+aVjCIpcPkTmcZ8XmD5f4XXvk8bk3cWT5fBV+LDkztRMHEkkwN
	 8HtCMF8UDDgwGLY242Le5LmoyTccKlSquCRwuNESdzfQta2+xiCMW27FwlFcQrBwfXbOE
	 hfkO/eIvTqnTH23TLoCLW0W2Gy1j+uBC3QwWmrqTlSlMu1PNFPx+lcBQolu1eppkeaKPm
	 eXFObAlvNAGSffFn5F+dXinjtRu8r1E2E1fu5snJt8OvXpBLmKiE3yid8XzLC+Qaz5lwC
	 +zNMr2dJEYWkmLL8NEqYl71lKA9Dl8F6CJj76BC11Ij/IYJqqKfRO26SyzuoKB9XGzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbojrCSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F877606ACE7
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbojrCSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F991F01825;
	Thu, 22 Oct 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682156;
	bh=9tIR3eP8Amclh0ByaXer9SBdGF399JPEoUEerG1hdUQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UbojrCSITqYZJ2DL4oLJXaGT7p5edlXETh9NWmeqhAOexZ/jB0SejvjMooENJfjGU
	 MVLAMYHnWOn5ISeBayy5VOlHm8CB2YGKrKGQ/Q3qPW6TlrRX18SPRkRFnPt4wjAG0l
	 zDlxmX6dvAOZQ5BUSidwEM2OWi4cV8immcOZGBVRnG2oC7jpdRl6wU6lTVvMX8j4+E
	 DJ0Bn11zMiz+BD1aiC2cRJIDxVmPR0P1cTY2oGwHhMWUCIcJNL21d2FClzCTwhl5n6
	 rPdyN3foghYOdZ6vGIAhT/CiQYwXREtoEVOMXi1NVLy/KPGVVq46FUHiMpdXLuQcgC
	 D4CSUiAqkdKXA==
Message-ID: <sashiko-outbox-181681@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <e3b82aeab9323eb1c70203e90942df5f6a4a01f8.1792679388.git.weh@linux.microsoft.com>
References: <cover.1792679388.git.weh@linux.microsoft.com>
 <e3b82aeab9323eb1c70203e90942df5f6a4a01f8.1792679388.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:15:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> Concurrent requests require the response handler and the waiting sender to
> agree on the lifetime and result state of each message slot.
>=20
> Protect the caller's output buffer, Linux error and device status with a
> per-slot lock. Publish the output buffer only while the sender is waiting
> and withdraw it before every return. A late response cannot copy through a
> pointer to caller storage whose lifetime has ended.
>=20
> Reinitialize completion and result state under both the allocation and
> per-slot locks when acquiring the slot. A response handler can still hold
> the per-slot lock after the previous sender has returned its admission
> permit, so an unpublished bitmap bit alone is not sufficient protection.
> If the response records its result while the timed wait expires, return
> [ ... ]
> Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@k=
ernel.org
> Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@k=
ernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792679388.gi=
t.weh@linux.microsoft.com?part=3D2

