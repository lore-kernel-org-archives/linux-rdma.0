Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635365;
	b=TGec0NM+np1hmUhsCQ219u1XnRWYyV5nI3N1Yxk5vp0e8UsgAF1FtGIz17VrXMH99npd
	 6MSEH7thTKvAAoxHvJc+q29PnE+0HX6Jq7CxU+qgOo3zjU/fsfCPqouPdLuoRMWD/KWyr
	 fTJArBE4VhciXLblJk0+Zkmhg3nYSBHFCX66W+E5q3e4YqQ5aOLfLdVHvomGjxF+qV28A
	 /c9NmQyrQLSeQRGozEDQ6fyP9dhDfmMQNlVivCCYTO+j0THiVrfchGDqZQbsmWk8LLi87
	 B4bIHkytfYKAfYnKDAT1046tFaf4JDugdj8Sz+rIeCiz3oxmxvGTEjkAUCk8ZfZYfjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Tr/iPHr+JWqZmmJR7USpXjVU7ujr6M6VCMW4PPGH0TI=;
	b=fiIUkngOZrfdJuMbvtt327Wx6/ARLv3ipOuQhX82sIAE7ILbcehP8DPw5LYff1qrjVaQ
	 9ewq20ES8jkUgoqiz62VbkhgrnXkvbtXWTqJmK1BuGTgftaoIsS8XL4ZENXzNNNxmZRK8
	 /IreF8mionr5H97bMj3NVB8/sUockR+xD5IMgTnGDojx1sFGOhXqCckYqIKB2/AfXFCsj
	 1u6DDwFeBfZPe6sRMHQ4bL8sAt9/0WaMVfZJjrk9laFdjvPgL30vbG3pY1y8RNor6TzOP
	 icKcv5M5tvFypQNOyrBfc5TD9zvT5H6nQA9zkNUUyDWiJUluBxjxomYN/oCAwyn7g2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gZI6ZY/9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BCD606A323;
	Wed, 25 Nov 2026 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gZI6ZY/9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDE21F000D0;
	Wed, 25 Nov 2026 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635364;
	bh=Tr/iPHr+JWqZmmJR7USpXjVU7ujr6M6VCMW4PPGH0TI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gZI6ZY/9FOlg1GJgOUhV+Cj0dx2xtMFRnWmyHraUhfsTgZjRWcxSshCt64dU0RpX0
	 EDhalz88iIHbniIOjjOm5PVk4BXti7Hsh17cmehu2NLSmIzekMYo2fX/sOR46PMxq0
	 eR7D4qT1xOBsY0U3iF9q8niKafp3xMkG9OSaA+UD6jldHb+CKxBcomllqrvBdBZc8z
	 352jKDlQ0teuXsvk7vnFJ7hjJsxDESnegcfbNk8d4ZfQJt3mUsINYuR9CTo8BA3XQJ
	 sGjAD7+QrrFMawIkuyZNlsU0eakuzq0CbBYgkPM3UtF+uXuMqVThLVtGdjJkRwXF0S
	 t5cLNGuJeKR7Q==
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
Subject: Re: [PATCH net-next 02/15] xdp: Keep the shared info of a buffer in
 kernel memory
In-Reply-To: <awb8BX2lbZ4sotpQ@boxer>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-2-bjorn@kernel.org> <awb8BX2lbZ4sotpQ@boxer>
Date: Wed, 25 Nov 2026 20:36:02 +0100
Message-ID: <87qzg8og9p.fsf@all.your.base.are.belong.to.us>
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

> On Tue, Nov 24, 2026 at 01:56:37PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
>> Currently, the shared info of an XDP buffer, with the fragment list of
>> a multi-buffer packet, lives at the end of the buffer's frame, in
>> memory that the device writes. Helpers follow its fragments, drivers
>> free them through it, and frame and skb conversion copy it, so memory
>> that others may write while the kernel uses it must not hold it.
>> Classic AF_XDP zero copy keeps it in the tail of a UMEM chunk, where
>> userspace can rewrite it.
>>=20
>> Let an RX queue keep the shared info of its buffers in kernel memory.
>> The queue gets one from xdp_rxq_info_reg_ext_sinfo(), and
>> xdp_rxq_info_unreg_mem_model() frees it. A buffer with the new
>> XDP_FLAGS_SINFO_EXT finds its shared info there.
>>=20
>> Whoever prepares a buffer sets the flag before adding fragments. The
>> queue NAPI builds one buffer at a time, so one shared info per queue
>> is enough. It is valid until the buffer is redirected, dropped or
>> copied. Frame conversion and skb construction refuse buffers with the
>> flag, as a frame or an skb would keep its shared info in the buffer.
>> Nothing sets the flag until later in this series.
>>=20
>> xdp_data_hard_end() reserves no shared-info tailroom for such a
>> buffer, so its data may reach the end of the frame. frame_sz then
>> bounds every write past the data, such as tail growth and
>> bpf_xdp_pull_data(), so the frame must not cover memory of other
>> buffers. Drivers may then pack such buffers tighter.
>>=20
>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
>> ---
>>  include/net/xdp.h | 41 +++++++++++++++++++++++++++++++++++------
>>  net/core/xdp.c    | 30 ++++++++++++++++++++++++++++++
>>  2 files changed, 65 insertions(+), 6 deletions(-)
>
> couldn't this effort be sent separately and address classic zc as well?

Yes, and it should. This is a security issue for AF_XDP implementations
supporting xdp.frags. :-(
