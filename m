Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1DB2E7165;
	Sat, 11 Jul 2026 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783743284; cv=none; b=SGbKM/LuSCqO5SxM6Rch1LQurDRz3Pn/3fTpTfAXw/Y+7xJMA35FVu29Q4R7v9a9xFOn7eQU3Ikt3jG48nRsCXKHcVXZ/5ZN6JMMs2HTFEJxU/8ifEBKz7kyhLToHuwfLjnq9b+TV2bs7hIhSEHZjSDFD//ihKjydLRqi4LrDIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783743284; c=relaxed/simple;
	bh=okSyZywuqHV+Cm2f8lzFI27HsSTmR6M4in7XkC4F/oA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAscS+bY5Xto3PWgmAFXVSA83WbSN9YEarb8lFxLys8IahT5zZIafxV8eBCbUPqj609tMIQCc9wFYKMXAgCIKuofcwgI8qK5gP5zYmdsNXfpcPUqHBpRUDn+XakOJtVvoOmIIVPNnlfjFmBcc2Q/2cnAQITIfX4WVdUt0zNHi1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=OmsVJg0q; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="OmsVJg0q"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 81C5920B7172;
	Fri, 10 Jul 2026 21:14:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81C5920B7172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1783743273;
	bh=QUJr0cSBp7DDYOpENoiFxljH1AKPOMDQDxe5QybqQo4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OmsVJg0qDaEa8xvcK1Zgf6EIDfjKTZBc4q5n1AIafgjkoLmY9zeHaLX7P6rOBmzFP
	 TrwoJWD2sGkScJfDMqNcNAazKt/U6AqsOkzfxBKAh2uoQzxmiL7GQIRcRxEkCp9UBF
	 5Pl1tfoJi379pDeKQKcWJQc5dyacyS8bi+yP3CV8=
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
	yury.norov@gmail.com,
	pavan.chebbi@broadcom.com,
	schakrabarti@linux.microsoft.com,
	gargaditya@linux.microsoft.com
Subject: [PATCH net-next v12 2/4] net: mana: do not bail out of mana_detach on dealloc failure
Date: Fri, 10 Jul 2026 21:10:22 -0700
Message-ID: <20260711041415.3008868-3-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260711041415.3008868-1-dipayanroy@linux.microsoft.com>
References: <20260711041415.3008868-1-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_detach() sets port_is_up = false before calling
mana_dealloc_queues(). If that call were to fail and return early,
netif_device_detach() and mana_cleanup_port_context() are skipped,
leaving the port in an inconsistent state where port_is_up is false
but netif_device_present() still returns true. A subsequent
mana_detach() from the reset work handler would then overwrite
port_st_save with false, causing mana_attach() to skip queue
allocation and leave the port permanently dead.

Remove the early return so that mana_detach() always completes its
full teardown. mana_dealloc_queues() already performs best-effort
cleanup regardless of internal errors (and in practice cannot fail
here since port_is_up is already false), so continuing to
netif_device_detach() and mana_cleanup_port_context() is safe and
ensures the state is always consistent for recovery.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 89e7f59f635d..5e3c7a2a2b49 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3707,10 +3707,8 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
 	if (apc->port_st_save) {
 		err = mana_dealloc_queues(ndev);
-		if (err) {
+		if (err)
 			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, err);
-			return err;
-		}
 	}
 
 	if (!from_close) {
-- 
2.43.0

