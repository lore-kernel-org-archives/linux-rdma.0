Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9239E9AC
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791478009; cv=none; b=WFLzBeo7SnKbVMB22n/p3qy/5lg+lDPXtof6/XkFxP8kUiqG7xskmskUpnWIJCK3U5KyPIY+345x/5bykv726pT2dLJB3ksnIeWX1rozYpTlSDvdxXmm2r9XoUB9wC3OTaxbd6vwyj2EAF0N8qyT9MD/10XL3OIVrodPjw6SM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791478009; c=relaxed/simple;
	bh=G6fvZxmSGlX0E+2Z3a2dbOCR6RNOFGI0m8hP74zZmpM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ckCXLBvnVTxnsk+qpewoFUmpghR5VFbxnzCOlpXYv58pe9N3I9QnlqusXWxLmitfCit6q60KnQwgHiuCAyk5D4LEoy8qSUwOjuTnBZk/hr4XnyOuC5tXHk0RZ18Dv1yU4MmpGBwzMMKVC8iakuGosO84uZdgtihC88cZn0zo4Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6ki+Vrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6ki+Vrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BB01F000FF;
	Thu,  8 Oct 2026 16:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791478008;
	bh=G6fvZxmSGlX0E+2Z3a2dbOCR6RNOFGI0m8hP74zZmpM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C6ki+Vrrrf5gGlt4buzRL0IIZbJDMRJ9kqk56RTGNRINgwi517m5SAc45eN+xpXmv
	 trTyQA/tmVI04l0J1RHiwZR+39AEKuDfGYyKYhTGp9rTGDmB0ln6R6/D8RdGwhg7Ly
	 QrKPyT4zTpVlTfvvzNqwqk03/COox4/2lUuJixgUCM351nS91UYEG4WekfJXJ471ZH
	 fa5GvJwep6iaShcNhO6Y0Udj70oFcHdmkHJmnv9q0PFaakTHiWDaHxyYBqkpkPk0Fr
	 +nTfY72iKPMry7bef5ZonW5JS0WON3y86JPrNfqWyEmJ73z1MNi8G7F5vS8pyEolsY
	 OnDJXeMv0Ll3g==
Message-ID: <sashiko-outbox-164386@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] rds: fix out-of-bounds conn_path access via handshake
 NPATHS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Henry Martin" <bsdhenrymartin@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
References: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 16:46:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Connections on the IB transport (t_mp_capable unset) own exactly one
> rds_conn_path slot, but the peer can still claim eight lanes through
> the NPATHS extension header of a handshake packet, and every
> subsequent fan-out path then treats all eight entries as real: the
> mp-start helper iterates conn->c_path[0..7], dereferencing cp->cp_conn,
> taking cp->cp_lock and queueing delayed work on cp->cp_wq at 504-byte
> strides into whatever comes after the single allocated slot (KASAN:
> "Read of size 8 in rds_conn_path_connect_if_down").
>=20
> The negotiated lane count is now clamped to the same value the
> transport was allocated with (trans->t_mp_capable ?
> RDS_MPATH_WORKERS : 1), so a peer can never ask us to walk lanes that
> do not exist.
>=20
> This vulnerability was discovered by Tencent CodeBuddy Security.
>=20
> Cc: stable@vger.kernel.org
> Fixes: ba3d1f480c7a ("net/rds: size a connection's path set by the transp=
ort it ends up with")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008163843.9573=
25-1-bsdhenrymartin@gmail.com?part=3D1

