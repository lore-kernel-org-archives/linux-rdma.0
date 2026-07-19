Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8038D353EE0;
	Sun, 19 Jul 2026 08:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784448834; cv=none; b=Chr2QXS1jJgcXHMq2MI7Yi7tmP6piyOtntumSWLsGF5/wtIaareHgAZ5HuNO7b2h6a1gYFp0MTP8Qkqq6elcdsANwfF6ZjUTsZChQEavs2feP/VwHi9aFWdotPuJM6DwtsG23GjA/i6r9Csyu6ZQPE4ZjrgM+PFsYP79sDzHucM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784448834; c=relaxed/simple;
	bh=LKvbheQlpzwmbZtr03LNfZ8JGkOHDWA/9mAx1fqSrqI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n4g7kjQ0BeBvidOGw910BzY6DWxEOtfNfrtWuEk1SvTvDFwdx8xAaOIQR8bDQRDKlHsAH/QXALhQryxX1306vbfvVqkb3djy/dID+2RJQCHkVLVqNmcTGQbMfTU6NzYla92AJ+1fan9ianCOhd224sfSuL0WamhAKdm9mjf6s00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEUpTeZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEUpTeZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E19D1F000E9;
	Sun, 19 Jul 2026 08:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784448833;
	bh=yPO5j6jDNZ1b8+1u9JOWqVZP2nKox7P+Uj+qtNTQe8k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cEUpTeZY1LlOQ9QXPTqv2d1v0fptj6K6iwIWGb3xN/YXCNh2uTwj/KgS7kMGtndIc
	 1KtzbjBcjGgKZ3RPchTumh7jhYr6QEuTRI98sz0G5ROfFwtx0nqSiaKOd+EFaQ7PBA
	 TRrSLkpo9QtHKIftJOOBmUHmRNCS8I1PIawU74QK2k52J+U4Ho5/AsgVwX9/ie30aU
	 KPCEBcyed32ldnFmTcCjdf4x2XK2tt5eb3Kaj8LQd2Ylp6EFodoNVIvRyO4aAxIPja
	 iddO0QEzkPHMJj/RvEoxSjwqpICTOc7fFLSmbMLyvXjow4xRBJibKlsWQGDSnqEhqp
	 tzYu2NAQ9GMPg==
Message-ID: <259284aa1280d387c413cc34fa5e4b11ad28379d.camel@kernel.org>
Subject: Re: [PATCH net] rds: tcp: unregister sysctl before tearing down
 listen socket
From: Allison Henderson <achender@kernel.org>
To: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org,  AutonomousCodeSecurity@microsoft.com,
 tgopinath@linux.microsoft.com,  kys@microsoft.com
Date: Sun, 19 Jul 2026 01:13:51 -0700
In-Reply-To: <20260718183420.13301-1-blbllhy@gmail.com>
References: <20260718183420.13301-1-blbllhy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-07-18 at 14:34 -0400, Cen Zhang (Microsoft) wrote:
> rds_tcp_exit_net() frees the per-netns RDS TCP listen socket via
> rds_tcp_kill_sock() before unregistering the per-netns sysctl table.  Sin=
ce
> rds_tcp_skbuf_handler() derives the netns from rtn->rds_tcp_listen_sock->=
sk,
> a concurrent sysctl write can race with netns teardown and dereference th=
e
> freed socket/sk.

Hi Cen,

Thanks for working on this.  The race is real and the analysis is right.
Some comments below:

>=20
> KASAN reports the race as:
>=20
>   BUG: KASAN: slab-use-after-free in rds_tcp_skbuf_handler+0x2aa/0x2e0
>   rds_tcp_skbuf_handler              net/rds/tcp.c:721
>   proc_sys_call_handler              fs/proc/proc_sysctl.c
>   vfs_write                          fs/read_write.c
>   __x64_sys_pwrite64                 fs/read_write.c

Was this stack actually observed or was it derived from an analysis? If it =
was
derived that's fine but just note it somewhere so that someone doesnt end u=
p
chasing a synthesized stack trace.  If you did actually hit it though, plea=
se
include the full report and a reproducer if you have it.

>=20
> Fix this by unregistering the RDS TCP sysctl table before calling
> rds_tcp_kill_sock().  unregister_net_sysctl_table() prevents new sysctl
> handlers from starting and waits for in-flight handlers to finish, so
> the listen socket can then be released safely.
>=20
> Fixes: 7f5611cbc487 ("rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using curr=
ent->nsproxy")
> Reported-by: AutonomousCodeSecurity@microsoft.com
Check patch generates a warning here for a Closes: or Link: tag. =C2=A0
If the reporting tool you're using generates a public report, please includ=
e the link here

> Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>

Other than that I think the fix is ok.  With the above fixed, you can add m=
y rvb:
Reviewed-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison
> ---
>  net/rds/tcp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index a1de114d5e2e..453d4077a85e 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -655,13 +655,13 @@ static void __net_exit rds_tcp_exit_net(struct net =
*net)
>  {
>  	struct rds_tcp_net *rtn =3D net_generic(net, rds_tcp_netid);
> =20
> -	rds_tcp_kill_sock(net);
> -
>  	if (rtn->rds_tcp_sysctl)
>  		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
> =20
>  	if (net !=3D &init_net)
>  		kfree(rtn->ctl_table);
> +
> +	rds_tcp_kill_sock(net);
>  }
> =20
>  static struct pernet_operations rds_tcp_net_ops =3D {

