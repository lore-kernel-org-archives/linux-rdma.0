Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746860;
	b=KDduBBygFZ1XwwCA9oTW5FuajDLOHMxPZGTN8+KVLKN4b13payFZ2hVQVngO+obOt3ii
	 nAghHoNhMbmQLMPoeqK1QAU9q5ifJJuuXlw3/zaba7DpwUMQEoz0AvXJGdo8yeDo3pxF6
	 14YaWF157aMsrTydomCVKC7+3SWV+QTVirpJmwRj1tFR5AouKEd0t/5cGrp1wyo7KjdqB
	 Mtl+PqUw4e4T7zYqVSd42nWOEyKM3jr8CoFBJkGigE9RJd/0Suk0G0BeWwr4kaQm80huH
	 KDXSUlkkc1wsl9sRP+P4VrKHQFCMu+tiImgS+y3d58yy3KKW6vEk2n8Ms7zHyf79dUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746860;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OLu+CnuhZDxmjy1MyD/PdUW/BL1uc4SH3dmqzW/F3Jw=;
	b=wna5WXhsIdKjcVbbnPlLixx2Z1wLDeqZQcRwka9/d6ZolrisIHOQ3EMAGEE/B/Pg4M37
	 zL+KwmeX3Dd5JYeD6gZOcKArFupLTrptx2HUuHK5kzt9aA91GXVu2EfPvtC9OLlB0/SiK
	 PL58dP7xXy8qApLv7Q66gk32n28O1FVm7vMp6SFGBXLKanXZ429X64WP0Xvq+4J24w05n
	 pqmj3A9TSEir5LpCbJ/ft6TLxaWOkxew2XWbkKGNhABhcn8Z8HEgpBwx7nEgoZI15nkpK
	 1jWIIshFsS1fiwnwcdbGXo43isZ9Y8ZFcE+EEflAp7nYFhy1AfI+UZ55FQ0XtEPw9gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSjksKYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44A5606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 23:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSjksKYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549DF1F000C1;
	Tue,  3 Nov 2026 23:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793746859;
	bh=OLu+CnuhZDxmjy1MyD/PdUW/BL1uc4SH3dmqzW/F3Jw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SSjksKYGdKdOlNg5vA8zu0oDqdJ5AvOEQ+9WGv/Blv9XsDcRUiK0iHikAxuMvDec+
	 f+Y+a+2D5uGugxgHQYy9e68FjqAsOGmaKX9vhwNhYU/52u7+rGu+eZZE6YB8mDBNSW
	 qxCplpL2rBI3p7nkYQ6O+PyGcjs5l0yCeiOe+NCuVCKdefqhG5Iy2DEyde0dGls3XN
	 qB8YLxwZ2gqXG+oOwi+TqjiWt4WJRkaFLLeadDMVXo1HnHT7yTXxAnYJzsTLkz9ZAz
	 5Lq7chMAsIJOL9XANvWmNzmaWOFuplRC9H+8Qb2iUlrDeAEfzt6Xr9Acya9Q56qSgd
	 sQGIhmQmJN3dQ==
Message-ID: <sashiko-outbox-196170@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/6] IB/isert: drain the QP without holding
 isert_conn->mutex
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103223802.1697607-3-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
 <20261103223802.1697607-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 23:00:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_disconnected_handler() drains the QP with isert_conn->mutex held.
> The drain waits for the flush completions of the send and receive queues,
> and those are reaped by ib_cq_poll_work() on ib-comp-wq, where
> isert_login_recv_done() takes isert_conn->mutex before it looks at the
> connection state.  If a login receive completes while the handler holds
> the mutex, the completion handler blocks on the mutex and the drain blocks
> on the completion that handler would have reaped.
>=20
> Return from isert_conn_terminate() whether this caller moved the
> connection to ISER_CONN_TERMINATING, and drain after dropping
> isert_conn->mutex.  Only the owner of isert_conn->node drains, so two
> callers cannot drain the same QP; the send and receive queues reserve room
> for one drain each, and a second concurrent drain hits the WARN_ONCE in
> __ib_drain_sq() and returns without draining.
>=20
> [ ... ]
>    </TASK>
>=20
> Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223802.1697=
607-1-yhlee@isslab.korea.ac.kr?part=3D2

