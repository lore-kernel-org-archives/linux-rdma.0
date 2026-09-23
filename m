Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D1E47A898
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153681; cv=none; b=A4/ACmz4bgHocE+ESmgwy1Em55qM6E+igX19R+dI3P6qfuKlDYOXecKWT7SYBL/yf1phScgRhzLMsCOpPiz8nJmynbGLXmMb8yW2t2+9okrLbVBxYtFAq51kpZt7uphhDJWy8XdpN0DyWpH1N3pETWG9sQXdQilqcJUVr05FAeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153681; c=relaxed/simple;
	bh=3IpH0PHiyD44StYP/WrHM+qHxkf2PK8zIUHoAJRNj1o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tmwOQnGSHEeFfnwxZQ0VKO6OJe2XhAF7cMzpYu4oeIGmf53jiUhCBFYjNWZe6YLRqQTl55NkQA5/ia6q4ohx695QsHKalav1oWxJthVc1PeeCpruYOPMu5jZz/MaB6nXTKJPMVGHdgXhQdU84wHb/Ugl39rIMKZP2O7Pk+otOcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHAZQ7IC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHAZQ7IC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA3A1F0089D;
	Wed, 23 Sep 2026 08:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153669;
	bh=ePEZxAkP4uQ0qi2EAaLYLeO9YVibCyZOEVYbgf9CJc8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IHAZQ7ICnnj8dgK/FJxEYF/hzepsMF2YcMhTfNBFdm4rQqnbMcZz4fG00UZG+3ItJ
	 HDs2dgEvPjQIvK0EdSM6SomRx1ohTJotSKG40CuE0BjjNJBgE6lVbF87PHMSt5p4Ei
	 c/3s1cIdm11flPnS8EpTTNeC4EqARxrrYmGYC86Q7f94FxzMxCQ57RHH3HcgKJhAfU
	 QQ2VkJa3ZaRpzu9URCKJo1dS7qw4TPwXvRlXH33VsIrymlXGIo3GQSrUj4ogUPvhIE
	 Soxh30xouFp8V5GkckwFGDa/bT8/rHvyWkncFpCzz0g0/qlC64fiWCd9rxuNe+sIWd
	 1DVeJgdzx8U0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 11/12] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-12-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:29 +0000
Message-Id: <20260923085429.9BA3A1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The previous patch gave each transport its own connection count in
> t_conn_count, incremented and decremented at exactly the points where
> the global rds_conn_count is.  That leaves rds_conn_count with a
> single remaining consumer: the seed of the per-path workqueue names
> in __rds_conn_create().
>=20
> Switch the name seed to t_conn_count, as UEK does, and remove
> rds_conn_count.  The numbering becomes per-transport instead of
> global, so connections of different transports can now receive the
> same seed; workqueue names carry no uniqueness requirement, and the
> seed was already reused as the count rose and fell.  Removing the
> counter also removes the rds_conn_lock round-trip that
> rds_conn_destroy_fini() took solely to decrement it.  (The free path
> still sleeps in destroy_workqueue(), so the last reference has to be
> dropped from process context as before; only that one lock goes.)
>=20
> Based on the Oracle UEK commit "net/rds: Each RDS transport
> should keep its own connection count".
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D11

