Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093418;
	b=QtgiTrfA/kdKoQmhWJ/kYxC28XpZfLHcexLAk6bXKlPOZGhctsz9A9gBMMkLgWXBZ4rG
	 qxnV63jFuWCMy00ZsWDjdVIZgjxIFnInWI+Cmv9iJ479dSy03tr43TVQHvILMkwRjlxiz
	 x2k8B7RiNRUxUDV9/RlakuIiTZ4eTtwtJmkqmgqK8o0fKSQzh9TyQPH1iUlShJDQMVpqa
	 4LVawlroidRLeUUs4bpfs8PphpzhDQsjHu4VYsdXVvbrBQnzDmbqN9QTC8VCbHJQS9i1r
	 Y2KKX7jCZYfBwkbCbIo9VzvC6P3JT1jls/eaGZnyeZGXc1ekHpYQ02sCsl29l+KdgZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093418;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Y/qg3qHIBvNqRN9GFHGv1XxuFSNYbBDkADxZGb7IZ50=;
	b=kxgXJDL6d3gvxWrzxSPNPnUUY7pJOJyvFzHoEebVswDG0+F+ZKV5d5NgB47UvdRMpTBh
	 poO1ml7CXFlz2bjWqvVR3sPeYjDnKCjWFsLIjEskhdNC8vPqDbgQV2nocRX4KibsOo34q
	 +D0GyVBBYLi0rbkcFfW+uPFdGprTOoW8/g4LrKIOZ8apQYraAN4OFCdNnVtp6BGVyr07S
	 40agBT2Tynsjb6O2ppM3+7MUG7uq3tWBpmebYLeDaNG6fssqIboxmeVvghOvPIzMznC3I
	 WRWv+3I5ScekJiD4bSh0ejId/5RvRNfGS73EmAc39Jp4szz7O+VT/3QJf3hRHggxPOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLKDKgys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD80606A31F
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 09:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLKDKgys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB001F01825;
	Tue, 27 Oct 2026 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093418;
	bh=Y/qg3qHIBvNqRN9GFHGv1XxuFSNYbBDkADxZGb7IZ50=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iLKDKgysXovBMC71vt6FBuZdh2D7KnjtFO/OJDKLmqkUcO3pqzO7kZnhAAcOFA7XD
	 OeGl+tHSyRy9jIJJ+lI9aHwG3CW3yk95Fs1TpdkbFG93ZX5b7Wi939ttibN2rF5GW8
	 A8uqZNW6tdnCukgJri2ow04OnMcijwj13Bqg88jhBcHxD2CnVWlseN/8MsUlT9bGOz
	 E7jLRZ8TyAP11OFVzT3AtYO0zlbrnZA85j6K3QLcEOh6YaBa5ISlfVSptk7i0a+8oL
	 OK0KmUanjTbJ7+yy9gaiNpYMEP1JtLfcWcBQ3QQLIuAS1hNl9+tlCu8Hc4McMZRduM
	 j6k0F8c6h5mIw==
Message-ID: <sashiko-outbox-186324@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next 1/3] RDMA/ionic: size the MR PTE reservation to
 max_sg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
References: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 09:30:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Amit Kumar <a.k@amd.com>
>=20
> CREATE_MR with map_count zero makes firmware reserve its default number
> of PTEs. A fast-registration memory region (MR) whose max_sg is larger
> than that default fails at REG_MR.
>=20
> Pass max_sg as map_count. The virtual address (VA) and length stay zero
> because no buffer is mapped yet.
>=20
> Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027092353.1961=
552-1-abhijit.gangurde@amd.com?part=3D1

