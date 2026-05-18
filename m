Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580CF37AA74;
	Mon, 18 May 2026 19:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133642; cv=none; b=pHUuikJfccW8bR29ZvlDFpIJYNQheqynVMODaykRCq60oegq50mhGMcpolpJFfDJ4N3JneWt2J6uyQX6v1Mfzy9ixYC8yzP5tf5B1lygBo6cbp3dL2k25CFaXcQHxozylwoPnw/RLedNzH75UYL/ZTiHUIdgC71jPxpH/s+iIIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133642; c=relaxed/simple;
	bh=/bI0wvIS4irKNIW0UIRdjGpqzaCoFj0Y8jYQlzdIY1Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pA64qKE20mVPNUJql8uxlkwPLZ0fWd3EDW8WF3vhMe8bum7ALflbYtfqfSZZaNoROjQIQuFgndm7f7k/8qWr+nY+pmL+yub2pUL2mgtXKRcIVQQ6Up1O6ko9aguPkD0MGWZDCkCYSC9umZCOI7LuglYM8M1sRX7hDnRwhwLtPm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ch6u7mM1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ch6u7mM1"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4362720B7169;
	Mon, 18 May 2026 12:47:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4362720B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779133635;
	bh=bwEBs7RhjEVS6uregRRC6XmI5WIqcSFOYgqSBVfJPkw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ch6u7mM1x6ZibX8hQFsLuYoPuor8c/sAwiG75n1Rl29ctM8ljFx6cBdCzl9zOQIRa
	 yVXmhP0311OGDtTN0dXGfAUiovyvqVUx8XjLiawGH7630Ef+MvH6BZ7LzHOEnAAkks
	 xHp3RpohJS5Ie8BsORmaMSn89HVnAAV3+encXy5U=
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	stephen@networkplumber.org,
	jacob.e.keller@intel.com,
	dipayanroy@microsoft.com,
	leitao@debian.org,
	kees@kernel.org,
	john.fastabend@gmail.com,
	hawk@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	ast@kernel.org,
	sdf@fomichev.me,
	yury.norov@gmail.com
Subject: [PATCH net 2/2] net: mana: Skip redundant detach in queue reset handler if already detached
Date: Mon, 18 May 2026 12:43:51 -0700
Message-ID: <20260518194654.735580-3-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260518194654.735580-1-dipayanroy@linux.microsoft.com>
References: <20260518194654.735580-1-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mana_per_port_queue_reset_work_handler() runs, it unconditionally
calls mana_detach() which attempts to tear down queues that are already
freed, leading to NULL pointer dereferences on apc->tx_qp and
apc->rxqs.

Check netif_device_present() in the reset handler and skip
mana_detach() when the port is already in detached state. This avoids
the redundant teardown and goes directly to mana_attach() to retry
bringing the port back up.

Fixes: 3b194343c250 ("net: mana: Implement ndo_tx_timeout and serialize queue resets per port.")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 0582803907a8..907efadf6fd6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -316,12 +316,19 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
 		goto out;
 	}
 
+	/* If already detached (indicates detach succeeded but attach failed
+	 * previously). Now skip mana detach and just retry mana_attach.
+	 */
+	if (!netif_device_present(ndev))
+		goto attach;
+
 	err = mana_detach(ndev, false);
 	if (err) {
 		netdev_err(ndev, "mana_detach failed: %d\n", err);
 		goto dealloc_pre_rxbufs;
 	}
 
+attach:
 	err = mana_attach(ndev);
 	if (err)
 		netdev_err(ndev, "mana_attach failed: %d\n", err);
-- 
2.43.0

