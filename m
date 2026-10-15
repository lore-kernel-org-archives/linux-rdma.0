Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA132E9730
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792028018; cv=none; b=tfT1eX+jVF7LA5LrFU5EMJF0sHBKgtqJ0LMQ2s+od7l3FcvCz82RdZSsBG4vo2EKwEseu7RkdlhjzZA+Jj0LO17BZVd9V5t7pUgCzHLokcdjHg/7n2pWfWr5vPlTtsT6wRyvBQz36n9O5w1JyKxbYPCQjAZpBHifybZddZbn85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792028018; c=relaxed/simple;
	bh=K8xcjndh216la0x0O0vnSkWVPUt5KWVo7lhN2vjcfxQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QkbaH8ISJhExs5kc1bOX6umfLw1dvEEPeXbkv/buZZq2cizQoJTCuJNRjHMrOM5wgF0FRQ4KMb/FeHox4XEG/zs6D5pSVhaokVkKynom1Ow+ZEQLgFsoPiS6COQxUgvXXZIrieBVxoTaji2s5dffbLKZMJsK6wj8Qnbkrt+hGkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z94AEay4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z94AEay4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0741F000C4;
	Thu, 15 Oct 2026 01:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792028016;
	bh=K8xcjndh216la0x0O0vnSkWVPUt5KWVo7lhN2vjcfxQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z94AEay4sxnzBc94VMFVvtEebyItA0WuK/1ZDD6GHvHmYd61qF7O0DXP4JWnq8sBM
	 uVHZCmKBYBlF9PyqRM16Zg9QGdM8O6lZUffmnAQUamFKlAbeJqRYKOKXBhjbFSX4/I
	 J0OW2wF7tqhtkO7qSMTRk5Y5+lU6m8tl/RSUABwIAlEgQoRTMjsivoOWiUwQGk9Wh8
	 UFhOR8wZErNXZW75LkfxowfMtVBUxivs88dFZ0iwsKBTjlZGSbvE1G564rbmRYxNFt
	 BQ7F3HY1YkX9vS9h8b615FwsfnlD+d61hH6pgDVvl4uiFMTV5nd8GVTcTlKBja2C+Q
	 IQGw/6E1DFjEQ==
Message-ID: <sashiko-outbox-172099@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 2/6] RDMA/irdma: Register irdma UVERBS
 ioctl namespace
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015011940.4122452-3-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-3-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:33:36 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> An irdma UVERBS module is now created. An irdma specific shadow buf is
> defined for CQ, while QP and SRQ reuses core's uapi definitions. This
> works since core builds shared core ioctl parsing tree first, before addi=
ng
> driver specific `uapi_definition`.
>=20
> Destroy paths are automatically handled by core dispatchers, as objects
> are now registered in the parsing tree and no additional driver specifics
> are needed in destroy ioctls. Resize, Query, and Modify continue to go
> through write() cmds.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015011940.4122=
452-1-dhu@x6u.co?part=3D2

