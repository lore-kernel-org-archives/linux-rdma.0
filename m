Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705169;
	b=yZHN/T05BcGWlg6Eq9YPCUCfA7EI9EdAYQSR1i9X3iFLEEBhIMadqV78y8u4jAUtoMDa
	 NTrJMMF8Hhjwn0/BANfZNsVkac3i4FM0J5CibNiwu0f9ehkdS7GWoNuyrPg8JBSF24kf6
	 0ExuA1orNn842iuN76cvse7pQM/080oki3EvxaEMBnoCiwtFtIig9AAjprVK9Jrti2Vrb
	 COxfQ1HMw6DPlK1s2RaWL1TiF4NkljYwHRAZecm+UeWc7uEt9RYqCbGRYwrgIhwzBuHx6
	 rPfYBQcPNMr+uclDHIiVjPoRCFIxAAUFoKQMGnolrhuDhEuzJvTQBM41jA/8P50nYcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705169;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sQ53E50LdACJUJWsFd5DMMXoEFRfd2r/t5qiPNPUTM4=;
	b=KfMy71uuS8f8OkZR9yJokkYX8xZzIEzphSuwKpaPnrU1bFRqBgNlUIHlxZhWg2/n6oe3
	 b0+vCi+5v9+LwARj50FsIq3OsL/fnoHT9QUPimJ6zM9YKFbbj26ClAWvT7cO+Ebuc8xD9
	 Adjkv3fcUqBTSWLEgq1BzUzvqnzM/hygrtbOR0Ukep1CDI4CUugJYDwnLT6T5ovVRorqY
	 qyuTaEq1p1RMJoOK84laoNOEtQbF7cdaaY2UFiOgqD5vZhgBw7qbAgtVVLM4ydSA55rMV
	 EtubrDPd10KZpVq1SuLy0VnWo5akhf+2bu2JQlGuz1SYIseqHP3AqS2FpRzGG2TqKLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYaqi3Zz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E94606B11F
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYaqi3Zz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B211F0093A;
	Tue,  3 Nov 2026 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705169;
	bh=sQ53E50LdACJUJWsFd5DMMXoEFRfd2r/t5qiPNPUTM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYaqi3ZzbxecMI5EuVfPpXHbmqYIzk1G68lbcixe3cFzOtdspGB1vT9lQSbWWmf3C
	 mAZFgwaMsXxklpA1tlhPG4akB5aCJpkkg/t/US2cg1K/rVOMc+1VTtrp8RUBjfF6l5
	 UQ0whj7YUtanYxjjYZXzPy/3rtGorBFAjnkgwrcTGrwHSdh0+J3bovdQ79M28x0BPM
	 b1Bn1t+7kGFTIzTUVnuik9g4KfZwzxvdHahr/dRVuONIEhgxCHrTBH8OWv2a/f3UYG
	 R65nNxQdVwBP0U5D+MgExrAek41JMQZQx5wnNHZSn5Cl9E2tmub4NhQwprm75y2/qK
	 xkxJDW+OuCNOw==
Message-ID: <sashiko-outbox-195145@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 4/9] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-5-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:26:08 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D4

