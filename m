Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7A424D74
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443462; cv=none; b=O/vA9E/i11u5SOvkmWIhNPso2DMmKHLfN8/vZNwUE4sGBQ3Q14WNALxXSHyg7GRhQIZ9KwMKjagz0L4iwa/4mqfNJ4eiJVPcn+En5CuTliCPbPlagEME1vbdIGFxN+P2UaNTK/Ka4X8xp9XHIWpqshi9m7k8Yca6myoVouMny3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443462; c=relaxed/simple;
	bh=9LvGijZPQvJsZLbNGDW1bEF0bw6Q7Hq0NRbfE3PcSFU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p6/31Jf+ZbiA+TNYEp8FIYVQYFkSBlFvJVNUkUWN7wCIeD8mfvv9Nyofkl73YKJBZIyA1NnBYGeN3Ruwv85LpZjVyhGdMmbIfdeRFsCIUzVzVkkxgNONJvsfaZqkplv60i/O8G7eR3wVYMWgAE87mLDBZ8TjK3iJVCHHv9s1GT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fF0t2Zrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fF0t2Zrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECBD1F0089A;
	Tue, 15 Sep 2026 03:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443458;
	bh=X/Hsjoe4ddY0p/08mtEmcx0ryXyRsFnMdxeujDqadAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fF0t2Zrj7WPPtoGYMF3GaF9Y9Q2/YLdDZRwOnMlw5+G5eur6iJSSJq9VvESeXIEcZ
	 Q01iL9PCYJOpRUaw/o1E/5KUCAeN2yJQxv1lVXUugZPHvVbkRSODx1T4xwobkfRRs0
	 xXLdQnZ/rBn+9TbZ8tAMytO7qdVKuplTYwilwMat3o78s1qboVhoCLc9ugSQ9I+tf7
	 y5WsCJRDfnxlLyQLiJAe78s7EoRwhwZBHxYSXm4Tj0mlvmZoce6h9j3UmwojiNMcEc
	 F3Tyu5bVhv1pzqCVnakql3YKjtdao+WpjthDxgxqtU+JD6Ffb/qrh2/jemJ1HhXuQR
	 e6rBGtriHuCpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 10/13] net/rds: tcp: don't attach an
 accepted socket to a connection being destroyed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-11-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:38 +0000
Message-Id: <20260915033738.8ECBD1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] The `rds_destroy_pending(conn)` check introduced by the patch =
is lockless with respect to connection teardown, leaving a Time-Of-Check to=
 Time-Of-Use (TOCTOU) race condition that renders the patch's attempt to fi=
x the Use-After-Free ineffective.
--

commit 128ba6b33f50fd05797877892e71aaf3ccd2f612
Author: Allison Henderson <achender@kernel.org>

net/rds: tcp: don't attach an accepted socket to a connection being destroy=
ed

This commit attempts to prevent a use-after-free by refusing to attach an
accepted socket to a connection whose teardown has already begun, doing so
by checking rds_destroy_pending().

> diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
> index dcac10a91a67f..e22ea9ca8c1ce 100644
> --- a/net/rds/tcp_listen.c
> +++ b/net/rds/tcp_listen.c
> @@ -278,7 +278,15 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
>  	cp =3D rs_tcp->t_cpath;
>  	conn_state =3D rds_conn_path_state(cp);
>  	WARN_ON(conn_state =3D=3D RDS_CONN_UP);
> -	if (conn_state !=3D RDS_CONN_CONNECTING && conn_state !=3D RDS_CONN_ERR=
OR) {
> +	/* A connection whose destroy has begun has been quiesced and is
> +	 * only waiting for its last reference: its paths sit in
> +	 * RDS_CONN_DOWN, which rds_tcp_accept_one_path() happily claims.
> +	 * Installing a socket on it would leave sk_user_data pointing
> +	 * at a path that is about to be freed.
> +	 */
> +	if (rds_destroy_pending(conn) ||
> +	    (conn_state !=3D RDS_CONN_CONNECTING &&
> +	     conn_state !=3D RDS_CONN_ERROR)) {

[Severity: Critical]
Does evaluating rds_destroy_pending() without an RCU read-side critical
section leave a Time-Of-Check to Time-Of-Use race condition?

Looking at rds_conn_destroy() in net/rds/connection.c, the teardown
sequence sets the c_destroy_in_prog flag and calls synchronize_rcu().
Because rds_tcp_accept_one() isn't holding rcu_read_lock() here,
synchronize_rcu() will not wait for it.

If rds_tcp_accept_one() gets preempted immediately after this check, could
rds_conn_destroy() run concurrently on another CPU, complete the teardown
while the socket is still NULL, and free the connection?

When rds_tcp_accept_one() resumes, it appears it would install the new
socket onto the connection and drop its reference via rds_conn_put().
This would leave the socket's callbacks and sk_user_data pointing to
freed memory, leading to the use-after-free this patch intends to prevent.

>  		rds_conn_path_drop(cp, 0);
>  		goto rst_nsk;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D10
