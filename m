Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826893;
	b=DQfbRCZUZrH6O07xzavOh8CCOSk7fuuvQ7Nf4OKKzSzJE5XOFISoDzjDgCWV+KJzs8vG
	 n8GV1LwFpgXx/8iatVvQc6m3y8jpSZfBnkVFGznzc9cUUGtMoYiy1UtIfdh7tY5ApSLnd
	 Qyrkls/cxsyKdEgb735klE3aDHEEJFtkpON3+GbLsyidZuvQpIr5zQFzTixCnAEnfM+zF
	 UL920RAg3enGdTkucRAQMHCw+cmXrqVtIS5J1VxzCzzCvy/Y7wkIpAlL4hiw84JdJN60u
	 tBkdTh4SWNSGyx3OFlPsuuCVstYI9PFJdstO5X7mQwpuXmg5U0aqmH+bljO9+BhWaNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826893;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wMYCt5EP/sNWDxIUvBX8we5zMZEdPqHevTqaZp/nA6U=;
	b=xp+v4EEeR8hD9Xrg+1ZHQkD77rLzpgr7O/IWs6G21q0wSPyq320Fjwp4lJUz6QdyOmYG
	 iqzQ21ShwKq5ZM91i/5HNp7DDYKFTWiyDvmX9eg27Q11ft0Sy1xEQxgY0QXgAFEqS0o3O
	 YTJ0C6cyUoKH8rj1LqOE1vWPca8nOwbHyAgFzbMP7CGBilPbPeOG7v5iEBVh4xjwiB372
	 QX0AO0rUo71xRR5RCKGbVfjip3QRyFce7auBtMrd9IBva07FnFXFYiCX3h+1A4UI7AfAH
	 yWAl1BIdtB2n0qhPcsSd5lcaXCPqveoxgYOGo6VsAdkTviR7DeNkVJGI1PNliWKl2iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EupUpYNb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BF2607075B;
	Wed,  4 Nov 2026 21:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EupUpYNb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46161F0093A;
	Wed,  4 Nov 2026 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826892;
	bh=wMYCt5EP/sNWDxIUvBX8we5zMZEdPqHevTqaZp/nA6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EupUpYNbxsz7bxH1Xzhu1FdX+NjLRR6kk4e4PfJE7IMhtjK7/HWHEMKGK108XFPhS
	 mBwSFyjkd183mb6RqzkERIBKWvlcjGSx0uKON9JOdu0eq4hUKnCXRz669Laqlw4yVd
	 W7nSUjz3LeWEHdPY5DLD4UanqsN3qrhBUv32Fp1qwlEKJXjg59aq/U94RtHRFKTg7D
	 imBGe3ru67Ls+x0axIKynDMFis1BtlyEqG0fRMtPLDtffXBT4cUsviW7QYExBRkbOy
	 s5kkuE5RxZcZs+9vddUbBdS88QI7/R2ST4LsqyQjyK1XhBYoWoOIHd6qVdMfevYpSM
	 CIQJcp9jsMIZA==
Message-ID: <sashiko-outbox-198071@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 2/5] net: skbuff: refcount spliced page_pool
 frags via skb_pipe_buf_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>, "Steffen Klassert" <steffen.klassert@secunet.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Willem de Bruijn" <willemb@google.com>, "Stanislav
 Fomichev" <sdf@fomichev.me>, "Pavel Begunkov" <asml.silence@gmail.com>, "Bobby
 Eshleman" <bobbyeshleman@meta.com>, "Andrew Lunn" <andrew+netdev@lunn.ch>, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jason Wang" <jasowangio@gmail.com>,
 =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "John
 Fastabend" <john.fastabend@gmail.com>, "Sabrina Dubroca" <sd@queasysnail.net>, "Johannes
 Berg" <johannes@sipsolutions.net>, "Byungchul Park" <byungchul@sk.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Lorenzo Bianconi" <lorenzo@kernel.org>, "Wen
 Gu" <guwen@linux.alibaba.com>, "Philo Lu" <lulie@linux.alibaba.com>, "Justin
 Chen" <justin.chen@broadcom.com>, "Florian Fainelli" <florian.fainelli@broadcom.com>, "Vikas
 Gupta" <vikas.gupta@broadcom.com>, "Michael Chan" <michael.chan@broadcom.com>, "Pavan
 Chebbi" <pavan.chebbi@broadcom.com>, "Doug Berger" <opendmb@gmail.com>, "Nicolai
 Buchwitz" <nb@tipi-net.de>, "Satish Kharat" <satishkh@cisco.com>, "Wei Fang" <wei.fang@nxp.com>, "Frank
 Li" <frank.li@nxp.com>, "Shenwei Wang" <shenwei.wang@nxp.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Jijie
 Shao" <shaojijie@huawei.com>, "Jian Shen" <shenjian15@huawei.com>, "Fan
 Gong" <gongfan1@huawei.com>, "Tony Nguyen" <anthony.l.nguyen@intel.com>, "Przemek
 Kitszel" <przemyslaw.kitszel@intel.com>, "Marcin Wojtas" <marcin.s.wojtas@gmail.com>, "Russell
 King" <linux@armlinux.org.uk>, "Sunil Goutham" <sgoutham@marvell.com>, "Geetha
 sowjanya" <gakula@marvell.com>, "Ratheesh Kannoth" <rkannoth@marvell.com>, "Subbaraya
 Sundeep" <sbhatta@marvell.com>, "Bharat Bhushan" <bbhushan2@marvell.com>, "Felix
 Fietkau" <nbd@nbd.name>, "Matthias Brugger" <matthias.bgg@gmail.com>, "AngeloGioacchino
 Del Regno" <angelogioacchino.delregno@collabora.com>, "Tariq Toukan" <tariqt@nvidia.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Mark Bloch" <mbloch@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Ido Schimmel" <idosch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Horatiu Vultur" <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, "Daniel
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
 Hostetler" <thostet@google.com>, "Erni Sri Satya Vennela" <ernis@linux.microsoft.com>, "Eric
 Joyner" <eric.joyner@amd.com>, "Mohammad Heib" <mheib@redhat.com>, "Prabu
 Thayalan" <prabu.ponrajthayalan@amd.com>, "Chintan Vankar" <c-vankar@ti.com>, "Nora
 Schiffer" <nora.schiffer@ew.tq-group.com>, "Alexander Sverdlin" <alex@sverdlin.org>, "Kevin
 Hao" <haokexin@gmail.com>, "Karl Mehltretter" <kmehltretter@gmail.com>, "Aleksandr
 Loktionov" <aleksandr.loktionov@intel.com>, "Meghana Malladi" <m-malladi@ti.com>, "Jacob
 Keller" <jacob.e.keller@intel.com>, "StanleyYP Wang" <StanleyYP.Wang@mediatek.com>, Frank.Li@kernel.org, wsa+renesas@sang-engineering.com
In-Reply-To: <20261103211424.127627-3-almasrymina@google.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-3-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:14:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: skbuff: missing refcount overflow check in skb_pipe_buf_get()
--

commit 9c79ad1ae20fce07ba4bd771a989ba25467dc207
Author: Mina Almasry <almasrymina@google.com>

net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops

This commit updates skb_splice_bits() and skb_append_pagefrags() to acquire
and release fragment references via netmem_inc_ref(), netmem_dec_ref(), and
skb_frag_ref() using a new skb_pipe_buf_ops table.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 48f6764117243..32a9dcdf2cb22 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3114,9 +3114,27 @@ EXPORT_SYMBOL(skb_copy_bits);
>   */
>  static void sock_spd_release(struct splice_pipe_desc *spd, unsigned int =
i)
>  {
> -	put_page(spd->pages[i]);
> +	netmem_dec_ref(page_to_netmem(spd->pages[i]));
>  }
> =20
> +static void skb_pipe_buf_release(struct pipe_inode_info *pipe,
> +				 struct pipe_buffer *buf)
> +{
> +	netmem_dec_ref(page_to_netmem(buf->page));
> +}
> +
> +static bool skb_pipe_buf_get(struct pipe_inode_info *pipe,
> +			     struct pipe_buffer *buf)
> +{
> +	netmem_inc_ref(page_to_netmem(buf->page));
> +	return true;
> +}

[Severity: High]
Does replacing nosteal_pipe_buf_ops with skb_pipe_buf_ops in skb_splice_bit=
s()
drop the page reference count overflow check when pipe buffers are duplicat=
ed?

Previously, nosteal_pipe_buf_ops used generic_pipe_buf_get(), which calls
try_get_page() and fails when the signed 32-bit page reference count is <=
=3D 0:

fs/pipe.c:generic_pipe_buf_get() {
	return try_get_page(buf->page);
}

include/linux/mm.h:try_get_page() {
	page =3D compound_head(page);
	if (WARN_ON_ONCE(page_ref_count(page) <=3D 0))
		return false;
	page_ref_inc(page);
	return true;
}

With skb_pipe_buf_get(), duplicating a spliced pipe buffer via tee() ->
link_pipe(), splice() -> splice_pipe_to_pipe(), or fuse_dev_splice_write()
invokes skb_pipe_buf_get() -> netmem_inc_ref() -> get_page() and
unconditionally returns true:

include/net/netmem.h:netmem_inc_ref() {
	if (netmem_is_net_iov(netmem))
		net_iov_inc_ref(netmem_to_net_iov(netmem));
	else
		get_page(netmem_to_page(netmem));
}

For any struct page-backed netmem using standard page refcounting (such as
sk_page_frag() pages from linear_to_page(), non-page_pool RX fragments, user
pages sent over a local socket, or page_pool pages whose pp_ref_count is 0,=
 as
well as all struct pages at this commit prior to commit "net: remove
skb->pp_recycle and consolidate netmem refcounting"), can repeated pipe buf=
fer
duplications push the page reference count past INT_MAX, triggering
VM_BUG_ON_FOLIO(folio_ref_zero_or_close_to_overflow(folio), folio) under
CONFIG_DEBUG_VM or wrapping _refcount to 0 and causing a use-after-free when
CONFIG_DEBUG_VM is disabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211424.1276=
27-1-almasrymina@google.com?part=3D2
