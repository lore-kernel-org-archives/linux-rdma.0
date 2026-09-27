Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A233BBFCA;
	Sun, 27 Sep 2026 07:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495828; cv=none; b=TErEZXDx9Pe4lO8CzWQZQ5ppTY2jEVzn74g19YnYCMWxktWUZnfE/ri3+1eZuFss8kkFRdc3tLcC7+h9WZuRK92fVTXdSz3z+mIMCfyof59DFxHOOaIgLVeQnFsdsCfyghhX2Fgkmd6p71xJpRThcEYM2xe47M3+/7tFIlgQrOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495828; c=relaxed/simple;
	bh=TxTORggkT5PVMZ4Ui8YEp9PSMmfCMJrR5/JUUUvUHbo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LBqXu/ddboH1i7XE1fKcx5zfFX/jsH0gduKdtqhLKOlQzmHtm3xhJlAGZDR3biZxWpmGCxxUUKEOuLKHa1XB+miUTxSb2NU5eQp3A/SLjzfnv4wAkSaVIfkO+Zxf/1zJB4y93UhjEjkGmF1P6eBCYSQYRH7sHs6Kscu8ns1+BjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CepePwEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CepePwEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8314A1F000FF;
	Sun, 27 Sep 2026 07:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790495826;
	bh=495FfSpG2Lnv0U+7tVcZBkLnlkouGgT0g0BBz6GxUa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CepePwEyIx3faNyrGpVMAEWR3STKHvocfEKFL7cnUUKS76+ZzNabOj3+IVG8GkVqD
	 FlAztKG3SWKZjLN43cJIcvpo9GHUD09LYtJdBTwu1IIz/elX1FfujV7J+gjBpUJHZn
	 xRPcHXroY5b20q7v2G6Mjmqn6I3VZKw949+juAMQVuGSU0Z3c4qRPhvc4B9UtsMNlf
	 37pvyOHRTXGep8LPQiMDLHP5tAWbl7b7AQDUSpRapKzo68SFUuHsmJ6QQfRU/BzGVz
	 8WA6orovoXDEx4QXfiqV5Mqhhsq5m9Av3opOB34mGYD0BzAgls3Lb5OxN4W8VGvbpt
	 bEWuisJXQzM8w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: serialize link group free work scheduling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260927074520.3694663-1-nicoyip.dev@gmail.com>
References: <20260927074520.3694663-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 07:57:06 +0000
Message-Id: <20260927075706.8314A1F000FF@smtp.kernel.org>
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
> KASAN reported:
> [ ... ]
> scheduling, keeping the group alive while acquiring the lock.
>=20
> Fixes: 8e316b9e7260 ("net/smc: improve link group freeing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927074520.3694=
663-1-nicoyip.dev@gmail.com?part=3D1

