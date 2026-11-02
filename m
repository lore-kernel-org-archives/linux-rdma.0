Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637260;
	b=iAsPFgReuWaQHM5Dr1F5enmMgjZb0A9oaMTyJfr16mTN2D85/aRlqPjBPhD8L0Wv6KJ0
	 hFqbI2tdBjsDVqB+EDLxcBcCJpmy8MvrEKwAe4qoE97oVxExS+iBEehxc/SLXXrZmZq1T
	 igLG1jWPZDz7zhO8kedzO7y2j/3SVdw6lxlPVA61HEzMc69waKjqilDrVlJQ3qd96zSEF
	 MTiRg+qw/Od/SQSY6TapGUaPiwVJzpki9VJ7/6tUHakLzCa2Diq29keWT9ImrzyDOGpWF
	 rozIMruVg+tEL9MMbKwssskl1dfGzQLH7dZ/Pxsgb2YqoG56FUVM8qn4f0M36DYCOpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637260;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zdFdEVZn8tZIiNp17e4VGcjEuKHI23GPkPtAD68SBKM=;
	b=Jnv+Bi2VxXCXIZjABnw/A1HuwqBXjXcrYLbLxZNNXtjmhv8txET7nSRJZB2V84rajh4M
	 +4fFy4jDQv1DIGOt63x1mTYCyIkRFjBAv6IkAvzyN4tZ5aLQAINBb+4DTY08Y5TGuP5dY
	 iLLI3jpVSPVUdmakjsnd8B9ZITmttHDbI/XNXZnwonp1GbQ5YWVL6A+S0VzMgP2iVLxea
	 UMsh/UYJL0UDp7/AVOnaMJB/tztAWuWmp+spxF0XcboWoDCxcINxM3HfraptZb3ICECUL
	 Wsh2P/03JQxi9GjjCJ6xu3LbxI07ZIyhd1OivBRiJFuXIKSnsFMl0NFoWc9lmPoZsTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gqe74xo1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B02606A91D
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gqe74xo1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A594F1F00A17;
	Mon,  2 Nov 2026 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637259;
	bh=zdFdEVZn8tZIiNp17e4VGcjEuKHI23GPkPtAD68SBKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gqe74xo18ntrTYJ9P4nkr49cg2Zgcjpt0Nh89jDXHWT8DnmS3ZHKr10OOm5ISMbMp
	 MCAz+wSHvbccWqxnaCOG2CDpVUVWAz99Zhy3fqF8HpzxHkXB/Yo3yajzd2B00ukjZF
	 AMx6pb7SkzZwRRU6sZSwP2dawBRpGGnCz8hNw/ea1pB7Voa0HvKXHZKrgGjv4rpAXL
	 lsj5GtfhhXmvQ6mHop3Dw3bHUJ0H+x53kYMsYtqUtYzW6Ha2JvFguXP1+BsRnDFbiR
	 in/LcBEYiXSoazn6SYA+YBqIps4iijZfv+ukuNIhoST3Z012jfhwHM8JazG84+uvuq
	 nH1f9BryetiLA==
Message-ID: <sashiko-outbox-193755@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 1/9] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-2-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:34:19 +0000
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
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D1

