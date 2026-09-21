Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01393264EF
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 03:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789960977; cv=none; b=Idsd2r628eUYWv8cha/Caj5uwdjtjnGH8UqTQLKLuMMz93naQ3vNm3kY8WBVW1LXzqzG/DtMz/P7s/9HTaaIajAHR45/AE9FRfbizE3KLiDs3dpFK4Ecrzqdqyao6t6tqJOnvqSU+55nYFlKG4ikfgIOoMeDpMuP9v7t4URgZvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789960977; c=relaxed/simple;
	bh=H28Q8E0IgAOYGlXk8VpQDVEQJJ9pjd0+GbEM6oCb0fE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gW8klJw73uP/oukpsjBuclEeoz8c7vF5aEL0dxdMMn5/IbfP6VH3b1c7J7Yl7BBtmMmDgXzfx2HHMQBRxU3UrYA3GmXphp4RChINoAapI1Op8zkX3XMyGXWTZNo7DDglC0qkLGbcAYhADV83G83AEzV8n6O9gbpPHsdv2ho8C9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUVNRTlM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUVNRTlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1758B1F00893;
	Mon, 21 Sep 2026 03:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789960976;
	bh=mH5QsBO3ZANbCDPK7x88ddIAUTo2FjhdIJ5HXLTnnnU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fUVNRTlMnhJms7eGAtU/ePtXLjPCbLufMi4YeIItlwU3u+ytx1MdgZyJLgaHeeK2v
	 SMSKxjNW78HTIphRDSaA2jp10XADRU9H2GVcV0/3uEKaEQjKyuq+gefb8m1Kmd/xdf
	 iFVnDQnIHSFopXPZ4UyipvLf0E7YGyoK+hJgsVCywrQiKkzfNGWdnLR+31rta2xlJH
	 pfR1V/CkOWH1K1kRCTTf+BuMEmSmVN8ld+8I0t57/jtRlY/DB0CEYW2PQggbBnJpVD
	 vqpLftPXQ6XVc48RL4UE+Hwt60av3i4QPEJnhXSr3scOwG5heh7beqvtOgk2Rl1RGy
	 wtJtIqRsFak9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/isert: Don't share drop_cmd_list across concurrent
 connection teardowns
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921031100.2199-1-lirongqing@baidu.com>
References: <20260921031100.2199-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 03:22:55 +0000
Message-Id: <20260921032256.1758B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> isert_put_unsol_pending_cmds() declares drop_cmd_list as a static
> LIST_HEAD, so the list is shared across all invocations of the function.
> It is called from isert_wait_conn(), the per-connection .iscsit_wait_conn
> transport callback, which runs independently for each connection during
> teardown.
>=20
> conn->cmd_lock only protects each connection's own conn_cmd_list, not the
> shared drop_cmd_list.  If two connections tear down at the same time, both
> threads list_move_tail() commands into the same drop_cmd_list without any
> mutual exclusion, and then both iterate and list_del/put it concurrently.
> This corrupts the linked list and can double-free iscsit_cmd structures.
>=20
> Make drop_cmd_list a stack-local list, matching the pattern already used
> in isert_free_np().
>=20
> Fixes: 3e03c4b01da3 ("iser-target: Put the reference on commands waiting =
for unsol data")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921031100.2199=
-1-lirongqing@baidu.com?part=3D1

