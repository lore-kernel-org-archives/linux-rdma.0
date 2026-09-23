Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066C938838B
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157566; cv=none; b=DgfeAeVM1RYLJjUbr/xgNzXHzeHIBQndYcf7qcZGowKGYK8qq+og183cbrR8nnelheQX2BehqUbeTS1bzk2ABuxK+owGqlCjXk6ek27gvWTjYfbbfysHG66OUneiSTkh5pGjGd0zlQoxGVYDxI4mjcHP4E03ZLa7wGmwhZnVOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157566; c=relaxed/simple;
	bh=UAPgLa8ymqSxKVmd2Ok9Kk9eJgjhir5OXtm5k9zHqFg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p79dkaHONwz4UZ2Fxi0zrE9ziakf9m6r7BqK6ANZsyWU7P/aBcbH6dcsFXMSz1TzJ28cV6CnwkgF9HzIzO10oCCJNeddszTHhIzqN9z6/WqCHdFhLQwu7MxxXBUQYJA+BORLedSQrUqJPymERSQ4oWwLVl36LDFHgjcfLccriqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IK6rUmRR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IK6rUmRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799041F00899;
	Wed, 23 Sep 2026 09:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790157564;
	bh=UAPgLa8ymqSxKVmd2Ok9Kk9eJgjhir5OXtm5k9zHqFg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IK6rUmRRLMXfgRf1MlJmhYRanOlsMKYCr/pR7liz1jNyRe5u1ZgxBpiQFY4OBEMr0
	 Rwqihh1JIzPF8aMCDxnXi9KEvSsBQPLagf6trGZPSxeNsw7mS1EiuQWZ9wxYPw5/ph
	 Q0wiVZmMqp4H53XsB9dS5ivA92Qsv/NObaIdJcGT1isIvA75wf1JPNnmNtQ/D1GmWr
	 9yuATAOqK7evUAcjXMvT2qAqltXb4dRG7AZ98RHRc2Zl/1pk3E8K6tRp1Rm0uKmdI6
	 jBGvRfPIEs5KDRw7fhCDA2P/ZELwQxdTPTVaY8HNPErClvnghVbi/0DmlJksPLeZZE
	 BEZjhrDQWDsBA==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v2 3/5] RDMA/ionic: segregate rq related fields from
 ionic_qp into a new ionic_rq struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922095724.3683011-4-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
 <20260922095724.3683011-4-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 09:59:24 +0000
Message-Id: <20260923095924.799041F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Amit Kumar <a.k@amd.com>
>=20
> In preparation for SRQ support, segregate rq related fields from ionic_qp
> into a new ionic_rq struct. This refactoring enables both non-SRQ and
> future SRQ code to leverage the common rq init/destroy infrastructure
> around ionic_qp_rq_init/_destroy with no functional changes.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922095724.3683=
011-1-abhijit.gangurde@amd.com?part=3D3

