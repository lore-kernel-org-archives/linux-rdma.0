Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6B439891F
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050187; cv=none; b=mTuZWKxVUwkJUgFZP7VMTEV7lHDHQ6IeGZsH9nLyufL9WpAjS4P3P0yEY2lq0IfdwigMrfydd72O+qv7e+JnyZ0HT8GAx9BnYgXg9qogjpzL5V35TOpdWZJOFGbTR4kNta2YZdKvOpan16wLntuN2faX5jjMK1M2GEnTwvi/w4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050187; c=relaxed/simple;
	bh=/iRzUH1FDuQVn7lnGfG2dLCvaTuoVHCrVidKWWSfelI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ut8mIzl9WcLdCTynM2egpasbRJ7dDlQNCQXLNCjaLC2qcKul+JrlTQ0CWbkjLN9HF1TIN/r19M7sNn8XBS6D9RfHy8wkjDRrwrlsrodVVlUMI4GmkF3zbXyFEuPX3guxS2RXNQr0t5uDqeJ82JldqMM6KcB07fsQWE+MBJBtW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5AfSZF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5AfSZF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2740E1F0089C;
	Sat,  3 Oct 2026 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050186;
	bh=nHdke2DfQVv04i4F7KpuzAt/SjHNykqQ3MDKS3Cb8ik=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i5AfSZF80BA9cVePf+0XIIiQQe/z0rMkZMITlp9eg12syD2qfDuxBI/bl2mYevArG
	 elHldmI2Kr7KJeswJdY+b1mHYgZS+tJS9tW8JrLIA42UZAcjXUAuviTymmaOYHlu6w
	 8mIu6BRmmCdLSs4rYbYCe3iWsPTa6iI6VQlF/nUovhd16I4hSHDk6bvBCC+cXR9wTr
	 h/jtjfX6ilIbuPIGrp9EaUu+7Opu4726h9D80n/k3y5Lq5DjuJlN07pwAhWFc/qV8S
	 POk3TNqmIen60pKwk52qCTo1dqdqYnXi1M6N4M5PKyv8WCPd8UIBJpOkbn8U+62V5X
	 I9APSs6sc4cqg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 04/13] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-5-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:25 +0000
Message-Id: <20261003175626.2740E1F0089C@smtp.kernel.org>
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
> With the predicate as it stands the guards cover the netns teardown and
> module unload cases; the following patch extends it to the destroy of a
> single connection.
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D4

