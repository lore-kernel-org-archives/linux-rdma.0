Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793896560;
	b=3MxJePvqET/rKF8sWWlCZX9rmV+WdUC1Ei6/fJ7fpu1ckNpGUgTqJf1P/ojunVFIfnp+
	 XzGoDYCD1B0aqqN633mfkTYCkBPZcpbkfyXIDpEEJur61lQIxSy5u17Yx9aT8rrjIxK20
	 PW9KMraFP9xlKN/GlTy7sRSJPIEOjxRg6H6E5NV8wmwcT/byD9GfLGYrzTTjOdIutvx94
	 e3KXXN+rTe81gj/25AcZQY9Ttmlm9aXWC57oKIc9E7W3xXX1pJ9+8LNU5Q33STQHGfikn
	 SFkw5iQ3A95NncLJniYBtw1zewO5lLc+k3ag776pfRCx1rBkbk9GQJha8r3FWtZglrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793896560;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=oaFEybmB3/LpRlTwU2ESXZoM0QOYsoH22CakPe6LiW0=;
	b=WKUB0QkMDAn4Vx0wTnBZ7LmLyjIx4d4hxvqXsqBN8XLGM4b2Jld6Vsm6aIMWjYbJicMj
	 JAu+fOlyxtr0fjWKmqdqJ8Liut5/DRaZ9nUMASWNenp8OV+CNBzSAyTJd5ObFDizc8PvI
	 9VxYJehL+tuYpptGJwBatIC6vXTZSZZ4aJZ0u7gZ3f7WkoCU5dnjLGnmoh3bVAx7ONEAa
	 2Q6O3+ILeX3aN+4QXNESuBl0J0op9azPpNDxLi8p9vODc52vRlO0rqmG6RRCQyzO2CvIN
	 eMqbwT3T1XMjZQ6om2s//oqrnrB2N1Oru+yc9zth1iR9J+llMoq3oGyVJ2ADuOrSupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PpT8/D5z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52B606A33F;
	Thu,  5 Nov 2026 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PpT8/D5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A1A1F000C1;
	Thu,  5 Nov 2026 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793896559;
	bh=oaFEybmB3/LpRlTwU2ESXZoM0QOYsoH22CakPe6LiW0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PpT8/D5zeLlfhjXRHDS9Xn7yTDCLEhyyWpMkM0/IfblI9PMLXcKedSOlnoASybHch
	 QMV8ab3TA2uSLtQsY231ygXHLK4E1dZjZWYTUyaq5EG+U+7SRxv/SC5EV5zIEGfbl+
	 Anl6FvxIWk2bzbUyorgGwbK7QtWE0eneo9Vkb0oEtRPqNHIcsTwj/H9gaUxgdyQRKl
	 9la8Ee4KQAzAUk3BDbj8WwQQ1UKgW36gLtWALpg8W7Mm455sUJQJK7b75HwOTlAxFH
	 tWWXsXG7Et2NnPPdGnHQoyRFRfRXjPc/WvDrWcLkNmwuDZMfzvcAqJShtCN7KTNjC+
	 ltbn1tD2mVL7w==
Message-ID: <cf2e3292-d591-42a4-bf6e-76f4567604c6@kernel.org>
Date: Thu, 5 Nov 2026 17:35:34 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v1 0/5] net: deprecate skb->pp_recycle and
 skb_mark_for_recycle()
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-doc@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 imx@lists.linux.dev, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-omap@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Willem de Bruijn <willemb@google.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Sabrina Dubroca <sd@queasysnail.net>,
 Johannes Berg <johannes@sipsolutions.net>, Byungchul Park
 <byungchul@sk.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>,
 Justin Chen <justin.chen@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Vikas Gupta <vikas.gupta@broadcom.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>,
 Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>,
 Wei Fang <wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>,
 Shenwei Wang <shenwei.wang@nxp.com>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>,
 Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>,
 Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Marcin Wojtas <marcin.s.wojtas@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>,
 Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth
 <rkannoth@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
 Bharat Bhushan <bbhushan2@marvell.com>, Felix Fietkau <nbd@nbd.name>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
 Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com,
 Daniel Machon <daniel.machon@microchip.com>,
 Steen Hegelund <Steen.Hegelund@microchip.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>,
 Brett Creeley <brett.creeley@amd.com>, Justin Lai
 <justinlai0215@realtek.com>, Larry Chiu <larry.chiu@realtek.com>,
 =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
 Paul Barker <paul@pbarker.dev>,
 Masahisa Kojima <kojima.masahisa@socionext.com>,
 Maxime Chevallier <maxime.chevallier@bootlin.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 FUJITA Tomonori <fujita.tomonori@gmail.com>,
 Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>,
 MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>,
 Mengyuan Lou <mengyuanlou@net-swift.com>,
 Ronak Doshi <ronak.doshi@broadcom.com>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jordan Rhee <jordanrhee@google.com>, Ankit Garg <nktgrg@google.com>,
 Tim Hostetler <thostet@google.com>,
 Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
 Eric Joyner <eric.joyner@amd.com>, Mohammad Heib <mheib@redhat.com>,
 Prabu Thayalan <prabu.ponrajthayalan@amd.com>,
 Chintan Vankar <c-vankar@ti.com>,
 Nora Schiffer <nora.schiffer@ew.tq-group.com>,
 Alexander Sverdlin <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Meghana Malladi <m-malladi@ti.com>, Jacob Keller <jacob.e.keller@intel.com>,
 StanleyYP Wang <StanleyYP.Wang@mediatek.com>
References: <20261103211424.127627-1-almasrymina@google.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/3/26 22:14, Mina Almasry wrote:
> Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
> helper, and reference-count netmems directly by their underlying type
> via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().
> 
> This series simplifies SKB and netmem reference counting:
> - Reclaims 1 bit from struct sk_buff (skb->pp_recycle).
> - Unifies reference counting of SKB fragment netmems and regular netmems
>    under netmem_inc_ref() and netmem_dec_ref(), eliminating the separate
>    skb_netmem_ref(), skb_netmem_unref(), and skb_mark_for_recycle() APIs.

Part of the performance gain from page_pool was to completely avoid the
atomic refcnt operation, when we can see that page refcnt==1.
Are you removing this?


> - Removes 110 net lines of non-test/doc code across 63 files (196
>    insertions, 306 deletions).
> 
> 1/5: net: skbuff: skip managed zerocopy frags in skb_frag_ref()
> 2/5: net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
> 3/5: net: datagram: refcount page_pool frags in zerocopy_fill_skb_from_iter()
> 4/5: net: remove skb->pp_recycle and consolidate netmem refcounting
> 5/5: net: remove skb_mark_for_recycle()
> 
> Mina Almasry (5):
>    net: skbuff: skip managed zerocopy frags in skb_frag_ref()
>    net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
>    net: datagram: refcount page_pool frags in
>      zerocopy_fill_skb_from_iter()
>    net: remove skb->pp_recycle and consolidate netmem refcounting
>    net: remove skb_mark_for_recycle()
> 
>   Documentation/networking/page_pool.rst        |   1 -
>   drivers/net/ethernet/airoha/airoha_eth.c      |   1 -
>   drivers/net/ethernet/alibaba/eea/eea_rx.c     |   3 -
>   .../net/ethernet/broadcom/asp2/bcmasp_intf.c  |   1 -
>   .../net/ethernet/broadcom/bnge/bnge_txrx.c    |   5 -
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   8 -
>   .../net/ethernet/broadcom/genet/bcmgenet.c    |   2 -
>   drivers/net/ethernet/cisco/enic/enic_rq.c     |   1 -
>   drivers/net/ethernet/engleder/tsnep_main.c    |   2 -
>   drivers/net/ethernet/freescale/fec_main.c     |   1 -
>   drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   9 -
>   .../net/ethernet/hisilicon/hibmcge/hbg_txrx.c |   1 -
>   .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   6 -
>   .../net/ethernet/huawei/hinic3/hinic3_rx.c    |   1 -
>   drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   2 -
>   drivers/net/ethernet/marvell/mvneta.c         |   2 -
>   .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   2 -
>   .../marvell/octeontx2/nic/otx2_txrx.c         |   1 -
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   1 -
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 -
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 -
>   drivers/net/ethernet/mellanox/mlxsw/pci.c     |   2 -
>   .../ethernet/microchip/lan966x/lan966x_fdma.c |   2 -
>   .../microchip/sparx5/lan969x/lan969x_fdma.c   |   1 -
>   drivers/net/ethernet/microsoft/mana/mana_en.c |   3 -
>   .../net/ethernet/mucse/rnpgbe/rnpgbe_lib.c    |   1 -
>   .../net/ethernet/pensando/ionic/ionic_txrx.c  |   2 -
>   .../net/ethernet/realtek/rtase/rtase_main.c   |   1 -
>   drivers/net/ethernet/renesas/ravb_main.c      |   2 -
>   drivers/net/ethernet/socionext/netsec.c       |   1 -
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c |   1 -
>   drivers/net/ethernet/tehuti/tn40.c            |   1 -
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   1 -
>   drivers/net/ethernet/ti/cpsw.c                |   2 -
>   drivers/net/ethernet/ti/cpsw_new.c            |   2 -
>   drivers/net/ethernet/ti/icssg/icssg_common.c  |   1 -
>   drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   2 -
>   drivers/net/veth.c                            |   3 +-
>   drivers/net/virtio_net.c                      |  16 +-
>   drivers/net/vmxnet3/vmxnet3_xdp.c             |   1 -
>   drivers/net/wireless/mediatek/mt76/dma.c      |   1 -
>   .../net/wireless/mediatek/mt76/mt7996/mac.c   |   1 -
>   drivers/net/wireless/mediatek/mt76/npu.c      |   1 -
>   drivers/net/wireless/mediatek/mt76/usb.c      |   1 -
>   drivers/net/xen-netfront.c                    |   1 -
>   include/linux/mm.h                            |   2 +-
>   include/linux/skbuff.h                        |  12 +-
>   include/linux/skbuff_ref.h                    |  60 +--
>   include/net/netmem.h                          |  39 +-
>   include/net/page_pool/helpers.h               |  46 ++-
>   net/core/datagram.c                           |   5 +
>   net/core/gro.c                                |   9 -
>   net/core/net_test.c                           | 369 +++++++++++-------
>   net/core/netmem_priv.h                        |  23 +-
>   net/core/page_pool.c                          |   8 +-
>   net/core/skbuff.c                             |  78 ++--
>   net/core/xdp.c                                |  13 +-
>   net/ipv4/esp4.c                               |  11 +-
>   net/ipv6/esp6.c                               |  11 +-
>   net/tls/tls_device.c                          |  14 +-
>   net/tls/tls_device_fallback.c                 |   6 +-
>   net/tls/tls_main.c                            |   4 +-
>   net/wireless/util.c                           |  31 +-
>   net/xfrm/trace_iptfs.h                        |   6 +-
>   net/xfrm/xfrm_iptfs.c                         |  16 +-
>   65 files changed, 418 insertions(+), 454 deletions(-)
> 
> 
> base-commit: 7b6ab4dbc156e2f96419715130b3d5738a306c93

