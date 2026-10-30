Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336051;
	b=N5ESBSKkfMf1D2FIvD1o62FMPQPwe/3/JCfnvRJR7aFHTS/OLy8M7q2xwXrKux0iu9f3
	 o/nGVyt/0+ZX8uX+gFPPOoENcVg0V6r0Sc+JyNIJnNlTf/Cpw+TpcEMRrT26B5xYqg716
	 lTth/ptWJvSAfgozli/yYaABi1n/2HKOGJaiqUU0NA4J7nVfDtp133v3cGkN8l5F5u6Ab
	 MZZpJAmmfZRfVKkObwToQ9aVKWz1QEeCvDAHpki5/6STXrA5F1IzobeyVj23IN87cDscw
	 AbLDGsLUBk6qC/Qlgn6qnAP79QirddLIyc1ZPNx7JyKwUbmWtaTGkx+UPqcPFygxV8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336051;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GRZhPspfGoIoHDro0fqKFnMZpxaec0nQJN7tyMQ27gI=;
	b=tFFVVUUkCmaaNqi9W5tl+BPq6zynmVvMvPvQP/jRUvfAMbbdH4r4Cvw5q4T9xEDdZOCA
	 TdGImYOJ/MZH/zsl1LD+wiituVgJG6jmA10L2OmhLPE/nYXilBvKYqgiNrPU0B0pFaWan
	 vGmQ6L2VROqXi8bCWhyE21WcYEXAc42fu4jSIk7Nk0aANc/oizuGJ9YqBaDyUuuk3aZny
	 kyRJDPv7UH/nHsu/inNz2w0yJ3a9+cH/vqaeBxZYgu3Pl4cw1WP1BiL8LwTw/bSW7DVzL
	 tKXlcU7B7+MhDQs+ZyQIurWzJEg4rHEo2s1ydFyweMZqqdsX28EuRZ3CyO77Epzo2mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mgft9yKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC6606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mgft9yKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1811F0093A;
	Fri, 30 Oct 2026 04:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336051;
	bh=GRZhPspfGoIoHDro0fqKFnMZpxaec0nQJN7tyMQ27gI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mgft9yKKCsK1FxH6oG5loozp+9nydnuS3ZpM9hRBODYpiNO58+zGozHBU+Tv+N0E6
	 bNJh0iW4R43tHLMGOjnPQLQOLzZJJbEd8TZpoESP+9V9OiIT56TEOlyWp+rqbr3hej
	 xubWvmnbvJdsLdEzs4TQJxUc9D3aMvcvxLJbXYROFZHjTC7ymzfOj3278WUCI+znPh
	 nTs3Q/M8krA2hca87sHl/5zitHPug1mYlHKi3SlZo2ammEnulUWcD2yryqNMOq0DH2
	 jQ/gjkxU5kMq3golLcJtTZ7V0jEpth8w8oSDhxd5ttQqKYSRwv/SWKvRrptvlT1St9
	 J+X1rW0TRTp4w==
Message-ID: <sashiko-outbox-190416@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 5/6] net: mana: Allocate interrupt context
 for each EQ when creating vPort
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260508221202.15725-6-longli@microsoft.com>
References: <20260508221202.15725-6-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Use GIC functions to create a dedicated interrupt context or acquire a
> shared interrupt context for each EQ when setting up a vPort.
>=20
> The caller now owns the GIC reference across the EQ create/destroy
> lifecycle: mana_create_eq() calls mana_gd_get_gic() before creating
> each EQ and mana_destroy_eq() calls mana_gd_put_gic() after destroying
> it. The msix_index invalidation is moved from mana_gd_deregister_irq()
> to the mana_gd_create_eq() error path so that mana_destroy_eq() can
> read the index before teardown.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508221202.1572=
5-1-longli@microsoft.com?part=3D5

