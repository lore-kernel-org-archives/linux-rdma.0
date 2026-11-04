Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756824;
	b=pgZ51c4lJsr6cHglsyo7K+lPq0ijWotVLXKLqiIC2c9ZOKf5RFRagT1aqzXbcwlw3V+L
	 fknyGt5m5ja5AZF9jnEXsay3kuk4JyTY8JuQV7XkASd2SeuLbQTh1nHFW8jDeF4inGW7v
	 dntblE3nOyRpW3UjNtqC0nSIIgdG3m4MvkLmxE6KYrBu7tKZVmahQgpPrebEIgoBEb4ul
	 r5qw3I9KhHjSdivna7mrZv/NmdXaaacBLVSQhavFxCpAHY1WMIOOBkqLnFIfsxqb7eeXv
	 5O8R4sR88//01j5QOxFg++bmqSVHbz0CiwpacQMTrnFtG8WOhcOkpYmpPEm6R0+36pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756824;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jsI7Xu9iMaADI549hPCY/f4z7pb1zbmcBVBLclSyJRU=;
	b=E0FUg/AVG3AgAKx2eLUA3D7GkhvWJXCug/o5PuSF9CXBOfcb7aLMl7jEQgRYHw49MApW
	 52yOstWgvWpW0/eps2n66Nw7IIYoMuJAEM1valCHhmgzvTxZiYOG85o3NIlfVy0fCarr/
	 5l3q/R9qTns9SAFJP8kgHFm1d/Wc8Duq98CI1ngmmvGoTt0eTdBAW9QQfOEEbTrwSe5F0
	 8kMJdiwnCQiYau7ys+cHCbT6ZqW7FL/Y9+7Hj4gNbMRj0VozTuzi2m7NGXYwJDB1PWsmz
	 95voJdPZ2u7LO3jqVEKulIY7auyZPakAMnuOyVpmtuCGbxsaYFsk90I6TsZM3n2BXjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XReC23cm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAECC606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XReC23cm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4401F000C1;
	Wed,  4 Nov 2026 01:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793756823;
	bh=jsI7Xu9iMaADI549hPCY/f4z7pb1zbmcBVBLclSyJRU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XReC23cmelvK32KufUIRTk9hfn1NPtoR3+4W6o+REWWxUuArQ8WPtVRQruvcQV4dL
	 t4qJAl6R848ZLYUBFeMiOydgELnvdhLIc5d5D4Z04e6PhlsVSPLBQ0cuha8DPUMjEj
	 AyWpl2Mwvu3Oi6063tDN7S/i5rT++ukqiGU6gHtIpog6yAcUvZBmkaUxE4bik5O3ih
	 wv3Ezzkgjow28qXfOb8DePcHAe+sYJ5s6xRtrgtDqrwRyPGf3mEKHziKJT9LOa8xUP
	 Wij3eU5tLbfl95siihHSrehPA7MEuS2BvFLyvnSKJO10fCdm2FQT2iiJcpB9PCziMT
	 qCWFdnGu84G+Q==
Message-ID: <sashiko-outbox-196381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/6] IB/isert: drain the QP without holding
 isert_conn->mutex
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104012219.1759523-3-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
 <20261104012219.1759523-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:47:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_disconnected_handler() drains the QP with isert_conn->mutex held.
> The drain waits for the flush completions of the send and receive queues,
> and those are reaped by ib_cq_poll_work() on ib-comp-wq, where
> isert_login_recv_done() takes isert_conn->mutex before it looks at the
> connection state.  If a login receive completes while the handler holds
> the mutex, the completion handler blocks on the mutex and the drain blocks
> on the completion that handler would have reaped.
>=20
> Return from isert_conn_terminate() whether this caller moved the
> connection to ISER_CONN_TERMINATING, and drain after dropping
> isert_conn->mutex.  Only the owner of isert_conn->node drains, so two
> callers cannot drain the same QP; the send and receive queues reserve room
> for one drain each, and a second concurrent drain hits the WARN_ONCE in
> __ib_drain_sq() and returns without draining.
>=20
> [ ... ]
>    </TASK>
>=20
> Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104012219.1759=
523-1-yhlee@isslab.korea.ac.kr?part=3D2

