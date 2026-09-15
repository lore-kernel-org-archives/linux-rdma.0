Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6641D11C
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443461; cv=none; b=SR4Ne1Irf9dOY2lB9RbRro5QRMCZObsLTIHM2ZAWs+2jXVhk68i02PF+HrGahoLcKjDGMXg0IMXraWL1JlhFi92TUFZCF1cnbcmPwNY5igBhf+KT/ds60tkt9s1gw2O051yHvlVFJWaVdnrfhf0DdGRchYhG5x4XW4Aqm3/DqJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443461; c=relaxed/simple;
	bh=4hjiGhUbbiZaDi2x65GprrfVXXhzQpXKIkwq9akRkGQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=roYzZ5GI/xrguXtzAvj3q+VR1qSTzQB6DlErfNro3vuI110HxDXVRJs+wrvQuZagnBndxCKRPQUvuuByjfxSYHms4gcE+/uF44ERUBKyWPUakH0gFngQ6JWv1FAl/5R3spF8woyHqNbo26ZVcMTs4zkltN93KW0bFUor9Wmz3y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxIOnfkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxIOnfkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF861F00899;
	Tue, 15 Sep 2026 03:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443458;
	bh=SZzx6OLjzOIUWRMdtDfwnmANyenGiAa6SyIXeQdwB0E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HxIOnfkY/a/BUqfAonXEd2f6bHV5xQTWtJurA8eJ2g589Ghkk5Ghl/6f4wJBuCr/e
	 hjvDfO8eOkD3lg+veseNfWsBl0SYhePR/dJ16MupGHHLguGBdbDJiMiLvO0t7mOIeN
	 tdrU7L6jgWBQL4TItLvGDeomDkkTJVKlj9maCOka2zcFovjmjJjbVx/cU8nFfwq3/z
	 M2hkG2BCLrCHtoa1bvHocZGlQsUnqvYOJA9JEMunguy2CDhqOns3uRvEpxtJXkX7YX
	 z4FxGXyssASxmCLFE0UhqhDs/sjUotuwpVS+g5nLCQqc3sweXRXsJDlDSW2p+7t1x+
	 YKS2h9A7PvJug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 07/13] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-8-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:37 +0000
Message-Id: <20260915033737.DDF861F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.
>=20
> That was fine while rds_conn_destroy() freed the connection before it
> returned.  Once the free is governed by the connection's reference
> count, a holder that outlives the teardown loop - a socket's cached
> rs_conn, an inc parked on a receive queue - defers conn_free() until
> after the helper has returned, and the list_del() then writes the
> neighbours' pointers into a stack frame that no longer exists.
>=20
> Unlink each node under the transport lock right before its
> rds_conn_destroy() instead, so that nothing is left on the stack list
> for a later free to touch.  TCP marks the node detached, as
> rds_tcp_kill_sock() already does for the secondary paths of a
> multipath connection; IB and loopback use list_del_init() and have
> their conn_free() skip a node that is already empty.  The tmp_list
> gathering itself is unchanged: it still exists so that
> rds_conn_destroy() is not called with the transport lock held.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D7

