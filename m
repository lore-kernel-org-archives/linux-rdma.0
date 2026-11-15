Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794729771;
	b=0GY5srDU2RS4hZEx+zAff5XIS5fsQCr8FpmSFcALlvRmAtMB8FducKH8HSxWw6VWHWda
	 m1Whzs+yUnqGvasQ+/XymEylflvLenbRbP8fOg6CntDg3EZbbwg1ExjWzHNBE34Lj92gZ
	 p5pe79cozAInWXKPT/5nry8wcttNvabCi15Oqw0ORUGhijw0mBFrZqGIo2RjaLWe/GOpN
	 94VFyPpneLCv8XnGZGtyxxlcRcH5lozNKi/rS2eLPkqTKaPiJhGsefGt5oxBaP8knc3Kd
	 +dRt/y0GF/Ag3SwpjErLsY9Ez0Eoouh/r+5JfrPf8CGz1ArZ3NfI94LlwGxEYDEb1uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794729771;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=j5fg8H94L595RJoWrSWVnHYtwYSDGByDB36QOftv6iE=;
	b=WCtYlHcUObuEmhFJa59BhqTwQtutzOFV19eB0yUkHP3/zds5MuGkJJ1rqEaUPy2YBjS3
	 2E1aFqrkKgoo3tXck9Fx3JH9h7riiosumwcx/a/lW6aobtelpU/cBEN1s1U7KC008hdCf
	 jg8q1AEHsFD5NVNvfMY/h7gQ43TVUMhSJtleKCpT9aQTx5btWjaXi61u63ECgeqzV2Kap
	 6jRiYjYnQ8BlZnoLX5qRT7cT4M/s4e3xi69bjKTjZs3hzMUdv4jJLXz49CEmLTvmMdjCB
	 gPQbb6YLTQn6Ax/slzgRb5k+oI7zDUfEUIrHvhHjzYnyMrkT7exitw17EylGJ/oE/uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="Gqm/KVFF";
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC21B606A329;
	Sun, 15 Nov 2026 08:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC21B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Gqm/KVFF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=j5
	fg8H94L595RJoWrSWVnHYtwYSDGByDB36QOftv6iE=; b=Gqm/KVFFkVhIV6u6V8
	ofco9XR4/T2DFInxk1jkHPkzEuY2KbIbhdP9n3D2juLBcJoW+R2lkWN4R9NuxQqw
	ahH9RejWO6fx0ursRavObCfUCjwq8hK/1LfHLKmUkK8hMM+IQkTmiEoanASdrrb5
	dbLRdhpmOaNb48HMyFKXCx8dM=
Received: from user-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3X7wUZ_lqo3Y3HQ--.40037S2;
	Sun, 15 Nov 2026 16:02:28 +0800 (CST)
From: Ziheng Wei <zihengw03@163.com>
To: Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/mlx4: Use the right list member in push_deleteing_req()
Date: Sun, 15 Nov 2026 16:02:26 +0800
Message-ID: <20261115080226.910258-1-zihengw03@163.com>
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
X-CM-TRANSID:_____wD3X7wUZ_lqo3Y3HQ--.40037S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CryUJr4UKF47GrWUArWfGrg_yoW5Jryfpr
	Z0yw15Cr1DGF4093WUWayFqay8Zas5Za4jkFWkKr1DCrnxXr40qF9rGa4Y9as8Arykuw17
	tF1Y9rsrurW7ur7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jMlk3UUUUU=
X-CM-SenderInfo: p2lkv0ljzqjqqrwthudrp/xtbC7RT3SGr5ZxSs7gAA3k

push_deleteing_req() looks up the last pending request from
group->func[slave].pending, but recovers the enclosing struct with the
group_list member instead of func_list.

A struct mcast_req is queued on two lists at once by queue_req():
group_list links it into group->pending_list and func_list links it
into group->func[].pending. The two list_head members are adjacent but
not at the same offset, so list_entry() on a node taken from
func[].pending yields a pointer 16 bytes past the start of the object.

The following pend_req->clean then reads past the end of the
allocation. On x86_64, sizeof(struct mcast_req) is 312 bytes and clean
is at offset 304; the shifted pointer reads it at offset 320.

The entry stays on the list when clear_pending_reqs() fails to cancel
group->timeout_work for the first request, which sets clear to 0 and
leaves the request queued. push_deleteing_req() is then called right
afterwards from clean_vf_mcast() and reads the bogus clean field, which
decides whether the new delete request is dropped.

Use func_list to recover the request.

Found by LLM-assisted source review. Not tested on SR-IOV hardware.
With a test module that calls clean_vf_mcast() on a fabricated group,
push_deleteing_req() read a marker value placed right after the
pending request and dropped the new delete request.

Fixes: b9c5d6a64358 ("IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV")
Cc: stable@vger.kernel.org
Signed-off-by: Ziheng Wei <zihengw03@163.com>
---

Notes:
    The changelog was drafted with an AI assistant from my analysis;
    I have reviewed the code, the fix and the text.

 drivers/infiniband/hw/mlx4/mcg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index bba178ffe..8705724c8 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1216,7 +1216,7 @@ static int push_deleteing_req(struct mcast_group *group, int slave)
 		return -ENOMEM;
 
 	if (!list_empty(&group->func[slave].pending)) {
-		pend_req = list_entry(group->func[slave].pending.prev, struct mcast_req, group_list);
+		pend_req = list_entry(group->func[slave].pending.prev, struct mcast_req, func_list);
 		if (pend_req->clean) {
 			kfree(req);
 			return 0;

base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.43.0

