Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39477381AF0
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 03:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791774413; cv=none; b=phaqs9KA9hViI/T7IC+dmktA03GXG88ZKX57OdtqIEFx1HdMs+u4lCZODisdCrTaAViEmz0ZOAxr3KNQgKmapq+/iGGyZ+xP/gsL9lmX1e0Szc9HNfcHkz5Hkti1rd/B8KXEpvBGHr6A7ivdVU4Ky/XkU1qVVLcaYl/mf/EQdss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791774413; c=relaxed/simple;
	bh=AiH06T6oWkxAzaYg1DX2G2SdwmpoE75zgLkEQrn7u6A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=S54w8sB4NLzfDHvTUb9YIG5RPde1esLzYIwNS/zUWGXr6XkaU4GKDaPBuJ7XGoFSuzGPiHURmjMeMnd81CwxRtytiwxhBES1UXFlJzpg7gwclC5kJ0/piSscMSpILaiuxb8QXEIjvYe5/2SdqGIhMVbMgANl3vW8M9ALZQ5ISm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eti5eZsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eti5eZsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FF11F0089B;
	Mon, 12 Oct 2026 03:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791774412;
	bh=5UrMBuaJmiS1mjXxFM7rFpfeftQ3J1yYy+kc4A4lJ6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eti5eZsaDdpWv1PXbWBHRimLmnHSI/FKAlKwKs3z7pX3K/ZgNti48OhoQ5w2aAGAL
	 gCXvuQHkQf0JFtRdi3rgD2zD8+BuKeoFmN8DKGRoKxhJ7ysE0RgVGlmlPuuyxD2uIG
	 1A9n8oaiU3rG1K712cevFQtS1zcnex6P93fSR8lydRoRXoajwUml0RWasIApb9Xwph
	 uu+rxAw9xrtiLAjgZ/inwyF3SmeCOeVUocXsWLDwnIFfSWzen38idGXwbntmATOBZg
	 m1o1pZro+gTt6QS8y/VpwJz1zPENjRPTuXqSNz/Adqgn/A5+jQJcPFtBm1SSPjxvuz
	 4W48Ay8mKqtag==
Message-ID: <sashiko-outbox-167569@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] rds: fix out-of-bounds conn_path walks via
 handshake exthdrs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Henry Martin" <bsdhenrymartin@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012025336.54756-1-bsdhenrymartin@gmail.com>
References: <20261012025336.54756-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 03:06:51 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Both the lane and the connection-generation negotiation are driven by
> extension headers in handshake packets, and both are processed
> unconditionally, even on transports that are not multipath capable.
> A non-MP connection (t_mp_capable unset) owns exactly one
> rds_conn_path slot, so a peer claiming up to RDS_MPATH_WORKERS lanes
> makes every subsequent fan-out walk conn->c_path[0..7] at 504-byte
> strides past the single allocated slot (KASAN: "Read of size 8 in
> rds_conn_path_connect_if_down"); the generation negotiation opens a
> similar out-of-bounds walk on the same array.
>=20
> Only process handshake extension headers when the connection's
> transport is multipath capable, so a peer can never make us walk
> lanes that do not exist.  Both call sites in rds_recv_incoming() are
> gated.
>=20
> This is a port of the Oracle UEK fix for the same issue, picked up
> where Paula's series of the same change left off.
>=20
> This issue was discovered by Tencent CodeBuddy Security.
>=20
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/netdev/20260825120132.51636-1-pamoutafpro@g=
mail.com/
> Link: https://github.com/oracle/linux-uek/commit/2fdeb0513f18
> Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport=
 is RDMA")
> Fixes: 905dd4184e07 ("RDS: TCP: Track peer's connection generation number=
")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012025336.5475=
6-1-bsdhenrymartin@gmail.com?part=3D1

