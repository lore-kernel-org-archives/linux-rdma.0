Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBF14AA1FA
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717301; cv=none; b=Kkm3hL5RjVa98ddoYULNiD0Il94s7mv2dvNOzrd0PUcQagcuOftI9NwTECN6C//9OqwCJwZEia5wYjANcRd4qLAYpicOzHiPV2GMvTiNuEAIv759E6kYmw2NHl1551KFHCHaizgtubmzCwKgna8V65P6BCHVxeamg50D4ctTyVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717301; c=relaxed/simple;
	bh=pEI8A1wxEYTqwxeua8JKL9DbYwIU7XQtfLWiizDtHWM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SbHFEWihMOmP2BEm2p+1yKAOlB067l9hXP4os3Tfz6+pwNGpHxOgUQUkbmhUHtqQ+m1V9otZaw6Ip0ImNEPVS1XlghSrCEgWzpXUFxO6rA7lgWoyHVGeloXm3ml+FACt3h9NEny+UVXxtPWv1NLdcbwO3HOI+Vl42aGBHxpG/6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHR0Vxnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHR0Vxnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5901F000FF;
	Fri, 18 Sep 2026 07:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717280;
	bh=zXK/oiWJDpT5eQZIPk13LrfIx8UVi5mm1dagvY89xmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZHR0Vxnw63v8FP1ufqnRrQF8nLCFyf6uf+0jFo1xizlReNm2krQlT28QeQ54clf4S
	 VIHmtZ1rzRIfheNLQnf89L/LWHXN0TRcVkVF9yvPlBKIIwwvzegvyhGXi+uBap0vVw
	 Jp/Pzqe2cVgmB4t5iS0FTEYbdoH8lw72ExShelzTmw7lSW9aehDxTxbjoBilK6fOq2
	 OWhb80BC2tqMiRv6gLYpLuYJPJ1ipWCappzqQX3h1FjmCrCoklxhNgKPa5qwaa5ERL
	 IBY2Vp4s+nAEv3LSRQj+q6F3GwSQMBoN3Cs8MVmFHqXaQvAWg+jFcjQVOr25kDVUO+
	 Kv9q/GuJfzhJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/rds: restrict the rdma_cm ids to IB
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917074108.174262-1-achender@kernel.org>
References: <20260917074108.174262-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:41:19 +0000
Message-Id: <20260918074120.1D5901F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] rds: memory leak of rdma_cm_id in rds_ib_conn_path_connect error pa=
th
--

commit 09995cfa814e39bb6b39d83f2fc5b812b28b6fcc
Author: Allison Henderson <achender@kernel.org>

net/rds: restrict the rdma_cm ids to IB devices

This commit restricts the RDS RDMA connection IDs to IB devices by utilizing
the rdma_restrict_node_type API. It adds calls to this function during
listener initialization, probe check, and connection path setup to ensure
the CMA IDs are strictly bound to RDMA_NODE_IB_CA nodes.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 4feb0edc360c8..a859c252fd9a7 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
[ ... ]
> @@ -999,6 +999,16 @@ int rds_ib_conn_path_connect(struct rds_conn_path *c=
p)
>  		goto out;
>  	}
> =20
> +	/* rds_ib_laddr_check() only vouched for the local address being
> +	 * on an IB device; the address resolution below picks the device
> +	 * on its own, so restrict it to the same kind.
> +	 */
> +	ret =3D rdma_restrict_node_type(ic->i_cm_id, RDMA_NODE_IB_CA);
> +	if (ret) {
> +		rdsdebug("rdma_restrict_node_type() failed: %d\n", ret);
> +		goto out;

[Severity: Low]
Does this error path leak the rdma_cm_id resource?

When rdma_restrict_node_type() fails here, the code jumps to the 'out'
label and returns without destroying the newly allocated ic->i_cm_id. By
contrast, if the subsequent rdma_resolve_addr() call fails, the code
explicitly cleans up with rdma_destroy_id(ic->i_cm_id) and sets it to NULL
before returning.

While rdma_restrict_node_type() currently deterministically returns 0 for a
newly allocated ID (since it is in the RDMA_CM_IDLE state and using a valid
node type), should this error path also clean up the ID to prevent future
resource leaks if the restriction logic changes?

> +	}
> +
>  	rdsdebug("created cm id %p for conn %p\n", ic->i_cm_id, conn);
> =20
>  	if (ipv6_addr_v4mapped(&conn->c_faddr)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917074108.1742=
62-1-achender@kernel.org?part=3D1
