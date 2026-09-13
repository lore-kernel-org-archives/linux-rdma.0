Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2964838DC6B
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271445; cv=none; b=aTrIfmlJs+ePVhVzFDfuS33HX29c3kz8TvNXjySt5YX5eLjSpcpwH3TmU+DWGVdjFdh97TMFTYDh5I7xsyAlX4Jq+70P+ROvINFxpUANxFO7YDJW5mrzln7WuKSM5FybvaDD5Jbju6wmLBfdaJCQ9dgzy5RhF8qgs9kUEpSCobM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271445; c=relaxed/simple;
	bh=t27K2WJkiNrF22dXHe2EQGp5EPz4kaAuITuZokwrviU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KJbmXmKuhHTWs04+vI8tBD7jk/s+cpglLcXXcN8L2zo2YriM+FM2Z9Or6Xf3dszg0owxqYh2pq//pumJNEzxvNy6dy3NU1kFCaE1v2F17rGkXu/O0YOU4XELzaiAB3yrO2aMyaOwkhEtLmDM6cxy+vGqKDhZW586pgFbbVmHNHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYcVPRs8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYcVPRs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC8C1F00893;
	Sun, 13 Sep 2026 03:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271444;
	bh=Fi5imZalqbWQdqjcI1B6TFTI5FTbeJbhHOY67CfDpKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oYcVPRs8eGzAQvA61Z7laCDs/2SCTlMcB2t9FoqbnZNo+53t2oSmKW++9ZwENplTW
	 S1HfL88Sdqf2eXWy1oSyYYuHgATQOlzPnYC7qE3fon3y3ahjLTjnA59AANQ9/xpH5L
	 oBzgVaq9TlIC7EXD9cuGWWsNBjKUws5hxoYOhPSDxUYDRSiHFOgwfNQOmG0pRumTHi
	 DTCKFAQKdSHvPm0jcFpRuPrxshjCMmEcMMZZRSv5ji2kJha5SN+tkY4Z7L0pdnq2dS
	 v23VP4y0p0QYcheADY677iNbi27l2stQ9ywNuOlFDAFm8by27Z2RCFY8Gc6LpHRNNW
	 eOeiQ/D/ZjMIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 8/9] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-9-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:43 +0000
Message-Id: <20260913035043.DAC8C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Leaking transport data for multipath connections in passive connec=
tion error paths.
--

commit 149715f475fee80907a20e835a5065660d049fe5
Author: Allison Henderson <achender@kernel.org>

net/rds: drop rds_conn_count in favor of t_conn_count

The previous patch gave each transport its own connection count in
t_conn_count, incremented and decremented at exactly the points where
the global rds_conn_count is.  This switches the name seed to
t_conn_count, and removes rds_conn_count.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 1ec141d6faa38..11813f93961d1 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -392,7 +392,6 @@ static struct rds_connection *__rds_conn_create(struc=
t net *net,
>  			rds_conn_get(conn);	/* caller */
>  			rcu_assign_pointer(parent->c_passive, conn);
>  			rds_cong_add_conn(conn);
> -			rds_conn_count++;

[Severity: High]
This isn't a bug introduced by this patch, but this section of
__rds_conn_create() has a pre-existing memory leak when tearing down
passive connections.

When establishing a passive connection, if the parent's destroy has begun
or another passive connection won the race, the error paths only free
the transport data for path 0:

	if (parent) {
		/* Creating passive conn */
		if (READ_ONCE(parent->c_destroy_in_prog)) {
			...
			trans->conn_free(conn->c_path[0].cp_transport_data);
			...
		} else if (rcu_access_pointer(parent->c_passive)) {
			...
			trans->conn_free(conn->c_path[0].cp_transport_data);
			...

Since conn_alloc() can allocate transport data for multiple paths (npaths),
doesn't freeing only c_path[0] permanently leak the transport-specific
connection data (like rds_tcp_connection) for paths 1 through npaths-1?

The normal connection error path just below this handles it correctly by
looping over all npaths:

		if (found) {
			for (i =3D 0; i < npaths; i++) {
				cp =3D &conn->c_path[i];
				if (cp->cp_transport_data)
					trans->conn_free(cp->cp_transport_data);
			}
		}

Could the passive error paths also be updated to iterate over all paths and
prevent this resource leak?

>  			atomic_inc(&conn->c_trans->t_conn_count);
>  		}
>  	} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D8
