Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC150DDD7;
	Mon, 31 Aug 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183770; cv=none; b=Pr66/QQgxJ9kKKONzIzFgiDSbSjUq48meljAGFdLaofsc0ExPjrtslnvQ0bPSbQLwTYSiIdhrkx3pru81F6wNj1dZ1n56+Coq/MDeHDTst5NZPj19xqVkJPAMldjAH8W7sSkHOoWjFxRy1Eisq+4Pua8XKhcV6WZsdEJbSL6q9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183770; c=relaxed/simple;
	bh=Lj3n8giDCyd/Zz7tK2ra0cutH0lL3gMQplN1CdZGBSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnkUlddU1iGJfsjYOgO00G5MnnGtOnzb0ZsvutDZiXKUt/0Nem1nshObWobfDJ4Hu5yOehdFbaDgXB1Kxz9GlCFTtnZwuQO2axd/7efQ2wEWc8wJiykK68yqRKe/ylMKfxC9IJi4ApQ4nrUcqHZ7kfzfQLkkkELINEhbMK78VkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lL9BX/x1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lL9BX/x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0411F00A3E;
	Mon, 31 Aug 2026 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183768;
	bh=Ve/fJU7N34EYMbKe7CqMMk3mb+cPI8jDl3wWjiguQQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lL9BX/x1xQ6CBpTRHRVhBA52XH/+xCQ8sDzg4g4ULUX8rIgL5lVX8blCL3nZN7nsL
	 SIvxb1hG6ak52HMvi74wjepsZxQVRY3t3mnwMNkzTI4Gya5sFGSHFS3KUFcv9G1Iaa
	 HLH2jm2CwWDhiMgzlI82xNAAuB3fd9NIF86kYKuB4m7KQVR/NTDbJEwDm9959SK/ed
	 J3KXVYH0DMiiIsFLJDooXIYQ+fxTcHjFQJaf75bLlKg/0eMXmh3koR+H1mJqyU9hom
	 58JWyzjG2iGkoUA/lbKa++TQwK5e8wjUBI+QSsvYG1sdmQuE0kkng0szg8Js/Ee9Oo
	 5i8LIgOzHzGuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net/mlx5: HWS, Handle destroying table that has a miss table
Date: Mon, 31 Aug 2026 09:25:21 -0400
Message-ID: <20260831133314.4125787-293-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 60e9e82f162ab7399373ff2185119289e4f6dc06 ]

If a table has a miss table that was created by
'mlx5hws_table_set_default_miss' API function, its miss_tbl
keeps the table that points to it in a list.
If such table is deleted, we need to also remove it from the
miss_tbl list, otherwise the node in miss_tbl list will contain
garbage.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260507173443.320465-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `b4 dig` run finished without useful results: looking up
the wrong commit (`5d324e5159d9e`, the USB merge) found no lore match,
and the subject-line search failed because `b4 dig` doesn’t accept a
patch title as a positional argument.

That doesn’t change the earlier conclusion. The patch content and review
context came from the local mbox
(`20260507_tariqt_net_mlx5_steering_misc_enhancements.mbx`), and the
backport recommendation for this 6.18.43 tree remains **YES**.

 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
index 6113383ae47bb..07a3dd1248c77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
@@ -282,6 +282,9 @@ int mlx5hws_table_destroy(struct mlx5hws_table *tbl)
 		goto unlock_err;
 	}
 
+	if (tbl->default_miss.miss_tbl)
+		list_del_init(&tbl->default_miss.next);
+
 	list_del_init(&tbl->tbl_list_node);
 	mutex_unlock(&ctx->ctrl_lock);
 
-- 
2.53.0

