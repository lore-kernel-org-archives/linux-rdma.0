Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A339A057
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 07:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790063310; cv=none; b=hVA9DIq/4hpVQOlYPJZzD2aOCAayraeR7MbqOhFJ0sQIdpOXOu49U7Ml1GnN12aFaCzAAE5H63ocg9IFL9beXItSYa8wDc/f+Oxg0NaDQaJsFJ4kFk/MHMINeEgJp69pblRjlGmqz2J4QxKwm5rTkdC6tF/kt0IRXJW/oCT2M54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790063310; c=relaxed/simple;
	bh=7Ftz7SZ3WrrFxlBDMt/6R2q2JUvNwYS9RU80CmiIapc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TGypKgL1o5pa1eCW8T2vMs0ErrNjmbITMZdZKfVv6LJ183QNd7yZlfChoA8YeiXndQXETHTxqGoJh8PAOpcAB+t+NCWP9oqD0IGD+oOA0SKLMyWP9+Gqt4OIfmmnl72gewIY6vWme6git6l7c6iE2XAxoRtBXh2sy1pQGBrncng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6r3Yj9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6r3Yj9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65471F000FF;
	Tue, 22 Sep 2026 07:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790063303;
	bh=VtADl1XW0WUTNKxRs5EUoi584ewelR9ArG+DA5Hjfvo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h6r3Yj9QurCQhw90fdDibVIsWjnqfuhGo7VHs5c4vJDEhlmb6LWBCgAiuLEIjszyG
	 AEl2qTLJN9AJxu/7fZPqUs+aSloQDuE6cuH00r7HuuPqLvuUkKvVxMHoSLSAW49mib
	 nfRdhGNCEf19Ah//JMP+xtOyhT1xpqky6OnBSYOZ5ji4xkzRQpcqIA591/tQ81Kr/L
	 YOr6ZR1kPOTQ/0rLKwrI2H2bifVLa9iwydPmr6T1HsaOehqyDAcrobWAOVb7Dn6oxu
	 wGgPac5zLc+h05L7uwwXLQrAZ3FhUfANRMKQIuI3lbAVl3n4ZD1ju12QI3J91Qr4lZ
	 3Nb02cADfrRkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: HV VHCA: Fix the agent registration race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ginger Li" <ginger.jzllee@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922074246.20411-1-ginger.jzllee@gmail.com>
References: <20260922074246.20411-1-ginger.jzllee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 07:48:22 +0000
Message-Id: <20260922074822.D65471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_hv_vhca_agent_create() drops agents_lock between checking whether an
> agent is already registered for the type and publishing the new agent, so=
 two
> concurrent create calls for the same type can both pass the check.  The s=
econd
> one then silently replaces the first one in hv_vhca->agents[], and the ag=
ent
> allocated by the first call is leaked.
>=20
> Hold agents_lock for the whole registration.  While at it, read
> hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] under the lock in
> mlx5_hv_vhca_cleanup() as well, since that slot is written under the lock.
>=20
> Fixes: 87175120defd ("net/mlx5: Add HV VHCA infrastructure")
> Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922074246.2041=
1-1-ginger.jzllee@gmail.com?part=3D1

