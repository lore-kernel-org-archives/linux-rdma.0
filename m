Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681433EA959
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 06:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392816; cv=none; b=uw8cRgyb1IhCPQAvokTQeqKOUP3zoRmrt7SG4hqcmGlhojD41rxMHum53i5vs5u4eCmcRfWh5eQGVtFAvxYIx8mxSdql9MnrKLI9HfLtfeYWKmYbI9mEL4J0mTMz/M/1zxj7wiXsG/QraHlbZ9Qoii251MKiFf3rB6w7s3vjrdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392816; c=relaxed/simple;
	bh=OPe7gSSC7OxpKFxaZsRPho9Qvor/8NggM7d07tSf1W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC8XlzDy5Kkm7nxqJgwXQDDGrJwwDxlb5eQs0Q1s/Pj/7G1eo5+ybiixUw/Oscg5hZgTo8+O+kvabtn1hUPopQYtQf7aNQyKqQFuzauhB5vMnp/OsAnwTguhzTQ2rCzRQYyjxlDUfxyQw1wKV9XI7A9JQCi42wKLB56WNFoNoNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GZVC4cFf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GZVC4cFf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792392814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTHOWVdv/FbYDqyrQZpXckGg41AN0bG8lahV7yIctow=;
	b=GZVC4cFf8wkB5Yq9sQ/VsyFoRG4Gny4/34BExznoUyzmzPLMHHMXsYLzg1eANcAngLXUK4
	SIm+MykJoLN2RAuqCv7LAce37wAkYIUYb5VdVPTulWHaDAOePGbcczQkjMeiuetO+ViSEd
	Yswv2AEPaTsGB1iXWgLiUDnUSazdzaw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-7vzVymaHN6a8IU00hPedoQ-1; Mon,
 19 Oct 2026 06:53:30 +0000
X-MC-Unique: 7vzVymaHN6a8IU00hPedoQ-1
X-Mimecast-MFC-AGG-ID: 7vzVymaHN6a8IU00hPedoQ_1792392808
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E15DC1800652;
	Mon, 19 Oct 2026 06:53:27 +0000 (UTC)
Received: from poros-thinkpadp16vgen1.tpbc.com (unknown [10.44.48.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7FFEA1955F03;
	Mon, 19 Oct 2026 06:53:21 +0000 (UTC)
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
Subject: [PATCH iwl-net 2/3] ice: do not block on the aux device lock in ethtool set_channels
Date: Mon, 19 Oct 2026 08:53:00 +0200
Message-ID: <20261019065301.3983537-3-poros@redhat.com>
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

ice_set_channels() takes the auxiliary device lock to test whether the
RDMA driver is bound, and ethtool ops run with the RTNL lock held. This
is the same inversion against the RDMA auxiliary probe as the one fixed
in ice_send_event_to_aux(), reached through a different caller.

Use device_trylock() and report the device as busy when it fails. The
existing diagnostic is not reused, a contended lock does not mean the
RDMA driver is bound. It is a netdev_dbg(), the condition is transient
and userspace already learns about it from -EBUSY.

Fixes: a6a0974aae42 ("ice: Prevent set_channel from changing queues while RDMA active")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index bf9a821c543b7f..f754ffe03285e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3944,7 +3944,11 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 
 	if (pf->cdev_info && pf->cdev_info->adev) {
 		mutex_lock(&pf->adev_mutex);
-		device_lock(&pf->cdev_info->adev->dev);
+		if (!device_trylock(&pf->cdev_info->adev->dev)) {
+			mutex_unlock(&pf->adev_mutex);
+			netdev_dbg(dev, "RDMA auxiliary device is busy, try again\n");
+			return -EBUSY;
+		}
 		locked = true;
 		if (pf->cdev_info->adev->dev.driver) {
 			netdev_err(dev, "Cannot change channels when RDMA is active\n");
-- 
2.56.0

