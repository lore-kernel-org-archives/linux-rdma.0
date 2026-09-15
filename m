Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B51C420479
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443455; cv=none; b=UEVotVBOk69V1ahGYcW1uF6k+nE8wykaxYta3msTDYQgCx+nqFjBKvl0/hc0ZAjQmJ89hdbSrm/K2Njq+dN/87xDqbQCLGF1pfe9R2obj9oYU+f1HmohsG/YKpn7v3wh7kWkOU243VHOR6rB7cMFTqogglgG4nluDPqN0S6V2t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443455; c=relaxed/simple;
	bh=Zk9MMDeH3DYFhhavJFcsZIcHvmUD1nt1FPnd1ESuQcE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LXgm+bItjS47fDPc1xvpMltUDY5jJ28KPtmVhnitTIJcPwBt3zL1Ktmpgq9F2K9tAp259NqMZe9XfBG51zWkomL5LFa50KpVN8rH7d33odf36/ZQXBHRpfbZI0nSSEkcYd9b1khK+WLwixQUJuz2OHGSzB0KuwJ/5rdmUcgKjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OIKXvsrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIKXvsrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5501F000FF;
	Tue, 15 Sep 2026 03:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443454;
	bh=IW20hZnHDyEZMOC7Di1NyRI7j7Y/i1MSU+A8hx48tFI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OIKXvsrL3k8YA1rQFPqkwLa3x0Rm+nA2CE1mDx30pnlU3n48bKFJV6gk10k0MY/Si
	 8uXtMY2JUnJttdr8OKFcggIpWpHaCZKqKalj2dZMGfNCNwOK97bXoDZV/Kak89aIBq
	 macRIwNJluSvVifvNopyRrnW3R97LVtpYLbZeAll2nqZpTHA4NhgQvea77LJ1gj4XY
	 MhKoxks40DBxD8vEYBkC7PJIXT4Wii+ocRuzvfdp4ggXZdvPQmzbcuO2TIscF1odW1
	 fGRsEau0dtR3kK574ucMWdWNC+S6YGjH36jM5VE3e+vCkk7ZtNOkEHwJzGL1dggSYt
	 Mwi9NYEgysdOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 09/13] net/rds: refuse to queue a message on
 a connection being destroyed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-10-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:33 +0000
Message-Id: <20260915033733.DD5501F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_path_quiesce() tears down cp_send_queue by walking it with no
> lock held.  That was tolerable while a connection could only be
> destroyed with no sender in flight, but a sender now holds a
> reference across rds_sendmsg(), and rds_conn_destroy() can quiesce
> the connection underneath it.  rds_send_queue_rm() adds to
> cp_send_queue under cp_lock, so the unlocked walk races the add and
> can corrupt the list.  Worse, a message added after the purge sits on
> the queue of a quiesced connection holding the connection reference
> rds_send_queue_rm() took for it: the reference is only dropped when
> the message is freed, the message is only freed when the queue is
> torn down, and the queue is only torn down by the destroy that has
> already run.  The connection would never be freed, and with it the
> transport could never unload.
>=20
> Splice the queue away under cp_lock in the quiesce, and have
> rds_send_queue_rm() test rds_destroy_pending() under that same lock
> before it touches either queue.  A sender that gets there first has
> its message purged; one that gets there second is refused, and
> rds_sendmsg() returns -EAGAIN for it, the same result the early
> rds_destroy_pending() check in rds_sendmsg() already produces for a
> connection whose destroy had begun before the send started.
> rds_send_queue_rm()'s *queued becomes negative on refusal so that the
> wait loop in rds_sendmsg() stops waiting for send room that will never
> come.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D9

