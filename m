Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2447369997
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388307; cv=none; b=GapDj99GJKc3c5W93jyYWtnFrmvxLEns7xwAN57x0HOvHFZY/vMLAk14hhsk+1eS9VOeWAeOVGWxY/XADh2zjC8vBTDec6hUlKzToGzi09jouTEcWR/UjvTk0MQSdDpMnMqo3fJBobzkMCop3EmlgX4S/blhMloVd3odchroupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388307; c=relaxed/simple;
	bh=4iobX3Jlme60Tjhi95TH55pebWIv6OuWRmWvEo4DdUc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oaD7d6LtStUHnfVRGX9nvfUU5WmcQ9fT2AJTRZ5KnqFrx3KnbwSRnlaSt8FQQhLDN+xSgXWgIK7N+1CZwXJhLfJTqFWJS3Uz21lL/ucQ0fv2H54paGvSdtWnN48pM/VCe5b9KRanfShVl0Smc/VpY/SqAm6CvTml0tAOt7gqwBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fu3HhRBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fu3HhRBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5547E1F000FF;
	Wed,  7 Oct 2026 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388306;
	bh=4iobX3Jlme60Tjhi95TH55pebWIv6OuWRmWvEo4DdUc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fu3HhRBq6CTZp+4bCcGwVjotwDOOMuOVTapYt7EObhfcKEqTpjqB408Qr1DOWXTFr
	 hCA8NU1IHk4M0BOsJ31IRuUbKDCUflOlgT9QWq+FZw1kvsAhlqCQog+khkI6EI4SZ0
	 m+ulFifgC19iRR4RUiEawlTCZ30P0JUHk6oOtxRRfYnD5Y5DVK1c4IPViKUHwfdDu0
	 v0ZP4brnLgYRk23ptACcoyXC2XjSefDIoS5YwmpLbr1MtB/BigWbau4HBamc+UixHC
	 KTk2Vy2+clW/4sAYEBniHlI8LFGel7Hd/lEgEL/vkAfKO5+eeaBh6NdNNJGatdC+AU
	 qDv8cnXRL/AGQ==
Message-ID: <sashiko-outbox-163168@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 10/10] RDMA/mana_ib: Drain kernel receive
 and send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-11-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-11-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:51:45 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D10

