Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF5390985
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208303; cv=none; b=OkvyDBpt8NdfZxerkgQam+Gz45xbiFOftMA6ZGtq0IkSgTz7GUCF9/Ha8+I+09iceJQP8YFBHn4zrCbsQqkI2hlNG2pn5W/xSYl91jleMmmmy/0loJZS2dvXZX1oJeHIc4BXMoMLCcal/PAeTUWdIaL0RYPqgTNHnZovDSISl5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208303; c=relaxed/simple;
	bh=mB94piuPl4jGptmNFfcbDZWRowXmpCwX3ZxojmGUUL4=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=nQh+I2qXwNYuUFSj6qp+XvJDt5l5Y+VVbKlKuJQyO9MFzJiH3itjVovJF1utCloQOuOVODxlhQOZVqHLv6h+Hdeu2YZXEKRD58J54qmtpJThpDf3KPGO9+giLCHX7qokGE3fRLlscojfCuJTZWGXKAN2Lm6w9q8BqdvNNpXZ+3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJuzNKKf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJuzNKKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90B01F000C4;
	Sat, 17 Oct 2026 03:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208302;
	bh=lGYCIBSSxXcuzH3IuUJAIxeV5wt2dSM2ijaExNQN/JE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NJuzNKKfvg6EIDMoRI/fSHnD898gfLDxNjptfLzjaZkHjUGpuuBNT4bSSisjDgwp/
	 ujDF+WzXLRBZbWuQ6Y9T3CG64ZucYQNcxwZI3Hrz9Mw/XTOG8ttfRei6kH4j/cz25D
	 7WSv2Ml/8KUXwKZJmwzH6oWu5ETt6IsUbgw2ZetDn4v9BK2RdGwjyI6n/u9lqBQebE
	 pvSOkUX3g1oPZYYj2uASKD3M8bGaDdg+Blc8WlG67GT5OEI2mE4dO+Iz+qm4C9kcJO
	 8kqlnuDTIVxc8+o4Qp+Y7dLX/91mNyqF0KbyyH9hjJLEDsgPin8ujjZx/tcG0tgJ2V
	 lZhN2+G76XM5g==
Message-ID: <sashiko-outbox-175264@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 12/13] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-13-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:22 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context, which carries no reference, and holds c_cm_lock - a
> mutex that lives in the connection's path array - across the transport
> callbacks.  Before this series that was already a use-after-free
> whenever a callback destroyed the connection, since rds_conn_destroy()
> freed it synchronously and the handler's mutex_unlock() ran on freed
> memory; the one such callback, rds_ib_cm_connect_complete() on a
> protocol version below 3.1, has meanwhile been switched to
> rds_conn_drop() by commit f97d8c7bab78 ("rds: ib: use rds_conn_drop()
> on protocol version mismatch"), which also removed the deadlock that
> destroy took on c_cm_lock.
>=20
> Now that a connection is freed by its last reference, none of the
> callbacks the handler dispatches drops a reference on the connection
> it was handed: the version-mismatch path only drops the connection,
> [ ... ]
> rds_ib_add_conn() refusing a device that rds_ib_dev_shutdown() has
> marked.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D12

