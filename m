Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC9489897
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 06:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392811; cv=none; b=hVWEhC2FvsZCWYnS55EbDO0KcsrG9zqIG6IZh0WUNf0dMbj+YehNNtwTP2VAeRqmUlMNKh5LTyzxycKKOZlqNNa9ws2eBRKW1SeONY0SwDS6Mkunjg1CzWYaaodHSxiNkPDShTMotaCnWA82SOesCAu4G3GlpjRAjFE0QIB+xeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392811; c=relaxed/simple;
	bh=lvgCpj2BVbM5zF8eVIh6rW4bPvglPkxTRgUlYOGhc5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnvLa6oj6FL5nTFk+CuBlbsxYsvZrDQuFYjxmiey3Zz2QZ3rUKTN7R9FNGse6wgMH5uVUWVg16Yx6s6T4MyY2ew8sygt1hUD3dpGpg5iDfNAcMel9Xpt1gwVxcGzB3AjBA9onxxoQFaBgGPR9rRFH39/HaPsKzuImegkk2kAEdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XzpJ7ypn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzpJ7ypn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792392808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZKK2mK9WchO5j1LrObMA8qjj5chpCR85FD1KEc1M4Jk=;
	b=XzpJ7ypn0hFZWKZ55k8403wPkmX7ZW50YeuI5MSgRt2Jt+BjNkL9M49dWS/ul2naNioGcj
	uyCR9eW8GsRZx7t3ySrtrFMG7Bc8TFMTLwy01bU0l9Dd7taqOuZJnBtdjPuhaP/HE5blWe
	aeS3UWhka9CZox/cb1mjpH5FcuLmW6g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-16VY8XV7NuCJI70W4peeCA-1; Mon,
 19 Oct 2026 06:53:24 +0000
X-MC-Unique: 16VY8XV7NuCJI70W4peeCA-1
X-Mimecast-MFC-AGG-ID: 16VY8XV7NuCJI70W4peeCA_1792392801
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D8DB1955F22;
	Mon, 19 Oct 2026 06:53:21 +0000 (UTC)
Received: from poros-thinkpadp16vgen1.tpbc.com (unknown [10.44.48.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4224A1956086;
	Mon, 19 Oct 2026 06:53:13 +0000 (UTC)
From: Petr Oros <poros@redhat.com>
To: netdev@vger.kernel.org
Cc: Petr Oros <poros@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Kamil Maziarz <kamil.maziarz@intel.com>,
	Rafal Rogalski <rafalx.rogalski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	linux-rdma@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH iwl-net 1/3] ice: avoid RTNL deadlock when notifying the RDMA auxiliary driver
Date: Mon, 19 Oct 2026 08:52:59 +0200
Message-ID: <20261019065301.3983537-2-poros@redhat.com>
In-Reply-To: <20261019065301.3983537-1-poros@redhat.com>
References: <20261019065301.3983537-1-poros@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ice_send_event_to_aux() blocks on the auxiliary device lock, and the
dcbnl callers reach it with the RTNL lock held. The RDMA auxiliary probe
takes the two in the opposite order, because __driver_attach() holds the
auxiliary device lock across ib_register_device(), which needs the RTNL
lock:

  systemd-udevd   state:D
    really_probe                  <- holds device_lock(&adev->dev)
    icrdma_probe
    irdma_ib_register_device
    ib_register_device
    setup_device
    irdma_roce_port_immutable
    ib_query_port
    irdma_query_port
    ib_get_eth_speed              <- blocks on rtnl_lock()

  lldpad          state:D
    rtnetlink_rcv_msg             <- holds rtnl_lock()
    dcb_doit
    dcbnl_ieee_set
    ice_dcbnl_setets
    ice_pf_dcb_cfg
    ice_send_event_to_aux         <- blocks on device_lock(&adev->dev)

Everything else that needs the RTNL lock piles up behind lldpad and the
boot never completes. The probe side cannot be changed, so use
device_trylock() and report whether the event reached the driver.

IIDC_RDMA_EVENT_BEFORE_TC_CHANGE has to arrive before the traffic
classes change, so ice_pf_dcb_cfg() refuses the request with -EBUSY
rather than run it behind the RDMA driver's back. The critical error and
MTU change events are sent from the service task, which consumes their
pending bits before sending, so those are re-armed instead.
AFTER_TC_CHANGE keeps its fire and forget behaviour, it can be neither
refused, the hardware has already changed, nor deferred, every lock that
would serialise a deferred delivery against the dcbnl callers forms
another cycle.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  9 ++++++++-
 drivers/net/ethernet/intel/ice/ice_idc.c     | 20 ++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_idc_int.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 16 ++++++++++++----
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 0bc6dd37568792..2022b46c990cb2 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -355,8 +355,10 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	struct iidc_rdma_event *event;
 	int ret = ICE_DCB_NO_HW_CHG;
 	struct ice_vsi *pf_vsi;
+	bool dcb_ena;
 
 	curr_cfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
+	dcb_ena = test_bit(ICE_FLAG_DCB_ENA, pf->flags);
 
 	/* FW does not care if change happened */
 	if (!pf->hw.port_info->qos_cfg.is_sw_lldp)
@@ -406,7 +408,12 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	}
 
 	set_bit(IIDC_RDMA_EVENT_BEFORE_TC_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
+	if (!ice_send_event_to_aux(pf, event)) {
+		assign_bit(ICE_FLAG_DCB_ENA, pf->flags, dcb_ena);
+		kfree(event);
+		ret = -EBUSY;
+		goto free_cfg;
+	}
 	kfree(event);
 
 	/* avoid race conditions by holding the lock while disabling and
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 102d63c3018b1f..7fd35ce966ea65 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -34,30 +34,42 @@ ice_get_auxiliary_drv(struct iidc_rdma_core_dev_info *cdev)
  * ice_send_event_to_aux - send event to RDMA AUX driver
  * @pf: pointer to PF struct
  * @event: event struct
+ *
+ * Return: false when the auxiliary device lock was contended.
  */
-void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_rdma_event *event)
+bool ice_send_event_to_aux(struct ice_pf *pf, struct iidc_rdma_event *event)
 {
 	struct iidc_rdma_core_auxiliary_drv *iadrv;
 	struct iidc_rdma_core_dev_info *cdev;
+	bool sent = true;
 
 	if (WARN_ON_ONCE(!in_task()))
-		return;
+		return true;
 
 	cdev = pf->cdev_info;
 	if (!cdev)
-		return;
+		return true;
 
 	mutex_lock(&pf->adev_mutex);
 	if (!cdev->adev)
 		goto finish;
 
-	device_lock(&cdev->adev->dev);
+	if (!device_trylock(&cdev->adev->dev)) {
+		dev_dbg(ice_pf_to_dev(pf),
+			"auxiliary device busy, dropped RDMA event 0x%lx\n",
+			*event->type);
+		sent = false;
+		goto finish;
+	}
+
 	iadrv = ice_get_auxiliary_drv(cdev);
 	if (iadrv && iadrv->event_handler)
 		iadrv->event_handler(cdev, event);
 	device_unlock(&cdev->adev->dev);
 finish:
 	mutex_unlock(&pf->adev_mutex);
+
+	return sent;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index 17dbfcfb6a2aff..e7d249d6140d92 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -9,6 +9,6 @@
 
 struct ice_pf;
 
-void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_rdma_event *event);
+bool ice_send_event_to_aux(struct ice_pf *pf, struct iidc_rdma_event *event);
 
 #endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d88835482d3aac..edb62606d2aae3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2313,11 +2313,16 @@ static void ice_service_task(struct work_struct *work)
 		struct iidc_rdma_event *event;
 
 		event = kzalloc_obj(*event);
-		if (event) {
+		if (!event) {
+			set_bit(ICE_AUX_ERR_PENDING, pf->state);
+		} else {
 			set_bit(IIDC_RDMA_EVENT_CRIT_ERR, event->type);
 			/* report the entire OICR value to AUX driver */
 			swap(event->reg, pf->oicr_err_reg);
-			ice_send_event_to_aux(pf, event);
+			if (!ice_send_event_to_aux(pf, event)) {
+				pf->oicr_err_reg |= event->reg;
+				set_bit(ICE_AUX_ERR_PENDING, pf->state);
+			}
 			kfree(event);
 		}
 	}
@@ -2336,9 +2341,12 @@ static void ice_service_task(struct work_struct *work)
 		struct iidc_rdma_event *event;
 
 		event = kzalloc_obj(*event);
-		if (event) {
+		if (!event) {
+			set_bit(ICE_FLAG_MTU_CHANGED, pf->flags);
+		} else {
 			set_bit(IIDC_RDMA_EVENT_AFTER_MTU_CHANGE, event->type);
-			ice_send_event_to_aux(pf, event);
+			if (!ice_send_event_to_aux(pf, event))
+				set_bit(ICE_FLAG_MTU_CHANGED, pf->flags);
 			kfree(event);
 		}
 	}
-- 
2.56.0

