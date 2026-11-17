Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.153.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794915092;
	b=OtP86cTjIsiSQFpsM8GkmY5vh5mRhyNnfIV0kE8pgT//cP2UKv1kNG5O2RIsRNe13ZqT
	 uNSZ/47ouP9lFYjuF9kvliTeSaEdInUgJSriQEyjrP4COT/N1IGZmbdb4NfXL3GTDLalC
	 yp3UcsoAAsQQ6YlQXSK5g8XsZ076xCcWvBaQttPFsyJxzuFbX8Bz6MMD2VPdVGlaSfe8S
	 kxMUTkpLoOAO4q6DD4VOSX3XHoviaKlf8mqS5K/TyWmvfZNOU6/eX2c0QkHkKHiZbsunI
	 +wLrnmSeny8XkhoKIAmY2G0EjuJoCIqcWkStl4ZvkF1GqztuV8+CKPWOTrkyLVT03Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794915092;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=lAbvIquq6eN3EU/HV67PNZGDW00wmyx7R71DbgJixRo=;
	b=yf6u9aBMmFHHv8wTgdjTqePq9+ezQvbP5flzdj9yCH04aBC+PSFso/+GMwVVsUh9C3no
	 fWlaHnMvIZn3WqBg+LyZWw4LVDcCkzzKN1zmQD1Y9K7GWybQ+2VLPiAuZbmxqZ2U1SkHq
	 Z5cM2MWWRJSdZb4fRQ6nhAatnlbM9j5xkMrNNHV2bk5JEUqkBgSdGVq1jaRObCWQazPzF
	 0HNwFdRvEpkVREnWeyhOtUpfcug2zkNqx68F4+NauG14Z3tQ4u178wXlsTkTIOGWGzqoA
	 qz2px3VIbudA6ihyxPyQVak2CtxWNGY86DT9IYcA4p0M9hbjh9MBoiu1wd/Coshq5WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=EAgm+sqY;
	arc=none smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBBA606A323
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EBBA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=EAgm+sqY
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794915101; x=1826451101;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2axHprejUkEX2g/CWgFDV7gmso5xZUAiGQ78yKq+d4k=;
  b=EAgm+sqYQc/en3+pRXQZ4pHmrBLM6ChIIdhsnmcwhgwnBh2Fm8XPu2LJ
   o3OTCssq8UuDIzPQ07sY7/gAjhUdnfliyUujlrCECE5PDG3NmMH8rS5b6
   NGfhcgBozYdeqWo3qGfBcxrBsKeCphYgIiwooVeVPXt7FoOQzMDATE82j
   tU7EEuhGkMcdln7kohMAbvkLMx+lOREoshfesK/CtaUOV3025YmDGKMSA
   J+lHq9PrZtTnKmo+SWb5jiz1CWFWxcxRDXTMcuEKXXh+ShmCfCnXIem2x
   oKIGbF30n5dJ/6If1i8PgXGQueNJKCctJ6fsiWRJEi+jo5fTlyFJn3bI0
   A==;
X-CSE-ConnectionGUID: Eq2s1ZfhTA+b4Cz3vySueg==
X-CSE-MsgGUID: HluR7SO0RCKpsACPZvl9lg==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161093533"
Received: from h199-255-45-15.hgst.com (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Nov 2026 19:31:40 +0800
X-CSE-ConnectionGUID: OLG7+D07RxyKfzdybnDJ+g==
X-CSE-MsgGUID: FoNZVljlSD+qdUB3loofyQ==
IronPort-SDR: 6afc3b13_LR4dFHuZg/LUmNsDjHSihzdrU1Qwbj+TLSRsytjkVou3U+W
 XQP7I1TipLV72gzdhnI8K1aVulbxNay++hrZK8w==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 03:31:31 -0800
X-CSE-ConnectionGUID: HJciZE7ZS8iLUQoo1ESQyw==
X-CSE-MsgGUID: lAPvm1lySd6fs36D2ne1ng==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 17 Nov 2026 03:31:30 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-rdma@vger.kernel.org
Cc: linux-nvme@lists.infradead.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Surabhi Gogte <sgogte@purestorage.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] RDMA/cma: Use a separate lockdep class for the listening cm_id
Date: Tue, 17 Nov 2026 20:31:29 +0900
Message-ID: <20261117113129.746490-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
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

Since commit 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation
and startup"), the host can send commands on an I/O queue before the
target has seen RDMA_CM_EVENT_ESTABLISHED for that queue. nvmet-rdma
keeps such commands on queue->rsp_wait_list and executes them from
nvmet_rdma_cm_handler() when the ESTABLISHED event arrives, that is,
with the handler_mutex of the queue's cm_id held. Executing a connect
command takes nvmet_config_sem, which creates a handler_mutex ->
nvmet_config_sem dependency. This is the reverse of the order in
nvmet_port_subsys_drop_link(), which holds nvmet_config_sem and calls
rdma_destroy_id() on the port's listening cm_id via
nvmet_disable_port(). Lockdep reports the warning below when blktests
nvme/004 or nvme/031 is run repeatedly with the rdma transport and the
rxe driver:

    WARNING: possible circular locking dependency detected
    rm/7346 is trying to acquire lock:
     (&id_priv->handler_mutex){+.+.}-{4:4}, at: rdma_destroy_id+0x17/0x20 [rdma_cm]
    but task is already holding lock:
     (nvmet_config_sem){++++}-{4:4}, at: nvmet_port_subsys_drop_link+0x52/0x340 [nvmet]

    -> #1 (nvmet_config_sem){++++}-{4:4}:
           down_read+0xa6/0x530
           nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
           nvmet_ctrl_find_get+0xaa/0x320 [nvmet]
           nvmet_execute_io_connect+0x1e0/0x480 [nvmet]
           nvmet_rdma_execute_command+0x18e/0x480 [nvmet_rdma]
           nvmet_rdma_handle_command+0x428/0xb30 [nvmet_rdma]
           nvmet_rdma_cm_handler+0x8a8/0x30f0 [nvmet_rdma]
           cma_cm_event_handler+0xb0/0x3c0 [rdma_cm]
           cma_ib_handler+0x28a/0x9b0 [rdma_cm]
           cm_process_work+0x4b/0x3e0 [ib_cm]
           cm_work_handler+0x2485/0xac10 [ib_cm]

    -> #0 (&id_priv->handler_mutex){+.+.}-{4:4}:
           rdma_destroy_id+0x17/0x20 [rdma_cm]
           nvmet_rdma_disable_port+0x44/0x300 [nvmet_rdma]
           nvmet_rdma_remove_port+0x42/0x60 [nvmet_rdma]
           nvmet_disable_port+0x120/0x1f0 [nvmet]
           nvmet_port_subsys_drop_link+0x261/0x340 [nvmet]
           configfs_unlink+0x36d/0x790
           vfs_unlink+0x278/0xb40
           filename_unlinkat+0x31d/0x670
           __x64_sys_unlinkat+0xae/0x100

    other info that might help us debug this:

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(nvmet_config_sem);
                                   lock(&id_priv->handler_mutex);
                                   lock(nvmet_config_sem);
      lock(&id_priv->handler_mutex);

     *** DEADLOCK ***

However, the two handler_mutex instances belong to different cm_ids. The
one held during command execution belongs to a connected queue's cm_id,
while the one taken by rdma_destroy_id() belongs to the listening cm_id.
nvmet-rdma does not take nvmet_config_sem while handling events of the
listening cm_id, so this is not a real deadlock. Lockdep cannot
distinguish the two because all handler_mutex instances share a single
lock class.

To avoid the false-positive WARN, assign a separate lockdep class to the
handler_mutex of a listening cm_id at the start of rdma_listen().

Link: https://lore.kernel.org/linux-nvme/at36um4zrsfOr3kh@shinmob/
Fixes: 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation and startup")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
* Changes from RFC v1
- Instead of the new helper function, do the reclassfication in rdma_listen()
- Link to RFC v1: https://lore.kernel.org/linux-rdma/20261108120154.148824-1-shinichiro.kawasaki@wdc.com/

 drivers/infiniband/core/cma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1acf7..b3678ddc79a4 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3949,6 +3949,13 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 		container_of(id, struct rdma_id_private, id);
 	int ret;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	static struct lock_class_key cma_listen_handler_mutex_key;
+
+	lockdep_set_class(&id_priv->handler_mutex,
+			  &cma_listen_handler_mutex_key);
+#endif
+
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN)) {
 		struct sockaddr_in any_in = {
 			.sin_family = AF_INET,
-- 
2.56.0

