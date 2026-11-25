Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795636220;
	b=ddA1givSzULJOiXAfBAxYBhQYeH3BkD5VFFKeHPTPW7imh4dQ4kan9M4jA7cwc9gC/4F
	 V6Zen9ZMN4EKBI1Fi+LLh14JWSgDAk7jWOJv9fdmoenhflh1lpwn0azRsLzomJSwf4gip
	 Gd8CsCr6IzfQW5fLWn7ynRHCqhGSOdAOIaCttZLNKGoeVdzKx9C5jRZyMFSFJbilOEOdo
	 onI6OWdKeoXLMIwkLIpzueSwOJdRxJkZvj7O23qGA+EJZwi8vBg1QzbcledM1dl858gGj
	 Zyh+cJ7S7wjcDMgxkXvWJEjt8JozAr8IKwmlDjJdnLAf/EwaJHyXsxGnKTB4/FF4sKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795636220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QM3eA59kfAmko2h6w0lhdnOjVX+zvtHEYYmZknhRfY0=;
	b=19QDIlDhbWMmslR5Vmc0M6/hqcP5UCD0DYevvNecq3vPt5AEyQwwcLs3ThxKWJBtROKi
	 XM04ClavnTWplmKIFQuqVFBcFooG4CrAGTuKvLMzh3NCjmEXZdDwh4Z8wNLXnLcbateJr
	 jgeBRPylWZi0112VrcScaKEAOYG+2Xp68Bi2vDL0uGwvrd7WBkgF/BERSHF/n96rcq2b8
	 YIp9uYdfgJbPoAwigF+1O4GUbUtAm1kmUurvVOYmPPnjDLrHodoOAFxuVN9SCHpA6tt1Q
	 EfglyAvlE8HdWk3le8/n78Mf1uFLq2DmTc48V6qTISzjNZznyrFvYMGOSP7LEFtLNrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGNhLSiM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74C9606A329;
	Wed, 25 Nov 2026 19:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGNhLSiM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652A41F000C6;
	Wed, 25 Nov 2026 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795636220;
	bh=QM3eA59kfAmko2h6w0lhdnOjVX+zvtHEYYmZknhRfY0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=iGNhLSiMgKF6+m0ChpnHIHvmkrkC3j2St+TRFQkyy+QkmYLtkwfmC5F30JYh3MPLf
	 gyQF++J+IODjjeayKXffQghl4jIvlcZC21Sg3GNFn5cAT7PTdcxkuJBi2Vc/fqHDUY
	 KFAlFD5Y5apAiMdynX2JJfi4mF8qAx6k37eY1+8K6IazzpmrtmTOKQIYw7uJMDQyWs
	 R0UVQEq5tIQqLrMBGjzsZXdIAr2D9UURcNDAD4fDLiuJzPJiuKsPhQVqswyFFdbjA1
	 Xs0TveRe4BmdYAvuuwb8WLBR5Q2m5ujSl4kBn1ty2VLp7l8eXk9yIur+hbWqy33HdT
	 TLlbO8HV4M2Aw==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>,
 John
 Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Alexander Duyck <alexanderduyck@fb.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Michael Chan
 <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
 bpf@vger.kernel.org, netdev@vger.kernel.org, Stuart Clark
 <stuclar@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, Simon Horman
 <horms@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Mina Almasry
 <almasrymina@google.com>, Song Liu <song@kernel.org>, Yonghong Song
 <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis
 <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, Randy
 Dunlap <rdunlap@infradead.org>, kernel-team@meta.com, Dimitri Daskalakis
 <dimitri.daskalakis1@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Mohsin Bashir <mohsin.bashr@gmail.com>, Kees Cook <kees@kernel.org>, Breno
 Leitao <leitao@debian.org>, Maxime Chevallier
 <maxime.chevallier@bootlin.com>, Tao Cui <cuitao@kylinos.cn>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, "Mike Marciniszyn (Meta)"
 <mike.marciniszyn@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Jiayuan
 Chen <jiayuan.chen@linux.dev>, Martin Karsten <mkarsten@uwaterloo.ca>,
 Nikolay Aleksandrov <razor@blackwall.org>, David Wei <dw@davidwei.uk>,
 Pavel
 Begunkov <asml.silence@gmail.com>, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 05/15] xdp: Run programs on buffers that must
 not hold kernel structures
In-Reply-To: <awb9GzkXa9Z9LxuP@boxer>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-5-bjorn@kernel.org> <awb9GzkXa9Z9LxuP@boxer>
Date: Wed, 25 Nov 2026 20:50:16 +0100
Message-ID: <877bi0oflz.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Tue, Nov 24, 2026 at 01:56:40PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
>> Currently, the core refuses native XDP programs next to a memory
>> provider. An AF_XDP sink needs XDP to steer its packets and to use the
>> RX metadata kfuncs. Its buffers are UMEM chunks that XDP may read
>> through the kernel mapping, but that userspace may write at any time,
>> also while the kernel reads them. If drivers build XDP buffers on them
>> as on pages, the core puts kernel structures into them, such as the
>> shared info of a multi-buffer packet, the xdp_frame of XDP_TX and
>> redirects, and the skb of XDP_PASS.
>>=20
>> Let programs run on sink buffers as on pages, and keep every kernel
>> structure out of them.
>>=20
>> A sink offers an XDP view of its UMEM, so drivers build the buffer as
>> for a page, while netmem_address() and skb_frag_address() still give
>> NULL for sink net_iovs. Programs and helpers read and write the packet
>> in place, fragments included. xdp_prepare_buff() tells a sink head by
>> its address, with one range check under a static key, and marks the
>> buffer before the driver adds fragments. Other buffers pay nothing
>> while no sink is bound.
>>=20
>> A marked buffer keeps its shared info in the queue, with
>> XDP_FLAGS_SINFO_EXT, set up when the driver registers a sink page pool
>> as its memory model.
>>=20
>> A sink buffer may only go to the AF_XDP socket of its queue. The core
>> turns XDP_TX and XDP_PASS into XDP_DROP, so drivers need no checks of
>> their own. XDP_ABORTED and invalid verdicts reach the driver, which
>> traces them and drops the packet. Frame conversion and skb
>> construction refuse sink buffers too, so devmap and cpumap drop them,
>> and sink net_iovs never become skb frags, so every net_iov frag stays
>> unreadable.
>>=20
>> As userspace may change the bytes meanwhile, the kernel takes bounds
>> only from its own fields, and only the program and its helpers read
>> the bytes. A helper that reads bytes twice must check a copy.
>>=20
>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
>> ---
>>  include/net/netmem.h          |  5 ++-
>>  include/net/page_pool/types.h |  7 ++--
>>  include/net/xdp.h             | 60 +++++++++++++++++++++++++++++++++--
>>  net/core/xdp.c                | 46 +++++++++++++++++++++++++--
>>  4 files changed, 108 insertions(+), 10 deletions(-)
>
>>  	xdp_frame->data =3D xdp->data;
>> @@ -763,6 +812,11 @@ static __always_inline u32 bpf_prog_run_xdp(const s=
truct bpf_prog *prog,
>>  	 */
>>  	u32 act =3D __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
>>=20=20
>> +	/* Sink buffers go to the AF_XDP socket of their queue, or nowhere */
>> +	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp) &&
>> +	    (act =3D=3D XDP_PASS || act =3D=3D XDP_TX))
>> +		act =3D XDP_DROP;
>
> I think it would be better to follow SEC(xdp.frags) approach and from
> verifier POV disallow progs doing anything different than XDP_REDIRECT...?
>
> Here you affect whole system.

This will go away once PASS/TX is supported in the follow up.

> Also, I don't follow currently why xdp pass is not allowed, management
> traffic gonna be dead on this queue.

This is to keep the size of the series down, to make it reviewable.
XDP_PASS and XDP_TX will be added in a follow up. You can have a look at
the patches on the github branch I linked in the cover.
