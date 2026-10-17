Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E0E392C27
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251573; cv=none; b=M8wk+Y82xHLHBaePqmx7kEuz7T1zODT5ekvucXQelBfuulshDPAD1BtTxWV9CQiodAmPNYab1S8WwNgroriVU86XdgKt7MxY9ZqsFvzXgLGcVP2QivAEZL2KS9ju833zv5q+ooXHz+5ogReUoyVZtKRN+omUjhxKHI6Ll4+Xji4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251573; c=relaxed/simple;
	bh=FLPh120VxKNWZAG8+UuCj+Wjj0AVW3zDzJRONwSjP54=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=nqR6AqBLRsX1AmVcTGb4PgDHb0YcgIN//Ix2vO5Uq/Bo9O9kp61snKmtMALkApOk/7kdaDOMniIxs7+BAw/Zwe+ctnyD3j0bcLJ+itda9/b0vUcvv0McibvHVOt/Ns0vYKBkN7lVL16HLBA1TQ9r+UlcckBa1CIKAA4pUSd6wds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfAkPQ0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfAkPQ0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C962A1F000C7;
	Sat, 17 Oct 2026 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251572;
	bh=FLPh120VxKNWZAG8+UuCj+Wjj0AVW3zDzJRONwSjP54=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DfAkPQ0Kb2uu+75pnY0abIajRgYPjmESGYazUseEc7XnKOrXGzZentqHL1WhhtXfP
	 j/HsYIBfby1+af1PqqrMjaS1j9S+9y2X35bHdz44K3tlYLE7+IGNf0IK7ijLYfleXP
	 FrVccOh6ar6jvi4S/8Vnhe2awyANAm9eR63PYHLMVawC1w3kNd8YyONL8JF/P6TPGB
	 vJ8bsqCIBwZPI7jd5juYbcBLIkBHMatxS5W31BgUU/Fc+j7ehwaF+IHniOJG05UHUj
	 b/L8z//Z0lvChci/Wum+Qn90GkvVTlR0i6QH/AUOV8Gqkq+kYvGJyhVufauUOv0+fm
	 muIW7ZL2oCMgA==
Message-ID: <sashiko-outbox-175612@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 12/13] net: mana: keep the surviving queues
 when the channel count is reduced
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <9ca7cff433262db61889e0b4f7cbb96b764aae68.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <9ca7cff433262db61889e0b4f7cbb96b764aae68.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Split the live set into a kept prefix and a retiring tail. Reductions
> allocate only pointer arrays and steering tables, retaining the kept
> queues' page pools, buffers, NAPI state and XDP references.
>=20
> After publication, wait for TX-selection readers before freeing the old
> containers, then retire only the tail. Failed publication discards the
> new containers without freeing shared queues.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D12

