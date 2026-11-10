Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794353705;
	b=3a9bZURYnYq8lKtWVmzHHVyFnCB5/GZ2cHYOKQMIwdloKK0qrMHIsSu54EQZlc1tL6CZ
	 y1xZaHPsBM56QDEw5oZwOc00NoIwNYRQbAr5WnLjwAguj2e+2aRLM6mrbZ3nzzHIEWuDv
	 LWdTD8UV5OCpmlKmTbKPHv1h1CkO1eaB+BUUVdbCNlEllVGp/YfMRiwrvcxfHGiONOijV
	 MX7jWCFH7ftWULFi+EpobyX50+tbHoWcTgVF84/Q179+nmtFFpbxwWADbXnOf/AF47RfK
	 Z1EeLHlKS+sZ5xmlBU2f4YKINV73hBukkuSl14ceS5+z7A/aJkfI7DMkI1kYNv0kbWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794353705;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ODQ/10oVzQfxcX9niXrGu4Ku1UwGX1ZHrfPE5kJVupA=;
	b=ANsQ59YAsr5kYgiHW8A7oaSOT7Y6aFWFz+TX3Seeij+7NNnKCXtTm4m/XMQkCipsoFtj
	 wyEXHnHsC58NO9Y2KXbROUsvmOnZNZvPY8UPUcT0g1pRw7BKgfU/h3vyKE4Dgo8cuGbfa
	 t4a/NBC4DhAgcKQaSSJzCIg7FsFKneXQWsHliStzaqvy8zOfiByMYZ8JVqtm/ddf4F1DJ
	 VAWLSrIjzs9o/SO4A2nQa5VnbuqGvVVzrj7H5nt2TLEh4NfWVyAj1mbF9ae6cysb+8+GO
	 kCb+amHwoA1vwwwV51VL3X17qH6qFnunvpEwQbmnU8S0LRcjXJul4gwEAnA6YVMuYBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AR6noewr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E6D606A320
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AR6noewr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA3E1F0093C;
	Tue, 10 Nov 2026 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794353704;
	bh=ODQ/10oVzQfxcX9niXrGu4Ku1UwGX1ZHrfPE5kJVupA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AR6noewrQm3Is+5qhvuTUuLVSdYf4+jXNf8yeoC7iZE1W8NMl4uw//+KQX7IbXg5K
	 xYyYQNfcAll03ftCwW7smUCXJFfCpKNYXfBmMOxqcoVre43hcq3c0Qo3eYjzSd9dxE
	 jkb9fTvb4z7bJBUrUeysUiNdjzwQ/jLUeMlKvCsJmkv3/m0NDLY1OAEvu03pEuiz3r
	 3/leqDXRC/vkzDIzCUsjnRcVykc2gK+bZGP8dwgRWIX5G0B3WOtntgCN4sQAw8RmQ0
	 AIEe4g3i9p+JrIllQQJiVjfo0hzzCXbFW72iogWC9XaenoIfYfFDZAVJ3JECp67Wtz
	 vP5QGlcSu9SFg==
Message-ID: <sashiko-outbox-207941@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/rdmavt: Call check_modify_qp after validating QP
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109201302.14531-1-serhatkumral1@gmail.com>
References: <20261109201302.14531-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:35:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rvt_modify_qp() calls the driver's check_modify_qp() hook before it
> validates the address handle attributes with rvt_check_ah().
>=20
> hfi1_check_modify_qp() uses the user-supplied SL in ah_to_sc() to index
> ibp->sl_to_sc[32]. The SL is a u8 that is bounds-checked only in
> hfi1_check_ah(), which runs later so an SL >=3D 32 causes an possible
> out-of-bounds read.
>=20
> Move the check_modify_qp() call after all generic attribute checks.
>=20
> Fixes: e85ec33d820e ("IB/rdmavt: add modify queue pair driver helpers")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109201302.1453=
1-1-serhatkumral1@gmail.com?part=3D1

