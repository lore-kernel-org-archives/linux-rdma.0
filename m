Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D0C2E738B
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 05:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789623155; cv=none; b=jE9uvSxUoJASqKcC5Mtg57B9q+3TJtUKz72Bi75cQGU5ThutC+TWIn63FjSXKYLBhxluTiKmg/hCeuLuExsxXhDOh7/VEUvKTR1SKJwgy141yUesgLV7eXpHvZgmtKd9yGIiuu8+S21wWbZ/ri6M2Hc6NOhWBw2CX0QskkaZRIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789623155; c=relaxed/simple;
	bh=cO/5txePaSY4s51M0BfeqacmxPTHxN9X6T48w3DmMX8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KGvGaNXAQscvo2x17EG6v/g58t0BK93J1v+fHGImZT3wmC69tE1U0uje8LwwRAiyF8IR/52BDaJ935ld4FF6g80YhtSnAd0uksnTSAGuqH/pc3tZD0wEMWKMRPAGj9ha6cLbmk36e+3wwS34YoeMOZ9It/YZhbLNNsjSRdeFeZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBp5yeZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBp5yeZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671B41F000FF;
	Thu, 17 Sep 2026 05:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789623153;
	bh=c/ZxsAx5pMRc6AL/7+r/Fsln5TPIbe5udLQ4Z7WdRYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aBp5yeZJ/V6loveQWWFGiXdwKKSWEDxvM/FR89B8wIZhLjIy14NFOloCiMqOMAqqf
	 ArO79W1jl/eKuCg1ZfEOYCdrwtVQm8RV7ZBztk/okb2j2iY1tv62kcHrxr6Gz/NWwV
	 y018z4IqcOnTCNO4avTzMvUTbH6Vcpz3Ir07eKN4nGLYg4UDfItEjxs7Lr5Sb61U29
	 /aPgrF7Ldo6iNVP+AdjpBa0VhkegRwbk2/hn6oA/xajYMKACvpv798W7nkGsniqef7
	 Y6L6W7S4If5Kl1pJKVT/L4LNyu2redd6dyx4s2RuiJr5rr8NB5aZXfdcnzZmRWc5Hx
	 cNh0PF2kNr5mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/multicast: Fix rb-tree corruption on MGID
 reassignment in join_handler
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917052012.2181-1-lirongqing@baidu.com>
References: <20260917052012.2181-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 05:32:32 +0000
Message-Id: <20260917053233.671B41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> When the SA assigns a wildcard (mgid0) join a concrete MGID that already
> has a group in the port table, join_handler() erases the group from the
> tree and calls mcast_insert() with allow_duplicates=3Dfalse.  mcast_inser=
t()
> then finds the existing group and returns it without re-inserting, but
> join_handler() discards the return value, leaving the group erased yet
> still alive.
>=20
> When the orphaned group's refcount later drops to zero, release_group()
> calls rb_erase() on the node that is no longer in the tree, corrupting
> the rb-tree (a stale parent pointer causes a valid subtree link to be
> overwritten with NULL).
>=20
> Clear the node with RB_CLEAR_NODE() after the erase in join_handler() so
> release_group() can detect via RB_EMPTY_NODE() that it is already out of
> the tree and skip the second erase.  A successful re-insert by
> mcast_insert() restores the in-tree state via rb_link_node().
>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917052012.2181=
-1-lirongqing@baidu.com?part=3D1

