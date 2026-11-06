Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793987600;
	b=qI7c2t7XytGhJCvhqAkeqdpN8wC+Ytw7auzoepvFMDo7s6HK1olVvR2IscJU03lRMSGk
	 83h67fvHcyzaYCoJEIKMoNRoPIsXsE0UWou/6dtZs9Q8WCxx1v54Wvt16/I2ZnQ33zzs1
	 6hprTOZzKwxqV9NfqQASXiwTYwdPWpEwYF6x2fxgsK0/oL2dpQ20mEfNbN1uZlI0AvgEF
	 eunpUkBrdPC3EAJg+wZJE0PwAc4uRLXtm0/uIa6l+h3ZN5T8qQxuj3Kx5GlRoZpMHxaVY
	 TLAYSbi6kDyRtamgDl7sFT+FAUa1GmP0r4mxCCLuFMY2dA3wEJFARzXZMBdkl6vMi9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793987600;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
	b=46V1tnW5gITWdNjE2y43EzjQGOw4PvBgZlgkWFd5RExqn2vHowac8MoHLHIJg/nHBN2N
	 1BqeWYwyZoPxXDYMEOyVIQ/CwdUxaHJli5CYzQlmscFraWgLqv1CLfNHnBmZ1NoT5cKjN
	 gs/lo+O+NEi6NRIoCn/a9odub+U4UyZ4k9i0fezeSahsXtIPKDSDK8i3MREuLGnPsABGz
	 Nf3LunFd5z2fO+uSwUAVOtaXTC4qaOAN8KVefp98Vctx7/kaqSkkFCalasHImVUkUN+TE
	 OQ5ArfFzrnjK6tAbDtKYaNXx7BsiAGs+WxAVSA2jzGG8k1LfGusVDvgZpEeHdn8KyWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jlcDAy1q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5956B606A329
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 17:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5956B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jlcDAy1q
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b571a45a2aso4008a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 09:53:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793987599; cv=none;
        d=google.com; s=arc-20260327;
        b=JKnOLt/mBr5SoHaUqPLf98eSEHD4Cv9xU1Yk0inWaNEpSgX6L/XgUnAUA8bzLyyp4f
         clMUR42rSmolUttzQ+k0ln0exHArIWnCzZrCjXbABEKZeT3bkFKji7GiSNNFDhLN8O2T
         mFZoERT3lOZcqsumhj4lHy/ujdO5lHHDamhpeofAEQV5XQFqZoENaMrhSGJ7VJRndV3s
         yhUDOe0ustputWK1NSonGoMzmKZa5Uf4JpyNoJ3XWUJQQgcCbP/N7EZ08sQtcC6zak11
         xjewOveciruDMkGYSOd7FRPxFCel3tMKVOlCNo0ueBLb3MQmhrAB6fBWjS3Jy83UiMsO
         d+Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
        fh=s9ZD4sBL/DmCa9D0vvk684TKzkWXDNn/wYZg8HYFwLI=;
        b=l7zRemvJmB3JFMhD/FrA04G7nIZGtQ/xfuqPPo/TbKsj0zBCup0NVT8svn4m63V8cG
         q9M0i0WnCvygBAhHSNFzxzjjhXLSRL8te7cIbAlrJ7em9srW/qbcFxK+NeD1lMHvWTm9
         gg47IKQHR9a+ZyIo/jTF4CYvAToJKmJ8KNIl0qvbJgn1Q03Y0V2cBMgkfeFf1hgLrl6Q
         d3OVY5Q7xOwFxytyRyhuxfL5AaQ2BrVHfE7dQNbY4QEz2Ag1RBN5QKld/BNgKZTgWsRY
         k4hzcjwoo4fv2f5l9KXZD89gnqpEYwh2UhMLSKxPGMSPCJ24niLY7x5yJdlJU9f/EQTk
         pAHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793987599; x=1794592399; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
        b=jlcDAy1qwlP8CV/J8ziGOhM7zgiwe1Yqasgt18zZ9BLFfbdjvFbOPJHelnnlWn7/NF
         Iv0y6BvcfswTFEAK+vaTKFWw4pm1SC9i7SkbSqJgyIWek4Oq+yCZaP0CXyGrm6BTXeAy
         PMZhXc8r+FCA+Uan8Tn54ozp3MQPEOEFZdVxBH5ggJzVX08faCYPNZDo3xsJ3VF8tmEg
         pX3urwYaX0msYCvMLpruaNTx6NxqPVTVZ/iC58DSiI1w9TNgPQSmlsdvsWkpbFzggva5
         DeXnKd9qGJxbmFLWSsqwsQR8pJQE3NG/l6oFkjRU8+PfaF5R3/yJ38vi2guHN24z+b5U
         +fdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793987599; x=1794592399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
        b=xsJd0hqW3PH+fwMezDtuKWSq3TzQ870cvQIAwFtTnz8axWE7BHfBZEQyWJE5B57YBE
         Kcyl9k4Y5D6FJAH00wdGBBTMkhks/gaDH4/CriNvZdtl1z3gk34JTo+z5oikn4uZqXqN
         NbVjAtwmWNg+JQKTkCzrvCmCX4fwZWP/cmfJZnYiACy0Eayco9ObrT9wYD5gbqWrqsvQ
         h/1a50wDbBCnSBtWgw/dt1aG/YBHEt+2X/WWJ5FQRUGm5G1JC/9t1Cmzgz5LJRnqNLdj
         Ws80QPS/1O75e+fHE9T7q5Gk8iAuRXd7P4bWzMVhhfv8mqxPAmivjbena+UxJugCaN63
         yfow==
X-Forwarded-Encrypted: i=1; AL+hErHXYPMtYlcWQH15j50t6FihhN2bnoIZZRmMjnB0CMkUDWlAMrdG/HEUZlvKD8x3HemLGznABPz/2CbM@vger.kernel.org
X-Gm-Message-State: APuU4Z+W184VYSjBAld6utdnR8AtbpenF8PV9eu4E4QEwpaFUv0c2/fQ
	o4liXQgyz1d9vAe5g68mnNaTJ+VGw2vYAR3Qm60ESGXIZs6YqGpSGJi4gL6pLWwTFC3MYCM1H/W
	GbuxWe45Kn7gA9ikHbeWjdEdWSce4FR9SMenF9PDY
X-Gm-Gg: AYBFou3m2oorUdwy6DkgpQSu8T0jVmCO4K489L6pmXvh14wGz2IkvJDiXCx9yAIm9OR
	9iuH7IHUZdEPfSozTZJyc5zoowG25/uCmwqeV62yvBDNPpSVuF62eh2OnRQawoWklAtIOx7OTld
	gsMGheZCP0sbf0LegxWbyS665nEe2bV9d0SfKRNn9Vs8KTx2perb8qXDsl0v3bR+gqV2Yz6+d/1
	C8SvePxn8nP+G5CnVEXniCi99H64TBuqqHvE+Oi3pXrsdastYWorelGZbFPf8xWqop0ZoDOaiq1
	k8rUrcSySMVn1e6eruQqiash8EV+vvTv9A+ZFP5pS4O8lj+VqCpeWTTtjItPCsnieXz6TW36uWa
	PhyJy0v7YMShinFHz13jIGOdbS8uy46q/iiKMVCsxR0vvuBNagULYDu308WD0+vs5rSU=
X-Received: by 2002:a05:6402:20d2:10b0:6af:97c0:ce51 with SMTP id
 4fb4d7f45d1cf-6b6f84514ccmr6722a12.13.1793987598073; Fri, 06 Nov 2026
 09:53:18 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com> <cf2e3292-d591-42a4-bf6e-76f4567604c6@kernel.org>
In-Reply-To: <cf2e3292-d591-42a4-bf6e-76f4567604c6@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 6 Nov 2026 09:53:06 -0800
X-Gm-Features: AclHuK9NbTvBEPfZwCm6iqd7sXh-jqNYXp8FMPv7QJO9bGGBVmf4WllHJrUhzyo
Message-ID: <CAHS8izO7QmD1qp=QfUsCq-R+p7OuOVUtqPJZh1k+u7H1J3KnoQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/5] net: deprecate skb->pp_recycle and skb_mark_for_recycle()
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org, 
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Johannes Berg <johannes@sipsolutions.net>, 
	Byungchul Park <byungchul@sk.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>, 
	Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	Doug Berger <opendmb@gmail.com>, Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, 
	Wei Fang <wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
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
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 8:36=E2=80=AFAM Jesper Dangaard Brouer <hawk@kernel.=
org> wrote:
>
>
>
> On 11/3/26 22:14, Mina Almasry wrote:
> > Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
> > helper, and reference-count netmems directly by their underlying type
> > via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().
> >
> > This series simplifies SKB and netmem reference counting:
> > - Reclaims 1 bit from struct sk_buff (skb->pp_recycle).
> > - Unifies reference counting of SKB fragment netmems and regular netmem=
s
> >    under netmem_inc_ref() and netmem_dec_ref(), eliminating the separat=
e
> >    skb_netmem_ref(), skb_netmem_unref(), and skb_mark_for_recycle() API=
s.
>
> Part of the performance gain from page_pool was to completely avoid the
> atomic refcnt operation, when we can see that page refcnt=3D=3D1.
> Are you removing this?
>

I am not, and this is a very sharp observation, because retaining that
optimization was one of the things I struggled with my LLM to come up
with a way to retain that optimization without pp_recycle. Patch 4
includes verification from pp-bench that the fast path remains just as
fast:

   - no-softirq-page_pool01 (fast path): 37 cycles (18.7 ns) baseline
vs      36-37 cycles (18.5 ns) patched.
   - no-softirq-page_pool02 (ptr_ring): 77-78 cycles (38.9 ns)
baseline vs      76-77 cycles (38.4 ns) patched.

But the sashiko comments indicates there is at least 1 race related to
this we missed. It looks like a smp_rmb() after checking the page is
exclusively owned may fix it. Let me see if that works.

--=20
Thanks,
Mina
