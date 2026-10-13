Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D5C3F4125;
	Tue, 13 Oct 2026 09:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885111; cv=none; b=ZclY13D8GYz7BhfJx0hHgKneOMabzeFUsL2qKT5FqXoG9OcMnAJXCgbNanNqmQnf13HguLsCwBVy3E4kjW1X2IjmDmisPhXAe4z6PEB8LQhO+OMJEKEZPhRZfgzVN2Y90tmucdIWH43fcmSExBonBj5kJf/bxK3vGoeEuiWx6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885111; c=relaxed/simple;
	bh=wjVsGgEVAS0EKS82pjnulKSNqzuxLm0EObY7XumYmrw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jpOOGmcaMFwFDvG6zTTsa+34E0BF1chmBYDhNS1PQN21j35RaEN/wLJ2zDhFGpKw5JAFgtQAb8m2Mf+bOj97QiXh5pHkNWLzqWW6gYNT4HtVrXXYzn6fNZdLgSDbXghAC/lROPe9gc3aNNLYPyBhOjxX2J9/1x5Vb3AeD7+q2JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOzySjjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOzySjjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E931F00893;
	Tue, 13 Oct 2026 09:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885110;
	bh=5bb43Km8IYsRRUYkW5FtzMaN2F3v99BkBO5aoDYxQRI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YOzySjjUl67ow0Pfv2PbpQr6Ua+Et5PQSa2mQevlRvWY/F1C+cICQpV8rqDJcMC7s
	 1l4ekFCl2uHJeIAyrqdY2bTEvZFydZl0oWB9hrkBXfu+gtePV7Py4hsEKlfcEC1US6
	 3HXOokc3r6yNJVf2JsnJnwhxOSL31zjm292BceUflWCeUiYx5JnQa/bKF8Rvrmloer
	 eKjKuQuRL4/KuuQmQHm07n3jZ4PGh6iwkoikwdeAcIrF0G276E4FeA+dPCZaZqlqMw
	 aSK8Po3yqUQ3K+mY+E9wNnePAjf81lrq/lZQ6bpJvcNfD8BIBvoB0lfEpwGIW2jvBv
	 s8/OfYdYVk9Pg==
Message-ID: <sashiko-outbox-169391@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 1/3] net/smc: serialize link group free work
 scheduling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013091716.1210420-2-nicoyip.dev@gmail.com>
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261013091716.1210420-2-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 09:51:49 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_lgr_schedule_free_work() checks lgr->freeing without the link group
> list lock held by the teardown paths. A concurrent smc_lgr_free_work()
> can set freeing and cancel the delayed work between that check and
> mod_delayed_work(), leaving a timer pending on a freed link group:
>=20
>   CPU 0 (smc_conn_free)            CPU 1 (smc_lgr_free_work)
>   observe lgr->freeing =3D=3D 0
>                                   set lgr->freeing under lgr_lock
>                                   cancel_delayed_work()
>                                   smc_lgr_free(): drop lgr reference
>   mod_delayed_work()
>   smc_lgr_put(): drop last reference and free lgr
>=20
> When the timer expires, the timer core accesses the freed memory.
>=20
> [ ... ]
>=20
> Fixes: 8e316b9e7260 ("net/smc: improve link group freeing")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013091716.1210=
420-1-nicoyip.dev@gmail.com?part=3D1

