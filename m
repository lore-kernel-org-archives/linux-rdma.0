Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676621;
	b=0aamSb8xCwpLcORZ/ewFcC//8FhTK2cwsuz71JXsUsdPAKeaqe0z/7HscOZO2hLj8ge0
	 x8x53m2svxpX5NGBOP+w1ntpdXBbhlz1a3/uRmswlQFoPK85D0A5ofQJzjySIXWltqtW1
	 MrZtHZ2uI9jz6t7lH2OY8Zuwpz43EP0sFBUvDCVTwnM/P7QDpybNQjosCwzE6gZVCty06
	 869AuTwnMPKh4A1wMz1XbJ7prDkyuLb2o/axPE7sCMQWMgeprty8eQua3bAqJckqdjHvo
	 k5prker49munEUlrHHOQdX6rE4Oyhz5dASo97oQFPinQSTjHbmJr3la5SxsV9UEN7Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676621;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T+mw2F1yUJNs8kyybctMrCnprUG4stRbsOjx9W2agMg=;
	b=GU+upF7I3tdvrSbce/98zSVbiFIsWO5w4R8KLGyUzAqfzeNPAy1t7mcw9P4VbmlDj4gf
	 KvWzy9GflYtegLMMUKaLWJd8Ad4Ye4SxHFs8VQkpJH9aC30k7+hgLI0z/IPg2bB3u395z
	 7kU8rxG53z4UuEzhygqElBYLov/tCA1oKyH6YcX2aYSXkCAR86kwuQe2gWYkegW02qko1
	 kZ/vDputVfFUN/cbgGElfpBNKWcJ2JnPKnW5xzMPeeabT0GDa11sZXl7TVugZ5wtjMIWS
	 rc0o8X3ClOc9ciAlziY3MmKUp8s7IpvMpMHULy8Hoiag87vgn/wevyt/ucnz9Dfv+Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KzxtzkSG;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAED606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 03:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EAED606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KzxtzkSG
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36a1947498bso3282440eec.1
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 19:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793676619; x=1794281419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T+mw2F1yUJNs8kyybctMrCnprUG4stRbsOjx9W2agMg=;
        b=KzxtzkSGjZqscMAingZKA1OcYOowm5TmBc8gYCvXnCGeIRDmwx7W+7o5rZ5LPkkX97
         G1KWVEt5Tc+UPOTHQzRo5DhYzJ3KDKf90vzWwuujQGeu2sNmZ/QShKQCvVEzXhbTHxrf
         2nvNllAe5+dA33UMtgaNJbNRWw5wCWiR3u3zX/DX3QZT4W1Otg5tzFPXP6+qr0OYCWnt
         3BTKlwAXvwhIjRlsXHn4wvkAREADqB03AMgHi8nF2f5WPcf6zuDhw+mre3HDoWR3r1g9
         wZ0VUsr0g2KwUq6+NpFEIVZMjQNBbwHMw5rC2Bp6Vwl5xrDKZ9So/gdWtAnxyks6wna9
         Na0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793676619; x=1794281419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T+mw2F1yUJNs8kyybctMrCnprUG4stRbsOjx9W2agMg=;
        b=ETur+JZTOn/CMrfNHmdogLLqxavHKU91ixGN2deJYGy9katnjbdU9CfYtgeXNXjClc
         sMFwqCvbNWsIZNSp9PG7DqmOsl/oE6PTuJ2Tf3w0vHR/zA3faJwNHFYjCb2duz26LeaI
         EjNvBDZaumRWof62DfxEjAa9rJ16/Q5TAZYsYfb60QT/cRZmkq4aU/hPRg9sXNcxFyXR
         iZsMBYSovrcpeYBbf2gojefJ5a3WPESbNJf5I4bIAKNustdkJfr3Uhp8KXrVfK4F4WAp
         QPm3XQir3CJFkStCdVHDMkl2FQDMLoyaG0/+6GS90gya8OG0142FFcv6PFyunbnAp+K0
         oEAw==
X-Forwarded-Encrypted: i=1; AKwUvBwm7i9h31CtNpWJUKGPWhEU1o0BgCGRcKIVOZcsUtdwO/V5UjYag0s7JqIbrEwpE0llN7B2h6Zar8Qe@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZgfwdlG608+GABJE1P6x4/MvzCqgXzHNobOL5IdtaIbkKRcxf
	kQBPP/BElE5cjJynn40i7qyrzqFMUWEMNQ3Bj/HfpEqe38OI8bNz95luCDw0YmdhR/0=
X-Gm-Gg: AYBFou2FPDDsO4k2Ene+HZq9IQJG509DGH+wY5ZG8vrbKNgwIRXcSkajeIPYOsv2uH1
	g8KE7vJYWA0hSH6q1A+c1YcIWv0bO2Y9r8FlKVJeclk0W+MTLyKmIi9MOqp/9gS8vLQ9ghOqxtq
	UbOMTfAoXipQDMcFtbCLpVBIOl5tk5L1EJd0kK84ValtTIv31T4n68nLLWK/JOHaEQbJq61JTwb
	982oIDmcgHqgmXlx0o9S6hZIY1p5QUsAwlpmp8PHsOyuIYomNuVecQjGg9zHA88zwKSsxe5x2ou
	hg8O8Cv6+lXqbeUsWon0zPGwwhmsEuW7hFlSAb7cQU76pZDViDuwsjY0Kh9GfkbJfgmRfjEXFHE
	T2h/865NA8+D2dLWheV9SnlaLfBRBwF2Lb6IK4OHeVnA9xaiRnukjRpeSmHAS9PCKuGZxw3/eOa
	i3Oa8raFOKqc+2BYoV8HF0J/cG7Pw9gesHT3B6xFH9mOL7ZMHW1V8Z8wWgKMpL67eYv5lfjKRMl
	QtbP2EM3fZ2HVguSxFxTwFq+UZkvZwzo1ykvHPkgjdFlXjcDBOOcV68amftV5d7jM4FUVqq59Pr
	LeWpvqOrjcNMC1x4/2cFNTs0c7F3OUYhydACp/U3G2DGG29jj1C/d+BClGT37gzEvQr/3XLr9dz
	LhAYdQqGpEEPk67KaDsYr026vhy42aZ4tA/vCcw==
X-Received: by 2002:a05:693c:2504:b0:36a:8a6:6916 with SMTP id 5a478bee46e88-36a4236f746mr17282888eec.18.1793676618913;
        Mon, 02 Nov 2026 19:30:18 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm41498577eec.8.2026.11.02.19.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:30:18 -0800 (PST)
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
Subject: [PATCH v4 0/3] IB/isert: fix the device removal use-after-free
Date: Tue,  3 Nov 2026 12:29:21 +0900
Message-ID: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
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
deadlocks against the handler_mutex that rdma_destroy_id() needs.  3/3
moves the teardown into an ib_client callback, as nvmet-rdma did in commit
f1d4ef7d8883.  1/3 is a separate problem that 3/3 adds a caller to, and
2/3 is an older deadlock that 3/3 would otherwise inherit.

The design is one owner per connection: publishing happens in the same
isert_conn_mutex section that tests isert_device->removing, and whoever
empties isert_conn->node under isert_np->mutex owns the release.

v3 -> v4

v3: https://lore.kernel.org/r/20261102061608.617186-1-yhlee@isslab.korea.ac.kr

Review of v3 raised six problems, all real; the first was a regression.

The refusal path in isert_connect_request() was that regression: v3 tested
removing after isert_rdma_accept() had run, so it destroyed an accepted QP
without draining it and rejected an id it had accepted.  v4 tests removing
before the accept and rejects there; if the test at the publish point
catches it, v4 drains the QP and returns an error so cma destroys the id.

Draining under isert_conn->mutex was the second, and not v3's doing:
mainline has done it since commit 6d1fba0c2cc7 ("iser-target: Rework
connection termination").  2/3 fixes it, and I split the drain fix out
with its own Fixes tag so it can reach stable without the rest.

The connection left in ISER_CONN_INIT was the third.  v3 marked it and
waited for a CM event that never comes; in v4 the removal walk owns it.

The trigger review named there, a DREQ before the RTU, needs the RTU lost
after the initiator sent it; a test-only drop left eight connections
unreleased on v3 with the removal never finishing, and none on v4.

The fourth and fifth were races on the np lists, both in 1/3.  The CM
handlers test isert_conn->node under isert_np->mutex and stand back when
it is empty, and connect_error returns zero there.

The sixth, a CONNECT_REQUEST after isert_remove_one() returns, is still
open: a test-only delay showed a new isert_device torn down cleanly by
cma's DEVICE_REMOVAL, but nothing orders that against device release.

One change is mine: the teardown now runs outside isert_conn_mutex, which
let a connection outlive its portal, so isert_np is reference counted.

With soft-RoCE, three v3 against three v4 runs per case: accept and INIT
went from a removal that never finished to one finished in seconds, drain
from six stuck drains to none, np list from 32 use after frees to none.
2/3 alone turned ten hung task warnings a run into none, three runs each.
Under KASAN one of twelve unpatched runs finished the removal and two
reported the use-after-free, 17 and 11 times; all twelve patched runs
finished and reported nothing.  Making rdma_accept() fail on every fourth
connection refused 48 connections over three runs with no KASAN report,
and every removal finished.  Login and I/O ran 18 times a side with no
difference and PROVE_LOCKING gave no splat in eight runs.

Yehyeong Lee (3):
  IB/isert: do not publish connections being released on a second list
  IB/isert: drain the QP without holding isert_conn->mutex
  IB/isert: tear connections down from an ib_client on device removal

 drivers/infiniband/ulp/isert/ib_isert.c | 310 ++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 240 insertions(+), 79 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

