Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712375;
	b=wfM27p4Ja4CYGkIoAHhWldojg2BjEY9+A7lYUMOkVid9Zm9bb+3ESJnYBs0g1lKLWG8F
	 JKhRg1kH7MNMu7onXzBNBWEXkE2b6dlw/aIJnmWZEQW0ktMl+VPusyio2ziJ7EVkxT+E8
	 J4I4zHsdCJvLwQM5qjHzWABQOmy6QgfctVr/YTsBsnZm0w+ITz5RxD+fEFvM3+DaKPnVo
	 mr+6/K+MqYZZljCf7Ubv11hoZXg9sMaLMNuMEHx3ibtUffy3TUoxiqLvzPonqW05Cp1ap
	 RYtWzOmjirQDTEhTbA+EuAi7SCpzgJVtbXQ4trPwFmSyAUJL2Qs4FOYR0DGGMR2q9ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712375;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NA/medYNoSaaUhwk2GJ3A/gyk7RjF7ZWpjYHfhL5u2c=;
	b=JgD6hWfiCstD1qZ9spgV/oN5clcNY1ZsCmS/PFIN8CDRvrt3eyp52O08m96dUu2dKrVl
	 L+aZaHO72QbvjfGTv/nBlHjVoBHcgIEDK0Xwn/K0kPKAqyHM7BBtO0/efowL9KN4L7tJl
	 sZixCYvP43fzlp9F4NH+DnRSfXcsHq8tKb9V9t86SzU2bzMlDcRqHIfK4QI7f40fKtEqF
	 DfyJu+KKMW1Y54z8q73MVWQnGiy6tliDPblk5sWFL60WT5Le2kFLlbOWQfyLer8diaqF8
	 nmHB+5ChWt+seDdVFBg3YG9PCEDUAh2/N1+yp94aqM8AIPYF3e+yVVZ2Ldll4juREKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ik7BGJXn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE62C6082BC1
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ik7BGJXn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9414A1F00A16;
	Tue,  3 Nov 2026 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712374;
	bh=NA/medYNoSaaUhwk2GJ3A/gyk7RjF7ZWpjYHfhL5u2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ik7BGJXnMO4sjgFKCOHdKHsKXHrjpLrqjJ17xncgIz5JrP/2M5+c0cmoBf2Px9fI0
	 Uh4CiBBtF/pVHJFutfwwIP47OfISRgl9Q8smzy26KIaD1TB7neUsqBZ42Z6Goox4G1
	 twNL7xWwxX3pJXtUhB5GZJ7wX9Ft0jZdOKUB+91hyDXhY70PoxjMV/6VEQdEZMeDRm
	 MxEbAz69vDQCqFbHcErLaUpDkLqP0OaWu+t4Bc9Piy+tA9X69Z91Kbfroa62Ykupik
	 1LMfpBtRE5qim7sz+fCXe7s9k/NLHL5VuVAGi/BXIAORyYTFbjAoM5eUMLBCQDJjlC
	 cs/VQ9dzdsUXg==
Message-ID: <sashiko-outbox-195339@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/5] IB/isert: do not publish connections being
 released on a second list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125955.1530355-2-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
 <20261103125955.1530355-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:26:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_connect_error() and isert_disconnected_handler() take a connection
> off isert_np->accepted or isert_np->pending and release it, but they do n=
ot
> check whether the other one got there first, and the connection also stays
> reachable from the list that isert_free_np() walks.  Two callers can
> therefore release the same connection, and isert_free_np() can release one
> a CM handler has already freed.
>=20
> Make the list the single owner token.  A caller that empties
> isert_conn->node under isert_np->mutex owns the drain and the release; one
> that finds it already empty stands back and returns zero, so cma keeps the
> id and the owner destroys it.  isert_connect_error() drains before it tak=
es
> the connection, which is the order mainline already uses, so no drain can
> run on a QP whose id another handler is tearing down.
>=20
> A test-only delay in isert_free_np(), right after it has taken a
> [ ... ]
>    ret_from_fork_asm+0x1a/0x30
>=20
> Fixes: 691b0480933f ("IB/isert: Fix dead lock in ib_isert")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125955.1530=
355-1-yhlee@isslab.korea.ac.kr?part=3D1

