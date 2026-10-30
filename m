Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366329;
	b=kgF5lzbQlog1xTe/f/bKmb4lYZuHezQrBHC+r4+ZFp3XhpU2+kFImBvhIh1L778y2R8C
	 mht28HctljOE6lYCaodH/MfNS75trbmgrONjOT/WPSWOiYqXDfrb3ex1DgjqcZgOywtnP
	 3LuaScgCri/9p6AevzY953EgasEHyCGCpDTOJR5KqfkWSDS6GjdIJ7zxpxT2ft26iIV03
	 QOKtaH8nletWy56/YxO5Iob4E6SFSykRTWb8e3pyCTqL3XpRA5FmHYC6pz6Hr2g5diuF0
	 Lw7/fYK8ZAym0vHS2mqM/U620OAye60vceujEQhWI6A5l/X0hfweChqxdRrVxAEEVIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366329;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0WqhlxUi38YjcP6C7fcffDVG+Qn7R03OaNXElEgkPx4=;
	b=hPmW2tM8PjF2b6JWn81G3QdfzF4nA2OerPsLQqgvHq8O0zjRdA7nszNKp0M33ufStnd4
	 JSWlHCOqamiwrjRSRw+iQywf7fEixpwt8Z04cyHWLPda9xabNEIxXrf06bNV338wVQ7Li
	 LmBAFXpBXZugEGCwyMOTs5glK/OjKkyR/W416MyGvxIgYNecbeLbr9Jv/vBMif2Yifg7Z
	 zVJa/Xvf2p30JyESpK19kzekz++Ap9a8k39HQYeSTMdsh6Q6JykLoFJr+W1ip/7I9dfwL
	 ocbJ4Iy2HGKuzm1uhutfiwnujB9/buFHRdJ8vr7u0KfgPOsJhKp8mXNmCjJzHgNk4Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lBK9XCk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C9A606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lBK9XCk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AB01F000C1;
	Fri, 30 Oct 2026 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793366328;
	bh=0WqhlxUi38YjcP6C7fcffDVG+Qn7R03OaNXElEgkPx4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lBK9XCk4nj4LiOe5eN/Tsht0Q+d/zat2INkQsuAMu19RwB4aH4qolV2cGrM6HDQWW
	 oOFEnGILx0Y41dQvHBHEaB3G+eHgCiIJflBVAZ10ZtBtPdlI99EZaZozI5Pee8FutL
	 bH1FByGzqDQdAIxjzkOgL1rcyOsnWLif2ml+AOkFdNjMzQVt6z8kAyxkmqLWklvImz
	 h1qwSAj3hRZ3nksLMlPnb7y/cOIjKBrEpVzQk/m52t6+hkUoY30vggUl6HpQDaQiJs
	 6JX0FClWtt0nxDxrpaCDE1ff/zCfuHStjJxB55n4E2LoU9EwT2qhel8upU3wcOT7c8
	 CRS+wOev24d8A==
Message-ID: <sashiko-outbox-191057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 02/10] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-3-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:18:48 +0000
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
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D2

