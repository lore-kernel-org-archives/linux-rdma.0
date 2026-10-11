Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666FE4078CE;
	Sun, 11 Oct 2026 08:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707996; cv=none; b=YCKFeaJ90RKaPDZARQxZDhUizW9Qfr5WGo2xSslvCxF6+13oGPdkZKrWzKpsBzuj+SVZsl8I1YOGJO8ec9eNvOKH6uTrShxdvYSkfQdutz521W+ODCRIOgKE+AeDnvuVZB+NlMW04WEuwuCG9C9fbHjN3OZBFASFbm8hmEmXaj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707996; c=relaxed/simple;
	bh=yoq6HBGnnbteGH0zv2Wmj8qc/U1efckiOcdYXGyysdI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fHQMGvfRYRJGIK0NF5Cn1aqHkxUBuAgzz9SLi0Le4ZOEAxeOt2d6uYkSvKfUoTf9/Y1bfJskhD+Yd8ujdRXAVfE1GjtuvdJohbre9CW19CtD1zEtQM8iXVIOwOwpNQkuY4+/UnWDuS8XH3w73jPZrq64RceDrOy9PMNtDwVyhEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVe8xgyk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVe8xgyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D303F1F0089D;
	Sun, 11 Oct 2026 08:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791707995;
	bh=yoq6HBGnnbteGH0zv2Wmj8qc/U1efckiOcdYXGyysdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eVe8xgykGykeNUjrk6A6jpCWO4q2smMA1fxzP0g4eCV5w26oSfzEkahl7mECoYcpJ
	 oYciup0xr31ZBPeDB16Fhc035gVea+xdSexCbawMnj6jFiUQyljP9+Lr/mdmeCxk5S
	 RuZzYaYbykQwep1lEf/2Pi27DJ7YlvFMvwNXHvJPDz2355OJKwQzbIsyEvIf+2iD0m
	 5q3jMELkDXhGkO3dokNiRDBN0wpmwPrGYA9TC4fqenWUt/D4B26BfyjIxYK77ecTMN
	 J5Zvs2GI7cH0zWzNeTJ25VB050k5LjJQcywc3VE1+dTq054nQFYg9AakmKVmoSi89/
	 zYvEN0Eqsn3Ng==
Message-ID: <sashiko-outbox-167126@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 2/6] net: skbuff: add napi_pp_get_page() and
 use it in tcp_recvmsg_dmabuf()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261010083935.3274178-3-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
 <20261010083935.3274178-3-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:39:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> While napi_pp_put_page() releases a page_pool pp_ref_count reference on
> a netmem, no symmetric helper existed to acquire one, forcing callers
> like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
> niov->desc.pp_ref_count.
>=20
> Add napi_pp_get_page() to pair symmetrically with napi_pp_put_page(),
> and use WARN_ON_ONCE(!napi_pp_get_page(netmem)) in tcp_recvmsg_dmabuf()
> to match WARN_ON_ONCE(!napi_pp_put_page(netmem)) in
> tcp_release_user_frags().
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010083935.3274=
178-1-almasrymina@google.com?part=3D2

