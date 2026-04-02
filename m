Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A6F31619B;
	Thu,  2 Apr 2026 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775150207; cv=none; b=uZ6CUSAhfFJMyJr9qHWOi0zYZ3BuwpRPd0ChgUfOj+IM6zSLgCdIbkIxHS7IqykQzwFqPtUPzsq3HWa+mLvzgfFaO0dhxtPqfVlhdciaOKWGjnyII3m0GcKIJGFZl0gVTTBhevdKON5RAOJUKwf+CiYzQVpws1+tz3zNwUWKud4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775150207; c=relaxed/simple;
	bh=q2ENSVdXL9UKqPBougkuIFpXYN+LGvwxDJpSdkRe9Ns=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AYqP8/eRKsibgVJIAknoP1iICanK0ZHsNP43ehtY6puvBvYrhkeBkGXZIpQVkk0wajbIAB/edcJ46hb0yKGLvUkI4TfmsezEYvGGqebc2wF0xT+TNN/JyQg854fkTldYz5PD6SyhqejTRJqHGVkL/ur5ze27SWpo/ybyk0NYWnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dl+Qup7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dl+Qup7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A08C116C6;
	Thu,  2 Apr 2026 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775150207;
	bh=q2ENSVdXL9UKqPBougkuIFpXYN+LGvwxDJpSdkRe9Ns=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=dl+Qup7z7Tc98Ztt+iWlXK/Q8X0gMUKI5vMwrgSYk4vNr979EgAfJr5jvFWvwUdqn
	 X9V+qmPQH/nINq3CbMK1/+Y738cooTCq0nNRl9eH4HW+iwPh6y9mcltfM8iBZsQbT3
	 0rVdOJrAg1YsnLP+/e3meuUO59+avboDyLEUV+HX4K7xLar4idJ2sBtwyFAaJ1z13z
	 t6YIdZZzynhs4JQqEDmJGAEXLntj/kxIaw+XKH/Q2rFKKAAKVsd+ONUFw/9UDpBreD
	 PxpG69RsW24/OtKUzY5pPtbtJ9zIx5eE2jblWv/sTpmLU9Cg/R+i1hPv/s83mthrsq
	 TiSi2wZQOQoTg==
Message-ID: <ef82c1e910558e82ac228c9dcf9ae79e9f78a238.camel@kernel.org>
Subject: Re: [PATCH v2 4/4] net/rds: Use special gfp_t format specifier
From: Allison Henderson <achender@kernel.org>
To: Brendan Jackman <jackmanb@google.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,  Stanislaw Gruszka <stf_xl@wp.pl>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org,  netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com
Date: Thu, 02 Apr 2026 10:16:44 -0700
In-Reply-To: <20260326-gfp64-v2-4-d916021cecdf@google.com>
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
	 <20260326-gfp64-v2-4-d916021cecdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-03-26 at 12:32 +0000, Brendan Jackman wrote:
> %pGg produces nice readable output and decouples the format string from
> the size of gfp_t.
>=20
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  net/rds/tcp_recv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
> index 49f96ee0c40f6..ffe843ca219c7 100644
> --- a/net/rds/tcp_recv.c
> +++ b/net/rds/tcp_recv.c
> @@ -275,7 +275,7 @@ static int rds_tcp_read_sock(struct rds_conn_path *cp=
, gfp_t gfp)
>  	desc.count =3D 1; /* give more than one skb per call */
> =20
>  	tcp_read_sock(sock->sk, &desc, rds_tcp_data_recv);
> -	rdsdebug("tcp_read_sock for tc %p gfp 0x%x returned %d\n", tc, gfp,
> +	rdsdebug("tcp_read_sock for tc %p gfp %pGg returned %d\n", tc, &gfp,
>  		 desc.error);
> =20
>  	if (skb_queue_empty_lockless(&sock->sk->sk_receive_queue) &&
>=20
This looks fine to me. Thanks Brendan!

Acked-by: Allison Henderson <achender@kernel.org>
