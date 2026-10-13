Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988CB4F30F8
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891972; cv=none; b=HTZ2qgQnYsdIHr7hRa6mANLUtXxt+PD6+646+LBMcm/ocqm8cNg0u47YP9oOuTF9x9HGf9VxB7LUBEMcKmGKfAVJdj/jc2nefAJVh9/exn477MzeXsy7JLQqVoS7tJknmfROyHOLYA/RTL1qaq4X6YZdZdkg9BSpTDib+wsy+1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891972; c=relaxed/simple;
	bh=5UBmLL+uTySeb1FpxxDkUAGgCNiZIKHqnyr16S+UJWc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gvsP8pm1nwqZmmVXVhI2T/SEjnClS2CuWkFkooT9T0c+PCUFyksJAxnrHv/Rzb2OQDWd9mtJO4bVtTrTOis5KH/ulJ1IFihbbnfZrilyZ2mV+mdm2HIhpULLLnABESpHSf0x2uD0q9ooRRPj62W38105eKbH+GDEExbCeHMEFr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NK7wZHMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NK7wZHMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552F01F00899;
	Tue, 13 Oct 2026 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891971;
	bh=5UBmLL+uTySeb1FpxxDkUAGgCNiZIKHqnyr16S+UJWc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NK7wZHMUfgLFuoMKudyk2mqLqrP2Mjoc+OWonAuQRQ8ebvbp+hzbZ+4QwcXRPkO56
	 LWrhtjyYTjKY9JAtcix0IvRenURVd4WKp1JhtQ72hevq6AmtRlM6mCD0rrLl+zz2LW
	 ZKAV1TKUuw+UVvoJHoME52yGuKt6Y2pVRBLGSvADKJ4nooqDt213yL5kwvBfFFOO43
	 I4teH/VzLfM1bbOs+PDxz2kNYfLaACXIgvGgPyKq17Ir10RhjCSYnmKR3CjhxABZuI
	 Zsv4yjWPHdNejtE8Xc+HiYtZ36zknA15Siu3T7lVIp+8bqPp1eB02xVmGDiLjOKcXG
	 MdEScYCtfOTyA==
Message-ID: <sashiko-outbox-169645@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/15] yunsilicon: add ethernet netdev registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114404.2471317-7-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114404.2471317-7-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 10 potential issue=
(s) to consider:
- [High] net: Negative error code truncated to u8 falsely reports Link UP o=
n firmware failure
- [High] net: Out-of-bounds array write in XPS configuration when comp_vect=
ors exceeds netdev queues
- [High] yunsilicon: TOCTOU race on link_event_handler causing NULL pointer=
 dereference
- [High] net: carrier state desync due to lockless adapter->opened race
- [Medium] net: XPS cpumask accumulates CPUs across queue iterations breaki=
ng 1-to-1 mapping
- [Medium] net: Missing u64_stats_sync protection for 64-bit per-CPU statis=
tics
- [Medium] net: xsc_eth_open silently ignores xsc_set_port_admin_status fai=
lure
- [Medium] net: Race between xsc_eth_close and link event handler leaves ca=
rrier ON while device closed
- [Medium] net: Race condition in xsc_eth_open silently drops valid hardwar=
e link events
- [Low] net: Hardware-provided MAC address is not validated before assignme=
nt
--

commit a6ac5cd27a115b0dca9b12956a0808733a45d432
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add ethernet netdev registration

This commit adds the ethernet auxiliary driver for Yunsilicon XSC devices. =
It allocates the netdev, programs the MAC address and MTU, registers it, an=
d implements the basic open and stop operations for port admin status and l=
ink events.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c at xsc_set_default_xps_cp=
umasks (around line 155), cpumask_clear is executed exactly once before the=
 loop.

Inside the loop, cpumask_set_cpu adds a CPU for the current queue index. Be=
cause the shared mask is not cleared between iterations, CPUs accumulate ac=
ross queues.

Could this break the intended Transmit Packet Steering isolation by mapping=
 all traffic to the highest-indexed TX queue?

[Severity: Low]
Looking at drivers/net/ethernet/yunsilicon/xsc/net/main.c in xsc_eth_l2_add=
r_init (around line 318), the hardware-provided MAC address is retrieved vi=
a xsc_eth_get_mac.

If the hardware returns success, the retrieved MAC is directly applied to t=
he netdevice without validation.

Should we check the address with is_valid_ether_addr to ensure the hardware=
 doesn't supply an all-zero or multicast MAC address before setting it?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/pci/vport.c at xsc_core_query_vport_=
state (around line 28), the function returns a u8 status.

When xsc_cmd_exec fails, it returns a standard negative integer error code =
which is then truncated to a u8.

Back in drivers/net/ethernet/yunsilicon/xsc/net/main.c at xsc_eth_get_link_=
status (around line 105), this truncated non-zero value is evaluated as a s=
uccessful Link UP state.

Might this cause the driver to erroneously transition the carrier state to =
UP during a mailbox timeout or hardware failure?

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.h (around line 11)=
, struct xsc_rq_stats and struct xsc_sq_stats store 64-bit packet and byte =
counters as plain u64 fields.

Since these counters are updated in the NAPI softirq path and read globally=
 without u64_stats_sync protection, will this result in torn reads on 32-bi=
t platforms?

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c at xsc_eth_open (around l=
ine 189), the driver sends a hardware mailbox command via xsc_set_port_admi=
n_status to physically enable the port.

The return value is discarded and the function unconditionally returns 0.

If the hardware initialization fails, could the kernel network stack incorr=
ectly consider the interface UP while the physical port remains down?

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c at xsc_eth_close (around =
line 208), adapter->opened is set to false, followed by netif_carrier_off, =
and finally xsc_irq_event_unregister.

Is there a race condition where a concurrent link event handler passes the =
opened check before it flips, waits out the carrier status change, and then=
 turns the carrier back ON just before the unregister step, leaving the car=
rier ON while the device is closed?

[Severity: Medium]
Also in drivers/net/ethernet/yunsilicon/xsc/net/main.c at xsc_eth_open (aro=
und line 182), the event handler is registered before the adapter->opened f=
lag is set to true.

If a hardware link state change triggers an interrupt in this exact window,=
 wouldn't the async event handler execute, check the flag, and return early=
, thereby permanently dropping a valid hardware link event?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c at xsc_eth_build_nic_para=
ms (around line 74), the raw hardware capability is stored without capping =
it to the maximum channel size.

Then in xsc_set_default_xps_cpumasks (around line 155), the loop iterates u=
p to this uncapped limit when calling netif_set_xps_queue.

If the hardware supports more completion vectors than allocated TX queues, =
could this trigger an out-of-bounds array write in the network core?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c at xsc_event_work (aro=
und line 309), the link_event_handler function pointer is checked and then =
called.

Concurrently, xsc_irq_event_unregister (around line 358) assigns NULL to th=
e handler before flushing the workqueue.

Since READ_ONCE is not used, is it possible for the compiler to emit multip=
le memory loads, allowing the function pointer to become NULL between the c=
heck and the call, leading to a panic?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c, xsc_eth_link_event_handl=
er (around line 138) performs a lockless read of adapter->opened.

Because this races with both ndo_open and ndo_stop, is there a risk that va=
lid link UP events are dropped during open, or stale carrier ON events are =
applied after close, leading to a complete desync of the carrier state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D6
