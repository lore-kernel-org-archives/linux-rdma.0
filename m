Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402456;
	b=KC711CnW8Pg1SjaUzK63VTg/b5UnnLp7ABgEII8y4UOsC/oxo1jXcqsSHBd+5cJXyIgM
	 IBR9jIOV61igClEMeu2jFo859PIDxbz4pNwDRysL1rIqnLSoSOE/fVFHfZx+4cLlAyoKU
	 surfDqZw75F6fgwJCD8dAH0Hzs1zIapdiSCh0j7ST2W6U4h7QFUfNT5v/ELAig/tUk2j9
	 5VXlK1fpsZzaITpPCfP4CWwKrqpE/n7zLzjga8fXYgage+cqiS0MOEGXsakMcJck4krmX
	 uipoEr9j3e+GIrhHNS3MuAk5D635YpvM/ot4JVV6ALGAaxyUqY6OYINafTY9kgoueAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402456;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XqUYhSlvBHP0cvJjkQW9/TQ+C8BRRvAIssLjdxVusqY=;
	b=iA9Ad3uodTVtVGYksQx/MATXCVftgjs516ebrF7OX8RAIYs/VE8kbkmC7xuWDyhrT73/
	 kBqhKaclBt4Gye4B25g3Eosn5NoK4+8UEE6m9Dt7YB2y1WW829dlL1fkNm5JNdUqeCeE4
	 ZoxoLZ/iNgtnmN1WWS8DU92MALlE/FsTOUPRwKsuuDTmxNs3/gDErIfgYX67U2R2oRJj6
	 Sp3hIeY7Ys479cvXZywEpPfF6hv2PUfUyGtUXv6udOf6/np6FjpW8A43C45xUFfU0m43f
	 ueAMJO0puM4EuOanCfPR/cVxfaf3jEfzP0sVgqqvd2lrNnPrpXFZ77FLi0nDqHCgpbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzLc4gFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14251606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzLc4gFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816941F00A05;
	Wed, 11 Nov 2026 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402455;
	bh=XqUYhSlvBHP0cvJjkQW9/TQ+C8BRRvAIssLjdxVusqY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gzLc4gFDdC6ZOu0sv+F7rWRk2NiMOftk9GfiHJprIWuFLI2Pqc7dGykTrMArTjUA1
	 agIpZP9YEWiGp9h7FQVOQN0MHbwdvnCudqENfZPtvuZgufeXAeVK7ybkkRYl9q1IGa
	 Oj+hZrroux8+ZFSQj0vz5AKrdkFFsdD/KpLbFY5muuQbmfo4C3twOH1A5+YSQ5qKIP
	 GxTiY7pqYIEp5JPUP51+wLGnBvvHR6OiDdrhDMf+5uF/RTSWKRv6/PfAf5x2ADML+E
	 vKzzKATBo4768b8gBoeeWo9IiR2z4cXRWe6oR43GSkSP7g3SNztPHMPqJE/ExVUk5E
	 yCW3JODDrdznQ==
Message-ID: <sashiko-outbox-209040@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 6/9] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-7-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:07:35 +0000
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
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Annotate the immediate-data OOB fields as little-endian to match
> the encoded values and avoid Sparse endianness warnings.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D6

