Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204041;
	b=Fe/womsOYgs2GoX6qIQI1vaBeBjgn/p2mtGOP1326PeDGaXCwr0cFc4bQsKwaTzzNw5z
	 /IrjIwl8OsKiRZwcpS4lSmDg3FdA3wSLr/b2XeNL8/m56RkXy0SWWj6feYtDa2fy8A3a5
	 2rv0Z/eQvPcjWd14nXGxWWo3CE45w8exLNU+y7zePKZ3I8BALV2AXfSAeWFQMs8sgHANQ
	 2/rhTkAQXONiMUh2aD1//lBVJM1CAdilpL8+j/0shj28re8K8fWFKcB/GtoqXOC8yILuz
	 nYBfS1owv9ugG/dw/ZvHy2gxdXFGcLcc82lQHj9djjuBei2aBVgOQbdNffxDkdf2MsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204041;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u7aSiRAyqUJJCYptUrQffwehB1VQ0X01AiRX22xwuyM=;
	b=jpp1tGlpR6/d4lcDKP22/UaaEy+kT7w9I+kTFdT8i6NJWzHem0iy6B9tMuYMn6W4zNv/
	 D1KIP8eitMikqYufNBPVc4NbHIvy2mEhegA7h1jNK5QsAjxUFgTPfAQOdJ2U3oue1p/vO
	 ULiZjtN4OOkWQMIpeTf7v5JWb4gSFZO7f3yEwO2qzh/NHCKF/PRfdnxwiMnBehH6veETS
	 Y7MJtW9dl6uM6OXj93bgKCT2lW8y0W+9sjTqHWIOKb189UcchZHodsvlWAtOUUx5sS/mE
	 4HekgpBR4JxoUXYADnL4/+fC6DU/kHaqpth0TyfPaGivVW9McO0zuMtdKdg3H5pN1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhCpmFyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A115606A321;
	Mon,  9 Nov 2026 06:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhCpmFyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABB31F008A1;
	Mon,  9 Nov 2026 06:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204041;
	bh=u7aSiRAyqUJJCYptUrQffwehB1VQ0X01AiRX22xwuyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mhCpmFyH7SOmyvOcs7GgLvFo4llqJQLn3JD9Ni+eLlL44nVNxcNUeVegJZSzxSMdc
	 4fJ85yE8c0ifBT0lCGnrINGc9IH004uFZD8R+b6P41elU0YmVXjixx42sa+uupOW5M
	 t+DPMvcBgCziGhkh+DZuIoOOYMOLMaRbgFrBWnYpL64er4kcD3H71VgIaMyFEIbsWW
	 7vjbN496UkeAwpsdLUdqap0gmN2SIES3Plx7MWAv3GZQm9V4/nH/Gg4fWSNVombPOQ
	 WGcmvMqaVR+eRUutu7SCemogVHTSWAObX2YQSSs55qVnnpCNvnODqGljh3ZINFQgOv
	 Pm6DPq60Ltkhw==
Message-ID: <sashiko-outbox-204470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/5] net: skbuff: skip managed zerocopy
 frags in skb_frag_ref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>, "Neal Cardwell" <ncardwell@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Pavel Begunkov" <asml.silence@gmail.com>, "Bobby
 Eshleman" <bobbyeshleman@meta.com>, "Stanislav Fomichev" <sdf@fomichev.me>, "Steffen
 Klassert" <steffen.klassert@secunet.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Willem
 de Bruijn" <willemb@google.com>, "John Fastabend" <john.fastabend@gmail.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>, "Andrew Lunn" <andrew+netdev@lunn.ch>, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jason Wang" <jasowangio@gmail.com>,
 =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Johannes
 Berg" <johannes@sipsolutions.net>, "Byungchul Park" <byungchul@sk.com>, "Zi
 Yan" <ziy@nvidia.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Lorenzo Bianconi" <lorenzo@kernel.org>, "Wen
 Gu" <guwen@linux.alibaba.com>, "Philo Lu" <lulie@linux.alibaba.com>, "Justin
 Chen" <justin.chen@broadcom.com>, "Florian Fainelli" <florian.fainelli@broadcom.com>, "Vikas
 Gupta" <vikas.gupta@broadcom.com>, "Michael Chan" <michael.chan@broadcom.com>, "Pavan
 Chebbi" <pavan.chebbi@broadcom.com>, "Doug Berger" <opendmb@gmail.com>, "Nicolai
 Buchwitz" <nb@tipi-net.de>, "Broadcom internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>, "Satish
 Kharat" <satishkh@cisco.com>, "Wei Fang" <wei.fang@nxp.com>, "Frank Li" <frank.li@nxp.com>, "Shenwei
 Wang" <shenwei.wang@nxp.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Jijie Shao" <shaojijie@huawei.com>, "Jian
 Shen" <shenjian15@huawei.com>, "Fan Gong" <gongfan1@huawei.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, "Przemek Kitszel" <przemyslaw.kitszel@intel.com>, "Marcin
 Wojtas" <marcin.s.wojtas@gmail.com>, "Russell King" <linux@armlinux.org.uk>, "Sunil
 Goutham" <sgoutham@marvell.com>, "Geetha sowjanya" <gakula@marvell.com>, "Ratheesh
 Kannoth" <rkannoth@marvell.com>, "Subbaraya Sundeep" <sbhatta@marvell.com>, "Bharat
 Bhushan" <bbhushan2@marvell.com>, "Felix Fietkau" <nbd@nbd.name>, "Matthias
 Brugger" <matthias.bgg@gmail.com>, "AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>, "Tariq
 Toukan" <tariqt@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>, "Mark
 Bloch" <mbloch@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>, "Ido
 Schimmel" <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>, "Horatiu
 Vultur" <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, "Daniel
 Machon" <daniel.machon@microchip.com>, "Steen Hegelund" <Steen.Hegelund@microchip.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Yibo Dong" <dong100@mucse.com>, "Brett Creeley" <brett.creeley@amd.com>, "Justin
 Lai" <justinlai0215@realtek.com>, "Larry Chiu" <larry.chiu@realtek.com>,
 =?utf-8?b?TmlrbGFzIFPDtmRlcmx1bmQ=?= <niklas.soderlund@ragnatech.se>, "Paul
 Barker" <paul@pbarker.dev>, "Masahisa Kojima" <kojima.masahisa@socionext.com>, "Maxime
 Chevallier" <maxime.chevallier@bootlin.com>, "Maxime Coquelin" <mcoquelin.stm32@gmail.com>, "Alexandre
 Torgue" <alexandre.torgue@foss.st.com>, "FUJITA Tomonori" <fujita.tomonori@gmail.com>, "Siddharth
 Vadapalli" <s-vadapalli@ti.com>, "Roger Quadros" <rogerq@kernel.org>, "MD
 Danish Anwar" <danishanwar@ti.com>, "Jiawen Wu" <jiawenwu@trustnetic.com>, "Mengyuan
 Lou" <mengyuanlou@net-swift.com>, "Ronak Doshi" <ronak.doshi@broadcom.com>, "Ryder
 Lee" <ryder.lee@mediatek.com>, "Shayne Chen" <shayne.chen@mediatek.com>, "Sean
 Wang" <sean.wang@mediatek.com>, "Juergen Gross" <jgross@suse.com>, "Stefano
 Stabellini" <sstabellini@kernel.org>, "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>, "Jordan
 Rhee" <jordanrhee@google.com>, "Ankit Garg" <nktgrg@google.com>, "Tim
 Hostetler" <thostet@google.com>, "Eric Joyner" <eric.joyner@amd.com>, "Prabu
 Thayalan" <prabu.ponrajthayalan@amd.com>, "Nikhil P. Rao" <nikhil.rao@amd.com>, "Chintan
 Vankar" <c-vankar@ti.com>, "Nora Schiffer" <nora.schiffer@ew.tq-group.com>, "Alexander
 Sverdlin" <alex@sverdlin.org>, "Kevin Hao" <haokexin@gmail.com>, "Karl
 Mehltretter" <kmehltretter@gmail.com>, "Aleksandr Loktionov" <aleksandr.loktionov@intel.com>, "Meghana
 Malladi" <m-malladi@ti.com>, "Jacob Keller" <jacob.e.keller@intel.com>, "StanleyYP
 Wang" <StanleyYP.Wang@mediatek.com>, imx@lists.linux.dev, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, Frank.Li@kernel.org, wsa+renesas@sang-engineering.com
In-Reply-To: <20261108060016.2131509-2-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
 <20261108060016.2131509-2-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 06:00:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net: skbuff: missing Fixes trailers for skb_frag_ref() and iptfs
  fixes
--

commit 289785b15a220a700e7ce94d6b9993ab94b82d49
Author: Mina Almasry <almasrymina@google.com>

> net: skbuff: skip managed zerocopy frags in skb_frag_ref()
>
> skb_frag_unref() and skb_release_data() skip releasing references on
> managed zerocopy fragments (SKBFL_MANAGED_FRAG_REFS), whereas
> skb_frag_ref() acquires a reference unconditionally. If skb_frag_ref()
> is called on a managed zerocopy SKB, the acquired reference is never
> released by skb_frag_unref() or skb_release_data().
>
> Skip acquiring a reference in skb_frag_ref() when skb_zcopy_managed(skb)
> is true so skb_frag_ref() matches skb_frag_unref() and
> skb_release_data(), and disable share_ok in iptfs_output_queued() when
> skb_zcopy_managed(skb) is true so iptfs_consume_frags() does not append
> unreferenced fragments into a managed zerocopy outer SKB.
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>

[Severity: Low]
Since this fixes fragment reference accounting for SKBFL_MANAGED_FRAG_REFS =
in
skb_frag_ref() and fragment sharing in iptfs_output_queued(), should the
commit message include:

  Fixes: 753f1ca4e1e5 ("net: introduce managed frags infrastructure")
  Fixes: b96ba312e21c ("xfrm: iptfs: share page fragments of inner packets")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108060016.2131=
509-1-almasrymina@google.com?part=3D1
