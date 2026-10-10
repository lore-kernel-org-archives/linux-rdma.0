Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCC94AAC4C;
	Sat, 10 Oct 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643329; cv=none; b=DVyu7Yxa18aSNqptVImqrKWkisQwWjnjI8Kpc4dviuZixggjTu9goo/ei2Y4sgYn+R9iNLOQgaiamCIPVHU3I+EIKtZpZhwG7EIwBcEpYoSeCTBpdoSxqpHJWFK3LE3NGG97otTd8qbLGbb5XK1aa7NDbiFisMTJJqoEebImCFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643329; c=relaxed/simple;
	bh=04Il7/HubYTqiKaeX8sYqkZQyMV0AT37y4iVfQw8cis=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oGwD9czV5CNdGM2qiEXLxKDGHO05bun2eDFb3fKXs+sVpMr1WIgFqMBbcWct6n+M6QPu6kfDQirjeXXt1e2p0RAiIQYHqvCPCU80GGpvR/cGIwqWnuM0KQN2T5/pVhT2j31xbvp+7P3hvrcvjXg58RbwlSg+UmQRicdwmhsPdas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXwMJkvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXwMJkvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D317C1F000FF;
	Sat, 10 Oct 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643328;
	bh=04Il7/HubYTqiKaeX8sYqkZQyMV0AT37y4iVfQw8cis=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AXwMJkvBrQ1Uz6Gxpj915/lKfyWFl1k8hkaLt1mtD/lg8/P/GeJTkBM9GVJq5yQtD
	 XKYi7zy9Aio7OTdpdjUJp8P6A85tJL6k6ENcetRy+JsNprIL0lN+x3kF7qTYh6r/K1
	 o5EiJbTiIFOctMYv1hYGCRYtiyEYB3DUnhFazTUNqWKCunKdgTQGgp9IcBdsLXpyHp
	 OYmGlmf7eF8NmNPgtCn6ykvHMqfeUmEpEjvWSBe3SBvUlqe+WqP3LLGCebxM1xjiHE
	 V8f/oPPu0zJeJqiQ+hpBB04uN3t4hPeFq4mU0GPSYSY7Hw0yJktCHUtUzQiQhxT5h9
	 TQWut6grohwVQ==
Message-ID: <sashiko-outbox-166662@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 06/13] net: mana: swap queue sets in
 mana_set_priv_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <57c94d333f2c3168c5d68190ff2aed23daa39a67.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <57c94d333f2c3168c5d68190ff2aed23daa39a67.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Rebuild queues through the swap path when USE_FULL_PAGE_RXBUF changes
> the RX layout. Carry priv_flags with the queue set so allocation failure
> leaves the live configuration unchanged and rollback restores the flags.
>=20
> Retain shortcuts for an unchanged RX buffer flag, a down port, or a
> configuration whose MTU or XDP already requires full-page RX. A failed
> rollback closes the port.
>=20
> This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
> RX buffers and page pools live. The port-owned EQ pool is shared,
> not doubled. Device resource limits may reject this temporary peak;
> allocation failure preserves the live queues and configuration.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D6

