Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366445;
	b=tzRloGbk8WTbUWINuNmcqKQBZYupp4dEtOG2LihXXxKbESM15011pkCAcSklbcnfTheQ
	 4QykDXCxmJlZdyqy9HVQZLBlKzQeMO5negr9szAjbOpMK4C3IIU5Kn4yHnebf9yaY6Dpf
	 zOaa+NYkkBR5JPqhelsvb5UlMa9RjhgnpOQIgvPdb/r7q9MUYs3ylfNHZ/+woUsjnCyod
	 ymdiwPYK6LlVppK3FyLtvD4194PDKA5CPrU2kc4YdvNGcMLDD+mFfTdWk7EM8GASAZZK9
	 d69K+nGdDHqeU+H1z+qdEE0KwS9UTnusZfJzQC7nMIAeFGJAeedBWhwReKFNSTZ9V/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366445;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i3ti6dA/UYYQPJuEARTVq0tb+GLuT02YgzLxqBcSESg=;
	b=jXFnL9gGfyHjlaiR9QH/7BxIb7MB/0QfkBO5xkkM44fQ7pjsqsoWgI+AgZsboFSsUbOB
	 vnG206HCZmxHWohe+onIUV6pMd+e9FlZ0xyxgFQdVs7YMDHbwZTHCtiRwoOsxuycuRbRc
	 xMXy0NQ35n8RgFlWNUEwqeAW9bImNcB1WSnZ19rFuqbpYtZXTh6owrcnjlpmJ7VELdYhX
	 3Xb8uz8gj4mkhCxXRJKbOLmm7/L128OARij0HdjZohFHlF2qPb4qAYVSKLsR4rSucb8ud
	 dWt8rfwfdnXlcDF4SBmQYSaZ+zQUUP5SkXNYyOBcSnzL8RcMsDORsK4iOdD6JNF/UIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxyTPUtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68159606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxyTPUtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8C01F000C1;
	Fri, 30 Oct 2026 13:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793366445;
	bh=i3ti6dA/UYYQPJuEARTVq0tb+GLuT02YgzLxqBcSESg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxyTPUtl62HSCvagNO3VhBgaIU7TMApEyifpfg4j7nwo6k49NP9rNkF+mk8XBuDZ3
	 ykJ0MIGJNs9FbuP5AgL0M/EP1wNbRPFVxWItATcSoMShgN17Fpf0o8DIcwyudaaGiG
	 dep34N7XhoRHVbsvESDMKL5heCJzFmKwRZJ8bZEfTnnmSIVNaTNDhbt5+Ar50CFjUJ
	 iMwa8DoEv8QXjYOGLCtPlqWH6IPE0l3GHO3SZchNA+wYCAAmwFFwhbUF4LpElm59PL
	 a3VO6v6GocCjRkAjdhkZ14ndIn4628JUEpSA/dZy7zJk9g0vSwoIrmh/E1lgsxoBlW
	 RjPZ2mhiidsGA==
Message-ID: <sashiko-outbox-191058@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 07/10] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-8-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:20:44 +0000
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
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D7

