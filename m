Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794359611;
	b=Csb11CpuTncsW+6K+pba9pE+S7MSa5S+UOE8VbNkfwWscgZtp1nTNZxE2Ny3dTXG3vnP
	 W+Jo0Hpsp59cPisxecOKfVcL/nvjZ0TsoqAN9tEnCtbNIYzBsyqHNC9kWbxIcrnDp2E1s
	 7Sz3/qViVGAjMEzGxRS2pGdUYxt7qOPLgUNFWs7uSFZFbwOJsx3f3Ca1kymKZXJilg+9r
	 bn2xZNETo5FPcM2abavCmLq5luTCr+k28Afj6GMIQtOHJt2Dpm0ucTbUuCwfGjn/7H94V
	 w7VC9upkGTZh1mHTNaPdjOApmvfqV2iWAoTjZDFL0uXqppzEC5Cp8vSJzaDWCFZLUbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794359611;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eAy59HGc3h2qnYXka7qm4BQesIQWi6V+JejjBFhpSZ0=;
	b=hpjpBqNkbIrZ9oPlwjxeykpnKVPfiQErtoqXGrJ0bikaV9xlN5WTriYJrPw+fm+fKXH7
	 tV8/3NvMLTDuDu/fL9Pw6F/YXkI3KDY+wvW/2Gsd0lC6kOmOMDqVgFK2SD67DxvUIVikN
	 Az608cxzkb3rsCADdgLS9dvanR2TY6zyb31OtKHLKjQ7wYT/gquC7xFe9oU90adiaO44u
	 4Li9P6eVCC3tBBglOuhX4etCidTtM0i5YYad9ZRhst2DQeOgdC7mDaAL0/Pbn9TuF29CC
	 5+ZmXvZcTasisfucq+FEXktctTEBhWbEp4DZ+mIITMSqkUzFHldbeva5CPepp+0DCeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lu0OyRGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300E3606A320;
	Wed, 11 Nov 2026 01:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lu0OyRGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67E91F0093C;
	Wed, 11 Nov 2026 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794359610;
	bh=eAy59HGc3h2qnYXka7qm4BQesIQWi6V+JejjBFhpSZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lu0OyRGMAhxtwJ5taq70H4M5SCJMSqmxnPH4g9e6YGcbalyFKJoxQ6E48p7YVBvlt
	 Suhmur7cZafjMQWQiUd5XKI9Kij9EFIkpRUZhhse9BYGvYGoKV79KN+ux9rV85zAAe
	 3AXoKuvvUDma5q0/78UDxhILHSqouMX30ryLqWpK3q7MPpHgJud2NaTBJ8MzWiaC75
	 7DzWoajuEqcuGckVyvDN1BsF/G9IO3t7OsMQOYqRooBBeE7yvFOxRn56GmNfcnhOlp
	 sks4I+nisHShcV4eUvAEoSNFTVe5ZFqeclp7qDLeFG9IEgoTwIRl62XdSRqFLZ3V/H
	 iul7mj2cMEmVw==
Date: Tue, 10 Nov 2026 17:13:25 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Neal Cardwell
 <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, Steffen
 Klassert <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Willem de Bruijn <willemb@google.com>, John
 Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, "Eugenio =?UTF-8?B?UMOpcmV6?="
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Johannes Berg <johannes@sipsolutions.net>, Byungchul Park
 <byungchul@sk.com>, Zi Yan <ziy@nvidia.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-wireless@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>,
 Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta
 <vikas.gupta@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>,
 Nicolai Buchwitz <nb@tipi-net.de>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Satish Kharat
 <satishkh@cisco.com>, Wei Fang <wei.fang@nxp.com>, Frank Li
 <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, Jijie
 Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, Fan Gong
 <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek
 Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas
 <marcin.s.wojtas@gmail.com>, Russell King <linux@armlinux.org.uk>, Sunil
 Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>,
 Ratheesh Kannoth <rkannoth@marvell.com>, Subbaraya Sundeep
 <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, Felix
 Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq
 Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Ido Schimmel
 <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, Horatiu Vultur
 <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, Daniel Machon
 <daniel.machon@microchip.com>, Steen Hegelund
 <Steen.Hegelund@microchip.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei
 Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Yibo Dong
 <dong100@mucse.com>, Brett Creeley <brett.creeley@amd.com>, Justin Lai
 <justinlai0215@realtek.com>, Larry Chiu <larry.chiu@realtek.com>, "Niklas
 =?UTF-8?B?U8O2ZGVybHVuZA==?=" <niklas.soderlund@ragnatech.se>, Paul Barker
 <paul@pbarker.dev>, Masahisa Kojima <kojima.masahisa@socionext.com>, Maxime
 Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Siddharth Vadapalli <s-vadapalli@ti.com>,
 Roger Quadros <rogerq@kernel.org>, MD Danish Anwar <danishanwar@ti.com>,
 Jiawen Wu <jiawenwu@trustnetic.com>, Mengyuan Lou
 <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, Ryder
 Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean
 Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, Stefano
 Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, Ankit
 Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, Eric Joyner
 <eric.joyner@amd.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>,
 "Nikhil P. Rao" <nikhil.rao@amd.com>, Chintan Vankar <c-vankar@ti.com>,
 Nora Schiffer <nora.schiffer@ew.tq-group.com>, Alexander Sverdlin
 <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, Karl Mehltretter
 <kmehltretter@gmail.com>, Aleksandr Loktionov
 <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, Jacob
 Keller <jacob.e.keller@intel.com>, StanleyYP Wang
 <StanleyYP.Wang@mediatek.com>, linux-doc@vger.kernel.org,
 imx@lists.linux.dev, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] net: deprecate skb->pp_recycle and
 skb_mark_for_recycle()
Message-ID: <20261110171325.49624e2e@kernel.org>
In-Reply-To: <20261108060016.2131509-1-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun,  8 Nov 2026 06:00:11 +0000 Mina Almasry wrote:
> Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
> helper, and reference-count netmems directly by their underlying type
> via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().

Series does not apply. I think there's too many fixes in this area
in flight to be entertaining this sort of cleanups right now.
-- 
pw-bot: reject
