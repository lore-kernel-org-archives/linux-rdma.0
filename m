Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A259F37B030
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790042255; cv=none; b=Zqa67H9hwTc+lakRH2zW+aNSfHIhLmyfzGPB/l4xPCgz1boxuUv2AfFTde7EDxPLFil+MRfcEluTmNh6pVUeN5ycfbnE8iGyK5isGpi6b5Slbz7+6gXHFcugb0LZGTw+lsm0msx0Sr+Gt0VAFmuHYgT/hJVmto1iis0p9nJA39g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790042255; c=relaxed/simple;
	bh=MlAGprmqu03MeLLF4Ec1WeaaYyy+zbScrl/dDeXtGls=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pDFcRCD6fvzmdSPamtHJp5bbx2N0ffqvVsfEHXWWKQcZHVLIYe039tvHYyLWh6LdCnhlRkAWkdMJcCXZ1UI7oZGrdxlv1uNM0HbPDNHV7bveDtvfgUZd6UpwtQhLSME34GtegeUEDFozclAH08/WAbzbNAklA522eF9bO7OoqqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTozZmiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTozZmiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D6D1F000FF;
	Tue, 22 Sep 2026 01:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790042254;
	bh=MlAGprmqu03MeLLF4Ec1WeaaYyy+zbScrl/dDeXtGls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hTozZmiL6P50DNhqhsD1mRQZLUcRNPIFyD03zBthHud4ofWTir/fxpsN8AZt5GRL4
	 64cZpwaUO7oKWI2ULSwaRDfUD93xuNFlreyS7JubZFKkwicAWNnpThaofKngdqc64y
	 KU28Sv/+l1hA+d3mKHSX1BvKMbcSGRNF3wfsMXZabWGyskVJ5gipfQ9SdgWFA2pp+D
	 yUceFVQMDMF6I2nTKHPtAlUVI3kWeZWX/It2uNFkcP4kDB8hcn589GdYSWUHvF5zKC
	 /03BnmBRupcffVm0ZP9kEIkegCHgkMB+FoZSadxTSZjbzVlEqX2NouVgRdMA39/bHB
	 QKusIwx/rWXmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/5] SUNRPC: fire svc_xprt_free tracepoint before
 dropping the netns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: "Anna Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20260922015128.240977-1-cel@kernel.org>
References: <20260922015128.240977-1-cel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:57:33 +0000
Message-Id: <20260922015734.00D6D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> svc_xprt_free() releases the transport's network namespace
> reference and then fires trace_svc_xprt_free(), which reads
> xpt_net->ns.inum through SVC_XPRT_ENDPOINT_ASSIGNMENTS. When the
> transport holds the last reference, the namespace is already on
> the cleanup list by the time the tracepoint reads it. The window
> is narrow, since cleanup_net() runs from a workqueue, but nothing
> holds the namespace alive across it.
>=20
> Fire the tracepoint before any of the teardown steps, while every
> field it records is still valid.
>=20
> Fixes: 11bbb0f76e99 ("SUNRPC: Trace a few more generic svc_xprt events")
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922015128.2409=
77-1-cel@kernel.org?part=3D1

