Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D0F32A3EC;
	Sat,  8 Aug 2026 07:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786174822; cv=none; b=EJx/MOHTTOpOKDf0OTfXeqXNhvXOlyiaM+2rpod3fpjQUI2V5XsCbdEbPKE+bRXbQr+2Z/rerQjb4sYtMQVHV4DehRrZDWRdcPnbhO+s1r3hgNbWfhuuKKZMu9uoSGye5FWeElWgyYQPh5bvgo+FeuG0oOYRXyM0TSLrLPLfhQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786174822; c=relaxed/simple;
	bh=l/Zj5z/U06X5lv4K/fJl4j7gbneYyX/Buhpbtq/e9VU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7avgqV+VFUeUlkjT2220F3NMHS5wAMI8P1pTR6t5L4vU892Bihbjy5WuLMWi6VTDPE57HDWBVG15aBsziM5xB0Tz5ArPCn33RtffBN+dAl8kroK2a5rk3uUX0pmcPNIBXiJRj9lNOd1B6sAA/ggYV7aMB3TtRmYZPkRDS40GsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=cYsLZMqw; arc=none smtp.client-ip=79.135.106.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="cYsLZMqw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1786174805; x=1786434005;
	bh=4iAukKsu43NOG+cnczdDvSJl9Qq7x4+l0jFL+1KK0gY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cYsLZMqwACg3JJfcK1po+9hNNSFa7Q7WvxFxB9REx9djIoI4ChnvVQG20jY8qkVtI
	 qyovX+djklefb7zlF9hJ79F5c+q9AfdvRdnuUnXMViXlCxVBAdSvslYU7cpFwVJ1Yo
	 5Uif+Wo2H8Pb2cHsT1FM7BOkMkfery1Ky6laz5ehgvgSY+WiULAoCmSMtOTQI48TST
	 j1W+9jZR/j5iLIhs1CNYfalQ5WydbBgQJ6D44D54Lk9yC2oYc+V1O/m6C5MQe2HfYU
	 OQClTqQeGKlQDrkEvsRvzAK0rG1xoP0P9RwK29vPPpP+UOtelds4j+kWSNjCGCpICV
	 BX1EQeRYogSxQ==
Date: Sat, 08 Aug 2026 07:40:01 +0000
To: Simon Horman <horms@kernel.org>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] net/smc: order the CDC receive path against buffer publication
Message-ID: <20260808073951.396605-1-hexlabsecurity@proton.me>
In-Reply-To: <20260731153225.GJ51943@horms.kernel.org>
References: <20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me> <20260731153225.GJ51943@horms.kernel.org>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 490869570e247f1a8ac4bed1f22525dc7e07c1d1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Simon,

> This is a pre-existing issue, but should the unpublish side be fixed in
> the same series, since this patch establishes the publication protocol fo=
r
> the ghost buffer?

Real gap, and it is on the list as its own series:

  https://lore.kernel.org/all/20260808-b4-disp-22f119e6-v2-0-61647601a6f3@p=
roton.me/

I kept them apart because they are independent revert units with different
Fixes: anchors and stable ranges -- this one is 69cb7dc0218b, where the CDC
path first dereferenced the descriptors; the teardown series is ae2be35cbed=
2,
which added the ghost buffer. The hunks are disjoint, so either order appli=
es.

There is a coupling worth knowing either way, which I should have said in t=
he
v4 cover: this patch caches sndbuf_desc in a local, so if it lands while th=
e
teardown series has not, that window stops being a NULL dereference and bec=
omes
a read of the freed descriptor. That argues for the teardown series landing
first or alongside, not for merging them. Both orders apply cleanly and giv=
e
the same tree; I checked. If you'd rather review them as one series I'll
respin them together.

> Would stopping the tasklet before detaching and freeing the ghost buffer,
> mirroring the publish-last ordering introduced here, close this?

Not on its own. That is what v1 of the teardown patch did, and Dust replied
that it does not fully eliminate the race; he was right. smc_conn_free() ca=
lls
smc_ism_unset_conn() only while the link group is still on its device list,=
 and
smc_lgr_terminate_sched() unlinks the group before the worker kills its
connections, so the device can arm the tasklet again after tasklet_kill() h=
as
returned. On an SMC-D loopback rig, with the reorder applied, 78 of 172
connections were still armable when the drain returned and the tasklet was
re-armed 33 times; unregistering first takes that to 0 of 31.

One correction to the review text, since it points at the wrong lock:

> smc_conn_kill() runs from the link group terminate worker with no socket
> lock at all

It does hold it -- __smc_lgr_terminate() takes lock_sock() at smc_core.c:15=
79,
and f621d6ebeebb did not add that; it only moved the sock_hold() under
conns_lock. The conclusion still stands for a different reason:
smc_cdc_msg_recv() takes only bh_lock_sock() and never checks
sock_owned_by_user(), so it does not defer to the backlog and lock_sock() d=
oes
not exclude it.

Thanks for the review.

Bryam

