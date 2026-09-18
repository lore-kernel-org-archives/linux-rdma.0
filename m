Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36E44AA1E6
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717237; cv=none; b=FjXmOP99t1BBU35CuNCSYM8RoODI/y6PpDwhXfC24wNPTbhkN0Zrycvc9/BicUl5nH/2CuCF23R7M63SiYOjZZB8tr9w4bRabsiqfHJ5zD4+xgC4Zkijmwyy7yMtAJhccCin0bUHK32Lr2PYjPaMU6Kg3YRU/P1eCag1C75VZ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717237; c=relaxed/simple;
	bh=nBGLJ50bAJDCE67OglBXcRdDlRs2zMBxoFyj96dHl8c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=McQHkWLrh2sKmZm2xfV347ACcV7sTdOT7bMKkQIlcWb1cXrfez3CFb0Uz1cbL3NsA9x7VrMO9ey49M2KBvoZy1zODDzwoISsEb9xzcbH31qJlvRCe7NnmTiEUyIuBXgMLv2CUjTMAL093sBLdlD1L83f4LzRkBIvi0xT9quMpNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIfGGD97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIfGGD97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D2A1F008A1;
	Fri, 18 Sep 2026 07:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717213;
	bh=uO1HquStU01TOmbtD8WDZ0pguFEVkjx9xkQ93Y+mXv8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SIfGGD973O3yGSB/z+04k53dqk/cHb1uJaX+002AdcKiRigYIgoosd39tXbSCVcbQ
	 +RNKvvNZSflb+a+Q6i4Y3PcxE1iQM8VrLRiKW0gInv/FqnrLQ/fOxs8T4+/tn4f13Y
	 2IlF5ztfk8a4mERcK3TQEFGYGWTjM5g8TzNoVmbv7lJ7xwpA0bH1rEE62HJAO9aOBy
	 NaKADWTL2LAYMG4MsJyMkyH8FZBbNcq0HKp7B4uZ8QKiiKvmerplszWMyZVFiqpx/0
	 U3M3ug6JIajvhaKMd85gQEizKSGLI5Y8Fe9Pzq+a8e8FnAMHe5hDebZogyjzH+IJOq
	 o5wV82qqwsFhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 11/12] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-12-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:13 +0000
Message-Id: <20260918074013.B3D2A1F008A1@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D11

