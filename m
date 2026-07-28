Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED5239EB47;
	Tue, 28 Jul 2026 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785275016; cv=none; b=CFUUviPw9vZlZ6rTiVIA1N3IFHg49h+19LpbEjWGHVBrdLYYr3643tRB3Q15YSNTUFOrlQ/BqkPW4VLjcrwyqLOwPKdqQtjf3lvM+NjqZvofu9QhWhJpQ3Qc7CjJsP56JaZYGaqTR0P6wnNyjDzGz2hDR5zJC6ZXahsVWqaKhpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785275016; c=relaxed/simple;
	bh=DyEwXd5pAriExK0XhUx55FkPr++yZGZZU+ubvuSqjdk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hxsYlnRQ44QmzA9nAvwexNzYWUfVaa6k/qE+b8C2mvoe4Vi0ZzOiODHzMqdKEhQaUUPxQMQ8bndWZKl3RP5/staieWzle6adHNGh6w5a+D+4z4ijehGwHdKMoVC0QxrOyHfaxcfmVJSzL8RlGk9CgkYBdBBhmqQy6b92NSJv678=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A27Au0Eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A27Au0Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C4E1F000E9;
	Tue, 28 Jul 2026 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785275014;
	bh=FPFd3THcS0+K8u8o3dy0lp1U8FSBqKG4SoO1gz9KXvA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=A27Au0EoZWeOFj13m84FaO/3KQ+KNiX1TUZ57e/oxCFXrwTp9bikqfyUWfYAqm2g+
	 78A77CGAcU6E+x6K8Og2JFAddPTaKJKozAHWbUZ39QBu5sM6LbXkXdprZh2Ivq8b8+
	 IhgLAzOhElcUeypruIeZkEqJrPxeli5oTRoy46z/rBaWRIW1nagsOXR3QlEZZrC31Z
	 R3kMXabV9vB0W2SDliZoQFUydBie6TX//eo1mdyasKZGOsfErH83LtZowQ/QnaDtug
	 KOH/COGZ7yOUik2hfv+E2271PNlimlUsTbSG8VPuHUMthfDTi0GxyD35oEa77kGhgw
	 kKCbBk+Pe8xpw==
Message-ID: <46a5f6a57ed7c680831f8819659e8be8d3b552f1.camel@kernel.org>
Subject: Re: [PATCH net-next v2] rds: synchronize info callbacks with module
 unload
From: Allison Henderson <achender@kernel.org>
To: Chengfeng Ye <nicoyip.dev@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, 
 Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Dan Carpenter
 <error27@gmail.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Tue, 28 Jul 2026 14:43:33 -0700
In-Reply-To: <20260727174826.135662-1-nicoyip.dev@gmail.com>
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
	 <20260727174826.135662-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-07-28 at 01:48 +0800, Chengfeng Ye wrote:
> rds_info_getsockopt() reads a callback from rds_info_funcs and invokes it
> without protecting the callback's lifetime.  Transport modules register
> functions stored in this array.  For example, rds_tcp.ko registers
> rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.
>=20
> This permits the following interleaving:
>=20
>   CPU0                             CPU1
>   rds_info_getsockopt()
>     func =3D rds_tcp_tc_info
>                                    rmmod rds_tcp
>                                      rds_tcp_exit()
>                                        rds_info_deregister_func()
>                                          rds_info_funcs[offset] =3D NULL
>                                      free rds_tcp module text
>     func()
>=20
> The reader can therefore branch to an address in unloaded module text.
>=20
> Protect callback invocation with SRCU.  Enter the SRCU read-side critical
> section before loading the callback and leave it only after the callback
> returns.  Clear the callback with release semantics and call
> synchronize_srcu() before deregistration returns, preventing module unloa=
d
> from freeing its text while an old reader is still executing it.  SRCU is
> required because callbacks such as RDS_INFO_COUNTERS can sleep.
>=20
> Keep the callback array unannotated and use acquire and release operation=
s
> for publication so sparse does not have to apply __rcu through the
> function-pointer typedef.  Replace the two callback-slot BUG_ON() checks
> with WARN_ON_ONCE() and return without changing the slot on mismatch.
>=20
> Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
> Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev=
@gmail.com/
> Suggested-by: Allison Henderson <achender@kernel.org>
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Hi Chengfeng,

Thanks for the updates, this looks good to me.

Reviewed-by: Allison Henderson <achender@kernel.org>
Allison

> ---
>=20
> Changes in v2:
> - Split the info callback/module-unload race from the independent
>   inc->i_conn lifetime bug.
> - Keep the callback array unannotated and use smp_load_acquire() and
>   smp_store_release() to resolve the sparse errors.
> - Replace the two touched callback-slot BUG_ON() checks with
>   WARN_ON_ONCE() error paths.
> - Rewrite the commit message for the callback race and omit the unrelated
>   inc->i_conn KASAN report.
>=20
> Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev=
@gmail.com/ [v1]
>=20
>  net/rds/info.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/rds/info.c b/net/rds/info.c
> index 21b32eb16559..408a4f0d04a3 100644
> --- a/net/rds/info.c
> +++ b/net/rds/info.c
> @@ -32,6 +32,7 @@
>   */
>  #include <linux/percpu.h>
>  #include <linux/seq_file.h>
> +#include <linux/srcu.h>
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
>  #include <linux/export.h>
> @@ -68,6 +69,7 @@ struct rds_info_iterator {
>  	unsigned long offset;
>  };
> =20
> +DEFINE_STATIC_SRCU(rds_info_srcu);
>  static DEFINE_SPINLOCK(rds_info_lock);
>  static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1];
> =20
> @@ -78,8 +80,13 @@ void rds_info_register_func(int optname, rds_info_func=
 func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> =20
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset]);
> -	rds_info_funcs[offset] =3D func;
> +	/* Validate the latest published slot value. */
> +	if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]))) {
> +		spin_unlock(&rds_info_lock);
> +		return;
> +	}
> +	/* Pair with lockless callback lookup. */
> +	smp_store_release(&rds_info_funcs[offset], func);
>  	spin_unlock(&rds_info_lock);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_register_func);
> @@ -91,9 +98,15 @@ void rds_info_deregister_func(int optname, rds_info_fu=
nc func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> =20
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset] !=3D func);
> -	rds_info_funcs[offset] =3D NULL;
> +	/* Validate the latest published slot value. */
> +	if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]) !=3D func)) =
{
> +		spin_unlock(&rds_info_lock);
> +		return;
> +	}
> +	/* Hide the callback before waiting for old readers. */
> +	smp_store_release(&rds_info_funcs[offset], NULL);
>  	spin_unlock(&rds_info_lock);
> +	synchronize_srcu(&rds_info_srcu);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_deregister_func);
> =20
> @@ -165,6 +178,7 @@ int rds_info_getsockopt(struct socket *sock, int optn=
ame, sockopt_t *opt)
>  	int npages =3D 0;
>  	int ret;
>  	int len;
> +	int srcu_idx;
>  	int total;
> =20
>  	len =3D opt->optlen;
> @@ -214,8 +228,11 @@ int rds_info_getsockopt(struct socket *sock, int opt=
name, sockopt_t *opt)
>  	rdsdebug("len %d nr_pages %lu\n", len, nr_pages);
> =20
>  call_func:
> -	func =3D rds_info_funcs[optname - RDS_INFO_FIRST];
> +	srcu_idx =3D srcu_read_lock(&rds_info_srcu);
> +	/* Pair with callback slot publication and removal. */
> +	func =3D smp_load_acquire(&rds_info_funcs[optname - RDS_INFO_FIRST]);
>  	if (!func) {
> +		srcu_read_unlock(&rds_info_srcu, srcu_idx);
>  		ret =3D -ENOPROTOOPT;
>  		goto out;
>  	}
> @@ -225,6 +242,7 @@ int rds_info_getsockopt(struct socket *sock, int optn=
ame, sockopt_t *opt)
>  	iter.offset =3D offset0;
> =20
>  	func(sock, len, &iter, &lens);
> +	srcu_read_unlock(&rds_info_srcu, srcu_idx);
>  	BUG_ON(lens.each =3D=3D 0);
> =20
>  	total =3D lens.nr * lens.each;

