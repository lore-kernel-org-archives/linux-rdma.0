Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0E02ECE86
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616418; cv=none; b=GUT/f+1ABJaYmOf4L5YByg1z1cAZzc3mTS6spx6ugTwSmCM8eK+yzNJxKGRi4Uov1P0NK29khN9u9THMto6U/MzaVj0A6HNqRltVqva71KQLcLmNt8h8rr2YsmzrQ4Bcdh2g/MBLERBboTRTiAKfdXHRCh0V8FpU52OtBjJpcCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616418; c=relaxed/simple;
	bh=jYvcrWEmyw4Mi6FWCgGcjl8Fq+rT1kOSN+q5/yJQGHA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Y+qvhN2gzU2dhOB5wSwXSUfK3zVx6gP6FVsEg5ImgXOrnueLm5sNPCYkkNsmVkDLmJm9s/uQJwL6yzw24GGVIpYtOG4ALIVFVmkYip5diBZhOmU+dzGgJbXeMOsK4JOTxvRQMFP32pZQsfYCS3+MySpm7lhZbizd7QmfS6+jFG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7UjafTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7UjafTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405741F000FF;
	Sat, 10 Oct 2026 07:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616417;
	bh=jYvcrWEmyw4Mi6FWCgGcjl8Fq+rT1kOSN+q5/yJQGHA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q7UjafTv6T66GIE0kOQZFH905CWYbB7h5auu+oQ4kgOAr2EPFtw3Dd5hjacWl1tR8
	 be4qkuNnv8pPLQHMYkQadiEvO5Y8QlDNPiA+7C/RzDUABDEf0o5zNap8teCrcSOP6h
	 JxYKbOLxmOLkLOaO3aAVkXSpbZ106ftYYjBnlW2yxn7g05ns6Omf5r8ieIclQhVWYG
	 4imE6lr60di2tD9q9dIac9Jnqk92C1URLyNPsDiAsrJWr9EJP48A/lShissvDOI5dL
	 nL1KVNblNfqYco5JmdPrzYH5a3MAfGj90FeZ1GPDEFJxExYUpgDzLpcg13DncYYw1P
	 MljYTXCra1qug==
Message-ID: <sashiko-outbox-166305@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 04/10] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-5-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:13:36 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D4

