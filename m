Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C9D41A78A
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616412; cv=none; b=jtEkJCfh3fOA+acMkBZOi7tOZj8q229oNb9kFb4jCSlM3paX6/pOFogvgWyp7im+qK/BBbCrPFFgCS22Im7RAV9Js1Uvjqn9tN2Pzzpt5W4OEzdNu37do05NC2q52lH7CHUyFF2MRN5xJf94DaEKj3bWEbNb1SATeCukj5C1NwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616412; c=relaxed/simple;
	bh=R7/nD9sWa3VIV9n0UwBOsDp3GABKOLXZH0B9zbIv1jE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DwCX09KSGPhxd/QtYcXl8uK28h+rCc0VfLgov6oqALKpxrVeTpMNDVRmuRuCiunKRc1K2zcGvQwpWflfP4/4NvRoF6wcsODqWzaysIiYAONgSlbNIJPQx+ArNTHaTstFeejMemY1dUMrECtTUtysPDtV+0kM3YiE9wNlG9fiJMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPsoPlD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPsoPlD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06BC1F00893;
	Sat, 10 Oct 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616411;
	bh=R7/nD9sWa3VIV9n0UwBOsDp3GABKOLXZH0B9zbIv1jE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KPsoPlD2+ovP9+3BLSBG6EWNCz5VWjKISrZ+FEQMyEBq4gh38tTDCEw/z+gzBIwRO
	 4d1CSfRZxhtuqtlwIDn87Km/jFzHYn5ZMZa5nVSMW801W+CAV2toYryhgCq+1gY4O/
	 yNmuXwBVRp9jVA4CQD3zVWuilaFGkImAki2BYYcX71rcLywH0UzdCy4svb5eADdPpQ
	 zcMK5gPt7NifKG6A2fpJChjvo6RGbf88eYXXCkfJUC+yFJM1Z8Xw0SuWFfqaa9dw4r
	 KJLU0pW1DXjsivvTNFMgMGnxwr6PE1Uy0Cb/HHOTxloJP25Z5hi++V8//53p0uK0EK
	 sBfEJ320PSxRw==
Message-ID: <sashiko-outbox-166304@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 10/10] RDMA/mana_ib: Drain kernel receive
 and send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-11-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-11-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:13:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement the core drain callbacks by moving the QP to ERR, posting a
> completion-bearing marker, and waiting until that marker is flushed.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D10

