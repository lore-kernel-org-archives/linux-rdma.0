Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067988;
	b=YY3+tAkNekSNX0HpeV1AW69LAw/qQxy62gKg5kADz08WDPCGjHWE3O/t8KzoB0wbu0Ld
	 sm5/yz/y73G1uZQLLkVwlhbIrOkdwa2o60MR5h722DYCGqLoOoLipFCrPmp/nTxCHc7v8
	 jtpIlBFW2oAQQABYtBNl7wlY69gqm5xh5mRFbHhbbeQQxo3eVrYp2Bp8O5bU3e+JRP+1d
	 qFtPoOyd5LDTFL7OgWbkWRPAnVemvZ4hbiDo1Mm6HZ8TMeus8pcq17XaMNIjRiQNdEQTq
	 YES00uNh5YfmFZAwg7QxKgIBgMz/VbyQgxqFkU+LcZpDJafsuJgPGqiO0o9NcEYgaBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067988;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vldVF3fo/3YtKiS25VsA9j3is7CtbUR3Sgan3hCzHrM=;
	b=I6B1Q2rSzcPPU6putGlOrAD5T7KTmWsN3LmB4lxaym3m3oqjylQgWIb/XY3dDK4u4ce0
	 7DOHKmkrLWzxIQi3ItKrXU60Yv3JWLUaHx0JcaWi9RUClTItUDqvPMb6yABPPNMOcRr0R
	 56iXkH/AL0S5Uty4yCiwt+enKukVHzleCXIEHBL0Q8CcCZXHLOzJV5Bx9uu9xaWEfSoWU
	 Y132lWhzB1+Px8aCBSjwE4RbAO++RNbvyKT7wSRUBp+cyu09+VgEwbbsMUZdudxxrMQth
	 Yi4kRVLM0Jo3Vq/iMaI6ffFLltuum1cqAHeDmziNqeNnkhkV2i55hOpT3JhhJ0BuCXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PK5FYglz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9808B606A324
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PK5FYglz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A23D1F01825;
	Tue, 27 Oct 2026 02:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793067988;
	bh=vldVF3fo/3YtKiS25VsA9j3is7CtbUR3Sgan3hCzHrM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PK5FYglz7LFT7/apJVLjLvDdC/ZACis+HCu4+EX+1a0vPjXTYyOV4TGL/2Tokywu4
	 Xj1dc9NVtog8FpEcV7X4wbw2HVsuXDrrmjuZ92wah6X7pcCTiK8Ho6Ydn42s1dC4Ki
	 wI5uglUxXROPRPweJ13uhZwJGJegu77cidbS6xY76asU+RQpLuUXixnzy745y07H8o
	 aOyaf2rGpDCRAQ3LHOSyW/Q5XHShINsXj8ZZg4XidHJ8kXPqte73X8I/4jEqlK6d6k
	 PhrQaFn5aK7MTVZqUeYJUFOnDMsS6hj8zBoX2DTpFtzugcULzjaJxE4dHBVU2JXVzc
	 UVDFwoJ3EtTHQ==
Message-ID: <sashiko-outbox-186017@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 3/7] RDMA/zrdma: Add internal headers and
 hardware register definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-4-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-4-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:26:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add internal header files for main driver logic and hardware registers.
> These headers define the structures and constants used by the subsequent
> implementation patches.
>=20
> zxdh_free_rsrc() uses guard(spinlock_irqsave), so the lock is released on
> every exit path. zxdh_alloc_rsrc() keeps the explicit locking, as it has
> several early return paths, and takes a pool name so that the exhaustion
> log identifies the affected pool.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D3

