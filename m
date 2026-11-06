Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793993831;
	b=T+K+cXrrjxKzJw2gMnFe0WsW6lZSNMfl7b5SirVxU6AXrkqAQAObL3H8Q8gH5O7iOzMM
	 ikdlU6lMHHfJ0vb8fVeHz8FOSTMeKFZs4vNL80A6AdX/XxT0/yPMrwmipqRrPRDXJWKc8
	 LMUi3xxsSxmWGZIBkY8EqLmIwVvi+fa4P1/Qy9aRlEJlsC6JwLABDyly2BzjZUGQ5o3uf
	 fpJ8Bq8+Q5/ypKMVEwzZbulMri16L81WoZdDgvNo7LhSB7VGIbwIyvTllMBhS7qO9JfcU
	 ucULB+PfToK9owH69VzYp2jhrGoLaAk5htNweE57X/6GBa3DpqeMFYEOBtA4xgxOJ6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793993831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
	b=TaDbMJdQ50IP27wFdX1nYQsgLA8Lq67ReDYv9/CiJonogwrrT1H12o6gtwiBn/T5zk2C
	 H7YidunDdaXffQiSiMaQc+uyyAJQVXXrd2xBAhDvfKTylHo/SYa/g5408EwbNUep0bE5q
	 m62VEoTXe8eQXewPr1d/cZZtTuPYDuyNkbTbl/ov0ONyi8a3zd+LLXUd13Y3Mwizx5ddo
	 1ggFSyajUQbXafs64NUa8TERQvGg7zLjrn3RfVJTluf4U9uWKG0Oai8IimkyvIVtZGyCw
	 85mk6X9elnIOYXzfHIrNVjx0HRAsXLhwhPaUbP90szZ12chxlFjsQKKn4rlSYve1Kmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dNYKX741;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A975E606A333
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 19:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A975E606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dNYKX741
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b571a45a2aso351a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 11:37:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793993829; cv=none;
        d=google.com; s=arc-20260327;
        b=WcNEPGXserh/poWCHw2lGMyEhsosyfY0ieG1WT0/qZO0uVqbD5RW/aAXQmCIjz4vSx
         rxfKrzqI5O/HU9N2gjiwVTaZ8BrN2DKhaNYAAAQOWCbDYY79mlHf37IUZ4dqN7g3uQTG
         6auX1SuZlh0Fuua5THBcOgtt6P3A43lIFzw59ckbmrqH4Pkz/tBGgpr0eSieYiWvDJOI
         R3oXRvU1uU49X6myqTBODa9jE6XmOkpWIlzZHt+grKTmyYBKtXw31RVNPTy7k4t0hmVv
         FwHWlVgHV7TQ2fWfs6h9ZmFLEQ73/EA+IGQ7G1EQEqfAzL/YYAAQzHKXN7FkyngCb/QQ
         gwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
        fh=YOJ+9j8M7hvx1a+qjNXUGorO2TMbKkw5sK02HJytoXQ=;
        b=ZGhv9o7s+/z8+L4YQKNXESUMnTWd+zLPpCpoHYym8VeSh2D65oWuL2K9TInuPiPwB/
         6la3HJaaHzVPtHd4M1QLRJ9BTb9EsIGbRud5nRWBSCp+9esnIWzRBPXA6wIJyitnqrie
         PBQbAch6zel97lJbHdi89FLHQd71H7R7F9I8wr1aOt9oVSoFfVciJpwyh26glMALHVEh
         d3tMrBqffm8X0hbXL/rc+GuYOilnIZ3GCsS6l3TR80MWMe6rQGLETmTscloSxhrbTlx0
         qcN5Ti2//vx1MHLOzU/zn/p30ZB7K5Nk7I+Z6bRrWNroQDBZgnEnmNDfKGi6IBQj6bXr
         oRug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793993829; x=1794598629; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
        b=dNYKX741s1YqNe1FvA8HrV/YpGpoTnGJGFShNhnSitPQzFMAUPpOwNIQMFI2wQuupp
         Y3hUs2tFnqdC/VdRW0zFndWiN5AEQOPGp+56b9YRlp3KsWlNMpTSS8KsWRrwE1ANF2pq
         rqBZJYUR8FH+KjD7/HLOiENIbIrs3HrrM8TJb1M/BuyUNDbGddOYw2008Rdk4q5N0Uxl
         3EieS5hw2UL/IalHpELqKu13m9jSN1raX/4Zjd6KaK+E++zf5w71v7XhAlDRuezX6Udl
         f7kTAVTND9XsibslSTDmGJ+yIq9kviDckaPxMp7hBXFHpqA1f7fpqoKOW8Fvv9kEJQlq
         mUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793993829; x=1794598629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
        b=m3uGja239+lOoiRGfGdE9j4N3ZXZ0JA+X01TkwJAmgFKxIhEERisCzsyzvM+p0AGsT
         UC6G+7hOQny94/h7DvyfvMCCw9RHrgKEYgJTUlyE0cK5flMSUVq7RP1FCdqjdOTSXX6l
         4onN5NQxkSDPxDsygH6Cr/TUy1EdhX9/IB8hp4lGVtVMxsIbjoHahnd7oppTAX9zttjx
         gwd6DwsHK+WEaaOSS2pGmiGKfXtbLWNdBu7DPb0THIrFXa0iNIH4xttFrpSMNY5V/yla
         VuXLJneuljsm66bwPnBfT4ZRKIhVsiqYg5lrElMIDfNxer9e28a+6/jfEft7wsy+bLz0
         Iw0w==
X-Forwarded-Encrypted: i=1; AL+hErEAJz8YKmB9yWl+a4QE50hUqBE9zFI2eOncWs5szn9OpOn6yfbaBE7erOn32KTTY7GOEKN5N6RwxNuh@vger.kernel.org
X-Gm-Message-State: APuU4Z+ETxluxceSNAJBHoPdKeW6ucByDF/OFmvsKtDldaCqu7++lFWI
	tf38CxO9lJstPxnYDrPG+1Gg4qqdV+9uPcgTZVFYQOSRF5LfLKDzCB627MJr3P6A/37fOtJsMYl
	Ll7v+5sBIQvim7MjOg0EEOGBj79mje21Uue3DHz3y
X-Gm-Gg: AYBFou3mUARD96Ns6/9vJuAeFw0NygUHY40ARTTP3a4y5AWx72++hlB4a/AJaCsngQn
	P1nNUOuB20LXgSpXHkD33TlFJYhukt/QxBAm/18OuQTvw1mruAk/f6+7TL3pQjEkNw9du/QujRq
	Lh5l5WtmEKnqnYFUeIY01GyS+q2DagCgciFhk6qyWl5KVdAVZeWrbpvGMYn6mE3XHUEFVzAWbeH
	pSqSZacY++wT6ZcujgVe0ycPLZD1HTBhk5BCljowl8xL303rLt/0YhQw5rG0FJXweUYVVxSR7lj
	L8Z5ImteSwt7TDmNSEC43jUFqfI8IcYXYj9aExcHDaWqsTekAZINceOAQWwkX0NAg19IxcE9HhN
	MJJLoyX9rZBt+behIAgfNa8aBk/yc+Vz7KC2oGuM+9MSxOamVIQJHzGX/6AHEIzG36Aw=
X-Received: by 2002:a05:6402:23d0:b0:6a6:7dff:61ab with SMTP id
 4fb4d7f45d1cf-6b6f845ff3cmr14348a12.15.1793993828178; Fri, 06 Nov 2026
 11:37:08 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-5-almasrymina@google.com> <sashiko-outbox-198073@kernel.org>
In-Reply-To: <sashiko-outbox-198073@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 6 Nov 2026 11:36:56 -0800
X-Gm-Features: AclHuK-XzQbdvaiv61WJyi_8ZqhwGRBCNFscgmlOjr77cMwMQUJZYeAEPiQPfDQ
Message-ID: <CAHS8izMDj5a0xyX4HAoAt=djt7As-Ko=LyEUfq9iJnPoCegXsA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 4/5] net: remove skb->pp_recycle and
 consolidate netmem refcounting
To: sashiko-reviews@lists.linux.dev
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Willem de Bruijn <willemb@google.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Pavel Begunkov <asml.silence@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>, 
	Justin Chen <justin.chen@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Vikas Gupta <vikas.gupta@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>, 
	Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, Wei Fang <wei.fang@nxp.com>, 
	Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, 
	Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>, 
	Subbaraya Sundeep <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
	Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, 
	Daniel Machon <daniel.machon@microchip.com>, Steen Hegelund <Steen.Hegelund@microchip.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>, 
	Brett Creeley <brett.creeley@amd.com>, Justin Lai <justinlai0215@realtek.com>, 
	Larry Chiu <larry.chiu@realtek.com>, 
	=?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>, 
	Paul Barker <paul@pbarker.dev>, Masahisa Kojima <kojima.masahisa@socionext.com>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>, 
	MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>, 
	Mengyuan Lou <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, 
	Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, 
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>, Eric Joyner <eric.joyner@amd.com>, 
	Mohammad Heib <mheib@redhat.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	Chintan Vankar <c-vankar@ti.com>, Nora Schiffer <nora.schiffer@ew.tq-group.com>, 
	Alexander Sverdlin <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>, 
	Frank.Li@kernel.org, wsa+renesas@sang-engineering.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 1:15=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Critical] page_pool: TOCTOU race in page_pool_unref_netmem() non-RMW f=
ast path
> - [High] tls: page leak between netmem kTLS records and mlx5 tx_sync_info=
_get()
> --

Real issues.

pw-bot: cr

--=20
Thanks,
Mina
