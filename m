Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCA74BE424
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387982; cv=none; b=aIrCarHlIq3twirTTRPZHGIZrXd9aniSYcD2Q0oh3Hxzv+0h1lZGaG7DmEz1Bn4DogABOZRlzBBnCtRHeFrtI8EDQa+BCDJh1/8dLOUb661HqKVirnMN9WPcerQMorfkVcMGcRuWXFz7q5kLRLRbTVu7ZC+JUNiD8eKKz8wwBOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387982; c=relaxed/simple;
	bh=+uQbwNoy7sCHkZzQGqs2N7LbKrtaA2EAJ6jsWFjS/fQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rPiYiqhVuXAG732vszTRP0gGYa7et5yOnUTXFyDYf7K6WlCjyT9l368BMIDwk85CXcAiM9M4ggspQ/QBYS9IBKA21hgWh8xKGxH2Xi+OEoAH7fvkkvOogWtpVewFeajmB1McRSobZYaLU5gr90iQxKqIApBMFfrmp+3O9xYlH4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HK7KG/JB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HK7KG/JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8611F000FF;
	Wed,  7 Oct 2026 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791387980;
	bh=+uQbwNoy7sCHkZzQGqs2N7LbKrtaA2EAJ6jsWFjS/fQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HK7KG/JBNxlrBtVWJnUh+z5sM23ppN69uxPaUJOKJBBo3owcl07HfTfyb4MPXs3uc
	 U7WOib81aVztAonOivY/KuDCz1Ub9qRSBeljc6dXM+v2NKmIBII3+XmBqKPHhfYZjD
	 GGekjIchLhqUAuJ72I3m3jwwxqeHm69r/QGu2en8KZLgeKI+CK6DSEJj+qEZGbkjTG
	 zMx3FbCTUVnOMeIkCSbxiw3mT7VRNcc8L90zDz01WAgEKxAse6h5Be5fMmxKZKwpnD
	 4jrch5ry4PGi1I4qE4ojbcO9F7GgHp+scpQ+z9Ea/dSns2mHEsnrtQh3ImvyjJO8tJ
	 +Ex2O97vW4zYg==
Message-ID: <sashiko-outbox-163158@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 04/10] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-5-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:46:19 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D4

