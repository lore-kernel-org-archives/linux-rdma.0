Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9704AA028;
	Sat, 10 Oct 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643334; cv=none; b=dLEbCssYP3mptC/3a/mqrR/uP2nE+mnRjVKD8xWHDT6HgAvdBog6KRZnwAVz2WSpsCtSxv4DH/mLlZUYJVHU3yKwP1tH/b7nhgOzq0oZFwnW+Eud1cWnxKDK6THiNHrsSoAsflOBKkwpIvNrJOU1DdIYmJdqvc3iZOtFXhZTFbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643334; c=relaxed/simple;
	bh=QA4XJnOkS3TxiOZEUj2eFQMk/2+OSxqd43MOK31El/Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=knpKW7Hi7Q24rZq+ioqaB0LSR04czrzmycmFIO6dMJWi5ae1QBi2W3GJ/rFSDBs7+fIE45khaYXV0R72AZb6lJjda6ph3FATagWlhR5MU1G9L5scZ88sJlteA5R+Wp8ImaFEVCclHQAjx8PZSe7nEzkvIHfYYR4FCMF11J++xWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1dmFt8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1dmFt8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435D11F00893;
	Sat, 10 Oct 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643333;
	bh=W3fpWhe4nVOa8TLjRtAzdJPzRB3fgxtA2OFqimOxBDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i1dmFt8ByYoS6hL0xl/qqGU/9paYgFuY1uBXUbWETpyj54Bxn/bLWq5mCUC1PsuHO
	 FRvTGpLkFATXY6MSlv5OIqSNlddI0qZbhvH24loJbaIhcXjuT3k31bWlrZ6Lh3Yycy
	 +0Eo0BWpQTH20hfsAheoOrrGKSGJWyI7+pyR5xTyDzIZVanTFy/DWee1O5RbnFbJRy
	 0IJhZNhaCJt56BoC+GnyvgihqUqxukc+8WPjZzqLG4N7A10zurOYNDWjsrL7tF/tGu
	 oSWihpMkxIYHbCOUEap7NoJiOPzYkcxF0ATHcENHfarOLJKo2l0pcrPb8kjRKIIUBh
	 sZttAegITuzzA==
Message-ID: <sashiko-outbox-166667@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 07/13] net: mana: swap queue sets in
 mana_change_mtu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <e9524a67c6e157f2e110f4e9f51ec3c94293a64d.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <e9524a67c6e157f2e110f4e9f51ec3c94293a64d.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Deadlock on 32-bit systems due to u64_stats_update_begin with pree=
mption enabled
--

commit 9fbccd82cfbdb308859b32b732f45f8415ee4bd0
Author: Long Li <longli@microsoft.com>
net: mana: swap queue sets in mana_change_mtu

This commit carries the MTU in the queue set and replaces the RX buffers fr=
om
it. It swaps queue sets in mana_change_mtu by allocating a new scratch cont=
ext,
publishing the new queue set, and cleaning up the old one upon success or
failure.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
[ ... ]
> @@ -4392,6 +4419,8 @@ int mana_publish_qset(struct mana_port_context *apc=
, struct mana_qset *newq,
>  	synchronize_net();
>  	mana_fold_qset_rx_stats(apc, out_old);
> =20
> +	WRITE_ONCE(ndev->mtu, apc->configured_mtu);
> +
>  	/* Publish restored fields before reopening the gate, as on success. */
>  	smp_wmb();

[Severity: High]
Can this lead to a deadlock on 32-bit systems?

The mana_publish_qset function executes under the rtnl lock with preemption
enabled, which leads to this call chain:

mana_publish_qset()
  mana_fold_qset_rx_stats()
    mana_fold_rxq_stats() {
        u64_stats_update_begin(&dst->syncp);
        dst->packets +=3D src->packets;
        dst->bytes +=3D src->bytes;
        ...
        u64_stats_update_end(&dst->syncp);
    }

Because preemption is enabled, on 32-bit architectures, a reader such as
ndo_get_stats64() could preempt the writer while the sequence count is odd.
The reader would then spin forever in u64_stats_fetch_retry() waiting for
an even sequence count, starving the preempted writer and resulting in a
deadlock.

Should preemption or interrupts be disabled around this stats update to
ensure readers cannot preempt the writer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D7
