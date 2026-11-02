Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600210;
	b=z+EkyezmAfupvtpuapopvHwOHI4O7/P0i2T1RDAA+mG7Ys/Jst2pG9LomuwOLiTJju+J
	 EsYnyH7+on7RsTzs3gq9ijNTWY3+8ONMmDk/KrcyafT4SnS9agHmswif8wg7mN25uUr2B
	 GPt8l6kYdrUjZHPFsOqShEPbhotxs7b/Qj3pERV6YRLBrHWdhJyQPtV2hW8VYXrUMRhUc
	 sObZ+ZK3cgFRsKwdUFTeHKxIdjvRnqriDQ1m78hQbpZXBhZj/ibzVqNRWhBED7W/tcZMD
	 VvyLYvQd73nF40KUEdTmsa4EPK0SPILEZkfGPj5phWjt/ds4Cl+hrywP4+v5F5E1PbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600210;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8sxqxZ/tFXcG65LJjLwgkRyGP3NtvdBgfC4fFF1s2qo=;
	b=FhNn5QwngzE9IVr7CzlAP7hhfynihTOMWiI2ws9nZBIsLa76/rBwKijwrd6PjALKNibQ
	 wxrr3jklEdDD3PV8WJyEa+O7MK1/pRcxd2XXZaBOTi8fTQFfeBVXnGYptLQrA1wx8clQX
	 3Zv+WrJyTg3jT1xBheyX7yhC+q8cD+vLHq2Mf690LqyCdhj+tRT6Qz2xK44q66Jp1rr7U
	 hCDlYXLGZ0/fr+KNvZo+h6Xx2ChxskEdCAKTdkxxiOuldhQ9HzcnKHzVU2r1jMAi3EoeQ
	 48qykhjOOchzAzbNy3ih1xSvjU63EWeNVATm4W13ec2WpQI1eeK4cL+37P+Q7MuPGPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nC0e+Cq4;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3B9606A326
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA3B9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nC0e+Cq4
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a07078200fso851986b3a.2
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600208; x=1794205008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8sxqxZ/tFXcG65LJjLwgkRyGP3NtvdBgfC4fFF1s2qo=;
        b=nC0e+Cq45eM+HVVdGpNmmpZS/oyYsZ9qFW2MtwXPsfRdNKHsSDsZiLackYQQRAUDSf
         ML5QADHEVcWWGrvMsTEaKFP311norQwlD9GKA23Xzv85tGYAeN89IK6QTbC6tVqstn4o
         yR5EGAZftrHLYT1VDsW4agAbXj1wK9R3Jh4aOZOm+f3jnIjdCu0OqPHwZFVYsXLRG+8N
         GgZ/L+X3r7pDpZEXBQ+IixNJEC/f2iabWC/ZQhj23ultZEnFSUx2Ws5rbwoWdemRFoFS
         IZvS6KR7T4h/yTa9FJ22p8Oioq1wIaKYXiI7DhuWTtpIohriIlXU8jUB/9c0VVp3rv0e
         wItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600208; x=1794205008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8sxqxZ/tFXcG65LJjLwgkRyGP3NtvdBgfC4fFF1s2qo=;
        b=Xau0uuPL9K7nSdttDfgmPikuzeCmXiVoMU1euj+wlqOZFuZDfoXcOpX3OnT2LmOdyn
         LM80GKGBduUxym57XpIjo2cnu0MBSsA29ryT1b6c5yrCBUcf1kHyr/6gEulNWe/dgwhU
         JqiOAGlGCaLJrJPZZzblW116r+0mK5ln/bvZTQ/RvprKmUxe9TEUG8K/Ss0CpDA6VDnb
         62w/h667cTYvfgzvkTD5ytRZQUINEtZoURhQrMXseRCtD1Hg3n/XPs6wOg5J2r4wAIwU
         B3F58fmPpEeDFIf5neo58xQDXl5ppknBGBrFk0uZyCRHIc+pYn3G7yBh6Bcs9/urNooM
         MTNQ==
X-Forwarded-Encrypted: i=1; AKwUvBx4nvivnXu2hB+UZr32tYK2upLd1xcnrHBuud48Y583vBpvS6ouFLXSVso+HdhyeUEAl7a7ByzpVCuj@vger.kernel.org
X-Gm-Message-State: AFq9FYIgbZNd24P7C2N/vWYeKroJHVTQFVVpE0D/AqgM9sYd7wtazy/E
	uLWpsrAioAy28CpG7tqWpRM6XOTMdEqpbmLE2Sq4sQstPFTkRdya7gAlr/gTmwYlbJU=
X-Gm-Gg: AYBFou0BXPckIFx21x/mqK8WfRg+efxi5ilHNzQBcCXPFl/kJYqGzJ5oAI4fxt2Lf3T
	slxaO0CC1HkLtdOpCRuKS5Bdcsy7+uSPHxrODX9k8K0cKkAxEg3H/p9rc3XHJefu+1BhBkgKHsN
	TVQowA3A+7tkt/D1a7Pf0IxCDbj21cGYNSkoNKRUK11mEShdQHQSyR5t3I+02+uaMFdmJh6eVYS
	7fohT+gQMLWLFmw37HTdQm6N6YRjxsD1kiWvKqnPti4veKsd/3S2a199lYmMG7b6HzAxlGnGIuv
	nN9km0tNTKbrSBHcBlbLk7CnoAscJ+M62jpj6H2hAnyyInaO1Y+w+RenIX1VQ1+MHXfggzdJxMr
	tFRBS14jAOQAJ5WTg59q8USF7+Pi66qbgtMcN7DtPCJjO3PpLZhtpgNyRaMrOtGG/hvdlzstRrU
	8/SCT+4o2qSVjK6xddHzM9bUPHtzfW4MW2vjiArOjlFizsZ8d8gbygIJUeojE7Ub/PJjrvdsQUW
	LfcwdjEebbkrgJwKqxkV+blRfNXZHTDRElLZAQowAoxoL6CxlV2DofFTfVqoeHKp+ACGZ8hlq1w
	fAV1jkIaDSBMqZftPAecnLObbWRW3inRDeG68YqcIgkWMYmRfdir9DrEPfSjSk7v14vY1cjM5sZ
	AvUGb7lEaCbSNRffOb+MwgYBAwxo5Q1HJScs0yPFvcGhU1BY/SNgZbcsZ1do=
X-Received: by 2002:a05:6300:6301:b0:3eb:3b69:77d2 with SMTP id adf61e73a8af0-3eb3b699956mr2989335637.37.1793600207806;
        Sun, 01 Nov 2026 22:16:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad9d03be0sm1509071b3a.27.2026.11.01.22.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:16:47 -0800 (PST)
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
Subject: [PATCH v3 0/2] IB/isert: fix the device removal use-after-free
Date: Mon,  2 Nov 2026 15:16:05 +0900
Message-ID: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
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
connection it was handed to reach ISER_CONN_DOWN and then frees it, which
is a use-after-free against isert_connect_release(), and the wait itself
deadlocks against the handler_mutex that rdma_destroy_id() needs.  2/2
moves the teardown into an ib_client removal callback, the way nvmet-rdma
did in commit f1d4ef7d8883.

1/2 is a separate problem that the review of v2 found.  It predates the
device removal work: isert_free_np() publishes the connections it is about
to release on a stack-local list without emptying isert_conn->node, so
isert_handle_unbound_conn() treats them as unclaimed, unlinks them from a
list it does not own and queues a second release.  It needs to go first
because 2/2 adds another caller of that path.

v2 -> v3

v2: https://lore.kernel.org/r/20261026060505.409476-1-yhlee@isslab.korea.ac.kr

The review of v2 raised four problems.  All four were real.

The race between isert_remove_one() and isert_free_np() on unbound
connections is 1/2.  Holding isert_np->mutex over the release loop would
close it and would also bring back the deadlock that commit 691b0480933f
("IB/isert: Fix dead lock in ib_isert") fixed, so 1/2 takes the
connections off isert_np one at a time, which empties isert_conn->node
before the mutex is dropped.

The race between isert_connected_handler() and isert_remove_one() was
introduced by v2.  Both handlers used to be reached only from
isert_cma_handler(), which the CM serialises per cm_id, so splitting the
ISER_CONN_UP store and the move onto isert_np->pending was safe until
isert_remove_one() started calling the teardown without that mutex.  2/2
keeps isert_conn->mutex across both.

The hang on an ISER_CONN_INIT connection is closed by marking it in
isert_teardown_conn() and having isert_connected_handler() release it
rather than promote it.  A marked connection whose peer never answers
holds the removal until the CM gives up on max_cm_retries.

The hang on racing connects is closed for the half where a connection the
walk has passed is promoted afterwards, which the previous item covers.
For a connect request arriving during the removal I have no measurement,
because no further RDMA_CM_EVENT_CONNECT_REQUEST arrived on soft-RoCE once
rdma link delete had started.  While isert_remove_one() is still running,
2/2 refuses such a request: isert_connect_request() fills isert_conn_list
and isert_np->accepted in one isert_conn_mutex section and returns -ENODEV
if the device is already being removed.

One window is left open and 2/2 does not close it.  Once
isert_remove_one() has returned, the isert_device for that ib_device is
gone, so a CONNECT_REQUEST that arrives before cma_remove_one() tears the
listener down makes isert_device_get() create a fresh isert_device, with
removing clear, and the connection stays in ISER_CONN_INIT.
cma_process_remove() then raises DEVICE_REMOVAL on that cm_id,
isert_teardown_conn() only marks the connection, and no further rdma_cm
event can reach it: cma_send_device_removal_put() has already set the id
to RDMA_CM_DEVICE_REMOVAL, and cma_ib_handler() drops every non-timewait
event for an id that is not in RDMA_CM_CONNECT.
Nothing destroys the cm_id, so the wait_for_completion(&cma_dev->comp) at
the end of cma_process_remove() does not return.  The unpatched code
blocks in the same case, in wait_event_interruptible(), so this is not a
regression, and it is not a memory-safety problem.  I have not reproduced
it.  A follow-up patch can close it.

One thing changed beyond answering the review.  The branch in
isert_connected_handler() that releases a connection it refuses to promote
disconnects and drains the QP first, because the login receive buffer is
still posted and isert_login_recv_done() dereferences isert_conn.

Measured with soft-RoCE under KASAN, removing the device under 32
connections: 4 of 12 unpatched runs hit the use-after-free, 76 reports in
all, and no removal finished within the cutoff; with this patch none did
and all 12 finished.  A connection held in ISER_CONN_INIT across the walk
took the removal to 73 seconds, 59 of them waiting for
RDMA_CM_EVENT_UNREACHABLE with status -110, against 14 seconds without
that delay.  Login and I/O showed no regression over 12 runs, and a
PROVE_LOCKING build reported nothing over 6 runs on each side.

Yehyeong Lee (2):
  IB/isert: do not publish connections being released on a second list
  IB/isert: tear connections down from an ib_client on device removal

 drivers/infiniband/ulp/isert/ib_isert.c | 203 +++++++++++++++++++++++---------
 drivers/infiniband/ulp/isert/ib_isert.h |   5 +-
 2 files changed, 151 insertions(+), 57 deletions(-)

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
