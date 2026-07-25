Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816D626F29B;
	Sat, 25 Jul 2026 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784996724; cv=none; b=UJuKxnMiYd54siuOYteFuLO1Z4CxoQO6tsSVVtkKbQR2uYUA/6FK7pSW6omkgfmSG4xsiAEvqXDaPYM+uwWZgEe/2f7StQt6weigjbGbpd/BA3XSCyxEij08b7bQoMR9BtmEjiFpu8cMZoN+ZEDWt5qgxvx+cHCyydf4GcIgYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784996724; c=relaxed/simple;
	bh=VjnbyLl6+mCNptBEq1pLvH0PL6yVvhLMD6ZF6rr3xNw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nBcB+sNdkL3CAD1HFWnEhgoW55zmHo2S32Id1MAmxMDbFHZgAiPK1swjODSSdL64yy6YLtRBMsCphcxw0KTkPWALI+RVHQ5TpvcAHHFywHAeyuqrR3Y4Eaff8ptej+zvHtCSTdmT9QTWdkzfJOoU8YOJXjMPx3UYzl6VKPVk3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKLk3CQc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKLk3CQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54181F000E9;
	Sat, 25 Jul 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784996723;
	bh=/p3nfC6w4BBk5XxtPOrk4Cuk2W7sbr/zK6K4VD82zg8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aKLk3CQcc9Demj3dJnyNVE1pEU5Pkvg7x+I9T4DjZzSwrnBdoFUYmOflHG5gJCq/7
	 F6f9p51jC1bRJ/4UPXsc1bD8DLcm8QEQx9NuD90LTquKE1iLookHx81xsSehLKshKY
	 pn/nIml5mwUU6tegbIRV2BS1WYUJfIaf8elmLxpdMBMOWcqbku9PSZL+MuA0b+CYZe
	 YNA1XZQu5Fm3Z7NnfgOa5lMr5Nj+EL/uCn4xMFIjTygubHEI6RzqyC5NIRYsHG8Wwv
	 csLo2pU33l/Rrm/mpMLCoVMY0KQGo/waA6v41vCg9P53c3mvnJgKaYMO7Qgnt3Lb8V
	 pYCPac2PRTDJw==
Message-ID: <e770554d9ca05784abb3c9d1ccd378295f46fa08.camel@kernel.org>
Subject: Re: [PATCH net-next 0/3] net/rds: Bug fix ports
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Cc: jhubbard@nvidia.com, leon@kernel.org
Date: Sat, 25 Jul 2026 09:25:21 -0700
In-Reply-To: <20260725082939.2546624-1-achender@kernel.org>
References: <20260725082939.2546624-1-achender@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-07-25 at 01:29 -0700, Allison Henderson wrote:
> Hi all,
>=20

Apologies, this should have been a v2.  Let me know if folks want the resen=
d for the book keeping or would rather forgo
the spam.

Thank you,
Allison

> This is a small set of net/rds bug fixes ported from uek to upstream
> rds.  I've been working on extending the rds selftest case, but need to
> stabilize a few more bugs and the first few fall into net with Fixes
> tags. I decided to leverage fable for this set and I thought the ports we
> clean and well explained.
>=20
> [PATCH net 1/3] net/rds: don't use unpin_user_pages_dirty_lock() from ato=
mic context
>    Avoids potentially sleeping in an atomic context by queueing page dirt=
ying in a work
>    item, which is then completed in a process context.
>=20
> [PATCH net 2/3] net/rds: hold the socket while an rds_mr references it
>    Port: commit c4d69e511f3b ("rds: Add proper refcnt when an RDS MR refe=
rences an RDS Socket")
>    https://github.com/oracle/linux-uek/commit/94549e4732d8
>=20
> [PATCH net-next 3/3] net/rds: fix rds_message leak in the rds_send_xmit()=
 drop path
>   Port: commit 94549e4732d8 ("net/rds: fix rds_message memleak in rds_sen=
d_xmit")
>   https://github.com/oracle/linux-uek/commit/94549e4732d8
>=20
> These were carved out of a larger porting effort, but I'll follow up with=
 a few more
> targeted for net-net after these land in net.
>=20
> Question and comments appreciated!=20
>=20
> Thanks,
> Allison
>=20
> Changes since v1:
>   - Patch 1/3: re-written to delay ditying through queued work items
>   - Patch 3/3: fixed check patch nits
>=20
> Allison Henderson (1):
>   net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
>=20
> H=C3=A5kon Bugge (1):
>   net/rds: hold the socket while an rds_mr references it
>=20
> Sharath Srinivasan (1):
>   net/rds: fix rds_message leak in the rds_send_xmit() drop path
>=20
>  net/rds/ib.c      |  7 +++++++
>  net/rds/message.c | 34 ++++++++++++++++++++++++++++++++++
>  net/rds/rdma.c    | 18 ++++++++++++++++--
>  net/rds/rds.h     |  6 ++++++
>  net/rds/send.c    | 18 +++++++++++++++---
>  5 files changed, 78 insertions(+), 5 deletions(-)
>=20

