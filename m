Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BD831F9BB
	for <linux-rdma@vger.kernel.org>; Sun, 10 May 2026 20:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778445232; cv=none; b=nnlxxRYxYHxEK4PAx0eULsGWF9WBtkqdQarQh/cXHJWiActmW71Oc1N0kBiecxcjYPfgNdRKSv95WbUq4MZWvzLvnKA2KOgJ3aJwk1s6WxqXh1u1YqLGNUuyMyu+iVlkNlnwWwTJGXLogFSYWbIBaBRiYlS0OCwKrib059uVUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778445232; c=relaxed/simple;
	bh=2wUKSUSHE9scw9qUgXRw9l/unI/4n7ehob9Z2USC7nM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ectqCW2UOSe64V2a1fAXxZ8gdXQ2IqRs/Wm30yIcxk8Hbg5Yx+F7XXG3aZWPLYjJsqOdRm+n3pCzBTKQWXRRaop7rk9THl8avgYe9l/5+fkMV6q5RUgGxaSkYX0iedKeBiwqlkiWgG1frc+cBZQ6lOt91cUPIFqem8iKhUuDLnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ncJkTBM8; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ncJkTBM8"
Message-ID: <d7de2f17-af2d-4b6a-be65-f009d78e3d20@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778445218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfKcMPHY9ZAK6g9Oz7/PqAZZMUwyLIAqYyCYd/6iX70=;
	b=ncJkTBM8dnCNpZlfbou7tRQnvzbA5UHpRuL6tjhpE8qRJElAZt+w4X/jfwsa+TPwXOg7d3
	k6ZFIC1gZ36v/S33lAXeBRU9+khsKtxurPyC3l46D4P+ppuriVat8xTa0i2qwxUqTlzujK
	I/2d/vw9sboE6jITMTS+qCOnfoXsNl4=
Date: Sun, 10 May 2026 13:33:18 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net-next v3 0/8] net: devmem: support devmem with netkit
 devices
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>,
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Alexander Duyck <alexanderduyck@fb.com>, kernel-team@meta.com,
 Daniel Borkmann <daniel@iogearbox.net>,
 Nikolay Aleksandrov <razor@blackwall.org>, Shuah Khan <shuah@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: dw@davidwei.uk, sdf.kernel@gmail.com, mohsin.bashr@gmail.com,
 willemb@google.com, jiang.kun2@zte.com.cn, xu.xin16@zte.com.cn,
 wang.yaxin@zte.com.cn, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Stanislav Fomichev <sdf@fomichev.me>, Mina Almasry <almasrymina@google.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>
References: <20260507-tcp-dm-netkit-v3-0-52821445867c@meta.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260507-tcp-dm-netkit-v3-0-52821445867c@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/5/7 19:27, Bobby Eshleman 写道:
> This series enables TCP devmem TX through netkit devices.
> 
> Netkit now supports queue leasing. A physical NIC's RX queue can be
> leased to a netkit guest interface inside a container namespace. This
> gives the container a devmem-capable data path on the RX side (bind-rx,
> etc...). On the TX side, the container process binds to its netkit guest
> interface and sends traffic that netkit redirects (via BPF or ip
> forwarding) to the physical NIC for DMA.
> 
> Two things in the existing devmem TX path prevent this from working:
> 
> 1. validate_xmit_unreadable_skb() requires dev->netmem_tx before it will
>     forward a dmabuf-backed (unreadable) skb. This protects skbs from
>     landing on devices that don't have the IOMMU mappings for the backing
>     dmabuf or that don't speak netmem. Netkit, however, does not support
>     DMA, doesn't attempt to read unreadable skb pages and so doesn't
>     break netmem (it is pure skb routing and redirection). It is
>     functionally capable of routing unreadable skbs, but there is no way
>     for the TX validation pathway to distinguish between a device that
>     will actually attempt DMA-ing the skb and another device
>     (like netkit) that does not DMA but also does not break
>     netmem.
> 
> 2. bind_tx_doit uses the bound device as the DMA device.  When the user
>     binds devmem TX to the netkit guest, the bind handler attempts to
>     create DMA mappings against netkit, which has no DMA capability and
>     no IOMMU mappings.
> 
> This series solves these problems as follows:
> 
> 1. Extend netmem_tx to two bits, assigned to one of three values:
> 
>     NETMEM_TX_NONE   - netmem not supported
>     NETMEM_TX_DMA    - netmem supported and performs DMA
>     NETMEM_TX_NO_DMA - netmem supported, but does not DMA
> 
>     With these bits, phys devices can set NETMEM_TX_DMA and devices like
>     netkit set NETMEM_TX_NO_DMA. The validation TX path ensures that any
>     DMA-capable netdev exactly matches the bound device, guaranteeing the
>     correct mapping of the bound dmabuf. The validation TX path also
>     allows devices with NETMEM_TX_NO_DMA to pass, knowing these devices
>     will not misuse netmem or run into IOMMU faults. After redirection or
>     routing and the skb finally makes its way through the stack to a
>     physical device's TX path, the above NETMEM_TX_DMA check is performed
>     again to guarantee the device has the appropriate binding/mappings.
> 
> 2. On TX bind, the bind handler recognizes NETMEM_TX_NO_DMA devices and
>     finds the phys TX device and binds to that instead. For the netkit
>     case, if it has been leased a queue from a DMA-capable device
>     already, then the bind action is performed on the DMA-capable device
>     instead and the dmabuf is mapped correctly.
> 
> ---
> Changes in v3:
> - Fix validate_xmit_unreadable_skb() logic for non-devmem
>    unreadable niovs (should not be dropped) (Sashiko)
> - Simplify lock handling in bind_tx, no premature release (Jakub)
> - split NO_DMA changes into separate patch (Jakub)
> - fixed some pylint issues, one required an additional patch ("selftests:
>    drv-net: make attr _nk_guest_ifname public") to rename a variable from
>    private to public
> - see per-patch changelist for more detailed changes
> - Link to v2: https://lore.kernel.org/r/20260504-tcp-dm-netkit-v2-0-56d52ac72fd4@meta.com
> 
> Changes in v2:
> - Squash driver conversion patches (2-5) into patch 1 (Jakub)
> - In validate_xmit_unreadable_skb() to check netmem_tx mode before inspecting
>    frags (Jakub)
> - Lock bind_dev around netdev_queue_get_dma_dev() when bind_dev != netdev to
>    fix lockdep (Sashiko)
> - Move require_devmem() into individual test functions so KsftSkipEx goes up to
>    ksft_run() (Sashiko)
> - Add nk_devmem.py to TEST_PROGS in Makefile (Sashiko)
> - Link to v1:
>    https://lore.kernel.org/all/20260428-tcp-dm-netkit-v1-0-719280eba4d2@meta.com/
> 
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> ---
> Bobby Eshleman (8):
>        net: convert netmem_tx flag to enum
>        net: netkit: declare NETMEM_TX_NO_DMA mode
>        net: devmem: support TX over NETMEM_TX_NO_DMA devices

I applied this patchset in my local kernel tree and built a new kernel 
image. I loaded this new kernel image in my test environment. It seems 
that all the testcases can pass.

I think that this patchset would not cause any regression problem in my 
test environment.

Zhu Yanjun

>        selftests: drv-net: ncdevmem: add -n flag to skip NIC configuration
>        selftests: drv-net: make attr _nk_guest_ifname public
>        selftests: drv-net: refactor devmem command builders into lib module
>        selftests: drv-net: add primary_rx_redirect support to NetDrvContEnv
>        selftests: drv-net: add netkit devmem tests
> 
>   .../networking/net_cachelines/net_device.rst       |   2 +-
>   Documentation/networking/netmem.rst                |   8 +-
>   .../translations/zh_CN/networking/netmem.rst       |   7 +-
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
>   drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
>   drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   2 +-
>   drivers/net/netkit.c                               |   1 +
>   include/linux/netdevice.h                          |  11 +-
>   net/core/dev.c                                     |   5 +-
>   net/core/devmem.c                                  |   6 +-
>   net/core/devmem.h                                  |   9 +-
>   net/core/netdev-genl.c                             |  65 +++++-
>   tools/testing/selftests/drivers/net/hw/Makefile    |   1 +
>   tools/testing/selftests/drivers/net/hw/devmem.py   |  77 ++------
>   .../selftests/drivers/net/hw/lib/py/devmem.py      | 218 +++++++++++++++++++++
>   tools/testing/selftests/drivers/net/hw/ncdevmem.c  |  58 +++---
>   .../testing/selftests/drivers/net/hw/nk_devmem.py  |  55 ++++++
>   .../drivers/net/hw/nk_primary_rx_redirect.bpf.c    |  39 ++++
>   .../testing/selftests/drivers/net/hw/nk_qlease.py  |   8 +-
>   tools/testing/selftests/drivers/net/lib/py/env.py  | 109 ++++++++---
>   21 files changed, 549 insertions(+), 138 deletions(-)
> ---
> base-commit: 790ead9394860e7d70c5e0e50a35b243e909a618
> change-id: 20260423-tcp-dm-netkit-2bd78b638d30
> 
> Best regards,

