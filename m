Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765796;
	b=IARGkBiXYs+0V17gf5Gk13g+tIX8ktPbbh8CdNEjZFpwiLwV6e7NcAJYRv/Y23bw2gPG
	 T8FIv/fzoFF2MoRi8bv2q7c/k2QuxG6nvNZ1POBR7WuRr7L4/QyIP/yVqHfCggCtwsNfK
	 mcPK4SAOV7yO4HDpfGYdvqZR2UUB+CUjC2HaXfhZxdW6SZUYK9i4BVkSbUDekfXhoAjiU
	 J+wuVGQxcCQGewRq9s4e8YDEhVNTv39XXTdpkYHZkY3wc9in/r7B4t0VxkN2zpgLMtnt8
	 LLpFQq71DvtNwn977ZmzSUKan2/P1wdIgfZxvPysBUheBOT8RiK2A+9iLfO1hjKxPpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765796;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t060X5IjwyMU/txz2a3GcFctu+2pQeVpGNmMboT1+y0=;
	b=B9O/j89UA93l/dB7BbHymww0alI7x1WRol4uAZsmcyfCx+nj+l6aM+FG5m0oKAu+InVI
	 2FrCP3LYMkXi/BPzv0v+YdgCNXq4BgJQJhDhnPs4Fa3JzIufPsoyq134sgQoQmezFdkQT
	 mDdlW+YqCEvOFW77HVogzJ908jw9VE4J63E0AlbaWckQHf0Fs8HaLEBaayBjY1osHgjFW
	 Wf04uM3JU43OR49e8D6m8HTkVT8C7IdFEJVNcMy0wAViDEzaP2YVNgZC49Px3DcyMqCP6
	 MUjWwOzFdgFcN7hhWmr6r2c6fh26TeddTnt+WzC98ojQVMnc73uVpkvX1/acLZXnCHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeyJgeOg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF70606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GeyJgeOg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997061F00A16;
	Wed,  4 Nov 2026 04:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793765795;
	bh=t060X5IjwyMU/txz2a3GcFctu+2pQeVpGNmMboT1+y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GeyJgeOgE0CdW9sESMKGx6f+ITiCpk5m/zcKRbCoe0S3jlVAQGorjmCGxs7FRGroc
	 6mEcuGOF8uV9xZLmb7Zji8rjyYYTAapjL2CUMLZXcflMi3qntne5P6Uxcl4uz6CrlC
	 6Cu8RGfo8PHFaVhlf6OcolyN5CUIB/HgOkxC9uVdekkZ1/rHnHDZoTX+lnzIeRdwE4
	 IDdRCr9SiS+TRMdrekoSj1Mt+XeJ1lE3lVPX0pWpw7vSBE0S8jBRMzp2hRBl5eL80Z
	 vanBmLQp8ujl9t7aMiBjwatG1yClg30oo1pXJTk/ww/zbnjAr992Xk5Vl1LTZITqS5
	 IxoQgTwhJcjVA==
Message-ID: <sashiko-outbox-196648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/6] IB/isert: drop the promotion reference when a
 connection errors out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104040318.1844865-5-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104040318.1844865-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 04:16:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_connected_handler() takes a reference when it moves a connection to
> ISER_CONN_UP, and the paths that give a promoted connection up drop it
> again.  isert_connect_error() does not: it drops one reference for any
> state.  A promoted connection that then gets an error event keeps one
> reference for ever, so isert_connect_release() never runs and the
> isert_device reference it holds is never returned.  isert_remove_one()
> waits for that in wait_for_completion(&removal_comp).
>=20
> A REJ after the RTU reaches this path.  cm_rej_handler() accepts
> IB_CM_ESTABLISHED while lap_state is IB_CM_LAP_UNINIT, and a passive id
> stays in RDMA_CM_CONNECT after ESTABLISHED, so cma_ib_handler() passes the
> event on as RDMA_CM_EVENT_REJECTED.
>=20
> Drop the promotion reference too when the connection being given up was
> promoted.  A test-only knob delivered that event to eight promoted
> [ ... ]
>    </TASK>
>=20
> Fixes: 954f23722b57 ("iscsi,iser-target: Initiate termination only once")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104040318.1844=
865-1-yhlee@isslab.korea.ac.kr?part=3D4

