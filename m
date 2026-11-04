Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782248;
	b=hWIvu+bKQ1Kdk0Kbus2Pmggyh/SPtQ2KZRD/aSNSoIF8ImBAPVbCeslYOkoiz712xkqA
	 JHqWLDJBemcyp2LjapV4aA74HyvxM+zKSZCygokpGWnoYHnugdf08ek6uSNA2W28E99hW
	 P3ZmRYyTP65DV1t1a0YgP9B0B78HQvjITLNDJQldfSqw5g4cY70Hd1uMZJUUAXfrlDwfd
	 r36GKuAaYbL5auUOSFkL0J9QP9NaZw8hpm61v7wjdfVEiOvBM/BUq8sw+w+6cWCe48ZUQ
	 Xqm81ud5m2Rq5zIXO/ORzgZqXs944mfO39mvzpkbPPhDmjtLLRh1AQ6RMIfz5bewGJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782248;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Ka4LeO6p9KHxDdBVtjYtwtbnRBVcioekcPs6c3kVaos=;
	b=1eL63b4LzlSZYSxN7Jw2r6Um8+GxWkDFufULV0aGa+7RBHTZzpHl2FO4fY82L4EJbW2B
	 sgpfNZt4XGZa6DSvAj2s8LkM9ZnoEWIelvzMDze+4KgzP00+TRtii10BuyNFfLsppFyY8
	 vk8gTT/03qsh/MzHpMq6VxZK4wvTIwM94B6635Roe7NwnBo2qZU1SJnl7YNVDMtGWAUQ/
	 YiqziqADBRgKZTolwGCxjB8DSg2mo+CEafUb7COLCDsjW3JN6vSVsD4dV2s4B2sD4mnta
	 pMuOBvANg6yykc5vNVx1nYSkr/KdkfY7HVdsiVbB3tjd0K+nKbAlm/vu9hdda84M/+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=WYYOO2ms;
	arc=none smtp.remote-ip=109.224.244.119
Received: from mail-244119.protonmail.ch (mail-244119.protonmail.ch [109.224.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4734F606D80B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 08:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4734F606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=WYYOO2ms
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1793782238; x=1794041438;
	bh=Ka4LeO6p9KHxDdBVtjYtwtbnRBVcioekcPs6c3kVaos=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=WYYOO2ms2wbZMkjH8wuBZ07Sin8amCYdZw/I/ac2FbR3KEZq3x+T4xZJP6hLH6IMe
	 bTl+/3Zd723RLTrvVW8LFl+BedRlyor0M+lPH+KIvTtTpmKaei5vHH3KJ0XsMAIoN6
	 Hrl/fY4KvMUzAKjZjePS5VvJ1hEdztISkCMDkqPR4S3galqW86daKomP3gd2tXjhhh
	 08f3cds2FGgdKbluMj4LtcvZ5Mvx4QI02Xj6yBiWOz65ctyKFvdDpVpbNFOEIKz5sF
	 bln97tOWmriBwhUcRXDaGVcSgv9ZCpKft0NU61Gzw4b8xMRFk8ZVAGI0FOUr8egczh
	 m5zCLzPH0X+Pg==
Date: Wed, 04 Nov 2026 08:50:33 +0000
To: "Md.Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/rtrs: Register client event handler after capability check
Message-ID: <179378222423.73361.3247716499619173751@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: 6a7f18721102f68a50ad2762d645a2b5c2679aee
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

rtrs_clt_ib_dev_init() registers dev->event_handler before checking
IB_DEVICE_MEM_MGT_EXTENSIONS. If the device does not provide that
capability, init returns -ENOTSUPP and rtrs_ib_dev_find_or_add() frees
dev through out_free_pd without calling the deinit callback. The embedded
event handler therefore remains on the IB device's list after its storage
has been freed.

A later IB event walks the dangling list entry and accesses freed memory.
The issue was found by static analysis. A focused out-of-tree test module
on an x86_64 QEMU/KASAN kernel temporarily cleared only
IB_DEVICE_MEM_MGT_EXTENSIONS on a SIW device, exercised the real
rtrs_clt_ib_dev_init() callback through rtrs_ib_dev_find_or_add(), restored
the capabilities, and dispatched IB_EVENT_DEVICE_FATAL. KASAN reported
an 8-byte slab-use-after-free read in ib_dispatch_event_clients(), with
both the allocation and free originating in rtrs_ib_dev_find_or_add().

Move the capability check before event handler registration. The check is
a prerequisite for successful client initialization. Registration cannot
fail and init returns success immediately afterwards, so every installed
handler is now owned by a successfully initialized device and is removed
by the existing deinit callback.

Fixes: 667db86bcbe8 ("RDMA/rtrs: Register ib event handler")
Cc: stable@vger.kernel.org
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ul=
p/rtrs/rtrs-clt.c
index bf3a0377da3ff..85eaa2bdb4704 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -3191,16 +3191,16 @@ void rtrs_clt_ib_event_handler(struct ib_event_hand=
ler *handler,
=20
 static int rtrs_clt_ib_dev_init(struct rtrs_ib_dev *dev)
 {
-=09INIT_IB_EVENT_HANDLER(&dev->event_handler, dev->ib_dev,
-=09=09=09      rtrs_clt_ib_event_handler);
-=09ib_register_event_handler(&dev->event_handler);
-
 =09if (!(dev->ib_dev->attrs.device_cap_flags &
 =09      IB_DEVICE_MEM_MGT_EXTENSIONS)) {
 =09=09pr_err("Memory registrations not supported.\n");
 =09=09return -ENOTSUPP;
 =09}
=20
+=09INIT_IB_EVENT_HANDLER(&dev->event_handler, dev->ib_dev,
+=09=09=09      rtrs_clt_ib_event_handler);
+=09ib_register_event_handler(&dev->event_handler);
+
 =09return 0;
 }
=20
--=20
2.43.0


