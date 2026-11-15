Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794729948;
	b=GvKNqb3lt+z1j26aee1HOEtAyec4supOkwvq6BLXSN9bBdw85r/6Z8uiTHV9r69EdL6U
	 +ad6xNL9ebWPbgI5ZAOgX8A5cCltWM5NonIytOIankF5bmvdNnzbTiyH7wLgiqM3rfBeV
	 lr6gHUIS0lgwJW43CO2rARByocT0goEven5bBlYtafaG0MnwddlgSjoMUKhJhkg08tUqz
	 eq6n+awAkWNPQ1IXioeR6LrVcPIJCHUmTQnfi47SZW7bISSKq0Yh8kcvskOhf4aMFZ+ch
	 vRUe3fep+olHoV9QKADumIAEI8w2Sc3CiHRoOFUD4EqfR2DoHInvpMrybDjWmVaQBXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794729948;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uLOINwQifbl7NdcmlKi1XwmwvGhRqaI2ZvtD86rQsQo=;
	b=1+ioWq6THsG1iG9tKciMg0Rp3dcwXim0rDdtB2+X8Xi8sCbfY4kdgDC/h/fjL6SsMVBi
	 qmD83BDtdxk9/Eq7uLDS1V5A1+89e6je7zC40lmhRt+oEaly75BSm2+VZoTcJMl5sl9qM
	 I5x+lpGK2KXY1SoC84G3IhYe+5qYoBnCLWXqbW6k5H9MbqkHB57aa7gOqmUaV2M+M8zjG
	 KydbVR8SOngGZGeZUC+Wll/CL5Vnw65VgPZmOY3jLmGh0ggzF5vJOMtLYLykhOQnfI7bb
	 nl83kh+z8h3YCvCllbJE9pT6mcWlPuS8E2us0Tx+28B6z6ymwwSWyqiqRhZT//OlKpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCj2aRKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A79606A329
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 08:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCj2aRKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95491F000C4;
	Sun, 15 Nov 2026 08:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794729947;
	bh=uLOINwQifbl7NdcmlKi1XwmwvGhRqaI2ZvtD86rQsQo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TCj2aRKxLqJHgssqOlScXQ9gGVEx1UljEdxHxax4fbMppoLQYTev0uSp8N+pUVDuy
	 VrwoHQgeHHIuLtqLykCMiO7PdYp5Xfxb5lApvdRXTRl8L9seOGLUSCkTu1seWJ2FV6
	 CgTY57LKGdm5Bn4gnBt38uGifHfYGv4qhxmWwJL5kLdvTOSvocawu8wjy9OcmCpfoS
	 8s6Vz+FTFih/hfO7J5vy1Kv2ZTr+U/RxoUEQuQVfILXvH8puM/j7hj61h3AI4rdEGC
	 uyd89llEJELhy3RGGsyR4oUisPe5PuD7p79sCxaTFSc8kyYnGIdousgibBeQqQqwhA
	 jC25ErfreNuRQ==
Message-ID: <sashiko-outbox-215281@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx4: Use the right list member in
 push_deleteing_req()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziheng Wei" <zihengw03@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115080226.910258-1-zihengw03@163.com>
References: <20261115080226.910258-1-zihengw03@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 08:05:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> push_deleteing_req() looks up the last pending request from
> group->func[slave].pending, but recovers the enclosing struct with the
> group_list member instead of func_list.
>=20
> A struct mcast_req is queued on two lists at once by queue_req():
> group_list links it into group->pending_list and func_list links it
> into group->func[].pending. The two list_head members are adjacent but
> not at the same offset, so list_entry() on a node taken from
> func[].pending yields a pointer 16 bytes past the start of the object.
>=20
> The following pend_req->clean then reads past the end of the
> allocation. On x86_64, sizeof(struct mcast_req) is 312 bytes and clean
> is at offset 304; the shifted pointer reads it at offset 320.
>=20
> The entry stays on the list when clear_pending_reqs() fails to cancel
> group->timeout_work for the first request, which sets clear to 0 and
> leaves the request queued. push_deleteing_req() is then called right
> afterwards from clean_vf_mcast() and reads the bogus clean field, which
> decides whether the new delete request is dropped.
>=20
> Use func_list to recover the request.
>=20
> Found by LLM-assisted source review. Not tested on SR-IOV hardware.
> With a test module that calls clean_vf_mcast() on a fabricated group,
> push_deleteing_req() read a marker value placed right after the
> pending request and dropped the new delete request.
>=20
> Fixes: b9c5d6a64358 ("IB/mlx4: Add multicast group (MCG) paravirtualizati=
on for SR-IOV")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziheng Wei <zihengw03@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115080226.9102=
58-1-zihengw03@163.com?part=3D1

