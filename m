Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36778468C26
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 06:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392837; cv=none; b=EaJhu1NZYAfAiFzlCOrINVNp6Qfz/3ADRP0AlJXmvh2O2r6mKAJkU954S/Di+xpv448jK/vLm+6cj9Oh/iNnzUp7r/OnrieE3ASt9v0CVOldffHxK1dHOpgzEpVk/5KSqeKrqVsFOJ5rdG6AZa8lhGOeePvwFIaX2kmgXuzwDb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392837; c=relaxed/simple;
	bh=ie9v22uPr7PotWlb4fNjvhbFPlRotAAB+Ebqx+gumkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1fA9rrIzy1raJJJGlhUsr5Acwu1JGl3ESI+s4lLRMcVcQZ4VpIgvdSDfgWj2PEYBbjje/7oAIG9MdmbbGAjx4RcybSVwjepscRGV6axzf5Sze3r60o160i09NM7qrmWJNOM7oGf4+9klQ4o75ycjIHjG09HlUF3TWWRGsCqMJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W5nW6nyc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W5nW6nyc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792392835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+7V933gJJwiBIK/wX238Dvmgf2YOL/YBDIJFdDFHDQ8=;
	b=W5nW6nycjUxW+a6zTIvv75nL+HApt4TglIlqVNBMAcgyGVaaa0KVSqbkaRvp4EmQpIAGIT
	pyubgHzG+fRtY0xz6imDC+fZ1QbRdoWykrgqF37sz1E54yiubjHYVQwAO5t/VBB66pZvVH
	MRVcM95HqxFcoOoNvns8uVdIWGnY4Bs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-489-tqBd2ESLMDC73_C1eKDJ_g-1; Mon,
 19 Oct 2026 06:53:37 +0000
X-MC-Unique: tqBd2ESLMDC73_C1eKDJ_g-1
X-Mimecast-MFC-AGG-ID: tqBd2ESLMDC73_C1eKDJ_g_1792392815
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B90819560BE;
	Mon, 19 Oct 2026 06:53:34 +0000 (UTC)
Received: from poros-thinkpadp16vgen1.tpbc.com (unknown [10.44.48.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 543621956086;
	Mon, 19 Oct 2026 06:53:28 +0000 (UTC)
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
Subject: [PATCH iwl-net 3/3] ice: do not block on the aux device lock in ndo_setup_tc
Date: Mon, 19 Oct 2026 08:53:01 +0200
Message-ID: <20261019065301.3983537-4-poros@redhat.com>
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

The TC_SETUP_QDISC_MQPRIO path of ice_setup_tc() takes the auxiliary
device lock to test whether the RDMA driver is bound, and ndo_setup_tc()
runs with the RTNL lock held. This closes the same cycle against the
RDMA auxiliary probe as the two preceding patches.

Use device_trylock() and report the device as busy when it fails, with
a distinct message for the same reason as in the previous patch.

Fixes: 4b31fd4d77ff ("ice: Fix RDMA VSI removal during queue rebuild")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index edb62606d2aae3..7b251136149615 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9448,7 +9448,11 @@ ice_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		cdev = pf->cdev_info;
 		if (cdev && cdev->adev) {
 			mutex_lock(&pf->adev_mutex);
-			device_lock(&cdev->adev->dev);
+			if (!device_trylock(&cdev->adev->dev)) {
+				mutex_unlock(&pf->adev_mutex);
+				netdev_dbg(netdev, "RDMA auxiliary device is busy, try again\n");
+				return -EBUSY;
+			}
 			locked = true;
 			if (cdev->adev->dev.driver) {
 				netdev_err(netdev, "Cannot change qdisc when RDMA is active\n");
-- 
2.56.0

