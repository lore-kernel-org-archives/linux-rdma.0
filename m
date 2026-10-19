Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92756485945
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392803; cv=none; b=WrokDfBgdrryKsCvfM1xNGjz0OB0MmccyYkRDyIqoJFDJum5WMRyk+wNm51vHNwYS/Z1v2cpMaidrdXdOcMwgMYLVVcfq5IbN/mhU4BlKziOnuI2RydQ3VZ36WikYUsmAj7gI2B1PA4oYAp/icJ11Dn5/hUJOskyvXT4A5RWcTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392803; c=relaxed/simple;
	bh=p+X+Xl8+cPLsbpBhfIlv3qel9raJ5+zSbCI5QqSPwB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FxvmmpecXMRxHArDZkWGS80zlYwS+94h3mdP4kdUgEurxdU5wRSgOcrVDzsoghdkhSl8a0F5SeZqkjXEWjucZTxTuk2gMW7p4HeSbPdghBSrIpOYfsSVK3hrnkFwp4F0AHub9nOTUW9GVwTHeR8vCifBynpdtOxgcmqF99TVI7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g33zgd9+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g33zgd9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792392800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ia+ZEym176fLK/VRzqajkyY5xZ/llz9gMIBRTMQe8QA=;
	b=g33zgd9+zjfpjl/k1QFS2e21XrQ0FhYYayHJDnfTfMt90JaD2iRF+pDRU2qWWFWeSsxYOZ
	ZqhK2fqKwNxbiaBRUt4PkY34Rj9q45KJjcvZv7whTpj1+2v/QgvNhjuYWsDNVRupuQYOBP
	naxijlaghFUrQI3X732pKiiiB6qzTcA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-RhZmXjyNMK-bjT8GInK8pA-1; Mon,
 19 Oct 2026 06:53:16 +0000
X-MC-Unique: RhZmXjyNMK-bjT8GInK8pA-1
X-Mimecast-MFC-AGG-ID: RhZmXjyNMK-bjT8GInK8pA_1792392793
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C677F1955F74;
	Mon, 19 Oct 2026 06:53:12 +0000 (UTC)
Received: from poros-thinkpadp16vgen1.tpbc.com (unknown [10.44.48.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 279441955F03;
	Mon, 19 Oct 2026 06:53:03 +0000 (UTC)
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
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH iwl-net 0/3] ice: fix RTNL vs auxiliary device lock inversion
Date: Mon, 19 Oct 2026 08:52:58 +0200
Message-ID: <20261019065301.3983537-1-poros@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ice takes the auxiliary device lock of its RDMA auxiliary device from
three places that run with the RTNL lock held. The RDMA auxiliary probe
takes the same two locks in the opposite order, because __driver_attach()
holds the auxiliary device lock across ib_register_device(), which needs
the RTNL lock. ib_query_port() reaches ib_get_eth_speed() first from the
port immutable setup and again from ib_cache_setup_one(). The result is
a hard deadlock that leaves the whole RTNL-serialised part of the stack
stuck, so the boot never completes:

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

linkwatch, addrconf, NetworkManager and every ethtool ioctl then pile up
behind lldpad. On a PREEMPT_RT kernel with CONFIG_DEBUG_RT_MUTEXES the
rtmutex chain walker reports "rtmutex deadlock detected" from whichever
task closes the cycle instead of hanging silently. Plain lockdep cannot
flag it, because device_initialize() marks dev->mutex with
lockdep_set_novalidate_class().

The probe side cannot be changed, so the three ice callers stop blocking
and use device_trylock() instead. Contention is only possible while the
driver core is binding, unbinding or suspending the auxiliary device,
since all three sites already serialise against each other under
pf->adev_mutex, and ice_unplug_aux_dev() clears cdev->adev under that
mutex before calling auxiliary_device_delete(). ice_unplug_aux_dev()
itself is never reached with the RTNL lock held, so there is no fourth
site to convert.

Patch 1 then handles a contended lock per event, because the right
answer differs. BEFORE_TC_CHANGE has to arrive before the traffic
classes change, so the DCB reconfiguration is refused with -EBUSY. The
MTU change and critical error events are sent from the service task,
which consumes their pending bits before sending, so they are re-armed
for the next run. AFTER_TC_CHANGE keeps its existing fire and forget
behaviour, and the commit message explains why deferring that one is
not safe. Patches 2 and 3 only turn the lock into a trylock, where a
contended lock means the operation is refused with -EBUSY and can be
retried, which is what the existing check already does when the RDMA
driver is bound.

This keeps the fix small enough to backport. It does not address the
underlying layering problem, which is that ice reaches for the driver
core lock of a foreign device at all. i40e and mlx5 both solve the same
need with provider-owned registration instead, and converting IIDC to
that model would make the inversion impossible by construction. That is
a net-next change across ice, irdma and iidc_rdma.h, and I am happy to
follow up with it if there is interest.

Tested on an E810-XXV with two PFs, irdma bound to both auxiliary
devices, on net tip commit 191aa41548b2d2 ("MAINTAINERS: add Bobby
Eshleman as vsock reviewer") with and without this series, same config
otherwise. A reproducer binds the irdma auxiliary driver while driving
one of the three RTNL-held callers into the probe window:

                        without the series   with the series
  ethtool set_channels  deadlock 10/10       0/10, window entered 300x
  ndo_setup_tc mqprio   deadlock             0/10, window entered 50x
  dcbnl ets set         deadlock             0/10, window entered 30x

A window entry is a contended device_trylock(), that is, the exact
moment really_probe() holds the auxiliary device lock and waits for the
RTNL lock, so each one is an occasion that used to close the cycle.
Without the series the console shows both halves and the box only
returns through hung_task_panic. 25 reboots on the patched kernel were
clean.

Petr Oros (3):
  ice: avoid RTNL deadlock when notifying the RDMA auxiliary driver
  ice: do not block on the aux device lock in ethtool set_channels
  ice: do not block on the aux device lock in ndo_setup_tc

 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  9 +++++++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  6 +++++-
 drivers/net/ethernet/intel/ice/ice_idc.c     | 20 ++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_idc_int.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 22 +++++++++++++++-----
 5 files changed, 47 insertions(+), 12 deletions(-)

-- 
2.56.0

