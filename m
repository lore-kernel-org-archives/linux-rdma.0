Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A591C3D7D9F
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884729; cv=none; b=uCaATvZYa9MHSt4QQ4AWwGctLPU3M8sDXBtaaNezc5GFCiIx1EwZINwf11yUNGrQ7eeo6vjlvuxpPf9A8sHaNVZM19pns/AX4oT1oOqQD8HiH+ID2pxCVixUCfnapv/r3jBMQ7wv/pFdj6Nuv8tLPSgQEwS41kRFKuhYKGNumiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884729; c=relaxed/simple;
	bh=TMB4XfecCD7HRe1N5Wxm4dzE/6Vz89gefpyr6pTPkZQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LTRrxEq9VeJ2V0FWe9bPwH2VDMjwM4iUuqzi1U8xlCWUFCxpiyCeI+w7/G+U1ke6IDIHF9mObCTuRa/QSQ3dtiaALeKNHCnhjjFYYDw7oijFPtsAHkCG6camgdoOxNK0IySWzMDZmyabTNrc34WOFHYptmQLpTfIGodgri7/PN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikY0Gu1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikY0Gu1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE5F1F00898;
	Sun, 20 Sep 2026 06:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884728;
	bh=FNeyTEuT01N3XZRe3ra4Un/Sq190FCYqUWfaFjK5REU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ikY0Gu1LXlbICMWoA2ZEDYGeZEF6+kqZPEgW/ltXHxGySmnmcVn5czPHaZOSuq5mn
	 dpDS2zO8c7yFD2cWeZH5Vrxa/ynnJZD9WwIVZmyavkUWfgNHE3980J6OrqSUTjjMKL
	 MnEjGOO4iz5Cgqc4YDvzwdDcyH8C/6OY2OciZ4G57JvabTaAaSjT3HfQM9Q5UR8szP
	 a+QSQRwOHX8NOFilE/I9A/c74+n7XNpla62EUfaBfgy/c+DzXvTg+p21HSCFe6OCjw
	 vR4116DGsIJkOE4IsECCQEU92eicFdJm2C/WdU6Ps/3ZW3AQ+8EKWBHWS3f59uod79
	 ujMdwJuBKCpwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 06/12] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-7-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:07 +0000
Message-Id: <20260920061208.6CE5F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending (a racing lookup-style holder, or simply the destroyer's own
> put not yet run when destroy was invoked from another context earlier)
> would execute transport module code after that module's text is gone.
>=20
> Count each transport's live connections in t_conn_count (incremented
> when a connection is published in __rds_conn_create(), decremented as
> the last step of rds_conn_destroy_fini()) and make the transport exit
> paths - rds_ib_exit(), rds_tcp_exit() and rds_loop_exit() - wait for
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D6

