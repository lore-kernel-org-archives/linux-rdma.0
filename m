Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210E91C75F9;
	Sun, 11 Oct 2026 07:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791702343; cv=none; b=mHSP/wDEKuWFi421gl1CgHHR6tMxu38va3MI6lhf1XP4dlmtpMIGmQvX4aJqaansJbMbjTjii41Znz54VGcmsotSIXCyRkoZeKOIVD7daEq6kBwAgIVD5e7ONr83nKL3ddpnHbb6SJHb2tkNqkgCYE4V9EqqnPLbfYsfJFgv2xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791702343; c=relaxed/simple;
	bh=IP4Rskfz/GCQYzO9x9MDvphxN7sxTG9YrpYTeMGwA7U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VMJ7ljqp+pIPCElS5fd/e9eck8aUv8v9GralC+XHf2ZXEZ9aSuEMPvJ/SGf9DwyxN8oM8hN0xKuyCsOWEKix7+tAlrrLromIFFRyVs6TpMi68wnCcT4b3aetTh8nN5GB0y3dg/H7TThzmOYIlEP17nm+rB4C6qm7av/IrZEuat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEAZeGM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEAZeGM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E8F1F0089B;
	Sun, 11 Oct 2026 07:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791702342;
	bh=Udrnn4cS7q6JKaUpjUsKRGSxz1A9hKmXkIAGTQIJMgU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HEAZeGM/zaQ3hOxN95kus4Sf31JgNyLP3MwTH7Gj1qb9/Co5ZTBE6RiwEuIG3kcHk
	 zJhvE1E9KNf2GUm/yvReYJNF2mIYWmp3lriD0n0KkbdiowIvUw+zA8naI5TkzxCrg/
	 taAM+vJ+HO0cwWl6g5C7P0Od4ul0ZXbDLC4w9fDBPJrInlmkLLEbd8qu7NxL62CyPj
	 gBJt+WL6tsFcrcBrLwIWGwXQjZRc+0UN0j9VbbrRRTe1aayV1sVP1iDKenmii8Xt85
	 6pJSrgOwJ3rw04BribWKPHwFuC0JNjttFIS2TdMo18iboKZIfv9rbhlbPDzybnujpn
	 bp3tZvIIEnG1g==
Message-ID: <9c5d7494fef90cee5404b2943409b2b41ce9b199.camel@kernel.org>
Subject: Re: [PATCH net v3] net/rds: ib: zero the unwritten tail of a short
 receive fragment
From: Allison Henderson <achender@kernel.org>
To: Shubham Antil <shubham@octane.security>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, Giovanni Vignone <gio@octane.security>,
 sungbyeongchan <tjdqudcks0424@naver.com>
Date: Sun, 11 Oct 2026 00:05:40 -0700
In-Reply-To: <20261008124940.13371-1-shubham@octane.security>
References: <20261008124940.13371-1-shubham@octane.security>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-10-08 at 18:19 +0530, Shubham Antil wrote:

Hi Shubham,

Thanks for the v3.  Some comments below:
=20
> rds_ib_process_recv() accepts an RDS/IB fragment once the receive
> completion reports at least an RDS header, and then trusts the
> header-declared message length h_len: rds_ib_inc_copy_to_user() later
> copies up to h_len bytes from the fragment pages to userspace on
> recvmsg().
>=20
> When a fragment carries fewer payload bytes than h_len accounts for, the
> bytes between the end of the received payload and h_len are read from the
> unwritten tail of the fragment page.  That page comes from the per-CPU
> receive cache and is not zeroed, so recvmsg() returns stale page contents
> to userspace.
>=20
> Zero the unwritten tail of a short fragment page on receipt, so the copy
> can only ever return received payload or zeros.  Fragments that fill the
> page are unaffected.
>=20
> Confirmed under KMSAN: without this change recvmsg() returns stale
> frag-page bytes and KMSAN flags an uninitialised copy in
> rds_ib_inc_copy_to_user(); with it the same over-read returns zeros and
> KMSAN is clean.
>=20
> Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
> Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks=
0424@naver.com/
> Reported-by: Shubham Antil <shubham@octane.security>
nit: since youre the author, you wouldn't add yourself as the reporter, so =
this tag should be trimmed out.

> Reported-by: Giovanni Vignone <gio@octane.security>
> Reported-by: Robert van Eijk <robert@octane.security>
> Reported-by: Paolo Gentry <paolo@octane.security>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Shubham Antil <shubham@octane.security>
> ---
> v3:
>  - Zero the unwritten fragment tail instead of dropping the connection.
>    A zero-copy send with a small iovec segment can legitimately produce a
>    non-final fragment shorter than RDS_FRAG_SIZE, so the v2 length check
>    could force a reconnect on well-formed traffic; zeroing the tail avoid=
s
>    that while still keeping uninitialised bytes out of recvmsg().
rds_sendmsg() rejects MSG_ZEROCOPY for any transport other than TCP, so I d=
ont
think this can happen over IB.

>    (Raised by the Sashiko review.)
I wasnt able to find the review that raised this, but the review for v2 lan=
ded after v3
was sent.  From your change log, it sounds like it was a different review, =
but the v2
findings are still valid, so those should be addressed:
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007062135.49946-1-=
shubham%40octane.security

>  - Drop Reviewed-by, since the approach changed.
> v2:
>  - Add Reported-by (sungbyeongchan, first to report, and the Octane
>    Security reporters).
>  net/rds/ib_recv.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffa..9695c7f24 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -35,6 +35,7 @@
>  #include <linux/slab.h>
>  #include <linux/pci.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/highmem.h>
>  #include <rdma/rdma_cm.h>
> =20
>  #include "rds_single_path.h"
> @@ -949,6 +950,19 @@ static void rds_ib_process_recv(struct rds_connectio=
n *conn,
>  		}
>  	}
> =20
> +	/* The device wrote only data_len bytes into this recycled fragment
> +	 * page.  Zero the unwritten tail so a later rds_ib_inc_copy_to_user(),
> +	 * which copies up to the peer-declared h_len, cannot hand stale page
> +	 * contents to userspace.
> +	 */
> +	if (data_len < RDS_FRAG_SIZE) {
> +		void *frag =3D kmap_local_page(sg_page(&recv->r_frag->f_sg));
> +
> +		memset(frag + recv->r_frag->f_sg.offset + data_len, 0,
> +		       RDS_FRAG_SIZE - data_len);
I think padding with zeros would deliver a malformed message to the applica=
tion as
if it were valid. A short fragment is a protocol violation, and resetting t=
he connection
is what we already do for a fragment header mismatch.

I notice the dashboard says a review is still queued, so I'd recommend wait=
ing for the
v3 review and then address both in a v4.

Thanks for working on this!
Allison

> +		kunmap_local(frag);
> +	}
> +
>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag =3D NULL;
> =20

