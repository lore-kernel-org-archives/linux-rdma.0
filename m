Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826899;
	b=wSUTaaekXXQvczXEh4dAGtfaW15yFOOQfhqttQqauNoPSbTc5MpQYDY8TxosJgkIvb8S
	 d89QK9Yq6Ny/cezHRE55ICQSeGhJTpGKYSu8oJwYssNajoL/UZKR9LXpqja/DRV2+gzmt
	 XrzW3J5kKNEsMGCjfLpjNHurKVffKb+EMGzFKM+/VuhPtQj9gpA4uILMYcoR4knLpQtx9
	 j8/FPTX4+kqGUESgCVfuAtMY32aQAXoZmTi1GG34cT3R8MESnrSOeWB08cASoFDWNepW/
	 Tcsfd1WuGBHQ7+1Bt4Xz6tsyknLiOSJ6ntP3jsu9Wug32t7iLmR1U8v7TB8PbLfEiDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826899;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZSU3GOYdTAyJi2/mATr7CvuZmk6mn8CBculz3Nu+aGM=;
	b=naJQAR3T2jvy92QJXHs1c9Vb9iD1tmdzfKyWcUIwjzg5hpr/toandMBPWHF4lEUHSR97
	 GjQB5BDlz2w2v2zc4rligjHaPJkbjH+jcoLu7ysJjWsR9UIBx38i/4DPmVGD2i9GFOEqJ
	 yDI+1Imwh1Whmp+8DGUG6kgtxV8Mv1PWaJkZpxjgHntaOHQaNvPXQ+T30D8hhVdadPpqK
	 OHi+VbjbZiztqVWwoEmGNzSYwCfM36I3n5+QL/sdJlnQm+9pXrqq/3LAlBhH8lU2L/4Py
	 Y1IwPskuE0gEyRODKmj5Gw80BXnt0gUVzQ58vfhgwi0CLz4PejUOCwasSSq3RoSDw5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4PDKc61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699626070770;
	Wed,  4 Nov 2026 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4PDKc61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F651F00A1B;
	Wed,  4 Nov 2026 21:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826899;
	bh=ZSU3GOYdTAyJi2/mATr7CvuZmk6mn8CBculz3Nu+aGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J4PDKc61N4keOuWERS5aSp2N8PhMwFXfTttZoQJiP/6NFecDNKxntuxYU8KTP2IT7
	 sQ+GOcnfzHxpPduzw8Axquz0pjikWlDPK+6jysaxaPcTRzpniWRwRSDwYgsjVZQiME
	 hp3SeDPadj5e64beejkKHFIYy6SzK8G6J/Ivl+w7Iz9N+JKw69zq/NWwIz+1PKkFj3
	 p2kJqCpbq5WMmk5HtP2egnpm593A8p3vnMr/TAyo/agIT9R93ZTR+grCkgKrUY7n+0
	 n8Gt29lLuVYq4blAgu2BoulYRKgefmxLu/vNeABBXSsxdBqqzdg25OSU2PVbLwjUrf
	 QlZgT2rzKPq2g==
Message-ID: <sashiko-outbox-198073@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 4/5] net: remove skb->pp_recycle and
 consolidate netmem refcounting
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
In-Reply-To: <20261103211424.127627-5-almasrymina@google.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-5-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:14:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] page_pool: TOCTOU race in page_pool_unref_netmem() non-RMW fas=
t path
- [High] tls: page leak between netmem kTLS records and mlx5 tx_sync_info_g=
et()
--

commit 874363fccb05e0d08d430f57bfdafc048dfc73e0
Author: Mina Almasry <almasrymina@google.com>

net: remove skb->pp_recycle and consolidate netmem refcounting

This commit removes the per-SKB pp_recycle bitfield and updates
netmem_inc_ref(), netmem_dec_ref(), and skb_pp_recycle() to check page_pool
membership directly via netmem_is_pp(). It also updates page_pool_unref_net=
mem()
and napi_pp_get_page() to coordinate pp_ref_count with external struct page
references, and converts TLS and wireless fragment refcounting to netmem
helpers.

> diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/help=
ers.h
> index 28635ce9454e8..af3cb65c30416 100644
> --- a/include/net/page_pool/helpers.h
> +++ b/include/net/page_pool/helpers.h
> @@ -242,6 +242,11 @@ page_pool_get_dma_dir(const struct page_pool *pool)
>  	return pool->p.dma_dir;
>  }
> =20
> +static inline long page_pool_ref_count(netmem_ref netmem)
> +{
> +	return atomic_long_read(netmem_get_pp_ref_count_ref(netmem));
> +}
> +
>  static inline void page_pool_fragment_netmem(netmem_ref netmem, long nr)
>  {
>  	atomic_long_set(netmem_get_pp_ref_count_ref(netmem), nr);
> @@ -270,13 +275,22 @@ static inline void page_pool_fragment_page(struct p=
age *page, long nr)
>  	page_pool_fragment_netmem(page_to_netmem(page), nr);
>  }
> =20
> +static inline bool page_pool_netmem_is_exclusively_owned(netmem_ref netm=
em)
> +{
> +	if (netmem_is_net_iov(netmem))
> +		return true;
> +
> +	return page_ref_count(__netmem_to_page(netmem)) =3D=3D 1;
> +}
> +
>  static inline long page_pool_unref_netmem(netmem_ref netmem, long nr)
>  {
>  	atomic_long_t *pp_ref_count =3D netmem_get_pp_ref_count_ref(netmem);
>  	long ret;
> =20
> -	/* If nr =3D=3D pp_ref_count then we have cleared all remaining
> -	 * references to the page:
> +	/* If nr =3D=3D pp_ref_count and the page_pool holds the sole page
> +	 * reference, then we have cleared all remaining references to the
> +	 * page:
>  	 * 1. 'n =3D=3D 1': no need to actually overwrite it.
>  	 * 2. 'n !=3D 1': overwrite it with one, which is the rare case
>  	 *              for pp_ref_count draining.
> @@ -288,8 +302,15 @@ static inline long page_pool_unref_netmem(netmem_ref=
 netmem, long nr)
>  	 * handling by ensuring all pages have partitioned into only 1 piece
>  	 * initially, and only overwrite it when the page is partitioned into
>  	 * more than one piece.
> +	 *
> +	 * If an external page reference exists (page_ref_count > 1), a
> +	 * concurrent napi_pp_get_page() caller holding only a page reference
> +	 * may attempt atomic_long_inc_not_zero(pp_ref_count), so we must
> +	 * perform an atomic RMW subtraction to 0 and leave pp_ref_count at 0
> +	 * while the page is released from the pool.
>  	 */
> -	if (atomic_long_read(pp_ref_count) =3D=3D nr) {
> +	if (atomic_long_read(pp_ref_count) =3D=3D nr &&
> +	    likely(page_pool_netmem_is_exclusively_owned(netmem))) {
>  		/* As we have ensured nr is always one for constant case using
>  		 * the BUILD_BUG_ON(), only need to handle the non-constant case
>  		 * here for pp_ref_count draining, which is a rare case.

[Severity: Critical]
Can the non-RMW fast path in page_pool_unref_netmem() race with a caller
that converts a struct page reference into a pp_ref_count reference, causing
an in-use page to be recycled into the pool?

With netmem_inc_ref() now calling napi_pp_get_page(), callers holding a
struct page reference such as zerocopy_fill_skb_from_iter() convert their
page_ref_count into a pp_ref_count:

net/core/datagram.c:zerocopy_fill_skb_from_iter() {
	...
			skb_fill_page_desc_noacc(skb, frag++, head, start, size);
			netmem_inc_ref(page_to_netmem(head));
			last_head =3D head;
			refs++;
		}
		if (refs)
			page_ref_sub(last_head, refs);
}

Consider a page_pool page with pp_ref_count =3D=3D 1 (held by an SKB being =
freed
on CPU 0) and page_ref_count =3D=3D 2 (1 held by the page_pool, 1 held by G=
UP in
zerocopy_fill_skb_from_iter() on CPU 1):

CPU 0                                   CPU 1
napi_pp_put_page()
  page_pool_put_full_netmem()
    page_pool_unref_netmem(netmem, 1)
      atomic_long_read(pp_ref_count) =3D=3D 1
      (true; pp_ref_count stays 1)
                                        zerocopy_fill_skb_from_iter()
                                          netmem_inc_ref()
                                            napi_pp_get_page()
                                              atomic_long_inc_not_zero(pp_r=
ef_count)
                                              (pp_ref_count: 1 -> 2)
                                          page_ref_sub(last_head, 1)
                                            (page_ref_count: 2 -> 1)
      page_pool_netmem_is_exclusively_owned()
        page_ref_count(page) =3D=3D 1 (true!)
      returns 0 (leaving pp_ref_count =3D=3D 2)
    __page_pool_put_page()
      __page_pool_page_can_be_recycled() (true)
      recycles page into pool while CPU 1's TX SKB still references it!

Similarly, on weakly ordered architectures, because atomic_long_read() and
page_ref_count() are both relaxed loads with no barrier between them, when
pp_ref_count =3D=3D 2 and page_ref_count =3D=3D 1, CPU 0 can speculatively =
load
page_ref_count =3D=3D 1 before CPU 1 maps the page via tcp_zerocopy_receive=
() ->
vm_insert_pages() (page_ref_count: 1 -> 2) and drops its pp_ref_count
(2 -> 1). CPU 0 then reads pp_ref_count =3D=3D 1 and returns 0 with pp_ref_=
count
left at 1 instead of 0 while __page_pool_put_page() ->
page_pool_return_netmem() releases the page from the pool.

[ ... ]

> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 4cdfbb57ecff0..670fdeeeae567 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c

[ ... ]

> @@ -269,7 +271,7 @@ static void tls_append_frag(struct tls_record_info *r=
ecord,
>  		skb_frag_fill_page_desc(frag, pfrag->page, pfrag->offset,
>  					size);
>  		++record->num_frags;
> -		get_page(pfrag->page);
> +		netmem_inc_ref(page_to_netmem(pfrag->page));
>  	}
> =20
>  	pfrag->offset +=3D size;
> @@ -302,7 +304,7 @@ static int tls_push_record(struct sock *sk,
>  		sg_set_page(&offload_ctx->sg_tx_data[i], skb_frag_page(frag),
>  			    skb_frag_size(frag), skb_frag_off(frag));
>  		sk_mem_charge(sk, skb_frag_size(frag));
> -		get_page(skb_frag_page(frag));
> +		netmem_inc_ref(skb_frag_netmem(frag));
>  	}
>  	sg_mark_end(&offload_ctx->sg_tx_data[record->num_frags - 1]);

[Severity: High]
Does switching tls_append_frag() and tls_push_record() to netmem_inc_ref()
cause a page leak during mlx5 kTLS TX resync when page_pool pages are
spliced into a hardware-offloaded TLS socket?

When a page_pool page is appended to a kTLS record (for example via
MSG_SPLICE_PAGES in tls_device_sendmsg() -> tls_push_data()),
tls_append_frag() and tls_push_record() now increment pp_ref_count via
netmem_inc_ref() -> napi_pp_get_page() instead of incrementing struct page
_refcount, leaving page_ref_count(page) =3D=3D 1.

However, the mlx5 kTLS TX resync path in
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c still manipulates
raw struct page _refcount on record->frags[i]:

tx_sync_info_get() {
	...
	while (remaining > 0) {
		skb_frag_t *frag =3D &record->frags[i];

		page_ref_inc(skb_frag_page(frag));
		remaining -=3D skb_frag_size(frag);
		info->frags[i++] =3D *frag;
	}
}

and in mlx5e_ktls_tx_handle_ooo() and mlx5e_ktls_tx_handle_resync_dump_comp=
():

void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
					   struct mlx5e_tx_wqe_info *wi,
					   u32 *dma_fifo_cc)
{
	...
	mlx5e_tx_dma_unmap(sq->pdev, dma);
	page_ref_dec(wi->resync_dump_frag_page);
	stats->tls_dump_packets++;
	stats->tls_dump_bytes +=3D wi->num_bytes;
}

If the TCP ACK for the record arrives while the resync DUMP WQE is in
flight, tls_tcp_clean_acked() -> destroy_record() -> netmem_dec_ref() ->
napi_pp_put_page() runs while page_ref_count(page) > 1 (elevated by
page_ref_inc() / page_ref_add() in mlx5). Because page_ref_count(page) > 1,
__page_pool_page_can_be_recycled() returns false and __page_pool_put_page()
calls page_pool_return_netmem(), which unmaps the page from the pool, clears
pp_magic, and drops the page_pool's _refcount via put_page().

When the DUMP WQE later completes in mlx5e_ktls_tx_handle_resync_dump_comp()
(or unwinds at err_out in mlx5e_ktls_tx_handle_ooo()), page_ref_dec()
decrements page->_refcount to 0 without freeing the page to the page
allocator, leaking the page.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211424.1276=
27-1-almasrymina@google.com?part=3D4
