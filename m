Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0224252A8
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391411; cv=none; b=QBh8jni13IB823Vpb3nKNzotF+2vIdKujvw6I3ZP36EimH383XltwC7n6SedADkrJrJTZUUOKAYEiU5ratYlLQ2CbRe6dJEzRdhbC09DFbnfBQW2FQUEAae4vrQinjWR7ehTvxubn/vnhBxCWx6F7HvebpdG5hLm5l6QVxQnW7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391411; c=relaxed/simple;
	bh=EBPRpX1gKowd5FSpoCnapUdMxakyWaJHqW4K7E/C8k4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pO77S32JZ8HWSKehq4ZAvU+vulQGSgNLgGYXGMsbT5FIcFMFd3uqkTX31mgPgRl3zlnckcIrOo/vcCTyLh8NAjPJYFwDnDbj9Qnwhs1gGIkVayCMYvBjqj3vskABE3UPGNGrKOALHGFppx1jYMgPZWDAmRhBUVQfQ4UqFN5wmrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPxbZLee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPxbZLee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ECC1F000FF;
	Mon, 14 Sep 2026 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391409;
	bh=EBPRpX1gKowd5FSpoCnapUdMxakyWaJHqW4K7E/C8k4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YPxbZLeenM87EPEHTkpKNdP+B1ICARw5EseUlLlJRI4tGQzt7eT/V9Xt7ilC8I+aV
	 k0Tl8gxUPc0XhD3sjzH1VZJ0Osgkc2DeR2CQb6Np6NRufwMrAUaTOlhk0kYfMNN5KV
	 esbiS/dcXhSh8JUA379SGflFJpeBZv1PQUN0j8f3Q85un3AiWYl4jG9WJoFCkDEUhN
	 l+JKW3QkGb5SDAV6O1AVgrYSscQgA7W6oLLAylfHuR7LXcqC7nKRWtCmJgobXC/pGT
	 gdUJfGspajx5oR+qKnsfGyP9YMnzNk0uRVdWBiPJFtbj0vu+JI9zR0P3v7E1p4n/gn
	 G40s4mt5mxsHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/srpt: Fix srp_sq_size documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914130536.19769-1-serhatkumral1@gmail.com>
References: <20260914130536.19769-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:10:08 +0000
Message-Id: <20260914131009.23ECC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Replace "Shared receive queue (SRQ)" with "Send queue".
>=20
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914130536.1976=
9-1-serhatkumral1@gmail.com?part=3D1

