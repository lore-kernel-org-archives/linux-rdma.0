Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A33AAF6C
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208295; cv=none; b=kYw23JQfKM5TbXv40MP9tu5Cl+eRYBnl6n8gfcwPTaMz3gjwgWfVjOL8HrqhyhKR2npI5OWFFIPGgowS7U5it+iscDEyV8D+KV0/LU5ckH/5aJoyFtcLFODxh94Yp1MbWHR/wVWSiY3wh4kPL+IGZnOEcMtUQX5WAULVIPGmTv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208295; c=relaxed/simple;
	bh=Una1mQQNp7i6oRllcW2Q8Iad1QaZDiuqg4dYdoqXN2A=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=swnnwpZpkMIKZrIO7R+n+9sOBtQx47SAL1+bBrSrdmMTV11MR/uW5BJITJGw1zpXiYf1kxlOxAfQ0DqIGzwISDWu6JGeavUYoWvUbZaoj1goCoj3Bix3csdTNWP4te8qGiE6LxKa6aZToPr8wWTGUpUf3rZz5Lv6Z6x0+B35wGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jnD6Jd4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jnD6Jd4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9465F1F000C6;
	Sat, 17 Oct 2026 03:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208294;
	bh=n+A93ijLXhna3Vz/oT+XaR6iLR5iDVmqELnhKjWtX1U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jnD6Jd4fDDyk7FqxDIjf4oDCIg/KffPpHwg2W4ZKdh8HB5IetrW/Jjv1GyrLb4l8t
	 pYjxkb9W+BZ2mFzcGDWnyyPt0cgLGL/Y8KLdqI3NGloe+XMa/ZgvWl0ic34tUYYtAP
	 mzmCzsVzSMLBpxG8/HXlMv2fuKneoH4MNA4q0HiO6MVoBlN14v/5fQY7Gx8M1qgCDO
	 2Pk911k+IoEKd2gkB/6Rw9Ckq/J7MTszVOH021WLe3zjTvRqaUz67a75biAzt06K2d
	 kMXAmip6cQGNOuae4rGSLc+ooKHvtR1Nu4RkVNIdwHCxcY1GFlBViBSSd6PewBOqN3
	 G+nf80SPfEs4g==
Message-ID: <sashiko-outbox-175256@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 04/13] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-5-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  The sites that can re-arm those works are
> supposed to test rds_destroy_pending() under rcu_read_lock() first,
> paired with the synchronize_rcu() in the destroy path, so that no new
> work can be queued once the cancellation has begun.
>=20
> Five arming sites never got that guard:
>=20
>   - rds_ib_send_cqe_handler() and rds_ib_send_add_credits() re-arm
>     cp_send_w when a send completion or a credit update clears
>     RDS_LL_SEND_FULL,
>   - rds_ib_recv_refill() re-arms cp_recv_w when the recv ring runs
>     low,
>   - rds_tcp_accept_one() kicks cp_recv_w on the freshly accepted
>     socket, and
> [ ... ]
> module unload cases; the following patch extends it to the destroy of a
> single connection.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D4

