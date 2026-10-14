Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622664AA1EB
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017406; cv=none; b=mtcx9XaZD1v6Y/J1ialML5oRM9c0CDJ9aulp7s/93zGUV/pNkjSxVRtPkd+MItnN4IvQmrxdhiwO6sr/di4ipsizfgy62/IJVm7+neO+J6923Pa22yqr3xtpqrWNc9IzT9zdioRyf1n6jh5YM9AcMAT5YVu4YzPKeSwc+RAeLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017406; c=relaxed/simple;
	bh=lLgl8VbvZv0w1zAu/q+Mps2iywiMUJC+Yid/91gf+pg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=d8HR3uWtuvE06eGn53h6evNimxfUNV4JuxVpOuFn4aAN3mf2UrsskvzLkcQupCcQmDaFxnymvvp7fMa46KMZfvbo6X3F62LXhxhUCXc2X5mnSgvbgMq1rPErzAorqLp6DVdbY0v27Hs8u+wTkI4JeM+WnZYZ5jb7StZEKfpsz98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHO4GIAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHO4GIAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BC81F000C4;
	Wed, 14 Oct 2026 22:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017405;
	bh=lLgl8VbvZv0w1zAu/q+Mps2iywiMUJC+Yid/91gf+pg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RHO4GIAhsdwl5GNVx/ZqN2rZ2IjWBxboNSp6UJAjmP95WtdGjqkqlp0QHU+Nxu4Ib
	 SDfPjBfvl2EAUfjPkcLgoeG4SahrP0uaOLMWkiqVYW1emaq84e7EW9o6qwYqUCG7aI
	 lHST6mjzifJPS0GIQEZyZx28XH9u4B7LzmEV1SsGKa7DS+cZg7SXwPyGxaxuIngSSm
	 EmlATkJ5Ek3eKT37tyS3l5wM9YYQirBx/Zy9dRgKNcnpACgEWoqvIbUqLoUSqL2Pqf
	 fFYR5cWbMqz4wD8f3/UNovPw+fGylU7AagrVmZFACMGwCaEovi2yXcp+OKMsranXyK
	 xiuWc+TPrNO5A==
Message-ID: <sashiko-outbox-171979@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 07/13] RDMA/core: job and job key objects
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-7-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-7-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:36:44 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> An unconnected transport demultiplexes incoming traffic on a JobID rather
> than on a connection. Add two objects for it: a job, which owns that ID
> and a table of peer addresses, and a job key, which ties a job to a
> protection domain and authorizes a queue pair to act within it.
>=20
> A job can be exported to a file descriptor and imported elsewhere, so an
> unprivileged process can join a job that was set up for it.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D7

