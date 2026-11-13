Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546313;
	b=2IWPGrU5GAXeY/SM7PjBr59mL0fbnkKIFZ37hWZ1eH1zKx/oFF6fSAndFIlslO+/8+wy
	 azuBB1z5LFu3hxhkezIqRntx10rIA++GQGysjxjaDAGXnLUaPsIXHtpQokl+bvdk5irgG
	 rPUnKGsMalOcrMjTL6C8bRuIPUFBuZ0L8T5egJkRgiyM9AYNjoZc0ILnF7GiGule23EZw
	 x9vKuU5cTOedQaUMNLjXMlvJ7jUGF30EhZi6TtjXPZmV4U1QXnNy8tcyDPWnDb7paVGaK
	 EG1lOtziz8rju5hmOB02k7M+K1tGrv1sTcg4EIcqKyXOKfFM/NvddHeZ22FJ6vh/UXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546313;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=90cnO2si6E3JEKFbtIU1ur/P6QcVp9kCxgqeylGPwf4=;
	b=bzHQS9jht0RpgXaKeJa8sqtnSToBvnnDpWK0X6IY9jLbQo7ccmYJiK+YsHdKWQN1yVNV
	 o76EqQz9lUOP4e9k7acA6orgh+qO+SXwvChryhXUXg20HA9d8657UvEaYv+vVqpRsBZeK
	 uG1ucK+e7ps1RgJyAPG4Rr3SaP6K8/V0deGTRDTAzPXirlnCssIkFpj/V0loWVEv7aUkm
	 pTWB8Ucy689hZjlEA+lXc7pNiaowjs/ahQxxeXEY7SX6OJS5Z3+Me8U2jvrmcyFcBnoJk
	 vYkORmNLDPjymGHnR/C7ol3+tnxohHhi+8vCo5t/8uF4sY4buxdKoCR+LaEUE2hr/Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TlE+7zad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183BB606A335
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TlE+7zad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45201F000C4;
	Fri, 13 Nov 2026 05:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546312;
	bh=90cnO2si6E3JEKFbtIU1ur/P6QcVp9kCxgqeylGPwf4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=TlE+7zadbBOlXb2tJFSSwE6/yVgnblpcWMmGtqHtemEdZ+vbLamagRsHTCWNQXcJ+
	 nRoeknMkTI+f3uyBqbqSoIdxuQNjrlY7J6ST3Iv/Yws7jT27hBquu2HQ/7ztPnSgdj
	 vJwXMUF/vNG0a16bYPUAbRIIamuZGgpq8umOtAb9Nfje2zEASRQfuQ75Ce2yy5MzFt
	 WAfaLEfIf4nqwn+6nKerVmkcJk7cKeflMCvQQu37qDLl7oYDHu6Ml4GkBdmbUolUL2
	 +xeS54GV2GGpWSQMoK6bmTOafWisCXumy1m4nryxYAvsInYCKz/fN6GbY0j6TLlrGd
	 4e4squo/KHO7g==
Message-ID: <sashiko-outbox-212193@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 04/12] net/rds: make rds_destroy_pending()
 report a connection's own destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-5-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  However, nothing currently stops the
> work-requeueing sites from queueing new work on the connection while
> that happens.  The existing code would suggest that this protection
> is supposed to come from rds_destroy_pending(), since all of those
> sites - apart from the workers' own self-requeues, which the sync
> cancel in the destroy path already rejects, and the destroy =3D=3D true
> rds_conn_path_drop(), which the destroy itself issues and flushes and
> IB device removal issues ahead of the module exit that destroys the
> connection - guard the queueing with
> rds_destroy_pending() under rcu_read_lock() (the last stragglers were
> converted by the previous patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> [ ... ]
> missing pieces of the requeue guard, which stand on their own.
>=20
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D4

