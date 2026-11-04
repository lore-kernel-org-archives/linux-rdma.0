Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755354;
	b=nakPQhfi98xfAAvcewZ2kF2wmeSnaisKQ5sTysqU8l3wDp+REnsMQEuHUmlDlktgGSjb
	 FtMfrWvzfWkJwfjHkcgxLNVtHvQKPSJm6Pi758Rin5IU/WdFqu815azAPb3kHoZ2R97em
	 Wzy4yfk12AkwrUyXC2xN4vq5GupfQLnVTW8G4oqBdPRCXvK8Ppj+btQdeW6Q+c6eZLPWG
	 8GelJ+E4va5nh0bdCbhC06Ie3ZNLJ343HfeGE3jZmETHHkIGMUqaSRaZP8TlFLu890vYM
	 yZVsz0OHdFZHdo+t1K6EjZzd6fSDGtWMaWF8gv0wzGnCi6AK1vTvMIzD/zzTpu1jFVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755354;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PJBuNB6AkmZaXTR0pd/HV7JvJHCCmg2tFqwhpuFbIGs=;
	b=gXbaX/u7lZ9JjmqWVhWj8Pj8w7BSDMqUM5cwTGXrepCYpCWe9tkS0byRkDYPShVB7rYa
	 OfqzbrvpiN9HVfTyjTVT7tgMbmHLwd9V4LIwxhGBETs6fZRwotwUMYju4RgYZXC+GbTNE
	 49gAbDM7+dBni1RC0CqvxJTsGWwnEi14XRQr4BZ5EtzSYecnKvc9rBtvRrloKziIkg7UE
	 qDKdd386rCSrSoAELUxRKIrxTc9ZudITpnXkVcQAOpsB5+vZPLTHY1a7vYdiEcXBrwuAF
	 hBfahq9XrJvv6GmqUVCnj8/u0ogik6N7NgUIOv6s/xCKXUjXGEsanSwr7WREqNZv/QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QY3a6FxG;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABD7606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ABD7606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QY3a6FxG
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so208149a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 17:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755352; x=1794360152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PJBuNB6AkmZaXTR0pd/HV7JvJHCCmg2tFqwhpuFbIGs=;
        b=QY3a6FxGWEEGE0Gke5rLu5IpVBl4gWuFlimWmeG5zx1mMNskq5V77WjWyyzimEg8uY
         TJOV9SCzvRaSFGuOoF70o5cPppKTGFF2KIECNiVjFvJiXY1hZUrrqQD48Z0l25a1V7H5
         JHgvJfrH130y7YkWuO1yf5lUsfMVZamq5LXWQnf18HmS2Xf9QImZ7crpjUzRs3rBwHHy
         22BdLzCOLM4dhFNJ5Rwb4HePT/r/rk17BapFFcjw+5mrLaiNuN13zeexRTK46NFhQCJN
         f3zBmLyyv10UTuJ00qViyGH16PGlFU7U9QPLSybdWuni8i9E70v+h4OFvIcOsDhf4dt1
         S75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755352; x=1794360152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PJBuNB6AkmZaXTR0pd/HV7JvJHCCmg2tFqwhpuFbIGs=;
        b=p1KUw3JFGq6vSfEN4zlXJItIrUd+jIMzZ/2mgKz93K39ulMKdqnAGRU6o5CjQN55f2
         BmgqpjBrkjeGR8qX9UeHG4i34t2FYh6Y6cSZDiD8DT2c9q3Sv6cSevnFgWtuGtI0AwiZ
         ngZMtnPztmuo0k+5ZhrygVl+DOjth6fzgdGYgW25csbfDQNgR4wWHc7A024rN6Mu+9OA
         aWChO90ow36RVJsN5GN8tP+cw52Sdba0ynODWrVgozNH3Cimrw1wQ5C5x1yaOdBS+NoS
         abYasspbpDd1I7n+7rgntH7kcBnTSszT4WL79OWJel9jnpKtkFKhIOb+0EjATqt8n6F9
         PWqA==
X-Forwarded-Encrypted: i=1; AKwUvBwKrUA0IK6dPnUTQk6qQnkf0j/zSqERaHfk8MduhXlNoscS/wwdkXlkQpih8Dc1N62VjPWASH6hJAk4@vger.kernel.org
X-Gm-Message-State: APuU4Z9i37jE6sqaKvHpinAdjeWsjXwCfU0vbvFnuDVU0EEfxAurtRtH
	SwtYuXZAoBBra4K0mB49/Seho5thLsfiAPySeyqSwUJVHceaZERb6YW09oNxMLoVYJ4=
X-Gm-Gg: AYBFou34eGzl4Fxl/f+8JIJsZOHQrP5k0jozPV1ROaTl0R6WEo/1N4f3R5njonZfDKG
	7u7D0LsatFVd+hvl/JLIHm3JxO+4OBOe/UAJzuZ5OX2ZGThoNJxkfRBx1MdI9QEV50FAAcVXNi0
	BU9Eq+J9iwtQehypy5TIsgrcMNJBcDpNAlA5xyBqe7oTQ3Tly+poC5uHQyRSrmhFs2YkRnuW3od
	60yc/CZQYiEFTq/aPGEkkguJssnnVBjeOj33Ok77SFaPSttbNGo/2iG1jtbv0WlfhPex0xU38wm
	FECtezgssdILIeQQtKn/eVBGEKZI9WYftXyCPuJPkQUkJ2R8BakGUNV78BDpMrT/FvG88yuU7PX
	NTlFDftbj33laIo7UA7Au8VnxvWGDY6gr2OqrW47ejJ4bGA0gdgiN1xAZJgheZZ+TeDJcDyV3n2
	YDapeoGrehRKbaFOQAajcqR3uUX+VF5p2Bi3tUE5P2pvdvAFdekPMG1VO0v19iKwKUeaklJm0/M
	ADndn//JKFtciSJgCmCDoVaJ49whNg/2NHU0T1IfaPNXUfjE/W6etC1bCmISK393LrhNZWoynoy
	vCYNHiJvguJZQf7ed9bNi0aiZNx3lHGwb2FSg+xBctdwXFoFDGGq8EE25H+7lOEIDj0rofEqspu
	HEgvKRxF8LDAiNFYi1LAVi2/iVDOyaLTmOHp9
X-Received: by 2002:a17:90b:4b8c:b0:3a8:9d0d:ca50 with SMTP id 98e67ed59e1d1-3ae897c853cmr12849266a91.10.1793755352365;
        Tue, 03 Nov 2026 17:22:32 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09452d89bsm678045a91.0.2026.11.03.17.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:22:31 -0800 (PST)
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
Subject: [PATCH v7 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 10:22:13 +0900
Message-ID: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
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

v6 -> v7

v6: https://lore.kernel.org/r/20261103223802.1697607-1-yhlee@isslab.korea.ac.kr

v5: https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr

v4: https://lore.kernel.org/r/20261103032924.1073138-1-yhlee@isslab.korea.ac.kr

Sashiko v6 5/6 Medium: set removing in the same critical section that
clears the client data.  isert_remove_one() cleared the ib_client data and
took its device reference under device_list_mutex, and set the removing
flag only in a later section.  Between the two an isert_device_get() for
another device with the same node_guid still saw the departing device as
usable and raised its reference count.  5/6 now takes isert_conn_mutex
first and does the clear, the lookup, the reference, the completion and
the flag in one device_list_mutex section.  No path in the series holds
device_list_mutex while taking isert_conn_mutex.  Nothing else changed:
1/6 to 4/6 and 6/6 are the same commits as in v6.

Measured over soft-RoCE with KASAN.  Parking isert_remove_one() after its
lookup and connecting on a second device with the same node_guid gave the
departing device two more references on v6 in both runs and none on v7.
Everything else is unchanged from v6: 140 runs with no KASAN, no Oops, no
lockdep splat and no refcount warning on either side, the late-device
window building one device and no core warning in six of eighteen runs,
twenty link removals and re-adds leaving device_list empty, and the login
park finishing in eight seconds.  I still could not measure the namespace
move, for the reason given in v6.

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

