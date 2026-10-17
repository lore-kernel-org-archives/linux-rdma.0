Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22FD3F12EF
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 06:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219740; cv=none; b=W+ncT15sK3cGZkMFm71WTPtFy5Yig17J6H9OVJtUjpLdK8CWqtcFIKmtGlJXhNv2u6tiHrvWRHmM5YKqMSQamdRxtBHeidnQwlYQ6nJXjHWZ0qNekNjjBe7iXTTKzqM9CKQJ/kdNb9kMwvVl2OpKMj7cVZHBE8LdMegkgoCx6yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219740; c=relaxed/simple;
	bh=l4OoWDG4ITFfOKSL5jWXIwfDKb1hDnpA9ekJlFyJHEo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=M4yJawu4OHRuHH+S87OrdYFYZWtueJ4HPa9Xeam7hlqD8cFv/B+q/bcy0OkErTUsVh3tBssveshVc40fjEhhx3cddlpi+mrvkk/Rnqneijnw6t5b+wdg3Pv8020pQ2xHroBuq51nKYONvdr2GwRJI/AFgdcoawlO4kTWYAXHZF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4NannGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4NannGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8D21F000C4;
	Sat, 17 Oct 2026 06:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792219739;
	bh=l4OoWDG4ITFfOKSL5jWXIwfDKb1hDnpA9ekJlFyJHEo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M4NannGZnjBMS+kH7av6IsM4RT85S2eMzEFTaFg83cgztP38H8ToZfz192ufW2m41
	 NtYo88x4iFgKA1RQiQCQQ63KJ2xEsdwvvXUMlFbQm6C60gCLRiTXplAR9ZeQShOK7W
	 ZJ0ZJ/PqbBh6X0576ZX6dJ7Q9Jeyo3CjdIzzoj00GhE/2iiGVE1H/MlZ7xYRXueO0c
	 5wpAhi883m2OTWhfftks6mmPWFHgEwbbNacxV6IYgtFbhYMm3o7d949KbA/CG+YsG2
	 GwfyXNCyKG1Z354T+3uuLHtoqAfzsnAn30Hd8wd3+4R1TYq7NCWqzFzd5mWdnsQlZx
	 +Mgp3XLgG9Dcg==
Message-ID: <sashiko-outbox-175350@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 04/10] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-5-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 06:48:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
> packet, message, and frame counters for use by work requests.
>=20
> Arm the requester receive queue at the initial PSN so that a CQE is
> generated when the specified PSN is acknowledged, indicating send
> completions.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D4

