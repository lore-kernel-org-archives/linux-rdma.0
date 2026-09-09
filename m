Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5D03546C6;
	Wed,  9 Sep 2026 03:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924589; cv=none; b=kqNcBkCQDlC6PmylvOIquo+DuuD08svbKkbFkNzwDxojSuP+a0dtocWNVynXtctpDbf2GQf/MPy4RtcmZO2vf9OFBH2P9TsLFQ0kRX5G1GIG6UU2XNnLyxpmIcDJ2NJp6hcrn+alcam3ZysJgB9i6f1a16icvkLhEJH8RPiyuFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924589; c=relaxed/simple;
	bh=P0gRf2e9bd7FI6yHbtrE+LSJe+6es6XH9GADS7VhNU4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lspH+pvms45OQHTM9ePWEDFKtyMQHULi+X9++udM5WUrIAlX79ETdUVXmUKAe/JjHuvcEnwlico3wsAL51/dlFg+3nW14m5t3yHh8wrJ3hGJrOrHVgJwdKwEu/Q32dHVcBO3+0V9MlyukFwOpilGukAmVljSY+OHCaYmLz/W+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUgGdt8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUgGdt8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE31F00A3D;
	Wed,  9 Sep 2026 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924588;
	bh=P0gRf2e9bd7FI6yHbtrE+LSJe+6es6XH9GADS7VhNU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HUgGdt8ZDl5aaYarxoNwRzFhL+VBfWnFB2ojgsI368x0zoeRMPl9JA+PN0F6/nQR0
	 O7KcQ5ft4SY2HhDosw+qNsclKKI84g+sQ7iP3DTAzkcSFV1Smt9r1PtguYcdzX3goy
	 Oo3NiWUrxcmlIW0HEPrIe66JBREBuIuypdJXMqP1EVyLfZikwfboihnpkkaXSrQl+S
	 8hCpl80FTo1RDPdAwNlLD62lrn3FVmuK/DNB3iWiZrTtF85mjjZupQ5HDpkFW0dc6r
	 0wJatjVLTzd7rBjbGLzHAUlvAWN/pqQo8NvDpZmxg7MPyABqb+oUHPMqBfCh0eSk6q
	 7b5BdbFhyyExQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 09/13] net: mana: keep per-queue statistics
 in the port context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260908032843.397667-10-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-10-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:47 +0000
Message-Id: <20260909032948.0EFE31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Move RX/TX counters into port-lifetime arrays so queue rebuilds do not
> reset them. Sum all max_queues slots for ndo_get_stats64(); keep the
> current queue count for ethtool's per-queue output.
>=20
> Retiring RX queues count into private drain_stats. Destruction and
> rollback fold these into separate port slots after writer quiescence.
> Report counters while down too, but gate the PHY query on port_is_up.
>=20
> DIM now samples the persistent live counters and skips retiring queues.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D9

