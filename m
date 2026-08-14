Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F6C194C96;
	Fri, 14 Aug 2026 02:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675270; cv=none; b=eeiNO2DRuda6NxHAqNqyxrNqAMPEylgWtSUwHg1svKnQu24kuzZ628xs9V4WYTmocVnI/T3mltsuG3UcR3EpBZACLGvvJ77912yv09k/65cGaiYB5NajAR5e/ZEgevUfoY3a5sWSSKx1dSDRp3Ms09awlUbNaG+/EleyyElBkOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675270; c=relaxed/simple;
	bh=Z48bvkpMxL4jMe78ug+JbhoY2e4MCvTgMB0uOQB+57I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FU5YPMfmwT8JAo5Ii+p5lGNoAHoVceGXjejh2BcplJWgn5vGnqTK5YWpVo+NOcG9cOJkETcZ3bPnyA+WLKpaslLmnsq1kW00J1Q2h2aBHnSKHr057MTSF3WnO5QnlgcB4P1erOwT4l8bmaBbPGxaVZgu/yrYIXhbIDyiUBwkK8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQPOI22A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQPOI22A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51791F000E9;
	Fri, 14 Aug 2026 02:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786675269;
	bh=00vEJXCsB0j31NwNqpR/ItpXlNHee6LMH4ArfUaRGYw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CQPOI22AZmuLJIfF8XvyMW+j8ezZ9HEU6QVZCipBzhi+VcwaPRWy0uJTE70ODX6/j
	 KiCNFGDKYvRWW6JmNKKhTLk/F+4bKBQ7HHIHPcZScG8FcOCJ4+IkJwfufpm59ei6On
	 OLI5Wl0AF4hiUA1aRZyetQvmh3euffrSK4QjojwQx8T8besfyqUs1hl4kuZnu5UA+H
	 lstmJ9eFd1ktvYCYA2wzzMYjTnpZzSvwlbUOCP0SJLH88UgkJ9f33HkO505SKFVTyH
	 Pn6f+gmaZFXDLo5ZdlcxklQfiaRtqazzeF/DAMMbpytD7f4GnhPCnqbbxb0Ksy/QeB
	 TlljMETIbjbdA==
Message-ID: <faa4c69a1c5e4899566ec525dd92f69e3cf4113e.camel@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net/rds: Bug fix ports, part 2
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Cc: jhubbard@nvidia.com, leon@kernel.org
Date: Thu, 13 Aug 2026 19:41:08 -0700
In-Reply-To: <20260809005103.82371-1-achender@kernel.org>
References: <20260809005103.82371-1-achender@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-08-08 at 17:51 -0700, Allison Henderson wrote:
> Hi all,
>=20
> This is the next batch of net/rds fixes ported from the Oracle UEK
> kernel, following up on the first set now in net-next [1]. =20
>=20
> This is v2 of patches 1 and 2 of "net/rds: Bug fix ports, part 2"
> [2], which contained two initialization-hardening ports.  While
> re-reviewing v1's patches 3 and 4 (the fastpath-lock teardown changes)
> I found their locking needs more rework than a respin should carry, so
> they are split out and will return as their own series together with
> two companion fixes. =C2=A0
>=20

This reply is just for book keeping.  As stated above, v1's patches 3 and 4
have been continued in a separate set:

[PATCH net-next 0/4] net/rds: own the fastpath locks across connection tear=
down
https://lore.kernel.org/all/20260814013501.43760-1-achender@kernel.org

> The two patches here are independent of them.
>=20
> [PATCH net 1/2] net/rds: reinitialize to_be_dropped on rds_send_xmit() re=
start
>   Port commit 7f52b9968d79 ("net/rds: rds_send_xmit should INIT_LIST_HEAD=
 (&to_be_dropped) on restart")
>   https://github.com/oracle/linux-uek/commit/7f52b9968d79=20
>=20
> [PATCH net 2/2] net/rds: initialize i_conn_path in rds_inc_init()
>   Port commit 0ec6a520da4f ("rds: rds_inc_init() should initialize the in=
c->i_conn_path field")
>   https://github.com/oracle/linux-uek/commit/0ec6a520da4f
>=20
> Questions and comments appreciated!
>=20
> Thanks,
> Allison
>=20
> v2:
>   - Patch 1: the comment now names rds_send_remove_from_sock()
>     instead of vaguely blaming "the callees", and the restart-time
>     invariant is enforced with a WARN_ON_ONCE(): entries still on
>     the list there would keep their message reference and their
>     RDS_MSG_ON_SOCK accounting, so a silent re-init would orphan
>     them.
>   - Patch 2: for loopback the field held a live value written by
>     rds_send_queue_rm(), not garbage; rds_loop_xmit() now uses
>     rds_inc_path_init() so the re-initialization keeps it valid, and
>     the commit message describes the two transports accurately.
>=20
> [1] https://lore.kernel.org/netdev/20260730041629.3512480-1-achender@kern=
el.org/
> [2] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kern=
el.org/
>=20
> Sharath Srinivasan (1):
>   net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
>=20
> William Kucharski (1):
>   net/rds: initialize i_conn_path in rds_inc_init()
>=20
>  net/rds/loop.c | 6 +++++-
>  net/rds/recv.c | 1 +
>  net/rds/send.c | 8 ++++++++
>  3 files changed, 14 insertions(+), 1 deletion(-)
>=20
>=20
> base-commit: 4fa4977a0d900f936bcae5cd2c510be5554e8dd6

