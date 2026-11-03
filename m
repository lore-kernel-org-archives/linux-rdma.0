Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745497;
	b=RnkmqExayCNYkUi2n4gid9XQ3nZNMB+fIUFLcystJWK9lGGelDd876bPqFH5o/pR5EJE
	 jJJtfzkWr05H0HxHY9qWcLDyvD8s7PrzMHcehJTemSXH/+ZBX7h7Nuj+AKq3KxZDNdPRe
	 QXaw7q8KoWhEXL53ni/wmYixiURupADV4RVbiAes0MTk8JhLRAICZ0lvp021nScENzZE3
	 pfDm//SkBfxkD7+ifpwpvwsMR+JWc4hKZdyuo6KSniad+yhvnv+RFE/smyOE7VwlB0G66
	 ZqCKojvEOTsFvUj+6cPCj6vFapSTzAGRykhg76zre8ou5KWeJ5Tc8ApPJmm42F86p6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QPkeASfTAUB7nlmudkHTEiM6vDMJBSmKmy93vryxuro=;
	b=X5h5NuNdwH0Ed7ZEI6c4/CUXcdYLR777mFShUsEnoEZdcxMrv0Vn7GaZDprVcOkTbeqT
	 bj5+FHE6zI+rvtO5lbNQOIIPein34B3jgSfxrKlOqjeA9r8OwYZBbBDcsg/E6LJpAkjBh
	 AZGbvG+dYXGQNA0WvHgx5wzOu9bh9DuH/QZKUAVwEQiWu/e5vw9bWfTu+2W/SXgBgqcvG
	 D0j5OmYf+dGCAQsxzpbpqmJ12RILkafN9YM7YYwZzuMKAeC9fqf4AOubeIS72sfV4gyc+
	 pb09AbtW3YoMY/FgrLbk6LEqQsCeS/HMUpGV1TXPHrFFdKhQUYIErbylbW/pZGZgWQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JKrEwHHF;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF28606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:38:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CF28606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JKrEwHHF
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2eb5251724bso142645ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 14:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793745494; x=1794350294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QPkeASfTAUB7nlmudkHTEiM6vDMJBSmKmy93vryxuro=;
        b=JKrEwHHFzZ0K1x/vfAnlQ3WfR+LXzeLE4FjTZg1TVYy8uNP/odlKjLTqEWQanoyUEI
         9DkyS+l5VrRt2IlEbBSbHQHuwXFqC5SbS9qlm7clePsLAiJVWikIzvGt12+BTmq0qwL7
         PXChCUx1wzCQ0w/741q11yn8C9GK9fTMwOo8G9ifAiMIf7uMP8oTJEtOVy8/m+V5I+f7
         klQmQE+zNn0/cCY3h2CO7dyBMKIIgWTfom3G+/XTKxN3V4/DpkhndqtAmWKR5No7y+Nz
         UPHLQVFAj7yytyAbrra5BN+/RTCzpC2F3VtGS/M4vw917zKcWey/RBfHbDxRa59F+5gJ
         3+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745494; x=1794350294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QPkeASfTAUB7nlmudkHTEiM6vDMJBSmKmy93vryxuro=;
        b=0Yc/3zDTKx/kmtBghsPDVpN1w+R9R814yUMvwBC08Vz46SMYmPRAOQ1il1bne7GDZm
         kHbJ0OM189iYbOYiCW03ksxGW/32Rpu3d1ikpjCQjW2k5FqbFr8PNFW/DqzeVM/9mPCy
         1auxAUcNQpb9pA2Yf3kubLPX9FtOxusZeeme4D9fkrCE4AhPRKUrhlgTWD+qu0T9WuQl
         OfYPb1L4Q7mjDEjVBDpjxQbJTLSKkMNwbupwVwm941ZGPuIxDesokjYtxArw6xrtufwL
         MRlZtrYAKai+h/38yczTxxlNimaVDvpgSeDzuPqq5iJgyw61hybamukAIdiz1mRgrQRW
         c0DA==
X-Forwarded-Encrypted: i=1; AKwUvBzeWFfXn8ofokTA/kAO++v6LhIVmcTbcN0UA3KLNokvKyjUZIZ95DugDezDAnLMAr3YCbaW8kDLz1PM@vger.kernel.org
X-Gm-Message-State: APuU4Z/IccIhOKuQBUDIzCbL7q+cO/mF4nEWRpQ4x9SvMyz9ROuUrm+W
	J0nbJCtqQTkQbk+vkKImF2SpUw22PE7XLu5fXx/vUxp5J94cCdHpobuHimekWRi/6f4=
X-Gm-Gg: AYBFou3K0FyHDhQqtvCIJUtPLOFWLvpGPChlTXiSWewX6p/hucGItgL7NXxYhX5dEKE
	vDOgncrzAhbUbcijdzq4lSmt+1Y50tXw08/Aas/cveJVQe1IIvUe1kbdQ014H+Db/fZxWvK0O0b
	fFNfHzQgjJlDJsJ8Jn5pbem9o7lTtnXKlFBqu7HmNvtS4Qq+778wxxHl9K0GlwJVmkIUj6pkG/c
	qNjtk2fESC+97GOIR8IGHQZNwJlXNFnIRhENbw1cF48mT0DJ/dBSaF+Ou/kPKIY7IKxu7s9d6tL
	H7S6OqKW2tFKwe1P71o5r/gcNFUMNWRjveJO8jCwPCeyDZnVtIXRifycyQIQGD1ISgIVbltj2OQ
	RajhaKx8DdEDdw/AuGdyn4lpYkSm8l7pgoe9v6oM8v7ChnsUqvVQYh27Nl0s8LED/bctalhSUGX
	YZhqLH6xdkkfn7tKu+tR3+Or34iCxo8EeL2GOIRL8xO0FCNuL+sPALNCW7EWJVcD/o9irLsHvnp
	NdljaiqJXt+BQ6DEOQwCZTpvl0CIe162VvNHxiJibY1bjYEn2og20Iepzo9fGCz7TRrNglduv8c
	n8ovnZFZWC3zZpwACNr5ok2ap05tArtcVf1EeqjzFUQGSW+eZ1zeCpc0MzA+WAfPwfH4anQqP5z
	8YqRupUvaZO7jyB7obrZOCpsHVmuInJK6WfCUHFjyGFXef6v1AOK+LV+ExU4=
X-Received: by 2002:a17:90b:1d44:b0:3ab:c80:936f with SMTP id 98e67ed59e1d1-3ae896f852cmr10413238a91.16.1793745494555;
        Tue, 03 Nov 2026 14:38:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b096b6116bsm223711a91.4.2026.11.03.14.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:38:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v6 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 07:37:56 +0900
Message-ID: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RDMA_CM_EVENT_DEVICE_REMOVAL callback in ib_isert waits for the
connection it was handed to reach ISER_CONN_DOWN and then frees it, a
use-after-free against isert_connect_release(), and the wait deadlocks
against the handler_mutex rdma_destroy_id() needs.  3/6 moves the teardown
into an ib_client callback, as nvmet-rdma did in f1d4ef7d8883, and gives
every connection one owner.  1/6 and 2/6 are older problems; 4/6, 5/6 and
6/6 close three holes the walk makes visible.

v5 -> v6

v5: https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr

v4: https://lore.kernel.org/r/20261103032924.1073138-1-yhlee@isslab.korea.ac.kr

The high point on 3/5 was the BOUND path asking iscsi to reinstate the
connection, which during the final login response signals an rx thread that
is still waiting for its login completion, so it leaves without running the
connection exit path and the removal waits for ever.  6/6 asks for
reinstatement only from ISER_CONN_FULL_FEATURE.  The call and the path are
older than this series, so 6/6 carries its own Fixes tag.  A test-only
delay in that gap reproduced the hang on all three runs of 1 to 5 and on
none of three with 6/6.

Both medium points on 5/5 were right, and v6 removes their cause instead of
patching it.  5/6 no longer allocates anything: isert_add_one() stores the
ib_client data, isert_remove_one() clears it under device_list_mutex before
anything else, and isert_device_get() refuses a device whose data is NULL.
Nothing can pile up over repeated device removals, and the isert_init()
failure path, where ib_register_client() calls ib_unregister_client()
itself and every remove callback used to allocate a marker, has nothing
left to leak.  Twenty link removals and re-adds left seventeen and thirteen
unused structs on device_list before this change and none after.

The high point on 5/5 was right as well, though the refusal was never
permanent.  It is now exactly the gap between the core clearing our client
data and setting it again, which for a namespace move is disable_device()
to enable_device_and_get().  I could not measure that gap: moving a device
between namespaces needs exclusive netns mode, which this setup refuses
while the initiator keeps an rxe device in another namespace.

Measured over soft-RoCE with KASAN.  The cells v5 passed are unchanged from
1 to 5 to 1 to 6, 84 runs with no KASAN, no lockdep splat and no refcount
warning on either side, login and I/O included.  The late-device window
opened in three of fifteen runs of 1 to 4, each building a second
isert_device and taking ten or eleven core warnings, and in three of
fifteen runs with 5/6, which built none.  PROVE_LOCKING gave no splat in
twenty single runs.

Yehyeong Lee (6):
  IB/isert: do not publish connections being released on a second list
  IB/isert: drain the QP without holding isert_conn->mutex
  IB/isert: tear connections down from an ib_client on device removal
  IB/isert: drop the promotion reference when a connection errors out
  IB/isert: do not build a new isert_device for a device being removed
  IB/isert: only reinstate a connection that reached full feature phase

 drivers/infiniband/ulp/isert/ib_isert.c | 399 +++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 297 insertions(+), 111 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

