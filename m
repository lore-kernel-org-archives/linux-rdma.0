Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FDC392836
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251568; cv=none; b=NVSDUOECIK0N/xeaLSQFcGLHa1qbs8AwFXAxlk+Tve9lx3Sga8PpEQnbk0hp7WKy6dbRSDkUcFTUsAuWSbdqBuBDEWnD53WoZwlNVMjXW8CEjTBc35aBdmqxqs87e3AH7bS9y7yRwAbHkYkmZJbsIF/E4A+gY3kUmK2QlBnLYEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251568; c=relaxed/simple;
	bh=YnqTrRDrYBnwruDtVblEw+mZalRqvl70RLsklwWhNdo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FnEv1Ho/sN2GFe6B5BnvjjwHgYDD0Koh9Cdz6iIWkP/eWdIHuqvGv3iomo7z+mj5jYMaLDJB9JhxjezdIBHssjshmvpAu4H+Vk/ieEX3akAu9Ki1LH9hoHMIXgMoao+BGqD7mEbtqHZIivUOq4MLVGlA1czEbg7jHeTJpmxgl/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQY0myJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQY0myJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C011F000C4;
	Sat, 17 Oct 2026 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251567;
	bh=YnqTrRDrYBnwruDtVblEw+mZalRqvl70RLsklwWhNdo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CQY0myJEA+U4Ta4f5Rq4XrG1DJgGezpaBiJsnRXOGLPxRTSD9Z31zbd6rC2AdwTAx
	 6Ocnrg9aUX8DHD/uZS1E3rXZ3f/I3LW9uthq18XjtHhQ95dGiwbQlh8PhA+xCqfOm9
	 PfKc79Hg4og0DkIYqr0oSBjp8UoRngwAqE0PoMlPocDjlH2Ob0TytGF2RbOkNKdxIf
	 TarGshVKi0f0VMu0M/ecrYiBZV2jlzNF2Q6m85/dkJ1Zn5n99SEdqoPx7OU5vFPFV+
	 nTGf14s9C1qOnpm16y+z8sa8U2s7yeXnQedktBdUgD9U2jTyWtntSBLEWyK3dSs68d
	 RXKiOwDqdAxTQ==
Message-ID: <sashiko-outbox-175605@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 05/13] net: mana: swap queue sets in
 mana_set_ringparam
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <88ace6b69bc4ee0a33da718490716472eefc9add.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <88ace6b69bc4ee0a33da718490716472eefc9add.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Replace detach/attach with queue-set allocation and publication. Failed
> allocation now leaves the running queues and ring sizes unchanged,
> rather than risking a detached port after attach failure.
>=20
> Skip requests whose rounded sizes already match. Keep RDMA excluded
> through failure cleanup, which can release the vport.
>=20
> This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
> RX buffers and page pools live. The port-owned EQ pool is shared,
> not doubled. Device resource limits may reject this temporary peak;
> allocation failure preserves the live queues and configuration.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D5

