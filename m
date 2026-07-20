Received: from 10.mo534.mail-out.ovh.net (10.mo534.mail-out.ovh.net [46.105.32.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0FA39C002
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.105.32.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784589067; cv=none; b=j9eIam/jMsuL9N2PkeSebCSXmdLBZV8M81bENFV5XvLHLY+6hBOtvtYPW9f0YfbzULx8AF82UAU5RQSFmM4/IViefSF/Qf7lvjtSknIt4l//hxdRuBq+S1usToPmR3FQmYvkf8G/aaPabAOL6i4XdqshraojMvEYy/fUNd3XKLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784589067; c=relaxed/simple;
	bh=e3W83qPhfGL1MyzfZ+OkadYx0TRHN0PqsHxIjlpsCPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m7qiuxbHA7UWEh20LIWR9aZkmTqtJaUZJd5LCbcIQKl+atghwRLMnn4LX2lmuTFkFqL6+bjmCBUE8Un6PS81M+WWxprMuKetcjHhYcXtYsswT0bb/EVLqL1gJqHG93DFztxcUFVvDZVchFT45t8BT123JSjpDdnKVQioAN6TNEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev; spf=pass smtp.mailfrom=pixelcluster.dev; dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b=mCQn5sGj; arc=none smtp.client-ip=46.105.32.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b="mCQn5sGj"
Received: from director4.derp.mail-out.ovh.net (director4.derp.mail-out.ovh.net [79.137.60.37])
	by mo534.mail-out.ovh.net (Postfix) with ESMTPS id 4h3s2Y5qPlz62Sp;
	Mon, 20 Jul 2026 20:05:41 +0000 (UTC)
Received: from director4.derp.mail-out.ovh.net (director4.derp.mail-out.ovh.net. [127.0.0.1])
        by director4.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 20:05:41 +0000 (UTC)
Received: from mta10.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.178.215])
	by director4.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4h3s2Y4WRXz230R;
	Mon, 20 Jul 2026 20:05:41 +0000 (UTC)
Received: from pixelcluster.dev (unknown [10.1.6.10])
	(Authenticated sender: nat@pixelcluster.dev)
	by mta10.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id D47CA78182C;
	Mon, 20 Jul 2026 20:05:34 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-114S0088dc193b7-f2c3-4779-a428-82256bb3fa97,
                    C3734F40C508294C35C68B4B2E3182D4061B5CDF) smtp.auth=nat@pixelcluster.dev
X-OVh-ClientIp:88.133.252.134
Message-ID: <41e73be8-242a-4e7b-b085-439375303590@pixelcluster.dev>
Date: Mon, 20 Jul 2026 22:05:33 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH net-next 08/13] drm/amdkfd: add GPU instruction
 emitter and disassembler
To: Taehee Yoo <ap420073@gmail.com>, Alex Deucher
 <alexander.deucher@amd.com>, Alexei Starovoitov <ast@kernel.org>,
 amd-gfx@lists.freedesktop.org, Andrew Lunn <andrew+netdev@lunn.ch>,
 Andrii Nakryiko <andrii@kernel.org>, Bill Wendling <morbo@google.com>,
 bpf@vger.kernel.org, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, Daniel Borkmann <daniel@iogearbox.net>,
 David Airlie <airlied@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Donald Hunter <donald.hunter@gmail.com>, dri-devel@lists.freedesktop.org,
 Eduard Zingerman <eddyz87@gmail.com>, Emil Tsalapatis
 <emil@etsalapatis.com>, Eric Dumazet <edumazet@google.com>,
 Felix Kuehling <Felix.Kuehling@amd.com>, Hoyeon Lee <hoyeon.rhee@gmail.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Leon Romanovsky
 <leon@kernel.org>, linaro-mm-sig@lists.linaro.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-media@vger.kernel.org,
 linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
 Mark Bloch <mbloch@nvidia.com>, Martin KaFai Lau <martin.lau@linux.dev>,
 Michael Chan <michael.chan@broadcom.com>,
 Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
 Nick Desaulniers <ndesaulniers@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
 Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@kernel.org>,
 Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Sumit Semwal <sumit.semwal@linaro.org>, Tariq Toukan <tariqt@nvidia.com>,
 Yonghong Song <yonghong.song@linux.dev>
References: <20260719175857.4071636-1-ap420073@gmail.com>
 <20260719175857.4071636-9-ap420073@gmail.com>
Content-Language: en-US
From: Natalie Vock <nat@pixelcluster.dev>
In-Reply-To: <20260719175857.4071636-9-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 9193254215845896543
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTEGrFInzTDZ5GgD+HQbfTKqjNCbKqKjMHw/Y0z45d4/2SdxUwF1PI5hWcNpNBLkOFZuqLZXlm6aUN6ud6YMFtmAYGsTBK4AwFU+shLUTeSNhiNkmPnVnn1qWi7WoqxwsPXgz8rB+fE5WFI4w9kbz875FlPS70f5uj4g2zt7Ip0RrL+73EhAWVD5argNsLLMj18LeGQFKwkRveKw4+nN/OjUYJcNcdLNUVI+tAB05u5TNWlYAO/f9EHXRspUY/gwSC7NNKhBc8dmRYJ1xB25zzlxUPF2m5N4O4BSqwv2xQ4svYhtjB1rJ4w6RCybkMBb38YIS/0mNfURkHul3tB3TTx5JRlQ5RtgvuC1VdGzv4kq7pAWYruYepdK6YaE/8/IF5yhry0OOKEWjmHvvTutLRqbqkLbzfkpv8SRFz4Op7RlWJgdHHshFsE6WGUiv5FNp4/ztF6zbgw5RaXRE13l+OWDqWC1WPBxYY9Xo6gW1ubOaq+Fqjpk3sCkrosIQDPdVPLVHYu+3PHEO3hWQcrHZGomcyiAaeQar4kq8Lwuii6xdK5wBk3PDmjF/UDlWJ1FNKscrS8zNBsuTwow0uqTg1NHWbgB1zzBQjsHCfC0N7lLMLtdre0dmwDa0Rn9JlBanotxe5p3XgWGh9Ep2NqWIThV7V6O3VPTPH75J6aFzkNZMQ
DKIM-Signature: a=rsa-sha256; bh=E/uA9+zlu2ZBmSvkmN50kL4iPK1x4ug4el5GMk/uNP4=;
 c=relaxed/relaxed; d=pixelcluster.dev; h=From; s=ovhmo-selector-1;
 t=1784577941; v=1;
 b=mCQn5sGjrlgVPjkVbYhiab7d94tZzWkc8fHxm5+dNRM6O67aPMGSGhub9j+dJHJu/bLQwsab
 NJ5vRuuXT2NIapZw6AQGVjVgiAOvWHYMwUGeZbvOI2lHICIvX4UaC1+Sw5gwDLnU/sy9TFjiyjU
 6K6h9QEVbu9fWc/pqfPtbiOULhGd3Qw14Y31yu30lOs3BM/T1sAGBon1A5W4h1Jz1Y4dQh35BuJ
 YEFAdd+SGStrZx5o/H5K4pcEm/euNUz3VaioJYBQHS82SY6uVNG9Gcizf+/LroLLwnCZex+w5gI
 YX4mdcHnS9XIdOr/uf5pmAPpOncw1evxgNXFXnKLHZd5g==

On 7/19/26 19:58, Taehee Yoo wrote:
> Add the AMD GCN (gfx9/gfx10) instruction encoder used to build the GPU
> shaders that knod dispatches, plus a matching disassembler used for
> debugging the generated code.

Is it really necessary to have a full-on compiler and disassembler in 
the kernel driver? This patch is massive and I'm wondering how much 
benefit it really provides. Is there really no way to move GPU 
compilation out of the kernel, one way or another? Could you get 
acceptable perf with a static shader that interprets BPF programs at 
runtime? Such a shader can be compiled beforehand and just embedded into 
the kernel - there's prior art there with the CWSR trap handler in amdkfd.

In case you really, really need to compile the BPF to native ISA, could 
you still have userspace take care of that in one way or another?

This would probably reduce the size of your patches to much more 
reasonable numbers as well.

Best,
Natalie

> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> (cherry picked from commit bbbe8531de11017f565a922b072d4aa5f99674fc)
> ---
>   drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu.h |  173 +
>   .../drm/amd/amdkfd/knod/knod_amdgpu_insn.h    | 6362 +++++++++++++++++
>   .../gpu/drm/amd/amdkfd/knod/knod_gfx10_insn.h | 3978 +++++++++++
>   .../gpu/drm/amd/amdkfd/knod/knod_gfx9_insn.h  | 4068 +++++++++++
>   4 files changed, 14581 insertions(+)
>   create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu.h
>   create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu_insn.h
>   create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/knod_gfx10_insn.h
>   create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/knod_gfx9_insn.h
> 
> diff --git a/drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu.h b/drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu.h
> new file mode 100644
> index 000000000000..77d1c6afdd0a
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu.h
> @@ -0,0 +1,173 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
> + * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
> + */
> +
> +#ifndef KFD_AMDGPU_H_INCLUDED
> +#define KFD_AMDGPU_H_INCLUDED
> +
> +#define KNOD_AMDGPU_REG_PAIR(x)         ((x) / 2)
> +
> +enum amdgcn_param_type {
> +	AMDGCN_PARAM_TYPE_SGPR,
> +	AMDGCN_PARAM_TYPE_VCC_LO,
> +	AMDGCN_PARAM_TYPE_VCC_HI,
> +	AMDGCN_PARAM_TYPE_TTPM_BASE,
> +	AMDGCN_PARAM_TYPE_M0,
> +	AMDGCN_PARAM_TYPE_NULL,
> +	AMDGCN_PARAM_TYPE_EXEC_LO,
> +	AMDGCN_PARAM_TYPE_EXEC_HI,
> +	AMDGCN_PARAM_TYPE_INTEGER_0,
> +	AMDGCN_PARAM_TYPE_INTEGER_MINUS_1,
> +	AMDGCN_PARAM_TYPE_SHARED_BASE,
> +	AMDGCN_PARAM_TYPE_SHARED_LIMIT,
> +	AMDGCN_PARAM_TYPE_PRIVATE_BASE,
> +	AMDGCN_PARAM_TYPE_PRIVATE_LIMIT,
> +	AMDGCN_PARAM_TYPE_POPS_EXITING_WAVE_ID,
> +	AMDGCN_PARAM_TYPE_SDWA,
> +	AMDGCN_PARAM_TYPE_DPP16,
> +	AMDGCN_PARAM_TYPE_VCCZ,
> +	AMDGCN_PARAM_TYPE_EXECZ,
> +	AMDGCN_PARAM_TYPE_SCC,
> +	AMDGCN_PARAM_TYPE_LITERAL_CONST,
> +	AMDGCN_PARAM_TYPE_VGPR,
> +	__AMDGCN_PARAM_TYPE_MAX,
> +};
> +
> +struct amdgcn_param32 {
> +	enum amdgcn_param_type type;
> +	int v;
> +};
> +
> +struct amdgcn_param64 {
> +	struct amdgcn_param32 lo;
> +	struct amdgcn_param32 hi;
> +	u64 imm;
> +};
> +
> +inline void knod_set(struct amdgcn_param32 *param,
> +				  enum amdgcn_param_type type, int v)
> +{
> +	param->type = type;
> +	param->v = v;
> +}
> +
> +inline void knod_vset32(struct amdgcn_param32 *param, int v)
> +{
> +	param->type = AMDGCN_PARAM_TYPE_VGPR;
> +	param->v = v;
> +}
> +
> +inline void knod_vset64(struct amdgcn_param64 *param, int v)
> +{
> +	param->lo.type = AMDGCN_PARAM_TYPE_VGPR;
> +	param->lo.v = v;
> +	param->hi.type = AMDGCN_PARAM_TYPE_VGPR;
> +	param->hi.v = v + 1;
> +}
> +
> +inline void knod_sset32(struct amdgcn_param32 *param, int v)
> +{
> +	param->type = AMDGCN_PARAM_TYPE_SGPR;
> +	param->v = v;
> +}
> +
> +inline void knod_sset64(struct amdgcn_param64 *param, int v)
> +{
> +	param->lo.type = AMDGCN_PARAM_TYPE_SGPR;
> +	param->lo.v = v;
> +	param->hi.type = AMDGCN_PARAM_TYPE_SGPR;
> +	param->hi.v = v + 1;
> +}
> +
> +inline void knod_iset32(struct amdgcn_param32 *param, int v)
> +{
> +	if (v > 64 || v < -16) {
> +		param->type = AMDGCN_PARAM_TYPE_LITERAL_CONST;
> +		param->v = v;
> +	} else if (v >= 0) {
> +		param->type = AMDGCN_PARAM_TYPE_INTEGER_0;
> +		param->v = v;
> +	} else {
> +		param->type = AMDGCN_PARAM_TYPE_INTEGER_MINUS_1;
> +		param->v = ~v;
> +	}
> +}
> +
> +inline void knod_iset64(struct amdgcn_param64 *param,
> +				     u64 v)
> +{
> +	int imm0 = v & ~0U;
> +	int imm1 = v >> 32;
> +
> +	param->imm = v;
> +
> +	if (imm0 > 64 || imm0 < -16) {
> +		param->lo.type = AMDGCN_PARAM_TYPE_LITERAL_CONST;
> +		param->lo.v = imm0;
> +	} else if (imm0 >= 0) {
> +		param->lo.type = AMDGCN_PARAM_TYPE_INTEGER_0;
> +		param->lo.v = imm0;
> +	} else {
> +		param->lo.type = AMDGCN_PARAM_TYPE_INTEGER_MINUS_1;
> +		param->lo.v = ~imm0;
> +	}
> +
> +	if (imm1 > 64 || imm1 < -16) {
> +		param->hi.type = AMDGCN_PARAM_TYPE_LITERAL_CONST;
> +		WARN_ON_ONCE(1);
> +		param->hi.v = imm1;
> +	} else if (imm1 >= 0) {
> +		param->hi.type = AMDGCN_PARAM_TYPE_INTEGER_0;
> +		param->hi.v = imm1;
> +	} else {
> +		param->hi.type = AMDGCN_PARAM_TYPE_INTEGER_MINUS_1;
> +		param->hi.v = ~imm1;
> +	}
> +}
> +
> +inline void knod_lset32(struct amdgcn_param32 *param, int v)
> +{
> +	param->type = AMDGCN_PARAM_TYPE_LITERAL_CONST;
> +	param->v = v;
> +}
> +
> +inline void knod_vccset(struct amdgcn_param32 *param)
> +{
> +	param->type = AMDGCN_PARAM_TYPE_VCC_LO;
> +	param->v = 0;
> +}
> +
> +inline bool knod_param_is_literal(struct amdgcn_param32 param)
> +{
> +	return param.type == AMDGCN_PARAM_TYPE_LITERAL_CONST;
> +}
> +
> +/* ======================================================================
> + * Param constructors - common to GFX9/GFX10 shader emitters.
> + *
> + * Usage: pass directly to emit_gfx{9,10}_* functions that take
> + *        struct amdgcn_param32 operands.
> + * ======================================================================
> + */
> +
> +#define P_S(n)	((struct amdgcn_param32){ AMDGCN_PARAM_TYPE_SGPR, (n) })
> +#define P_V(n)	((struct amdgcn_param32){ AMDGCN_PARAM_TYPE_VGPR, (n) })
> +#define P_I(n)	((struct amdgcn_param32){ AMDGCN_PARAM_TYPE_INTEGER_0, (n) })
> +#define P_L(v)	((struct amdgcn_param32){ AMDGCN_PARAM_TYPE_LITERAL_CONST, (v) })
> +#define P_VCC	((struct amdgcn_param32){ AMDGCN_PARAM_TYPE_VCC_LO, 0 })
> +#define P_EXEC	((struct amdgcn_param32){ AMDGCN_PARAM_TYPE_EXEC_LO, 0 })
> +
> +/* ======================================================================
> + * Branch patching - operates directly on u32 *buf
> + * ======================================================================
> + */
> +
> +static inline void patch_branch(u32 *buf, int patch_pos, int target_pos)
> +{
> +	int offset = target_pos - (patch_pos + 1);
> +
> +	buf[patch_pos] = (buf[patch_pos] & 0xFFFF0000u) | (offset & 0xFFFF);
> +}
> +
> +#endif
> diff --git a/drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu_insn.h b/drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu_insn.h
> new file mode 100644
> index 000000000000..9703bf781ff5
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/amdkfd/knod/knod_amdgpu_insn.h
> @@ -0,0 +1,6362 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
> + * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
> + */
> +
> +#ifndef KFD_AMDGPU_INSN_H_INCLUDED
> +#define KFD_AMDGPU_INSN_H_INCLUDED
> +
> +#include "knod_amdgpu.h"
> +#include "knod_gfx10_insn.h"
> +#include "knod_gfx9_insn.h"
> +
> +enum amdgcn_insn_type {
> +	AMDGCN_INSN_TYPE_SOP2,
> +	AMDGCN_INSN_TYPE_SOPK,
> +	AMDGCN_INSN_TYPE_SOP1,
> +	AMDGCN_INSN_TYPE_SOPC,
> +	AMDGCN_INSN_TYPE_SOPP,
> +	AMDGCN_INSN_TYPE_SMEM,
> +	AMDGCN_INSN_TYPE_VOP2,
> +	AMDGCN_INSN_TYPE_VOP1,
> +	AMDGCN_INSN_TYPE_VOPC,
> +	AMDGCN_INSN_TYPE_VOP3A,
> +	AMDGCN_INSN_TYPE_VOP3B,
> +	AMDGCN_INSN_TYPE_VOP3P,
> +	AMDGCN_INSN_TYPE_SDWA,
> +	AMDGCN_INSN_TYPE_SDWAB,
> +	AMDGCN_INSN_TYPE_DPP16,
> +	AMDGCN_INSN_TYPE_DPP8,
> +	AMDGCN_INSN_TYPE_VINTRP,
> +	AMDGCN_INSN_TYPE_DS,
> +	AMDGCN_INSN_TYPE_MTBUF,
> +	AMDGCN_INSN_TYPE_MUBUF,
> +	AMDGCN_INSN_TYPE_MIMG,
> +	AMDGCN_INSN_TYPE_FLAT,
> +	AMDGCN_INSN_TYPE_EXP,
> +	__AMDGCN_INSN_TYPE_MAX,
> +};
> +
> +static const char opnames_gfx10[__AMDGCN_INSN_TYPE_MAX][900][30] = {
> +	[AMDGCN_INSN_TYPE_VOP3A] = {
> +		[GFX10_V_FMA_LEGACY_F32] = "v_fma_legacy_f32",
> +		[GFX10_V_MAD_I32_I24] = "V_MAD_I32_I24",
> +		[GFX10_V_MAD_U32_U24] = "v_mad_u32_u24",
> +		[GFX10_V_CUBEID_F32] = "v_cubeid_f32",
> +		[GFX10_V_CUBESC_F32] = "v_cubesc_f32",
> +		[GFX10_V_CUBETC_F32] = "v_cubetc_f32",
> +		[GFX10_V_CUBEMA_F32] = "v_cubema_f32",
> +		[GFX10_V_BFE_U32] = "v_bfe_u32",
> +		[GFX10_V_BFE_I32] = "v_bfe_i32",
> +		[GFX10_V_BFI_B32] = "v_bfi_b32",
> +		[GFX10_V_FMA_F32] = "v_fma_f32",
> +		[GFX10_V_FMA_F64] = "v_fma_f64",
> +		[GFX10_V_LERP_U8] = "v_lerp_u8",
> +		[GFX10_V_ALIGNBIT_B32] = "v_alignbit_b32",
> +		[GFX10_V_ALIGNBYTE_B32] = "v_alignbyte_b32",
> +		[GFX10_V_MULLIT_F32] = "v_mullit_f32",
> +		[GFX10_V_MIN3_F32] = "v_min3_f32",
> +		[GFX10_V_MIN3_I32] = "v_min3_i32",
> +		[GFX10_V_MIN3_U32] = "v_min3_u32",
> +		[GFX10_V_MAX3_F32] = "v_max3_f32",
> +		[GFX10_V_MAX3_I32] = "v_max3_i32",
> +		[GFX10_V_MAX3_U32] = "v_max3_u32",
> +		[GFX10_V_MED3_F32] = "v_med3_f32",
> +		[GFX10_V_MED3_I32] = "v_med3_i32",
> +		[GFX10_V_MED3_U32] = "v_med3_u32",
> +		[GFX10_V_SAD_U8] = "v_sad_u8",
> +		[GFX10_V_SAD_HI_U8] = "v_sad_hi_u8",
> +		[GFX10_V_SAD_U16] = "v_sad_u16",
> +		[GFX10_V_SAD_U32] = "v_sad_u32",
> +		[GFX10_V_CVT_PK_U8_F32] = "v_cvt_pk_u8_f32",
> +		[GFX10_V_DIV_FIXUP_F32] = "v_div_fixup_f32",
> +		[GFX10_V_DIV_FIXUP_F64] = "v_div_fixup_f64",
> +		[GFX10_V_ADD_F64] = "v_add_f64",
> +		[GFX10_V_MUL_F64] = "v_mul_f64",
> +		[GFX10_V_MIN_F64] = "v_min_f64",
> +		[GFX10_V_MAX_F64] = "v_max_f64",
> +		[GFX10_V_LDEXP_F64] = "v_ldexp_f64",
> +		[GFX10_V_MUL_LO_U32] = "v_mul_lo_u32",
> +		[GFX10_V_MUL_HI_U32] = "v_mul_hi_u32",
> +		[GFX10_V_MUL_HI_I32] = "v_mul_hi_i32",
> +		[GFX10_V_DIV_FMAS_F32] = "v_div_fmas_f32",
> +		[GFX10_V_DIV_FMAS_F64] = "v_div_fmas_f64",
> +		[GFX10_V_MSAD_U8] = "v_msad_u8",
> +		[GFX10_V_QSAD_PK_U16_U8] = "v_qsad_pk_u16_u8",
> +		[GFX10_V_MQSAD_PK_U16_U8] = "v_mqsad_pk_u16_u8",
> +		[GFX10_V_TRIG_PREOP_F64] = "v_trig_preop_f64",
> +		[GFX10_V_MQSAD_U32_U8] = "v_mqsad_u32_u8",
> +		[GFX10_V_XOR3_B32] = "v_xor3_b32",
> +		[GFX10_V_LSHLREV_B64] = "v_lshlrev_b64",
> +		[GFX10_V_LSHRREV_B64] = "v_lshrrev_b64",
> +		[GFX10_V_ASHRREV_I64] = "v_ashrrev_i64",
> +		[GFX10_V_ADD_NC_U16] = "v_add_nc_u16",
> +		[GFX10_V_SUB_NC_U16] = "v_sub_nc_u16",
> +		[GFX10_V_MUL_LO_U16] = "v_mul_lo_u16",
> +		[GFX10_V_LSHRREV_B16] = "v_lshrrev_b16",
> +		[GFX10_V_ASHRREV_I16] = "v_ashrrev_i16",
> +		[GFX10_V_MAX_U16] = "v_max_u16",
> +		[GFX10_V_MAX_I16] = "v_max_i16",
> +		[GFX10_V_MIN_U16] = "v_min_u16",
> +		[GFX10_V_MIN_I16] = "v_min_i16",
> +		[GFX10_V_ADD_NC_I16] = "v_add_nc_i16",
> +		[GFX10_V_SUB_NC_I16] = "v_sub_nc_i16",
> +		[GFX10_V_PACK_B32_F16] = "v_pack_b32_f16",
> +		[GFX10_V_CVT_PKNORM_I16_F16] = "v_cvt_pknorm_i16_f16",
> +		[GFX10_V_CVT_PKNORM_U16_F16] = "v_cvt_pknorm_u16_f16",
> +		[GFX10_V_LSHLREV_B16] = "v_lshlrev_b16",
> +		[GFX10_V_MAD_U16] = "v_mad_u16",
> +		[GFX10_V_INTERP_P1LL_F16] = "v_interp_p1ll_f16",
> +		[GFX10_V_INTERP_P1LV_F16] = "v_interp_p1lv_f16",
> +		[GFX10_V_PERM_B32] = "v_perm_b32",
> +		[GFX10_V_XAD_U32] = "v_xad_u32",
> +		[GFX10_V_LSHL_ADD_U32] = "v_lshl_add_u32",
> +		[GFX10_V_ADD_LSHL_U32] = "v_add_lshl_u32",
> +		[GFX10_V_FMA_F16] = "v_fma_f16",
> +		[GFX10_V_MIN3_F16] = "v_min3_f16",
> +		[GFX10_V_MIN3_I16] = "v_min3_i16",
> +		[GFX10_V_MIN3_U16] = "v_min3_u16",
> +		[GFX10_V_MAX3_F16] = "v_max3_f16",
> +		[GFX10_V_MAX3_I16] = "v_max3_i16",
> +		[GFX10_V_MAX3_U16] = "v_max3_u16",
> +		[GFX10_V_MED3_F16] = "v_med3_f16",
> +		[GFX10_V_MED3_I16] = "v_med3_i16",
> +		[GFX10_V_MED3_U16] = "v_med3_u16",
> +		[GFX10_V_INTERP_P2_F16] = "v_interp_p2_f16",
> +		[GFX10_V_MAD_I16] = "v_mad_i16",
> +		[GFX10_V_DIV_FIXUP_F16] = "v_div_fixup_f16",
> +		[GFX10_V_READLANE_B32] = "v_readlane_b32",
> +		[GFX10_V_WRITELANE_B32] = "v_writelane_b32",
> +		[GFX10_V_LDEXP_F32] = "v_ldexp_f32",
> +		[GFX10_V_BFM_B32] = "v_bfm_b32",
> +		[GFX10_V_BCNT_U32_B32] = "v_bcnt_u32_b32",
> +		[GFX10_V_MBCNT_LO_U32_B32] = "v_mbcnt_lo_u32_b32",
> +		[GFX10_V_MBCNT_HI_U32_B32] = "v_mbcnt_hi_u32_b32",
> +		[GFX10_V_CVT_PKNORM_I16_F32] = "v_cvt_pknorm_i16_f32",
> +		[GFX10_V_CVT_PKNORM_U16_F32] = "v_cvt_pknorm_u16_f32",
> +		[GFX10_V_CVT_PK_U16_U32] = "v_cvt_pk_u16_u32",
> +		[GFX10_V_CVT_PK_I16_I32] = "v_cvt_pk_i16_i32",
> +		[GFX10_V_ADD3_U32] = "v_add3_u32",
> +		[GFX10_V_LSHL_OR_B32] = "v_lshl_or_b32",
> +		[GFX10_V_AND_OR_B32] = "v_and_or_b32",
> +		[GFX10_V_OR3_B32] = "v_or3_b32",
> +		[GFX10_V_MAD_U32_U16] = "v_mad_u32_u16",
> +		[GFX10_V_MAD_I32_I16] = "v_mad_i32_i16",
> +		[GFX10_V_SUB_NC_I32] = "v_sub_nc_i32",
> +		[GFX10_V_PERMLANE16_B32] = "v_permlane16_b32",
> +		[GFX10_V_PERMLANEX16_B32] = "v_permlanex16_b32",
> +		[GFX10_V_ADD_NC_I32] = "v_add_nc_i32",
> +	},
> +	[AMDGCN_INSN_TYPE_SOP2] = {
> +		[GFX10_S_ADD_U32] = "s_add_u32",
> +		[GFX10_S_SUB_U32] = "s_sub_u32",
> +		[GFX10_S_ADD_I32] = "s_add_i32",
> +		[GFX10_S_SUB_I32] = "s_sub_i32",
> +		[GFX10_S_ADDC_U32] = "s_addc_u32",
> +		[GFX10_S_SUBB_U32] = "s_subb_u32",
> +		[GFX10_S_MIN_I32] = "s_min_i32",
> +		[GFX10_S_MIN_U32] = "s_min_u32",
> +		[GFX10_S_MAX_I32] = "s_max_i32",
> +		[GFX10_S_MAX_U32] = "s_max_u32",
> +		[GFX10_S_CSELECT_B32] = "s_cselect_b32",
> +		[GFX10_S_CELECT_B64] = "s_celect_b64",
> +		[GFX10_S_AND_B32] = "s_and_b32",
> +		[GFX10_S_AND_B64] = "s_and_b64",
> +		[GFX10_S_OR_B32] = "s_or_b32",
> +		[GFX10_S_OR_B64] = "s_or_b64",
> +		[GFX10_S_XOR_B32] = "s_xor_b32",
> +		[GFX10_S_XOR_B64] = "s_xor_b64",
> +		[GFX10_S_ANDN2_B32] = "s_andn2_b32",
> +		[GFX10_S_ANDN2_B64] = "s_andn2_b64",
> +		[GFX10_S_ORN2_B32] = "s_orn2_b32",
> +		[GFX10_S_ORN2_B64] = "s_orn2_b64",
> +		[GFX10_S_NAND_B32] = "s_nand_b32",
> +		[GFX10_S_NAND_B64] = "s_nand_b64",
> +		[GFX10_S_NOR_B32] = "s_nor_b32",
> +		[GFX10_S_NOR_B64] = "s_nor_b64",
> +		[GFX10_S_XNOR_B32] = "s_xnor_b32",
> +		[GFX10_S_XNOR_B64] = "s_xnor_b64",
> +		[GFX10_S_LSHL_B32] = "s_lshl_b32",
> +		[GFX10_S_LSHL_B64] = "s_lshl_b64",
> +		[GFX10_S_LSHR_B32] = "s_lshr_b32",
> +		[GFX10_S_LSHR_B64] = "s_lshr_b64",
> +		[GFX10_S_ASHR_I32] = "s_ashr_i32",
> +		[GFX10_S_ASHR_I64] = "s_ashr_i64",
> +		[GFX10_S_BFM_B32] = "s_bfm_b32",
> +		[GFX10_S_BFM_B64] = "s_bfm_b64",
> +		[GFX10_S_MUL_I32] = "s_mul_i32",
> +		[GFX10_S_MUL_I64] = "s_mul_i64",
> +		[GFX10_S_BFE_U32] = "s_bfe_u32",
> +		[GFX10_S_BFE_I32] = "s_bfe_i32",
> +		[GFX10_S_BFE_U64] = "s_bfe_u64",
> +		[GFX10_S_ABSDIFF_I32] = "s_absdiff_i32",
> +		[GFX10_S_LSHL1_ADD_U32] = "s_lshl1_add_u32",
> +		[GFX10_S_LSHL2_ADD_U32] = "s_lshl2_add_u32",
> +		[GFX10_S_LSHL3_ADD_U32] = "s_lshl3_add_u32",
> +		[GFX10_S_LSHL4_ADD_U32] = "s_lshl4_add_u32",
> +		[GFX10_S_PACK_LL_B32_B16] = "s_pack_ll_b32_b16",
> +		[GFX10_S_PACK_LH_B32_B16] = "s_pack_lh_b32_b16",
> +		[GFX10_S_MUL_HI_U32] = "s_mul_hi_u32",
> +		[GFX10_S_MUL_HI_I32] = "s_mul_hi_i32",
> +	},
> +	[AMDGCN_INSN_TYPE_SOPK] = {
> +		[GFX10_S_MOVK_I32] = "s_movk_i32",
> +		[GFX10_S_VERSION] = "s_version",
> +		[GFX10_S_CMOVK_I32] = "s_cmovk_i32",
> +		[GFX10_S_CMPK_EQ_I32] = "s_cmpk_eq_i32",
> +		[GFX10_S_CMPK_LG_I32] = "s_cmpk_lg_i32",
> +		[GFX10_S_CMPK_GT_I32] = "s_cmpk_gt_i32",
> +		[GFX10_S_CMPK_GE_I32] = "s_cmpk_ge_i32",
> +		[GFX10_S_CMPK_LT_I32] = "s_cmpk_lt_i32",
> +		[GFX10_S_CMPK_LE_I32] = "s_cmpk_le_i32",
> +		[GFX10_S_CMPK_EQ_U32] = "s_cmpk_eq_u32",
> +		[GFX10_S_CMPK_LG_U32] = "s_cmpk_lg_u32",
> +		[GFX10_S_CMPK_GT_U32] = "s_cmpk_gt_u32",
> +		[GFX10_S_CMPK_GE_U32] = "s_cmpk_ge_u32",
> +		[GFX10_S_CMPK_LT_U32] = "s_cmpk_lt_u32",
> +		[GFX10_S_CMPK_LE_U32] = "s_cmpk_le_u32",
> +		[GFX10_S_ADDK_I32] = "s_addk_i32",
> +		[GFX10_S_MULK_I32] = "s_mulk_i32",
> +		[GFX10_S_GETREG_B32] = "s_getreg_b32",
> +		[GFX10_S_SETREG_B32] = "s_setreg_b32",
> +		[GFX10_S_SETREG_IMM32_B32] = "s_setreg_imm32_b32",
> +		[GFX10_S_CALL_B64] = "s_call_b64",
> +		[GFX10_S_WAITCNT_VSCNT] = "s_waitcnt_vscnt",
> +		[GFX10_S_WAITCNT_VMCNT] = "s_waitcnt_vmcnt",
> +		[GFX10_S_WAITCNT_EXPCNT] = "s_waitcnt_expcnt",
> +		[GFX10_S_WAITCNT_LGKMCNT] = "s_waitcnt_lgkmcnt",
> +		[GFX10_S_SUBVECTOR_LOOP_BEGIN] = "s_subvector_loop_begin",
> +		[GFX10_S_SUBVECTOR_LOOP_END] = "s_subvector_loop_end",
> +	},
> +	[AMDGCN_INSN_TYPE_SOP1] = {
> +		[GFX10_S_MOV_B32] = "s_mov_b32",
> +		[GFX10_S_MOV_B64] = "s_mov_b64",
> +		[GFX10_S_CMOV_B32] = "s_cmov_b32",
> +		[GFX10_S_CMOV_B64] = "s_cmov_b64",
> +		[GFX10_S_NOT_B32] = "s_not_b32",
> +		[GFX10_S_NOT_B64] = "s_not_b64",
> +		[GFX10_S_WQM_B32] = "s_wqm_b32",
> +		[GFX10_S_WQM_B64] = "s_wqm_b64",
> +		[GFX10_S_BREV_B32] = "s_brev_b32",
> +		[GFX10_S_BREV_B64] = "s_brev_b64",
> +		[GFX10_S_BCNT0_I32_B32] = "s_bcnt0_i32_b32",
> +		[GFX10_S_BCNT0_I32_B64] = "s_bcnt0_i32_b64",
> +		[GFX10_S_BCNT1_I32_B32] = "s_bcnt1_i32_b32",
> +		[GFX10_S_BCNT1_I32_B64] = "s_bcnt1_i32_b64",
> +		[GFX10_S_FF0_I32_B32] = "s_ff0_i32_b32",
> +		[GFX10_S_FF0_I32_B64] = "s_ff0_i32_b64",
> +		[GFX10_S_FF1_I32_B32] = "s_ff1_i32_b32",
> +		[GFX10_S_FF1_I32_B64] = "s_ff1_i32_b64",
> +		[GFX10_S_FLBIT_I32_B32] = "s_flbit_i32_b32",
> +		[GFX10_S_FLBIT_I32_B64] = "s_flbit_i32_b64",
> +		[GFX10_S_FLBIT_I32] = "s_flbit_i32",
> +		[GFX10_S_FLBIT_I32_I64] = "s_flbit_i32_i64",
> +		[GFX10_S_SEXT_I32_I8] = "s_sext_i32_i8",
> +		[GFX10_S_SEXT_I32_I16] = "s_sext_i32_i16",
> +		[GFX10_S_BITSET0_B32] = "s_bitset0_b32",
> +		[GFX10_S_BITSET0_B64] = "s_bitset0_b64",
> +		[GFX10_S_BITSET1_B32] = "s_bitset1_b32",
> +		[GFX10_S_BITSET1_B64] = "s_bitset1_b64",
> +		[GFX10_S_GETPC_B64] = "s_getpc_b64",
> +		[GFX10_S_SETPC_B64] = "s_setpc_b64",
> +		[GFX10_S_SWAPPC_B64] = "s_swappc_b64",
> +		[GFX10_S_RFE_B64] = "s_rfe_b64",
> +		[GFX10_S_AND_SAVEEXEC_B64] = "s_and_saveexec_b64",
> +		[GFX10_S_XNOR_SAVEEXEC_B64] = "s_xnor_saveexec_b64",
> +		[GFX10_S_QUADMASK_B32] = "s_quadmask_b32",
> +		[GFX10_S_QUADMASK_B64] = "s_quadmask_b64",
> +		[GFX10_S_MOVRELS_B32] = "s_movrels_b32",
> +		[GFX10_S_MOVRELS_B64] = "s_movrels_b64",
> +		[GFX10_S_MOVRELD_B32] = "s_movreld_b32",
> +		[GFX10_S_MOVRELD_B64] = "s_movreld_b64",
> +		[GFX10_S_ABS_I32] = "s_abs_i32",
> +		[GFX10_S_ANDN1_SAVEEXEC_B64] = "s_andn1_saveexec_b64",
> +		[GFX10_S_ORN1_SAVEEXEC_B64] = "s_orn1_saveexec_b64",
> +		[GFX10_S_ANDN1_WREXEC_B64] = "s_andn1_wrexec_b64",
> +		[GFX10_S_ANDN2_WREXEC_B64] = "s_andn2_wrexec_b64",
> +		[GFX10_S_BITREPLICATE_B64_B32] = "s_bitreplicate_b64_b32",
> +		[GFX10_S_AND_SAVEEXEC_B32] = "s_and_saveexec_b32",
> +		[GFX10_S_OR_SAVEEXEC_B32] = "s_or_saveexec_b32",
> +		[GFX10_S_XOR_SAVEEXEC_B32] = "s_xor_saveexec_b32",
> +		[GFX10_S_ANDN2_SAVEEXEC_B32] = "s_andn2_saveexec_b32",
> +		[GFX10_S_ORN2_SAVEEXEC_B32] = "s_orn2_saveexec_b32",
> +		[GFX10_S_NAND_SAVEEXEC_B32] = "s_nand_saveexec_b32",
> +		[GFX10_S_NOR_SAVEEXEC_B32] = "s_nor_saveexec_b32",
> +		[GFX10_S_XNOR_SAVEEXEC_B32] = "s_xnor_saveexec_b32",
> +		[GFX10_S_ANDN1_SAVEEXEC_B32] = "s_andn1_saveexec_b32",
> +		[GFX10_S_ORN1_SAVEEXEC_B32] = "s_orn1_saveexec_b32",
> +		[GFX10_S_ANDN1_WREXEC_B32] = "s_andn1_wrexec_b32",
> +		[GFX10_S_ANDN2_WREXEC_B32] = "s_andn2_wrexec_b32",
> +		[GFX10_S_MOVRELSD_2_B32] = "s_movrelsd_2_b32",
> +	},
> +	[AMDGCN_INSN_TYPE_SOPC] = {
> +		[GFX10_S_CMP_EQ_I32] = "s_cmp_eq_i32",
> +		[GFX10_S_CMP_LG_I32] = "s_cmp_lg_i32",
> +		[GFX10_S_CMP_GT_I32] = "s_cmp_gt_i32",
> +		[GFX10_S_CMP_GE_I32] = "s_cmp_ge_i32",
> +		[GFX10_S_CMP_LT_I32] = "s_cmp_lt_i32",
> +		[GFX10_S_CMP_LE_I32] = "s_cmp_le_i32",
> +		[GFX10_S_CMP_EQ_U32] = "s_cmp_eq_u32",
> +		[GFX10_S_CMP_LG_U32] = "s_cmp_lg_u32",
> +		[GFX10_S_CMP_GT_U32] = "s_cmp_gt_u32",
> +		[GFX10_S_CMP_GE_U32] = "s_cmp_ge_u32",
> +		[GFX10_S_CMP_LT_U32] = "s_cmp_lt_u32",
> +		[GFX10_S_CMP_LE_U32] = "s_cmp_le_u32",
> +		[GFX10_S_BITCMP0_B32] = "s_bitcmp0_b32",
> +		[GFX10_S_BITCMP1_B32] = "s_bitcmp1_b32",
> +		[GFX10_S_BITCMP0_B64] = "s_bitcmp0_b64",
> +		[GFX10_S_BITCMP1_B64] = "s_bitcmp1_b64",
> +		[GFX10_S_CMP_EQ_U64] = "s_cmp_eq_u64",
> +		[GFX10_S_CMP_LG_U64] = "s_cmp_lg_u64",
> +	},
> +	[AMDGCN_INSN_TYPE_SOPP] = {
> +		[GFX10_S_NOP] = "s_nop",
> +		[GFX10_S_ENDPGM] = "s_endpgm",
> +		[GFX10_S_BRANCH] = "s_branch",
> +		[GFX10_S_WAKEUP] = "s_wakeup",
> +		[GFX10_S_CBRANCH_SCC0] = "s_cbranch_scc0",
> +		[GFX10_S_CBRANCH_SCC1] = "s_cbranch_scc1",
> +		[GFX10_S_CBRANCH_VCCZ] = "s_cbranch_vccz",
> +		[GFX10_S_CBRANCH_VCCNZ] = "s_cbranch_vccnz",
> +		[GFX10_S_CBRANCH_EXECZ] = "s_cbranch_execz",
> +		[GFX10_S_CBRANCH_EXECNZ] = "s_cbranch_execnz",
> +		[GFX10_S_BARRIER] = "s_barrier",
> +		[GFX10_S_SETKILL] = "s_setkill",
> +		[GFX10_S_WAITCNT] = "s_waitcnt",
> +		[GFX10_S_SETHALT] = "s_sethalt",
> +		[GFX10_S_SLEEP] = "s_sleep",
> +		[GFX10_S_SETPRIO] = "s_setprio",
> +		[GFX10_S_SENDMSG] = "s_sendmsg",
> +		[GFX10_S_SENDMSGHALT] = "s_sendmsghalt",
> +		[GFX10_S_TRAP] = "s_trap",
> +		[GFX10_S_ICACHE_INV] = "s_icache_inv",
> +		[GFX10_S_INCPERFLEVEL] = "s_incperflevel",
> +		[GFX10_S_DECPERFLEVEL] = "s_decperflevel",
> +		[GFX10_S_TTRACEDATA] = "s_ttracedata",
> +		[GFX10_S_CBRANCH_CDBGSYS] = "s_cbranch_cdbgsys",
> +		[GFX10_S_CBRANCH_CDBGUSER] = "s_cbranch_cdbguser",
> +		[GFX10_S_CBRANCH_CDBGSYS_OR_USER] = "s_cbranch_cdbgsys_or_user",
> +		[GFX10_S_CBRANCH_CDBGSYS_AND_USER] = "s_cbranch_cdbgsys_and_user",
> +		[GFX10_S_ENDPGM_SAVED] = "s_endpgm_saved",
> +		[GFX10_S_ENDPGM_ORDERED_PS_DONE] = "s_endpgm_ordered_ps_done",
> +		[GFX10_S_CODE_END] = "s_code_end",
> +		[GFX10_S_INST_PREFETCH] = "s_inst_prefetch",
> +		[GFX10_S_CLAUSE] = "s_clause",
> +		[GFX10_S_WAITCNT_DEPCTR] = "s_waitcnt_depctr",
> +		[GFX10_S_ROUND_MODE] = "s_round_mode",
> +		[GFX10_S_DENORM_MODE] = "s_denorm_mode",
> +		[GFX10_S_TTRACEDATA_IMM] = "s_ttracedata_imm",
> +	},
> +	[AMDGCN_INSN_TYPE_SMEM] = {
> +		[GFX10_S_LOAD_DWORD] = "s_load_dword",
> +		[GFX10_S_LOAD_DWORDX2] = "s_load_dwordx2",
> +		[GFX10_S_LOAD_DWORDX4] = "s_load_dwordx4",
> +		[GFX10_S_LOAD_DWORDX8] = "s_load_dwordx8",
> +		[GFX10_S_LOAD_DWORDX16] = "s_load_dwordx16",
> +		[GFX10_S_BUFFER_LOAD_DWORD] = "s_buffer_load_dword",
> +		[GFX10_S_BUFFER_LOAD_DWORDX2] = "s_buffer_load_dwordx2",
> +		[GFX10_S_BUFFER_LOAD_DWORDX4] = "s_buffer_load_dwordx4",
> +		[GFX10_S_BUFFER_LOAD_DWORDX8] = "s_buffer_load_dwordx8",
> +		[GFX10_S_BUFFER_LOAD_DWORDX16] = "s_buffer_load_dwordx16",
> +		[GFX10_S_GL1_INV] = "s_gl1_inv",
> +		[GFX10_S_DCACHE_INV] = "s_dcache_inv",
> +		[GFX10_S_MEMTIME] = "s_memtime",
> +		[GFX10_S_MEMREALTIME] = "s_memrealtime",
> +		[GFX10_S_ATC_PROBE] = "s_atc_probe",
> +		[GFX10_S_ATC_PROBE_BUFFER] = "s_atc_probe_buffer",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP2] = {
> +		[GFX10_V_CNDMASK_B32] = "v_cndmask_b32",
> +		[GFX10_V_DOT2C_F32_F16] = "v_dot2c_f32_f16",
> +		[GFX10_V_ADD_F32] = "v_add_f32",
> +		[GFX10_V_SUB_F32] = "v_sub_f32",
> +		[GFX10_V_SUBREV_F32] = "v_subrev_f32",
> +		[GFX10_V_FMAC_LEGACY_F32] = "v_fmac_legacy_f32",
> +		[GFX10_V_MUL_LEGACY_F32] = "v_mul_legacy_f32",
> +		[GFX10_V_MUL_F32] = "v_mul_f32",
> +		[GFX10_V_MUL_I32_I24] = "v_mul_i32_i24",
> +		[GFX10_V_MUL_HI_I32_I24] = "v_mul_hi_i32_i24",
> +		[GFX10_V_MUL_U32_U24] = "v_mul_u32_u24",
> +		[GFX10_V_MUL_HI_U32_U24] = "v_mul_hi_u32_u24",
> +		[GFX10_V_DOT4C_I32_I8] = "v_dot4c_i32_i8",
> +		[GFX10_V_MIN_F32] = "v_min_f32",
> +		[GFX10_V_MAX_F32] = "v_max_f32",
> +		[GFX10_V_MIN_I32] = "v_min_i32",
> +		[GFX10_V_MAX_I32] = "v_max_i32",
> +		[GFX10_V_MIN_U32] = "v_min_u32",
> +		[GFX10_V_MAX_U32] = "v_max_u32",
> +		[GFX10_V_LSHRREV_B32] = "v_lshrrev_b32",
> +		[GFX10_V_ASHRREV_I32] = "v_ashrrev_i32",
> +		[GFX10_V_LSHLREV_B32] = "v_lshlrev_b32",
> +		[GFX10_V_AND_B32] = "v_and_b32",
> +		[GFX10_V_OR_B32] = "v_or_b32",
> +		[GFX10_V_XOR_B32] = "v_xor_b32",
> +		[GFX10_V_XNOR_B32] = "v_xnor_b32",
> +		[GFX10_V_ADD_NC_U32] = "v_add_nc_u32",
> +		[GFX10_V_SUB_NC_U32] = "v_sub_nc_u32",
> +		[GFX10_V_SUBREV_NC_U32] = "v_subrev_nc_u32",
> +		[GFX10_V_ADD_CO_CI_U32] = "v_add_co_ci_u32",
> +		[GFX10_V_SUB_CO_CI_U32] = "v_sub_co_ci_u32",
> +		[GFX10_V_SUBREV_CO_CI_U32] = "v_subrev_co_ci_u32",
> +		[GFX10_V_FMAC_F32] = "v_fmac_f32",
> +		[GFX10_V_FMAMK_F32] = "v_fmamk_f32",
> +		[GFX10_V_FMAAK_F32] = "v_fmaak_f32",
> +		[GFX10_V_CVT_PKRTZ_F16_F32] = "v_cvt_pkrtz_f16_f32",
> +		[GFX10_V_ADD_F16] = "v_add_f16",
> +		[GFX10_V_SUB_F16] = "v_sub_f16",
> +		[GFX10_V_SUBREV_F16] = "v_subrev_f16",
> +		[GFX10_V_MUL_F16] = "v_mul_f16",
> +		[GFX10_V_FMAC_F16] = "v_fmac_f16",
> +		[GFX10_V_FMAMK_F16] = "v_fmamk_f16",
> +		[GFX10_V_FMAAK_F16] = "v_fmaak_f16",
> +		[GFX10_V_MAX_F16] = "v_max_f16",
> +		[GFX10_V_MIN_F16] = "v_min_f16",
> +		[GFX10_V_LDEXP_F16] = "v_ldexp_f16",
> +		[GFX10_V_PK_FMAC_F16] = "v_pk_fmac_f16",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP1] = {
> +		[GFX10_V_NOP] = "v_nop",
> +		[GFX10_V_MOV_B32] = "v_mov_b32",
> +		[GFX10_V_READFIRSTLANE_B32] = "v_readfirstlane_b32",
> +		[GFX10_V_CVT_I32_F64] = "v_cvt_i32_f64",
> +		[GFX10_V_CVT_F64_I32] = "v_cvt_f64_i32",
> +		[GFX10_V_CVT_F32_I32] = "v_cvt_f32_i32",
> +		[GFX10_V_CVT_F32_U32] = "v_cvt_f32_u32",
> +		[GFX10_V_CVT_U32_F32] = "v_cvt_u32_f32",
> +		[GFX10_V_CVT_I32_F32] = "v_cvt_i32_f32",
> +		[GFX10_V_CVT_F16_F32] = "v_cvt_f16_f32",
> +		[GFX10_V_CVT_F32_F16] = "v_cvt_f32_f16",
> +		[GFX10_V_CVT_RPI_I32_F32] = "v_cvt_rpi_i32_f32",
> +		[GFX10_V_CVT_FLR_I32_F32] = "v_cvt_flr_i32_f32",
> +		[GFX10_V_CVT_OFF_F32_I4] = "v_cvt_off_f32_i4",
> +		[GFX10_V_CVT_F32_F64] = "v_cvt_f32_f64",
> +		[GFX10_V_CVT_F64_F32] = "v_cvt_f64_f32",
> +		[GFX10_V_CVT_F32_UBYTE0] = "v_cvt_f32_ubyte0",
> +		[GFX10_V_CVT_F32_UBYTE1] = "v_cvt_f32_ubyte1",
> +		[GFX10_V_CVT_F32_UBYTE2] = "v_cvt_f32_ubyte2",
> +		[GFX10_V_CVT_F32_UBYTE3] = "v_cvt_f32_ubyte3",
> +		[GFX10_V_CVT_U32_F64] = "v_cvt_u32_f64",
> +		[GFX10_V_CVT_F64_U32] = "v_cvt_f64_u32",
> +		[GFX10_V_TRUNC_F64] = "v_trunc_f64",
> +		[GFX10_V_CEIL_F64] = "v_ceil_f64",
> +		[GFX10_V_RNDNE_F64] = "v_rndne_f64",
> +		[GFX10_V_FLOOR_F64] = "v_floor_f64",
> +		[GFX10_V_PIPEFLUSH] = "v_pipeflush",
> +		[GFX10_V_FRACT_F32] = "v_fract_f32",
> +		[GFX10_V_TRUNC_F32] = "v_trunc_f32",
> +		[GFX10_V_CEIL_F32] = "v_ceil_f32",
> +		[GFX10_V_RNDNE_F32] = "v_rndne_f32",
> +		[GFX10_V_FLOOR_F32] = "v_floor_f32",
> +		[GFX10_V_EXP_F32] = "v_exp_f32",
> +		[GFX10_V_LOG_F32] = "v_log_f32",
> +		[GFX10_V_RCP_F32] = "v_rcp_f32",
> +		[GFX10_V_RCP_IFLAG_F32] = "v_rcp_iflag_f32",
> +		[GFX10_V_RSQ_F32] = "v_rsq_f32",
> +		[GFX10_V_RCP_F64] = "v_rcp_f64",
> +		[GFX10_V_RSQ_F64] = "v_rsq_f64",
> +		[GFX10_V_SQRT_F32] = "v_sqrt_f32",
> +		[GFX10_V_SQRT_F64] = "v_sqrt_f64",
> +		[GFX10_V_SIN_F32] = "v_sin_f32",
> +		[GFX10_V_COS_F32] = "v_cos_f32",
> +		[GFX10_V_NOT_B32] = "v_not_b32",
> +		[GFX10_V_BFREV_B32] = "v_bfrev_b32",
> +		[GFX10_V_FFBH_U32] = "v_ffbh_u32",
> +		[GFX10_V_FFBL_B32] = "v_ffbl_b32",
> +		[GFX10_V_FFBH_I32] = "v_ffbh_i32",
> +		[GFX10_V_FREXP_EXP_I32_F64] = "v_frexp_exp_i32_f64",
> +		[GFX10_V_FREXP_MANT_F64] = "v_frexp_mant_f64",
> +		[GFX10_V_FRACT_F64] = "v_fract_f64",
> +		[GFX10_V_FREXP_EXP_I32_F32] = "v_frexp_exp_i32_f32",
> +		[GFX10_V_FREXP_MANT_F32] = "v_frexp_mant_f32",
> +		[GFX10_V_CLREXCP] = "v_clrexcp",
> +		[GFX10_V_MOVRELD_B32] = "v_movreld_b32",
> +		[GFX10_V_MOVRELS_B32] = "v_movrels_b32",
> +		[GFX10_V_MOVRELSD_B32] = "v_movrelsd_b32",
> +		[GFX10_V_MOVRELSD_2_B32] = "v_movrelsd_2_b32",
> +		[GFX10_V_CVT_F16_U16] = "v_cvt_f16_u16",
> +		[GFX10_V_CVT_F16_I16] = "v_cvt_f16_i16",
> +		[GFX10_V_CVT_U16_F16] = "v_cvt_u16_f16",
> +		[GFX10_V_CVT_I16_F16] = "v_cvt_i16_f16",
> +		[GFX10_V_RCP_F16] = "v_rcp_f16",
> +		[GFX10_V_SQRT_F16] = "v_sqrt_f16",
> +		[GFX10_V_RSQ_F16] = "v_rsq_f16",
> +		[GFX10_V_LOG_F16] = "v_log_f16",
> +		[GFX10_V_EXP_F16] = "v_exp_f16",
> +		[GFX10_V_FREXP_MANT_F16] = "v_frexp_mant_f16",
> +		[GFX10_V_FREXP_EXP_I16_F16] = "v_frexp_exp_i16_f16",
> +		[GFX10_V_FLOOR_F16] = "v_floor_f16",
> +		[GFX10_V_CEIL_F16] = "v_ceil_f16",
> +		[GFX10_V_TRUNC_F16] = "v_trunc_f16",
> +		[GFX10_V_RNDNE_F16] = "v_rndne_f16",
> +		[GFX10_V_FRACT_F16] = "v_fract_f16",
> +		[GFX10_V_SIN_F16] = "v_sin_f16",
> +		[GFX10_V_COS_F16] = "v_cos_f16",
> +		[GFX10_V_SAT_PK_U8_I16] = "v_sat_pk_u8_i16",
> +		[GFX10_V_CVT_NORM_I16_F16] = "v_cvt_norm_i16_f16",
> +		[GFX10_V_CVT_NORM_U16_F16] = "v_cvt_norm_u16_f16",
> +		[GFX10_V_SWAP_B32] = "v_swap_b32",
> +		[GFX10_V_SWAPREL_B32] = "v_swaprel_b32",
> +	},
> +	[AMDGCN_INSN_TYPE_VOPC] = {
> +		[GFX10_V_CMP_F_F32] = "v_cmp_f_f32",
> +		[GFX10_V_CMP_LT_F32] = "v_cmp_lt_f32",
> +		[GFX10_V_CMP_EQ_F32] = "v_cmp_eq_f32",
> +		[GFX10_V_CMP_LE_F32] = "v_cmp_le_f32",
> +		[GFX10_V_CMP_GT_F32] = "v_cmp_gt_f32",
> +		[GFX10_V_CMP_LG_F32] = "v_cmp_lg_f32",
> +		[GFX10_V_CMP_GE_F32] = "v_cmp_ge_f32",
> +		[GFX10_V_CMP_O_F32] = "v_cmp_o_f32",
> +		[GFX10_V_CMP_U_F32] = "v_cmp_u_f32",
> +		[GFX10_V_CMP_NGE_F32] = "v_cmp_nge_f32",
> +		[GFX10_V_CMP_NLG_F32] = "v_cmp_nlg_f32",
> +		[GFX10_V_CMP_NGT_F32] = "v_cmp_ngt_f32",
> +		[GFX10_V_CMP_NLE_F32] = "v_cmp_nle_f32",
> +		[GFX10_V_CMP_NEQ_F32] = "v_cmp_neq_f32",
> +		[GFX10_V_CMP_NLT_F32] = "v_cmp_nlt_f32",
> +		[GFX10_V_CMP_TRU_F32] = "v_cmp_tru_f32",
> +		[GFX10_V_CMPX_F_F32] = "v_cmpx_f_f32",
> +		[GFX10_V_CMPX_LT_F32] = "v_cmpx_lt_f32",
> +		[GFX10_V_CMPX_EQ_F32] = "v_cmpx_eq_f32",
> +		[GFX10_V_CMPX_LE_F32] = "v_cmpx_le_f32",
> +		[GFX10_V_CMPX_GT_F32] = "v_cmpx_gt_f32",
> +		[GFX10_V_CMPX_LG_F32] = "v_cmpx_lg_f32",
> +		[GFX10_V_CMPX_GE_F32] = "v_cmpx_ge_f32",
> +		[GFX10_V_CMPX_O_F32] = "v_cmpx_o_f32",
> +		[GFX10_V_CMPX_U_F32] = "v_cmpx_u_f32",
> +		[GFX10_V_CMPX_NGE_F32] = "v_cmpx_nge_f32",
> +		[GFX10_V_CMPX_NLG_F32] = "v_cmpx_nlg_f32",
> +		[GFX10_V_CMPX_NGT_F32] = "v_cmpx_ngt_f32",
> +		[GFX10_V_CMPX_NLE_F32] = "v_cmpx_nle_f32",
> +		[GFX10_V_CMPX_NEQ_F32] = "v_cmpx_neq_f32",
> +		[GFX10_V_CMPX_NLT_F32] = "v_cmpx_nlt_f32",
> +		[GFX10_V_CMPX_TRU_F32] = "v_cmpx_tru_f32",
> +		[GFX10_V_CMP_F_F64] = "v_cmp_f_f64",
> +		[GFX10_V_CMP_LT_F64] = "v_cmp_lt_f64",
> +		[GFX10_V_CMP_EQ_F64] = "v_cmp_eq_f64",
> +		[GFX10_V_CMP_LE_F64] = "v_cmp_le_f64",
> +		[GFX10_V_CMP_GT_F64] = "v_cmp_gt_f64",
> +		[GFX10_V_CMP_LG_F64] = "v_cmp_lg_f64",
> +		[GFX10_V_CMP_GE_F64] = "v_cmp_ge_f64",
> +		[GFX10_V_CMP_O_F64] = "v_cmp_o_f64",
> +		[GFX10_V_CMP_U_F64] = "v_cmp_u_f64",
> +		[GFX10_V_CMP_NGE_F64] = "v_cmp_nge_f64",
> +		[GFX10_V_CMP_NLG_F64] = "v_cmp_nlg_f64",
> +		[GFX10_V_CMP_NGT_F64] = "v_cmp_ngt_f64",
> +		[GFX10_V_CMP_NLE_F64] = "v_cmp_nle_f64",
> +		[GFX10_V_CMP_NEQ_F64] = "v_cmp_neq_f64",
> +		[GFX10_V_CMP_NLT_F64] = "v_cmp_nlt_f64",
> +		[GFX10_V_CMP_TRU_F64] = "v_cmp_tru_f64",
> +		[GFX10_V_CMPX_F_F64] = "v_cmpx_f_f64",
> +		[GFX10_V_CMPX_LT_F64] = "v_cmpx_lt_f64",
> +		[GFX10_V_CMPX_EQ_F64] = "v_cmpx_eq_f64",
> +		[GFX10_V_CMPX_LE_F64] = "v_cmpx_le_f64",
> +		[GFX10_V_CMPX_GT_F64] = "v_cmpx_gt_f64",
> +		[GFX10_V_CMPX_LG_F64] = "v_cmpx_lg_f64",
> +		[GFX10_V_CMPX_GE_F64] = "v_cmpx_ge_f64",
> +		[GFX10_V_CMPX_O_F64] = "v_cmpx_o_f64",
> +		[GFX10_V_CMPX_U_F64] = "v_cmpx_u_f64",
> +		[GFX10_V_CMPX_NGE_F64] = "v_cmpx_nge_f64",
> +		[GFX10_V_CMPX_NLG_F64] = "v_cmpx_nlg_f64",
> +		[GFX10_V_CMPX_NGT_F64] = "v_cmpx_ngt_f64",
> +		[GFX10_V_CMPX_NLE_F64] = "v_cmpx_nle_f64",
> +		[GFX10_V_CMPX_NEQ_F64] = "v_cmpx_neq_f64",
> +		[GFX10_V_CMPX_NLT_F64] = "v_cmpx_nlt_f64",
> +		[GFX10_V_CMPX_TRU_F64] = "v_cmpx_tru_f64",
> +		[GFX10_V_CMP_F_I32] = "v_cmp_f_i32",
> +		[GFX10_V_CMP_LT_I32] = "v_cmp_lt_i32",
> +		[GFX10_V_CMP_EQ_I32] = "v_cmp_eq_i32",
> +		[GFX10_V_CMP_LE_I32] = "v_cmp_le_i32",
> +		[GFX10_V_CMP_GT_I32] = "v_cmp_gt_i32",
> +		[GFX10_V_CMP_NE_I32] = "v_cmp_ne_i32",
> +		[GFX10_V_CMP_GE_I32] = "v_cmp_ge_i32",
> +		[GFX10_V_CMP_T_I32] = "v_cmp_t_i32",
> +		[GFX10_V_CMP_CLASS_F32] = "v_cmp_class_f32",
> +		[GFX10_V_CMP_LT_I16] = "v_cmp_lt_i16",
> +		[GFX10_V_CMP_EQ_I16] = "v_cmp_eq_i16",
> +		[GFX10_V_CMP_LE_I16] = "v_cmp_le_i16",
> +		[GFX10_V_CMP_GT_I16] = "v_cmp_gt_i16",
> +		[GFX10_V_CMP_NE_I16] = "v_cmp_ne_i16",
> +		[GFX10_V_CMP_GE_I16] = "v_cmp_ge_i16",
> +		[GFX10_V_CMP_CLASS_F16] = "v_cmp_class_f16",
> +		[GFX10_V_CMPX_F_I32] = "v_cmpx_f_i32",
> +		[GFX10_V_CMPX_LT_I32] = "v_cmpx_lt_i32",
> +		[GFX10_V_CMPX_EQ_I32] = "v_cmpx_eq_i32",
> +		[GFX10_V_CMPX_LE_I32] = "v_cmpx_le_i32",
> +		[GFX10_V_CMPX_GT_I32] = "v_cmpx_gt_i32",
> +		[GFX10_V_CMPX_NE_I32] = "v_cmpx_ne_i32",
> +		[GFX10_V_CMPX_GE_I32] = "v_cmpx_ge_i32",
> +		[GFX10_V_CMPX_T_I32] = "v_cmpx_t_i32",
> +		[GFX10_V_CMPX_CLASS_F32] = "v_cmpx_class_f32",
> +		[GFX10_V_CMPX_LT_I16] = "v_cmpx_lt_i16",
> +		[GFX10_V_CMPX_EQ_I16] = "v_cmpx_eq_i16",
> +		[GFX10_V_CMPX_LE_I16] = "v_cmpx_le_i16",
> +		[GFX10_V_CMPX_GT_I16] = "v_cmpx_gt_i16",
> +		[GFX10_V_CMPX_NE_I16] = "v_cmpx_ne_i16",
> +		[GFX10_V_CMPX_GE_I16] = "v_cmpx_ge_i16",
> +		[GFX10_V_CMPX_CLASS_F16] = "v_cmpx_class_f16",
> +		[GFX10_V_CMP_F_I64] = "v_cmp_f_i64",
> +		[GFX10_V_CMP_LT_I64] = "v_cmp_lt_i64",
> +		[GFX10_V_CMP_EQ_I64] = "v_cmp_eq_i64",
> +		[GFX10_V_CMP_LE_I64] = "v_cmp_le_i64",
> +		[GFX10_V_CMP_GT_I64] = "v_cmp_gt_i64",
> +		[GFX10_V_CMP_NE_I64] = "v_cmp_ne_i64",
> +		[GFX10_V_CMP_GE_I64] = "v_cmp_ge_i64",
> +		[GFX10_V_CMP_T_I64] = "v_cmp_t_i64",
> +		[GFX10_V_CMP_CLASS_F64] = "v_cmp_class_f64",
> +		[GFX10_V_CMP_LT_U16] = "v_cmp_lt_u16",
> +		[GFX10_V_CMP_EQ_U16] = "v_cmp_eq_u16",
> +		[GFX10_V_CMP_LE_U16] = "v_cmp_le_u16",
> +		[GFX10_V_CMP_GT_U16] = "v_cmp_gt_u16",
> +		[GFX10_V_CMP_NE_U16] = "v_cmp_ne_u16",
> +		[GFX10_V_CMP_GE_U16] = "v_cmp_ge_u16",
> +		[GFX10_V_CMPX_F_I64] = "v_cmpx_f_i64",
> +		[GFX10_V_CMPX_LT_I64] = "v_cmpx_lt_i64",
> +		[GFX10_V_CMPX_EQ_I64] = "v_cmpx_eq_i64",
> +		[GFX10_V_CMPX_LE_I64] = "v_cmpx_le_i64",
> +		[GFX10_V_CMPX_GT_I64] = "v_cmpx_gt_i64",
> +		[GFX10_V_CMPX_NE_I64] = "v_cmpx_ne_i64",
> +		[GFX10_V_CMPX_GE_I64] = "v_cmpx_ge_i64",
> +		[GFX10_V_CMPX_T_I64] = "v_cmpx_t_i64",
> +		[GFX10_V_CMPX_CLASS_F64] = "v_cmpx_class_f64",
> +		[GFX10_V_CMPX_LT_U16] = "v_cmpx_lt_u16",
> +		[GFX10_V_CMPX_EQ_U16] = "v_cmpx_eq_u16",
> +		[GFX10_V_CMPX_LE_U16] = "v_cmpx_le_u16",
> +		[GFX10_V_CMPX_GT_U16] = "v_cmpx_gt_u16",
> +		[GFX10_V_CMPX_NE_U16] = "v_cmpx_ne_u16",
> +		[GFX10_V_CMPX_GE_U16] = "v_cmpx_ge_u16",
> +		[GFX10_V_CMP_F_U32] = "v_cmp_f_u32",
> +		[GFX10_V_CMP_LT_U32] = "v_cmp_lt_u32",
> +		[GFX10_V_CMP_EQ_U32] = "v_cmp_eq_u32",
> +		[GFX10_V_CMP_LE_U32] = "v_cmp_le_u32",
> +		[GFX10_V_CMP_GT_U32] = "v_cmp_gt_u32",
> +		[GFX10_V_CMP_NE_U32] = "v_cmp_ne_u32",
> +		[GFX10_V_CMP_GE_U32] = "v_cmp_ge_u32",
> +		[GFX10_V_CMP_T_U32] = "v_cmp_t_u32",
> +		[GFX10_V_CMP_F_F16] = "v_cmp_f_f16",
> +		[GFX10_V_CMP_LT_F16] = "v_cmp_lt_f16",
> +		[GFX10_V_CMP_EQ_F16] = "v_cmp_eq_f16",
> +		[GFX10_V_CMP_LE_F16] = "v_cmp_le_f16",
> +		[GFX10_V_CMP_GT_F16] = "v_cmp_gt_f16",
> +		[GFX10_V_CMP_LG_F16] = "v_cmp_lg_f16",
> +		[GFX10_V_CMP_GE_F16] = "v_cmp_ge_f16",
> +		[GFX10_V_CMP_O_F16] = "v_cmp_o_f16",
> +		[GFX10_V_CMPX_F_U32] = "v_cmpx_f_u32",
> +		[GFX10_V_CMPX_LT_U32] = "v_cmpx_lt_u32",
> +		[GFX10_V_CMPX_EQ_U32] = "v_cmpx_eq_u32",
> +		[GFX10_V_CMPX_LE_U32] = "v_cmpx_le_u32",
> +		[GFX10_V_CMPX_GT_U32] = "v_cmpx_gt_u32",
> +		[GFX10_V_CMPX_NE_U32] = "v_cmpx_ne_u32",
> +		[GFX10_V_CMPX_GE_U32] = "v_cmpx_ge_u32",
> +		[GFX10_V_CMPX_T_U32] = "v_cmpx_t_u32",
> +		[GFX10_V_CMPX_F_F16] = "v_cmpx_f_f16",
> +		[GFX10_V_CMPX_LT_F16] = "v_cmpx_lt_f16",
> +		[GFX10_V_CMPX_EQ_F16] = "v_cmpx_eq_f16",
> +		[GFX10_V_CMPX_LE_F16] = "v_cmpx_le_f16",
> +		[GFX10_V_CMPX_GT_F16] = "v_cmpx_gt_f16",
> +		[GFX10_V_CMPX_LG_F16] = "v_cmpx_lg_f16",
> +		[GFX10_V_CMPX_GE_F16] = "v_cmpx_ge_f16",
> +		[GFX10_V_CMPX_O_F16] = "v_cmpx_o_f16",
> +		[GFX10_V_CMP_F_U64] = "v_cmp_f_u64",
> +		[GFX10_V_CMP_LT_U64] = "v_cmp_lt_u64",
> +		[GFX10_V_CMP_EQ_U64] = "v_cmp_eq_u64",
> +		[GFX10_V_CMP_LE_U64] = "v_cmp_le_u64",
> +		[GFX10_V_CMP_GT_U64] = "v_cmp_gt_u64",
> +		[GFX10_V_CMP_NE_U64] = "v_cmp_ne_u64",
> +		[GFX10_V_CMP_GE_U64] = "v_cmp_ge_u64",
> +		[GFX10_V_CMP_T_U64] = "v_cmp_t_u64",
> +		[GFX10_V_CMP_U_F16] = "v_cmp_u_f16",
> +		[GFX10_V_CMP_NGE_F16] = "v_cmp_nge_f16",
> +		[GFX10_V_CMP_NLG_F16] = "v_cmp_nlg_f16",
> +		[GFX10_V_CMP_NGT_F16] = "v_cmp_ngt_f16",
> +		[GFX10_V_CMP_NLE_F16] = "v_cmp_nle_f16",
> +		[GFX10_V_CMP_NEQ_F16] = "v_cmp_neq_f16",
> +		[GFX10_V_CMP_NLT_F16] = "v_cmp_nlt_f16",
> +		[GFX10_V_CMP_TRU_F16] = "v_cmp_tru_f16",
> +		[GFX10_V_CMPX_F_U64] = "v_cmpx_f_u64",
> +		[GFX10_V_CMPX_LT_U64] = "v_cmpx_lt_u64",
> +		[GFX10_V_CMPX_EQ_U64] = "v_cmpx_eq_u64",
> +		[GFX10_V_CMPX_LE_U64] = "v_cmpx_le_u64",
> +		[GFX10_V_CMPX_GT_U64] = "v_cmpx_gt_u64",
> +		[GFX10_V_CMPX_NE_U64] = "v_cmpx_ne_u64",
> +		[GFX10_V_CMPX_GE_U64] = "v_cmpx_ge_u64",
> +		[GFX10_V_CMPX_T_U64] = "v_cmpx_t_u64",
> +		[GFX10_V_CMPX_U_F16] = "v_cmpx_u_f16",
> +		[GFX10_V_CMPX_NGE_F16] = "v_cmpx_nge_f16",
> +		[GFX10_V_CMPX_NLG_F16] = "v_cmpx_nlg_f16",
> +		[GFX10_V_CMPX_NGT_F16] = "v_cmpx_ngt_f16",
> +		[GFX10_V_CMPX_NLE_F16] = "v_cmpx_nle_f16",
> +		[GFX10_V_CMPX_NEQ_F16] = "v_cmpx_neq_f16",
> +		[GFX10_V_CMPX_NLT_F16] = "v_cmpx_nlt_f16",
> +		[GFX10_V_CMPX_TRU_F16] = "v_cmpx_tru_f16",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP3B] = {
> +		[GFX10_V_DIV_SCALE_F32] = "v_div_scale_f32",
> +		[GFX10_V_DIV_SCALE_F64] = "v_div_scale_f64",
> +		[GFX10_V_MAD_U64_U32] = "v_mad_u64_u32",
> +		[GFX10_V_MAD_I64_I32] = "v_mad_i64_i32",
> +		[GFX10_V_ADD_CO_U32] = "v_add_co_u32",
> +		[GFX10_V_SUB_CO_U32] = "v_sub_co_u32",
> +		[GFX10_V_SUBREV_CO_U32] = "v_subrev_co_u32",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP3P] = {
> +		[GFX10_V_PK_MAD_I16] = "v_pk_mad_i16",
> +		[GFX10_V_PK_MUL_LO_U16] = "v_pk_mul_lo_u16",
> +		[GFX10_V_PK_ADD_I16] = "v_pk_add_i16",
> +		[GFX10_V_PK_SUB_I16] = "v_pk_sub_i16",
> +		[GFX10_V_PK_LSHLREV_B16] = "v_pk_lshlrev_b16",
> +		[GFX10_V_PK_LSHRREV_B16] = "v_pk_lshrrev_b16",
> +		[GFX10_V_PK_ASHRREV_I16] = "v_pk_ashrrev_i16",
> +		[GFX10_V_PK_MAX_I16] = "v_pk_max_i16",
> +		[GFX10_V_PK_MIN_I16] = "v_pk_min_i16",
> +		[GFX10_V_PK_MAD_U16] = "v_pk_mad_u16",
> +		[GFX10_V_PK_ADD_U16] = "v_pk_add_u16",
> +		[GFX10_V_PK_SUB_U16] = "v_pk_sub_u16",
> +		[GFX10_V_PK_MAX_U16] = "v_pk_max_u16",
> +		[GFX10_V_PK_MIN_U16] = "v_pk_min_u16",
> +		[GFX10_V_PK_FMA_F16] = "v_pk_fma_f16",
> +		[GFX10_V_PK_ADD_F16] = "v_pk_add_f16",
> +		[GFX10_V_PK_MUL_F16] = "v_pk_mul_f16",
> +		[GFX10_V_PK_MIN_F16] = "v_pk_min_f16",
> +		[GFX10_V_PK_MAX_F16] = "v_pk_max_f16",
> +		[GFX10_V_DOT2_F32_F16] = "v_dot2_f32_f16",
> +		[GFX10_V_DOT2_I32_I16] = "v_dot2_i32_i16",
> +		[GFX10_V_DOT2_U32_U16] = "v_dot2_u32_u16",
> +		[GFX10_V_DOT4_I32_I8] = "v_dot4_i32_i8",
> +		[GFX10_V_DOT4_U32_U8] = "v_dot4_u32_u8",
> +		[GFX10_V_DOT8_I32_I4] = "v_dot8_i32_i4",
> +		[GFX10_V_DOT8_U32_U4] = "v_dot8_u32_u4",
> +		[GFX10_V_FMA_MIX_F32] = "v_fma_mix_f32",
> +		[GFX10_V_FMA_MIXLO_F16] = "v_fma_mixlo_f16",
> +		[GFX10_V_FMA_MIXHI_F16] = "v_fma_mixhi_f16",
> +	},
> +	[AMDGCN_INSN_TYPE_MUBUF] = {
> +		[GFX10_BUFFER_LOAD_FORMAT_X] = "buffer_load_format_x",
> +		[GFX10_BUFFER_LOAD_FORMAT_XY] = "buffer_load_format_xy",
> +		[GFX10_BUFFER_LOAD_FORMAT_XYZ] = "buffer_load_format_xyz",
> +		[GFX10_BUFFER_LOAD_FORMAT_XYZW] = "buffer_load_format_xyzw",
> +		[GFX10_BUFFER_STORE_FORMAT_X] = "buffer_store_format_x",
> +		[GFX10_BUFFER_STORE_FORMAT_XY] = "buffer_store_format_xy",
> +		[GFX10_BUFFER_STORE_FORMAT_XYZ] = "buffer_store_format_xyz",
> +		[GFX10_BUFFER_STORE_FORMAT_XYZW] = "buffer_store_format_xyzw",
> +		[GFX10_BUFFER_LOAD_UBYTE] = "buffer_load_ubyte",
> +		[GFX10_BUFFER_LOAD_SBYTE] = "buffer_load_sbyte",
> +		[GFX10_BUFFER_LOAD_USHORT] = "buffer_load_ushort",
> +		[GFX10_BUFFER_LOAD_SSHORT] = "buffer_load_sshort",
> +		[GFX10_BUFFER_LOAD_DWORD] = "buffer_load_dword",
> +		[GFX10_BUFFER_LOAD_DWORDX2] = "buffer_load_dwordx2",
> +		[GFX10_BUFFER_LOAD_DWORDX4] = "buffer_load_dwordx4",
> +		[GFX10_BUFFER_LOAD_DWORDX3] = "buffer_load_dwordx3",
> +		[GFX10_BUFFER_STORE_BYTE] = "buffer_store_byte",
> +		[GFX10_BUFFER_STORE_BYTE_D16_HI] = "buffer_store_byte_d16_hi",
> +		[GFX10_BUFFER_STORE_SHORT] = "buffer_store_short",
> +		[GFX10_BUFFER_STORE_SHORT_D16_HI] = "buffer_store_short_d16_hi",
> +		[GFX10_BUFFER_STORE_DWORD] = "buffer_store_dword",
> +		[GFX10_BUFFER_STORE_DWORDX2] = "buffer_store_dwordx2",
> +		[GFX10_BUFFER_STORE_DWORDX4] = "buffer_store_dwordx4",
> +		[GFX10_BUFFER_STORE_DWORDX3] = "buffer_store_dwordx3",
> +		[GFX10_BUFFER_LOAD_UBYTE_D16] = "buffer_load_ubyte_d16",
> +		[GFX10_BUFFER_LOAD_UBYTE_D16_HI] = "buffer_load_ubyte_d16_hi",
> +		[GFX10_BUFFER_LOAD_SBYTE_D16] = "buffer_load_sbyte_d16",
> +		[GFX10_BUFFER_LOAD_SBYTE_D16_HI] = "buffer_load_sbyte_d16_hi",
> +		[GFX10_BUFFER_LOAD_SHORT_D16] = "buffer_load_short_d16",
> +		[GFX10_BUFFER_LOAD_SHORT_D16_HI] = "buffer_load_short_d16_hi",
> +		[GFX10_BUFFER_LOAD_FORMAT_D16_HI_X] = "buffer_load_format_d16_hi_x",
> +		[GFX10_BUFFER_STORE_FORMAT_D16_HI_X] = "buffer_store_format_d16_hi_x",
> +		[GFX10_BUFFER_ATOMIC_SWAP] = "buffer_atomic_swap",
> +		[GFX10_BUFFER_ATOMIC_CMPSWAP] = "buffer_atomic_cmpswap",
> +		[GFX10_BUFFER_ATOMIC_ADD] = "buffer_atomic_add",
> +		[GFX10_BUFFER_ATOMIC_SUB] = "buffer_atomic_sub",
> +		[GFX10_BUFFER_ATOMIC_CSUB] = "buffer_atomic_csub",
> +		[GFX10_BUFFER_ATOMIC_SMIN] = "buffer_atomic_smin",
> +		[GFX10_BUFFER_ATOMIC_UMIN] = "buffer_atomic_umin",
> +		[GFX10_BUFFER_ATOMIC_SMAX] = "buffer_atomic_smax",
> +		[GFX10_BUFFER_ATOMIC_UMAX] = "buffer_atomic_umax",
> +		[GFX10_BUFFER_ATOMIC_AND] = "buffer_atomic_and",
> +		[GFX10_BUFFER_ATOMIC_OR] = "buffer_atomic_or",
> +		[GFX10_BUFFER_ATOMIC_XOR] = "buffer_atomic_xor",
> +		[GFX10_BUFFER_ATOMIC_INC] = "buffer_atomic_inc",
> +		[GFX10_BUFFER_ATOMIC_DEC] = "buffer_atomic_dec",
> +		[GFX10_BUFFER_ATOMIC_FCMPSWAP] = "buffer_atomic_fcmpswap",
> +		[GFX10_BUFFER_ATOMIC_FMIN] = "buffer_atomic_fmin",
> +		[GFX10_BUFFER_ATOMIC_FMAX] = "buffer_atomic_fmax",
> +		[GFX10_BUFFER_ATOMIC_SWAP_X2] = "buffer_atomic_swap_x2",
> +		[GFX10_BUFFER_ATOMIC_CMPSWAP_X2] = "buffer_atomic_cmpswap_x2",
> +		[GFX10_BUFFER_ATOMIC_ADD_X2] = "buffer_atomic_add_x2",
> +		[GFX10_BUFFER_ATOMIC_SUB_X2] = "buffer_atomic_sub_x2",
> +		[GFX10_BUFFER_ATOMIC_SMIN_X2] = "buffer_atomic_smin_x2",
> +		[GFX10_BUFFER_ATOMIC_UMIN_X2] = "buffer_atomic_umin_x2",
> +		[GFX10_BUFFER_ATOMIC_SMAX_X2] = "buffer_atomic_smax_x2",
> +		[GFX10_BUFFER_ATOMIC_UMAX_X2] = "buffer_atomic_umax_x2",
> +		[GFX10_BUFFER_ATOMIC_AND_X2] = "buffer_atomic_and_x2",
> +		[GFX10_BUFFER_ATOMIC_OR_X2] = "buffer_atomic_or_x2",
> +		[GFX10_BUFFER_ATOMIC_XOR_X2] = "buffer_atomic_xor_x2",
> +		[GFX10_BUFFER_ATOMIC_INC_X2] = "buffer_atomic_inc_x2",
> +		[GFX10_BUFFER_ATOMIC_DEC_X2] = "buffer_atomic_dec_x2",
> +		[GFX10_BUFFER_ATOMIC_FCMPSWAP_X2] = "buffer_atomic_fcmpswap_x2",
> +		[GFX10_BUFFER_ATOMIC_FMIN_X2] = "buffer_atomic_fmin_x2",
> +		[GFX10_BUFFER_ATOMIC_FMAX_X2] = "buffer_atomic_fmax_x2",
> +		[GFX10_BUFFER_GL0_INV] = "buffer_gl0_inv",
> +		[GFX10_BUFFER_GL1_INV] = "buffer_gl1_inv",
> +		[GFX10_BUFFER_LOAD_FORMAT_D16_X] = "buffer_load_format_d16_x",
> +		[GFX10_BUFFER_LOAD_FORMAT_D16_XY] = "buffer_load_format_d16_xy",
> +		[GFX10_BUFFER_LOAD_FORMAT_D16_XYZ] = "buffer_load_format_d16_xyz",
> +		[GFX10_BUFFER_LOAD_FORMAT_D16_XYZW] = "buffer_load_format_d16_xyzw",
> +		[GFX10_BUFFER_STORE_FORMAT_D16_X] = "buffer_store_format_d16_x",
> +		[GFX10_BUFFER_STORE_FORMAT_D16_XY] = "buffer_store_format_d16_xy",
> +		[GFX10_BUFFER_STORE_FORMAT_D16_XYZ] = "buffer_store_format_d16_xyz",
> +		[GFX10_BUFFER_STORE_FORMAT_D16_XYZW] = "buffer_store_format_d16_xyzw",
> +	},
> +	[AMDGCN_INSN_TYPE_FLAT] = {
> +		[GFX10_GLOBAL_LOAD_UBYTE] = "global_load_ubyte",
> +		[GFX10_GLOBAL_LOAD_SBYTE] = "global_load_sbyte",
> +		[GFX10_GLOBAL_LOAD_USHORT] = "global_load_ushort",
> +		[GFX10_GLOBAL_LOAD_SSHORT] = "global_load_sshort",
> +		[GFX10_GLOBAL_LOAD_DWORD] = "global_load_dword",
> +		[GFX10_GLOBAL_LOAD_DWORDX2] = "global_load_dwordx2",
> +		[GFX10_GLOBAL_LOAD_DWORDX4] = "global_load_dwordx4",
> +		[GFX10_GLOBAL_LOAD_DWORDX3] = "global_load_dwordx3",
> +		[GFX10_GLOBAL_LOAD_DWORD_ADDTID] = "global_load_dword_addtid",
> +		[GFX10_GLOBAL_STORE_DWORD_ADDTID] = "global_store_dword_addtid",
> +		[GFX10_GLOBAL_STORE_BYTE] = "global_store_byte",
> +		[GFX10_GLOBAL_STORE_BYTE_D16_HI] = "global_store_byte_d16_hi",
> +		[GFX10_GLOBAL_STORE_SHORT] = "global_store_short",
> +		[GFX10_GLOBAL_STORE_SHORT_D16_HI] = "global_store_short_d16_hi",
> +		[GFX10_GLOBAL_STORE_DWORD] = "global_store_dword",
> +		[GFX10_GLOBAL_STORE_DWORDX2] = "global_store_dwordx2",
> +		[GFX10_GLOBAL_STORE_DWORDX4] = "global_store_dwordx4",
> +		[GFX10_GLOBAL_STORE_DWORDX3] = "global_store_dwordx3",
> +		[GFX10_GLOBAL_LOAD_UBYTE_D16] = "global_load_ubyte_d16",
> +		[GFX10_GLOBAL_LOAD_UBYTE_D16_HI] = "global_load_ubyte_d16_hi",
> +		[GFX10_GLOBAL_LOAD_SBYTE_D16] = "global_load_sbyte_d16",
> +		[GFX10_GLOBAL_LOAD_SBYTE_D16_HI] = "global_load_sbyte_d16_hi",
> +		[GFX10_GLOBAL_LOAD_SHORT_D16] = "global_load_short_d16",
> +		[GFX10_GLOBAL_LOAD_SHORT_D16_HI] = "global_load_short_d16_hi",
> +		[GFX10_GLOBAL_ATOMIC_SWAP] = "global_atomic_swap",
> +		[GFX10_GLOBAL_ATOMIC_CMPSWAP] = "global_atomic_cmpswap",
> +		[GFX10_GLOBAL_ATOMIC_ADD] = "global_atomic_add",
> +		[GFX10_GLOBAL_ATOMIC_SUB] = "global_atomic_sub",
> +		[GFX10_GLOBAL_ATOMIC_CSUB] = "global_atomic_csub",
> +		[GFX10_GLOBAL_ATOMIC_SMIN] = "global_atomic_smin",
> +		[GFX10_GLOBAL_ATOMIC_UMIN] = "global_atomic_umin",
> +		[GFX10_GLOBAL_ATOMIC_SMAX] = "global_atomic_smax",
> +		[GFX10_GLOBAL_ATOMIC_UMAX] = "global_atomic_umax",
> +		[GFX10_GLOBAL_ATOMIC_AND] = "global_atomic_and",
> +		[GFX10_GLOBAL_ATOMIC_OR] = "global_atomic_or",
> +		[GFX10_GLOBAL_ATOMIC_XOR] = "global_atomic_xor",
> +		[GFX10_GLOBAL_ATOMIC_INC] = "global_atomic_inc",
> +		[GFX10_GLOBAL_ATOMIC_DEC] = "global_atomic_dec",
> +		[GFX10_GLOBAL_ATOMIC_FCMPSWAP] = "global_atomic_fcmpswap",
> +		[GFX10_GLOBAL_ATOMIC_FMIN] = "global_atomic_fmin",
> +		[GFX10_GLOBAL_ATOMIC_FMAX] = "global_atomic_fmax",
> +		[GFX10_GLOBAL_ATOMIC_SWAP_X2] = "global_atomic_swap_x2",
> +		[GFX10_GLOBAL_ATOMIC_CMPSWAP_X2] = "global_atomic_cmpswap_x2",
> +		[GFX10_GLOBAL_ATOMIC_ADD_X2] = "global_atomic_add_x2",
> +		[GFX10_GLOBAL_ATOMIC_SUB_X2] = "global_atomic_sub_x2",
> +		[GFX10_GLOBAL_ATOMIC_SMIN_X2] = "global_atomic_smin_x2",
> +		[GFX10_GLOBAL_ATOMIC_UMIN_X2] = "global_atomic_umin_x2",
> +		[GFX10_GLOBAL_ATOMIC_SMAX_X2] = "global_atomic_smax_x2",
> +		[GFX10_GLOBAL_ATOMIC_UMAX_X2] = "global_atomic_umax_x2",
> +		[GFX10_GLOBAL_ATOMIC_AND_X2] = "global_atomic_and_x2",
> +		[GFX10_GLOBAL_ATOMIC_OR_X2] = "global_atomic_or_x2",
> +		[GFX10_GLOBAL_ATOMIC_XOR_X2] = "global_atomic_xor_x2",
> +		[GFX10_GLOBAL_ATOMIC_INC_X2] = "global_atomic_inc_x2",
> +		[GFX10_GLOBAL_ATOMIC_DEC_X2] = "global_atomic_dec_x2",
> +		[GFX10_GLOBAL_ATOMIC_FCMPSWAP_X2] = "global_atomic_fcmpswap_x2",
> +		[GFX10_GLOBAL_ATOMIC_FMIN_X2] = "global_atomic_fmin_x2",
> +		[GFX10_GLOBAL_ATOMIC_FMAX_X2] = "global_atomic_fmax_x2",
> +	},
> +};
> +
> +static const char opnames_gfx9[__AMDGCN_INSN_TYPE_MAX][900][30] = {
> +	[AMDGCN_INSN_TYPE_SOP2] = {
> +		[GFX9_S_ADD_U32] = "s_add_u32",
> +		[GFX9_S_SUB_U32] = "s_sub_u32",
> +		[GFX9_S_ADD_I32] = "s_add_i32",
> +		[GFX9_S_SUB_I32] = "s_sub_i32",
> +		[GFX9_S_ADDC_U32] = "s_addc_u32",
> +		[GFX9_S_SUBB_U32] = "s_subb_u32",
> +		[GFX9_S_MIN_I32] = "s_min_i32",
> +		[GFX9_S_MIN_U32] = "s_min_u32",
> +		[GFX9_S_MAX_I32] = "s_max_i32",
> +		[GFX9_S_MAX_U32] = "s_max_u32",
> +		[GFX9_S_CSELECT_B32] = "s_cselect_b32",
> +		[GFX9_S_CSELECT_B64] = "s_cselect_b64",
> +		[GFX9_S_AND_B32] = "s_and_b32",
> +		[GFX9_S_AND_B64] = "s_and_b64",
> +		[GFX9_S_OR_B32] = "s_or_b32",
> +		[GFX9_S_OR_B64] = "s_or_b64",
> +		[GFX9_S_XOR_B32] = "s_xor_b32",
> +		[GFX9_S_XOR_B64] = "s_xor_b64",
> +		[GFX9_S_ANDN2_B32] = "s_andn2_b32",
> +		[GFX9_S_ANDN2_B64] = "s_andn2_b64",
> +		[GFX9_S_ORN2_B32] = "s_orn2_b32",
> +		[GFX9_S_ORN2_B64] = "s_orn2_b64",
> +		[GFX9_S_NAND_B32] = "s_nand_b32",
> +		[GFX9_S_NAND_B64] = "s_nand_b64",
> +		[GFX9_S_NOR_B32] = "s_nor_b32",
> +		[GFX9_S_NOR_B64] = "s_nor_b64",
> +		[GFX9_S_XNOR_B32] = "s_xnor_b32",
> +		[GFX9_S_XNOR_B64] = "s_xnor_b64",
> +		[GFX9_S_LSHL_B32] = "s_lshl_b32",
> +		[GFX9_S_LSHL_B64] = "s_lshl_b64",
> +		[GFX9_S_LSHR_B32] = "s_lshr_b32",
> +		[GFX9_S_LSHR_B64] = "s_lshr_b64",
> +		[GFX9_S_ASHR_I32] = "s_ashr_i32",
> +		[GFX9_S_ASHR_I64] = "s_ashr_i64",
> +		[GFX9_S_BFM_B32] = "s_bfm_b32",
> +		[GFX9_S_BFM_B64] = "s_bfm_b64",
> +		[GFX9_S_MUL_I32] = "s_mul_i32",
> +		[GFX9_S_BFE_U32] = "s_bfe_u32",
> +		[GFX9_S_BFE_I32] = "s_bfe_i32",
> +		[GFX9_S_BFE_U64] = "s_bfe_u64",
> +		[GFX9_S_BFE_I64] = "s_bfe_i64",
> +		[GFX9_S_CBRANCH_G_FORK] = "s_cbranch_g_fork",
> +		[GFX9_S_ABSDIFF_I32] = "s_absdiff_i32",
> +		[GFX9_S_RFE_RESTORE_B64] = "s_rfe_restore_b64",
> +		[GFX9_S_MUL_HI_U32] = "s_mul_hi_u32",
> +		[GFX9_S_MUL_HI_I32] = "s_mul_hi_i32",
> +		[GFX9_S_LSHL1_ADD_U32] = "s_lshl1_add_u32",
> +		[GFX9_S_LSHL2_ADD_U32] = "s_lshl2_add_u32",
> +		[GFX9_S_LSHL3_ADD_U32] = "s_lshl3_add_u32",
> +		[GFX9_S_LSHL4_ADD_U32] = "s_lshl4_add_u32",
> +		[GFX9_S_PACK_LL_B32_B16] = "s_pack_ll_b32_b16",
> +		[GFX9_S_PACK_LH_B32_B16] = "s_pack_lh_b32_b16",
> +		[GFX9_S_PACK_HH_B32_B16] = "s_pack_hh_b32_b16",
> +	},
> +	[AMDGCN_INSN_TYPE_SOPK] = {
> +		[GFX9_S_MOVK_I32] = "s_movk_i32",
> +		[GFX9_S_CMOVK_I32] = "s_cmovk_i32",
> +		[GFX9_S_CMPK_EQ_I32] = "s_cmpk_eq_i32",
> +		[GFX9_S_CMPK_LG_I32] = "s_cmpk_lg_i32",
> +		[GFX9_S_CMPK_GT_I32] = "s_cmpk_gt_i32",
> +		[GFX9_S_CMPK_GE_I32] = "s_cmpk_ge_i32",
> +		[GFX9_S_CMPK_LT_I32] = "s_cmpk_lt_i32",
> +		[GFX9_S_CMPK_LE_I32] = "s_cmpk_le_i32",
> +		[GFX9_S_CMPK_EQ_U32] = "s_cmpk_eq_u32",
> +		[GFX9_S_CMPK_LG_U32] = "s_cmpk_lg_u32",
> +		[GFX9_S_CMPK_GT_U32] = "s_cmpk_gt_u32",
> +		[GFX9_S_CMPK_GE_U32] = "s_cmpk_ge_u32",
> +		[GFX9_S_CMPK_LT_U32] = "s_cmpk_lt_u32",
> +		[GFX9_S_CMPK_LE_U32] = "s_cmpk_le_u32",
> +		[GFX9_S_ADDK_I32] = "s_addk_i32",
> +		[GFX9_S_MULK_I32] = "s_mulk_i32",
> +		[GFX9_S_CBRANCH_I_FORK] = "s_cbranch_i_fork",
> +		[GFX9_S_GETREG_B32] = "s_getreg_b32",
> +		[GFX9_S_SETREG_B32] = "s_setreg_b32",
> +		[GFX9_S_SETREG_IMM32_B32] = "s_setreg_imm32_b32",
> +		[GFX9_S_CALL_B64] = "s_call_b64",
> +	},
> +	[AMDGCN_INSN_TYPE_SOP1] = {
> +		[GFX9_S_MOV_B32] = "s_mov_b32",
> +		[GFX9_S_MOV_B64] = "s_mov_b64",
> +		[GFX9_S_CMOV_B32] = "s_cmov_b32",
> +		[GFX9_S_CMOV_B64] = "s_cmov_b64",
> +		[GFX9_S_NOT_B32] = "s_not_b32",
> +		[GFX9_S_NOT_B64] = "s_not_b64",
> +		[GFX9_S_WQM_B32] = "s_wqm_b32",
> +		[GFX9_S_WQM_B64] = "s_wqm_b64",
> +		[GFX9_S_BREV_B32] = "s_brev_b32",
> +		[GFX9_S_BREV_B64] = "s_brev_b64",
> +		[GFX9_S_BCNT0_I32_B32] = "s_bcnt0_i32_b32",
> +		[GFX9_S_BCNT0_I32_B64] = "s_bcnt0_i32_b64",
> +		[GFX9_S_BCNT1_I32_B32] = "s_bcnt1_i32_b32",
> +		[GFX9_S_BCNT1_I32_B64] = "s_bcnt1_i32_b64",
> +		[GFX9_S_FF0_I32_B32] = "s_ff0_i32_b32",
> +		[GFX9_S_FF0_I32_B64] = "s_ff0_i32_b64",
> +		[GFX9_S_FF1_I32_B32] = "s_ff1_i32_b32",
> +		[GFX9_S_FF1_I32_B64] = "s_ff1_i32_b64",
> +		[GFX9_S_FLBIT_I32_B32] = "s_flbit_i32_b32",
> +		[GFX9_S_FLBIT_I32_B64] = "s_flbit_i32_b64",
> +		[GFX9_S_FLBIT_I32] = "s_flbit_i32",
> +		[GFX9_S_FLBIT_I32_I64] = "s_flbit_i32_i64",
> +		[GFX9_S_SEXT_I32_I8] = "s_sext_i32_i8",
> +		[GFX9_S_SEXT_I32_I16] = "s_sext_i32_i16",
> +		[GFX9_S_BITSET0_B32] = "s_bitset0_b32",
> +		[GFX9_S_BITSET0_B64] = "s_bitset0_b64",
> +		[GFX9_S_BITSET1_B32] = "s_bitset1_b32",
> +		[GFX9_S_BITSET1_B64] = "s_bitset1_b64",
> +		[GFX9_S_GETPC_B64] = "s_getpc_b64",
> +		[GFX9_S_SETPC_B64] = "s_setpc_b64",
> +		[GFX9_S_SWAPPC_B64] = "s_swappc_b64",
> +		[GFX9_S_RFE_B64] = "s_rfe_b64",
> +		[GFX9_S_AND_SAVEEXEC_B64] = "s_and_saveexec_b64",
> +		[GFX9_S_XNOR_SAVEEXEC_B64] = "s_xnor_saveexec_b64",
> +		[GFX9_S_QUADMASK_B32] = "s_quadmask_b32",
> +		[GFX9_S_QUADMASK_B64] = "s_quadmask_b64",
> +		[GFX9_S_MOVRELS_B32] = "s_movrels_b32",
> +		[GFX9_S_MOVRELS_B64] = "s_movrels_b64",
> +		[GFX9_S_MOVRELD_B32] = "s_movreld_b32",
> +		[GFX9_S_MOVRELD_B64] = "s_movreld_b64",
> +		[GFX9_S_ABS_I32] = "s_abs_i32",
> +		[GFX9_S_ANDN1_SAVEEXEC_B64] = "s_andn1_saveexec_b64",
> +		[GFX9_S_ORN1_SAVEEXEC_B64] = "s_orn1_saveexec_b64",
> +		[GFX9_S_ANDN1_WREXEC_B64] = "s_andn1_wrexec_b64",
> +		[GFX9_S_ANDN2_WREXEC_B64] = "s_andn2_wrexec_b64",
> +		[GFX9_S_BITREPLICATE_B64_B32] = "s_bitreplicate_b64_b32",
> +		/* SOP1 opcodes missing from the table (Vega ISA 12.3). */
> +		[GFX9_S_OR_SAVEEXEC_B64] = "s_or_saveexec_b64",
> +		[GFX9_S_XOR_SAVEEXEC_B64] = "s_xor_saveexec_b64",
> +		[GFX9_S_ANDN2_SAVEEXEC_B64] = "s_andn2_saveexec_b64",
> +		[GFX9_S_ORN2_SAVEEXEC_B64] = "s_orn2_saveexec_b64",
> +		[GFX9_S_NAND_SAVEEXEC_B64] = "s_nand_saveexec_b64",
> +		[GFX9_S_NOR_SAVEEXEC_B64] = "s_nor_saveexec_b64",
> +		[GFX9_S_SET_GPR_IDX_IDX] = "s_set_gpr_idx_idx",
> +	},
> +	[AMDGCN_INSN_TYPE_SOPC] = {
> +		[GFX9_S_CMP_EQ_I32] = "s_cmp_eq_i32",
> +		[GFX9_S_CMP_LG_I32] = "s_cmp_lg_i32",
> +		[GFX9_S_CMP_GT_I32] = "s_cmp_gt_i32",
> +		[GFX9_S_CMP_GE_I32] = "s_cmp_ge_i32",
> +		[GFX9_S_CMP_LT_I32] = "s_cmp_lt_i32",
> +		[GFX9_S_CMP_LE_I32] = "s_cmp_le_i32",
> +		[GFX9_S_CMP_EQ_U32] = "s_cmp_eq_u32",
> +		[GFX9_S_CMP_LG_U32] = "s_cmp_lg_u32",
> +		[GFX9_S_CMP_GT_U32] = "s_cmp_gt_u32",
> +		[GFX9_S_CMP_GE_U32] = "s_cmp_ge_u32",
> +		[GFX9_S_CMP_LT_U32] = "s_cmp_lt_u32",
> +		[GFX9_S_CMP_LE_U32] = "s_cmp_le_u32",
> +		[GFX9_S_BITCMP0_B32] = "s_bitcmp0_b32",
> +		[GFX9_S_BITCMP1_B32] = "s_bitcmp1_b32",
> +		[GFX9_S_BITCMP0_B64] = "s_bitcmp0_b64",
> +		[GFX9_S_BITCMP1_B64] = "s_bitcmp1_b64",
> +		[GFX9_S_SETVSKIP] = "s_setvskip",
> +		[GFX9_S_SET_GPR_IDX_ON] = "s_set_gpr_idx_on",
> +		[GFX9_S_CMP_EQ_U64] = "s_cmp_eq_u64",
> +		[GFX9_S_CMP_LG_U64] = "s_cmp_lg_u64",
> +	},
> +	[AMDGCN_INSN_TYPE_SOPP] = {
> +		[GFX9_S_NOP] = "s_nop",
> +		[GFX9_S_ENDPGM] = "s_endpgm",
> +		[GFX9_S_BRANCH] = "s_branch",
> +		[GFX9_S_WAKEUP] = "s_wakeup",
> +		[GFX9_S_CBRANCH_SCC0] = "s_cbranch_scc0",
> +		[GFX9_S_CBRANCH_SCC1] = "s_cbranch_scc1",
> +		[GFX9_S_CBRANCH_VCCZ] = "s_cbranch_vccz",
> +		[GFX9_S_CBRANCH_VCCNZ] = "s_cbranch_vccnz",
> +		[GFX9_S_CBRANCH_EXECZ] = "s_cbranch_execz",
> +		[GFX9_S_CBRANCH_EXECNZ] = "s_cbranch_execnz",
> +		[GFX9_S_BARRIER] = "s_barrier",
> +		[GFX9_S_SETKILL] = "s_setkill",
> +		[GFX9_S_WAITCNT] = "s_waitcnt",
> +		[GFX9_S_SETHALT] = "s_sethalt",
> +		[GFX9_S_SLEEP] = "s_sleep",
> +		[GFX9_S_SETPRIO] = "s_setprio",
> +		[GFX9_S_SENDMSG] = "s_sendmsg",
> +		[GFX9_S_SENDMSGHALT] = "s_sendmsghalt",
> +		[GFX9_S_TRAP] = "s_trap",
> +		[GFX9_S_ICACHE_INV] = "s_icache_inv",
> +		[GFX9_S_INCPERFLEVEL] = "s_incperflevel",
> +		[GFX9_S_DECPERFLEVEL] = "s_decperflevel",
> +		[GFX9_S_TTRACEDATA] = "s_ttracedata",
> +		[GFX9_S_CBRANCH_CDBGSYS] = "s_cbranch_cdbgsys",
> +		[GFX9_S_CBRANCH_CDBGUSER] = "s_cbranch_cdbguser",
> +		[GFX9_S_CBRANCH_CDBGSYS_OR_USER] = "s_cbranch_cdbgsys_or_user",
> +		[GFX9_S_CBRANCH_CDBGSYS_AND_USER] = "s_cbranch_cdbgsys_and_user",
> +		[GFX9_S_ENDPGM_SAVED] = "s_endpgm_saved",
> +		[GFX9_S_SET_GPR_IDX_OFF] = "s_set_gpr_idx_off",
> +		[GFX9_S_SET_GPR_IDX_MODE] = "s_set_gpr_idx_mode",
> +		[GFX9_S_ENDPGM_ORDERED_PS_DONE] = "s_endpgm_ordered_ps_done",
> +	},
> +	[AMDGCN_INSN_TYPE_SMEM] = {
> +		[GFX9_S_LOAD_DWORD] = "s_load_dword",
> +		[GFX9_S_LOAD_DWORDX2] = "s_load_dwordx2",
> +		[GFX9_S_LOAD_DWORDX4] = "s_load_dwordx4",
> +		[GFX9_S_LOAD_DWORDX8] = "s_load_dwordx8",
> +		[GFX9_S_LOAD_DWORDX16] = "s_load_dwordx16",
> +		[GFX9_S_SCRATCH_LOAD_DWORD] = "s_scratch_load_dword",
> +		[GFX9_S_SCRATCH_LOAD_DWORDX2] = "s_scratch_load_dwordx2",
> +		[GFX9_S_SCRATCH_LOAD_DWORDX4] = "s_scratch_load_dwordx4",
> +		[GFX9_S_BUFFER_LOAD_DWORD] = "s_buffer_load_dword",
> +		[GFX9_S_BUFFER_LOAD_DWORDX2] = "s_buffer_load_dwordx2",
> +		[GFX9_S_BUFFER_LOAD_DWORDX4] = "s_buffer_load_dwordx4",
> +		[GFX9_S_BUFFER_LOAD_DWORDX8] = "s_buffer_load_dwordx8",
> +		[GFX9_S_BUFFER_LOAD_DWORDX16] = "s_buffer_load_dwordx16",
> +		[GFX9_S_STORE_DWORD] = "s_store_dword",
> +		[GFX9_S_STORE_DWORDX2] = "s_store_dwordx2",
> +		[GFX9_S_STORE_DWORDX4] = "s_store_dwordx4",
> +		[GFX9_S_SCRATCH_STORE_DWORD] = "s_scratch_store_dword",
> +		[GFX9_S_SCRATCH_STORE_DWORDX2] = "s_scratch_store_dwordx2",
> +		[GFX9_S_SCRATCH_STORE_DWORDX4] = "s_scratch_store_dwordx4",
> +		[GFX9_S_BUFFER_STORE_DWORD] = "s_buffer_store_dword",
> +		[GFX9_S_BUFFER_STORE_DWORDX2] = "s_buffer_store_dwordx2",
> +		[GFX9_S_BUFFER_STORE_DWORDX4] = "s_buffer_store_dwordx4",
> +		[GFX9_S_DCACHE_INV] = "s_dcache_inv",
> +		[GFX9_S_DCACHE_WB] = "s_dcache_wb",
> +		[GFX9_S_DCACHE_INV_VOL] = "s_dcache_inv_vol",
> +		[GFX9_S_DCACHE_WB_VOL] = "s_dcache_wb_vol",
> +		[GFX9_S_MEMTIME] = "s_memtime",
> +		[GFX9_S_MEMREALTIME] = "s_memrealtime",
> +		[GFX9_S_ATC_PROBE] = "s_atc_probe",
> +		[GFX9_S_ATC_PROBE_BUFFER] = "s_atc_probe_buffer",
> +		[GFX9_S_DCACHE_DISCARD] = "s_dcache_discard",
> +		[GFX9_S_DCACHE_DISCARD_X2] = "s_dcache_discard_x2",
> +		[GFX9_S_BUFFER_ATOMIC_SWAP] = "s_buffer_atomic_swap",
> +		[GFX9_S_BUFFER_ATOMIC_CMPSWAP] = "s_buffer_atomic_cmpswap",
> +		[GFX9_S_BUFFER_ATOMIC_ADD] = "s_buffer_atomic_add",
> +		[GFX9_S_BUFFER_ATOMIC_SUB] = "s_buffer_atomic_sub",
> +		[GFX9_S_BUFFER_ATOMIC_SMIN] = "s_buffer_atomic_smin",
> +		[GFX9_S_BUFFER_ATOMIC_UMIN] = "s_buffer_atomic_umin",
> +		[GFX9_S_BUFFER_ATOMIC_SMAX] = "s_buffer_atomic_smax",
> +		[GFX9_S_BUFFER_ATOMIC_UMAX] = "s_buffer_atomic_umax",
> +		[GFX9_S_BUFFER_ATOMIC_AND] = "s_buffer_atomic_and",
> +		[GFX9_S_BUFFER_ATOMIC_OR] = "s_buffer_atomic_or",
> +		[GFX9_S_BUFFER_ATOMIC_XOR] = "s_buffer_atomic_xor",
> +		[GFX9_S_BUFFER_ATOMIC_INC] = "s_buffer_atomic_inc",
> +		[GFX9_S_BUFFER_ATOMIC_DEC] = "s_buffer_atomic_dec",
> +		[GFX9_S_BUFFER_ATOMIC_SWAP_X2] = "s_buffer_atomic_swap_x2",
> +		[GFX9_S_BUFFER_ATOMIC_CMPSWAP_X2] = "s_buffer_atomic_cmpswap_x2",
> +		[GFX9_S_BUFFER_ATOMIC_ADD_X2] = "s_buffer_atomic_add_x2",
> +		[GFX9_S_BUFFER_ATOMIC_SUB_X2] = "s_buffer_atomic_sub_x2",
> +		[GFX9_S_BUFFER_ATOMIC_SMIN_X2] = "s_buffer_atomic_smin_x2",
> +		[GFX9_S_BUFFER_ATOMIC_UMIN_X2] = "s_buffer_atomic_umin_x2",
> +		[GFX9_S_BUFFER_ATOMIC_SMAX_X2] = "s_buffer_atomic_smax_x2",
> +		[GFX9_S_BUFFER_ATOMIC_UMAX_X2] = "s_buffer_atomic_umax_x2",
> +		[GFX9_S_BUFFER_ATOMIC_AND_X2] = "s_buffer_atomic_and_x2",
> +		[GFX9_S_BUFFER_ATOMIC_OR_X2] = "s_buffer_atomic_or_x2",
> +		[GFX9_S_BUFFER_ATOMIC_XOR_X2] = "s_buffer_atomic_xor_x2",
> +		[GFX9_S_BUFFER_ATOMIC_INC_X2] = "s_buffer_atomic_inc_x2",
> +		[GFX9_S_BUFFER_ATOMIC_DEC_X2] = "s_buffer_atomic_dec_x2",
> +		[GFX9_S_ATOMIC_SWAP] = "s_atomic_swap",
> +		[GFX9_S_ATOMIC_CMPSWAP] = "s_atomic_cmpswap",
> +		[GFX9_S_ATOMIC_ADD] = "s_atomic_add",
> +		[GFX9_S_ATOMIC_SUB] = "s_atomic_sub",
> +		[GFX9_S_ATOMIC_SMIN] = "s_atomic_smin",
> +		[GFX9_S_ATOMIC_UMIN] = "s_atomic_umin",
> +		[GFX9_S_ATOMIC_SMAX] = "s_atomic_smax",
> +		[GFX9_S_ATOMIC_UMAX] = "s_atomic_umax",
> +		[GFX9_S_ATOMIC_AND] = "s_atomic_and",
> +		[GFX9_S_ATOMIC_OR] = "s_atomic_or",
> +		[GFX9_S_ATOMIC_XOR] = "s_atomic_xor",
> +		[GFX9_S_ATOMIC_INC] = "s_atomic_inc",
> +		[GFX9_S_ATOMIC_DEC] = "s_atomic_dec",
> +		[GFX9_S_ATOMIC_SWAP_X2] = "s_atomic_swap_x2",
> +		[GFX9_S_ATOMIC_CMPSWAP_X2] = "s_atomic_cmpswap_x2",
> +		[GFX9_S_ATOMIC_ADD_X2] = "s_atomic_add_x2",
> +		[GFX9_S_ATOMIC_SUB_X2] = "s_atomic_sub_x2",
> +		[GFX9_S_ATOMIC_SMIN_X2] = "s_atomic_smin_x2",
> +		[GFX9_S_ATOMIC_UMIN_X2] = "s_atomic_umin_x2",
> +		[GFX9_S_ATOMIC_SMAX_X2] = "s_atomic_smax_x2",
> +		[GFX9_S_ATOMIC_UMAX_X2] = "s_atomic_umax_x2",
> +		[GFX9_S_ATOMIC_AND_X2] = "s_atomic_and_x2",
> +		[GFX9_S_ATOMIC_OR_X2] = "s_atomic_or_x2",
> +		[GFX9_S_ATOMIC_XOR_X2] = "s_atomic_xor_x2",
> +		[GFX9_S_ATOMIC_INC_X2] = "s_atomic_inc_x2",
> +		[GFX9_S_ATOMIC_DEC_X2] = "s_atomic_dec_x2",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP2] = {
> +		[GFX9_V_CNDMASK_B32] = "v_cndmask_b32",
> +		[GFX9_V_ADD_F32] = "v_add_f32",
> +		[GFX9_V_SUB_F32] = "v_sub_f32",
> +		[GFX9_V_SUBREV_F32] = "v_subrev_f32",
> +		[GFX9_V_MUL_LEGACY_F32] = "v_mul_legacy_f32",
> +		[GFX9_V_MUL_F32] = "v_mul_f32",
> +		[GFX9_V_MUL_I32_I24] = "v_mul_i32_i24",
> +		[GFX9_V_MUL_HI_I32_I24] = "v_mul_hi_i32_i24",
> +		[GFX9_V_MUL_U32_U24] = "v_mul_u32_u24",
> +		[GFX9_V_MUL_HI_U32_U24] = "v_mul_hi_u32_u24",
> +		[GFX9_V_MIN_F32] = "v_min_f32",
> +		[GFX9_V_MAX_F32] = "v_max_f32",
> +		[GFX9_V_MIN_I32] = "v_min_i32",
> +		[GFX9_V_MAX_I32] = "v_max_i32",
> +		[GFX9_V_MIN_U32] = "v_min_u32",
> +		[GFX9_V_MAX_U32] = "v_max_u32",
> +		[GFX9_V_LSHRREV_B32] = "v_lshrrev_b32",
> +		[GFX9_V_ASHRREV_I32] = "v_ashrrev_i32",
> +		[GFX9_V_LSHLREV_B32] = "v_lshlrev_b32",
> +		[GFX9_V_AND_B32] = "v_and_b32",
> +		[GFX9_V_OR_B32] = "v_or_b32",
> +		[GFX9_V_XOR_B32] = "v_xor_b32",
> +		[GFX9_V_MAC_F32] = "v_mac_f32",
> +		[GFX9_V_MADMK_F32] = "v_madmk_f32",
> +		[GFX9_V_MADAK_F32] = "v_madak_f32",
> +		[GFX9_V_ADD_CO_U32] = "v_add_co_u32",
> +		[GFX9_V_SUB_CO_U32] = "v_sub_co_u32",
> +		[GFX9_V_SUBREV_CO_U32] = "v_subrev_co_u32",
> +		[GFX9_V_ADDC_CO_U32] = "v_addc_co_u32",
> +		[GFX9_V_SUBB_CO_U32] = "v_subb_co_u32",
> +		[GFX9_V_SUBBREV_CO_U32] = "v_subbrev_co_u32",
> +		[GFX9_V_ADD_F16] = "v_add_f16",
> +		[GFX9_V_SUB_F16] = "v_sub_f16",
> +		[GFX9_V_SUBREV_F16] = "v_subrev_f16",
> +		[GFX9_V_MUL_F16] = "v_mul_f16",
> +		[GFX9_V_MAC_F16] = "v_mac_f16",
> +		[GFX9_V_MADMK_F16] = "v_madmk_f16",
> +		[GFX9_V_MADAK_F16] = "v_madak_f16",
> +		[GFX9_V_ADD_U16] = "v_add_u16",
> +		[GFX9_V_SUB_U16] = "v_sub_u16",
> +		[GFX9_V_SUBREV_U16] = "v_subrev_u16",
> +		[GFX9_V_MUL_LO_U16] = "v_mul_lo_u16",
> +		[GFX9_V_LSHLREV_B16] = "v_lshlrev_b16",
> +		[GFX9_V_LSHRREV_B16] = "v_lshrrev_b16",
> +		[GFX9_V_ASHRREV_I16] = "v_ashrrev_i16",
> +		[GFX9_V_MAX_F16] = "v_max_f16",
> +		[GFX9_V_MIN_F16] = "v_min_f16",
> +		[GFX9_V_MAX_U16] = "v_max_u16",
> +		[GFX9_V_MAX_I16] = "v_max_i16",
> +		[GFX9_V_MIN_U16] = "v_min_u16",
> +		[GFX9_V_MIN_I16] = "v_min_i16",
> +		[GFX9_V_LDEXP_F16] = "v_ldexp_f16",
> +		[GFX9_V_ADD_U32] = "v_add_u32",
> +		[GFX9_V_SUB_U32] = "v_sub_u32",
> +		[GFX9_V_SUBREV_U32] = "v_subrev_u32",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP1] = {
> +		[GFX9_V_NOP] = "v_nop",
> +		[GFX9_V_MOV_B32] = "v_mov_b32",
> +		[GFX9_V_READFIRSTLANE_B32] = "v_readfirstlane_b32",
> +		[GFX9_V_CVT_I32_F64] = "v_cvt_i32_f64",
> +		[GFX9_V_CVT_F64_I32] = "v_cvt_f64_i32",
> +		[GFX9_V_CVT_F32_I32] = "v_cvt_f32_i32",
> +		[GFX9_V_CVT_F32_U32] = "v_cvt_f32_u32",
> +		[GFX9_V_CVT_U32_F32] = "v_cvt_u32_f32",
> +		[GFX9_V_CVT_I32_F32] = "v_cvt_i32_f32",
> +		[GFX9_V_CVT_F16_F32] = "v_cvt_f16_f32",
> +		[GFX9_V_CVT_F32_F16] = "v_cvt_f32_f16",
> +		[GFX9_V_CVT_RPI_I32_F32] = "v_cvt_rpi_i32_f32",
> +		[GFX9_V_CVT_FLR_I32_F32] = "v_cvt_flr_i32_f32",
> +		[GFX9_V_CVT_OFF_F32_I4] = "v_cvt_off_f32_i4",
> +		[GFX9_V_CVT_F32_F64] = "v_cvt_f32_f64",
> +		[GFX9_V_CVT_F64_F32] = "v_cvt_f64_f32",
> +		[GFX9_V_CVT_F32_UBYTE0] = "v_cvt_f32_ubyte0",
> +		[GFX9_V_CVT_F32_UBYTE1] = "v_cvt_f32_ubyte1",
> +		[GFX9_V_CVT_F32_UBYTE2] = "v_cvt_f32_ubyte2",
> +		[GFX9_V_CVT_F32_UBYTE3] = "v_cvt_f32_ubyte3",
> +		[GFX9_V_CVT_U32_F64] = "v_cvt_u32_f64",
> +		[GFX9_V_CVT_F64_U32] = "v_cvt_f64_u32",
> +		[GFX9_V_TRUNC_F64] = "v_trunc_f64",
> +		[GFX9_V_CEIL_F64] = "v_ceil_f64",
> +		[GFX9_V_RNDNE_F64] = "v_rndne_f64",
> +		[GFX9_V_FLOOR_F64] = "v_floor_f64",
> +		[GFX9_V_FRACT_F32] = "v_fract_f32",
> +		[GFX9_V_TRUNC_F32] = "v_trunc_f32",
> +		[GFX9_V_CEIL_F32] = "v_ceil_f32",
> +		[GFX9_V_RNDNE_F32] = "v_rndne_f32",
> +		[GFX9_V_FLOOR_F32] = "v_floor_f32",
> +		[GFX9_V_EXP_F32] = "v_exp_f32",
> +		[GFX9_V_LOG_F32] = "v_log_f32",
> +		[GFX9_V_RCP_F32] = "v_rcp_f32",
> +		[GFX9_V_RCP_IFLAG_F32] = "v_rcp_iflag_f32",
> +		[GFX9_V_RSQ_F32] = "v_rsq_f32",
> +		[GFX9_V_RCP_F64] = "v_rcp_f64",
> +		[GFX9_V_RSQ_F64] = "v_rsq_f64",
> +		[GFX9_V_SQRT_F32] = "v_sqrt_f32",
> +		[GFX9_V_SQRT_F64] = "v_sqrt_f64",
> +		[GFX9_V_SIN_F32] = "v_sin_f32",
> +		[GFX9_V_COS_F32] = "v_cos_f32",
> +		[GFX9_V_NOT_B32] = "v_not_b32",
> +		[GFX9_V_BFREV_B32] = "v_bfrev_b32",
> +		[GFX9_V_FFBH_U32] = "v_ffbh_u32",
> +		[GFX9_V_FFBL_B32] = "v_ffbl_b32",
> +		[GFX9_V_FFBH_I32] = "v_ffbh_i32",
> +		[GFX9_V_FREXP_EXP_I32_F64] = "v_frexp_exp_i32_f64",
> +		[GFX9_V_FREXP_MANT_F64] = "v_frexp_mant_f64",
> +		[GFX9_V_FRACT_F64] = "v_fract_f64",
> +		[GFX9_V_FREXP_EXP_I32_F32] = "v_frexp_exp_i32_f32",
> +		[GFX9_V_FREXP_MANT_F32] = "v_frexp_mant_f32",
> +		[GFX9_V_CLREXCP] = "v_clrexcp",
> +		[GFX9_V_SCREEN_PARTITION_4SE_B32] = "v_screen_partition_4se_b32",
> +		[GFX9_V_CVT_F16_U16] = "v_cvt_f16_u16",
> +		[GFX9_V_CVT_F16_I16] = "v_cvt_f16_i16",
> +		[GFX9_V_CVT_U16_F16] = "v_cvt_u16_f16",
> +		[GFX9_V_CVT_I16_F16] = "v_cvt_i16_f16",
> +		[GFX9_V_RCP_F16] = "v_rcp_f16",
> +		[GFX9_V_SQRT_F16] = "v_sqrt_f16",
> +		[GFX9_V_RSQ_F16] = "v_rsq_f16",
> +		[GFX9_V_LOG_F16] = "v_log_f16",
> +		[GFX9_V_EXP_F16] = "v_exp_f16",
> +		[GFX9_V_FREXP_MANT_F16] = "v_frexp_mant_f16",
> +		[GFX9_V_FREXP_EXP_I16_F16] = "v_frexp_exp_i16_f16",
> +		[GFX9_V_FLOOR_F16] = "v_floor_f16",
> +		[GFX9_V_CEIL_F16] = "v_ceil_f16",
> +		[GFX9_V_TRUNC_F16] = "v_trunc_f16",
> +		[GFX9_V_RNDNE_F16] = "v_rndne_f16",
> +		[GFX9_V_FRACT_F16] = "v_fract_f16",
> +		[GFX9_V_SIN_F16] = "v_sin_f16",
> +		[GFX9_V_COS_F16] = "v_cos_f16",
> +		[GFX9_V_EXP_LEGACY_F32] = "v_exp_legacy_f32",
> +		[GFX9_V_LOG_LEGACY_F32] = "v_log_legacy_f32",
> +		[GFX9_V_CVT_NORM_I16_F16] = "v_cvt_norm_i16_f16",
> +		[GFX9_V_CVT_NORM_U16_F16] = "v_cvt_norm_u16_f16",
> +		[GFX9_V_SAT_PK_U8_I16] = "v_sat_pk_u8_i16",
> +		[GFX9_V_SWAP_B32] = "v_swap_b32",
> +	},
> +	[AMDGCN_INSN_TYPE_VOPC] = {
> +		[GFX9_V_CMP_CLASS_F32] = "v_cmp_class_f32",
> +		[GFX9_V_CMPX_CLASS_F32] = "v_cmpx_class_f32",
> +		[GFX9_V_CMP_CLASS_F64] = "v_cmp_class_f64",
> +		[GFX9_V_CMPX_CLASS_F64] = "v_cmpx_class_f64",
> +		[GFX9_V_CMP_CLASS_F16] = "v_cmp_class_f16",
> +		[GFX9_V_CMPX_CLASS_F16] = "v_cmpx_class_f16",
> +		[GFX9_V_CMP_F_F16] = "v_cmp_f_f16",
> +		[GFX9_V_CMP_LT_F16] = "v_cmp_lt_f16",
> +		[GFX9_V_CMP_EQ_F16] = "v_cmp_eq_f16",
> +		[GFX9_V_CMP_LE_F16] = "v_cmp_le_f16",
> +		[GFX9_V_CMP_GT_F16] = "v_cmp_gt_f16",
> +		[GFX9_V_CMP_LG_F16] = "v_cmp_lg_f16",
> +		[GFX9_V_CMP_GE_F16] = "v_cmp_ge_f16",
> +		[GFX9_V_CMP_O_F16] = "v_cmp_o_f16",
> +		[GFX9_V_CMP_U_F16] = "v_cmp_u_f16",
> +		[GFX9_V_CMP_NGE_F16] = "v_cmp_nge_f16",
> +		[GFX9_V_CMP_NLG_F16] = "v_cmp_nlg_f16",
> +		[GFX9_V_CMP_NGT_F16] = "v_cmp_ngt_f16",
> +		[GFX9_V_CMP_NLE_F16] = "v_cmp_nle_f16",
> +		[GFX9_V_CMP_NEQ_F16] = "v_cmp_neq_f16",
> +		[GFX9_V_CMP_NLT_F16] = "v_cmp_nlt_f16",
> +		[GFX9_V_CMP_TRU_F16] = "v_cmp_tru_f16",
> +		[GFX9_V_CMPX_F_F16] = "v_cmpx_f_f16",
> +		[GFX9_V_CMPX_LT_F16] = "v_cmpx_lt_f16",
> +		[GFX9_V_CMPX_EQ_F16] = "v_cmpx_eq_f16",
> +		[GFX9_V_CMPX_LE_F16] = "v_cmpx_le_f16",
> +		[GFX9_V_CMPX_GT_F16] = "v_cmpx_gt_f16",
> +		[GFX9_V_CMPX_LG_F16] = "v_cmpx_lg_f16",
> +		[GFX9_V_CMPX_GE_F16] = "v_cmpx_ge_f16",
> +		[GFX9_V_CMPX_O_F16] = "v_cmpx_o_f16",
> +		[GFX9_V_CMPX_U_F16] = "v_cmpx_u_f16",
> +		[GFX9_V_CMPX_NGE_F16] = "v_cmpx_nge_f16",
> +		[GFX9_V_CMPX_NLG_F16] = "v_cmpx_nlg_f16",
> +		[GFX9_V_CMPX_NGT_F16] = "v_cmpx_ngt_f16",
> +		[GFX9_V_CMPX_NLE_F16] = "v_cmpx_nle_f16",
> +		[GFX9_V_CMPX_NEQ_F16] = "v_cmpx_neq_f16",
> +		[GFX9_V_CMPX_NLT_F16] = "v_cmpx_nlt_f16",
> +		[GFX9_V_CMPX_TRU_F16] = "v_cmpx_tru_f16",
> +		[GFX9_V_CMP_F_F32] = "v_cmp_f_f32",
> +		[GFX9_V_CMP_LT_F32] = "v_cmp_lt_f32",
> +		[GFX9_V_CMP_EQ_F32] = "v_cmp_eq_f32",
> +		[GFX9_V_CMP_LE_F32] = "v_cmp_le_f32",
> +		[GFX9_V_CMP_GT_F32] = "v_cmp_gt_f32",
> +		[GFX9_V_CMP_LG_F32] = "v_cmp_lg_f32",
> +		[GFX9_V_CMP_GE_F32] = "v_cmp_ge_f32",
> +		[GFX9_V_CMP_O_F32] = "v_cmp_o_f32",
> +		[GFX9_V_CMP_U_F32] = "v_cmp_u_f32",
> +		[GFX9_V_CMP_NGE_F32] = "v_cmp_nge_f32",
> +		[GFX9_V_CMP_NLG_F32] = "v_cmp_nlg_f32",
> +		[GFX9_V_CMP_NGT_F32] = "v_cmp_ngt_f32",
> +		[GFX9_V_CMP_NLE_F32] = "v_cmp_nle_f32",
> +		[GFX9_V_CMP_NEQ_F32] = "v_cmp_neq_f32",
> +		[GFX9_V_CMP_NLT_F32] = "v_cmp_nlt_f32",
> +		[GFX9_V_CMP_TRU_F32] = "v_cmp_tru_f32",
> +		[GFX9_V_CMPX_F_F32] = "v_cmpx_f_f32",
> +		[GFX9_V_CMPX_LT_F32] = "v_cmpx_lt_f32",
> +		[GFX9_V_CMPX_EQ_F32] = "v_cmpx_eq_f32",
> +		[GFX9_V_CMPX_LE_F32] = "v_cmpx_le_f32",
> +		[GFX9_V_CMPX_GT_F32] = "v_cmpx_gt_f32",
> +		[GFX9_V_CMPX_LG_F32] = "v_cmpx_lg_f32",
> +		[GFX9_V_CMPX_GE_F32] = "v_cmpx_ge_f32",
> +		[GFX9_V_CMPX_O_F32] = "v_cmpx_o_f32",
> +		[GFX9_V_CMPX_U_F32] = "v_cmpx_u_f32",
> +		[GFX9_V_CMPX_NGE_F32] = "v_cmpx_nge_f32",
> +		[GFX9_V_CMPX_NLG_F32] = "v_cmpx_nlg_f32",
> +		[GFX9_V_CMPX_NGT_F32] = "v_cmpx_ngt_f32",
> +		[GFX9_V_CMPX_NLE_F32] = "v_cmpx_nle_f32",
> +		[GFX9_V_CMPX_NEQ_F32] = "v_cmpx_neq_f32",
> +		[GFX9_V_CMPX_NLT_F32] = "v_cmpx_nlt_f32",
> +		[GFX9_V_CMPX_TRU_F32] = "v_cmpx_tru_f32",
> +		[GFX9_V_CMP_F_F64] = "v_cmp_f_f64",
> +		[GFX9_V_CMP_LT_F64] = "v_cmp_lt_f64",
> +		[GFX9_V_CMP_EQ_F64] = "v_cmp_eq_f64",
> +		[GFX9_V_CMP_LE_F64] = "v_cmp_le_f64",
> +		[GFX9_V_CMP_GT_F64] = "v_cmp_gt_f64",
> +		[GFX9_V_CMP_LG_F64] = "v_cmp_lg_f64",
> +		[GFX9_V_CMP_GE_F64] = "v_cmp_ge_f64",
> +		[GFX9_V_CMP_O_F64] = "v_cmp_o_f64",
> +		[GFX9_V_CMP_U_F64] = "v_cmp_u_f64",
> +		[GFX9_V_CMP_NGE_F64] = "v_cmp_nge_f64",
> +		[GFX9_V_CMP_NLG_F64] = "v_cmp_nlg_f64",
> +		[GFX9_V_CMP_NGT_F64] = "v_cmp_ngt_f64",
> +		[GFX9_V_CMP_NLE_F64] = "v_cmp_nle_f64",
> +		[GFX9_V_CMP_NEQ_F64] = "v_cmp_neq_f64",
> +		[GFX9_V_CMP_NLT_F64] = "v_cmp_nlt_f64",
> +		[GFX9_V_CMP_TRU_F64] = "v_cmp_tru_f64",
> +		[GFX9_V_CMPX_F_F64] = "v_cmpx_f_f64",
> +		[GFX9_V_CMPX_LT_F64] = "v_cmpx_lt_f64",
> +		[GFX9_V_CMPX_EQ_F64] = "v_cmpx_eq_f64",
> +		[GFX9_V_CMPX_LE_F64] = "v_cmpx_le_f64",
> +		[GFX9_V_CMPX_GT_F64] = "v_cmpx_gt_f64",
> +		[GFX9_V_CMPX_LG_F64] = "v_cmpx_lg_f64",
> +		[GFX9_V_CMPX_GE_F64] = "v_cmpx_ge_f64",
> +		[GFX9_V_CMPX_O_F64] = "v_cmpx_o_f64",
> +		[GFX9_V_CMPX_U_F64] = "v_cmpx_u_f64",
> +		[GFX9_V_CMPX_NGE_F64] = "v_cmpx_nge_f64",
> +		[GFX9_V_CMPX_NLG_F64] = "v_cmpx_nlg_f64",
> +		[GFX9_V_CMPX_NGT_F64] = "v_cmpx_ngt_f64",
> +		[GFX9_V_CMPX_NLE_F64] = "v_cmpx_nle_f64",
> +		[GFX9_V_CMPX_NEQ_F64] = "v_cmpx_neq_f64",
> +		[GFX9_V_CMPX_NLT_F64] = "v_cmpx_nlt_f64",
> +		[GFX9_V_CMPX_TRU_F64] = "v_cmpx_tru_f64",
> +		[GFX9_V_CMP_F_I16] = "v_cmp_f_i16",
> +		[GFX9_V_CMP_LT_I16] = "v_cmp_lt_i16",
> +		[GFX9_V_CMP_EQ_I16] = "v_cmp_eq_i16",
> +		[GFX9_V_CMP_LE_I16] = "v_cmp_le_i16",
> +		[GFX9_V_CMP_GT_I16] = "v_cmp_gt_i16",
> +		[GFX9_V_CMP_NE_I16] = "v_cmp_ne_i16",
> +		[GFX9_V_CMP_GE_I16] = "v_cmp_ge_i16",
> +		[GFX9_V_CMP_T_I16] = "v_cmp_t_i16",
> +		[GFX9_V_CMP_F_U16] = "v_cmp_f_u16",
> +		[GFX9_V_CMP_LT_U16] = "v_cmp_lt_u16",
> +		[GFX9_V_CMP_EQ_U16] = "v_cmp_eq_u16",
> +		[GFX9_V_CMP_LE_U16] = "v_cmp_le_u16",
> +		[GFX9_V_CMP_GT_U16] = "v_cmp_gt_u16",
> +		[GFX9_V_CMP_NE_U16] = "v_cmp_ne_u16",
> +		[GFX9_V_CMP_GE_U16] = "v_cmp_ge_u16",
> +		[GFX9_V_CMP_T_U16] = "v_cmp_t_u16",
> +		[GFX9_V_CMPX_F_I16] = "v_cmpx_f_i16",
> +		[GFX9_V_CMPX_LT_I16] = "v_cmpx_lt_i16",
> +		[GFX9_V_CMPX_EQ_I16] = "v_cmpx_eq_i16",
> +		[GFX9_V_CMPX_LE_I16] = "v_cmpx_le_i16",
> +		[GFX9_V_CMPX_GT_I16] = "v_cmpx_gt_i16",
> +		[GFX9_V_CMPX_NE_I16] = "v_cmpx_ne_i16",
> +		[GFX9_V_CMPX_GE_I16] = "v_cmpx_ge_i16",
> +		[GFX9_V_CMPX_T_I16] = "v_cmpx_t_i16",
> +		[GFX9_V_CMPX_F_U16] = "v_cmpx_f_u16",
> +		[GFX9_V_CMPX_LT_U16] = "v_cmpx_lt_u16",
> +		[GFX9_V_CMPX_EQ_U16] = "v_cmpx_eq_u16",
> +		[GFX9_V_CMPX_LE_U16] = "v_cmpx_le_u16",
> +		[GFX9_V_CMPX_GT_U16] = "v_cmpx_gt_u16",
> +		[GFX9_V_CMPX_NE_U16] = "v_cmpx_ne_u16",
> +		[GFX9_V_CMPX_GE_U16] = "v_cmpx_ge_u16",
> +		[GFX9_V_CMPX_T_U16] = "v_cmpx_t_u16",
> +		[GFX9_V_CMP_F_I32] = "v_cmp_f_i32",
> +		[GFX9_V_CMP_LT_I32] = "v_cmp_lt_i32",
> +		[GFX9_V_CMP_EQ_I32] = "v_cmp_eq_i32",
> +		[GFX9_V_CMP_LE_I32] = "v_cmp_le_i32",
> +		[GFX9_V_CMP_GT_I32] = "v_cmp_gt_i32",
> +		[GFX9_V_CMP_NE_I32] = "v_cmp_ne_i32",
> +		[GFX9_V_CMP_GE_I32] = "v_cmp_ge_i32",
> +		[GFX9_V_CMP_T_I32] = "v_cmp_t_i32",
> +		[GFX9_V_CMP_F_U32] = "v_cmp_f_u32",
> +		[GFX9_V_CMP_LT_U32] = "v_cmp_lt_u32",
> +		[GFX9_V_CMP_EQ_U32] = "v_cmp_eq_u32",
> +		[GFX9_V_CMP_LE_U32] = "v_cmp_le_u32",
> +		[GFX9_V_CMP_GT_U32] = "v_cmp_gt_u32",
> +		[GFX9_V_CMP_NE_U32] = "v_cmp_ne_u32",
> +		[GFX9_V_CMP_GE_U32] = "v_cmp_ge_u32",
> +		[GFX9_V_CMP_T_U32] = "v_cmp_t_u32",
> +		[GFX9_V_CMPX_F_I32] = "v_cmpx_f_i32",
> +		[GFX9_V_CMPX_LT_I32] = "v_cmpx_lt_i32",
> +		[GFX9_V_CMPX_EQ_I32] = "v_cmpx_eq_i32",
> +		[GFX9_V_CMPX_LE_I32] = "v_cmpx_le_i32",
> +		[GFX9_V_CMPX_GT_I32] = "v_cmpx_gt_i32",
> +		[GFX9_V_CMPX_NE_I32] = "v_cmpx_ne_i32",
> +		[GFX9_V_CMPX_GE_I32] = "v_cmpx_ge_i32",
> +		[GFX9_V_CMPX_T_I32] = "v_cmpx_t_i32",
> +		[GFX9_V_CMPX_F_U32] = "v_cmpx_f_u32",
> +		[GFX9_V_CMPX_LT_U32] = "v_cmpx_lt_u32",
> +		[GFX9_V_CMPX_EQ_U32] = "v_cmpx_eq_u32",
> +		[GFX9_V_CMPX_LE_U32] = "v_cmpx_le_u32",
> +		[GFX9_V_CMPX_GT_U32] = "v_cmpx_gt_u32",
> +		[GFX9_V_CMPX_NE_U32] = "v_cmpx_ne_u32",
> +		[GFX9_V_CMPX_GE_U32] = "v_cmpx_ge_u32",
> +		[GFX9_V_CMPX_T_U32] = "v_cmpx_t_u32",
> +		[GFX9_V_CMP_F_I64] = "v_cmp_f_i64",
> +		[GFX9_V_CMP_LT_I64] = "v_cmp_lt_i64",
> +		[GFX9_V_CMP_EQ_I64] = "v_cmp_eq_i64",
> +		[GFX9_V_CMP_LE_I64] = "v_cmp_le_i64",
> +		[GFX9_V_CMP_GT_I64] = "v_cmp_gt_i64",
> +		[GFX9_V_CMP_NE_I64] = "v_cmp_ne_i64",
> +		[GFX9_V_CMP_GE_I64] = "v_cmp_ge_i64",
> +		[GFX9_V_CMP_T_I64] = "v_cmp_t_i64",
> +		[GFX9_V_CMP_F_U64] = "v_cmp_f_u64",
> +		[GFX9_V_CMP_LT_U64] = "v_cmp_lt_u64",
> +		[GFX9_V_CMP_EQ_U64] = "v_cmp_eq_u64",
> +		[GFX9_V_CMP_LE_U64] = "v_cmp_le_u64",
> +		[GFX9_V_CMP_GT_U64] = "v_cmp_gt_u64",
> +		[GFX9_V_CMP_NE_U64] = "v_cmp_ne_u64",
> +		[GFX9_V_CMP_GE_U64] = "v_cmp_ge_u64",
> +		[GFX9_V_CMP_T_U64] = "v_cmp_t_u64",
> +		[GFX9_V_CMPX_F_I64] = "v_cmpx_f_i64",
> +		[GFX9_V_CMPX_LT_I64] = "v_cmpx_lt_i64",
> +		[GFX9_V_CMPX_EQ_I64] = "v_cmpx_eq_i64",
> +		[GFX9_V_CMPX_LE_I64] = "v_cmpx_le_i64",
> +		[GFX9_V_CMPX_GT_I64] = "v_cmpx_gt_i64",
> +		[GFX9_V_CMPX_NE_I64] = "v_cmpx_ne_i64",
> +		[GFX9_V_CMPX_GE_I64] = "v_cmpx_ge_i64",
> +		[GFX9_V_CMPX_T_I64] = "v_cmpx_t_i64",
> +		[GFX9_V_CMPX_F_U64] = "v_cmpx_f_u64",
> +		[GFX9_V_CMPX_LT_U64] = "v_cmpx_lt_u64",
> +		[GFX9_V_CMPX_EQ_U64] = "v_cmpx_eq_u64",
> +		[GFX9_V_CMPX_LE_U64] = "v_cmpx_le_u64",
> +		[GFX9_V_CMPX_GT_U64] = "v_cmpx_gt_u64",
> +		[GFX9_V_CMPX_NE_U64] = "v_cmpx_ne_u64",
> +		[GFX9_V_CMPX_GE_U64] = "v_cmpx_ge_u64",
> +		[GFX9_V_CMPX_T_U64] = "v_cmpx_t_u64",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP3A] = {
> +		[GFX9_V_MAD_LEGACY_F32] = "v_mad_legacy_f32",
> +		[GFX9_V_MAD_F32] = "v_mad_f32",
> +		[GFX9_V_MAD_I32_I24] = "v_mad_i32_i24",
> +		[GFX9_V_MAD_U32_U24] = "v_mad_u32_u24",
> +		[GFX9_V_CUBEID_F32] = "v_cubeid_f32",
> +		[GFX9_V_CUBESC_F32] = "v_cubesc_f32",
> +		[GFX9_V_CUBETC_F32] = "v_cubetc_f32",
> +		[GFX9_V_CUBEMA_F32] = "v_cubema_f32",
> +		[GFX9_V_BFE_U32] = "v_bfe_u32",
> +		[GFX9_V_BFE_I32] = "v_bfe_i32",
> +		[GFX9_V_BFI_B32] = "v_bfi_b32",
> +		[GFX9_V_FMA_F32] = "v_fma_f32",
> +		[GFX9_V_FMA_F64] = "v_fma_f64",
> +		[GFX9_V_LERP_U8] = "v_lerp_u8",
> +		[GFX9_V_ALIGNBIT_B32] = "v_alignbit_b32",
> +		[GFX9_V_ALIGNBYTE_B32] = "v_alignbyte_b32",
> +		[GFX9_V_MIN3_F32] = "v_min3_f32",
> +		[GFX9_V_MIN3_I32] = "v_min3_i32",
> +		[GFX9_V_MIN3_U32] = "v_min3_u32",
> +		[GFX9_V_MAX3_F32] = "v_max3_f32",
> +		[GFX9_V_MAX3_I32] = "v_max3_i32",
> +		[GFX9_V_MAX3_U32] = "v_max3_u32",
> +		[GFX9_V_MED3_F32] = "v_med3_f32",
> +		[GFX9_V_MED3_I32] = "v_med3_i32",
> +		[GFX9_V_MED3_U32] = "v_med3_u32",
> +		[GFX9_V_SAD_U8] = "v_sad_u8",
> +		[GFX9_V_SAD_HI_U8] = "v_sad_hi_u8",
> +		[GFX9_V_SAD_U16] = "v_sad_u16",
> +		[GFX9_V_SAD_U32] = "v_sad_u32",
> +		[GFX9_V_CVT_PK_U8_F32] = "v_cvt_pk_u8_f32",
> +		[GFX9_V_DIV_FIXUP_F32] = "v_div_fixup_f32",
> +		[GFX9_V_DIV_FIXUP_F64] = "v_div_fixup_f64",
> +		[GFX9_V_DIV_FMAS_F32] = "v_div_fmas_f32",
> +		[GFX9_V_DIV_FMAS_F64] = "v_div_fmas_f64",
> +		[GFX9_V_MSAD_U8] = "v_msad_u8",
> +		[GFX9_V_QSAD_PK_U16_U8] = "v_qsad_pk_u16_u8",
> +		[GFX9_V_MQSAD_PK_U16_U8] = "v_mqsad_pk_u16_u8",
> +		[GFX9_V_MQSAD_U32_U8] = "v_mqsad_u32_u8",
> +		[GFX9_V_MAD_LEGACY_F16] = "v_mad_legacy_f16",
> +		[GFX9_V_MAD_LEGACY_U16] = "v_mad_legacy_u16",
> +		[GFX9_V_MAD_LEGACY_I16] = "v_mad_legacy_i16",
> +		[GFX9_V_PERM_B32] = "v_perm_b32",
> +		[GFX9_V_FMA_LEGACY_F16] = "v_fma_legacy_f16",
> +		[GFX9_V_DIV_FIXUP_LEGACY_F16] = "v_div_fixup_legacy_f16",
> +		[GFX9_V_CVT_PKACCUM_U8_F32] = "v_cvt_pkaccum_u8_f32",
> +		[GFX9_V_MAD_U32_U16] = "v_mad_u32_u16",
> +		[GFX9_V_MAD_I32_I16] = "v_mad_i32_i16",
> +		[GFX9_V_XAD_U32] = "v_xad_u32",
> +		[GFX9_V_MIN3_F16] = "v_min3_f16",
> +		[GFX9_V_MIN3_I16] = "v_min3_i16",
> +		[GFX9_V_MIN3_U16] = "v_min3_u16",
> +		[GFX9_V_MAX3_F16] = "v_max3_f16",
> +		[GFX9_V_MAX3_I16] = "v_max3_i16",
> +		[GFX9_V_MAX3_U16] = "v_max3_u16",
> +		[GFX9_V_MED3_F16] = "v_med3_f16",
> +		[GFX9_V_MED3_I16] = "v_med3_i16",
> +		[GFX9_V_MED3_U16] = "v_med3_u16",
> +		[GFX9_V_LSHL_ADD_U32] = "v_lshl_add_u32",
> +		[GFX9_V_ADD_LSHL_U32] = "v_add_lshl_u32",
> +		[GFX9_V_ADD3_U32] = "v_add3_u32",
> +		[GFX9_V_LSHL_OR_B32] = "v_lshl_or_b32",
> +		[GFX9_V_AND_OR_B32] = "v_and_or_b32",
> +		[GFX9_V_OR3_B32] = "v_or3_b32",
> +		[GFX9_V_MAD_F16] = "v_mad_f16",
> +		[GFX9_V_MAD_U16] = "v_mad_u16",
> +		[GFX9_V_MAD_I16] = "v_mad_i16",
> +		[GFX9_V_FMA_F16] = "v_fma_f16",
> +		[GFX9_V_DIV_FIXUP_F16] = "v_div_fixup_f16",
> +		[GFX9_V_INTERP_P1LL_F16] = "v_interp_p1ll_f16",
> +		[GFX9_V_INTERP_P1LV_F16] = "v_interp_p1lv_f16",
> +		[GFX9_V_INTERP_P2_LEGACY_F16] = "v_interp_p2_legacy_f16",
> +		[GFX9_V_INTERP_P2_F16] = "v_interp_p2_f16",
> +		[GFX9_V_ADD_F64] = "v_add_f64",
> +		[GFX9_V_MUL_F64] = "v_mul_f64",
> +		[GFX9_V_MIN_F64] = "v_min_f64",
> +		[GFX9_V_MAX_F64] = "v_max_f64",
> +		[GFX9_V_LDEXP_F64] = "v_ldexp_f64",
> +		[GFX9_V_MUL_LO_U32] = "v_mul_lo_u32",
> +		[GFX9_V_MUL_HI_U32] = "v_mul_hi_u32",
> +		[GFX9_V_MUL_HI_I32] = "v_mul_hi_i32",
> +		[GFX9_V_LDEXP_F32] = "v_ldexp_f32",
> +		[GFX9_V_READLANE_B32] = "v_readlane_b32",
> +		[GFX9_V_WRITELANE_B32] = "v_writelane_b32",
> +		[GFX9_V_BCNT_U32_B32] = "v_bcnt_u32_b32",
> +		[GFX9_V_MBCNT_LO_U32_B32] = "v_mbcnt_lo_u32_b32",
> +		[GFX9_V_MBCNT_HI_U32_B32] = "v_mbcnt_hi_u32_b32",
> +		[GFX9_V_LSHLREV_B64] = "v_lshlrev_b64",
> +		[GFX9_V_LSHRREV_B64] = "v_lshrrev_b64",
> +		[GFX9_V_ASHRREV_I64] = "v_ashrrev_i64",
> +		[GFX9_V_TRIG_PREOP_F64] = "v_trig_preop_f64",
> +		[GFX9_V_BFM_B32] = "v_bfm_b32",
> +		[GFX9_V_CVT_PKNORM_I16_F32] = "v_cvt_pknorm_i16_f32",
> +		[GFX9_V_CVT_PKNORM_U16_F32] = "v_cvt_pknorm_u16_f32",
> +		[GFX9_V_CVT_PKRTZ_F16_F32] = "v_cvt_pkrtz_f16_f32",
> +		[GFX9_V_CVT_PK_U16_U32] = "v_cvt_pk_u16_u32",
> +		[GFX9_V_CVT_PK_I16_I32] = "v_cvt_pk_i16_i32",
> +		[GFX9_V_CVT_PKNORM_I16_F16] = "v_cvt_pknorm_i16_f16",
> +		[GFX9_V_CVT_PKNORM_U16_F16] = "v_cvt_pknorm_u16_f16",
> +		[GFX9_V_ADD_I32] = "v_add_i32",
> +		[GFX9_V_SUB_I32] = "v_sub_i32",
> +		[GFX9_V_ADD_I16] = "v_add_i16",
> +		[GFX9_V_SUB_I16] = "v_sub_i16",
> +		[GFX9_V_PACK_B32_F16] = "v_pack_b32_f16",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP3B] = {
> +		[GFX9_V_DIV_SCALE_F64] = "v_div_scale_f64",
> +		[GFX9_V_MAD_U64_U32] = "v_mad_u64_u32",
> +		[GFX9_V_MAD_I64_I32] = "v_mad_i64_i32",
> +	},
> +	[AMDGCN_INSN_TYPE_VOP3P] = {
> +		[GFX9_V_PK_MAD_I16] = "v_pk_mad_i16",
> +		[GFX9_V_PK_MUL_LO_U16] = "v_pk_mul_lo_u16",
> +		[GFX9_V_PK_ADD_I16] = "v_pk_add_i16",
> +		[GFX9_V_PK_SUB_I16] = "v_pk_sub_i16",
> +		[GFX9_V_PK_LSHLREV_B16] = "v_pk_lshlrev_b16",
> +		[GFX9_V_PK_LSHRREV_B16] = "v_pk_lshrrev_b16",
> +		[GFX9_V_PK_ASHRREV_I16] = "v_pk_ashrrev_i16",
> +		[GFX9_V_PK_MAX_I16] = "v_pk_max_i16",
> +		[GFX9_V_PK_MIN_I16] = "v_pk_min_i16",
> +		[GFX9_V_PK_MAD_U16] = "v_pk_mad_u16",
> +		[GFX9_V_PK_ADD_U16] = "v_pk_add_u16",
> +		[GFX9_V_PK_SUB_U16] = "v_pk_sub_u16",
> +		[GFX9_V_PK_MAX_U16] = "v_pk_max_u16",
> +		[GFX9_V_PK_MIN_U16] = "v_pk_min_u16",
> +		[GFX9_V_PK_FMA_F16] = "v_pk_fma_f16",
> +		[GFX9_V_PK_ADD_F16] = "v_pk_add_f16",
> +		[GFX9_V_PK_MUL_F16] = "v_pk_mul_f16",
> +		[GFX9_V_PK_MIN_F16] = "v_pk_min_f16",
> +		[GFX9_V_PK_MAX_F16] = "v_pk_max_f16",
> +		[GFX9_V_MAD_MIX_F32] = "v_mad_mix_f32",
> +		[GFX9_V_MAD_MIXLO_F16] = "v_mad_mixlo_f16",
> +		[GFX9_V_MAD_MIXHI_F16] = "v_mad_mixhi_f16",
> +	},
> +	[AMDGCN_INSN_TYPE_MUBUF] = {
> +		[GFX9_BUFFER_LOAD_FORMAT_X] = "buffer_load_format_x",
> +		[GFX9_BUFFER_LOAD_FORMAT_XY] = "buffer_load_format_xy",
> +		[GFX9_BUFFER_LOAD_FORMAT_XYZ] = "buffer_load_format_xyz",
> +		[GFX9_BUFFER_LOAD_FORMAT_XYZW] = "buffer_load_format_xyzw",
> +		[GFX9_BUFFER_STORE_FORMAT_X] = "buffer_store_format_x",
> +		[GFX9_BUFFER_STORE_FORMAT_XY] = "buffer_store_format_xy",
> +		[GFX9_BUFFER_STORE_FORMAT_XYZ] = "buffer_store_format_xyz",
> +		[GFX9_BUFFER_STORE_FORMAT_XYZW] = "buffer_store_format_xyzw",
> +		[GFX9_BUFFER_LOAD_FORMAT_D16_X] = "buffer_load_format_d16_x",
> +		[GFX9_BUFFER_LOAD_FORMAT_D16_XY] = "buffer_load_format_d16_xy",
> +		[GFX9_BUFFER_LOAD_FORMAT_D16_XYZ] = "buffer_load_format_d16_xyz",
> +		[GFX9_BUFFER_LOAD_FORMAT_D16_XYZW] = "buffer_load_format_d16_xyzw",
> +		[GFX9_BUFFER_STORE_FORMAT_D16_X] = "buffer_store_format_d16_x",
> +		[GFX9_BUFFER_STORE_FORMAT_D16_XY] = "buffer_store_format_d16_xy",
> +		[GFX9_BUFFER_STORE_FORMAT_D16_XYZ] = "buffer_store_format_d16_xyz",
> +		[GFX9_BUFFER_STORE_FORMAT_D16_XYZW] = "buffer_store_format_d16_xyzw",
> +		[GFX9_BUFFER_LOAD_UBYTE] = "buffer_load_ubyte",
> +		[GFX9_BUFFER_LOAD_SBYTE] = "buffer_load_sbyte",
> +		[GFX9_BUFFER_LOAD_USHORT] = "buffer_load_ushort",
> +		[GFX9_BUFFER_LOAD_SSHORT] = "buffer_load_sshort",
> +		[GFX9_BUFFER_LOAD_DWORD] = "buffer_load_dword",
> +		[GFX9_BUFFER_LOAD_DWORDX2] = "buffer_load_dwordx2",
> +		[GFX9_BUFFER_LOAD_DWORDX3] = "buffer_load_dwordx3",
> +		[GFX9_BUFFER_LOAD_DWORDX4] = "buffer_load_dwordx4",
> +		[GFX9_BUFFER_STORE_BYTE] = "buffer_store_byte",
> +		[GFX9_BUFFER_STORE_BYTE_D16_HI] = "buffer_store_byte_d16_hi",
> +		[GFX9_BUFFER_STORE_SHORT] = "buffer_store_short",
> +		[GFX9_BUFFER_STORE_SHORT_D16_HI] = "buffer_store_short_d16_hi",
> +		[GFX9_BUFFER_STORE_DWORD] = "buffer_store_dword",
> +		[GFX9_BUFFER_STORE_DWORDX2] = "buffer_store_dwordx2",
> +		[GFX9_BUFFER_STORE_DWORDX3] = "buffer_store_dwordx3",
> +		[GFX9_BUFFER_STORE_DWORDX4] = "buffer_store_dwordx4",
> +		[GFX9_BUFFER_LOAD_UBYTE_D16] = "buffer_load_ubyte_d16",
> +		[GFX9_BUFFER_LOAD_UBYTE_D16_HI] = "buffer_load_ubyte_d16_hi",
> +		[GFX9_BUFFER_LOAD_SBYTE_D16] = "buffer_load_sbyte_d16",
> +		[GFX9_BUFFER_LOAD_SBYTE_D16_HI] = "buffer_load_sbyte_d16_hi",
> +		[GFX9_BUFFER_LOAD_SHORT_D16] = "buffer_load_short_d16",
> +		[GFX9_BUFFER_LOAD_SHORT_D16_HI] = "buffer_load_short_d16_hi",
> +		[GFX9_BUFFER_LOAD_FORMAT_D16_HI_X] = "buffer_load_format_d16_hi_x",
> +		[GFX9_BUFFER_STORE_FORMAT_D16_HI_X] = "buffer_store_format_d16_hi_x",
> +		[GFX9_BUFFER_STORE_LDS_DWORD] = "buffer_store_lds_dword",
> +		[GFX9_BUFFER_WBINVL1] = "buffer_wbinvl1",
> +		[GFX9_BUFFER_WBINVL1_VOL] = "buffer_wbinvl1_vol",
> +		[GFX9_BUFFER_ATOMIC_SWAP] = "buffer_atomic_swap",
> +		[GFX9_BUFFER_ATOMIC_CMPSWAP] = "buffer_atomic_cmpswap",
> +		[GFX9_BUFFER_ATOMIC_ADD] = "buffer_atomic_add",
> +		[GFX9_BUFFER_ATOMIC_SUB] = "buffer_atomic_sub",
> +		[GFX9_BUFFER_ATOMIC_SMIN] = "buffer_atomic_smin",
> +		[GFX9_BUFFER_ATOMIC_UMIN] = "buffer_atomic_umin",
> +		[GFX9_BUFFER_ATOMIC_SMAX] = "buffer_atomic_smax",
> +		[GFX9_BUFFER_ATOMIC_UMAX] = "buffer_atomic_umax",
> +		[GFX9_BUFFER_ATOMIC_AND] = "buffer_atomic_and",
> +		[GFX9_BUFFER_ATOMIC_OR] = "buffer_atomic_or",
> +		[GFX9_BUFFER_ATOMIC_XOR] = "buffer_atomic_xor",
> +		[GFX9_BUFFER_ATOMIC_INC] = "buffer_atomic_inc",
> +		[GFX9_BUFFER_ATOMIC_DEC] = "buffer_atomic_dec",
> +		[GFX9_BUFFER_ATOMIC_SWAP_X2] = "buffer_atomic_swap_x2",
> +		[GFX9_BUFFER_ATOMIC_CMPSWAP_X2] = "buffer_atomic_cmpswap_x2",
> +		[GFX9_BUFFER_ATOMIC_ADD_X2] = "buffer_atomic_add_x2",
> +		[GFX9_BUFFER_ATOMIC_SUB_X2] = "buffer_atomic_sub_x2",
> +		[GFX9_BUFFER_ATOMIC_SMIN_X2] = "buffer_atomic_smin_x2",
> +		[GFX9_BUFFER_ATOMIC_UMIN_X2] = "buffer_atomic_umin_x2",
> +		[GFX9_BUFFER_ATOMIC_SMAX_X2] = "buffer_atomic_smax_x2",
> +		[GFX9_BUFFER_ATOMIC_UMAX_X2] = "buffer_atomic_umax_x2",
> +		[GFX9_BUFFER_ATOMIC_AND_X2] = "buffer_atomic_and_x2",
> +		[GFX9_BUFFER_ATOMIC_OR_X2] = "buffer_atomic_or_x2",
> +		[GFX9_BUFFER_ATOMIC_XOR_X2] = "buffer_atomic_xor_x2",
> +		[GFX9_BUFFER_ATOMIC_INC_X2] = "buffer_atomic_inc_x2",
> +		[GFX9_BUFFER_ATOMIC_DEC_X2] = "buffer_atomic_dec_x2",
> +	},
> +	[AMDGCN_INSN_TYPE_FLAT] = {
> +		[GFX9_GLOBAL_LOAD_UBYTE] = "global_load_ubyte",
> +		[GFX9_GLOBAL_LOAD_SBYTE] = "global_load_sbyte",
> +		[GFX9_GLOBAL_LOAD_USHORT] = "global_load_ushort",
> +		[GFX9_GLOBAL_LOAD_SSHORT] = "global_load_sshort",
> +		[GFX9_GLOBAL_LOAD_DWORD] = "global_load_dword",
> +		[GFX9_GLOBAL_LOAD_DWORDX2] = "global_load_dwordx2",
> +		[GFX9_GLOBAL_LOAD_DWORDX3] = "global_load_dwordx3",
> +		[GFX9_GLOBAL_LOAD_DWORDX4] = "global_load_dwordx4",
> +		[GFX9_GLOBAL_STORE_BYTE] = "global_store_byte",
> +		[GFX9_GLOBAL_STORE_BYTE_D16_HI] = "global_store_byte_d16_hi",
> +		[GFX9_GLOBAL_STORE_SHORT] = "global_store_short",
> +		[GFX9_GLOBAL_STORE_SHORT_D16_HI] = "global_store_short_d16_hi",
> +		[GFX9_GLOBAL_STORE_DWORD] = "global_store_dword",
> +		[GFX9_GLOBAL_STORE_DWORDX2] = "global_store_dwordx2",
> +		[GFX9_GLOBAL_STORE_DWORDX3] = "global_store_dwordx3",
> +		[GFX9_GLOBAL_STORE_DWORDX4] = "global_store_dwordx4",
> +		[GFX9_GLOBAL_LOAD_UBYTE_D16] = "global_load_ubyte_d16",
> +		[GFX9_GLOBAL_LOAD_UBYTE_D16_HI] = "global_load_ubyte_d16_hi",
> +		[GFX9_GLOBAL_LOAD_SBYTE_D16] = "global_load_sbyte_d16",
> +		[GFX9_GLOBAL_LOAD_SBYTE_D16_HI] = "global_load_sbyte_d16_hi",
> +		[GFX9_GLOBAL_LOAD_SHORT_D16] = "global_load_short_d16",
> +		[GFX9_GLOBAL_LOAD_SHORT_D16_HI] = "global_load_short_d16_hi",
> +		[GFX9_GLOBAL_ATOMIC_SWAP] = "global_atomic_swap",
> +		[GFX9_GLOBAL_ATOMIC_CMPSWAP] = "global_atomic_cmpswap",
> +		[GFX9_GLOBAL_ATOMIC_ADD] = "global_atomic_add",
> +		[GFX9_GLOBAL_ATOMIC_SUB] = "global_atomic_sub",
> +		[GFX9_GLOBAL_ATOMIC_SMIN] = "global_atomic_smin",
> +		[GFX9_GLOBAL_ATOMIC_UMIN] = "global_atomic_umin",
> +		[GFX9_GLOBAL_ATOMIC_SMAX] = "global_atomic_smax",
> +		[GFX9_GLOBAL_ATOMIC_UMAX] = "global_atomic_umax",
> +		[GFX9_GLOBAL_ATOMIC_AND] = "global_atomic_and",
> +		[GFX9_GLOBAL_ATOMIC_OR] = "global_atomic_or",
> +		[GFX9_GLOBAL_ATOMIC_XOR] = "global_atomic_xor",
> +		[GFX9_GLOBAL_ATOMIC_INC] = "global_atomic_inc",
> +		[GFX9_GLOBAL_ATOMIC_DEC] = "global_atomic_dec",
> +		[GFX9_GLOBAL_ATOMIC_SWAP_X2] = "global_atomic_swap_x2",
> +		[GFX9_GLOBAL_ATOMIC_CMPSWAP_X2] = "global_atomic_cmpswap_x2",
> +		[GFX9_GLOBAL_ATOMIC_ADD_X2] = "global_atomic_add_x2",
> +		[GFX9_GLOBAL_ATOMIC_SUB_X2] = "global_atomic_sub_x2",
> +		[GFX9_GLOBAL_ATOMIC_SMIN_X2] = "global_atomic_smin_x2",
> +		[GFX9_GLOBAL_ATOMIC_UMIN_X2] = "global_atomic_umin_x2",
> +		[GFX9_GLOBAL_ATOMIC_SMAX_X2] = "global_atomic_smax_x2",
> +		[GFX9_GLOBAL_ATOMIC_UMAX_X2] = "global_atomic_umax_x2",
> +		[GFX9_GLOBAL_ATOMIC_AND_X2] = "global_atomic_and_x2",
> +		[GFX9_GLOBAL_ATOMIC_OR_X2] = "global_atomic_or_x2",
> +		[GFX9_GLOBAL_ATOMIC_XOR_X2] = "global_atomic_xor_x2",
> +		[GFX9_GLOBAL_ATOMIC_INC_X2] = "global_atomic_inc_x2",
> +		[GFX9_GLOBAL_ATOMIC_DEC_X2] = "global_atomic_dec_x2",
> +	},
> +	[AMDGCN_INSN_TYPE_DS] = {
> +		/* DS opcode names (Vega ISA 12.13, opcodes 0-255). The DS
> +		 * table was entirely unpopulated, so DS instructions
> +		 * disassembled with a blank mnemonic. Enum values were
> +		 * ISA-verified (one known value bug at DS_CONDXCHG32_RTN_B64
> +		 * is tracked separately).
> +		 */
> +		[GFX9_DS_ADD_U32] = "ds_add_u32",
> +		[GFX9_DS_SUB_U32] = "ds_sub_u32",
> +		[GFX9_DS_RSUB_U32] = "ds_rsub_u32",
> +		[GFX9_DS_INC_U32] = "ds_inc_u32",
> +		[GFX9_DS_DEC_U32] = "ds_dec_u32",
> +		[GFX9_DS_MIN_I32] = "ds_min_i32",
> +		[GFX9_DS_MAX_I32] = "ds_max_i32",
> +		[GFX9_DS_MIN_U32] = "ds_min_u32",
> +		[GFX9_DS_MAX_U32] = "ds_max_u32",
> +		[GFX9_DS_AND_B32] = "ds_and_b32",
> +		[GFX9_DS_OR_B32] = "ds_or_b32",
> +		[GFX9_DS_XOR_B32] = "ds_xor_b32",
> +		[GFX9_DS_MSKOR_B32] = "ds_mskor_b32",
> +		[GFX9_DS_WRITE_B32] = "ds_write_b32",
> +		[GFX9_DS_WRITE2_B32] = "ds_write2_b32",
> +		[GFX9_DS_WRITE2ST64_B32] = "ds_write2st64_b32",
> +		[GFX9_DS_CMPST_B32] = "ds_cmpst_b32",
> +		[GFX9_DS_CMPST_F32] = "ds_cmpst_f32",
> +		[GFX9_DS_MIN_F32] = "ds_min_f32",
> +		[GFX9_DS_MAX_F32] = "ds_max_f32",
> +		[GFX9_DS_NOP] = "ds_nop",
> +		[GFX9_DS_ADD_F32] = "ds_add_f32",
> +		[GFX9_DS_WRITE_ADDTID_B32] = "ds_write_addtid_b32",
> +		[GFX9_DS_WRITE_B8] = "ds_write_b8",
> +		[GFX9_DS_WRITE_B16] = "ds_write_b16",
> +		[GFX9_DS_ADD_RTN_U32] = "ds_add_rtn_u32",
> +		[GFX9_DS_SUB_RTN_U32] = "ds_sub_rtn_u32",
> +		[GFX9_DS_RSUB_RTN_U32] = "ds_rsub_rtn_u32",
> +		[GFX9_DS_INC_RTN_U32] = "ds_inc_rtn_u32",
> +		[GFX9_DS_DEC_RTN_U32] = "ds_dec_rtn_u32",
> +		[GFX9_DS_MIN_RTN_I32] = "ds_min_rtn_i32",
> +		[GFX9_DS_MAX_RTN_I32] = "ds_max_rtn_i32",
> +		[GFX9_DS_MIN_RTN_U32] = "ds_min_rtn_u32",
> +		[GFX9_DS_MAX_RTN_U32] = "ds_max_rtn_u32",
> +		[GFX9_DS_AND_RTN_B32] = "ds_and_rtn_b32",
> +		[GFX9_DS_OR_RTN_B32] = "ds_or_rtn_b32",
> +		[GFX9_DS_XOR_RTN_B32] = "ds_xor_rtn_b32",
> +		[GFX9_DS_MSKOR_RTN_B32] = "ds_mskor_rtn_b32",
> +		[GFX9_DS_WRXCHG_RTN_B32] = "ds_wrxchg_rtn_b32",
> +		[GFX9_DS_WRXCHG2_RTN_B32] = "ds_wrxchg2_rtn_b32",
> +		[GFX9_DS_WRXCHG2ST64_RTN_B32] = "ds_wrxchg2st64_rtn_b32",
> +		[GFX9_DS_CMPST_RTN_B32] = "ds_cmpst_rtn_b32",
> +		[GFX9_DS_CMPST_RTN_F32] = "ds_cmpst_rtn_f32",
> +		[GFX9_DS_MIN_RTN_F32] = "ds_min_rtn_f32",
> +		[GFX9_DS_MAX_RTN_F32] = "ds_max_rtn_f32",
> +		[GFX9_DS_WRAP_RTN_B32] = "ds_wrap_rtn_b32",
> +		[GFX9_DS_ADD_RTN_F32] = "ds_add_rtn_f32",
> +		[GFX9_DS_READ_B32] = "ds_read_b32",
> +		[GFX9_DS_READ2_B32] = "ds_read2_b32",
> +		[GFX9_DS_READ2ST64_B32] = "ds_read2st64_b32",
> +		[GFX9_DS_READ_I8] = "ds_read_i8",
> +		[GFX9_DS_READ_U8] = "ds_read_u8",
> +		[GFX9_DS_READ_I16] = "ds_read_i16",
> +		[GFX9_DS_READ_U16] = "ds_read_u16",
> +		[GFX9_DS_SWIZZLE_B32] = "ds_swizzle_b32",
> +		[GFX9_DS_PERMUTE_B32] = "ds_permute_b32",
> +		[GFX9_DS_BPERMUTE_B32] = "ds_bpermute_b32",
> +		[GFX9_DS_ADD_U64] = "ds_add_u64",
> +		[GFX9_DS_SUB_U64] = "ds_sub_u64",
> +		[GFX9_DS_RSUB_U64] = "ds_rsub_u64",
> +		[GFX9_DS_INC_U64] = "ds_inc_u64",
> +		[GFX9_DS_DEC_U64] = "ds_dec_u64",
> +		[GFX9_DS_MIN_I64] = "ds_min_i64",
> +		[GFX9_DS_MAX_I64] = "ds_max_i64",
> +		[GFX9_DS_MIN_U64] = "ds_min_u64",
> +		[GFX9_DS_MAX_U64] = "ds_max_u64",
> +		[GFX9_DS_AND_B64] = "ds_and_b64",
> +		[GFX9_DS_OR_B64] = "ds_or_b64",
> +		[GFX9_DS_XOR_B64] = "ds_xor_b64",
> +		[GFX9_DS_MSKOR_B64] = "ds_mskor_b64",
> +		[GFX9_DS_WRITE_B64] = "ds_write_b64",
> +		[GFX9_DS_WRITE2_B64] = "ds_write2_b64",
> +		[GFX9_DS_WRITE2ST64_B64] = "ds_write2st64_b64",
> +		[GFX9_DS_CMPST_B64] = "ds_cmpst_b64",
> +		[GFX9_DS_CMPST_F64] = "ds_cmpst_f64",
> +		[GFX9_DS_MIN_F64] = "ds_min_f64",
> +		[GFX9_DS_MAX_F64] = "ds_max_f64",
> +		[GFX9_DS_WRITE_B8_D16_HI] = "ds_write_b8_d16_hi",
> +		[GFX9_DS_WRITE_B16_D16_HI] = "ds_write_b16_d16_hi",
> +		[GFX9_DS_READ_U8_D16] = "ds_read_u8_d16",
> +		[GFX9_DS_READ_U8_D16_HI] = "ds_read_u8_d16_hi",
> +		[GFX9_DS_READ_I8_D16] = "ds_read_i8_d16",
> +		[GFX9_DS_READ_I8_D16_HI] = "ds_read_i8_d16_hi",
> +		[GFX9_DS_READ_U16_D16] = "ds_read_u16_d16",
> +		[GFX9_DS_READ_U16_D16_HI] = "ds_read_u16_d16_hi",
> +		[GFX9_DS_ADD_RTN_U64] = "ds_add_rtn_u64",
> +		[GFX9_DS_SUB_RTN_U64] = "ds_sub_rtn_u64",
> +		[GFX9_DS_RSUB_RTN_U64] = "ds_rsub_rtn_u64",
> +		[GFX9_DS_INC_RTN_U64] = "ds_inc_rtn_u64",
> +		[GFX9_DS_DEC_RTN_U64] = "ds_dec_rtn_u64",
> +		[GFX9_DS_MIN_RTN_I64] = "ds_min_rtn_i64",
> +		[GFX9_DS_MAX_RTN_I64] = "ds_max_rtn_i64",
> +		[GFX9_DS_MIN_RTN_U64] = "ds_min_rtn_u64",
> +		[GFX9_DS_MAX_RTN_U64] = "ds_max_rtn_u64",
> +		[GFX9_DS_AND_RTN_B64] = "ds_and_rtn_b64",
> +		[GFX9_DS_OR_RTN_B64] = "ds_or_rtn_b64",
> +		[GFX9_DS_XOR_RTN_B64] = "ds_xor_rtn_b64",
> +		[GFX9_DS_MSKOR_RTN_B64] = "ds_mskor_rtn_b64",
> +		[GFX9_DS_WRXCHG_RTN_B64] = "ds_wrxchg_rtn_b64",
> +		[GFX9_DS_WRXCHG2_RTN_B64] = "ds_wrxchg2_rtn_b64",
> +		[GFX9_DS_WRXCHG2ST64_RTN_B64] = "ds_wrxchg2st64_rtn_b64",
> +		[GFX9_DS_CMPST_RTN_B64] = "ds_cmpst_rtn_b64",
> +		[GFX9_DS_CMPST_RTN_F64] = "ds_cmpst_rtn_f64",
> +		[GFX9_DS_MIN_RTN_F64] = "ds_min_rtn_f64",
> +		[GFX9_DS_MAX_RTN_F64] = "ds_max_rtn_f64",
> +		[GFX9_DS_READ_B64] = "ds_read_b64",
> +		[GFX9_DS_READ2_B64] = "ds_read2_b64",
> +		[GFX9_DS_CONDXCHG32_RTN_B64] = "ds_condxchg32_rtn_b64",
> +		[GFX9_DS_ADD_SRC2_U32] = "ds_add_src2_u32",
> +		[GFX9_DS_SUB_SRC2_U32] = "ds_sub_src2_u32",
> +		[GFX9_DS_RSUB_SRC2_U32] = "ds_rsub_src2_u32",
> +		[GFX9_DS_INC_SRC2_U32] = "ds_inc_src2_u32",
> +		[GFX9_DS_DEC_SRC2_U32] = "ds_dec_src2_u32",
> +		[GFX9_DS_MIN_SRC2_I32] = "ds_min_src2_i32",
> +		[GFX9_DS_MAX_SRC2_I32] = "ds_max_src2_i32",
> +		[GFX9_DS_MIN_SRC2_U32] = "ds_min_src2_u32",
> +		[GFX9_DS_MAX_SRC2_U32] = "ds_max_src2_u32",
> +		[GFX9_DS_AND_SRC2_B32] = "ds_and_src2_b32",
> +		[GFX9_DS_OR_SRC2_B32] = "ds_or_src2_b32",
> +		[GFX9_DS_XOR_SRC2_B32] = "ds_xor_src2_b32",
> +		[GFX9_DS_WRITE_SRC2_B32] = "ds_write_src2_b32",
> +		[GFX9_DS_MIN_SRC2_F32] = "ds_min_src2_f32",
> +		[GFX9_DS_MAX_SRC2_F32] = "ds_max_src2_f32",
> +		[GFX9_DS_ADD_SRC2_F32] = "ds_add_src2_f32",
> +		[GFX9_DS_GWS_SEMA_RELEASE_ALL] = "ds_gws_sema_release_all",
> +		[GFX9_DS_ADD_SRC2_U64] = "ds_add_src2_u64",
> +		[GFX9_DS_SUB_SRC2_U64] = "ds_sub_src2_u64",
> +		[GFX9_DS_RSUB_SRC2_U64] = "ds_rsub_src2_u64",
> +		[GFX9_DS_INC_SRC2_U64] = "ds_inc_src2_u64",
> +		[GFX9_DS_DEC_SRC2_U64] = "ds_dec_src2_u64",
> +		[GFX9_DS_MIN_SRC2_I64] = "ds_min_src2_i64",
> +		[GFX9_DS_MAX_SRC2_I64] = "ds_max_src2_i64",
> +		[GFX9_DS_MIN_SRC2_U64] = "ds_min_src2_u64",
> +		[GFX9_DS_MAX_SRC2_U64] = "ds_max_src2_u64",
> +		[GFX9_DS_AND_SRC2_B64] = "ds_and_src2_b64",
> +		[GFX9_DS_OR_SRC2_B64] = "ds_or_src2_b64",
> +		[GFX9_DS_XOR_SRC2_B64] = "ds_xor_src2_b64",
> +		[GFX9_DS_WRITE_SRC2_B64] = "ds_write_src2_b64",
> +		[GFX9_DS_MIN_SRC2_F64] = "ds_min_src2_f64",
> +		[GFX9_DS_MAX_SRC2_F64] = "ds_max_src2_f64",
> +		[GFX9_DS_WRITE_B96] = "ds_write_b96",
> +		[GFX9_DS_WRITE_B128] = "ds_write_b128",
> +		[GFX9_DS_READ_B96] = "ds_read_b96",
> +		[GFX9_DS_READ_B128] = "ds_read_b128",
> +	},
> +};
> +
> +struct amdgcn_insn  {
> +	union {
> +		union amdgcn_gfx10_insn gfx10;
> +		union amdgcn_gfx9_insn gfx9;
> +	};
> +	u32 size;
> +	u32 idx;
> +	enum amdgcn_insn_type type;
> +};
> +
> +static inline void emit_s_load_dwordx2(int version, struct amdgcn_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src, int offset)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_load_dwordx2(&insn->gfx10, dst,
> +						       src,
> +						       offset);
> +		insn->type = AMDGCN_INSN_TYPE_SMEM;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_load_dwordx2(&insn->gfx9, dst,
> +						      src,
> +						      offset);
> +		insn->type = AMDGCN_INSN_TYPE_SMEM;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_load_dwordx2_soff(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src,
> +				     int offset, u8 soffset)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_load_dwordx2(&insn->gfx10, dst,
> +						       src, offset);
> +		insn->gfx10.smem.soffset = soffset;
> +		insn->type = AMDGCN_INSN_TYPE_SMEM;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_load_dwordx2(&insn->gfx9, dst,
> +						      src, offset);
> +		insn->gfx9.smem.soe = 1;
> +		insn->gfx9.smem.soffset = soffset;
> +		insn->type = AMDGCN_INSN_TYPE_SMEM;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_lshl_b32(int version, struct amdgcn_insn *insn,
> +			     struct amdgcn_param32 dst,
> +			     struct amdgcn_param32 src0,
> +			     struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_lshl_b32(&insn->gfx10, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_lshl_b32(&insn->gfx9, dst,
> +						   src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_bfe_i32(int version, struct amdgcn_insn *insn,
> +			   struct amdgcn_param32 dst,
> +			   struct amdgcn_param32 src0,
> +			   struct amdgcn_param32 src1,
> +			   struct amdgcn_param32 src2)
> +{
> +	WARN_ON(knod_param_is_literal(src0) ||
> +		knod_param_is_literal(src1) ||
> +		knod_param_is_literal(src2));
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_bfe_i32(&insn->gfx10,
> +						  dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_bfe_i32(&insn->gfx9,
> +						 dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_bfe_u32(int version, struct amdgcn_insn *insn,
> +			   struct amdgcn_param32 dst,
> +			   struct amdgcn_param32 src0,
> +			   struct amdgcn_param32 src1,
> +			   struct amdgcn_param32 src2)
> +{
> +	WARN_ON(knod_param_is_literal(src0) ||
> +		knod_param_is_literal(src1) ||
> +		knod_param_is_literal(src2));
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_bfe_u32(&insn->gfx10,
> +						  dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_bfe_u32(&insn->gfx9,
> +						 dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_bfi_b32(int version, struct amdgcn_insn *insn,
> +			   struct amdgcn_param32 dst,
> +			   struct amdgcn_param32 src0,
> +			   struct amdgcn_param32 src1,
> +			   struct amdgcn_param32 src2)
> +{
> +	WARN_ON(knod_param_is_literal(src0) ||
> +		knod_param_is_literal(src1) ||
> +		knod_param_is_literal(src2));
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_bfi_b32(&insn->gfx10,
> +						  dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_bfi_b32(&insn->gfx9,
> +						 dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_lshl_add_u32(int version, struct amdgcn_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1,
> +				struct amdgcn_param32 src2)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_lshl_add_u32(&insn->gfx10,
> +						       dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_lshl_add_u32(&insn->gfx9,
> +						      dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_lshl_or_b32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1,
> +			       struct amdgcn_param32 src2)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_lshl_or_b32(&insn->gfx10,
> +						      dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_lshl_or_b32(&insn->gfx9,
> +						     dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_alignbit_b32(int version, struct amdgcn_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1,
> +				struct amdgcn_param32 src2)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_alignbit_b32(&insn->gfx10,
> +						       dst, src0,
> +						       src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_alignbit_b32(&insn->gfx9,
> +						      dst, src0,
> +						      src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_perm_b32(int version, struct amdgcn_insn *insn,
> +			    struct amdgcn_param32 dst,
> +			    struct amdgcn_param32 src0,
> +			    struct amdgcn_param32 src1,
> +			    struct amdgcn_param32 src2)
> +{
> +	WARN_ON(knod_param_is_literal(src0) ||
> +		knod_param_is_literal(src1) ||
> +		knod_param_is_literal(src2));
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_perm_b32(&insn->gfx10,
> +						    dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_perm_b32(&insn->gfx9,
> +						   dst, src0, src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_mad_u64_u32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param64 dst,
> +			       struct amdgcn_param32 dst2,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1,
> +			       struct amdgcn_param64 src2)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_mad_u64_u32(&insn->gfx10, dst,
> +						      dst2, src0,
> +						      src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3B;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_mad_u64_u32(&insn->gfx9, dst,
> +						     dst2, src0,
> +						     src1, src2);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3B;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_mov_b32(int version, struct amdgcn_insn *insn,
> +			   struct amdgcn_param32 dst, struct amdgcn_param32 src)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_mov_b32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_mov_b32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_mov_b32_e32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_mov_b32_e32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOP1;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_mov_b32_e32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOP1;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_readfirstlane_b32(int version,
> +				     struct amdgcn_insn *insn,
> +				     u8 sdst, u8 vsrc)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_readfirstlane_b32(&insn->gfx10,
> +							    sdst, vsrc);
> +		insn->type = AMDGCN_INSN_TYPE_VOP1;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_readfirstlane_b32(&insn->gfx9,
> +							   sdst, vsrc);
> +		insn->type = AMDGCN_INSN_TYPE_VOP1;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_add_co_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_add_co_u32(&insn->gfx10, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3B;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_add_co_u32(&insn->gfx9, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_add_co_ci_u32_e32(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_add_co_ci_u32_e32(&insn->gfx10,
> +							    dst, src0,
> +							    src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_addc_co_u32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +/* No carry in/out */
> +static inline void emit_v_add_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_add_nc_u32(&insn->gfx10, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_add_u32(&insn->gfx9, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +/* No carry in/out */
> +static inline void emit_v_sub_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_sub_nc_u32(&insn->gfx10, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_sub_u32(&insn->gfx9, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_xor_b32_e32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_xor_b32_e32(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_xor_b32_e32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_or_b32_e32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_or_b32_e32(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_or_b32_e32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cndmask_b32_e32(int version, struct amdgcn_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_cndmask_b32_e32(&insn->gfx10, dst,
> +							   src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_cndmask_b32_e32(&insn->gfx9, dst,
> +							  src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_and_b32_e32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_and_b32_e32(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_and_b32_e32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_sub_co_ci_u32_e32(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_sub_co_ci_u32_e32(&insn->gfx10,
> +							    dst, src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_subb_co_u32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_subrev_co_ci_u32_e32(int version,
> +					struct amdgcn_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src0,
> +					struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_subrev_co_ci_u32_e32(&insn->gfx10,
> +							       dst, src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_subbrev_co_u32(&insn->gfx9, dst,
> +							src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_sub_co_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_sub_co_u32(&insn->gfx10, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3B;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_sub_co_u32(&insn->gfx9, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_subrev_co_u32(int version, struct amdgcn_insn *insn,
> +				 struct amdgcn_param32 dst,
> +				 struct amdgcn_param32 src0,
> +				 struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_subrev_co_u32(&insn->gfx10, dst,
> +							src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3B;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_subrev_co_u32(&insn->gfx9, dst,
> +						       src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_mul_lo_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_mul_lo_u32(&insn->gfx10, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_mul_lo_u32(&insn->gfx9, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_mbcnt_lo_u32_b32(int version,
> +				    struct amdgcn_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_mbcnt_lo_u32_b32(&insn->gfx10,
> +							    dst, src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_mbcnt_lo_u32_b32(&insn->gfx9,
> +							   dst, src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_mbcnt_hi_u32_b32(int version,
> +				    struct amdgcn_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_mbcnt_hi_u32_b32(&insn->gfx10,
> +							    dst, src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_mbcnt_hi_u32_b32(&insn->gfx9,
> +							   dst, src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_mul_hi_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src0,
> +			      struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_mul_hi_u32(&insn->gfx10, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_mul_hi_u32(&insn->gfx9, dst,
> +						    src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_lshlrev_b64(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param64 dst,
> +			       struct amdgcn_param64 src0,
> +			       struct amdgcn_param64 src1)
> +{
> +	/* D.u64 = S1.u64 << S0.u[5:0]. */
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_lshlrev_b64(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_lshlrev_b64(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_lshrrev_b64(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param64 dst,
> +			       struct amdgcn_param64 src0,
> +			       struct amdgcn_param64 src1)
> +{
> +	WARN_ON(src1.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_lshrrev_b64(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_lshrrev_b64(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_ashrrev_i64(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param64 dst,
> +			       struct amdgcn_param64 src0,
> +			       struct amdgcn_param64 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_ashrrev_i64(&insn->gfx10, dst, src0,
> +						      src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_ashrrev_i64(&insn->gfx9, dst, src0,
> +						     src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_ashrrev_i32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_ashrrev_i32(&insn->gfx10, dst, src0,
> +						      src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_ashrrev_i32(&insn->gfx9, dst, src0,
> +						     src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP3A;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_lshlrev_b32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_lshlrev_b32(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_lshlrev_b32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_lshrrev_b32(int version, struct amdgcn_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	if (version == 10) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx10_v_lshrrev_b32(&insn->gfx10, dst,
> +						      src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +		insn->size = emit_gfx9_v_lshrrev_b32(&insn->gfx9, dst,
> +						     src0, src1);
> +		insn->type = AMDGCN_INSN_TYPE_VOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_eq_u64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_eq_u64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_eq_u64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_eq_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_eq_u32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_eq_u32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_gt_u64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_gt_u64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_gt_u64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_gt_i64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_gt_i64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_gt_i64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_ge_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_ge_u32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_ge_u32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_gt_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_gt_u32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_gt_u32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_lt_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_lt_u32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_lt_u32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_le_u32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_le_u32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_le_u32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_gt_i32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_gt_i32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_gt_i32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_ge_i32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_ge_i32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_ge_i32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_lt_i32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_lt_i32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_lt_i32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_le_i32(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param32 dst,
> +			      struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_le_i32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_le_i32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +/* EXEC &= (src0 < src1), per-lane mask update */
> +static inline void emit_v_cmpx_lt_u32(int version, struct amdgcn_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src)
> +{
> +	WARN_ON_ONCE(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmpx_lt_u32(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmpx_lt_u32(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_ge_u64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_ge_u64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_ge_u64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_ge_i64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_ge_i64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_ge_i64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_lt_u64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_lt_u64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_lt_u64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_lt_i64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_lt_i64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_lt_i64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_le_u64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_le_u64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_le_u64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_v_cmp_le_i64(int version, struct amdgcn_insn *insn,
> +			      struct amdgcn_param64 dst,
> +			      struct amdgcn_param64 src)
> +{
> +	WARN_ON_ONCE(dst.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_v_cmp_le_i64(&insn->gfx10, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_v_cmp_le_i64(&insn->gfx9, dst, src);
> +		insn->type = AMDGCN_INSN_TYPE_VOPC;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_buffer_load_ubyte(int version, struct amdgcn_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src,
> +				   short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_buffer_load_ubyte(&insn->gfx10,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_buffer_load_ubyte(&insn->gfx9,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_buffer_load_ushort(int version,
> +				    struct amdgcn_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src,
> +				    short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_buffer_load_ushort(&insn->gfx10,
> +							   dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_buffer_load_ushort(&insn->gfx9,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_buffer_load_dword(int version, struct amdgcn_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src,
> +				   short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_buffer_load_dword(&insn->gfx10,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_buffer_load_dword(&insn->gfx9,
> +							 dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_buffer_load_dwordx2(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src,
> +				     short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_buffer_load_dwordx2(&insn->gfx10,
> +							    dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_buffer_load_dwordx2(&insn->gfx9,
> +							   dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_buffer_load_dwordx4(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src,
> +				     short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_buffer_load_dwordx4(&insn->gfx10,
> +							    dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_buffer_load_dwordx4(&insn->gfx9,
> +							   dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_MUBUF;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_load_ubyte(int version, struct amdgcn_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src,
> +				   short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_load_ubyte(&insn->gfx10,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_load_ubyte(&insn->gfx9,
> +							 dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_load_ushort(int version,
> +				    struct amdgcn_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src,
> +				    short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_load_ushort(&insn->gfx10,
> +							   dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_load_ushort(&insn->gfx9,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_load_dword(int version, struct amdgcn_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src,
> +				   short off)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_load_dword(&insn->gfx10,
> +							  dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_load_dword(&insn->gfx9,
> +							 dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_load_dwordx2(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src,
> +				     short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_load_dwordx2(&insn->gfx10,
> +							    dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_load_dwordx2(&insn->gfx9,
> +							   dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_load_dwordx4(int version,
> +				     struct amdgcn_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src,
> +				     short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_load_dwordx4(&insn->gfx10,
> +							    dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_load_dwordx4(&insn->gfx9,
> +							   dst, src, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_store_byte(int version, struct amdgcn_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src, int off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_store_byte(&insn->gfx10,
> +							  src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_store_byte(&insn->gfx9,
> +							 src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +#define DEFINE_EMIT_GLOBAL_ATOMIC(name)					\
> +static inline void emit_global_atomic_##name(int version,		\
> +				      struct amdgcn_insn *insn,		\
> +				      struct amdgcn_param32 vdst,	\
> +				      struct amdgcn_param32 addr,	\
> +				      struct amdgcn_param32 data,	\
> +				      int off, int glc)			\
> +{									\
> +	if (version == 10) {						\
> +		insn->size = emit_gfx10_global_atomic_##name(		\
> +			&insn->gfx10, vdst, addr, data, off, glc);	\
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;			\
> +	} else if (version == 9) {					\
> +		insn->size = emit_gfx9_global_atomic_##name(		\
> +			&insn->gfx9, vdst, addr, data, off, glc);	\
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;			\
> +	} else {							\
> +		WARN_ON_ONCE(1);						\
> +	}								\
> +}
> +
> +DEFINE_EMIT_GLOBAL_ATOMIC(add)
> +DEFINE_EMIT_GLOBAL_ATOMIC(and)
> +DEFINE_EMIT_GLOBAL_ATOMIC(or)
> +DEFINE_EMIT_GLOBAL_ATOMIC(xor)
> +DEFINE_EMIT_GLOBAL_ATOMIC(swap)
> +DEFINE_EMIT_GLOBAL_ATOMIC(cmpswap)
> +DEFINE_EMIT_GLOBAL_ATOMIC(add_x2)
> +DEFINE_EMIT_GLOBAL_ATOMIC(and_x2)
> +DEFINE_EMIT_GLOBAL_ATOMIC(or_x2)
> +DEFINE_EMIT_GLOBAL_ATOMIC(xor_x2)
> +DEFINE_EMIT_GLOBAL_ATOMIC(swap_x2)
> +DEFINE_EMIT_GLOBAL_ATOMIC(cmpswap_x2)
> +
> +static inline void emit_global_store_short(int version,
> +				    struct amdgcn_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src, int off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_store_short(&insn->gfx10,
> +							   src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_store_short(&insn->gfx9,
> +							  src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_store_dword(int version,
> +				    struct amdgcn_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src, int off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_store_dword(&insn->gfx10,
> +							   src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_store_dword(&insn->gfx9,
> +							  src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_store_dwordx2(int version,
> +				      struct amdgcn_insn *insn,
> +				      struct amdgcn_param32 dst,
> +				      struct amdgcn_param32 src, int off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_store_dwordx2(&insn->gfx10,
> +							     src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_store_dwordx2(&insn->gfx9,
> +							    src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_global_store_dwordx4(int version,
> +				      struct amdgcn_insn *insn,
> +				      struct amdgcn_param32 dst,
> +				      struct amdgcn_param32 src, int off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_global_store_dwordx4(&insn->gfx10,
> +							     src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_global_store_dwordx4(&insn->gfx9,
> +							    src, dst, off);
> +		insn->type = AMDGCN_INSN_TYPE_FLAT;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_branch(int version, struct amdgcn_insn *insn,
> +				 short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_branch(&insn->gfx10, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_branch(&insn->gfx9, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_cbranch_vccz(int version, struct amdgcn_insn *insn,
> +				       short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_cbranch_vccz(&insn->gfx10, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_cbranch_vccz(&insn->gfx9, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_cbranch_vccnz(int version, struct amdgcn_insn *insn,
> +					short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_cbranch_vccnz(&insn->gfx10, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_cbranch_vccnz(&insn->gfx9, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +/* Structurized CFG wrapper functions.
> + * Use raw SGPR indices; EXEC=126, VCC=106, integer_0=128.
> + */
> +
> +static inline void emit_s_and_saveexec_b64(int version,
> +				    struct amdgcn_insn *insn,
> +				    u8 sdst, u8 ssrc)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_and_saveexec_b64(&insn->gfx10,
> +							    sdst, ssrc);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_and_saveexec_b64(&insn->gfx9,
> +							   sdst, ssrc);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_bcnt1_i32_b64(int version, struct amdgcn_insn *insn,
> +				 u8 sdst, u8 ssrc)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_bcnt1_i32_b64(&insn->gfx10,
> +							 sdst, ssrc);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_bcnt1_i32_b64(&insn->gfx9,
> +							sdst, ssrc);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_mov_b64(int version, struct amdgcn_insn *insn,
> +			   u8 sdst, u8 ssrc)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_mov_b64(&insn->gfx10, sdst, ssrc);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_mov_b64(&insn->gfx9, sdst, ssrc);
> +		insn->type = AMDGCN_INSN_TYPE_SOP1;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_and_b64(int version, struct amdgcn_insn *insn,
> +			   u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_and_b64(&insn->gfx10,
> +						   sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_and_b64(&insn->gfx9,
> +						  sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_or_b64(int version, struct amdgcn_insn *insn,
> +			  u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_or_b64(&insn->gfx10,
> +						  sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_or_b64(&insn->gfx9,
> +						 sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_andn2_b64(int version, struct amdgcn_insn *insn,
> +			     u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_andn2_b64(&insn->gfx10,
> +						     sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_andn2_b64(&insn->gfx9,
> +						    sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_cbranch_execz(int version, struct amdgcn_insn *insn,
> +				 short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_cbranch_execz(&insn->gfx10, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_cbranch_execz(&insn->gfx9, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_cbranch_execnz(int version, struct amdgcn_insn *insn,
> +				  short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_cbranch_execnz(&insn->gfx10, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_cbranch_execnz(&insn->gfx9, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_sub_u32(int version, struct amdgcn_insn *insn,
> +			   u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_sub_u32(&insn->gfx10,
> +						   sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_sub_u32(&insn->gfx9,
> +						  sdst, ssrc0, ssrc1);
> +		insn->type = AMDGCN_INSN_TYPE_SOP2;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_cbranch_scc0(int version, struct amdgcn_insn *insn,
> +				short off)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_cbranch_scc0(&insn->gfx10, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_cbranch_scc0(&insn->gfx9, off);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_branch_fixup(int version, struct amdgcn_insn *insn,
> +				     short off)
> +{
> +	if (version == 10)
> +		insn->size = emit_gfx10_branch_fixup(&insn->gfx10, off);
> +	else if (version == 9)
> +		insn->size = emit_gfx9_branch_fixup(&insn->gfx9, off);
> +	else
> +		WARN_ON_ONCE(1);
> +}
> +
> +static inline void emit_s_waitcnt_lgkmcnt(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_waitcnt_lgkmcnt(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_waitcnt_lgkmcnt(&insn->gfx9);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_waitcnt_vmcnt(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_waitcnt_vmcnt(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_waitcnt_vmcnt(&insn->gfx9);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_waitcnt_vmcnt_lgkmcnt(int version,
> +						struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_waitcnt_vmcnt_lgkmcnt(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_waitcnt_vmcnt_lgkmcnt(&insn->gfx9);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_nop(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_nop(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_nop(&insn->gfx9);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_endpgm(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_endpgm(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_endpgm(&insn->gfx9);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_code_end(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_code_end(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		WARN_ON_ONCE(1);
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void emit_s_icache_inv(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10) {
> +		insn->size = emit_gfx10_s_icache_inv(&insn->gfx10);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else if (version == 9) {
> +		insn->size = emit_gfx9_s_icache_inv(&insn->gfx9);
> +		insn->type = AMDGCN_INSN_TYPE_SOPP;
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void gfx10_debug_vop3a(union amdgcn_gfx10_insn *insn)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +
> +	if (insn->vop3a.src0 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3a.src0);
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3a.src0 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3a.src0 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src0 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3a.src0 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src0 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3a.src0 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src1 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3a.src1);
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3a.src1 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3a.src1 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src1 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3a.src1 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src1 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3a.src1 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src2 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3a.src2);
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3a.src2 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3a.src2 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src2 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3a.src2 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src2 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3a.src2 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s, %s, %s\n",
> +		opnames_gfx10[AMDGCN_INSN_TYPE_VOP3A][insn->vop3a.op],
> +		insn->vop3a.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx10_debug_vop3b(union amdgcn_gfx10_insn *insn)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +	char sdst[20];
> +
> +	if (insn->vop3b.sdst < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(sdst, "s%d", insn->vop3b.sdst);
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(sdst, "%s", "vcc_lo");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(sdst, "%s", "vcc_hi");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_NULL)
> +		sprintf(sdst, "%s", "null");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(sdst, "%s", "exec_lo");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(sdst, "%s", "exec_hi");
> +	else if (insn->vop3b.sdst < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(sdst, "0x%x",
> +			insn->vop3b.sdst - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.sdst < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(sdst, "-0x%x",
> +			insn->vop3b.sdst - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(sdst, "%s", "vcc");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(sdst, "%s", "exec");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_SCC)
> +		sprintf(sdst, "%s", "scc");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(sdst, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.sdst >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(sdst, "v%d",
> +			insn->vop3b.sdst - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src0 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3b.src0);
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3b.src0 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3b.src0 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.src0 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3b.src0 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src0 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3b.src0 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src1 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3b.src1);
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3b.src1 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3b.src1 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.src1 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3b.src1 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src1 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3b.src1 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src2 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3b.src2);
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3b.src2 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3b.src2 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.src2 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3b.src2 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src2 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3b.src2 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s, %s, %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP3B][insn->vop3b.op],
> +		 insn->vop3b.vdst, sdst, src0, src1, src2);
> +}
> +
> +static inline void gfx10_debug_vop1(union amdgcn_gfx10_insn *insn)
> +{
> +	char src0[20];
> +
> +	if (insn->vop1.src0 < GFX10_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop1.src0);
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop1.src0 < GFX10_VOP1_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop1.src0 - GFX10_VOP1_SRC_INTEGER_0);
> +	else if (insn->vop1.src0 < GFX10_VOP1_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop1.src0 - GFX10_VOP1_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop1.literal);
> +	else if (insn->vop1.src0 >= GFX10_VOP1_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop1.src0 - GFX10_VOP1_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP1][insn->vop1.op],
> +		 insn->vop1.vdst, src0);
> +}
> +
> +static inline void gfx10_debug_vopc(union amdgcn_gfx10_insn *insn)
> +{
> +	char src0[20];
> +
> +	if (insn->vopc.src0 < GFX10_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vopc.src0);
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vopc.src0 < GFX10_VOPC_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vopc.src0 - GFX10_VOPC_SRC_INTEGER_0);
> +	else if (insn->vopc.src0 < GFX10_VOPC_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vopc.src0 - GFX10_VOPC_SRC_INTEGER_MINUS_1);
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vopc.literal);
> +	else if (insn->vopc.src0 >= GFX10_VOPC_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vopc.src0 - GFX10_VOPC_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s %s, v%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOPC][insn->vopc.op],
> +		 src0, insn->vopc.vsrc1);
> +}
> +
> +static inline void gfx10_debug_vop2(union amdgcn_gfx10_insn *insn)
> +{
> +	char src0[20];
> +
> +	if (insn->vop2.src0 < GFX10_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop2.src0);
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop2.src0 < GFX10_VOP2_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop2.src0 - GFX10_VOP2_SRC_INTEGER_0);
> +	else if (insn->vop2.src0 < GFX10_VOP2_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop2.src0 - GFX10_VOP2_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop2.literal);
> +	else if (insn->vop2.src0 >= GFX10_VOP2_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop2.src0 - GFX10_VOP2_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s v%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP2][insn->vop2.op],
> +		 insn->vop2.vdst,
> +		 src0,
> +		 insn->vop2.vsrc1);
> +}
> +
> +static inline void gfx10_debug_sop1(union amdgcn_gfx10_insn *insn)
> +{
> +	char ssrc0[20];
> +
> +	if (insn->sop1.ssrc0 < GFX10_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "s%d", insn->sop1.ssrc0);
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "%s", "vcc_lo");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_VCC_HI)
> +		sprintf(ssrc0, "%s", "vcc_hi");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_NULL)
> +		sprintf(ssrc0, "%s", "null");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_EXEC_LO)
> +		sprintf(ssrc0, "%s", "exec_lo");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_EXEC_HI)
> +		sprintf(ssrc0, "%s", "exec_hi");
> +	else if (insn->sop1.ssrc0 < GFX10_SOP1_SSRC_INTEGER_MINUS_1)
> +		sprintf(ssrc0, "0x%x",
> +			insn->sop1.ssrc0 - GFX10_SOP1_SSRC_INTEGER_0);
> +	else if (insn->sop1.ssrc0 < GFX10_SOP1_SSRC_SHARED_BASE)
> +		sprintf(ssrc0, "-0x%x",
> +			insn->sop1.ssrc0 - GFX10_SOP1_SSRC_INTEGER_MINUS_1);
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_VCCZ)
> +		sprintf(ssrc0, "%s", "vcc");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_EXECZ)
> +		sprintf(ssrc0, "%s", "exec");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_SCC)
> +		sprintf(ssrc0, "%s", "scc");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_LITERAL_CONST)
> +		sprintf(ssrc0, "0x%x", insn->sop1.literal);
> +
> +	pr_debug("knod_asm %s s%d, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOP1][insn->sop1.op],
> +		 insn->sop1.sdst,
> +		 ssrc0);
> +}
> +
> +static inline void gfx10_debug_sopp(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm %s 0x%x\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOPP][insn->sopp.op],
> +		 insn->sopp.simm16);
> +}
> +
> +static inline void gfx10_debug_smem(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("%s s[%d:%d], s[%d:%d], 0x%x\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SMEM][insn->smem.op],
> +		 insn->smem.sdata,
> +		 insn->smem.sdata + 1,
> +		 (insn->smem.sbase * 2),
> +		 (insn->smem.sbase * 2) + 1,
> +		 insn->smem.offset);
> +}
> +
> +static inline void gfx10_debug_mubuf(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm %s v%d, v%d, s[%d:%d], 0x%x offen offset:%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_MUBUF][insn->mubuf.op],
> +		 insn->mubuf.vdata,
> +		 insn->mubuf.vaddr,
> +		 insn->mubuf.srsrc,
> +		 insn->mubuf.srsrc + 3,
> +		 insn->mubuf.soffset,
> +		 insn->mubuf.offset);
> +}
> +
> +static inline void gfx10_debug_global(union amdgcn_gfx10_insn *insn)
> +{
> +	if (insn->flat.op == GFX9_GLOBAL_STORE_BYTE) {
> +		pr_debug("knod_asm %s v[%d:%d], v%d, off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_SHORT) {
> +		pr_debug("knod_asm %s v[%d:%d], v%d, off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORD) {
> +		pr_debug("knod_asm %s v[%d:%d], v%d, off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORDX2) {
> +		pr_debug("knod_asm %s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.data + 1,
> +			 insn->flat.offset);
> +	} else {
> +		pr_debug("knod_asm %s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.vdst,
> +			 insn->flat.vdst + 1,
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.offset);
> +	}
> +}
> +
> +static inline void decode_ssrc8(int ssrc, u32 literal, char *buf)
> +{
> +	if (ssrc < 106)
> +		sprintf(buf, "s%d", ssrc);
> +	else if (ssrc == 106)
> +		sprintf(buf, "vcc_lo");
> +	else if (ssrc == 107)
> +		sprintf(buf, "vcc_hi");
> +	else if (ssrc == 125)
> +		sprintf(buf, "null");
> +	else if (ssrc == 126)
> +		sprintf(buf, "exec_lo");
> +	else if (ssrc == 127)
> +		sprintf(buf, "exec_hi");
> +	else if (ssrc < 193)
> +		sprintf(buf, "0x%x", ssrc - 128);
> +	else if (ssrc < 235)
> +		sprintf(buf, "-0x%x", ssrc - 193);
> +	else if (ssrc == 251)
> +		sprintf(buf, "vcc");
> +	else if (ssrc == 252)
> +		sprintf(buf, "exec");
> +	else if (ssrc == 253)
> +		sprintf(buf, "scc");
> +	else if (ssrc == 255)
> +		sprintf(buf, "0x%x", literal);
> +	else
> +		sprintf(buf, "?%d", ssrc);
> +}
> +
> +static inline void decode_vsrc9(int src, u32 literal, char *buf)
> +{
> +	if (src >= 256)
> +		sprintf(buf, "v%d", src - 256);
> +	else
> +		decode_ssrc8(src, literal, buf);
> +}
> +
> +static inline void gfx10_debug_sop2(union amdgcn_gfx10_insn *insn)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sop2.ssrc0, insn->sop2.literal, ssrc0);
> +	decode_ssrc8(insn->sop2.ssrc1, insn->sop2.literal, ssrc1);
> +	pr_debug("knod_asm %s s%d, %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOP2][insn->sop2.op],
> +		 insn->sop2.sdst, ssrc0, ssrc1);
> +}
> +
> +static inline void gfx10_debug_sopk(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm %s s%d, 0x%x\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOPK][insn->sopk.op],
> +		 insn->sopk.sdst, insn->sopk.simm16);
> +}
> +
> +static inline void gfx10_debug_sopc(union amdgcn_gfx10_insn *insn)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sopc.ssrc0, insn->sopc.literal, ssrc0);
> +	decode_ssrc8(insn->sopc.ssrc1, insn->sopc.literal, ssrc1);
> +	pr_debug("knod_asm %s %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOPC][insn->sopc.op],
> +		 ssrc0, ssrc1);
> +}
> +
> +static inline void gfx10_debug_vop3p(union amdgcn_gfx10_insn *insn)
> +{
> +	char src0[20], src1[20], src2[20];
> +
> +	decode_vsrc9(insn->vop3p.src0, insn->vop3p.literal, src0);
> +	decode_vsrc9(insn->vop3p.src1, insn->vop3p.literal, src1);
> +	decode_vsrc9(insn->vop3p.src2, insn->vop3p.literal, src2);
> +	pr_debug("knod_asm %s v%d, %s, %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP3P][insn->vop3p.op],
> +		 (int)insn->vop3p.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx10_debug_sdwa(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm sdwa src0:%d dst_sel:%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwa.src0, insn->sdwa.dst_sel,
> +		 insn->sdwa.src0_sel, insn->sdwa.src1_sel);
> +}
> +
> +static inline void gfx10_debug_sdwab(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm sdwab src0:%d sdst:s%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwab.src0, insn->sdwab.sdst,
> +		 insn->sdwab.src0_sel, insn->sdwab.src1_sel);
> +}
> +
> +static inline void gfx10_debug_dpp16(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm dpp16 (not decoded)\n");
> +}
> +
> +static inline void gfx10_debug_dpp8(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm dpp8 (not decoded)\n");
> +}
> +
> +static inline void gfx10_debug_vintrp(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm vintrp (not decoded)\n");
> +}
> +
> +static inline void gfx10_debug_ds(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm %s v%d, v%d, v%d, v%d offset0:%d offset1:%d%s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_DS][insn->ds.op],
> +		 (int)insn->ds.vdst, (int)insn->ds.addr,
> +		 (int)insn->ds.data0, (int)insn->ds.data1,
> +		 (int)insn->ds.offset0, (int)insn->ds.offset1,
> +		 insn->ds.gds ? " gds" : "");
> +}
> +
> +static inline void gfx10_debug_mtbuf(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm %s v%d, v%d, s[%d:%d], s%d format:%d offset:%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_MTBUF][insn->mtbuf.op],
> +		 (int)insn->mtbuf.vdata, (int)insn->mtbuf.vaddr,
> +		 (int)insn->mtbuf.srsrc * 4, (int)insn->mtbuf.srsrc * 4 + 3,
> +		 (int)insn->mtbuf.soffset, (int)insn->mtbuf.foamat,
> +		 (int)insn->mtbuf.offset);
> +}
> +
> +static inline void gfx10_debug_mimg(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm mimg (not decoded)\n");
> +}
> +
> +static inline void gfx10_debug_exp(union amdgcn_gfx10_insn *insn)
> +{
> +	pr_debug("knod_asm exp (not decoded)\n");
> +}
> +
> +static inline void gfx10_debug_insn(struct amdgcn_insn *insn)
> +{
> +	u32 *ptr;
> +
> +	switch (insn->type) {
> +	case AMDGCN_INSN_TYPE_SOP2:
> +		gfx10_debug_sop2(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPK:
> +		gfx10_debug_sopk(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOP1:
> +		gfx10_debug_sop1(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPC:
> +		gfx10_debug_sopc(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPP:
> +		gfx10_debug_sopp(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SMEM:
> +		gfx10_debug_smem(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP2:
> +		gfx10_debug_vop2(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP1:
> +		gfx10_debug_vop1(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOPC:
> +		gfx10_debug_vopc(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3A:
> +		gfx10_debug_vop3a(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3B:
> +		gfx10_debug_vop3b(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3P:
> +		gfx10_debug_vop3p(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWA:
> +		gfx10_debug_sdwa(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWAB:
> +		gfx10_debug_sdwab(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP16:
> +		gfx10_debug_dpp16(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP8:
> +		gfx10_debug_dpp8(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_VINTRP:
> +		gfx10_debug_vintrp(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_DS:
> +		gfx10_debug_ds(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_MTBUF:
> +		gfx10_debug_mtbuf(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_MUBUF:
> +		gfx10_debug_mubuf(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_MIMG:
> +		gfx10_debug_mimg(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_FLAT:
> +		gfx10_debug_global(&insn->gfx10);
> +		break;
> +	case AMDGCN_INSN_TYPE_EXP:
> +		gfx10_debug_exp(&insn->gfx10);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +
> +	ptr = (u32 *)&insn->gfx10;
> +	if (insn->size == 4) {
> +		pr_debug("knod_asm %s %u %.8X\n", __func__, __LINE__, ptr[0]);
> +	} else if (insn->size == 8) {
> +		pr_debug("knod_asm %s %u %.8X %.8X\n",
> +			 __func__, __LINE__, ptr[0], ptr[1]);
> +	} else if (insn->size == 12) {
> +		pr_debug("knod_asm %s %u %.8X %.8X %.8X\n",
> +			 __func__, __LINE__, ptr[0], ptr[1], ptr[2]);
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void gfx9_debug_vop3a(union amdgcn_gfx9_insn *insn)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +
> +	if (insn->vop3a.src0 < GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3a.src0);
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3a.src0 < GFX9_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3a.src0 - GFX9_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src0 < GFX9_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3a.src0 - GFX9_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src0 >= GFX9_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3a.src0 - GFX9_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src1 < GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3a.src1);
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3a.src1 < GFX9_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3a.src1 - GFX9_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src1 < GFX9_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3a.src1 - GFX9_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src1 >= GFX9_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3a.src1 - GFX9_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src2 < GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3a.src2);
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3a.src2 < GFX9_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3a.src2 - GFX9_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src2 < GFX9_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3a.src2 - GFX9_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src2 >= GFX9_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3a.src2 - GFX9_VOP3A_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP3A][insn->vop3a.op],
> +		 insn->vop3a.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx9_debug_vop3b(union amdgcn_gfx9_insn *insn)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +	char sdst[20];
> +
> +	if (insn->vop3b.sdst < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(sdst, "s%d", insn->vop3b.sdst);
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(sdst, "%s", "vcc_lo");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(sdst, "%s", "vcc_hi");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_NULL)
> +		sprintf(sdst, "%s", "null");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(sdst, "%s", "exec_lo");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(sdst, "%s", "exec_hi");
> +	else if (insn->vop3b.sdst < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(sdst, "0x%x",
> +			insn->vop3b.sdst - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.sdst < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(sdst, "-0x%x",
> +			insn->vop3b.sdst - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(sdst, "%s", "vcc");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(sdst, "%s", "exec");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_SCC)
> +		sprintf(sdst, "%s", "scc");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(sdst, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.sdst >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(sdst, "v%d",
> +			insn->vop3b.sdst - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src0 < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3b.src0);
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3b.src0 < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3b.src0 - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.src0 < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3b.src0 - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src0 >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3b.src0 - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src1 < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3b.src1);
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3b.src1 < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3b.src1 - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.src1 < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3b.src1 - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src1 >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3b.src1 - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src2 < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3b.src2);
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3b.src2 < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3b.src2 - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.src2 < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3b.src2 - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src2 >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3b.src2 - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s, %s, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP3B][insn->vop3b.op],
> +		 insn->vop3b.vdst, sdst, src0, src1, src2);
> +}
> +
> +static inline void gfx9_debug_vop1(union amdgcn_gfx9_insn *insn)
> +{
> +	char src0[20];
> +
> +	if (insn->vop1.src0 < GFX9_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop1.src0);
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop1.src0 < GFX9_VOP1_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop1.src0 - GFX9_VOP1_SRC_INTEGER_0);
> +	else if (insn->vop1.src0 < GFX9_VOP1_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop1.src0 - GFX9_VOP1_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop1.literal);
> +	else if (insn->vop1.src0 >= GFX9_VOP1_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d", insn->vop1.src0 - GFX9_VOP1_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP1][insn->vop1.op],
> +		 insn->vop1.vdst, src0);
> +}
> +
> +static inline void gfx9_debug_vopc(union amdgcn_gfx9_insn *insn)
> +{
> +	char src0[20];
> +
> +	if (insn->vopc.src0 < GFX9_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vopc.src0);
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vopc.src0 < GFX9_VOPC_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vopc.src0 - GFX9_VOPC_SRC_INTEGER_0);
> +	else if (insn->vopc.src0 < GFX9_VOPC_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vopc.src0 - GFX9_VOPC_SRC_INTEGER_MINUS_1);
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vopc.literal);
> +	else if (insn->vopc.src0 >= GFX9_VOPC_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d", insn->vopc.src0 - GFX9_VOPC_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s %s, v%d\n",
> +		opnames_gfx9[AMDGCN_INSN_TYPE_VOPC][insn->vopc.op],
> +		src0,
> +		insn->vopc.vsrc1);
> +}
> +
> +static inline void gfx9_debug_vop2(union amdgcn_gfx9_insn *insn)
> +{
> +	char src0[20];
> +
> +	if (insn->vop2.src0 < GFX9_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop2.src0);
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop2.src0 < GFX9_VOP2_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop2.src0 - GFX9_VOP2_SRC_INTEGER_0);
> +	else if (insn->vop2.src0 < GFX9_VOP2_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop2.src0 - GFX9_VOP2_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop2.literal);
> +	else if (insn->vop2.src0 >= GFX9_VOP2_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d", insn->vop2.src0 - GFX9_VOP2_SRC_VGPR_BASE);
> +
> +	pr_debug("knod_asm %s v%d, %s v%d\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP2][insn->vop2.op],
> +		 insn->vop2.vdst,
> +		 src0,
> +		 insn->vop2.vsrc1);
> +}
> +
> +static inline void gfx9_debug_sop1(union amdgcn_gfx9_insn *insn)
> +{
> +	char ssrc0[20];
> +
> +	if (insn->sop1.ssrc0 < GFX9_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "s%d", insn->sop1.ssrc0);
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "%s", "vcc_lo");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_VCC_HI)
> +		sprintf(ssrc0, "%s", "vcc_hi");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_NULL)
> +		sprintf(ssrc0, "%s", "null");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_EXEC_LO)
> +		sprintf(ssrc0, "%s", "exec_lo");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_EXEC_HI)
> +		sprintf(ssrc0, "%s", "exec_hi");
> +	else if (insn->sop1.ssrc0 < GFX9_SOP1_SSRC_INTEGER_MINUS_1)
> +		sprintf(ssrc0, "0x%x",
> +			insn->sop1.ssrc0 - GFX9_SOP1_SSRC_INTEGER_0);
> +	else if (insn->sop1.ssrc0 < GFX9_SOP1_SSRC_SHARED_BASE)
> +		sprintf(ssrc0, "-0x%x",
> +			insn->sop1.ssrc0 - GFX9_SOP1_SSRC_INTEGER_MINUS_1);
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_VCCZ)
> +		sprintf(ssrc0, "%s", "vcc");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_EXECZ)
> +		sprintf(ssrc0, "%s", "exec");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_SCC)
> +		sprintf(ssrc0, "%s", "scc");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_LITERAL_CONST)
> +		sprintf(ssrc0, "0x%x", insn->sop1.literal);
> +
> +	pr_debug("knod_asm %s s%d, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOP1][insn->sop1.op],
> +		 insn->sop1.sdst,
> +		 ssrc0);
> +}
> +
> +static inline void gfx9_debug_sopp(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm %s 0x%x\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOPP][insn->sopp.op],
> +		 insn->sopp.simm16);
> +}
> +
> +static inline void gfx9_debug_smem(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("%s s[%d:%d], s[%d:%d], 0x%x\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SMEM][insn->smem.op],
> +		 insn->smem.sdata,
> +		 insn->smem.sdata + 1,
> +		 (insn->smem.sbase * 2),
> +		 (insn->smem.sbase * 2) + 1,
> +		 insn->smem.offset);
> +}
> +
> +static inline void gfx9_debug_mubuf(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm %s v%d, v%d, s[%d:%d], 0x%x offen offset:%d\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_MUBUF][insn->mubuf.op],
> +		 insn->mubuf.vdata,
> +		 insn->mubuf.vaddr,
> +		 insn->mubuf.srsrc,
> +		 insn->mubuf.srsrc + 3,
> +		 insn->mubuf.soffset,
> +		 insn->mubuf.offset);
> +}
> +
> +static inline void gfx9_debug_global(union amdgcn_gfx9_insn *insn)
> +{
> +	if (insn->flat.op == GFX9_GLOBAL_STORE_BYTE) {
> +		pr_debug("knod_asm %s v[%d:%d], v%d, off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_SHORT) {
> +		pr_debug("knod_asm %s v[%d:%d], v%d, off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORD) {
> +		pr_debug("knod_asm %s v[%d:%d], v%d, off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORDX2) {
> +		pr_debug("knod_asm %s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.data + 1,
> +			insn->flat.offset);
> +	} else {
> +		pr_debug("knod_asm %s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.vdst,
> +			insn->flat.vdst + 1,
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.offset);
> +	}
> +}
> +
> +static inline void gfx9_debug_sop2(union amdgcn_gfx9_insn *insn)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sop2.ssrc0, insn->sop2.literal, ssrc0);
> +	decode_ssrc8(insn->sop2.ssrc1, insn->sop2.literal, ssrc1);
> +	pr_debug("knod_asm %s s%d, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOP2][insn->sop2.op],
> +		 insn->sop2.sdst, ssrc0, ssrc1);
> +}
> +
> +static inline void gfx9_debug_sopk(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm %s s%d, 0x%x\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOPK][insn->sopk.op],
> +		 insn->sopk.sdst, insn->sopk.simm16);
> +}
> +
> +static inline void gfx9_debug_sopc(union amdgcn_gfx9_insn *insn)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sopc.ssrc0, insn->sopc.literal, ssrc0);
> +	decode_ssrc8(insn->sopc.ssrc1, insn->sopc.literal, ssrc1);
> +	pr_debug("knod_asm %s %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOPC][insn->sopc.op],
> +		 ssrc0, ssrc1);
> +}
> +
> +static inline void gfx9_debug_vop3p(union amdgcn_gfx9_insn *insn)
> +{
> +	char src0[20], src1[20], src2[20];
> +
> +	decode_vsrc9(insn->vop3p.src0, insn->vop3p.literal, src0);
> +	decode_vsrc9(insn->vop3p.src1, insn->vop3p.literal, src1);
> +	decode_vsrc9(insn->vop3p.src2, insn->vop3p.literal, src2);
> +	pr_debug("knod_asm %s v%d, %s, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP3P][insn->vop3p.op],
> +		 (int)insn->vop3p.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx9_debug_sdwa(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm sdwa src0:%d dst_sel:%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwa.src0, insn->sdwa.dst_sel,
> +		 insn->sdwa.src0_sel, insn->sdwa.src1_sel);
> +}
> +
> +static inline void gfx9_debug_sdwab(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm sdwab src0:%d sdst:s%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwab.src0, insn->sdwab.sdst,
> +		 insn->sdwab.src0_sel, insn->sdwab.src1_sel);
> +}
> +
> +static inline void gfx9_debug_dpp16(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm dpp16 (not decoded)\n");
> +}
> +
> +static inline void gfx9_debug_dpp8(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm dpp8 (not decoded)\n");
> +}
> +
> +static inline void gfx9_debug_vintrp(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm vintrp (not decoded)\n");
> +}
> +
> +static inline void gfx9_debug_ds(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm %s v%d, v%d, v%d, v%d offset0:%d offset1:%d%s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_DS][insn->ds.op],
> +		 (int)insn->ds.vdst, (int)insn->ds.addr,
> +		 (int)insn->ds.data0, (int)insn->ds.data1,
> +		 (int)insn->ds.offset0, (int)insn->ds.offset1,
> +		 insn->ds.gds ? " gds" : "");
> +}
> +
> +static inline void gfx9_debug_mtbuf(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm %s v%d, v%d, s[%d:%d], s%d dfmt:%d nfmt:%d offset:%d\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_MTBUF][insn->mtbuf.op],
> +		 (int)insn->mtbuf.vdata, (int)insn->mtbuf.vaddr,
> +		 (int)insn->mtbuf.srsrc * 4, (int)insn->mtbuf.srsrc * 4 + 3,
> +		 (int)insn->mtbuf.soffset, (int)insn->mtbuf.dfmt,
> +		 (int)insn->mtbuf.nfmt, (int)insn->mtbuf.offset);
> +}
> +
> +static inline void gfx9_debug_mimg(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm mimg (not decoded)\n");
> +}
> +
> +static inline void gfx9_debug_exp(union amdgcn_gfx9_insn *insn)
> +{
> +	pr_debug("knod_asm exp (not decoded)\n");
> +}
> +
> +static inline void gfx9_debug_insn(struct amdgcn_insn *insn)
> +{
> +	u32 *ptr;
> +
> +	switch (insn->type) {
> +	case AMDGCN_INSN_TYPE_SOP2:
> +		gfx9_debug_sop2(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPK:
> +		gfx9_debug_sopk(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOP1:
> +		gfx9_debug_sop1(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPC:
> +		gfx9_debug_sopc(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPP:
> +		gfx9_debug_sopp(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SMEM:
> +		gfx9_debug_smem(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP2:
> +		gfx9_debug_vop2(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP1:
> +		gfx9_debug_vop1(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOPC:
> +		gfx9_debug_vopc(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3A:
> +		gfx9_debug_vop3a(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3B:
> +		gfx9_debug_vop3b(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3P:
> +		gfx9_debug_vop3p(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWA:
> +		gfx9_debug_sdwa(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWAB:
> +		gfx9_debug_sdwab(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP16:
> +		gfx9_debug_dpp16(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP8:
> +		gfx9_debug_dpp8(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_VINTRP:
> +		gfx9_debug_vintrp(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_DS:
> +		gfx9_debug_ds(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_MTBUF:
> +		gfx9_debug_mtbuf(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_MUBUF:
> +		gfx9_debug_mubuf(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_MIMG:
> +		gfx9_debug_mimg(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_FLAT:
> +		gfx9_debug_global(&insn->gfx9);
> +		break;
> +	case AMDGCN_INSN_TYPE_EXP:
> +		gfx9_debug_exp(&insn->gfx9);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +
> +	ptr = (u32 *)&insn->gfx9;
> +	if (insn->size == 4) {
> +		pr_debug("knod_asm %s %u %.8X\n", __func__, __LINE__, ptr[0]);
> +	} else if (insn->size == 8) {
> +		pr_debug("knod_asm %s %u %.8X %.8X\n",
> +			 __func__, __LINE__, ptr[0], ptr[1]);
> +	} else if (insn->size == 12) {
> +		pr_debug("knod_asm %s %u %.8X %.8X %.8X\n",
> +			 __func__, __LINE__, ptr[0], ptr[1], ptr[2]);
> +	} else {
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
> +static inline void debug_insn(int version, struct amdgcn_insn *insn)
> +{
> +	if (version == 10)
> +		gfx10_debug_insn(insn);
> +	else if (version == 9)
> +		gfx9_debug_insn(insn);
> +	else
> +		WARN_ON_ONCE(1);
> +}
> +
> +static inline void gfx10_debugfs_vop3a(union amdgcn_gfx10_insn *insn,
> +				       struct seq_file *m)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +
> +	if (insn->vop3a.src0 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3a.src0);
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3a.src0 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3a.src0 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src0 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3a.src0 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3a.src0 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src0 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3a.src0 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src1 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3a.src1);
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3a.src1 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3a.src1 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src1 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3a.src1 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3a.src1 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src1 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3a.src1 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src2 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3a.src2);
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3a.src2 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3a.src2 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src2 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3a.src2 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3a.src2 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src2 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3a.src2 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s, %s, %s\n",
> +		opnames_gfx10[AMDGCN_INSN_TYPE_VOP3A][insn->vop3a.op],
> +		insn->vop3a.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx10_debugfs_vop3b(union amdgcn_gfx10_insn *insn,
> +				       struct seq_file *m)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +	char sdst[20];
> +
> +	if (insn->vop3b.sdst < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(sdst, "s%d", insn->vop3b.sdst);
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(sdst, "%s", "vcc_lo");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(sdst, "%s", "vcc_hi");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_NULL)
> +		sprintf(sdst, "%s", "null");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(sdst, "%s", "exec_lo");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(sdst, "%s", "exec_hi");
> +	else if (insn->vop3b.sdst < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(sdst, "0x%x",
> +			insn->vop3b.sdst - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.sdst < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(sdst, "-0x%x",
> +			insn->vop3b.sdst - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(sdst, "%s", "vcc");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(sdst, "%s", "exec");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_SCC)
> +		sprintf(sdst, "%s", "scc");
> +	else if (insn->vop3b.sdst == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(sdst, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.sdst >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(sdst, "v%d",
> +			insn->vop3b.sdst - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src0 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3b.src0);
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3b.src0 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3b.src0 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.src0 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3b.src0 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3b.src0 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src0 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3b.src0 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src1 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3b.src1);
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3b.src1 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3b.src1 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.src1 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3b.src1 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3b.src1 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src1 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3b.src1 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src2 < GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3b.src2);
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3b.src2 < GFX10_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3b.src2 - GFX10_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3b.src2 < GFX10_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3b.src2 - GFX10_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3b.src2 == GFX10_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src2 >= GFX10_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3b.src2 - GFX10_VOP3A_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s, %s, %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP3B][insn->vop3b.op],
> +		 insn->vop3b.vdst, sdst, src0, src1, src2);
> +}
> +
> +static inline void gfx10_debugfs_vop1(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char src0[20];
> +
> +	if (insn->vop1.src0 < GFX10_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop1.src0);
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop1.src0 < GFX10_VOP1_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop1.src0 - GFX10_VOP1_SRC_INTEGER_0);
> +	else if (insn->vop1.src0 < GFX10_VOP1_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop1.src0 - GFX10_VOP1_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop1.src0 == GFX10_VOP1_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop1.literal);
> +	else if (insn->vop1.src0 >= GFX10_VOP1_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop1.src0 - GFX10_VOP1_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP1][insn->vop1.op],
> +		 insn->vop1.vdst, src0);
> +}
> +
> +static inline void gfx10_debugfs_vopc(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char src0[20];
> +
> +	if (insn->vopc.src0 < GFX10_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vopc.src0);
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vopc.src0 < GFX10_VOPC_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vopc.src0 - GFX10_VOPC_SRC_INTEGER_0);
> +	else if (insn->vopc.src0 < GFX10_VOPC_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vopc.src0 - GFX10_VOPC_SRC_INTEGER_MINUS_1);
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vopc.src0 == GFX10_VOPC_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vopc.literal);
> +	else if (insn->vopc.src0 >= GFX10_VOPC_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vopc.src0 - GFX10_VOPC_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s %s, v%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOPC][insn->vopc.op],
> +		 src0, insn->vopc.vsrc1);
> +}
> +
> +static inline void gfx10_debugfs_vop2(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char src0[20];
> +
> +	if (insn->vop2.src0 < GFX10_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop2.src0);
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop2.src0 < GFX10_VOP2_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop2.src0 - GFX10_VOP2_SRC_INTEGER_0);
> +	else if (insn->vop2.src0 < GFX10_VOP2_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop2.src0 - GFX10_VOP2_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop2.src0 == GFX10_VOP2_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop2.literal);
> +	else if (insn->vop2.src0 >= GFX10_VOP2_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop2.src0 - GFX10_VOP2_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s v%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP2][insn->vop2.op],
> +		 insn->vop2.vdst,
> +		 src0,
> +		 insn->vop2.vsrc1);
> +}
> +
> +static inline void gfx10_debugfs_sop1(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char ssrc0[20];
> +
> +	if (insn->sop1.ssrc0 < GFX10_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "s%d", insn->sop1.ssrc0);
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "%s", "vcc_lo");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_VCC_HI)
> +		sprintf(ssrc0, "%s", "vcc_hi");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_NULL)
> +		sprintf(ssrc0, "%s", "null");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_EXEC_LO)
> +		sprintf(ssrc0, "%s", "exec_lo");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_EXEC_HI)
> +		sprintf(ssrc0, "%s", "exec_hi");
> +	else if (insn->sop1.ssrc0 < GFX10_SOP1_SSRC_INTEGER_MINUS_1)
> +		sprintf(ssrc0, "0x%x",
> +			insn->sop1.ssrc0 - GFX10_SOP1_SSRC_INTEGER_0);
> +	else if (insn->sop1.ssrc0 < GFX10_SOP1_SSRC_SHARED_BASE)
> +		sprintf(ssrc0, "-0x%x",
> +			insn->sop1.ssrc0 - GFX10_SOP1_SSRC_INTEGER_MINUS_1);
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_VCCZ)
> +		sprintf(ssrc0, "%s", "vcc");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_EXECZ)
> +		sprintf(ssrc0, "%s", "exec");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_SCC)
> +		sprintf(ssrc0, "%s", "scc");
> +	else if (insn->sop1.ssrc0 == GFX10_SOP1_SSRC_LITERAL_CONST)
> +		sprintf(ssrc0, "0x%x", insn->sop1.literal);
> +
> +	seq_printf(m, "%s s%d, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOP1][insn->sop1.op],
> +		 insn->sop1.sdst,
> +		 ssrc0);
> +}
> +
> +static inline void gfx10_debugfs_sopp(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "%s 0x%x\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOPP][insn->sopp.op],
> +		 insn->sopp.simm16);
> +}
> +
> +static inline void gfx10_debugfs_smem(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "%s s[%d:%d], s[%d:%d], 0x%x\n",
> +		   opnames_gfx10[AMDGCN_INSN_TYPE_SMEM][insn->smem.op],
> +		   insn->smem.sdata,
> +		   insn->smem.sdata + 1,
> +		   (insn->smem.sbase * 2),
> +		   (insn->smem.sbase * 2) + 1,
> +		   insn->smem.offset);
> +}
> +
> +static inline void gfx10_debugfs_mubuf(union amdgcn_gfx10_insn *insn,
> +				       struct seq_file *m)
> +{
> +	seq_printf(m, "%s v%d, v%d, s[%d:%d], 0x%x offen offset:%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_MUBUF][insn->mubuf.op],
> +		 insn->mubuf.vdata,
> +		 insn->mubuf.vaddr,
> +		 insn->mubuf.srsrc,
> +		 insn->mubuf.srsrc + 3,
> +		 insn->mubuf.soffset,
> +		 insn->mubuf.offset);
> +}
> +
> +static inline void gfx10_debugfs_global(union amdgcn_gfx10_insn *insn,
> +					struct seq_file *m)
> +{
> +	if (insn->flat.op == GFX9_GLOBAL_STORE_BYTE) {
> +		seq_printf(m, "%s v[%d:%d], v%d, off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_SHORT) {
> +		seq_printf(m, "%s v[%d:%d], v%d, off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORD) {
> +		seq_printf(m, "%s v[%d:%d], v%d, off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORDX2) {
> +		seq_printf(m, "%s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.data,
> +			 insn->flat.data + 1,
> +			 insn->flat.offset);
> +	} else {
> +		seq_printf(m, "%s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			 opnames_gfx10[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			 insn->flat.vdst,
> +			 insn->flat.vdst + 1,
> +			 insn->flat.addr,
> +			 insn->flat.addr + 1,
> +			 insn->flat.offset);
> +	}
> +}
> +
> +static inline void gfx10_debugfs_sop2(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sop2.ssrc0, insn->sop2.literal, ssrc0);
> +	decode_ssrc8(insn->sop2.ssrc1, insn->sop2.literal, ssrc1);
> +	seq_printf(m, "%s s%d, %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOP2][insn->sop2.op],
> +		 insn->sop2.sdst, ssrc0, ssrc1);
> +}
> +
> +static inline void gfx10_debugfs_sopk(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "%s s%d, 0x%x\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOPK][insn->sopk.op],
> +		 insn->sopk.sdst, insn->sopk.simm16);
> +}
> +
> +static inline void gfx10_debugfs_sopc(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sopc.ssrc0, insn->sopc.literal, ssrc0);
> +	decode_ssrc8(insn->sopc.ssrc1, insn->sopc.literal, ssrc1);
> +	seq_printf(m, "%s %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_SOPC][insn->sopc.op],
> +		 ssrc0, ssrc1);
> +}
> +
> +static inline void gfx10_debugfs_vop3p(union amdgcn_gfx10_insn *insn,
> +					struct seq_file *m)
> +{
> +	char src0[20], src1[20], src2[20];
> +
> +	decode_vsrc9(insn->vop3p.src0, insn->vop3p.literal, src0);
> +	decode_vsrc9(insn->vop3p.src1, insn->vop3p.literal, src1);
> +	decode_vsrc9(insn->vop3p.src2, insn->vop3p.literal, src2);
> +	seq_printf(m, "%s v%d, %s, %s, %s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_VOP3P][insn->vop3p.op],
> +		 (int)insn->vop3p.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx10_debugfs_sdwa(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "sdwa src0:%d dst_sel:%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwa.src0, insn->sdwa.dst_sel,
> +		 insn->sdwa.src0_sel, insn->sdwa.src1_sel);
> +}
> +
> +static inline void gfx10_debugfs_sdwab(union amdgcn_gfx10_insn *insn,
> +					struct seq_file *m)
> +{
> +	seq_printf(m, "sdwab src0:%d sdst:s%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwab.src0, insn->sdwab.sdst,
> +		 insn->sdwab.src0_sel, insn->sdwab.src1_sel);
> +}
> +
> +static inline void gfx10_debugfs_dpp16(union amdgcn_gfx10_insn *insn,
> +					struct seq_file *m)
> +{
> +	seq_puts(m, "dpp16 (not decoded)\n");
> +}
> +
> +static inline void gfx10_debugfs_dpp8(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_puts(m, "dpp8 (not decoded)\n");
> +}
> +
> +static inline void gfx10_debugfs_vintrp(union amdgcn_gfx10_insn *insn,
> +					 struct seq_file *m)
> +{
> +	seq_puts(m, "vintrp (not decoded)\n");
> +}
> +
> +static inline void gfx10_debugfs_ds(union amdgcn_gfx10_insn *insn,
> +				    struct seq_file *m)
> +{
> +	seq_printf(m, "%s v%d, v%d, v%d, v%d offset0:%d offset1:%d%s\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_DS][insn->ds.op],
> +		 (int)insn->ds.vdst, (int)insn->ds.addr,
> +		 (int)insn->ds.data0, (int)insn->ds.data1,
> +		 (int)insn->ds.offset0, (int)insn->ds.offset1,
> +		 insn->ds.gds ? " gds" : "");
> +}
> +
> +static inline void gfx10_debugfs_mtbuf(union amdgcn_gfx10_insn *insn,
> +					struct seq_file *m)
> +{
> +	seq_printf(m, "%s v%d, v%d, s[%d:%d], s%d format:%d offset:%d\n",
> +		 opnames_gfx10[AMDGCN_INSN_TYPE_MTBUF][insn->mtbuf.op],
> +		 (int)insn->mtbuf.vdata, (int)insn->mtbuf.vaddr,
> +		 (int)insn->mtbuf.srsrc * 4, (int)insn->mtbuf.srsrc * 4 + 3,
> +		 (int)insn->mtbuf.soffset, (int)insn->mtbuf.foamat,
> +		 (int)insn->mtbuf.offset);
> +}
> +
> +static inline void gfx10_debugfs_mimg(union amdgcn_gfx10_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_puts(m, "mimg (not decoded)\n");
> +}
> +
> +static inline void gfx10_debugfs_exp(union amdgcn_gfx10_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_puts(m, "exp (not decoded)\n");
> +}
> +
> +static inline void gfx10_debugfs_insn(struct amdgcn_insn *insn,
> +				      struct seq_file *m)
> +{
> +	u32 *ptr = (u32 *)&insn->gfx10;
> +
> +	if (insn->size == 4)
> +		seq_printf(m, "%.8X\t\t\t", ptr[0]);
> +	else if (insn->size == 8)
> +		seq_printf(m, "%.8X %.8X\t\t", ptr[0], ptr[1]);
> +	else if (insn->size == 12)
> +		seq_printf(m, "%.8X %.8X %.8X\t\t\t", ptr[0], ptr[1], ptr[2]);
> +	else
> +		WARN_ON_ONCE(1);
> +
> +	switch (insn->type) {
> +	case AMDGCN_INSN_TYPE_SOP2:
> +		gfx10_debugfs_sop2(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPK:
> +		gfx10_debugfs_sopk(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOP1:
> +		gfx10_debugfs_sop1(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPC:
> +		gfx10_debugfs_sopc(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPP:
> +		gfx10_debugfs_sopp(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SMEM:
> +		gfx10_debugfs_smem(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP2:
> +		gfx10_debugfs_vop2(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP1:
> +		gfx10_debugfs_vop1(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOPC:
> +		gfx10_debugfs_vopc(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3A:
> +		gfx10_debugfs_vop3a(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3B:
> +		gfx10_debugfs_vop3b(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3P:
> +		gfx10_debugfs_vop3p(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWA:
> +		gfx10_debugfs_sdwa(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWAB:
> +		gfx10_debugfs_sdwab(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP16:
> +		gfx10_debugfs_dpp16(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP8:
> +		gfx10_debugfs_dpp8(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VINTRP:
> +		gfx10_debugfs_vintrp(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_DS:
> +		gfx10_debugfs_ds(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_MTBUF:
> +		gfx10_debugfs_mtbuf(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_MUBUF:
> +		gfx10_debugfs_mubuf(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_MIMG:
> +		gfx10_debugfs_mimg(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_FLAT:
> +		gfx10_debugfs_global(&insn->gfx10, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_EXP:
> +		gfx10_debugfs_exp(&insn->gfx10, m);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +}
> +
> +static inline void gfx9_debugfs_vop3a(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +
> +	if (insn->vop3a.src0 < GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3a.src0);
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3a.src0 < GFX9_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3a.src0 - GFX9_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src0 < GFX9_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3a.src0 - GFX9_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3a.src0 == GFX9_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src0 >= GFX9_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3a.src0 - GFX9_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src1 < GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3a.src1);
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3a.src1 < GFX9_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3a.src1 - GFX9_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src1 < GFX9_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3a.src1 - GFX9_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3a.src1 == GFX9_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src1 >= GFX9_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3a.src1 - GFX9_VOP3A_SRC_VGPR_BASE);
> +
> +	if (insn->vop3a.src2 < GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3a.src2);
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3a.src2 < GFX9_VOP3A_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3a.src2 - GFX9_VOP3A_SRC_INTEGER_0);
> +	else if (insn->vop3a.src2 < GFX9_VOP3A_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3a.src2 - GFX9_VOP3A_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3a.src2 == GFX9_VOP3A_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3a.literal);
> +	else if (insn->vop3a.src2 >= GFX9_VOP3A_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3a.src2 - GFX9_VOP3A_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP3A][insn->vop3a.op],
> +		 insn->vop3a.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx9_debugfs_vop3b(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char src0[20];
> +	char src1[20];
> +	char src2[20];
> +	char sdst[20];
> +
> +	if (insn->vop3b.sdst < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(sdst, "s%d", insn->vop3b.sdst);
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(sdst, "%s", "vcc_lo");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(sdst, "%s", "vcc_hi");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_NULL)
> +		sprintf(sdst, "%s", "null");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(sdst, "%s", "exec_lo");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(sdst, "%s", "exec_hi");
> +	else if (insn->vop3b.sdst < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(sdst, "0x%x",
> +			insn->vop3b.sdst - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.sdst < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(sdst, "-0x%x",
> +			insn->vop3b.sdst - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(sdst, "%s", "vcc");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(sdst, "%s", "exec");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_SCC)
> +		sprintf(sdst, "%s", "scc");
> +	else if (insn->vop3b.sdst == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(sdst, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.sdst >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(sdst, "v%d",
> +			insn->vop3b.sdst - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src0 < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop3b.src0);
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop3b.src0 < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop3b.src0 - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.src0 < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop3b.src0 - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop3b.src0 == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src0 >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d",
> +			insn->vop3b.src0 - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src1 < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src1, "s%d", insn->vop3b.src1);
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src1, "%s", "vcc_lo");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(src1, "%s", "vcc_hi");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_NULL)
> +		sprintf(src1, "%s", "null");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(src1, "%s", "exec_lo");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(src1, "%s", "exec_hi");
> +	else if (insn->vop3b.src1 < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(src1, "0x%x",
> +			insn->vop3b.src1 - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.src1 < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(src1, "-0x%x",
> +			insn->vop3b.src1 - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(src1, "%s", "vcc");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(src1, "%s", "exec");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_SCC)
> +		sprintf(src1, "%s", "scc");
> +	else if (insn->vop3b.src1 == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(src1, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src1 >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(src1, "v%d",
> +			insn->vop3b.src1 - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	if (insn->vop3b.src2 < GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src2, "s%d", insn->vop3b.src2);
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_VCC_LO)
> +		sprintf(src2, "%s", "vcc_lo");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_VCC_HI)
> +		sprintf(src2, "%s", "vcc_hi");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_NULL)
> +		sprintf(src2, "%s", "null");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_EXEC_LO)
> +		sprintf(src2, "%s", "exec_lo");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_EXEC_HI)
> +		sprintf(src2, "%s", "exec_hi");
> +	else if (insn->vop3b.src2 < GFX9_VOP3B_SRC_INTEGER_MINUS_1)
> +		sprintf(src2, "0x%x",
> +			insn->vop3b.src2 - GFX9_VOP3B_SRC_INTEGER_0);
> +	else if (insn->vop3b.src2 < GFX9_VOP3B_SRC_SHARED_BASE)
> +		sprintf(src2, "-0x%x",
> +			insn->vop3b.src2 - GFX9_VOP3B_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_VCCZ)
> +		sprintf(src2, "%s", "vcc");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_EXECZ)
> +		sprintf(src2, "%s", "exec");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_SCC)
> +		sprintf(src2, "%s", "scc");
> +	else if (insn->vop3b.src2 == GFX9_VOP3B_SRC_LITERAL_CONST)
> +		sprintf(src2, "0x%x", insn->vop3b.literal);
> +	else if (insn->vop3b.src2 >= GFX9_VOP3B_SRC_VGPR_BASE)
> +		sprintf(src2, "v%d",
> +			insn->vop3b.src2 - GFX9_VOP3B_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s, %s, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP3B][insn->vop3b.op],
> +		 insn->vop3b.vdst, sdst, src0, src1, src2);
> +}
> +
> +static inline void gfx9_debugfs_vop1(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	char src0[20];
> +
> +	if (insn->vop1.src0 < GFX9_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop1.src0);
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop1.src0 < GFX9_VOP1_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop1.src0 - GFX9_VOP1_SRC_INTEGER_0);
> +	else if (insn->vop1.src0 < GFX9_VOP1_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop1.src0 - GFX9_VOP1_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop1.src0 == GFX9_VOP1_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop1.literal);
> +	else if (insn->vop1.src0 >= GFX9_VOP1_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d", insn->vop1.src0 - GFX9_VOP1_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP1][insn->vop1.op],
> +		 insn->vop1.vdst, src0);
> +}
> +
> +static inline void gfx9_debugfs_vopc(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	char src0[20];
> +
> +	if (insn->vopc.src0 < GFX9_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vopc.src0);
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vopc.src0 < GFX9_VOPC_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vopc.src0 - GFX9_VOPC_SRC_INTEGER_0);
> +	else if (insn->vopc.src0 < GFX9_VOPC_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vopc.src0 - GFX9_VOPC_SRC_INTEGER_MINUS_1);
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vopc.src0 == GFX9_VOPC_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vopc.literal);
> +	else if (insn->vopc.src0 >= GFX9_VOPC_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d", insn->vopc.src0 - GFX9_VOPC_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s %s, v%d\n",
> +		opnames_gfx9[AMDGCN_INSN_TYPE_VOPC][insn->vopc.op],
> +		src0,
> +		insn->vopc.vsrc1);
> +}
> +
> +static inline void gfx9_debugfs_vop2(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	char src0[20];
> +
> +	if (insn->vop2.src0 < GFX9_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "s%d", insn->vop2.src0);
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_VCC_LO)
> +		sprintf(src0, "%s", "vcc_lo");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_VCC_HI)
> +		sprintf(src0, "%s", "vcc_hi");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_NULL)
> +		sprintf(src0, "%s", "null");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_EXEC_LO)
> +		sprintf(src0, "%s", "exec_lo");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_EXEC_HI)
> +		sprintf(src0, "%s", "exec_hi");
> +	else if (insn->vop2.src0 < GFX9_VOP2_SRC_INTEGER_MINUS_1)
> +		sprintf(src0, "0x%x",
> +			insn->vop2.src0 - GFX9_VOP2_SRC_INTEGER_0);
> +	else if (insn->vop2.src0 < GFX9_VOP2_SRC_SHARED_BASE)
> +		sprintf(src0, "-0x%x",
> +			insn->vop2.src0 - GFX9_VOP2_SRC_INTEGER_MINUS_1);
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_VCCZ)
> +		sprintf(src0, "%s", "vcc");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_EXECZ)
> +		sprintf(src0, "%s", "exec");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_SCC)
> +		sprintf(src0, "%s", "scc");
> +	else if (insn->vop2.src0 == GFX9_VOP2_SRC_LITERAL_CONST)
> +		sprintf(src0, "0x%x", insn->vop2.literal);
> +	else if (insn->vop2.src0 >= GFX9_VOP2_SRC_VGPR_BASE)
> +		sprintf(src0, "v%d", insn->vop2.src0 - GFX9_VOP2_SRC_VGPR_BASE);
> +
> +	seq_printf(m, "%s v%d, %s v%d\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP2][insn->vop2.op],
> +		 insn->vop2.vdst,
> +		 src0,
> +		 insn->vop2.vsrc1);
> +}
> +
> +static inline void gfx9_debugfs_sop1(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	char ssrc0[20];
> +
> +	if (insn->sop1.ssrc0 < GFX9_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "s%d", insn->sop1.ssrc0);
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_VCC_LO)
> +		sprintf(ssrc0, "%s", "vcc_lo");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_VCC_HI)
> +		sprintf(ssrc0, "%s", "vcc_hi");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_NULL)
> +		sprintf(ssrc0, "%s", "null");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_EXEC_LO)
> +		sprintf(ssrc0, "%s", "exec_lo");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_EXEC_HI)
> +		sprintf(ssrc0, "%s", "exec_hi");
> +	else if (insn->sop1.ssrc0 < GFX9_SOP1_SSRC_INTEGER_MINUS_1)
> +		sprintf(ssrc0, "0x%x",
> +			insn->sop1.ssrc0 - GFX9_SOP1_SSRC_INTEGER_0);
> +	else if (insn->sop1.ssrc0 < GFX9_SOP1_SSRC_SHARED_BASE)
> +		sprintf(ssrc0, "-0x%x",
> +			insn->sop1.ssrc0 - GFX9_SOP1_SSRC_INTEGER_MINUS_1);
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_VCCZ)
> +		sprintf(ssrc0, "%s", "vcc");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_EXECZ)
> +		sprintf(ssrc0, "%s", "exec");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_SCC)
> +		sprintf(ssrc0, "%s", "scc");
> +	else if (insn->sop1.ssrc0 == GFX9_SOP1_SSRC_LITERAL_CONST)
> +		sprintf(ssrc0, "0x%x", insn->sop1.literal);
> +
> +	seq_printf(m, "%s s%d, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOP1][insn->sop1.op],
> +		 insn->sop1.sdst,
> +		 ssrc0);
> +}
> +
> +static inline void gfx9_debugfs_sopp(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_printf(m, "%s 0x%x\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOPP][insn->sopp.op],
> +		 insn->sopp.simm16);
> +}
> +
> +static inline void gfx9_debugfs_smem(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_printf(m, "%s s[%d:%d], s[%d:%d], 0x%x\n",
> +		   opnames_gfx9[AMDGCN_INSN_TYPE_SMEM][insn->smem.op],
> +		   insn->smem.sdata,
> +		   insn->smem.sdata + 1,
> +		   (insn->smem.sbase * 2),
> +		   (insn->smem.sbase * 2) + 1,
> +		   insn->smem.offset);
> +}
> +
> +static inline void gfx9_debugfs_mubuf(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "%s v%d, v%d, s[%d:%d], 0x%x offen offset:%d\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_MUBUF][insn->mubuf.op],
> +		 insn->mubuf.vdata,
> +		 insn->mubuf.vaddr,
> +		 insn->mubuf.srsrc,
> +		 insn->mubuf.srsrc + 3,
> +		 insn->mubuf.soffset,
> +		 insn->mubuf.offset);
> +}
> +
> +static inline void gfx9_debugfs_global(union amdgcn_gfx9_insn *insn,
> +				       struct seq_file *m)
> +{
> +	if (insn->flat.op == GFX9_GLOBAL_STORE_BYTE) {
> +		seq_printf(m, "%s v[%d:%d], v%d, off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_SHORT) {
> +		seq_printf(m, "%s v[%d:%d], v%d, off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORD) {
> +		seq_printf(m, "%s v[%d:%d], v%d, off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.offset);
> +	} else if (insn->flat.op == GFX9_GLOBAL_STORE_DWORDX2) {
> +		seq_printf(m, "%s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.data,
> +			insn->flat.data + 1,
> +			insn->flat.offset);
> +	} else {
> +		seq_printf(m, "%s v[%d:%d], v[%d:%d], off offset:%d\n",
> +			opnames_gfx9[AMDGCN_INSN_TYPE_FLAT][insn->flat.op],
> +			insn->flat.vdst,
> +			insn->flat.vdst + 1,
> +			insn->flat.addr,
> +			insn->flat.addr + 1,
> +			insn->flat.offset);
> +	}
> +}
> +
> +static inline void gfx9_debugfs_sop2(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sop2.ssrc0, insn->sop2.literal, ssrc0);
> +	decode_ssrc8(insn->sop2.ssrc1, insn->sop2.literal, ssrc1);
> +	seq_printf(m, "%s s%d, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOP2][insn->sop2.op],
> +		 insn->sop2.sdst, ssrc0, ssrc1);
> +}
> +
> +static inline void gfx9_debugfs_sopk(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_printf(m, "%s s%d, 0x%x\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOPK][insn->sopk.op],
> +		 insn->sopk.sdst, insn->sopk.simm16);
> +}
> +
> +static inline void gfx9_debugfs_sopc(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	char ssrc0[20], ssrc1[20];
> +
> +	decode_ssrc8(insn->sopc.ssrc0, insn->sopc.literal, ssrc0);
> +	decode_ssrc8(insn->sopc.ssrc1, insn->sopc.literal, ssrc1);
> +	seq_printf(m, "%s %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_SOPC][insn->sopc.op],
> +		 ssrc0, ssrc1);
> +}
> +
> +static inline void gfx9_debugfs_vop3p(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	char src0[20], src1[20], src2[20];
> +
> +	decode_vsrc9(insn->vop3p.src0, insn->vop3p.literal, src0);
> +	decode_vsrc9(insn->vop3p.src1, insn->vop3p.literal, src1);
> +	decode_vsrc9(insn->vop3p.src2, insn->vop3p.literal, src2);
> +	seq_printf(m, "%s v%d, %s, %s, %s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_VOP3P][insn->vop3p.op],
> +		 (int)insn->vop3p.vdst, src0, src1, src2);
> +}
> +
> +static inline void gfx9_debugfs_sdwa(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_printf(m, "sdwa src0:%d dst_sel:%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwa.src0, insn->sdwa.dst_sel,
> +		 insn->sdwa.src0_sel, insn->sdwa.src1_sel);
> +}
> +
> +static inline void gfx9_debugfs_sdwab(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "sdwab src0:%d sdst:s%d src0_sel:%d src1_sel:%d\n",
> +		 insn->sdwab.src0, insn->sdwab.sdst,
> +		 insn->sdwab.src0_sel, insn->sdwab.src1_sel);
> +}
> +
> +static inline void gfx9_debugfs_dpp16(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_puts(m, "dpp16 (not decoded)\n");
> +}
> +
> +static inline void gfx9_debugfs_dpp8(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_puts(m, "dpp8 (not decoded)\n");
> +}
> +
> +static inline void gfx9_debugfs_vintrp(union amdgcn_gfx9_insn *insn,
> +					struct seq_file *m)
> +{
> +	seq_puts(m, "vintrp (not decoded)\n");
> +}
> +
> +static inline void gfx9_debugfs_ds(union amdgcn_gfx9_insn *insn,
> +				   struct seq_file *m)
> +{
> +	seq_printf(m, "%s v%d, v%d, v%d, v%d offset0:%d offset1:%d%s\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_DS][insn->ds.op],
> +		 (int)insn->ds.vdst, (int)insn->ds.addr,
> +		 (int)insn->ds.data0, (int)insn->ds.data1,
> +		 (int)insn->ds.offset0, (int)insn->ds.offset1,
> +		 insn->ds.gds ? " gds" : "");
> +}
> +
> +static inline void gfx9_debugfs_mtbuf(union amdgcn_gfx9_insn *insn,
> +				      struct seq_file *m)
> +{
> +	seq_printf(m, "%s v%d, v%d, s[%d:%d], s%d dfmt:%d nfmt:%d offset:%d\n",
> +		 opnames_gfx9[AMDGCN_INSN_TYPE_MTBUF][insn->mtbuf.op],
> +		 (int)insn->mtbuf.vdata, (int)insn->mtbuf.vaddr,
> +		 (int)insn->mtbuf.srsrc * 4, (int)insn->mtbuf.srsrc * 4 + 3,
> +		 (int)insn->mtbuf.soffset, (int)insn->mtbuf.dfmt,
> +		 (int)insn->mtbuf.nfmt, (int)insn->mtbuf.offset);
> +}
> +
> +static inline void gfx9_debugfs_mimg(union amdgcn_gfx9_insn *insn,
> +				     struct seq_file *m)
> +{
> +	seq_puts(m, "mimg (not decoded)\n");
> +}
> +
> +static inline void gfx9_debugfs_exp(union amdgcn_gfx9_insn *insn,
> +				    struct seq_file *m)
> +{
> +	seq_puts(m, "exp (not decoded)\n");
> +}
> +
> +static inline void gfx9_debugfs_insn(struct amdgcn_insn *insn,
> +				     struct seq_file *m)
> +{
> +	u32 *ptr = (u32 *)&insn->gfx9;
> +
> +	if (insn->size == 4)
> +		seq_printf(m, "%.8X\t\t\t", ptr[0]);
> +	else if (insn->size == 8)
> +		seq_printf(m, "%.8X %.8X\t\t", ptr[0], ptr[1]);
> +	else if (insn->size == 12)
> +		seq_printf(m, "%.8X %.8X %.8X\t", ptr[0], ptr[1], ptr[2]);
> +	else
> +		WARN_ON_ONCE(1);
> +
> +	switch (insn->type) {
> +	case AMDGCN_INSN_TYPE_SOP2:
> +		gfx9_debugfs_sop2(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPK:
> +		gfx9_debugfs_sopk(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOP1:
> +		gfx9_debugfs_sop1(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPC:
> +		gfx9_debugfs_sopc(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SOPP:
> +		gfx9_debugfs_sopp(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SMEM:
> +		gfx9_debugfs_smem(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP2:
> +		gfx9_debugfs_vop2(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP1:
> +		gfx9_debugfs_vop1(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOPC:
> +		gfx9_debugfs_vopc(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3A:
> +		gfx9_debugfs_vop3a(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3B:
> +		gfx9_debugfs_vop3b(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VOP3P:
> +		gfx9_debugfs_vop3p(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWA:
> +		gfx9_debugfs_sdwa(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_SDWAB:
> +		gfx9_debugfs_sdwab(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP16:
> +		gfx9_debugfs_dpp16(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_DPP8:
> +		gfx9_debugfs_dpp8(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_VINTRP:
> +		gfx9_debugfs_vintrp(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_DS:
> +		gfx9_debugfs_ds(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_MTBUF:
> +		gfx9_debugfs_mtbuf(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_MUBUF:
> +		gfx9_debugfs_mubuf(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_MIMG:
> +		gfx9_debugfs_mimg(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_FLAT:
> +		gfx9_debugfs_global(&insn->gfx9, m);
> +		break;
> +	case AMDGCN_INSN_TYPE_EXP:
> +		gfx9_debugfs_exp(&insn->gfx9, m);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +}
> +
> +static inline void debugfs_insn(int version, struct amdgcn_insn *insn,
> +				struct seq_file *m)
> +{
> +	if (version == 10)
> +		gfx10_debugfs_insn(insn, m);
> +	else if (version == 9)
> +		gfx9_debugfs_insn(insn, m);
> +	else
> +		WARN_ON_ONCE(1);
> +}
> +
> +/*
> + * Recover instruction type + size from a raw machine-code word stream into a
> + * struct amdgcn_insn, so code holding only the emitted u32 blob (the feature
> + * shaders emit via the low-level emit_gfxN_* helpers straight into the GPU
> + * code buffer, discarding type/size) can be fed to the shared disassembler
> + * debugfs_insn() instead of a per-feature hand-rolled hex re-parser.
> + *
> + * This mirrors the proven encoding-detection that used to live in the
> + * per-feature disassemblers. The checks are ordered widest
> + * fixed-prefix first: SOPP/SOP1/SOPC (9-bit enc) before SOPK (4-bit) before
> + * SOP2 (2-bit), and every bit31==1 class (VOP1/VOPC/SMEM/DS/FLAT/MUBUF/VOP3)
> + * before the VOP2 (bit31==0) catch-all. Version-specific encodings: SMEM
> + * (gfx9 0x30 / gfx10 0x3d), SOPC literal (gfx10 only) and VOP3 (gfx9 0x34 /
> + * gfx10 0x35). size is in bytes (4/8/12) to match what emit_* stamps in.
> + */
> +static inline void amdgcn_classify(int version, const u32 *code,
> +				   struct amdgcn_insn *out)
> +{
> +	enum amdgcn_insn_type type;
> +	u32 w0 = code[0];
> +	bool is_b;
> +	u32 dwords;
> +	u32 enc;
> +	u32 op;
> +
> +	enc = (w0 >> 23) & 0x1ff;
> +
> +	if (enc == 0x17f) {				/* SOPP */
> +		type = AMDGCN_INSN_TYPE_SOPP;
> +		dwords = 1;
> +	} else if (enc == 0x17d) {			/* SOP1 */
> +		type = AMDGCN_INSN_TYPE_SOP1;
> +		dwords = ((w0 & 0xff) == 0xff) ? 2 : 1;
> +	} else if (enc == 0x17e) {			/* SOPC */
> +		type = AMDGCN_INSN_TYPE_SOPC;
> +		dwords = (version == 10 &&
> +			  ((w0 & 0xff) == 0xff || ((w0 >> 8) & 0xff) == 0xff))
> +			 ? 2 : 1;
> +	} else if (((w0 >> 28) & 0xf) == 0xb) {		/* SOPK */
> +		type = AMDGCN_INSN_TYPE_SOPK;
> +		dwords = 1;
> +	} else if (((w0 >> 30) & 0x3) == 0x2) {		/* SOP2 */
> +		type = AMDGCN_INSN_TYPE_SOP2;
> +		dwords = ((w0 & 0xff) == 0xff ||
> +			  ((w0 >> 8) & 0xff) == 0xff) ? 2 : 1;
> +	} else if (((w0 >> 26) & 0x3f) ==
> +		   (version == 10 ? 0x3d : 0x30)) {	/* SMEM */
> +		type = AMDGCN_INSN_TYPE_SMEM;
> +		dwords = 2;
> +	} else if (((w0 >> 25) & 0x7f) == 0x3f) {	/* VOP1 */
> +		type = AMDGCN_INSN_TYPE_VOP1;
> +		dwords = ((w0 & 0xff) == 0xff) ? 2 : 1;
> +	} else if (((w0 >> 25) & 0x7f) == 0x3e) {	/* VOPC */
> +		type = AMDGCN_INSN_TYPE_VOPC;
> +		dwords = 1;
> +	} else if (((w0 >> 26) & 0x3f) == 0x36) {	/* DS */
> +		type = AMDGCN_INSN_TYPE_DS;
> +		dwords = 2;
> +	/* FLAT/GLOBAL/SCRATCH */
> +	} else if (((w0 >> 26) & 0x3f) == 0x37) {
> +		type = AMDGCN_INSN_TYPE_FLAT;
> +		dwords = 2;
> +	} else if (((w0 >> 26) & 0x3f) == 0x38) {	/* MUBUF */
> +		type = AMDGCN_INSN_TYPE_MUBUF;
> +		dwords = 2;
> +	} else if (((w0 >> 26) & 0x3f) ==
> +		   (version == 10 ? 0x35 : 0x34)) {	/* VOP3A / VOP3B */
> +		op = (w0 >> 16) & 0x3ff;
> +		if (version == 10)
> +			is_b = (op == GFX10_V_ADD_CO_U32 ||
> +				op == GFX10_V_SUB_CO_U32 ||
> +				op == GFX10_V_SUBREV_CO_U32 ||
> +				op == GFX10_V_MAD_U64_U32 ||
> +				op == GFX10_V_MAD_I64_I32 ||
> +				op == GFX10_V_DIV_SCALE_F32 ||
> +				op == GFX10_V_DIV_SCALE_F64);
> +		else
> +			is_b = (op == GFX9_V_MAD_U64_U32 ||
> +				op == GFX9_V_MAD_I64_I32 ||
> +				op == GFX9_V_DIV_SCALE_F64);
> +		type = is_b ? AMDGCN_INSN_TYPE_VOP3B : AMDGCN_INSN_TYPE_VOP3A;
> +		dwords = 2;
> +	} else if (((w0 >> 31) & 0x1) == 0) {		/* VOP2 */
> +		type = AMDGCN_INSN_TYPE_VOP2;
> +		dwords = ((w0 & 0xff) == 0xff) ? 2 : 1;
> +	} else {					/* unknown: 1 dword */
> +		type = AMDGCN_INSN_TYPE_SOPP;
> +		dwords = 1;
> +	}
> +
> +	memset(out, 0, sizeof(*out));
> +	out->type = type;
> +	out->size = dwords * 4;
> +	memcpy(&out->gfx10, code, dwords * 4);
> +}
> +
> +/*
> + * Drop-in replacement for the old per-feature hex re-parsers: classify
> + * one raw instruction at @code, print it through the
> + * shared (complete-opnames) disassembler, and return the number of dwords
> + * consumed so the caller can advance. @max_dwords guards against reading a
> + * second dword past the end of the buffer.
> + */
> +static inline int amdgcn_disasm_raw(int version, const u32 *code,
> +				    int max_dwords, struct seq_file *m)
> +{
> +	struct amdgcn_insn insn;
> +
> +	if (max_dwords <= 0)
> +		return 1;
> +	amdgcn_classify(version, code, &insn);
> +	if ((int)(insn.size / 4) > max_dwords) {
> +		seq_printf(m, "%.8X\t\t\t(truncated)\n", code[0]);
> +		return 1;
> +	}
> +	debugfs_insn(version, &insn, m);
> +	return insn.size / 4;
> +}
> +
> +
> +#endif
> diff --git a/drivers/gpu/drm/amd/amdkfd/knod/knod_gfx10_insn.h b/drivers/gpu/drm/amd/amdkfd/knod/knod_gfx10_insn.h
> new file mode 100644
> index 000000000000..f2699adb6c7d
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/amdkfd/knod/knod_gfx10_insn.h
> @@ -0,0 +1,3978 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
> + * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
> + */
> +
> +#ifndef KFD_AMDGPU_GFX10_INSN_H_INCLUDED
> +#define KFD_AMDGPU_GFX10_INSN_H_INCLUDED
> +
> +#include "knod_amdgpu.h"
> +
> +/* See knod_gfx9_insn.h for rationale on not including knod_amdgpu_insn.h */
> +
> +#define GFX10_SRC_SGPR_BASE		0
> +#define GFX10_SRC_VCC_LO		106
> +#define GFX10_SRC_VCC_HI		107
> +#define GFX10_SRC_TTPM_BASE		108
> +#define GFX10_SRC_M0			124
> +#define GFX10_SRC_NULL			125
> +#define GFX10_SRC_EXEC_LO		126
> +#define GFX10_SRC_EXEC_HI		127
> +#define GFX10_SRC_INTEGER_0		128
> +#define GFX10_SRC_INTEGER_MINUS_1	193
> +#define GFX10_SRC_SHARED_BASE		235
> +#define GFX10_SRC_SHARED_LIMIT		236
> +#define GFX10_SRC_PRIVATE_BASE		237
> +#define GFX10_SRC_PRIVATE_LIMIT		238
> +#define GFX10_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_SRC_SDWA			249
> +#define GFX10_SRC_DDP16			250
> +#define GFX10_SRC_VCCZ			251
> +#define GFX10_SRC_EXECZ			252
> +#define GFX10_SRC_SCC			253
> +#define GFX10_SRC_LITERAL_CONST		255
> +#define GFX10_SRC_VGPR_BASE		256
> +
> +static int gfx10_param_base[__AMDGCN_PARAM_TYPE_MAX] = {
> +	GFX10_SRC_SGPR_BASE,
> +	GFX10_SRC_VCC_LO,
> +	GFX10_SRC_VCC_HI,
> +	GFX10_SRC_TTPM_BASE,
> +	GFX10_SRC_M0,
> +	GFX10_SRC_NULL,
> +	GFX10_SRC_EXEC_LO,
> +	GFX10_SRC_EXEC_HI,
> +	GFX10_SRC_INTEGER_0,
> +	GFX10_SRC_INTEGER_MINUS_1,
> +	GFX10_SRC_SHARED_BASE,
> +	GFX10_SRC_SHARED_LIMIT,
> +	GFX10_SRC_PRIVATE_BASE,
> +	GFX10_SRC_PRIVATE_LIMIT,
> +	GFX10_SRC_POPS_EXITING_WAVE_ID,
> +	GFX10_SRC_SDWA,
> +	GFX10_SRC_DDP16,
> +	GFX10_SRC_VCCZ,
> +	GFX10_SRC_EXECZ,
> +	GFX10_SRC_SCC,
> +	GFX10_SRC_LITERAL_CONST,
> +	GFX10_SRC_VGPR_BASE,
> +};
> +
> +/* Scalar ALU and Control Format */
> +struct amdgcn_gfx10_sop2 {
> +	u32 ssrc0:8;
> +	u32 ssrc1:8;
> +	u32 sdst:7;
> +	u32 op:7;
> +	u32 encoding:2;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_sop2_opcode {
> +	GFX10_S_ADD_U32 = 0,
> +	GFX10_S_SUB_U32 = 1,
> +	GFX10_S_ADD_I32 = 2,
> +	GFX10_S_SUB_I32 = 3,
> +	GFX10_S_ADDC_U32 = 4,
> +	GFX10_S_SUBB_U32 = 5,
> +	GFX10_S_MIN_I32 = 6,
> +	GFX10_S_MIN_U32 = 7,
> +	GFX10_S_MAX_I32 = 8,
> +	GFX10_S_MAX_U32 = 9,
> +	GFX10_S_CSELECT_B32 = 10,
> +	GFX10_S_CELECT_B64 = 11,
> +	/* 12-13: reserved */
> +	GFX10_S_AND_B32 = 14,
> +	GFX10_S_AND_B64 = 15,
> +	GFX10_S_OR_B32 = 16,
> +	GFX10_S_OR_B64 = 17,
> +	GFX10_S_XOR_B32 = 18,
> +	GFX10_S_XOR_B64 = 19,
> +	GFX10_S_ANDN2_B32 = 20,
> +	GFX10_S_ANDN2_B64 = 21,
> +	GFX10_S_ORN2_B32 = 22,
> +	GFX10_S_ORN2_B64 = 23,
> +	GFX10_S_NAND_B32 = 24,
> +	GFX10_S_NAND_B64 = 25,
> +	GFX10_S_NOR_B32 = 26,
> +	GFX10_S_NOR_B64 = 27,
> +	GFX10_S_XNOR_B32 = 28,
> +	GFX10_S_XNOR_B64 = 29,
> +	GFX10_S_LSHL_B32 = 30,
> +	GFX10_S_LSHL_B64 = 31,
> +	GFX10_S_LSHR_B32 = 32,
> +	GFX10_S_LSHR_B64 = 33,
> +	GFX10_S_ASHR_I32 = 34,
> +	GFX10_S_ASHR_I64 = 35,
> +	GFX10_S_BFM_B32 = 36,
> +	GFX10_S_BFM_B64 = 37,
> +	GFX10_S_MUL_I32 = 38,
> +	GFX10_S_MUL_I64 = 39,
> +	GFX10_S_BFE_U32 = 40,
> +	GFX10_S_BFE_I32 = 41,
> +	GFX10_S_BFE_U64 = 42,
> +	GFX10_S_ABSDIFF_I32 = 44,
> +	GFX10_S_LSHL1_ADD_U32 = 46,
> +	GFX10_S_LSHL2_ADD_U32 = 47,
> +	GFX10_S_LSHL3_ADD_U32 = 48,
> +	GFX10_S_LSHL4_ADD_U32 = 49,
> +	GFX10_S_PACK_LL_B32_B16 = 50,
> +	GFX10_S_PACK_LH_B32_B16 = 51,
> +	GFX10_S_PACK_HH_B32_B16 = 52,
> +	GFX10_S_MUL_HI_U32 = 53,
> +	GFX10_S_MUL_HI_I32 = 54,
> +};
> +
> +#define GFX10_SOP2_ENCODING			0x2
> +#define GFX10_SOP2_SSRC_SGPR_BASE		0
> +#define GFX10_SOP2_SSRC_VCC_LO			106
> +#define GFX10_SOP2_SSRC_VCC_HI			107
> +#define GFX10_SOP2_SSRC_TTPM_BASE		108
> +#define GFX10_SOP2_SSRC_M0			124
> +#define GFX10_SOP2_SSRC_NULL			125
> +#define GFX10_SOP2_SSRC_EXEC_LO			126
> +#define GFX10_SOP2_SSRC_EXEC_HI			127
> +#define GFX10_SOP2_SSRC_INTEGER_0		128
> +#define GFX10_SOP2_SSRC_INTEGER_MINUS_1		193
> +#define GFX10_SOP2_SSRC_SHARED_BASE		235
> +#define GFX10_SOP2_SSRC_SHARED_LIMIT		236
> +#define GFX10_SOP2_SSRC_PRIVATE_BASE		237
> +#define GFX10_SOP2_SSRC_PRIVATE_LIMIT		238
> +#define GFX10_SOP2_SSRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_SOP2_SSRC_VCCZ			251
> +#define GFX10_SOP2_SSRC_EXECZ			252
> +#define GFX10_SOP2_SSRC_SCC			253
> +/* SDST
> + * Same codes as SSRC0, above except only codes 0-127 are valid.
> + */
> +
> +struct amdgcn_gfx10_sopk {
> +	u32 simm16:16;
> +	u32 sdst:7;
> +	u32 op:5;
> +	u32 encoding:4;
> +};
> +
> +enum amdgcn_gfx10_sopk_opcode {
> +	GFX10_S_MOVK_I32 = 0,
> +	GFX10_S_VERSION = 1,
> +	GFX10_S_CMOVK_I32 = 2,
> +	GFX10_S_CMPK_EQ_I32 = 3,
> +	GFX10_S_CMPK_LG_I32 = 4,
> +	GFX10_S_CMPK_GT_I32 = 5,
> +	GFX10_S_CMPK_GE_I32 = 6,
> +	GFX10_S_CMPK_LT_I32 = 7,
> +	GFX10_S_CMPK_LE_I32 = 8,
> +	GFX10_S_CMPK_EQ_U32 = 9,
> +	GFX10_S_CMPK_LG_U32 = 10,
> +	GFX10_S_CMPK_GT_U32 = 11,
> +	GFX10_S_CMPK_GE_U32 = 12,
> +	GFX10_S_CMPK_LT_U32 = 13,
> +	GFX10_S_CMPK_LE_U32 = 14,
> +	GFX10_S_ADDK_I32 = 15,
> +	GFX10_S_MULK_I32 = 16,
> +	/* 17: reserved */
> +	GFX10_S_GETREG_B32 = 18,
> +	GFX10_S_SETREG_B32 = 19,
> +	/* 20: reserved */
> +	GFX10_S_SETREG_IMM32_B32 = 21,
> +	GFX10_S_CALL_B64 = 22,
> +	GFX10_S_WAITCNT_VSCNT = 23,
> +	GFX10_S_WAITCNT_VMCNT = 24,
> +	GFX10_S_WAITCNT_EXPCNT = 25,
> +	GFX10_S_WAITCNT_LGKMCNT = 26,
> +	GFX10_S_SUBVECTOR_LOOP_BEGIN = 27,
> +	GFX10_S_SUBVECTOR_LOOP_END = 28,
> +};
> +
> +#define GFX10_SOPK_ENCODING			0xb
> +#define GFX10_SOPK_SDST_SGPR0_BASE		0
> +#define GFX10_SOPK_SDST_VCC_LO			106
> +#define GFX10_SOPK_SDST_VCC_HI			107
> +#define GFX10_SOPK_SDST_TTPM_BASE		108
> +#define GFX10_SOPK_SDST_M0			124
> +#define GFX10_SOPK_SDST_NULL			125
> +#define GFX10_SOPK_SDST_EXEC_LO			126
> +#define GFX10_SOPK_SDST_EXEC_HI			127
> +
> +struct amdgcn_gfx10_sop1 {
> +	u32 ssrc0:8;
> +	u32 op:8;
> +	u32 sdst:7;
> +	u32 encoding:9;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_sop1_opcode {
> +	GFX10_S_MOV_B32 = 3,
> +	GFX10_S_MOV_B64 = 4,
> +	GFX10_S_CMOV_B32 = 5,
> +	GFX10_S_CMOV_B64 = 6,
> +	GFX10_S_NOT_B32 = 7,
> +	GFX10_S_NOT_B64 = 8,
> +	GFX10_S_WQM_B32 = 9,
> +	GFX10_S_WQM_B64 = 10,
> +	GFX10_S_BREV_B32 = 11,
> +	GFX10_S_BREV_B64 = 12,
> +	GFX10_S_BCNT0_I32_B32 = 13,
> +	GFX10_S_BCNT0_I32_B64 = 14,
> +	GFX10_S_BCNT1_I32_B32 = 15,
> +	GFX10_S_BCNT1_I32_B64 = 16,
> +	GFX10_S_FF0_I32_B32 = 17,
> +	GFX10_S_FF0_I32_B64 = 18,
> +	GFX10_S_FF1_I32_B32 = 19,
> +	GFX10_S_FF1_I32_B64 = 20,
> +	GFX10_S_FLBIT_I32_B32 = 21,
> +	GFX10_S_FLBIT_I32_B64 = 22,
> +	GFX10_S_FLBIT_I32 = 23,
> +	GFX10_S_FLBIT_I32_I64 = 24,
> +	GFX10_S_SEXT_I32_I8 = 25,
> +	GFX10_S_SEXT_I32_I16 = 26,
> +	GFX10_S_BITSET0_B32 = 27,
> +	GFX10_S_BITSET0_B64 = 28,
> +	GFX10_S_BITSET1_B32 = 29,
> +	GFX10_S_BITSET1_B64 = 30,
> +	GFX10_S_GETPC_B64 = 31,
> +	GFX10_S_SETPC_B64 = 32,
> +	GFX10_S_SWAPPC_B64 = 33,
> +	GFX10_S_RFE_B64 = 34,
> +	/* 35: reserved */
> +	GFX10_S_AND_SAVEEXEC_B64 = 36,
> +	/* 37-42: OR/XOR/ANDN2/ORN2/NAND/NOR_SAVEEXEC_B64 (unused) */
> +	GFX10_S_XNOR_SAVEEXEC_B64 = 43,
> +	GFX10_S_QUADMASK_B32 = 44,
> +	GFX10_S_QUADMASK_B64 = 45,
> +	GFX10_S_MOVRELS_B32 = 46,
> +	GFX10_S_MOVRELS_B64 = 47,
> +	GFX10_S_MOVRELD_B32 = 48,
> +	GFX10_S_MOVRELD_B64 = 49,
> +	/* 50-51: reserved */
> +	GFX10_S_ABS_I32 = 52,
> +	/* 53-54: reserved */
> +	GFX10_S_ANDN1_SAVEEXEC_B64 = 55,
> +	GFX10_S_ORN1_SAVEEXEC_B64 = 56,
> +	GFX10_S_ANDN1_WREXEC_B64 = 57,
> +	GFX10_S_ANDN2_WREXEC_B64 = 58,
> +	GFX10_S_BITREPLICATE_B64_B32 = 59,
> +	GFX10_S_AND_SAVEEXEC_B32 = 60,
> +	GFX10_S_OR_SAVEEXEC_B32 = 61,
> +	GFX10_S_XOR_SAVEEXEC_B32 = 62,
> +	GFX10_S_ANDN2_SAVEEXEC_B32 = 63,
> +	GFX10_S_ORN2_SAVEEXEC_B32 = 64,
> +	GFX10_S_NAND_SAVEEXEC_B32 = 65,
> +	GFX10_S_NOR_SAVEEXEC_B32 = 66,
> +	GFX10_S_XNOR_SAVEEXEC_B32 = 67,
> +	GFX10_S_ANDN1_SAVEEXEC_B32 = 68,
> +	GFX10_S_ORN1_SAVEEXEC_B32 = 69,
> +	GFX10_S_ANDN1_WREXEC_B32 = 70,
> +	GFX10_S_ANDN2_WREXEC_B32 = 71,
> +	/* 72: reserved */
> +	GFX10_S_MOVRELSD_2_B32 = 73,
> +};
> +
> +#define GFX10_SOP1_ENCODING			0x17d
> +#define GFX10_SOP1_SSRC_SGPR_BASE		0
> +#define GFX10_SOP1_SSRC_VCC_LO			106
> +#define GFX10_SOP1_SSRC_VCC_HI			107
> +#define GFX10_SOP1_SSRC_TTPM_BASE		108
> +#define GFX10_SOP1_SSRC_M0			124
> +#define GFX10_SOP1_SSRC_NULL			125
> +#define GFX10_SOP1_SSRC_EXEC_LO			126
> +#define GFX10_SOP1_SSRC_EXEC_HI			127
> +#define GFX10_SOP1_SSRC_INTEGER_0		128
> +#define GFX10_SOP1_SSRC_INTEGER_MINUS_1		193
> +#define GFX10_SOP1_SSRC_SHARED_BASE		235
> +#define GFX10_SOP1_SSRC_SHARED_LIMIT		236
> +#define GFX10_SOP1_SSRC_PRIVATE_BASE		237
> +#define GFX10_SOP1_SSRC_PRIVATE_LIMIT		238
> +#define GFX10_SOP1_SSRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_SOP1_SSRC_VCCZ			251
> +#define GFX10_SOP1_SSRC_EXECZ			252
> +#define GFX10_SOP1_SSRC_SCC			253
> +#define GFX10_SOP1_SSRC_LITERAL_CONST		255
> +/* SDST
> + * Same codes as SSRC0, above except only codes 0-127 are valid.
> + */
> +
> +struct amdgcn_gfx10_sopc {
> +	u32 ssrc0:8;
> +	u32 ssrc1:8;
> +	u32 op:7;
> +	u32 encoding:9;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_sopc_opcode {
> +	GFX10_S_CMP_EQ_I32 = 0,
> +	GFX10_S_CMP_LG_I32 = 1,
> +	GFX10_S_CMP_GT_I32 = 2,
> +	GFX10_S_CMP_GE_I32 = 3,
> +	GFX10_S_CMP_LT_I32 = 4,
> +	GFX10_S_CMP_LE_I32 = 5,
> +	GFX10_S_CMP_EQ_U32 = 6,
> +	GFX10_S_CMP_LG_U32 = 7,
> +	GFX10_S_CMP_GT_U32 = 8,
> +	GFX10_S_CMP_GE_U32 = 9,
> +	GFX10_S_CMP_LT_U32 = 10,
> +	GFX10_S_CMP_LE_U32 = 11,
> +	GFX10_S_BITCMP0_B32 = 12,
> +	GFX10_S_BITCMP1_B32 = 13,
> +	GFX10_S_BITCMP0_B64 = 14,
> +	GFX10_S_BITCMP1_B64 = 15,
> +	/* 16-17: reserved */
> +	GFX10_S_CMP_EQ_U64 = 18,
> +	GFX10_S_CMP_LG_U64 = 19,
> +};
> +
> +#define GFX10_SOPC_ENCODING			0x17e
> +#define GFX10_SOPC_SSRC_SGPR_BASE		0
> +#define GFX10_SOPC_SSRC_VCC_LO			106
> +#define GFX10_SOPC_SSRC_VCC_HI			107
> +#define GFX10_SOPC_SSRC_TTPM_BASE		108
> +#define GFX10_SOPC_SSRC_M0			124
> +#define GFX10_SOPC_SSRC_NULL			125
> +#define GFX10_SOPC_SSRC_EXEC_LO			126
> +#define GFX10_SOPC_SSRC_EXEC_HI			127
> +#define GFX10_SOPC_SSRC_INTEGER_0		128
> +#define GFX10_SOPC_SSRC_INTEGER_MINUS_1		193
> +#define GFX10_SOPC_SSRC_SHARED_BASE		235
> +#define GFX10_SOPC_SSRC_SHARED_LIMIT		236
> +#define GFX10_SOPC_SSRC_PRIVATE_BASE		237
> +#define GFX10_SOPC_SSRC_PRIVATE_LIMIT		238
> +#define GFX10_SOPC_SSRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_SOPC_SSRC_VCCZ			251
> +#define GFX10_SOPC_SSRC_EXECZ			252
> +#define GFX10_SOPC_SSRC_SCC			253
> +/* SDST
> + * Same codes as SSRC0, above except only codes 0-127 are valid.
> + */
> +
> +struct amdgcn_gfx10_sopp_vmcnt {
> +	u16 vmcnt1:4;
> +	u16 expcnt:3;
> +	u16 dummy:1;
> +	u16 lgkmcnt:6;
> +	u16 vmcnt2:2;
> +};
> +
> +struct amdgcn_gfx10_sopp {
> +	u32 simm16:16;
> +	u32 op:7;
> +	u32 encoding:9;
> +};
> +
> +enum amdgcn_gfx10_sopp_opcode {
> +	GFX10_S_NOP = 0,
> +	GFX10_S_ENDPGM = 1,
> +	GFX10_S_BRANCH = 2,
> +	GFX10_S_WAKEUP = 3,
> +	GFX10_S_CBRANCH_SCC0 = 4,
> +	GFX10_S_CBRANCH_SCC1 = 5,
> +	GFX10_S_CBRANCH_VCCZ = 6,
> +	GFX10_S_CBRANCH_VCCNZ = 7,
> +	GFX10_S_CBRANCH_EXECZ = 8,
> +	GFX10_S_CBRANCH_EXECNZ = 9,
> +	GFX10_S_BARRIER = 10,
> +	GFX10_S_SETKILL = 11,
> +	GFX10_S_WAITCNT = 12,
> +	GFX10_S_SETHALT = 13,
> +	GFX10_S_SLEEP = 14,
> +	GFX10_S_SETPRIO = 15,
> +	GFX10_S_SENDMSG = 16,
> +	GFX10_S_SENDMSGHALT = 17,
> +	GFX10_S_TRAP = 18,
> +	GFX10_S_ICACHE_INV = 19,
> +	GFX10_S_INCPERFLEVEL = 20,
> +	GFX10_S_DECPERFLEVEL = 21,
> +	GFX10_S_TTRACEDATA = 22,
> +	GFX10_S_CBRANCH_CDBGSYS = 23,
> +	GFX10_S_CBRANCH_CDBGUSER = 24,
> +	GFX10_S_CBRANCH_CDBGSYS_OR_USER = 25,
> +	GFX10_S_CBRANCH_CDBGSYS_AND_USER = 26,
> +	GFX10_S_ENDPGM_SAVED = 27,
> +	/* 28-29: reserved */
> +	GFX10_S_ENDPGM_ORDERED_PS_DONE = 30,
> +	GFX10_S_CODE_END = 31,
> +	GFX10_S_INST_PREFETCH = 32,
> +	GFX10_S_CLAUSE = 33,
> +	/* 34: reserved */
> +	GFX10_S_WAITCNT_DEPCTR = 35,
> +	GFX10_S_ROUND_MODE = 36,
> +	GFX10_S_DENORM_MODE = 37,
> +	/* 38-39: reserved */
> +	GFX10_S_TTRACEDATA_IMM = 40,
> +};
> +
> +#define GFX10_SOPP_ENCODING		0x17f
> +
> +/* Scalar Memory Format */
> +struct amdgcn_gfx10_smem {
> +	u64 sbase:6;
> +	u64 sdata:7;
> +	u64 dummy1:1;
> +	u64 dlc:1;
> +	u64 dummy2:1;
> +	u64 glc:1;
> +	u64 dummy3:1;
> +	u64 op:8;
> +	u64 encoding:6;
> +	u64 offset:21;
> +	u64 dummy4:4;
> +	u64 soffset:7;
> +};
> +
> +enum amdgcn_gfx10_smem_opcode {
> +	GFX10_S_LOAD_DWORD = 0,
> +	GFX10_S_LOAD_DWORDX2 = 1,
> +	GFX10_S_LOAD_DWORDX4 = 2,
> +	GFX10_S_LOAD_DWORDX8 = 3,
> +	GFX10_S_LOAD_DWORDX16 = 4,
> +	/* 5-7: reserved */
> +	GFX10_S_BUFFER_LOAD_DWORD = 8,
> +	GFX10_S_BUFFER_LOAD_DWORDX2 = 9,
> +	GFX10_S_BUFFER_LOAD_DWORDX4 = 10,
> +	GFX10_S_BUFFER_LOAD_DWORDX8 = 11,
> +	GFX10_S_BUFFER_LOAD_DWORDX16 = 12,
> +	/* 13-30: reserved */
> +	GFX10_S_GL1_INV = 31,
> +	GFX10_S_DCACHE_INV = 32,
> +	/* 33-35: reserved */
> +	GFX10_S_MEMTIME = 36,
> +	GFX10_S_MEMREALTIME = 37,
> +	GFX10_S_ATC_PROBE = 38,
> +	GFX10_S_ATC_PROBE_BUFFER = 39,
> +};
> +
> +#define GFX10_SMEM_ENCODING		0x3d
> +#define GFX10_SMEM_SOFFSET_NULL		125
> +
> +/* Vector ALU Format */
> +struct amdgcn_gfx10_vop2 {
> +	u32 src0:9;
> +	u32 vsrc1:8;
> +	u32 vdst:8;
> +	u32 op:6;
> +	u32 encoding:1;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_vop2_opcode {
> +	/* 0: reserved */
> +	GFX10_V_CNDMASK_B32 = 1,
> +	GFX10_V_DOT2C_F32_F16 = 2,
> +	GFX10_V_ADD_F32 = 3,
> +	GFX10_V_SUB_F32 = 4,
> +	GFX10_V_SUBREV_F32 = 5,
> +	GFX10_V_FMAC_LEGACY_F32 = 6,
> +	GFX10_V_MUL_LEGACY_F32 = 7,
> +	GFX10_V_MUL_F32 = 8,
> +	GFX10_V_MUL_I32_I24 = 9,
> +	GFX10_V_MUL_HI_I32_I24 = 10,
> +	GFX10_V_MUL_U32_U24 = 11,
> +	GFX10_V_MUL_HI_U32_U24 = 12,
> +	GFX10_V_DOT4C_I32_I8 = 13,
> +	/* 14: reserved */
> +	GFX10_V_MIN_F32 = 15,
> +	GFX10_V_MAX_F32 = 16,
> +	GFX10_V_MIN_I32 = 17,
> +	GFX10_V_MAX_I32 = 18,
> +	GFX10_V_MIN_U32 = 19,
> +	GFX10_V_MAX_U32 = 20,
> +	/* 21: reserved */
> +	GFX10_V_LSHRREV_B32 = 22,
> +	/* 23: reserved */
> +	GFX10_V_ASHRREV_I32 = 24,
> +	/* 25: reserved */
> +	GFX10_V_LSHLREV_B32 = 26,
> +	GFX10_V_AND_B32 = 27,
> +	GFX10_V_OR_B32 = 28,
> +	GFX10_V_XOR_B32 = 29,
> +	GFX10_V_XNOR_B32 = 30,
> +	/* 31-36: reserved */
> +	GFX10_V_ADD_NC_U32 = 37,
> +	GFX10_V_SUB_NC_U32 = 38,
> +	GFX10_V_SUBREV_NC_U32 = 39,
> +	GFX10_V_ADD_CO_CI_U32 = 40,
> +	GFX10_V_SUB_CO_CI_U32 = 41,
> +	GFX10_V_SUBREV_CO_CI_U32 = 42,
> +	GFX10_V_FMAC_F32 = 43,
> +	GFX10_V_FMAMK_F32 = 44,
> +	GFX10_V_FMAAK_F32 = 45,
> +	/* 46: reserved */
> +	GFX10_V_CVT_PKRTZ_F16_F32 = 47,
> +	/* 48-49: reserved */
> +	GFX10_V_ADD_F16 = 50,
> +	GFX10_V_SUB_F16 = 51,
> +	GFX10_V_SUBREV_F16 = 52,
> +	GFX10_V_MUL_F16 = 53,
> +	GFX10_V_FMAC_F16 = 54,
> +	GFX10_V_FMAMK_F16 = 55,
> +	GFX10_V_FMAAK_F16 = 56,
> +	GFX10_V_MAX_F16 = 57,
> +	GFX10_V_MIN_F16 = 58,
> +	GFX10_V_LDEXP_F16 = 59,
> +	GFX10_V_PK_FMAC_F16 = 60,
> +};
> +
> +#define GFX10_VOP2_ENCODING			0x0
> +#define GFX10_VOP2_SRC_SGPR_BASE		0
> +#define GFX10_VOP2_SRC_VCC_LO			106
> +#define GFX10_VOP2_SRC_VCC_HI			107
> +#define GFX10_VOP2_SRC_TTPM_BASE		108
> +#define GFX10_VOP2_SRC_M0			124
> +#define GFX10_VOP2_SRC_NULL			125
> +#define GFX10_VOP2_SRC_EXEC_LO			126
> +#define GFX10_VOP2_SRC_EXEC_HI			127
> +#define GFX10_VOP2_SRC_INTEGER_0		128
> +#define GFX10_VOP2_SRC_INTEGER_MINUS_1		193
> +#define GFX10_VOP2_SRC_SHARED_BASE		235
> +#define GFX10_VOP2_SRC_SHARED_LIMIT		236
> +#define GFX10_VOP2_SRC_PRIVATE_BASE		237
> +#define GFX10_VOP2_SRC_PRIVATE_LIMIT		238
> +#define GFX10_VOP2_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_VOP2_SRC_SDWA			249
> +#define GFX10_VOP2_SRC_DDP16			250
> +#define GFX10_VOP2_SRC_VCCZ			251
> +#define GFX10_VOP2_SRC_EXECZ			252
> +#define GFX10_VOP2_SRC_SCC			253
> +#define GFX10_VOP2_SRC_LITERAL_CONST		255
> +#define GFX10_VOP2_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx10_vop1 {
> +	u32 src0:9;
> +	u32 op:8;
> +	u32 vdst:8;
> +	u32 encoding:7;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_vop1_opcode {
> +	GFX10_V_NOP = 0,
> +	GFX10_V_MOV_B32 = 1,
> +	GFX10_V_READFIRSTLANE_B32 = 2,
> +	GFX10_V_CVT_I32_F64 = 3,
> +	GFX10_V_CVT_F64_I32 = 4,
> +	GFX10_V_CVT_F32_I32 = 5,
> +	GFX10_V_CVT_F32_U32 = 6,
> +	GFX10_V_CVT_U32_F32 = 7,
> +	GFX10_V_CVT_I32_F32 = 8,
> +	/* 9: reserved */
> +	GFX10_V_CVT_F16_F32 = 10,
> +	GFX10_V_CVT_F32_F16 = 11,
> +	GFX10_V_CVT_RPI_I32_F32 = 12,
> +	GFX10_V_CVT_FLR_I32_F32 = 13,
> +	GFX10_V_CVT_OFF_F32_I4 = 14,
> +	GFX10_V_CVT_F32_F64 = 15,
> +	GFX10_V_CVT_F64_F32 = 16,
> +	GFX10_V_CVT_F32_UBYTE0 = 17,
> +	GFX10_V_CVT_F32_UBYTE1 = 18,
> +	GFX10_V_CVT_F32_UBYTE2 = 19,
> +	GFX10_V_CVT_F32_UBYTE3 = 20,
> +	GFX10_V_CVT_U32_F64 = 21,
> +	GFX10_V_CVT_F64_U32 = 22,
> +	GFX10_V_TRUNC_F64 = 23,
> +	GFX10_V_CEIL_F64 = 24,
> +	GFX10_V_RNDNE_F64 = 25,
> +	GFX10_V_FLOOR_F64 = 26,
> +	GFX10_V_PIPEFLUSH = 27,
> +	/* 28-31: reserved */
> +	GFX10_V_FRACT_F32 = 32,
> +	GFX10_V_TRUNC_F32 = 33,
> +	GFX10_V_CEIL_F32 = 34,
> +	GFX10_V_RNDNE_F32 = 35,
> +	GFX10_V_FLOOR_F32 = 36,
> +	GFX10_V_EXP_F32 = 37,
> +	/* 38: reserved */
> +	GFX10_V_LOG_F32 = 39,
> +	/* 40-41: reserved */
> +	GFX10_V_RCP_F32 = 42,
> +	GFX10_V_RCP_IFLAG_F32 = 43,
> +	/* 44-45: reserved */
> +	GFX10_V_RSQ_F32 = 46,
> +	GFX10_V_RCP_F64 = 47,
> +	/* 48: reserved */
> +	GFX10_V_RSQ_F64 = 49,
> +	/* 50: reserved */
> +	GFX10_V_SQRT_F32 = 51,
> +	GFX10_V_SQRT_F64 = 52,
> +	GFX10_V_SIN_F32 = 53,
> +	GFX10_V_COS_F32 = 54,
> +	GFX10_V_NOT_B32 = 55,
> +	GFX10_V_BFREV_B32 = 56,
> +	GFX10_V_FFBH_U32 = 57,
> +	GFX10_V_FFBL_B32 = 58,
> +	GFX10_V_FFBH_I32 = 59,
> +	GFX10_V_FREXP_EXP_I32_F64 = 60,
> +	GFX10_V_FREXP_MANT_F64 = 61,
> +	GFX10_V_FRACT_F64 = 62,
> +	GFX10_V_FREXP_EXP_I32_F32 = 63,
> +	GFX10_V_FREXP_MANT_F32 = 64,
> +	GFX10_V_CLREXCP = 65,
> +	GFX10_V_MOVRELD_B32 = 66,
> +	GFX10_V_MOVRELS_B32 = 67,
> +	GFX10_V_MOVRELSD_B32 = 68,
> +	/* 69-71: reserved */
> +	GFX10_V_MOVRELSD_2_B32 = 72,
> +	/* 73-79: reserved */
> +	GFX10_V_CVT_F16_U16 = 80,
> +	GFX10_V_CVT_F16_I16 = 81,
> +	GFX10_V_CVT_U16_F16 = 82,
> +	GFX10_V_CVT_I16_F16 = 83,
> +	GFX10_V_RCP_F16 = 84,
> +	GFX10_V_SQRT_F16 = 85,
> +	GFX10_V_RSQ_F16 = 86,
> +	GFX10_V_LOG_F16 = 87,
> +	GFX10_V_EXP_F16 = 88,
> +	GFX10_V_FREXP_MANT_F16 = 89,
> +	GFX10_V_FREXP_EXP_I16_F16 = 90,
> +	GFX10_V_FLOOR_F16 = 91,
> +	GFX10_V_CEIL_F16 = 92,
> +	GFX10_V_TRUNC_F16 = 93,
> +	GFX10_V_RNDNE_F16 = 94,
> +	GFX10_V_FRACT_F16 = 95,
> +	GFX10_V_SIN_F16 = 96,
> +	GFX10_V_COS_F16 = 97,
> +	GFX10_V_SAT_PK_U8_I16 = 98,
> +	GFX10_V_CVT_NORM_I16_F16 = 99,
> +	GFX10_V_CVT_NORM_U16_F16 = 100,
> +	GFX10_V_SWAP_B32 = 101,
> +	/* 102-103: reserved */
> +	GFX10_V_SWAPREL_B32 = 104,
> +};
> +
> +#define GFX10_VOP1_ENCODING			0x3f
> +#define GFX10_VOP1_SRC_SGPR_BASE		0
> +#define GFX10_VOP1_SRC_VCC_LO			106
> +#define GFX10_VOP1_SRC_VCC_HI			107
> +#define GFX10_VOP1_SRC_TTPM_BASE		108
> +#define GFX10_VOP1_SRC_M0			124
> +#define GFX10_VOP1_SRC_NULL			125
> +#define GFX10_VOP1_SRC_EXEC_LO			126
> +#define GFX10_VOP1_SRC_EXEC_HI			127
> +#define GFX10_VOP1_SRC_INTEGER_0		128
> +#define GFX10_VOP1_SRC_INTEGER_MINUS_1		193
> +#define GFX10_VOP1_SRC_SHARED_BASE		235
> +#define GFX10_VOP1_SRC_SHARED_LIMIT		236
> +#define GFX10_VOP1_SRC_PRIVATE_BASE		237
> +#define GFX10_VOP1_SRC_PRIVATE_LIMIT		238
> +#define GFX10_VOP1_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_VOP1_SRC_SDWA			249
> +#define GFX10_VOP1_SRC_DDP16			250
> +#define GFX10_VOP1_SRC_VCCZ			251
> +#define GFX10_VOP1_SRC_EXECZ			252
> +#define GFX10_VOP1_SRC_SCC			253
> +#define GFX10_VOP1_SRC_LITERAL_CONST		255
> +#define GFX10_VOP1_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx10_vopc {
> +	u32 src0:9;
> +	u32 vsrc1:8;
> +	u32 op:8;
> +	u32 encoding:7;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_vopc_compare_offset16 {
> +	GFX10_VOPC16_F = 0,
> +	GFX10_VOPC16_LT = 1,
> +	GFX10_VOPC16_EQ = 2,
> +	GFX10_VOPC16_LE = 3,
> +	GFX10_VOPC16_GT = 4,
> +	GFX10_VOPC16_LG = 5,
> +	GFX10_VOPC16_GE = 6,
> +	GFX10_VOPC16_O = 7,
> +	GFX10_VOPC16_U = 8,
> +	GFX10_VOPC16_NGE = 9,
> +	GFX10_VOPC16_NLG = 10,
> +	GFX10_VOPC16_NGT = 11,
> +	GFX10_VOPC16_NLE = 12,
> +	GFX10_VOPC16_NEQ = 13,
> +	GFX10_VOPC16_NLT = 14,
> +	GFX10_VOPC16_TRU = 15,
> +};
> +
> +enum amdgcn_gfx10_vopc_compare_offset8 {
> +	GFX10_VOPC8_F = 0,
> +	GFX10_VOPC8_LT = 1,
> +	GFX10_VOPC8_EQ = 2,
> +	GFX10_VOPC8_LE = 3,
> +	GFX10_VOPC8_GT = 4,
> +	GFX10_VOPC8_LG = 5,
> +	GFX10_VOPC8_GE = 6,
> +	GFX10_VOPC8_TRU = 7,
> +};
> +
> +enum amdgcn_gfx10_vopc_opcode {
> +	GFX10_V_CMP_F_F32 = 0,
> +	GFX10_V_CMP_LT_F32 = 1,
> +	GFX10_V_CMP_EQ_F32 = 2,
> +	GFX10_V_CMP_LE_F32 = 3,
> +	GFX10_V_CMP_GT_F32 = 4,
> +	GFX10_V_CMP_LG_F32 = 5,
> +	GFX10_V_CMP_GE_F32 = 6,
> +	GFX10_V_CMP_O_F32 = 7,
> +	GFX10_V_CMP_U_F32 = 8,
> +	GFX10_V_CMP_NGE_F32 = 9,
> +	GFX10_V_CMP_NLG_F32 = 10,
> +	GFX10_V_CMP_NGT_F32 = 11,
> +	GFX10_V_CMP_NLE_F32 = 12,
> +	GFX10_V_CMP_NEQ_F32 = 13,
> +	GFX10_V_CMP_NLT_F32 = 14,
> +	GFX10_V_CMP_TRU_F32 = 15,
> +	GFX10_V_CMPX_F_F32 = 16,
> +	GFX10_V_CMPX_LT_F32 = 17,
> +	GFX10_V_CMPX_EQ_F32 = 18,
> +	GFX10_V_CMPX_LE_F32 = 19,
> +	GFX10_V_CMPX_GT_F32 = 20,
> +	GFX10_V_CMPX_LG_F32 = 21,
> +	GFX10_V_CMPX_GE_F32 = 22,
> +	GFX10_V_CMPX_O_F32 = 23,
> +	GFX10_V_CMPX_U_F32 = 24,
> +	GFX10_V_CMPX_NGE_F32 = 25,
> +	GFX10_V_CMPX_NLG_F32 = 26,
> +	GFX10_V_CMPX_NGT_F32 = 27,
> +	GFX10_V_CMPX_NLE_F32 = 28,
> +	GFX10_V_CMPX_NEQ_F32 = 29,
> +	GFX10_V_CMPX_NLT_F32 = 30,
> +	GFX10_V_CMPX_TRU_F32 = 31,
> +	GFX10_V_CMP_F_F64 = 32,
> +	GFX10_V_CMP_LT_F64 = 33,
> +	GFX10_V_CMP_EQ_F64 = 34,
> +	GFX10_V_CMP_LE_F64 = 35,
> +	GFX10_V_CMP_GT_F64 = 36,
> +	GFX10_V_CMP_LG_F64 = 37,
> +	GFX10_V_CMP_GE_F64 = 38,
> +	GFX10_V_CMP_O_F64 = 39,
> +	GFX10_V_CMP_U_F64 = 40,
> +	GFX10_V_CMP_NGE_F64 = 41,
> +	GFX10_V_CMP_NLG_F64 = 42,
> +	GFX10_V_CMP_NGT_F64 = 43,
> +	GFX10_V_CMP_NLE_F64 = 44,
> +	GFX10_V_CMP_NEQ_F64 = 45,
> +	GFX10_V_CMP_NLT_F64 = 46,
> +	GFX10_V_CMP_TRU_F64 = 47,
> +	GFX10_V_CMPX_F_F64 = 48,
> +	GFX10_V_CMPX_LT_F64 = 49,
> +	GFX10_V_CMPX_EQ_F64 = 50,
> +	GFX10_V_CMPX_LE_F64 = 51,
> +	GFX10_V_CMPX_GT_F64 = 52,
> +	GFX10_V_CMPX_LG_F64 = 53,
> +	GFX10_V_CMPX_GE_F64 = 54,
> +	GFX10_V_CMPX_O_F64 = 55,
> +	GFX10_V_CMPX_U_F64 = 56,
> +	GFX10_V_CMPX_NGE_F64 = 57,
> +	GFX10_V_CMPX_NLG_F64 = 58,
> +	GFX10_V_CMPX_NGT_F64 = 59,
> +	GFX10_V_CMPX_NLE_F64 = 60,
> +	GFX10_V_CMPX_NEQ_F64 = 61,
> +	GFX10_V_CMPX_NLT_F64 = 62,
> +	GFX10_V_CMPX_TRU_F64 = 63,
> +	/* 64-127: reserved */
> +	GFX10_V_CMP_F_I32 = 128,
> +	GFX10_V_CMP_LT_I32 = 129,
> +	GFX10_V_CMP_EQ_I32 = 130,
> +	GFX10_V_CMP_LE_I32 = 131,
> +	GFX10_V_CMP_GT_I32 = 132,
> +	GFX10_V_CMP_NE_I32 = 133,
> +	GFX10_V_CMP_GE_I32 = 134,
> +	GFX10_V_CMP_T_I32 = 135,
> +	GFX10_V_CMP_CLASS_F32 = 136,
> +	GFX10_V_CMP_LT_I16 = 137,
> +	GFX10_V_CMP_EQ_I16 = 138,
> +	GFX10_V_CMP_LE_I16 = 139,
> +	GFX10_V_CMP_GT_I16 = 140,
> +	GFX10_V_CMP_NE_I16 = 141,
> +	GFX10_V_CMP_GE_I16 = 142,
> +	GFX10_V_CMP_CLASS_F16 = 143,
> +	GFX10_V_CMPX_F_I32 = 144,
> +	GFX10_V_CMPX_LT_I32 = 145,
> +	GFX10_V_CMPX_EQ_I32 = 146,
> +	GFX10_V_CMPX_LE_I32 = 147,
> +	GFX10_V_CMPX_GT_I32 = 148,
> +	GFX10_V_CMPX_NE_I32 = 149,
> +	GFX10_V_CMPX_GE_I32 = 150,
> +	GFX10_V_CMPX_T_I32 = 151,
> +	GFX10_V_CMPX_CLASS_F32 = 152,
> +	GFX10_V_CMPX_LT_I16 = 153,
> +	GFX10_V_CMPX_EQ_I16 = 154,
> +	GFX10_V_CMPX_LE_I16 = 155,
> +	GFX10_V_CMPX_GT_I16 = 156,
> +	GFX10_V_CMPX_NE_I16 = 157,
> +	GFX10_V_CMPX_GE_I16 = 158,
> +	GFX10_V_CMPX_CLASS_F16 = 159,
> +	GFX10_V_CMP_F_I64 = 160,
> +	GFX10_V_CMP_LT_I64 = 161,
> +	GFX10_V_CMP_EQ_I64 = 162,
> +	GFX10_V_CMP_LE_I64 = 163,
> +	GFX10_V_CMP_GT_I64 = 164,
> +	GFX10_V_CMP_NE_I64 = 165,
> +	GFX10_V_CMP_GE_I64 = 166,
> +	GFX10_V_CMP_T_I64 = 167,
> +	GFX10_V_CMP_CLASS_F64 = 168,
> +	GFX10_V_CMP_LT_U16 = 169,
> +	GFX10_V_CMP_EQ_U16 = 170,
> +	GFX10_V_CMP_LE_U16 = 171,
> +	GFX10_V_CMP_GT_U16 = 172,
> +	GFX10_V_CMP_NE_U16 = 173,
> +	GFX10_V_CMP_GE_U16 = 174,
> +	/* 175: reserved */
> +	GFX10_V_CMPX_F_I64 = 176,
> +	GFX10_V_CMPX_LT_I64 = 177,
> +	GFX10_V_CMPX_EQ_I64 = 178,
> +	GFX10_V_CMPX_LE_I64 = 179,
> +	GFX10_V_CMPX_GT_I64 = 180,
> +	GFX10_V_CMPX_NE_I64 = 181,
> +	GFX10_V_CMPX_GE_I64 = 182,
> +	GFX10_V_CMPX_T_I64 = 183,
> +	GFX10_V_CMPX_CLASS_F64 = 184,
> +	GFX10_V_CMPX_LT_U16 = 185,
> +	GFX10_V_CMPX_EQ_U16 = 186,
> +	GFX10_V_CMPX_LE_U16 = 187,
> +	GFX10_V_CMPX_GT_U16 = 188,
> +	GFX10_V_CMPX_NE_U16 = 189,
> +	GFX10_V_CMPX_GE_U16 = 190,
> +	/* 191: reserved */
> +	GFX10_V_CMP_F_U32 = 192,
> +	GFX10_V_CMP_LT_U32 = 193,
> +	GFX10_V_CMP_EQ_U32 = 194,
> +	GFX10_V_CMP_LE_U32 = 195,
> +	GFX10_V_CMP_GT_U32 = 196,
> +	GFX10_V_CMP_NE_U32 = 197,
> +	GFX10_V_CMP_GE_U32 = 198,
> +	GFX10_V_CMP_T_U32 = 199,
> +	GFX10_V_CMP_F_F16 = 200,
> +	GFX10_V_CMP_LT_F16 = 201,
> +	GFX10_V_CMP_EQ_F16 = 202,
> +	GFX10_V_CMP_LE_F16 = 203,
> +	GFX10_V_CMP_GT_F16 = 204,
> +	GFX10_V_CMP_LG_F16 = 205,
> +	GFX10_V_CMP_GE_F16 = 206,
> +	GFX10_V_CMP_O_F16 = 207,
> +	GFX10_V_CMPX_F_U32 = 208,
> +	GFX10_V_CMPX_LT_U32 = 209,
> +	GFX10_V_CMPX_EQ_U32 = 210,
> +	GFX10_V_CMPX_LE_U32 = 211,
> +	GFX10_V_CMPX_GT_U32 = 212,
> +	GFX10_V_CMPX_NE_U32 = 213,
> +	GFX10_V_CMPX_GE_U32 = 214,
> +	GFX10_V_CMPX_T_U32 = 215,
> +	GFX10_V_CMPX_F_F16 = 216,
> +	GFX10_V_CMPX_LT_F16 = 217,
> +	GFX10_V_CMPX_EQ_F16 = 218,
> +	GFX10_V_CMPX_LE_F16 = 219,
> +	GFX10_V_CMPX_GT_F16 = 220,
> +	GFX10_V_CMPX_LG_F16 = 221,
> +	GFX10_V_CMPX_GE_F16 = 222,
> +	GFX10_V_CMPX_O_F16 = 223,
> +	GFX10_V_CMP_F_U64 = 224,
> +	GFX10_V_CMP_LT_U64 = 225,
> +	GFX10_V_CMP_EQ_U64 = 226,
> +	GFX10_V_CMP_LE_U64 = 227,
> +	GFX10_V_CMP_GT_U64 = 228,
> +	GFX10_V_CMP_NE_U64 = 229,
> +	GFX10_V_CMP_GE_U64 = 230,
> +	GFX10_V_CMP_T_U64 = 231,
> +	GFX10_V_CMP_U_F16 = 232,
> +	GFX10_V_CMP_NGE_F16 = 233,
> +	GFX10_V_CMP_NLG_F16 = 234,
> +	GFX10_V_CMP_NGT_F16 = 235,
> +	GFX10_V_CMP_NLE_F16 = 236,
> +	GFX10_V_CMP_NEQ_F16 = 237,
> +	GFX10_V_CMP_NLT_F16 = 238,
> +	GFX10_V_CMP_TRU_F16 = 239,
> +	GFX10_V_CMPX_F_U64 = 240,
> +	GFX10_V_CMPX_LT_U64 = 241,
> +	GFX10_V_CMPX_EQ_U64 = 242,
> +	GFX10_V_CMPX_LE_U64 = 243,
> +	GFX10_V_CMPX_GT_U64 = 244,
> +	GFX10_V_CMPX_NE_U64 = 245,
> +	GFX10_V_CMPX_GE_U64 = 246,
> +	GFX10_V_CMPX_T_U64 = 247,
> +	GFX10_V_CMPX_U_F16 = 248,
> +	GFX10_V_CMPX_NGE_F16 = 249,
> +	GFX10_V_CMPX_NLG_F16 = 250,
> +	GFX10_V_CMPX_NGT_F16 = 251,
> +	GFX10_V_CMPX_NLE_F16 = 252,
> +	GFX10_V_CMPX_NEQ_F16 = 253,
> +	GFX10_V_CMPX_NLT_F16 = 254,
> +	GFX10_V_CMPX_TRU_F16 = 255,
> +};
> +
> +#define GFX10_VOPC_ENCODING			0x3e
> +#define GFX10_VOPC_SRC_SGPR_BASE		0
> +#define GFX10_VOPC_SRC_VCC_LO			106
> +#define GFX10_VOPC_SRC_VCC_HI			107
> +#define GFX10_VOPC_SRC_TTPM_BASE		108
> +#define GFX10_VOPC_SRC_M0			124
> +#define GFX10_VOPC_SRC_NULL			125
> +#define GFX10_VOPC_SRC_EXEC_LO			126
> +#define GFX10_VOPC_SRC_EXEC_HI			127
> +#define GFX10_VOPC_SRC_INTEGER_0		128
> +#define GFX10_VOPC_SRC_INTEGER_MINUS_1		193
> +#define GFX10_VOPC_SRC_SHARED_BASE		235
> +#define GFX10_VOPC_SRC_SHARED_LIMIT		236
> +#define GFX10_VOPC_SRC_PRIVATE_BASE		237
> +#define GFX10_VOPC_SRC_PRIVATE_LIMIT		238
> +#define GFX10_VOPC_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_VOPC_SRC_SDWA			249
> +#define GFX10_VOPC_SRC_DDP16			250
> +#define GFX10_VOPC_SRC_VCCZ			251
> +#define GFX10_VOPC_SRC_EXECZ			252
> +#define GFX10_VOPC_SRC_SCC			253
> +#define GFX10_VOPC_SRC_LITERAL_CONST		255
> +#define GFX10_VOPC_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx10_vop3a {
> +	u64 vdst:8;
> +	u64 abs:3;
> +	u64 op_sel:4;
> +	u64 clmp:1;
> +	u64 op:10;
> +	u64 encoding:6;
> +	u64 src0:9;
> +	u64 src1:9;
> +	u64 src2:9;
> +	u64 omod:2;
> +	u64 neg:3;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_vop3a_opcode {
> +	GFX10_V_FMA_LEGACY_F32 = 320,
> +	/* 321: reserved */
> +	GFX10_V_MAD_I32_I24 = 322,
> +	GFX10_V_MAD_U32_U24 = 323,
> +	GFX10_V_CUBEID_F32 = 324,
> +	GFX10_V_CUBESC_F32 = 325,
> +	GFX10_V_CUBETC_F32 = 326,
> +	GFX10_V_CUBEMA_F32 = 327,
> +	GFX10_V_BFE_U32 = 328,
> +	GFX10_V_BFE_I32 = 329,
> +	GFX10_V_BFI_B32 = 330,
> +	GFX10_V_FMA_F32 = 331,
> +	GFX10_V_FMA_F64 = 332,
> +	GFX10_V_LERP_U8 = 333,
> +	GFX10_V_ALIGNBIT_B32 = 334,
> +	GFX10_V_ALIGNBYTE_B32 = 335,
> +	GFX10_V_MULLIT_F32 = 336,
> +	GFX10_V_MIN3_F32 = 337,
> +	GFX10_V_MIN3_I32 = 338,
> +	GFX10_V_MIN3_U32 = 339,
> +	GFX10_V_MAX3_F32 = 340,
> +	GFX10_V_MAX3_I32 = 341,
> +	GFX10_V_MAX3_U32 = 342,
> +	GFX10_V_MED3_F32 = 343,
> +	GFX10_V_MED3_I32 = 344,
> +	GFX10_V_MED3_U32 = 345,
> +	GFX10_V_SAD_U8 = 346,
> +	GFX10_V_SAD_HI_U8 = 347,
> +	GFX10_V_SAD_U16 = 348,
> +	GFX10_V_SAD_U32 = 349,
> +	GFX10_V_CVT_PK_U8_F32 = 350,
> +	GFX10_V_DIV_FIXUP_F32 = 351,
> +	GFX10_V_DIV_FIXUP_F64 = 352,
> +	/* 353-355: reserved */
> +	GFX10_V_ADD_F64 = 356,
> +	GFX10_V_MUL_F64 = 357,
> +	GFX10_V_MIN_F64 = 358,
> +	GFX10_V_MAX_F64 = 359,
> +	GFX10_V_LDEXP_F64 = 360,
> +	GFX10_V_MUL_LO_U32 = 361,
> +	GFX10_V_MUL_HI_U32 = 362,
> +	/* 363: reserved */
> +	GFX10_V_MUL_HI_I32 = 364,
> +	/* 365-366: VOP3B (V_DIV_SCALE_F32/F64) */
> +	GFX10_V_DIV_FMAS_F32 = 367,
> +	GFX10_V_DIV_FMAS_F64 = 368,
> +	GFX10_V_MSAD_U8 = 369,
> +	GFX10_V_QSAD_PK_U16_U8 = 370,
> +	GFX10_V_MQSAD_PK_U16_U8 = 371,
> +	GFX10_V_TRIG_PREOP_F64 = 372,
> +	GFX10_V_MQSAD_U32_U8 = 373,
> +	/* 374-375: VOP3B (V_MAD_U64_U32/I64_I32) */
> +	GFX10_V_XOR3_B32 = 376,
> +	/* 377-766: reserved */
> +	GFX10_V_LSHLREV_B64 = 767,
> +	GFX10_V_LSHRREV_B64 = 768,
> +	GFX10_V_ASHRREV_I64 = 769,
> +	/* 770: reserved */
> +	GFX10_V_ADD_NC_U16 = 771,
> +	GFX10_V_SUB_NC_U16 = 772,
> +	GFX10_V_MUL_LO_U16 = 773,
> +	/* 774: reserved */
> +	GFX10_V_LSHRREV_B16 = 775,
> +	GFX10_V_ASHRREV_I16 = 776,
> +	GFX10_V_MAX_U16 = 777,
> +	GFX10_V_MAX_I16 = 778,
> +	GFX10_V_MIN_U16 = 779,
> +	GFX10_V_MIN_I16 = 780,
> +	GFX10_V_ADD_NC_I16 = 781,
> +	GFX10_V_SUB_NC_I16 = 782,
> +	/* 783-784: VOP3B (V_ADD_CO_U32/V_SUB_CO_U32) */
> +	GFX10_V_PACK_B32_F16 = 785,
> +	GFX10_V_CVT_PKNORM_I16_F16 = 786,
> +	GFX10_V_CVT_PKNORM_U16_F16 = 787,
> +	GFX10_V_LSHLREV_B16 = 788,
> +	/* 789-792: reserved; 793: VOP3B (V_SUBREV_CO_U32) */
> +	GFX10_V_MAD_U16 = 832,
> +	/* 833: reserved */
> +	GFX10_V_INTERP_P1LL_F16 = 834,
> +	GFX10_V_INTERP_P1LV_F16 = 835,
> +	GFX10_V_PERM_B32 = 836,
> +	GFX10_V_XAD_U32 = 837,
> +	GFX10_V_LSHL_ADD_U32 = 838,
> +	GFX10_V_ADD_LSHL_U32 = 839,
> +	/* 840-842: reserved */
> +	GFX10_V_FMA_F16 = 843,
> +	/* 844-848: reserved */
> +	GFX10_V_MIN3_F16 = 849,
> +	GFX10_V_MIN3_I16 = 850,
> +	GFX10_V_MIN3_U16 = 851,
> +	GFX10_V_MAX3_F16 = 852,
> +	GFX10_V_MAX3_I16 = 853,
> +	GFX10_V_MAX3_U16 = 854,
> +	GFX10_V_MED3_F16 = 855,
> +	GFX10_V_MED3_I16 = 856,
> +	GFX10_V_MED3_U16 = 857,
> +	GFX10_V_INTERP_P2_F16 = 858,
> +	/* 859-861: reserved */
> +	GFX10_V_MAD_I16 = 862,
> +	GFX10_V_DIV_FIXUP_F16 = 863,
> +	GFX10_V_READLANE_B32 = 864,
> +	GFX10_V_WRITELANE_B32 = 865,
> +	GFX10_V_LDEXP_F32 = 866,
> +	GFX10_V_BFM_B32 = 867,
> +	GFX10_V_BCNT_U32_B32 = 868,
> +	GFX10_V_MBCNT_LO_U32_B32 = 869,
> +	GFX10_V_MBCNT_HI_U32_B32 = 870,
> +	/* 871: reserved */
> +	GFX10_V_CVT_PKNORM_I16_F32 = 872,
> +	GFX10_V_CVT_PKNORM_U16_F32 = 873,
> +	GFX10_V_CVT_PK_U16_U32 = 874,
> +	GFX10_V_CVT_PK_I16_I32 = 875,
> +	/* 876: reserved */
> +	GFX10_V_ADD3_U32 = 877,
> +	/* 878: reserved */
> +	GFX10_V_LSHL_OR_B32 = 879,
> +	/* 880: reserved */
> +	GFX10_V_AND_OR_B32 = 881,
> +	GFX10_V_OR3_B32 = 882,
> +	GFX10_V_MAD_U32_U16 = 883,
> +	/* 884: reserved */
> +	GFX10_V_MAD_I32_I16 = 885,
> +	GFX10_V_SUB_NC_I32 = 886,
> +	GFX10_V_PERMLANE16_B32 = 887,
> +	GFX10_V_PERMLANEX16_B32 = 888,
> +	/* 889-894: reserved */
> +	GFX10_V_ADD_NC_I32 = 895,
> +};
> +
> +enum amdgcn_gfx10_vop3a_abs {
> +	GFX10_VOP3A_ABS_SRC0,
> +	GFX10_VOP3A_ABS_SRC1,
> +	GFX10_VOP3A_ABS_SRC2,
> +};
> +
> +#define GFX10_VOP3A_ENCODING			0x35
> +#define GFX10_VOP3A_SRC_SGPR_BASE		0
> +#define GFX10_VOP3A_SRC_VCC_LO			106
> +#define GFX10_VOP3A_SRC_VCC_HI			107
> +#define GFX10_VOP3A_SRC_TTPM_BASE		108
> +#define GFX10_VOP3A_SRC_M0			124
> +#define GFX10_VOP3A_SRC_NULL			125
> +#define GFX10_VOP3A_SRC_EXEC_LO			126
> +#define GFX10_VOP3A_SRC_EXEC_HI			127
> +#define GFX10_VOP3A_SRC_INTEGER_0		128
> +#define GFX10_VOP3A_SRC_INTEGER_MINUS_1		193
> +#define GFX10_VOP3A_SRC_SHARED_BASE		235
> +#define GFX10_VOP3A_SRC_SHARED_LIMIT		236
> +#define GFX10_VOP3A_SRC_PRIVATE_BASE		237
> +#define GFX10_VOP3A_SRC_PRIVATE_LIMIT		238
> +#define GFX10_VOP3A_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_VOP3A_SRC_SDWA			249
> +#define GFX10_VOP3A_SRC_DDP16			250
> +#define GFX10_VOP3A_SRC_VCCZ			251
> +#define GFX10_VOP3A_SRC_EXECZ			252
> +#define GFX10_VOP3A_SRC_SCC			253
> +#define GFX10_VOP3A_SRC_LITERAL_CONST		255
> +#define GFX10_VOP3A_SRC_VGPR_BASE		256
> +
> +/*
> + * Two-source VOP3 forms have reserved third-source bits on gfx10. Encoding
> + * an inline integer zero there executes, but LLVM/RGP reject the instruction.
> + */
> +#define GFX10_VOP3_UNUSED_SRC			0
> +
> +struct amdgcn_gfx10_vop3b {
> +	u64 vdst:8;
> +	u64 sdst:7;
> +	u64 clmp:1;
> +	u64 op:10;
> +	u64 encoding:6;
> +	u64 src0:9;
> +	u64 src1:9;
> +	u64 src2:9;
> +	u64 omod:2;
> +	u64 neg:3;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_vop3b_opcode {
> +	GFX10_V_DIV_SCALE_F32 = 365,
> +	GFX10_V_DIV_SCALE_F64 = 366,
> +	GFX10_V_MAD_U64_U32 = 374,
> +	GFX10_V_MAD_I64_I32 = 375,
> +	GFX10_V_ADD_CO_U32 = 783,
> +	GFX10_V_SUB_CO_U32 = 784,
> +	GFX10_V_SUBREV_CO_U32 = 793,
> +};
> +
> +#define GFX10_VOP3B_ENCODING			0x35
> +#define GFX10_VOP3B_SRC_SGPR_BASE		0
> +#define GFX10_VOP3B_SRC_VCC_LO			106
> +#define GFX10_VOP3B_SRC_VCC_HI			107
> +#define GFX10_VOP3B_SRC_TTPM_BASE		108
> +#define GFX10_VOP3B_SRC_M0			124
> +#define GFX10_VOP3B_SRC_NULL			125
> +#define GFX10_VOP3B_SRC_EXEC_LO			126
> +#define GFX10_VOP3B_SRC_EXEC_HI			127
> +#define GFX10_VOP3B_SRC_INTEGER_0		128
> +#define GFX10_VOP3B_SRC_INTEGER_MINUS_1		193
> +#define GFX10_VOP3B_SRC_SHARED_BASE		235
> +#define GFX10_VOP3B_SRC_SHARED_LIMIT		236
> +#define GFX10_VOP3B_SRC_PRIVATE_BASE		237
> +#define GFX10_VOP3B_SRC_PRIVATE_LIMIT		238
> +#define GFX10_VOP3B_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_VOP3B_SRC_SDWA			249
> +#define GFX10_VOP3B_SRC_DDP16			250
> +#define GFX10_VOP3B_SRC_VCCZ			251
> +#define GFX10_VOP3B_SRC_EXECZ			252
> +#define GFX10_VOP3B_SRC_SCC			253
> +#define GFX10_VOP3B_SRC_LITERAL_CONST		255
> +#define GFX10_VOP3B_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx10_vop3p {
> +	u64 vdst:8;
> +	u64 neg_hi:3;
> +	u64 op_sel:3;
> +	u64 op_sel_hi2:1;
> +	u64 clmp:1;
> +	u64 op:7;
> +	u64 dummy:3;
> +	u64 encoding:6;
> +	u64 src0:9;
> +	u64 src1:9;
> +	u64 src2:9;
> +	u64 op_sel_hi:2;
> +	u64 neg:3;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx10_vop3p_opcode {
> +	GFX10_V_PK_MAD_I16 = 0,
> +	GFX10_V_PK_MUL_LO_U16 = 1,
> +	GFX10_V_PK_ADD_I16 = 2,
> +	GFX10_V_PK_SUB_I16 = 3,
> +	GFX10_V_PK_LSHLREV_B16 = 4,
> +	GFX10_V_PK_LSHRREV_B16 = 5,
> +	GFX10_V_PK_ASHRREV_I16 = 6,
> +	GFX10_V_PK_MAX_I16 = 7,
> +	GFX10_V_PK_MIN_I16 = 8,
> +	GFX10_V_PK_MAD_U16 = 9,
> +	GFX10_V_PK_ADD_U16 = 10,
> +	GFX10_V_PK_SUB_U16 = 11,
> +	GFX10_V_PK_MAX_U16 = 12,
> +	GFX10_V_PK_MIN_U16 = 13,
> +	GFX10_V_PK_FMA_F16 = 14,
> +	GFX10_V_PK_ADD_F16 = 15,
> +	GFX10_V_PK_MUL_F16 = 16,
> +	GFX10_V_PK_MIN_F16 = 17,
> +	GFX10_V_PK_MAX_F16 = 18,
> +	GFX10_V_DOT2_F32_F16 = 19,
> +	GFX10_V_DOT2_I32_I16 = 20,
> +	GFX10_V_DOT2_U32_U16 = 21,
> +	GFX10_V_DOT4_I32_I8 = 22,
> +	GFX10_V_DOT4_U32_U8 = 23,
> +	GFX10_V_DOT8_I32_I4 = 24,
> +	GFX10_V_DOT8_U32_U4 = 25,
> +	/* 26-31: reserved */
> +	GFX10_V_FMA_MIX_F32 = 32,
> +	GFX10_V_FMA_MIXLO_F16 = 33,
> +	GFX10_V_FMA_MIXHI_F16 = 34,
> +};
> +
> +#define GFX10_VOP3P_ENCODING			0x33
> +#define GFX10_VOP3P_SRC_SGPR_BASE		0
> +#define GFX10_VOP3P_SRC_VCC_LO		106
> +#define GFX10_VOP3P_SRC_VCC_HI		107
> +#define GFX10_VOP3P_SRC_TTPM_BASE		108
> +#define GFX10_VOP3P_SRC_M0			124
> +#define GFX10_VOP3P_SRC_NULL			125
> +#define GFX10_VOP3P_SRC_EXEC_LO		126
> +#define GFX10_VOP3P_SRC_EXEC_HI		127
> +#define GFX10_VOP3P_SRC_INTEGER_0		128
> +#define GFX10_VOP3P_SRC_INTEGER_MINUS_1	193
> +#define GFX10_VOP3P_SRC_SHARED_BASE		235
> +#define GFX10_VOP3P_SRC_SHARED_LIMIT		236
> +#define GFX10_VOP3P_SRC_PRIVATE_BASE		237
> +#define GFX10_VOP3P_SRC_PRIVATE_LIMIT		238
> +#define GFX10_VOP3P_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX10_VOP3P_SRC_SDWA			249
> +#define GFX10_VOP3P_SRC_DDP16			250
> +#define GFX10_VOP3P_SRC_VCCZ			251
> +#define GFX10_VOP3P_SRC_EXECZ			252
> +#define GFX10_VOP3P_SRC_SCC			253
> +#define GFX10_VOP3P_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx10_sdwa {
> +	u32 src0:8;
> +	u32 dst_sel:3;
> +	u32 dst_u:2;
> +	u32 clmp:1;
> +	u32 omod:2;
> +	u32 src0_sel:3;
> +	u32 src0_sext:1;
> +	u32 src0_neg:1;
> +	u32 src0_abs:1;
> +	u32 dummy1:1;
> +	u32 s0:1;
> +	u32 src1_sel:3;
> +	u32 src1_sext:1;
> +	u32 src1_neg:1;
> +	u32 src1_abs:1;
> +	u32 dummy2:1;
> +	u32 s1:1;
> +};
> +
> +struct amdgcn_gfx10_sdwab {
> +	u32 src0:8;
> +	u32 sdst:7;
> +	u32 sd:1;
> +	u32 src0_sel:3;
> +	u32 src0_sext:1;
> +	u32 src0_neg:1;
> +	u32 src0_abs:1;
> +	u32 dummy1:1;
> +	u32 s0:1;
> +	u32 src1_sel:3;
> +	u32 src1_sext:1;
> +	u32 src1_neg:1;
> +	u32 src1_abs:1;
> +	u32 dummy2:1;
> +	u32 s1:1;
> +};
> +
> +struct amdgcn_gfx10_dpp16 {
> +};
> +
> +struct amdgcn_gfx10_dpp8 {
> +};
> +
> +/* Vector Parameter Interpolation Format */
> +struct amdgcn_gfx10_vintrp {
> +};
> +
> +/* LDS and GDS Format */
> +struct amdgcn_gfx10_ds {
> +	u64 offset0:8;
> +	u64 offset1:8;
> +	u64 dummy:1;
> +	u64 gds:1;
> +	u64 op:8;
> +	u64 encoding:6;
> +	u64 addr:8;
> +	u64 data0:8;
> +	u64 data1:8;
> +	u64 vdst:8;
> +};
> +
> +enum amdgcn_gfx10_ds_opcode {
> +	GFX10_DS_ADD_U32 = 0,
> +	GFX10_DS_SUB_U32 = 1,
> +	GFX10_DS_RSUB_U32 = 2,
> +	GFX10_DS_INC_U32 = 3,
> +	GFX10_DS_DEC_U32 = 4,
> +	GFX10_DS_MIN_I32 = 5,
> +	GFX10_DS_MAX_I32 = 6,
> +	GFX10_DS_MIN_U32 = 7,
> +	GFX10_DS_MAX_U32 = 8,
> +	GFX10_DS_AND_B32 = 9,
> +	GFX10_DS_OR_B32 = 10,
> +	GFX10_DS_XOR_B32 = 11,
> +	GFX10_DS_MSKOR_B32 = 12,
> +	GFX10_DS_WRITE_B32 = 13,
> +	GFX10_DS_WRITE2_B32 = 14,
> +	GFX10_DS_WRITE2ST64_B32 = 15,
> +	GFX10_DS_CMPST_B32 = 16,
> +	GFX10_DS_CMPST_F32 = 17,
> +	GFX10_DS_MIN_F32 = 18,
> +	GFX10_DS_MAX_F32 = 19,
> +	GFX10_DS_NOP = 20,
> +	GFX10_DS_ADD_F32 = 21,
> +	/* 22-23: reserved */
> +	GFX10_DS_GWS_SEMA_RELEASE_ALL = 24,
> +	GFX10_DS_GWS_INIT = 25,
> +	GFX10_DS_GWS_SEMA_V = 26,
> +	GFX10_DS_GWS_SEMA_BR = 27,
> +	GFX10_DS_GWS_SEMA_P = 28,
> +	GFX10_DS_GWS_BARRIER = 29,
> +	GFX10_DS_WRITE_B8 = 30,
> +	GFX10_DS_WRITE_B16 = 31,
> +	GFX10_DS_ADD_RTN_U32 = 32,
> +	GFX10_DS_SUB_RTN_U32 = 33,
> +	GFX10_DS_RSUB_RTN_U32 = 34,
> +	GFX10_DS_INC_RTN_U32 = 35,
> +	GFX10_DS_DEC_RTN_U32 = 36,
> +	GFX10_DS_MIN_RTN_I32 = 37,
> +	GFX10_DS_MAX_RTN_I32 = 38,
> +	GFX10_DS_MIN_RTN_U32 = 39,
> +	GFX10_DS_MAX_RTN_U32 = 40,
> +	GFX10_DS_AND_RTN_B32 = 41,
> +	GFX10_DS_OR_RTN_B32 = 42,
> +	GFX10_DS_XOR_RTN_B32 = 43,
> +	GFX10_DS_MSKOR_RTN_B32 = 44,
> +	GFX10_DS_WRXCHG_RTN_B32 = 45,
> +	GFX10_DS_WRXCHG2_RTN_B32 = 46,
> +	GFX10_DS_WRXCHG2ST64_RTN_B32 = 47,
> +	GFX10_DS_CMPST_RTN_B32 = 48,
> +	GFX10_DS_CMPST_RTN_F32 = 49,
> +	GFX10_DS_MIN_RTN_F32 = 50,
> +	GFX10_DS_MAX_RTN_F32 = 51,
> +	GFX10_DS_WRAP_RTN_B32 = 52,
> +	GFX10_DS_SWIZZLE_B32 = 53,
> +	GFX10_DS_READ_B32 = 54,
> +	GFX10_DS_READ2_B32 = 55,
> +	GFX10_DS_READ2ST64_B32 = 56,
> +	GFX10_DS_READ_I8 = 57,
> +	GFX10_DS_READ_U8 = 58,
> +	GFX10_DS_READ_I16 = 59,
> +	GFX10_DS_READ_U16 = 60,
> +	GFX10_DS_CONSUME = 61,
> +	GFX10_DS_APPEND = 62,
> +	GFX10_DS_ORDERED_COUNT = 63,
> +	GFX10_DS_ADD_U64 = 64,
> +	GFX10_DS_SUB_U64 = 65,
> +	GFX10_DS_RSUB_U64 = 66,
> +	GFX10_DS_INC_U64 = 67,
> +	GFX10_DS_DEC_U64 = 68,
> +	GFX10_DS_MIN_I64 = 69,
> +	GFX10_DS_MAX_I64 = 70,
> +	GFX10_DS_MIN_U64 = 71,
> +	GFX10_DS_MAX_U64 = 72,
> +	GFX10_DS_AND_B64 = 73,
> +	GFX10_DS_OR_B64 = 74,
> +	GFX10_DS_XOR_B64 = 75,
> +	GFX10_DS_MSKOR_B64 = 76,
> +	GFX10_DS_WRITE_B64 = 77,
> +	GFX10_DS_WRITE2_B64 = 78,
> +	GFX10_DS_WRITE2ST64_B64 = 79,
> +	GFX10_DS_CMPST_B64 = 80,
> +	GFX10_DS_CMPST_F64 = 81,
> +	GFX10_DS_MIN_F64 = 82,
> +	GFX10_DS_MAX_F64 = 83,
> +	/* 84: reserved */
> +	GFX10_DS_ADD_RTN_F32 = 85,
> +	/* 86-95: reserved */
> +	GFX10_DS_ADD_RTN_U64 = 96,
> +	GFX10_DS_SUB_RTN_U64 = 97,
> +	GFX10_DS_RSUB_RTN_U64 = 98,
> +	GFX10_DS_INC_RTN_U64 = 99,
> +	GFX10_DS_DEC_RTN_U64 = 100,
> +	GFX10_DS_MIN_RTN_I64 = 101,
> +	GFX10_DS_MAX_RTN_I64 = 102,
> +	GFX10_DS_MIN_RTN_U64 = 103,
> +	GFX10_DS_MAX_RTN_U64 = 104,
> +	GFX10_DS_AND_RTN_B64 = 105,
> +	GFX10_DS_OR_RTN_B64 = 106,
> +	GFX10_DS_XOR_RTN_B64 = 107,
> +	GFX10_DS_MSKOR_RTN_B64 = 108,
> +	GFX10_DS_WRXCHG_RTN_B64 = 109,
> +	GFX10_DS_WRXCHG2_RTN_B64 = 110,
> +	GFX10_DS_WRXCHG2ST64_RTN_B64 = 111,
> +	GFX10_DS_CMPST_RTN_B64 = 112,
> +	GFX10_DS_CMPST_RTN_F64 = 113,
> +	GFX10_DS_MIN_RTN_F64 = 114,
> +	GFX10_DS_MAX_RTN_F64 = 115,
> +	/* 116-117: reserved */
> +	GFX10_DS_READ_B64 = 118,
> +	GFX10_DS_READ2_B64 = 119,
> +	GFX10_DS_READ2ST64_B64 = 120,
> +	/* 121-125: reserved */
> +	GFX10_DS_CONDXCHG32_RTN_B64 = 126,
> +	/* 127-159: reserved */
> +	GFX10_DS_WRITE_B8_D16_HI = 160,
> +	GFX10_DS_WRITE_B16_D16_HI = 161,
> +	GFX10_DS_READ_U8_D16 = 162,
> +	GFX10_DS_READ_U8_D16_HI = 163,
> +	GFX10_DS_READ_I8_D16 = 164,
> +	GFX10_DS_READ_I8_D16_HI = 165,
> +	GFX10_DS_READ_U16_D16 = 166,
> +	GFX10_DS_READ_U16_D16_HI = 167,
> +	/* 168-175: reserved */
> +	GFX10_DS_WRITE_ADDTID_B32 = 176,
> +	GFX10_DS_READ_ADDTID_B32 = 177,
> +	GFX10_DS_PERMUTE_B32 = 178,
> +	GFX10_DS_BPERMUTE_B32 = 179,
> +	/* 180-221: reserved */
> +	GFX10_DS_WRITE_B96 = 222,
> +	GFX10_DS_WRITE_B128 = 223,
> +	/* 224-253: reserved */
> +	GFX10_DS_READ_B96 = 254,
> +	GFX10_DS_READ_B128 = 255,
> +};
> +
> +#define GFX10_DS_ENCODING		0x36
> +#define GFX10_DS_GDS			1
> +#define GFX10_DS_LDS			0
> +
> +/* Vector Memory Buffer Formats */
> +struct amdgcn_gfx10_mtbuf {
> +	u64 offset:12;
> +	u64 offen:1;
> +	u64 idxen:1;
> +	u64 glc:1;
> +	u64 dlc:1;
> +	u64 op:3;
> +	u64 foamat:7;
> +	u64 encoding:6;
> +	u64 vaddr:8;
> +	u64 vdata:8;
> +	u64 srsrc:5;
> +	u64 opm:1;
> +	u64 slc:1;
> +	u64 tfe:1;
> +	u64 soffset:8;
> +};
> +
> +enum amdgcn_gfx10_mtbuf_opcode {
> +	GFX10_TBUFFER_LOAD_FORMAT_X = 0,
> +	GFX10_TBUFFER_LOAD_FORMAT_XY = 1,
> +	GFX10_TBUFFER_LOAD_FORMAT_XYZ = 2,
> +	GFX10_TBUFFER_LOAD_FORMAT_XYZW = 3,
> +	GFX10_TBUFFER_STORE_FORMAT_X = 4,
> +	GFX10_TBUFFER_STORE_FORMAT_XY = 5,
> +	GFX10_TBUFFER_STORE_FORMAT_XYZ = 6,
> +	GFX10_TBUFFER_STORE_FORMAT_XYZW = 7,
> +	GFX10_TBUFFER_LOAD_FORMAT_D16_X = 8,
> +	GFX10_TBUFFER_LOAD_FORMAT_D16_XY = 9,
> +	GFX10_TBUFFER_LOAD_FORMAT_D16_XYZ = 10,
> +	GFX10_TBUFFER_LOAD_FORMAT_D16_XYZW = 11,
> +	GFX10_TBUFFER_STORE_FORMAT_D16_X = 12,
> +	GFX10_TBUFFER_STORE_FORMAT_D16_XY = 13,
> +	GFX10_TBUFFER_STORE_FORMAT_D16_XYZ = 14,
> +	GFX10_TBUFFER_STORE_FORMAT_D16_XYZW = 15,
> +};
> +
> +#define GFX10_MUBUF_ENCODING				0x38
> +#define GFX10_MUBUF_SOFFSET_SGPR_BASE			0
> +#define GFX10_MUBUF_SOFFSET_VCC_LO			106
> +#define GFX10_MUBUF_SOFFSET_VCC_HI			107
> +#define GFX10_MUBUF_SOFFSET_TTPM_BASE			108
> +#define GFX10_MUBUF_SOFFSET_M0				124
> +#define GFX10_MUBUF_SOFFSET_NULL			125
> +#define GFX10_MUBUF_SOFFSET_EXEC_LO			126
> +#define GFX10_MUBUF_SOFFSET_EXEC_HI			127
> +#define GFX10_MUBUF_SOFFSET_INTEGER_0			128
> +#define GFX10_MUBUF_SOFFSET_INTEGER_MINUS_1		193
> +#define GFX10_MUBUF_SOFFSET_SHARED_BASE			235
> +#define GFX10_MUBUF_SOFFSET_SHARED_LIMIT		236
> +#define GFX10_MUBUF_SOFFSET_PRIVATE_BASE		237
> +#define GFX10_MUBUF_SOFFSET_PRIVATE_LIMIT		238
> +#define GFX10_MUBUF_SOFFSET_POPS_EXITING_WAVE_ID	239
> +#define GFX10_MUBUF_SOFFSET_VCCZ			251
> +#define GFX10_MUBUF_SOFFSET_EXECZ			252
> +#define GFX10_MUBUF_SOFFSET_SCC				253
> +
> +struct amdgcn_gfx10_mubuf {
> +	u64 offset:12;
> +	u64 offen:1;
> +	u64 idxen:1;
> +	u64 glc:1;
> +	u64 dlc:1;
> +	u64 lds:1;
> +	u64 dummy1:1;
> +	u64 op:7;
> +	u64 opm:1;
> +	u64 encoding:6;
> +	u64 vaddr:8;
> +	u64 vdata:8;
> +	u64 srsrc:5;
> +	u64 dummy2:1;
> +	u64 slc:1;
> +	u64 tfe:1;
> +	u64 soffset:8;
> +};
> +
> +enum amdgcn_gfx10_mubuf_opcode {
> +	GFX10_BUFFER_LOAD_FORMAT_X = 0,
> +	GFX10_BUFFER_LOAD_FORMAT_XY = 1,
> +	GFX10_BUFFER_LOAD_FORMAT_XYZ = 2,
> +	GFX10_BUFFER_LOAD_FORMAT_XYZW = 3,
> +	GFX10_BUFFER_STORE_FORMAT_X = 4,
> +	GFX10_BUFFER_STORE_FORMAT_XY = 5,
> +	GFX10_BUFFER_STORE_FORMAT_XYZ = 6,
> +	GFX10_BUFFER_STORE_FORMAT_XYZW = 7,
> +	GFX10_BUFFER_LOAD_UBYTE = 8,
> +	GFX10_BUFFER_LOAD_SBYTE = 9,
> +	GFX10_BUFFER_LOAD_USHORT = 10,
> +	GFX10_BUFFER_LOAD_SSHORT = 11,
> +	GFX10_BUFFER_LOAD_DWORD = 12,
> +	GFX10_BUFFER_LOAD_DWORDX2 = 13,
> +	GFX10_BUFFER_LOAD_DWORDX4 = 14,
> +	GFX10_BUFFER_LOAD_DWORDX3 = 15,
> +	/* 16-23: reserved */
> +	GFX10_BUFFER_STORE_BYTE = 24,
> +	GFX10_BUFFER_STORE_BYTE_D16_HI = 25,
> +	GFX10_BUFFER_STORE_SHORT = 26,
> +	GFX10_BUFFER_STORE_SHORT_D16_HI = 27,
> +	GFX10_BUFFER_STORE_DWORD = 28,
> +	GFX10_BUFFER_STORE_DWORDX2 = 29,
> +	GFX10_BUFFER_STORE_DWORDX4 = 30,
> +	GFX10_BUFFER_STORE_DWORDX3 = 31,
> +	GFX10_BUFFER_LOAD_UBYTE_D16 = 32,
> +	GFX10_BUFFER_LOAD_UBYTE_D16_HI = 33,
> +	GFX10_BUFFER_LOAD_SBYTE_D16 = 34,
> +	GFX10_BUFFER_LOAD_SBYTE_D16_HI = 35,
> +	GFX10_BUFFER_LOAD_SHORT_D16 = 36,
> +	GFX10_BUFFER_LOAD_SHORT_D16_HI = 37,
> +	GFX10_BUFFER_LOAD_FORMAT_D16_HI_X = 38,
> +	GFX10_BUFFER_STORE_FORMAT_D16_HI_X = 39,
> +	/* 40-47: reserved */
> +	GFX10_BUFFER_ATOMIC_SWAP = 48,
> +	GFX10_BUFFER_ATOMIC_CMPSWAP = 49,
> +	GFX10_BUFFER_ATOMIC_ADD = 50,
> +	GFX10_BUFFER_ATOMIC_SUB = 51,
> +	GFX10_BUFFER_ATOMIC_CSUB = 52,
> +	GFX10_BUFFER_ATOMIC_SMIN = 53,
> +	GFX10_BUFFER_ATOMIC_UMIN = 54, /* was 58 - BUG FIX (ISA p.212) */
> +	GFX10_BUFFER_ATOMIC_SMAX = 55,
> +	GFX10_BUFFER_ATOMIC_UMAX = 56,
> +	GFX10_BUFFER_ATOMIC_AND = 57,
> +	GFX10_BUFFER_ATOMIC_OR = 58,
> +	GFX10_BUFFER_ATOMIC_XOR = 59,
> +	GFX10_BUFFER_ATOMIC_INC = 60,
> +	GFX10_BUFFER_ATOMIC_DEC = 61,
> +	GFX10_BUFFER_ATOMIC_FCMPSWAP = 62,
> +	GFX10_BUFFER_ATOMIC_FMIN = 63,
> +	GFX10_BUFFER_ATOMIC_FMAX = 64,
> +	/* 65-79: reserved */
> +	GFX10_BUFFER_ATOMIC_SWAP_X2 = 80,
> +	GFX10_BUFFER_ATOMIC_CMPSWAP_X2 = 81,
> +	GFX10_BUFFER_ATOMIC_ADD_X2 = 82,
> +	GFX10_BUFFER_ATOMIC_SUB_X2 = 83,
> +	/* 84: reserved */
> +	GFX10_BUFFER_ATOMIC_SMIN_X2 = 85,
> +	GFX10_BUFFER_ATOMIC_UMIN_X2 = 86,
> +	GFX10_BUFFER_ATOMIC_SMAX_X2 = 87,
> +	GFX10_BUFFER_ATOMIC_UMAX_X2 = 88,
> +	GFX10_BUFFER_ATOMIC_AND_X2 = 89,
> +	GFX10_BUFFER_ATOMIC_OR_X2 = 90,
> +	GFX10_BUFFER_ATOMIC_XOR_X2 = 91,
> +	GFX10_BUFFER_ATOMIC_INC_X2 = 92,
> +	GFX10_BUFFER_ATOMIC_DEC_X2 = 93,
> +	GFX10_BUFFER_ATOMIC_FCMPSWAP_X2 = 94,
> +	GFX10_BUFFER_ATOMIC_FMIN_X2 = 95,
> +	GFX10_BUFFER_ATOMIC_FMAX_X2 = 96,
> +	/* 97-112: reserved */
> +	GFX10_BUFFER_GL0_INV = 113,
> +	GFX10_BUFFER_GL1_INV = 114,
> +	/* 115-127: reserved */
> +	GFX10_BUFFER_LOAD_FORMAT_D16_X = 128,
> +	GFX10_BUFFER_LOAD_FORMAT_D16_XY = 129,
> +	GFX10_BUFFER_LOAD_FORMAT_D16_XYZ = 130,
> +	GFX10_BUFFER_LOAD_FORMAT_D16_XYZW = 131,
> +	GFX10_BUFFER_STORE_FORMAT_D16_X = 132,
> +	GFX10_BUFFER_STORE_FORMAT_D16_XY = 133,
> +	GFX10_BUFFER_STORE_FORMAT_D16_XYZ = 134,
> +	GFX10_BUFFER_STORE_FORMAT_D16_XYZW = 135,
> +};
> +
> +/* Vector Memory Image Format */
> +struct amdgcn_gfx10_mimg {
> +};
> +
> +#define GFX10_FLAT_ENCODING			0x37
> +#define GFX10_FLAT_SADDR_SGPR_BASE		0
> +#define GFX10_FLAT_SADDR_VCC_LO			106
> +#define GFX10_FLAT_SADDR_VCC_HI			107
> +#define GFX10_FLAT_SADDR_TTPM_BASE		108
> +#define GFX10_FLAT_SADDR_M0			124
> +#define GFX10_FLAT_SADDR_NULL			125
> +#define GFX10_FLAT_SADDR_EXEC_LO		126
> +#define GFX10_FLAT_SADDR_EXEC_HI		127
> +#define GFX10_FLAT_SADDR_INTEGER_0		128
> +#define GFX10_FLAT_SADDR_INTEGER_MINUS_1	193
> +#define GFX10_FLAT_SADDR_SHARED_BASE		235
> +#define GFX10_FLAT_SADDR_SHARED_LIMIT		236
> +#define GFX10_FLAT_SADDR_PRIVATE_BASE		237
> +#define GFX10_FLAT_SADDR_PRIVATE_LIMIT		238
> +#define GFX10_FLAT_SADDR_POPS_EXITING_WAVE_ID	239
> +#define GFX10_FLAT_SADDR_VCCZ			251
> +#define GFX10_FLAT_SADDR_EXECZ			252
> +#define GFX10_FLAT_SADDR_SCC			253
> +
> +/*
> + * Scalar SGPR that provides an offset address. Use NULL for disabled global
> + * addressing; the 0x7f encoding is not accepted by LLVM/RGP for gfx10 global
> + * memory instructions.
> + * Meaning of this field is different for Scratch and Global:
> + * Flat: Unused.
> + * Scratch: Use an SGPR (instead of VGPR) for the address.
> + * Global: Use the SGPR to provide a base address; the VGPR provides a 32-bit
> + * offset per lane.
> + */
> +#define GFX10_FLAT_SADDR_DISABLE                 GFX10_FLAT_SADDR_NULL
> +#define GFX10_FLAT_SEG_FLAT                      0
> +#define GFX10_FLAT_SEG_SCRATCH                   1
> +#define GFX10_FLAT_SEG_GLOBAL                    2
> +
> +/* Flat Formats */
> +struct amdgcn_gfx10_flat {
> +	u64 offset:12;
> +	u64 dlc:1;
> +	u64 lds:1;
> +	u64 seg:2;
> +	u64 glc:1;
> +	u64 slc:1;
> +	u64 op:7;
> +	u64 dummy1:1;
> +	u64 encoding:6;
> +	u64 addr:8;
> +	u64 data:8;
> +	u64 saddr:7;
> +	u64 dummy2:1;
> +	u64 vdst:8;
> +};
> +
> +enum amdgcn_gfx10_flat_opcode {
> +	/* 0-7: reserved */
> +	GFX10_FLAT_LOAD_UBYTE = 8,
> +	GFX10_FLAT_LOAD_SBYTE = 9,
> +	GFX10_FLAT_LOAD_USHORT = 10,
> +	GFX10_FLAT_LOAD_SSHORT = 11,
> +	GFX10_FLAT_LOAD_DWORD = 12,
> +	GFX10_FLAT_LOAD_DWORDX2 = 13,
> +	GFX10_FLAT_LOAD_DWORDX4 = 14,
> +	GFX10_FLAT_LOAD_DWORDX3 = 15,
> +	/* 16-23: reserved */
> +	GFX10_FLAT_STORE_BYTE = 24,
> +	GFX10_FLAT_STORE_BYTE_D16_HI = 25,
> +	GFX10_FLAT_STORE_SHORT = 26,
> +	GFX10_FLAT_STORE_SHORT_D16_HI = 27,
> +	GFX10_FLAT_STORE_DWORD = 28,
> +	GFX10_FLAT_STORE_DWORDX2 = 29,
> +	GFX10_FLAT_STORE_DWORDX4 = 30,
> +	GFX10_FLAT_STORE_DWORDX3 = 31,
> +	GFX10_FLAT_LOAD_UBYTE_D16 = 32,
> +	GFX10_FLAT_LOAD_UBYTE_D16_HI = 33,
> +	GFX10_FLAT_LOAD_SBYTE_D16 = 34,
> +	GFX10_FLAT_LOAD_SBYTE_D16_HI = 35,
> +	GFX10_FLAT_LOAD_SHORT_D16 = 36,
> +	GFX10_FLAT_LOAD_SHORT_D16_HI = 37,
> +	/* 38-47: reserved */
> +	GFX10_FLAT_ATOMIC_SWAP = 48,
> +	GFX10_FLAT_ATOMIC_CMPSWAP = 49,
> +	GFX10_FLAT_ATOMIC_ADD = 50,
> +	GFX10_FLAT_ATOMIC_SUB = 51,
> +	/* 52: reserved (CSUB is GLOBAL/MUBUF only) */
> +	GFX10_FLAT_ATOMIC_SMIN = 53,
> +	GFX10_FLAT_ATOMIC_UMIN = 54,
> +	GFX10_FLAT_ATOMIC_SMAX = 55,
> +	GFX10_FLAT_ATOMIC_UMAX = 56,
> +	GFX10_FLAT_ATOMIC_AND = 57,
> +	GFX10_FLAT_ATOMIC_OR = 58,
> +	GFX10_FLAT_ATOMIC_XOR = 59,
> +	GFX10_FLAT_ATOMIC_INC = 60,
> +	GFX10_FLAT_ATOMIC_DEC = 61,
> +	GFX10_FLAT_ATOMIC_FCMPSWAP = 62,
> +	GFX10_FLAT_ATOMIC_FMIN = 63,
> +	GFX10_FLAT_ATOMIC_FMAX = 64,
> +	/* 65-79: reserved */
> +	GFX10_FLAT_ATOMIC_SWAP_X2 = 80,
> +	GFX10_FLAT_ATOMIC_CMPSWAP_X2 = 81,
> +	GFX10_FLAT_ATOMIC_ADD_X2 = 82,
> +	GFX10_FLAT_ATOMIC_SUB_X2 = 83,
> +	/* 84: reserved */
> +	GFX10_FLAT_ATOMIC_SMIN_X2 = 85,
> +	GFX10_FLAT_ATOMIC_UMIN_X2 = 86,
> +	GFX10_FLAT_ATOMIC_SMAX_X2 = 87,
> +	GFX10_FLAT_ATOMIC_UMAX_X2 = 88,
> +	GFX10_FLAT_ATOMIC_AND_X2 = 89,
> +	GFX10_FLAT_ATOMIC_OR_X2 = 90,
> +	GFX10_FLAT_ATOMIC_XOR_X2 = 91,
> +	GFX10_FLAT_ATOMIC_INC_X2 = 92,
> +	GFX10_FLAT_ATOMIC_DEC_X2 = 93,
> +	GFX10_FLAT_ATOMIC_FCMPSWAP_X2 = 94,
> +	GFX10_FLAT_ATOMIC_FMIN_X2 = 95,
> +	GFX10_FLAT_ATOMIC_FMAX_X2 = 96,
> +};
> +
> +enum amdgcn_gfx10_global_opcode {
> +	/* 0-7: reserved */
> +	GFX10_GLOBAL_LOAD_UBYTE = 8,
> +	GFX10_GLOBAL_LOAD_SBYTE = 9,
> +	GFX10_GLOBAL_LOAD_USHORT = 10,
> +	GFX10_GLOBAL_LOAD_SSHORT = 11,
> +	GFX10_GLOBAL_LOAD_DWORD = 12,
> +	GFX10_GLOBAL_LOAD_DWORDX2 = 13,
> +	GFX10_GLOBAL_LOAD_DWORDX4 = 14,
> +	GFX10_GLOBAL_LOAD_DWORDX3 = 15,
> +	/* 16-21: reserved */
> +	GFX10_GLOBAL_LOAD_DWORD_ADDTID = 22,
> +	GFX10_GLOBAL_STORE_DWORD_ADDTID = 23,
> +	GFX10_GLOBAL_STORE_BYTE = 24,
> +	GFX10_GLOBAL_STORE_BYTE_D16_HI = 25,
> +	GFX10_GLOBAL_STORE_SHORT = 26,
> +	GFX10_GLOBAL_STORE_SHORT_D16_HI = 27,
> +	GFX10_GLOBAL_STORE_DWORD = 28,
> +	GFX10_GLOBAL_STORE_DWORDX2 = 29,
> +	GFX10_GLOBAL_STORE_DWORDX4 = 30,
> +	GFX10_GLOBAL_STORE_DWORDX3 = 31,
> +	GFX10_GLOBAL_LOAD_UBYTE_D16 = 32,
> +	GFX10_GLOBAL_LOAD_UBYTE_D16_HI = 33,
> +	GFX10_GLOBAL_LOAD_SBYTE_D16 = 34,
> +	GFX10_GLOBAL_LOAD_SBYTE_D16_HI = 35,
> +	GFX10_GLOBAL_LOAD_SHORT_D16 = 36,
> +	GFX10_GLOBAL_LOAD_SHORT_D16_HI = 37,
> +	/* 38-47: reserved */
> +	GFX10_GLOBAL_ATOMIC_SWAP = 48,
> +	GFX10_GLOBAL_ATOMIC_CMPSWAP = 49,
> +	GFX10_GLOBAL_ATOMIC_ADD = 50,
> +	GFX10_GLOBAL_ATOMIC_SUB = 51,
> +	GFX10_GLOBAL_ATOMIC_CSUB = 52,
> +	GFX10_GLOBAL_ATOMIC_SMIN = 53,
> +	GFX10_GLOBAL_ATOMIC_UMIN = 54,
> +	GFX10_GLOBAL_ATOMIC_SMAX = 55,
> +	GFX10_GLOBAL_ATOMIC_UMAX = 56,
> +	GFX10_GLOBAL_ATOMIC_AND = 57,
> +	GFX10_GLOBAL_ATOMIC_OR = 58,
> +	GFX10_GLOBAL_ATOMIC_XOR = 59,
> +	GFX10_GLOBAL_ATOMIC_INC = 60,
> +	GFX10_GLOBAL_ATOMIC_DEC = 61,
> +	GFX10_GLOBAL_ATOMIC_FCMPSWAP = 62,
> +	GFX10_GLOBAL_ATOMIC_FMIN = 63,
> +	GFX10_GLOBAL_ATOMIC_FMAX = 64,
> +	/* 65-79: reserved */
> +	GFX10_GLOBAL_ATOMIC_SWAP_X2 = 80,
> +	GFX10_GLOBAL_ATOMIC_CMPSWAP_X2 = 81,
> +	GFX10_GLOBAL_ATOMIC_ADD_X2 = 82,
> +	GFX10_GLOBAL_ATOMIC_SUB_X2 = 83,
> +	/* 84: reserved */
> +	GFX10_GLOBAL_ATOMIC_SMIN_X2 = 85,
> +	GFX10_GLOBAL_ATOMIC_UMIN_X2 = 86,
> +	GFX10_GLOBAL_ATOMIC_SMAX_X2 = 87,
> +	GFX10_GLOBAL_ATOMIC_UMAX_X2 = 88,
> +	GFX10_GLOBAL_ATOMIC_AND_X2 = 89,
> +	GFX10_GLOBAL_ATOMIC_OR_X2 = 90,
> +	GFX10_GLOBAL_ATOMIC_XOR_X2 = 91,
> +	GFX10_GLOBAL_ATOMIC_INC_X2 = 92,
> +	GFX10_GLOBAL_ATOMIC_DEC_X2 = 93,
> +	GFX10_GLOBAL_ATOMIC_FCMPSWAP_X2 = 94,
> +	GFX10_GLOBAL_ATOMIC_FMIN_X2 = 95,
> +	GFX10_GLOBAL_ATOMIC_FMAX_X2 = 96,
> +};
> +
> +enum amdgcn_gfx10_scratch_opcode {
> +	/* 0-7: reserved */
> +	GFX10_SCRATCH_LOAD_UBYTE = 8,
> +	GFX10_SCRATCH_LOAD_SBYTE = 9,
> +	GFX10_SCRATCH_LOAD_USHORT = 10,
> +	GFX10_SCRATCH_LOAD_SSHORT = 11,
> +	GFX10_SCRATCH_LOAD_DWORD = 12,
> +	GFX10_SCRATCH_LOAD_DWORDX2 = 13,
> +	GFX10_SCRATCH_LOAD_DWORDX4 = 14,
> +	GFX10_SCRATCH_LOAD_DWORDX3 = 15,
> +	/* 16-23: reserved */
> +	GFX10_SCRATCH_STORE_BYTE = 24,
> +	GFX10_SCRATCH_STORE_BYTE_D16_HI = 25,
> +	GFX10_SCRATCH_STORE_SHORT = 26,
> +	GFX10_SCRATCH_STORE_SHORT_D16_HI = 27,
> +	GFX10_SCRATCH_STORE_DWORD = 28,
> +	GFX10_SCRATCH_STORE_DWORDX2 = 29,
> +	GFX10_SCRATCH_STORE_DWORDX4 = 30,
> +	GFX10_SCRATCH_STORE_DWORDX3 = 31,
> +	GFX10_SCRATCH_LOAD_UBYTE_D16 = 32,
> +	GFX10_SCRATCH_LOAD_UBYTE_D16_HI = 33,
> +	GFX10_SCRATCH_LOAD_SBYTE_D16 = 34,
> +	GFX10_SCRATCH_LOAD_SBYTE_D16_HI = 35,
> +	GFX10_SCRATCH_LOAD_SHORT_D16 = 36,
> +	GFX10_SCRATCH_LOAD_SHORT_D16_HI = 37,
> +};
> +
> +/* Export Format */
> +struct amdgcn_gfx10_exp {
> +};
> +
> +union amdgcn_gfx10_insn {
> +	struct amdgcn_gfx10_sop2 sop2;
> +	struct amdgcn_gfx10_sopk sopk;
> +	struct amdgcn_gfx10_sop1 sop1;
> +	struct amdgcn_gfx10_sopc sopc;
> +	struct amdgcn_gfx10_sopp sopp;
> +	struct amdgcn_gfx10_smem smem;
> +	struct amdgcn_gfx10_vop2 vop2;
> +	struct amdgcn_gfx10_vop1 vop1;
> +	struct amdgcn_gfx10_vopc vopc;
> +	struct amdgcn_gfx10_vop3a vop3a;
> +	struct amdgcn_gfx10_vop3b vop3b;
> +	struct amdgcn_gfx10_vop3p vop3p;
> +	struct amdgcn_gfx10_sdwa sdwa;
> +	struct amdgcn_gfx10_sdwab sdwab;
> +	struct amdgcn_gfx10_dpp16 dpp16;
> +	struct amdgcn_gfx10_dpp8 dpp8;
> +	struct amdgcn_gfx10_vintrp vintrp;
> +	struct amdgcn_gfx10_ds ds;
> +	struct amdgcn_gfx10_mtbuf mtbuf;
> +	struct amdgcn_gfx10_mubuf mubuf;
> +	struct amdgcn_gfx10_mimg mimg;
> +	struct amdgcn_gfx10_flat flat;
> +	struct amdgcn_gfx10_exp exp;
> +};
> +
> +/* Cast macro - convert u32 *buf position to GFX10 insn union pointer. */
> +#define I10(buf, n)	((union amdgcn_gfx10_insn *)&(buf)[(n)])
> +
> +inline u32 gfx10_get_param_base(struct amdgcn_param32 param)
> +{
> +	return gfx10_param_base[param.type];
> +}
> +
> +inline u32 emit_gfx10_s_load_dwordx2(union amdgcn_gfx10_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src, int offset)
> +{
> +	/* s_load_dwordx2 <dst/sdata>, <src/sbase>, <offset>
> +	 * sdata: register, load to.
> +	 * sbase: sgpr-pair, load from.
> +	 * offset: offset of kernarg_address in the hsa_kernel_dispatch_packet.
> +	 *
> +	 * sdata = *(sbase + offset);
> +	 * param = (__global struct _knod_bpf_param *)pkt.kernarg_address;
> +	 */
> +
> +	insn->smem.sbase = KNOD_AMDGPU_REG_PAIR(src.v);
> +	insn->smem.sdata = dst.v;
> +	insn->smem.dummy1 = 0;
> +	insn->smem.dlc = 0;
> +	insn->smem.dummy2 = 0;
> +	insn->smem.glc = 0;
> +	insn->smem.dummy3 = 0;
> +	insn->smem.op = GFX10_S_LOAD_DWORDX2;
> +	insn->smem.encoding = GFX10_SMEM_ENCODING;
> +	insn->smem.offset = offset;
> +	insn->smem.dummy4 = 0;
> +	insn->smem.soffset = GFX10_SMEM_SOFFSET_NULL; /* no SGPR offset */
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_bfe_i32(union amdgcn_gfx10_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1,
> +				struct amdgcn_param32 src2)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_BFE_I32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_bfe_u32(union amdgcn_gfx10_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1,
> +				struct amdgcn_param32 src2)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_BFE_U32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_bfi_b32(union amdgcn_gfx10_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1,
> +				struct amdgcn_param32 src2)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_BFI_B32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_lshl_add_u32(union amdgcn_gfx10_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1,
> +				     struct amdgcn_param32 src2)
> +{
> +	/* v_lshl_add_u32 <dst>, <src0>, <src1>, <src2>
> +	 *
> +	 * <dst> = (<src0> << <src1>) + <src2>;
> +	 */
> +
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_LSHL_ADD_U32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_lshl_or_b32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1,
> +				    struct amdgcn_param32 src2)
> +{
> +	/* v_lshl_or_b32 <dst>, <src0>, <src1>, <src2>
> +	 *
> +	 * D.u = (S0.u << S1.u[4:0]) | S2.u
> +	 */
> +
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_LSHL_OR_B32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_mad_u64_u32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param64 vdst,
> +				    struct amdgcn_param32 sdst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1,
> +				    struct amdgcn_param64 src2)
> +{
> +	/* v_mad_u64_u32 <vdst>, <sdst>, <src0_imm>, <src1>, <src2>
> +	 * <vdst>: destination vgpr.
> +	 * <sdst>: destination sgpr.
> +	 * <src0>: source vgpr
> +	 * <src1>: source vgpr
> +	 * <src2>: source vgpr
> +	 *
> +	 * {vcc_out,D.u64} = S0.u32 * S1.u32 + S2.u64.
> +	 * ctx = &param->sub[idx].ctx;
> +	 */
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.hi.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3b.vdst = vdst.lo.v;
> +	insn->vop3b.sdst = sdst.v;
> +	insn->vop3b.clmp = 0;
> +	insn->vop3b.op = GFX10_V_MAD_U64_U32;
> +	insn->vop3b.encoding = GFX10_VOP3B_ENCODING;
> +	insn->vop3b.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3b.src2 = gfx10_get_param_base(src2.lo) + src2.lo.v;
> +	insn->vop3b.omod = 0;
> +	insn->vop3b.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3b.src0 = gfx10_get_param_base(src0);
> +		insn->vop3b.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3b.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_s_mov_b32(union amdgcn_gfx10_insn *insn,
> +				struct amdgcn_param32 dst, struct amdgcn_param32 src)
> +{
> +	if (src.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->sop1.ssrc0 = gfx10_get_param_base(src);
> +		insn->sop1.literal = src.v;
> +	} else {
> +		insn->sop1.ssrc0 = gfx10_get_param_base(src) + src.v;
> +	}
> +	insn->sop1.op = GFX10_S_MOV_B32;
> +	insn->sop1.sdst = gfx10_get_param_base(dst) + dst.v;
> +	insn->sop1.encoding = GFX10_SOP1_ENCODING;
> +
> +	if (src.type == AMDGCN_PARAM_TYPE_LITERAL_CONST)
> +		return 8;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_mov_b32_e32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src)
> +{
> +	if (dst.type != AMDGCN_PARAM_TYPE_VGPR)
> +		WARN_ON_ONCE(1);
> +	insn->vop1.encoding = GFX10_VOP1_ENCODING;
> +	insn->vop1.vdst = dst.v;
> +	insn->vop1.op = GFX10_V_MOV_B32;
> +	if (src.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop1.src0 = GFX10_VOP1_SRC_LITERAL_CONST;
> +		insn->vop1.literal = src.v;
> +
> +		return 8;
> +	}
> +	insn->vop1.src0 = gfx10_get_param_base(src) + src.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_add_co_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop3b.vdst = dst.v;
> +	insn->vop3b.sdst = GFX10_VOP3B_SRC_VCC_LO;
> +	insn->vop3b.clmp = 0;
> +	insn->vop3b.op = GFX10_V_ADD_CO_U32;
> +	insn->vop3b.encoding = GFX10_VOP3B_ENCODING;
> +	insn->vop3b.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3b.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3b.omod = 0;
> +	insn->vop3b.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3b.src0 = gfx10_get_param_base(src0);
> +		insn->vop3b.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3b.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_add_co_ci_u32_e32(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src0,
> +					  struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_ADD_CO_CI_U32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_xor_b32_e32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_XOR_B32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_or_b32_e32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_OR_B32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cndmask_b32_e32(union amdgcn_gfx10_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src0,
> +					struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_CNDMASK_B32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_and_b32_e32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_AND_B32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_sub_co_ci_u32_e32(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src0,
> +					  struct amdgcn_param32 src1)
> +{
> +	/* vdst = src0 - vsrc1 - vcc */
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_SUB_CO_CI_U32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_subrev_co_ci_u32_e32(union amdgcn_gfx10_insn *insn,
> +					     struct amdgcn_param32 dst,
> +					     struct amdgcn_param32 src0,
> +					     struct amdgcn_param32 src1)
> +{
> +	/* vdst = src0 - vsrc1 - vcc */
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_SUBREV_CO_CI_U32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_sub_co_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	/* dst = src0 - src1 */
> +	insn->vop3b.vdst = dst.v;
> +	insn->vop3b.sdst = GFX10_VOP3B_SRC_VCC_LO;
> +	insn->vop3b.clmp = 0;
> +	insn->vop3b.op = GFX10_V_SUB_CO_U32;
> +	insn->vop3b.encoding = GFX10_VOP3B_ENCODING;
> +	insn->vop3b.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3b.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3b.omod = 0;
> +	insn->vop3b.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3b.src0 = gfx10_get_param_base(src0);
> +		insn->vop3b.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3b.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_subrev_co_u32(union amdgcn_gfx10_insn *insn,
> +				      struct amdgcn_param32 dst,
> +				      struct amdgcn_param32 src0,
> +				      struct amdgcn_param32 src1)
> +{
> +	/* dst = src0 - src1 */
> +	insn->vop3b.vdst = dst.v;
> +	insn->vop3b.sdst = GFX10_VOP3B_SRC_VCC_LO;
> +	insn->vop3b.clmp = 0;
> +	insn->vop3b.op = GFX10_V_SUBREV_CO_U32;
> +	insn->vop3b.encoding = GFX10_VOP3B_ENCODING;
> +	insn->vop3b.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3b.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3b.omod = 0;
> +	insn->vop3b.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3b.src0 = gfx10_get_param_base(src0);
> +		insn->vop3b.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3b.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_mul_lo_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_MUL_LO_U32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +/* v_mbcnt_lo_u32_b32 vdst, src0, vsrc1 */
> +inline u32 emit_gfx10_v_mbcnt_lo_u32_b32(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src0,
> +					  struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_MBCNT_LO_U32_B32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +
> +	return 8;
> +}
> +
> +/* v_mbcnt_hi_u32_b32 vdst, src0, vsrc1 */
> +inline u32 emit_gfx10_v_mbcnt_hi_u32_b32(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src0,
> +					  struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_MBCNT_HI_U32_B32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_mul_hi_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_MUL_HI_U32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_lshlrev_b64(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param64 dst,
> +				    struct amdgcn_param64 src0,
> +				    struct amdgcn_param64 src1)
> +{
> +	/* dst = s1 << s0 */
> +	insn->vop3a.vdst = dst.lo.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_LSHLREV_B64;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1.lo) + src1.lo.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0.lo);
> +		insn->vop3a.literal = src0.lo.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0.lo) + src0.lo.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_lshrrev_b64(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param64 dst,
> +				    struct amdgcn_param64 src0,
> +				    struct amdgcn_param64 src1)
> +{
> +	/* dst = s1 >> s0 */
> +	insn->vop3a.vdst = dst.lo.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_LSHRREV_B64;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1.lo) + src1.lo.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0.lo);
> +		insn->vop3a.literal = src0.lo.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0.lo) + src0.lo.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_lshlrev_b32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	/* dst = s1 << s0 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_LSHLREV_B32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_lshrrev_b32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	/* dst = s1 << s0 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_LSHRREV_B32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_add_nc_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_ADD_NC_U32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_sub_nc_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_SUB_NC_U32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_ashrrev_i64(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param64 dst,
> +				    struct amdgcn_param64 src0,
> +				    struct amdgcn_param64 src1)
> +{
> +	/* dst = s1 >> s0 */
> +	insn->vop3a.vdst = dst.lo.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_ASHRREV_I64;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1.lo) + src1.lo.v;
> +	insn->vop3a.src2 = GFX10_VOP3_UNUSED_SRC;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0.lo);
> +		insn->vop3a.literal = src0.lo.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0.lo) + src0.lo.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_ashrrev_i32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	/* dst = s1 >> s0 (arithmetic) */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_ASHRREV_I32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_alignbit_b32(union amdgcn_gfx10_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1,
> +				     struct amdgcn_param32 src2)
> +{
> +	/* dst = s1 >> s0 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_ALIGNBIT_B32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx10_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_eq_u64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 == S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_EQ_U64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_eq_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 == S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_EQ_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_gt_u64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 > S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_GT_U64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_gt_i64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 > S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_GT_I64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_ge_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 >= S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_GE_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_gt_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 > S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_GT_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_lt_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 < S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_LT_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_le_u32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 <= S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_LE_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_gt_i32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 > S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_GT_I32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_ge_i32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 >= S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_GE_I32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_lt_i32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 < S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_LT_I32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_le_i32(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 <= S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMP_LE_I32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmpx_lt_u32(union amdgcn_gfx10_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src)
> +{
> +	/* EXEC &= (S0 < S1) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX10_V_CMPX_LT_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_ge_u64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 >= S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_GE_U64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_ge_i64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 >= S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_GE_I64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_lt_u64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 < S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_LT_U64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_lt_i64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 < S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_LT_I64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_le_u64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 <= S1 */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_LE_U64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_v_cmp_le_i64(union amdgcn_gfx10_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 <= S1 (signed) */
> +	insn->vopc.src0 = gfx10_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX10_V_CMP_LE_I64;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_buffer_load_ubyte(union amdgcn_gfx10_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src,
> +					short off)
> +{
> +	/* buffer_load_ubyte <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dlc = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.op = GFX10_BUFFER_LOAD_UBYTE;
> +	insn->mubuf.opm = 0;
> +	insn->mubuf.encoding = GFX10_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.slc = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX10_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_buffer_load_ushort(union amdgcn_gfx10_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src,
> +					 short off)
> +{
> +	/* buffer_load_ushort <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dlc = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.op = GFX10_BUFFER_LOAD_USHORT;
> +	insn->mubuf.opm = 0;
> +	insn->mubuf.encoding = GFX10_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.slc = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX10_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_buffer_load_dword(union amdgcn_gfx10_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src,
> +					short off)
> +{
> +	/* buffer_load_dword <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dlc = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.op = GFX10_BUFFER_LOAD_DWORD;
> +	insn->mubuf.opm = 0;
> +	insn->mubuf.encoding = GFX10_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.slc = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX10_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_buffer_load_dwordx2(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src,
> +					  short off)
> +{
> +	/* buffer_load_dwordx2 <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dlc = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.op = GFX10_BUFFER_LOAD_DWORDX2;
> +	insn->mubuf.opm = 0;
> +	insn->mubuf.encoding = GFX10_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.slc = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX10_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_buffer_load_dwordx4(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src,
> +					  short off)
> +{
> +	/* buffer_load_dwordx4 <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dlc = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.op = GFX10_BUFFER_LOAD_DWORDX4;
> +	insn->mubuf.opm = 0;
> +	insn->mubuf.encoding = GFX10_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.slc = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX10_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_load_ubyte(union amdgcn_gfx10_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src,
> +					short off)
> +{
> +	/* global_load_ubyte <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_UBYTE;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_load_ushort(union amdgcn_gfx10_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src,
> +					 short off)
> +{
> +	/* global_load_ushort <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_USHORT;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_load_dword(union amdgcn_gfx10_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src,
> +					short off)
> +{
> +	/* global_load_dword <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_DWORD;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_load_dwordx2(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src,
> +					  short off)
> +{
> +	/* global_load_dwordx2 <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_DWORDX2;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_load_dwordx4(union amdgcn_gfx10_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src,
> +					  short off)
> +{
> +	/* global_load_dwordx4 <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_DWORDX4;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_store_byte(union amdgcn_gfx10_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_byte <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX10_GLOBAL_STORE_BYTE;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_store_short(union amdgcn_gfx10_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_short <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX10_GLOBAL_STORE_SHORT;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_store_dword(union amdgcn_gfx10_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_dword <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX10_GLOBAL_STORE_DWORD;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +/* global_atomic_add vdst, addr, data, off  (GLC=1: return old value)
> + * old_val = *(u32 *)(addr + off); *(u32 *)(addr + off) += data; vdst = old_val
> + */
> +/* GFX10 global atomic: opcode only differs, all else identical */
> +#define DEFINE_GFX10_GLOBAL_ATOMIC(name, opcode)			 \
> +inline u32 emit_gfx10_global_atomic_##name(union amdgcn_gfx10_insn *insn,\
> +					    struct amdgcn_param32 vdst,	 \
> +					    struct amdgcn_param32 addr,	 \
> +					    struct amdgcn_param32 data,	 \
> +					    int off, int glc)		 \
> +{									 \
> +	insn->flat.offset = off;					 \
> +	insn->flat.dlc = 0;						 \
> +	insn->flat.lds = 0;						 \
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;				 \
> +	insn->flat.glc = glc;						 \
> +	insn->flat.slc = 0;						 \
> +	insn->flat.op = (opcode);					 \
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;			 \
> +	insn->flat.addr = addr.v;					 \
> +	insn->flat.data = data.v;					 \
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;			 \
> +	insn->flat.dummy1 = 0;						 \
> +	insn->flat.dummy2 = 0;						 \
> +	insn->flat.vdst = vdst.v;					 \
> +	return 8;							 \
> +}
> +
> +DEFINE_GFX10_GLOBAL_ATOMIC(add, GFX10_GLOBAL_ATOMIC_ADD)
> +DEFINE_GFX10_GLOBAL_ATOMIC(and, GFX10_GLOBAL_ATOMIC_AND)
> +DEFINE_GFX10_GLOBAL_ATOMIC(or, GFX10_GLOBAL_ATOMIC_OR)
> +DEFINE_GFX10_GLOBAL_ATOMIC(xor, GFX10_GLOBAL_ATOMIC_XOR)
> +DEFINE_GFX10_GLOBAL_ATOMIC(swap, GFX10_GLOBAL_ATOMIC_SWAP)
> +DEFINE_GFX10_GLOBAL_ATOMIC(cmpswap, GFX10_GLOBAL_ATOMIC_CMPSWAP)
> +DEFINE_GFX10_GLOBAL_ATOMIC(add_x2, GFX10_GLOBAL_ATOMIC_ADD_X2)
> +DEFINE_GFX10_GLOBAL_ATOMIC(and_x2, GFX10_GLOBAL_ATOMIC_AND_X2)
> +DEFINE_GFX10_GLOBAL_ATOMIC(or_x2, GFX10_GLOBAL_ATOMIC_OR_X2)
> +DEFINE_GFX10_GLOBAL_ATOMIC(xor_x2, GFX10_GLOBAL_ATOMIC_XOR_X2)
> +DEFINE_GFX10_GLOBAL_ATOMIC(swap_x2, GFX10_GLOBAL_ATOMIC_SWAP_X2)
> +DEFINE_GFX10_GLOBAL_ATOMIC(cmpswap_x2, GFX10_GLOBAL_ATOMIC_CMPSWAP_X2)
> +
> +inline u32 emit_gfx10_global_store_dwordx2(union amdgcn_gfx10_insn *insn,
> +					   struct amdgcn_param32 dst,
> +					   struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_dwordx2 <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX10_GLOBAL_STORE_DWORDX2;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_store_dwordx4(union amdgcn_gfx10_insn *insn,
> +					   struct amdgcn_param32 dst,
> +					   struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_dwordx4 <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX10_GLOBAL_STORE_DWORDX4;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX10_FLAT_SADDR_DISABLE;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_s_branch(union amdgcn_gfx10_insn *insn,
> +			       short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_BRANCH;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_cbranch_vccz(union amdgcn_gfx10_insn *insn,
> +				     short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_CBRANCH_VCCZ;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_cbranch_vccnz(union amdgcn_gfx10_insn *insn,
> +				      short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_CBRANCH_VCCNZ;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_branch_fixup(union amdgcn_gfx10_insn *insn,
> +				   short off)
> +{
> +	WARN_ON(insn->sopp.op != GFX10_S_BRANCH &&
> +		insn->sopp.op != GFX10_S_CBRANCH_VCCZ &&
> +		insn->sopp.op != GFX10_S_CBRANCH_VCCNZ &&
> +		insn->sopp.op != GFX10_S_CBRANCH_EXECZ &&
> +		insn->sopp.op != GFX10_S_CBRANCH_EXECNZ);
> +	insn->sopp.simm16 = off;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_waitcnt_lgkmcnt(union amdgcn_gfx10_insn *insn)
> +{
> +	struct amdgcn_gfx10_sopp_vmcnt vmcnt;
> +	u16 simm16;
> +	/* s_waitcnt lgkmcnt (0)
> +	 * wait for memory
> +	 */
> +	vmcnt.vmcnt1 = -1;
> +	vmcnt.vmcnt2 = -1;
> +	vmcnt.expcnt = -1;
> +	vmcnt.dummy = 0;
> +	vmcnt.lgkmcnt = 0;
> +	memcpy(&simm16, &vmcnt, sizeof(u16));
> +	insn->sopp.simm16 = simm16;
> +	insn->sopp.op = GFX10_S_WAITCNT;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_waitcnt_vmcnt(union amdgcn_gfx10_insn *insn)
> +{
> +	struct amdgcn_gfx10_sopp_vmcnt vmcnt;
> +	u16 simm16;
> +	/* s_waitcnt lgkmcnt (0)
> +	 * wait for memory
> +	 */
> +	vmcnt.vmcnt1 = 0;
> +	vmcnt.vmcnt2 = 0;
> +	vmcnt.expcnt = -1;
> +	vmcnt.dummy = 0;
> +	vmcnt.lgkmcnt = -1;
> +	memcpy(&simm16, &vmcnt, sizeof(u16));
> +	insn->sopp.simm16 = simm16;
> +	insn->sopp.op = GFX10_S_WAITCNT;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_waitcnt_vmcnt_lgkmcnt(union amdgcn_gfx10_insn *insn)
> +{
> +	struct amdgcn_gfx10_sopp_vmcnt vmcnt;
> +	u16 simm16;
> +	/* s_waitcnt lgkmcnt (0)
> +	 * wait for memory
> +	 */
> +	vmcnt.vmcnt1 = 0;
> +	vmcnt.vmcnt2 = 0;
> +	vmcnt.expcnt = -1;
> +	vmcnt.dummy = 0;
> +	vmcnt.lgkmcnt = 0;
> +	memcpy(&simm16, &vmcnt, sizeof(u16));
> +	insn->sopp.simm16 = simm16;
> +	insn->sopp.op = GFX10_S_WAITCNT;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_nop(union amdgcn_gfx10_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX10_S_NOP;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_endpgm(union amdgcn_gfx10_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX10_S_ENDPGM;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_code_end(union amdgcn_gfx10_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX10_S_CODE_END;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_icache_inv(union amdgcn_gfx10_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX10_S_ICACHE_INV;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* Structurized CFG instructions.
> + * These use raw SGPR indices for 64-bit pair operations involving
> + * EXEC (126) and VCC (106) special registers.
> + */
> +
> +/* s_and_saveexec_b64 s[sdst:sdst+1], s[ssrc:ssrc+1]
> + * sdst = EXEC; EXEC &= ssrc; SCC = (EXEC != 0)
> + */
> +inline u32 emit_gfx10_s_and_saveexec_b64(union amdgcn_gfx10_insn *insn,
> +					  u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX10_S_AND_SAVEEXEC_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX10_SOP1_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_bcnt1_i32_b64 sdst, s[ssrc:ssrc+1]
> + * sdst = popcount(ssrc). SCC = (sdst != 0)
> + */
> +inline u32 emit_gfx10_s_bcnt1_i32_b64(union amdgcn_gfx10_insn *insn,
> +				       u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX10_S_BCNT1_I32_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX10_SOP1_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_mov_b64 s[sdst:sdst+1], s[ssrc:ssrc+1] (or special src like 0) */
> +inline u32 emit_gfx10_s_mov_b64(union amdgcn_gfx10_insn *insn,
> +				 u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX10_S_MOV_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX10_SOP1_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_and_b64 s[sdst:sdst+1], s[ssrc0:ssrc0+1], s[ssrc1:ssrc1+1] */
> +inline u32 emit_gfx10_s_and_b64(union amdgcn_gfx10_insn *insn,
> +				 u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX10_S_AND_B64;
> +	insn->sop2.encoding = GFX10_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_or_b64 s[sdst:sdst+1], s[ssrc0:ssrc0+1], s[ssrc1:ssrc1+1] */
> +inline u32 emit_gfx10_s_or_b64(union amdgcn_gfx10_insn *insn,
> +				u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX10_S_OR_B64;
> +	insn->sop2.encoding = GFX10_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_andn2_b64 s[sdst:sdst+1], s[ssrc0:ssrc0+1], s[ssrc1:ssrc1+1]
> + * sdst = ssrc0 & ~ssrc1
> + */
> +inline u32 emit_gfx10_s_andn2_b64(union amdgcn_gfx10_insn *insn,
> +				   u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX10_S_ANDN2_B64;
> +	insn->sop2.encoding = GFX10_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_cbranch_execz off - branch if EXEC == 0 */
> +inline u32 emit_gfx10_s_cbranch_execz(union amdgcn_gfx10_insn *insn,
> +				       short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_CBRANCH_EXECZ;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_cbranch_execnz off - branch if EXEC != 0 */
> +inline u32 emit_gfx10_s_cbranch_execnz(union amdgcn_gfx10_insn *insn,
> +					short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_CBRANCH_EXECNZ;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_sub_u32 sdst, ssrc0, ssrc1 - sdst = ssrc0 - ssrc1; SCC = borrow */
> +inline u32 emit_gfx10_s_sub_u32(union amdgcn_gfx10_insn *insn,
> +				 u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX10_S_SUB_U32;
> +	insn->sop2.encoding = GFX10_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_cbranch_scc0 off - branch if SCC == 0 (no borrow) */
> +inline u32 emit_gfx10_s_cbranch_scc0(union amdgcn_gfx10_insn *insn,
> +				      short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_CBRANCH_SCC0;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +static inline void __emit_gfx10_sop2(union amdgcn_gfx10_insn *insn,
> +				      int op, int sdst, int ssrc0, int ssrc1)
> +{
> +	insn->sop2.encoding = GFX10_SOP2_ENCODING;
> +	insn->sop2.op = op;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +}
> +
> +static inline void __emit_gfx10_sop1(union amdgcn_gfx10_insn *insn,
> +				      int op, int sdst, int ssrc0)
> +{
> +	insn->sop1.encoding = GFX10_SOP1_ENCODING;
> +	insn->sop1.op = op;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.ssrc0 = ssrc0;
> +}
> +
> +static inline void __emit_gfx10_sopp(union amdgcn_gfx10_insn *insn,
> +				      int op, u16 simm16)
> +{
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +	insn->sopp.op = op;
> +	insn->sopp.simm16 = simm16;
> +}
> +
> +static inline void __emit_gfx10_vop2(union amdgcn_gfx10_insn *insn,
> +				      int op, int vdst, int vsrc1, int src0)
> +{
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	insn->vop2.op = op;
> +	insn->vop2.vdst = vdst;
> +	insn->vop2.vsrc1 = vsrc1;
> +	insn->vop2.src0 = src0;
> +}
> +
> +static inline void __emit_gfx10_smem(union amdgcn_gfx10_insn *insn,
> +				      int op, int sdata, int sbase_pair,
> +				      u32 offset)
> +{
> +	insn->smem.encoding = GFX10_SMEM_ENCODING;
> +	insn->smem.op = op;
> +	insn->smem.sdata = sdata;
> +	insn->smem.sbase = sbase_pair;
> +	insn->smem.offset = offset;
> +	insn->smem.soffset = GFX10_SRC_NULL;
> +}
> +
> +static inline void __emit_gfx10_ds(union amdgcn_gfx10_insn *insn,
> +				    int op, int addr, int data0, int vdst,
> +				    int off0, int off1)
> +{
> +	insn->ds.encoding = GFX10_DS_ENCODING;
> +	insn->ds.op = op;
> +	insn->ds.gds = GFX10_DS_LDS;
> +	insn->ds.addr = addr;
> +	insn->ds.data0 = data0;
> +	insn->ds.vdst = vdst;
> +	insn->ds.offset0 = off0;
> +	insn->ds.offset1 = off1;
> +}
> +
> +static inline void __emit_gfx10_global(union amdgcn_gfx10_insn *insn,
> +					int op, int vdst, int vaddr,
> +					int vdata, int saddr, int offset)
> +{
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.op = op;
> +	insn->flat.vdst = vdst;
> +	insn->flat.addr = vaddr;
> +	insn->flat.data = vdata;
> +	insn->flat.saddr = saddr;
> +	insn->flat.offset = offset;
> +}
> +
> +/* ======================================================================
> + * GFX10 Param-Aware Emit Functions
> + *
> + * Paired with GFX9 equivalents in knod_gfx9_insn.h.  Used by shader
> + * emitters (aesgcm_shader.h, ipsec_fused_gfx10.h, ...) that construct
> + * operands via P_S/P_V/P_I/P_L helpers.
> + * ======================================================================
> + */
> +
> +static inline int __p2e10(struct amdgcn_param32 p)
> +{
> +	if (p.type == AMDGCN_PARAM_TYPE_LITERAL_CONST)
> +		return gfx10_get_param_base(p);
> +	return gfx10_get_param_base(p) + p.v;
> +}
> +
> +/* --- GFX10 SOP2 (param32) --- */
> +
> +#define DEFINE_GFX10_SOP2_P(name, opcode)				\
> +inline u32 emit_gfx10_##name(union amdgcn_gfx10_insn *insn,		\
> +			      struct amdgcn_param32 dst,		\
> +			      struct amdgcn_param32 src0,		\
> +			      struct amdgcn_param32 src1)		\
> +{									\
> +	insn->sop2.sdst = __p2e10(dst);				\
> +	insn->sop2.ssrc0 = __p2e10(src0);				\
> +	insn->sop2.ssrc1 = __p2e10(src1);				\
> +	insn->sop2.op = opcode;					\
> +	insn->sop2.encoding = GFX10_SOP2_ENCODING;			\
> +	if (knod_param_is_literal(src0)) {			\
> +		insn->sop2.literal = src0.v;				\
> +		return 8;						\
> +	}								\
> +	if (knod_param_is_literal(src1)) {			\
> +		insn->sop2.literal = src1.v;				\
> +		return 8;						\
> +	}								\
> +	return 4;							\
> +}
> +
> +DEFINE_GFX10_SOP2_P(s_add_u32,   GFX10_S_ADD_U32)
> +DEFINE_GFX10_SOP2_P(s_sub_u32_p, GFX10_S_SUB_U32)
> +DEFINE_GFX10_SOP2_P(s_addc_u32,  GFX10_S_ADDC_U32)
> +DEFINE_GFX10_SOP2_P(s_subb_u32,  GFX10_S_SUBB_U32)
> +DEFINE_GFX10_SOP2_P(s_and_b32_p, GFX10_S_AND_B32)
> +DEFINE_GFX10_SOP2_P(s_lshl_b32,  GFX10_S_LSHL_B32)
> +DEFINE_GFX10_SOP2_P(s_lshr_b32,  GFX10_S_LSHR_B32)
> +DEFINE_GFX10_SOP2_P(s_mul_i32,   GFX10_S_MUL_I32)
> +DEFINE_GFX10_SOP2_P(s_xor_b32,   GFX10_S_XOR_B32)
> +
> +#undef DEFINE_GFX10_SOP2_P
> +
> +/* --- GFX10 SOPC (param32) --- */
> +
> +#define DEFINE_GFX10_SOPC_P(name, opcode)				\
> +inline u32 emit_gfx10_##name(union amdgcn_gfx10_insn *insn,		\
> +			      struct amdgcn_param32 src0,		\
> +			      struct amdgcn_param32 src1)		\
> +{									\
> +	insn->sopc.ssrc0 = __p2e10(src0);				\
> +	insn->sopc.ssrc1 = __p2e10(src1);				\
> +	insn->sopc.op = opcode;					\
> +	insn->sopc.encoding = GFX10_SOPC_ENCODING;			\
> +	if (knod_param_is_literal(src0)) {			\
> +		insn->sopc.literal = src0.v;				\
> +		return 8;						\
> +	}								\
> +	if (knod_param_is_literal(src1)) {			\
> +		insn->sopc.literal = src1.v;				\
> +		return 8;						\
> +	}								\
> +	return 4;							\
> +}
> +
> +DEFINE_GFX10_SOPC_P(s_cmp_eq_u32, GFX10_S_CMP_EQ_U32)
> +DEFINE_GFX10_SOPC_P(s_cmp_lg_u32, GFX10_S_CMP_LG_U32)
> +DEFINE_GFX10_SOPC_P(s_cmp_ge_u32, GFX10_S_CMP_GE_U32)
> +DEFINE_GFX10_SOPC_P(s_cmp_lt_u32, GFX10_S_CMP_LT_U32)
> +
> +#undef DEFINE_GFX10_SOPC_P
> +
> +/* --- GFX10 SOPP --- */
> +
> +inline u32 emit_gfx10_s_barrier(union amdgcn_gfx10_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX10_S_BARRIER;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx10_s_cbranch_scc1(union amdgcn_gfx10_insn *insn,
> +				      short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX10_S_CBRANCH_SCC1;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +	return 4;
> +}
> +
> +/*
> + * GFX10 s_waitcnt encoding:
> + *   simm16[3:0]   = vmcnt[3:0]
> + *   simm16[7:4]   = expcnt (set to 7 = unused)
> + *   simm16[13:8]  = lgkmcnt[5:0]
> + *   simm16[15:14] = vmcnt[5:4]
> + */
> +#define GFX10_WAITCNT(vm, lgkm) \
> +	(((((vm) >> 4) & 0x3) << 14) | (((lgkm) & 0x3F) << 8) | \
> +	 (7 << 4) | ((vm) & 0xF))
> +
> +inline u32 emit_gfx10_s_waitcnt(union amdgcn_gfx10_insn *insn,
> +				 int vm, int lgkm)
> +{
> +	insn->sopp.simm16 = GFX10_WAITCNT(vm, lgkm);
> +	insn->sopp.op = GFX10_S_WAITCNT;
> +	insn->sopp.encoding = GFX10_SOPP_ENCODING;
> +	return 4;
> +}
> +
> +/* --- GFX10 SOP1 --- */
> +
> +inline u32 emit_gfx10_s_not_b64(union amdgcn_gfx10_insn *insn,
> +				 u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX10_S_NOT_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX10_SOP1_ENCODING;
> +	return 4;
> +}
> +
> +/* --- GFX10 VOPC (v_cmp_ne_u32 param variant) --- */
> +
> +inline u32 emit_gfx10_v_cmp_ne_u32(union amdgcn_gfx10_insn *insn,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1)
> +{
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vopc.vsrc1 = src1.v;
> +	insn->vopc.op = GFX10_V_CMP_NE_U32;
> +	insn->vopc.encoding = GFX10_VOPC_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vopc.src0 = gfx10_get_param_base(src0);
> +		insn->vopc.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vopc.src0 = gfx10_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +/* --- GFX10 SMEM --- */
> +
> +#define DEFINE_GFX10_SMEM_P(name, opcode)				\
> +inline u32 emit_gfx10_##name(union amdgcn_gfx10_insn *insn,		\
> +			      struct amdgcn_param32 dst,		\
> +			      struct amdgcn_param32 src, int offset)	\
> +{									\
> +	insn->smem.sdata = dst.v;					\
> +	insn->smem.sbase = src.v / 2;					\
> +	insn->smem.op = opcode;					\
> +	insn->smem.offset = offset;					\
> +	insn->smem.soffset = GFX10_SRC_NULL;				\
> +	insn->smem.encoding = GFX10_SMEM_ENCODING;			\
> +	return 8;							\
> +}
> +
> +DEFINE_GFX10_SMEM_P(s_load_dword,   GFX10_S_LOAD_DWORD)
> +DEFINE_GFX10_SMEM_P(s_load_dwordx4, GFX10_S_LOAD_DWORDX4)
> +
> +#undef DEFINE_GFX10_SMEM_P
> +
> +/* s_dcache_inv - no operands */
> +inline u32 emit_gfx10_s_dcache_inv(union amdgcn_gfx10_insn *insn)
> +{
> +	insn->smem.sdata = 0;
> +	insn->smem.sbase = 0;
> +	insn->smem.op = GFX10_S_DCACHE_INV;
> +	insn->smem.offset = 0;
> +	insn->smem.soffset = GFX10_SRC_NULL;
> +	insn->smem.encoding = GFX10_SMEM_ENCODING;
> +	return 8;
> +}
> +
> +/* --- GFX10 VOP1: v_readfirstlane_b32 --- */
> +
> +inline u32 emit_gfx10_v_readfirstlane_b32(union amdgcn_gfx10_insn *insn,
> +					   u8 sdst, u8 vsrc)
> +{
> +	insn->vop1.encoding = GFX10_VOP1_ENCODING;
> +	insn->vop1.vdst = sdst;
> +	insn->vop1.op = GFX10_V_READFIRSTLANE_B32;
> +	insn->vop1.src0 = GFX10_SRC_VGPR_BASE + vsrc;
> +	return 4;
> +}
> +
> +/* --- GFX10 VOP2: v_max_i32 --- */
> +
> +inline u32 emit_gfx10_v_max_i32(union amdgcn_gfx10_insn *insn,
> +				 struct amdgcn_param32 dst,
> +				 struct amdgcn_param32 src0,
> +				 struct amdgcn_param32 src1)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX10_V_MAX_I32;
> +	insn->vop2.encoding = GFX10_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx10_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx10_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +/* --- GFX10 VOP3A: v_perm_b32 --- */
> +
> +inline u32 emit_gfx10_v_perm_b32(union amdgcn_gfx10_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1,
> +				  struct amdgcn_param32 src2)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	/* VOP3 does not support literal constants on GFX10 */
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX10_V_PERM_B32;
> +	insn->vop3a.encoding = GFX10_VOP3A_ENCODING;
> +	insn->vop3a.src0 = gfx10_get_param_base(src0) + src0.v;
> +	insn->vop3a.src1 = gfx10_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx10_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +
> +	return 8;
> +}
> +
> +/* --- GFX10 DS --- */
> +
> +inline u32 emit_gfx10_ds_write_b32(union amdgcn_gfx10_insn *insn,
> +				     int addr, int data0)
> +{
> +	__emit_gfx10_ds(insn, GFX10_DS_WRITE_B32, addr, data0, 0, 0, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_ds_read_b32(union amdgcn_gfx10_insn *insn,
> +				    int vdst, int addr)
> +{
> +	__emit_gfx10_ds(insn, GFX10_DS_READ_B32, addr, 0, vdst, 0, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_ds_write_b32_off(union amdgcn_gfx10_insn *insn,
> +					 int addr, int data0, int offset)
> +{
> +	__emit_gfx10_ds(insn, GFX10_DS_WRITE_B32, addr, data0, 0, offset, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_ds_read_b32_off(union amdgcn_gfx10_insn *insn,
> +					int vdst, int addr, int offset)
> +{
> +	__emit_gfx10_ds(insn, GFX10_DS_READ_B32, addr, 0, vdst, offset, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_ds_write_b128(union amdgcn_gfx10_insn *insn,
> +				     int addr, int data0)
> +{
> +	__emit_gfx10_ds(insn, GFX10_DS_WRITE_B128, addr, data0, 0, 0, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_ds_read_b128(union amdgcn_gfx10_insn *insn,
> +				    int vdst, int addr)
> +{
> +	__emit_gfx10_ds(insn, GFX10_DS_READ_B128, addr, 0, vdst, 0, 0);
> +	return 8;
> +}
> +
> +/* --- GFX10 GLOBAL with saddr mode (scalar base + VGPR offset) --- */
> +
> +inline u32 emit_gfx10_global_load_dword_saddr(union amdgcn_gfx10_insn *insn,
> +						int vdst, int vaddr,
> +						int saddr, short off)
> +{
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_DWORD;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = vaddr;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = saddr / 2;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = vdst;
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_load_dwordx4_saddr(union amdgcn_gfx10_insn *insn,
> +						  int vdst, int vaddr,
> +						  int saddr, short off)
> +{
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX10_GLOBAL_LOAD_DWORDX4;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = vaddr;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = saddr / 2;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = vdst;
> +	return 8;
> +}
> +
> +inline u32 emit_gfx10_global_store_dwordx4_saddr(union amdgcn_gfx10_insn *insn,
> +						   int vaddr, int vdata,
> +						   int saddr, short off)
> +{
> +	insn->flat.offset = off;
> +	insn->flat.dlc = 0;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX10_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX10_GLOBAL_STORE_DWORDX4;
> +	insn->flat.encoding = GFX10_FLAT_ENCODING;
> +	insn->flat.addr = vaddr;
> +	insn->flat.data = vdata;
> +	insn->flat.saddr = saddr / 2;
> +	insn->flat.dummy1 = 0;
> +	insn->flat.dummy2 = 0;
> +	insn->flat.vdst = 0;
> +	return 8;
> +}
> +
> +#endif
> diff --git a/drivers/gpu/drm/amd/amdkfd/knod/knod_gfx9_insn.h b/drivers/gpu/drm/amd/amdkfd/knod/knod_gfx9_insn.h
> new file mode 100644
> index 000000000000..ea987188f982
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/amdkfd/knod/knod_gfx9_insn.h
> @@ -0,0 +1,4068 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
> + * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
> + */
> +
> +#ifndef KFD_AMDGPU_GFX9_INSN_H_INCLUDED
> +#define KFD_AMDGPU_GFX9_INSN_H_INCLUDED
> +
> +#include "knod_amdgpu.h"
> +
> +/*
> + * knod_amdgpu_insn.h is intentionally NOT included here.
> + * This file provides ISA definitions (structs, enums, encoding constants)
> + * and per-version emit functions that are self-contained.
> + *
> + * The version-dispatch layer (knod_amdgpu_insn.h) includes this file
> + * and adds struct amdgcn_insn + wrapper functions on top.
> + */
> +
> +#define GFX9_SRC_SGPR_BASE		0
> +#define GFX9_SRC_VCC_LO			106
> +#define GFX9_SRC_VCC_HI			107
> +#define GFX9_SRC_TTPM_BASE		108
> +#define GFX9_SRC_M0			124
> +#define GFX9_SRC_NULL			125
> +#define GFX9_SRC_EXEC_LO		126
> +#define GFX9_SRC_EXEC_HI		127
> +#define GFX9_SRC_INTEGER_0		128
> +#define GFX9_SRC_INTEGER_MINUS_1	193
> +#define GFX9_SRC_SHARED_BASE		235
> +#define GFX9_SRC_SHARED_LIMIT		236
> +#define GFX9_SRC_PRIVATE_BASE		237
> +#define GFX9_SRC_PRIVATE_LIMIT		238
> +#define GFX9_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_SRC_SDWA			249
> +#define GFX9_SRC_DDP16			250
> +#define GFX9_SRC_VCCZ			251
> +#define GFX9_SRC_EXECZ			252
> +#define GFX9_SRC_SCC			253
> +#define GFX9_SRC_LITERAL_CONST		255
> +#define GFX9_SRC_VGPR_BASE		256
> +
> +static int gfx9_param_base[__AMDGCN_PARAM_TYPE_MAX] = {
> +	GFX9_SRC_SGPR_BASE,
> +	GFX9_SRC_VCC_LO,
> +	GFX9_SRC_VCC_HI,
> +	GFX9_SRC_TTPM_BASE,
> +	GFX9_SRC_M0,
> +	GFX9_SRC_NULL,
> +	GFX9_SRC_EXEC_LO,
> +	GFX9_SRC_EXEC_HI,
> +	GFX9_SRC_INTEGER_0,
> +	GFX9_SRC_INTEGER_MINUS_1,
> +	GFX9_SRC_SHARED_BASE,
> +	GFX9_SRC_SHARED_LIMIT,
> +	GFX9_SRC_PRIVATE_BASE,
> +	GFX9_SRC_PRIVATE_LIMIT,
> +	GFX9_SRC_POPS_EXITING_WAVE_ID,
> +	GFX9_SRC_SDWA,
> +	GFX9_SRC_DDP16,
> +	GFX9_SRC_VCCZ,
> +	GFX9_SRC_EXECZ,
> +	GFX9_SRC_SCC,
> +	GFX9_SRC_LITERAL_CONST,
> +	GFX9_SRC_VGPR_BASE,
> +};
> +
> +/* Scalar ALU and Control Format */
> +struct amdgcn_gfx9_sop2 {
> +	u32 ssrc0:8;
> +	u32 ssrc1:8;
> +	u32 sdst:7;
> +	u32 op:7;
> +	u32 encoding:2;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_sop2_opcode {
> +	GFX9_S_ADD_U32,
> +	GFX9_S_SUB_U32,
> +	GFX9_S_ADD_I32,
> +	GFX9_S_SUB_I32,
> +	GFX9_S_ADDC_U32,
> +	GFX9_S_SUBB_U32,
> +	GFX9_S_MIN_I32,
> +	GFX9_S_MIN_U32,
> +	GFX9_S_MAX_I32,
> +	GFX9_S_MAX_U32,
> +	GFX9_S_CSELECT_B32,
> +	GFX9_S_CSELECT_B64,
> +	GFX9_S_AND_B32,
> +	GFX9_S_AND_B64,
> +	GFX9_S_OR_B32,
> +	GFX9_S_OR_B64,
> +	GFX9_S_XOR_B32,
> +	GFX9_S_XOR_B64,
> +	GFX9_S_ANDN2_B32,
> +	GFX9_S_ANDN2_B64,
> +	GFX9_S_ORN2_B32,
> +	GFX9_S_ORN2_B64,
> +	GFX9_S_NAND_B32,
> +	GFX9_S_NAND_B64,
> +	GFX9_S_NOR_B32,
> +	GFX9_S_NOR_B64,
> +	GFX9_S_XNOR_B32,
> +	GFX9_S_XNOR_B64,
> +	GFX9_S_LSHL_B32,
> +	GFX9_S_LSHL_B64,
> +	GFX9_S_LSHR_B32,
> +	GFX9_S_LSHR_B64,
> +	GFX9_S_ASHR_I32,
> +	GFX9_S_ASHR_I64,
> +	GFX9_S_BFM_B32,
> +	GFX9_S_BFM_B64,
> +	GFX9_S_MUL_I32,
> +	GFX9_S_BFE_U32,
> +	GFX9_S_BFE_I32,
> +	GFX9_S_BFE_U64,
> +	GFX9_S_BFE_I64,
> +	GFX9_S_CBRANCH_G_FORK,
> +	GFX9_S_ABSDIFF_I32,
> +	GFX9_S_RFE_RESTORE_B64,
> +	GFX9_S_MUL_HI_U32,
> +	GFX9_S_MUL_HI_I32,
> +	GFX9_S_LSHL1_ADD_U32,
> +	GFX9_S_LSHL2_ADD_U32,
> +	GFX9_S_LSHL3_ADD_U32,
> +	GFX9_S_LSHL4_ADD_U32,
> +	GFX9_S_PACK_LL_B32_B16,
> +	GFX9_S_PACK_LH_B32_B16,
> +	GFX9_S_PACK_HH_B32_B16,
> +};
> +
> +#define GFX9_SOP2_ENCODING			0x2
> +#define GFX9_SOP2_SSRC_SGPR_BASE		0
> +#define GFX9_SOP2_SSRC_VCC_LO			106
> +#define GFX9_SOP2_SSRC_VCC_HI			107
> +#define GFX9_SOP2_SSRC_TTPM_BASE		108
> +#define GFX9_SOP2_SSRC_M0			124
> +#define GFX9_SOP2_SSRC_NULL			125
> +#define GFX9_SOP2_SSRC_EXEC_LO			126
> +#define GFX9_SOP2_SSRC_EXEC_HI			127
> +#define GFX9_SOP2_SSRC_INTEGER_0		128
> +#define GFX9_SOP2_SSRC_INTEGER_MINUS_1		193
> +#define GFX9_SOP2_SSRC_SHARED_BASE		235
> +#define GFX9_SOP2_SSRC_SHARED_LIMIT		236
> +#define GFX9_SOP2_SSRC_PRIVATE_BASE		237
> +#define GFX9_SOP2_SSRC_PRIVATE_LIMIT		238
> +#define GFX9_SOP2_SSRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_SOP2_SSRC_VCCZ			251
> +#define GFX9_SOP2_SSRC_EXECZ			252
> +#define GFX9_SOP2_SSRC_SCC			253
> +/* SDST
> + * Same codes as SSRC0, above except only codes 0-127 are valid.
> + */
> +
> +struct amdgcn_gfx9_sopk {
> +	u32 simm16:16;
> +	u32 sdst:7;
> +	u32 op:5;
> +	u32 encoding:4;
> +};
> +
> +enum amdgcn_gfx9_sopk_opcode {
> +	GFX9_S_MOVK_I32,
> +	GFX9_S_CMOVK_I32,
> +	GFX9_S_CMPK_EQ_I32,
> +	GFX9_S_CMPK_LG_I32,
> +	GFX9_S_CMPK_GT_I32,
> +	GFX9_S_CMPK_GE_I32,
> +	GFX9_S_CMPK_LT_I32,
> +	GFX9_S_CMPK_LE_I32,
> +	GFX9_S_CMPK_EQ_U32,
> +	GFX9_S_CMPK_LG_U32,
> +	GFX9_S_CMPK_GT_U32,
> +	GFX9_S_CMPK_GE_U32,
> +	GFX9_S_CMPK_LT_U32,
> +	GFX9_S_CMPK_LE_U32,
> +	GFX9_S_ADDK_I32,
> +	GFX9_S_MULK_I32,
> +	GFX9_S_CBRANCH_I_FORK,
> +	GFX9_S_GETREG_B32,
> +	GFX9_S_SETREG_B32 = 18,
> +	GFX9_S_SETREG_IMM32_B32 = 20,
> +	GFX9_S_CALL_B64,
> +};
> +
> +#define GFX9_SOPK_ENCODING			0xb
> +#define GFX9_SOPK_SDST_SGPR0_BASE		0
> +#define GFX9_SOPK_SDST_VCC_LO			106
> +#define GFX9_SOPK_SDST_VCC_HI			107
> +#define GFX9_SOPK_SDST_TTPM_BASE		108
> +#define GFX9_SOPK_SDST_M0			124
> +#define GFX9_SOPK_SDST_NULL			125
> +#define GFX9_SOPK_SDST_EXEC_LO			126
> +#define GFX9_SOPK_SDST_EXEC_HI			127
> +
> +struct amdgcn_gfx9_sop1 {
> +	u32 ssrc0:8;
> +	u32 op:8;
> +	u32 sdst:7;
> +	u32 encoding:9;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_sop1_opcode {
> +	GFX9_S_MOV_B32 = 0,
> +	GFX9_S_MOV_B64,
> +	GFX9_S_CMOV_B32,
> +	GFX9_S_CMOV_B64,
> +	GFX9_S_NOT_B32,
> +	GFX9_S_NOT_B64,
> +	GFX9_S_WQM_B32,
> +	GFX9_S_WQM_B64,
> +	GFX9_S_BREV_B32,
> +	GFX9_S_BREV_B64,
> +	GFX9_S_BCNT0_I32_B32,
> +	GFX9_S_BCNT0_I32_B64,
> +	GFX9_S_BCNT1_I32_B32,
> +	GFX9_S_BCNT1_I32_B64,
> +	GFX9_S_FF0_I32_B32,
> +	GFX9_S_FF0_I32_B64,
> +	GFX9_S_FF1_I32_B32,
> +	GFX9_S_FF1_I32_B64,
> +	GFX9_S_FLBIT_I32_B32,
> +	GFX9_S_FLBIT_I32_B64,
> +	GFX9_S_FLBIT_I32,
> +	GFX9_S_FLBIT_I32_I64,
> +	GFX9_S_SEXT_I32_I8,
> +	GFX9_S_SEXT_I32_I16,
> +	GFX9_S_BITSET0_B32,
> +	GFX9_S_BITSET0_B64,
> +	GFX9_S_BITSET1_B32,
> +	GFX9_S_BITSET1_B64,
> +	GFX9_S_GETPC_B64,
> +	GFX9_S_SETPC_B64,
> +	GFX9_S_SWAPPC_B64,
> +	GFX9_S_RFE_B64 = 31,
> +	GFX9_S_AND_SAVEEXEC_B64,
> +	GFX9_S_OR_SAVEEXEC_B64,
> +	GFX9_S_XOR_SAVEEXEC_B64,
> +	GFX9_S_ANDN2_SAVEEXEC_B64,
> +	GFX9_S_ORN2_SAVEEXEC_B64,
> +	GFX9_S_NAND_SAVEEXEC_B64,
> +	GFX9_S_NOR_SAVEEXEC_B64,
> +	GFX9_S_XNOR_SAVEEXEC_B64,
> +	GFX9_S_QUADMASK_B32,
> +	GFX9_S_QUADMASK_B64,
> +	GFX9_S_MOVRELS_B32,
> +	GFX9_S_MOVRELS_B64,
> +	GFX9_S_MOVRELD_B32,
> +	GFX9_S_MOVRELD_B64,
> +	GFX9_S_ABS_I32 = 48,
> +	GFX9_S_SET_GPR_IDX_IDX = 50,
> +	GFX9_S_ANDN1_SAVEEXEC_B64,
> +	GFX9_S_ORN1_SAVEEXEC_B64,
> +	GFX9_S_ANDN1_WREXEC_B64,
> +	GFX9_S_ANDN2_WREXEC_B64,
> +	GFX9_S_BITREPLICATE_B64_B32,
> +};
> +
> +#define GFX9_SOP1_ENCODING			0x17d
> +#define GFX9_SOP1_SSRC_SGPR_BASE		0
> +#define GFX9_SOP1_SSRC_VCC_LO			106
> +#define GFX9_SOP1_SSRC_VCC_HI			107
> +#define GFX9_SOP1_SSRC_TTPM_BASE		108
> +#define GFX9_SOP1_SSRC_M0			124
> +#define GFX9_SOP1_SSRC_NULL			125
> +#define GFX9_SOP1_SSRC_EXEC_LO			126
> +#define GFX9_SOP1_SSRC_EXEC_HI			127
> +#define GFX9_SOP1_SSRC_INTEGER_0		128
> +#define GFX9_SOP1_SSRC_INTEGER_MINUS_1		193
> +#define GFX9_SOP1_SSRC_SHARED_BASE		235
> +#define GFX9_SOP1_SSRC_SHARED_LIMIT		236
> +#define GFX9_SOP1_SSRC_PRIVATE_BASE		237
> +#define GFX9_SOP1_SSRC_PRIVATE_LIMIT		238
> +#define GFX9_SOP1_SSRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_SOP1_SSRC_VCCZ			251
> +#define GFX9_SOP1_SSRC_EXECZ			252
> +#define GFX9_SOP1_SSRC_SCC			253
> +#define GFX9_SOP1_SSRC_LITERAL_CONST		255
> +/* SDST
> + * Same codes as SSRC0, above except only codes 0-127 are valid.
> + */
> +
> +struct amdgcn_gfx9_sopc {
> +	u32 ssrc0:8;
> +	u32 ssrc1:8;
> +	u32 op:7;
> +	u32 encoding:9;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_sopc_opcode {
> +	GFX9_S_CMP_EQ_I32,
> +	GFX9_S_CMP_LG_I32,
> +	GFX9_S_CMP_GT_I32,
> +	GFX9_S_CMP_GE_I32,
> +	GFX9_S_CMP_LT_I32,
> +	GFX9_S_CMP_LE_I32,
> +	GFX9_S_CMP_EQ_U32,
> +	GFX9_S_CMP_LG_U32,
> +	GFX9_S_CMP_GT_U32,
> +	GFX9_S_CMP_GE_U32,
> +	GFX9_S_CMP_LT_U32,
> +	GFX9_S_CMP_LE_U32,
> +	GFX9_S_BITCMP0_B32,
> +	GFX9_S_BITCMP1_B32,
> +	GFX9_S_BITCMP0_B64,
> +	GFX9_S_BITCMP1_B64,
> +	GFX9_S_SETVSKIP,
> +	GFX9_S_SET_GPR_IDX_ON,
> +	GFX9_S_CMP_EQ_U64,
> +	GFX9_S_CMP_LG_U64,
> +};
> +
> +#define GFX9_SOPC_ENCODING			0x17e
> +#define GFX9_SOPC_SSRC_SGPR_BASE		0
> +#define GFX9_SOPC_SSRC_VCC_LO			106
> +#define GFX9_SOPC_SSRC_VCC_HI			107
> +#define GFX9_SOPC_SSRC_TTPM_BASE		108
> +#define GFX9_SOPC_SSRC_M0			124
> +#define GFX9_SOPC_SSRC_NULL			125
> +#define GFX9_SOPC_SSRC_EXEC_LO			126
> +#define GFX9_SOPC_SSRC_EXEC_HI			127
> +#define GFX9_SOPC_SSRC_INTEGER_0		128
> +#define GFX9_SOPC_SSRC_INTEGER_MINUS_1		193
> +#define GFX9_SOPC_SSRC_SHARED_BASE		235
> +#define GFX9_SOPC_SSRC_SHARED_LIMIT		236
> +#define GFX9_SOPC_SSRC_PRIVATE_BASE		237
> +#define GFX9_SOPC_SSRC_PRIVATE_LIMIT		238
> +#define GFX9_SOPC_SSRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_SOPC_SSRC_VCCZ			251
> +#define GFX9_SOPC_SSRC_EXECZ			252
> +#define GFX9_SOPC_SSRC_SCC			253
> +/* SDST
> + * Same codes as SSRC0, above except only codes 0-127 are valid.
> + */
> +
> +struct amdgcn_gfx9_sopp_vmcnt {
> +	u16 vmcnt1:4;
> +	u16 expcnt:3;
> +	u16 dummy1:1;
> +	u16 lgkmcnt:4;	/* GFX9: 4-bit counter, max=15 */
> +	u16 dummy2:2;
> +	u16 vmcnt2:2;
> +};
> +
> +struct amdgcn_gfx9_sopp {
> +	u32 simm16:16;
> +	u32 op:7;
> +	u32 encoding:9;
> +};
> +
> +enum amdgcn_gfx9_sopp_opcode {
> +	GFX9_S_NOP,
> +	GFX9_S_ENDPGM,
> +	GFX9_S_BRANCH,
> +	GFX9_S_WAKEUP,
> +	GFX9_S_CBRANCH_SCC0,
> +	GFX9_S_CBRANCH_SCC1,
> +	GFX9_S_CBRANCH_VCCZ,
> +	GFX9_S_CBRANCH_VCCNZ,
> +	GFX9_S_CBRANCH_EXECZ,
> +	GFX9_S_CBRANCH_EXECNZ,
> +	GFX9_S_BARRIER,
> +	GFX9_S_SETKILL,
> +	GFX9_S_WAITCNT,
> +	GFX9_S_SETHALT,
> +	GFX9_S_SLEEP,
> +	GFX9_S_SETPRIO,
> +	GFX9_S_SENDMSG,
> +	GFX9_S_SENDMSGHALT,
> +	GFX9_S_TRAP,
> +	GFX9_S_ICACHE_INV,
> +	GFX9_S_INCPERFLEVEL,
> +	GFX9_S_DECPERFLEVEL,
> +	GFX9_S_TTRACEDATA,
> +	GFX9_S_CBRANCH_CDBGSYS,
> +	GFX9_S_CBRANCH_CDBGUSER,
> +	GFX9_S_CBRANCH_CDBGSYS_OR_USER,
> +	GFX9_S_CBRANCH_CDBGSYS_AND_USER,
> +	GFX9_S_ENDPGM_SAVED,
> +	GFX9_S_SET_GPR_IDX_OFF,
> +	GFX9_S_SET_GPR_IDX_MODE,
> +	GFX9_S_ENDPGM_ORDERED_PS_DONE,
> +};
> +
> +#define GFX9_SOPP_ENCODING		0x17f
> +
> +/* Scalar Memory Format */
> +struct amdgcn_gfx9_smem {
> +	u64 sbase:6;
> +	u64 sdata:7;
> +	u64 dummy1:1;
> +	u64 soe:1; /* Scalar Offset Enable */
> +	u64 nv:1; /* Non-Volatile */
> +	u64 glc:1; /* Globally Memory Coherent */
> +	u64 imm:1; /* Immediate Enable */
> +	u64 op:8;
> +	u64 encoding:6;
> +	u64 offset:21;
> +	u64 dummy2:4;
> +	u64 soffset:7;
> +};
> +
> +enum amdgcn_gfx9_smem_opcode {
> +	GFX9_S_LOAD_DWORD,
> +	GFX9_S_LOAD_DWORDX2,
> +	GFX9_S_LOAD_DWORDX4,
> +	GFX9_S_LOAD_DWORDX8,
> +	GFX9_S_LOAD_DWORDX16,
> +	GFX9_S_SCRATCH_LOAD_DWORD,
> +	GFX9_S_SCRATCH_LOAD_DWORDX2,
> +	GFX9_S_SCRATCH_LOAD_DWORDX4,
> +	GFX9_S_BUFFER_LOAD_DWORD,
> +	GFX9_S_BUFFER_LOAD_DWORDX2,
> +	GFX9_S_BUFFER_LOAD_DWORDX4,
> +	GFX9_S_BUFFER_LOAD_DWORDX8,
> +	GFX9_S_BUFFER_LOAD_DWORDX16 = 12,
> +	GFX9_S_STORE_DWORD = 16,
> +	GFX9_S_STORE_DWORDX2,
> +	GFX9_S_STORE_DWORDX4 = 18,
> +	GFX9_S_SCRATCH_STORE_DWORD = 21,
> +	GFX9_S_SCRATCH_STORE_DWORDX2,
> +	GFX9_S_SCRATCH_STORE_DWORDX4,
> +	GFX9_S_BUFFER_STORE_DWORD,
> +	GFX9_S_BUFFER_STORE_DWORDX2,
> +	GFX9_S_BUFFER_STORE_DWORDX4 = 26,
> +	GFX9_S_DCACHE_INV = 32,
> +	GFX9_S_DCACHE_WB,
> +	GFX9_S_DCACHE_INV_VOL,
> +	GFX9_S_DCACHE_WB_VOL,
> +	GFX9_S_MEMTIME,
> +	GFX9_S_MEMREALTIME,
> +	GFX9_S_ATC_PROBE,
> +	GFX9_S_ATC_PROBE_BUFFER,
> +	GFX9_S_DCACHE_DISCARD,
> +	GFX9_S_DCACHE_DISCARD_X2 = 41,
> +	GFX9_S_BUFFER_ATOMIC_SWAP = 64,
> +	GFX9_S_BUFFER_ATOMIC_CMPSWAP,
> +	GFX9_S_BUFFER_ATOMIC_ADD,
> +	GFX9_S_BUFFER_ATOMIC_SUB,
> +	GFX9_S_BUFFER_ATOMIC_SMIN,
> +	GFX9_S_BUFFER_ATOMIC_UMIN,
> +	GFX9_S_BUFFER_ATOMIC_SMAX,
> +	GFX9_S_BUFFER_ATOMIC_UMAX,
> +	GFX9_S_BUFFER_ATOMIC_AND,
> +	GFX9_S_BUFFER_ATOMIC_OR,
> +	GFX9_S_BUFFER_ATOMIC_XOR,
> +	GFX9_S_BUFFER_ATOMIC_INC,
> +	GFX9_S_BUFFER_ATOMIC_DEC = 76,
> +	GFX9_S_BUFFER_ATOMIC_SWAP_X2 = 96,
> +	GFX9_S_BUFFER_ATOMIC_CMPSWAP_X2,
> +	GFX9_S_BUFFER_ATOMIC_ADD_X2,
> +	GFX9_S_BUFFER_ATOMIC_SUB_X2,
> +	GFX9_S_BUFFER_ATOMIC_SMIN_X2,
> +	GFX9_S_BUFFER_ATOMIC_UMIN_X2,
> +	GFX9_S_BUFFER_ATOMIC_SMAX_X2,
> +	GFX9_S_BUFFER_ATOMIC_UMAX_X2,
> +	GFX9_S_BUFFER_ATOMIC_AND_X2,
> +	GFX9_S_BUFFER_ATOMIC_OR_X2,
> +	GFX9_S_BUFFER_ATOMIC_XOR_X2,
> +	GFX9_S_BUFFER_ATOMIC_INC_X2,
> +	GFX9_S_BUFFER_ATOMIC_DEC_X2 = 108,
> +	GFX9_S_ATOMIC_SWAP = 128,
> +	GFX9_S_ATOMIC_CMPSWAP,
> +	GFX9_S_ATOMIC_ADD,
> +	GFX9_S_ATOMIC_SUB,
> +	GFX9_S_ATOMIC_SMIN,
> +	GFX9_S_ATOMIC_UMIN,
> +	GFX9_S_ATOMIC_SMAX,
> +	GFX9_S_ATOMIC_UMAX,
> +	GFX9_S_ATOMIC_AND,
> +	GFX9_S_ATOMIC_OR,
> +	GFX9_S_ATOMIC_XOR,
> +	GFX9_S_ATOMIC_INC,
> +	GFX9_S_ATOMIC_DEC = 140,
> +	GFX9_S_ATOMIC_SWAP_X2 = 160,
> +	GFX9_S_ATOMIC_CMPSWAP_X2,
> +	GFX9_S_ATOMIC_ADD_X2,
> +	GFX9_S_ATOMIC_SUB_X2,
> +	GFX9_S_ATOMIC_SMIN_X2,
> +	GFX9_S_ATOMIC_UMIN_X2,
> +	GFX9_S_ATOMIC_SMAX_X2,
> +	GFX9_S_ATOMIC_UMAX_X2,
> +	GFX9_S_ATOMIC_AND_X2,
> +	GFX9_S_ATOMIC_OR_X2,
> +	GFX9_S_ATOMIC_XOR_X2,
> +	GFX9_S_ATOMIC_INC_X2,
> +	GFX9_S_ATOMIC_DEC_X2,
> +};
> +
> +#define GFX9_SMEM_ENCODING		0x30
> +#define GFX9_SMEM_SOFFSET_NULL		125
> +
> +/* Vector ALU Format */
> +struct amdgcn_gfx9_vop2 {
> +	u32 src0:9;
> +	u32 vsrc1:8;
> +	u32 vdst:8;
> +	u32 op:6;
> +	u32 encoding:1;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_vop2_opcode {
> +	GFX9_V_CNDMASK_B32,
> +	GFX9_V_ADD_F32,
> +	GFX9_V_SUB_F32,
> +	GFX9_V_SUBREV_F32,
> +	GFX9_V_MUL_LEGACY_F32,
> +	GFX9_V_MUL_F32,
> +	GFX9_V_MUL_I32_I24,
> +	GFX9_V_MUL_HI_I32_I24,
> +	GFX9_V_MUL_U32_U24,
> +	GFX9_V_MUL_HI_U32_U24,
> +	GFX9_V_MIN_F32,
> +	GFX9_V_MAX_F32,
> +	GFX9_V_MIN_I32,
> +	GFX9_V_MAX_I32,
> +	GFX9_V_MIN_U32,
> +	GFX9_V_MAX_U32,
> +	GFX9_V_LSHRREV_B32,
> +	GFX9_V_ASHRREV_I32,
> +	GFX9_V_LSHLREV_B32,
> +	GFX9_V_AND_B32,
> +	GFX9_V_OR_B32,
> +	GFX9_V_XOR_B32,
> +	GFX9_V_MAC_F32,
> +	GFX9_V_MADMK_F32,
> +	GFX9_V_MADAK_F32,
> +	GFX9_V_ADD_CO_U32,
> +	GFX9_V_SUB_CO_U32,
> +	GFX9_V_SUBREV_CO_U32,
> +	GFX9_V_ADDC_CO_U32,
> +	GFX9_V_SUBB_CO_U32,
> +	GFX9_V_SUBBREV_CO_U32,
> +	GFX9_V_ADD_F16,
> +	GFX9_V_SUB_F16,
> +	GFX9_V_SUBREV_F16,
> +	GFX9_V_MUL_F16,
> +	GFX9_V_MAC_F16,
> +	GFX9_V_MADMK_F16,
> +	GFX9_V_MADAK_F16,
> +	GFX9_V_ADD_U16,
> +	GFX9_V_SUB_U16,
> +	GFX9_V_SUBREV_U16,
> +	GFX9_V_MUL_LO_U16,
> +	GFX9_V_LSHLREV_B16,
> +	GFX9_V_LSHRREV_B16,
> +	GFX9_V_ASHRREV_I16,
> +	GFX9_V_MAX_F16,
> +	GFX9_V_MIN_F16,
> +	GFX9_V_MAX_U16,
> +	GFX9_V_MAX_I16,
> +	GFX9_V_MIN_U16,
> +	GFX9_V_MIN_I16,
> +	GFX9_V_LDEXP_F16,
> +	GFX9_V_ADD_U32,
> +	GFX9_V_SUB_U32,
> +	GFX9_V_SUBREV_U32,
> +};
> +
> +#define GFX9_VOP2_ENCODING			0x0
> +#define GFX9_VOP2_SRC_SGPR_BASE		0
> +#define GFX9_VOP2_SRC_VCC_LO			106
> +#define GFX9_VOP2_SRC_VCC_HI			107
> +#define GFX9_VOP2_SRC_TTPM_BASE		108
> +#define GFX9_VOP2_SRC_M0			124
> +#define GFX9_VOP2_SRC_NULL			125
> +#define GFX9_VOP2_SRC_EXEC_LO			126
> +#define GFX9_VOP2_SRC_EXEC_HI			127
> +#define GFX9_VOP2_SRC_INTEGER_0		128
> +#define GFX9_VOP2_SRC_INTEGER_MINUS_1		193
> +#define GFX9_VOP2_SRC_SHARED_BASE		235
> +#define GFX9_VOP2_SRC_SHARED_LIMIT		236
> +#define GFX9_VOP2_SRC_PRIVATE_BASE		237
> +#define GFX9_VOP2_SRC_PRIVATE_LIMIT		238
> +#define GFX9_VOP2_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_VOP2_SRC_SDWA			249
> +#define GFX9_VOP2_SRC_DDP16			250
> +#define GFX9_VOP2_SRC_VCCZ			251
> +#define GFX9_VOP2_SRC_EXECZ			252
> +#define GFX9_VOP2_SRC_SCC			253
> +#define GFX9_VOP2_SRC_LITERAL_CONST		255
> +#define GFX9_VOP2_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx9_vop1 {
> +	u32 src0:9;
> +	u32 op:8;
> +	u32 vdst:8;
> +	u32 encoding:7;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_vop1_opcode {
> +	GFX9_V_NOP,
> +	GFX9_V_MOV_B32,
> +	GFX9_V_READFIRSTLANE_B32,
> +	GFX9_V_CVT_I32_F64,
> +	GFX9_V_CVT_F64_I32,
> +	GFX9_V_CVT_F32_I32,
> +	GFX9_V_CVT_F32_U32,
> +	GFX9_V_CVT_U32_F32,
> +	GFX9_V_CVT_I32_F32 = 8,
> +	GFX9_V_CVT_F16_F32 = 10,
> +	GFX9_V_CVT_F32_F16,
> +	GFX9_V_CVT_RPI_I32_F32,
> +	GFX9_V_CVT_FLR_I32_F32,
> +	GFX9_V_CVT_OFF_F32_I4,
> +	GFX9_V_CVT_F32_F64,
> +	GFX9_V_CVT_F64_F32,
> +	GFX9_V_CVT_F32_UBYTE0,
> +	GFX9_V_CVT_F32_UBYTE1,
> +	GFX9_V_CVT_F32_UBYTE2,
> +	GFX9_V_CVT_F32_UBYTE3,
> +	GFX9_V_CVT_U32_F64,
> +	GFX9_V_CVT_F64_U32,
> +	GFX9_V_TRUNC_F64,
> +	GFX9_V_CEIL_F64,
> +	GFX9_V_RNDNE_F64,
> +	GFX9_V_FLOOR_F64,
> +	GFX9_V_FRACT_F32,
> +	GFX9_V_TRUNC_F32,
> +	GFX9_V_CEIL_F32,
> +	GFX9_V_RNDNE_F32,
> +	GFX9_V_FLOOR_F32,
> +	GFX9_V_EXP_F32,
> +	GFX9_V_LOG_F32,
> +	GFX9_V_RCP_F32,
> +	GFX9_V_RCP_IFLAG_F32,
> +	GFX9_V_RSQ_F32,
> +	GFX9_V_RCP_F64,
> +	GFX9_V_RSQ_F64,
> +	GFX9_V_SQRT_F32,
> +	GFX9_V_SQRT_F64,
> +	GFX9_V_SIN_F32,
> +	GFX9_V_COS_F32,
> +	GFX9_V_NOT_B32,
> +	GFX9_V_BFREV_B32,
> +	GFX9_V_FFBH_U32,
> +	GFX9_V_FFBL_B32,
> +	GFX9_V_FFBH_I32,
> +	GFX9_V_FREXP_EXP_I32_F64,
> +	GFX9_V_FREXP_MANT_F64,
> +	GFX9_V_FRACT_F64,
> +	GFX9_V_FREXP_EXP_I32_F32,
> +	GFX9_V_FREXP_MANT_F32,
> +	GFX9_V_CLREXCP,
> +	/* ISA opcodes 54 and 56 are not defined (reserved gaps). */
> +	GFX9_V_SCREEN_PARTITION_4SE_B32 = 55,
> +	GFX9_V_CVT_F16_U16 = 57,
> +	GFX9_V_CVT_F16_I16,
> +	GFX9_V_CVT_U16_F16,
> +	GFX9_V_CVT_I16_F16,
> +	GFX9_V_RCP_F16,
> +	GFX9_V_SQRT_F16,
> +	GFX9_V_RSQ_F16,
> +	GFX9_V_LOG_F16,
> +	GFX9_V_EXP_F16,
> +	GFX9_V_FREXP_MANT_F16,
> +	GFX9_V_FREXP_EXP_I16_F16,
> +	GFX9_V_FLOOR_F16,
> +	GFX9_V_CEIL_F16,
> +	GFX9_V_TRUNC_F16,
> +	GFX9_V_RNDNE_F16,
> +	GFX9_V_FRACT_F16,
> +	GFX9_V_SIN_F16,
> +	GFX9_V_COS_F16,
> +	GFX9_V_EXP_LEGACY_F32,
> +	GFX9_V_LOG_LEGACY_F32,
> +	GFX9_V_CVT_NORM_I16_F16,
> +	GFX9_V_CVT_NORM_U16_F16,
> +	GFX9_V_SAT_PK_U8_I16 = 79,
> +	GFX9_V_SWAP_B32 = 81,
> +};
> +
> +#define GFX9_VOP1_ENCODING			0x3f
> +#define GFX9_VOP1_SRC_SGPR_BASE			0
> +#define GFX9_VOP1_SRC_VCC_LO			106
> +#define GFX9_VOP1_SRC_VCC_HI			107
> +#define GFX9_VOP1_SRC_TTPM_BASE			108
> +#define GFX9_VOP1_SRC_M0			124
> +#define GFX9_VOP1_SRC_NULL			125
> +#define GFX9_VOP1_SRC_EXEC_LO			126
> +#define GFX9_VOP1_SRC_EXEC_HI			127
> +#define GFX9_VOP1_SRC_INTEGER_0			128
> +#define GFX9_VOP1_SRC_INTEGER_MINUS_1		193
> +#define GFX9_VOP1_SRC_SHARED_BASE		235
> +#define GFX9_VOP1_SRC_SHARED_LIMIT		236
> +#define GFX9_VOP1_SRC_PRIVATE_BASE		237
> +#define GFX9_VOP1_SRC_PRIVATE_LIMIT		238
> +#define GFX9_VOP1_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_VOP1_SRC_SDWA			249
> +#define GFX9_VOP1_SRC_DDP16			250
> +#define GFX9_VOP1_SRC_VCCZ			251
> +#define GFX9_VOP1_SRC_EXECZ			252
> +#define GFX9_VOP1_SRC_SCC			253
> +#define GFX9_VOP1_SRC_LITERAL_CONST		255
> +#define GFX9_VOP1_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx9_vopc {
> +	u32 src0:9;
> +	u32 vsrc1:8;
> +	u32 op:8;
> +	u32 encoding:7;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_vopc_compare_offset16 {
> +	GFX9_VOPC16_F = 0,
> +	GFX9_VOPC16_LT,
> +	GFX9_VOPC16_EQ,
> +	GFX9_VOPC16_LE,
> +	GFX9_VOPC16_GT,
> +	GFX9_VOPC16_LG,
> +	GFX9_VOPC16_GE,
> +	GFX9_VOPC16_O,
> +	GFX9_VOPC16_U,
> +	GFX9_VOPC16_NGE,
> +	GFX9_VOPC16_NLG,
> +	GFX9_VOPC16_NGT,
> +	GFX9_VOPC16_NLE,
> +	GFX9_VOPC16_NEQ,
> +	GFX9_VOPC16_NLT,
> +	GFX9_VOPC16_TRU,
> +};
> +
> +enum amdgcn_gfx9_vopc_compare_offset8 {
> +	GFX9_VOPC8_F = 0,
> +	GFX9_VOPC8_LT,
> +	GFX9_VOPC8_EQ,
> +	GFX9_VOPC8_LE,
> +	GFX9_VOPC8_GT,
> +	GFX9_VOPC8_LG,
> +	GFX9_VOPC8_GE,
> +	GFX9_VOPC8_TRU,
> +};
> +
> +enum amdgcn_gfx9_vopc_opcode {
> +	GFX9_V_CMP_CLASS_F32 = 16,
> +	GFX9_V_CMPX_CLASS_F32,
> +	GFX9_V_CMP_CLASS_F64,
> +	GFX9_V_CMPX_CLASS_F64,
> +	GFX9_V_CMP_CLASS_F16,
> +	GFX9_V_CMPX_CLASS_F16 = 21,
> +	GFX9_V_CMP_F_F16 = 32,
> +	GFX9_V_CMP_LT_F16,
> +	GFX9_V_CMP_EQ_F16,
> +	GFX9_V_CMP_LE_F16,
> +	GFX9_V_CMP_GT_F16,
> +	GFX9_V_CMP_LG_F16,
> +	GFX9_V_CMP_GE_F16,
> +	GFX9_V_CMP_O_F16,
> +	GFX9_V_CMP_U_F16,
> +	GFX9_V_CMP_NGE_F16,
> +	GFX9_V_CMP_NLG_F16,
> +	GFX9_V_CMP_NGT_F16,
> +	GFX9_V_CMP_NLE_F16,
> +	GFX9_V_CMP_NEQ_F16,
> +	GFX9_V_CMP_NLT_F16,
> +	GFX9_V_CMP_TRU_F16,
> +	GFX9_V_CMPX_F_F16,
> +	GFX9_V_CMPX_LT_F16,
> +	GFX9_V_CMPX_EQ_F16,
> +	GFX9_V_CMPX_LE_F16,
> +	GFX9_V_CMPX_GT_F16,
> +	GFX9_V_CMPX_LG_F16,
> +	GFX9_V_CMPX_GE_F16,
> +	GFX9_V_CMPX_O_F16,
> +	GFX9_V_CMPX_U_F16,
> +	GFX9_V_CMPX_NGE_F16,
> +	GFX9_V_CMPX_NLG_F16,
> +	GFX9_V_CMPX_NGT_F16,
> +	GFX9_V_CMPX_NLE_F16,
> +	GFX9_V_CMPX_NEQ_F16,
> +	GFX9_V_CMPX_NLT_F16,
> +	GFX9_V_CMPX_TRU_F16,
> +	GFX9_V_CMP_F_F32,
> +	GFX9_V_CMP_LT_F32,
> +	GFX9_V_CMP_EQ_F32,
> +	GFX9_V_CMP_LE_F32,
> +	GFX9_V_CMP_GT_F32,
> +	GFX9_V_CMP_LG_F32,
> +	GFX9_V_CMP_GE_F32,
> +	GFX9_V_CMP_O_F32,
> +	GFX9_V_CMP_U_F32,
> +	GFX9_V_CMP_NGE_F32,
> +	GFX9_V_CMP_NLG_F32,
> +	GFX9_V_CMP_NGT_F32,
> +	GFX9_V_CMP_NLE_F32,
> +	GFX9_V_CMP_NEQ_F32,
> +	GFX9_V_CMP_NLT_F32,
> +	GFX9_V_CMP_TRU_F32,
> +	GFX9_V_CMPX_F_F32,
> +	GFX9_V_CMPX_LT_F32,
> +	GFX9_V_CMPX_EQ_F32,
> +	GFX9_V_CMPX_LE_F32,
> +	GFX9_V_CMPX_GT_F32,
> +	GFX9_V_CMPX_LG_F32,
> +	GFX9_V_CMPX_GE_F32,
> +	GFX9_V_CMPX_O_F32,
> +	GFX9_V_CMPX_U_F32,
> +	GFX9_V_CMPX_NGE_F32,
> +	GFX9_V_CMPX_NLG_F32,
> +	GFX9_V_CMPX_NGT_F32,
> +	GFX9_V_CMPX_NLE_F32,
> +	GFX9_V_CMPX_NEQ_F32,
> +	GFX9_V_CMPX_NLT_F32,
> +	GFX9_V_CMPX_TRU_F32,
> +	GFX9_V_CMP_F_F64,
> +	GFX9_V_CMP_LT_F64,
> +	GFX9_V_CMP_EQ_F64,
> +	GFX9_V_CMP_LE_F64,
> +	GFX9_V_CMP_GT_F64,
> +	GFX9_V_CMP_LG_F64,
> +	GFX9_V_CMP_GE_F64,
> +	GFX9_V_CMP_O_F64,
> +	GFX9_V_CMP_U_F64,
> +	GFX9_V_CMP_NGE_F64,
> +	GFX9_V_CMP_NLG_F64,
> +	GFX9_V_CMP_NGT_F64,
> +	GFX9_V_CMP_NLE_F64,
> +	GFX9_V_CMP_NEQ_F64,
> +	GFX9_V_CMP_NLT_F64,
> +	GFX9_V_CMP_TRU_F64,
> +	GFX9_V_CMPX_F_F64,
> +	GFX9_V_CMPX_LT_F64,
> +	GFX9_V_CMPX_EQ_F64,
> +	GFX9_V_CMPX_LE_F64,
> +	GFX9_V_CMPX_GT_F64,
> +	GFX9_V_CMPX_LG_F64,
> +	GFX9_V_CMPX_GE_F64,
> +	GFX9_V_CMPX_O_F64,
> +	GFX9_V_CMPX_U_F64,
> +	GFX9_V_CMPX_NGE_F64,
> +	GFX9_V_CMPX_NLG_F64,
> +	GFX9_V_CMPX_NGT_F64,
> +	GFX9_V_CMPX_NLE_F64,
> +	GFX9_V_CMPX_NEQ_F64,
> +	GFX9_V_CMPX_NLT_F64,
> +	GFX9_V_CMPX_TRU_F64 = 127,
> +	GFX9_V_CMP_F_I16 = 160,
> +	GFX9_V_CMP_LT_I16,
> +	GFX9_V_CMP_EQ_I16,
> +	GFX9_V_CMP_LE_I16,
> +	GFX9_V_CMP_GT_I16,
> +	GFX9_V_CMP_NE_I16,
> +	GFX9_V_CMP_GE_I16,
> +	GFX9_V_CMP_T_I16,
> +	GFX9_V_CMP_F_U16,
> +	GFX9_V_CMP_LT_U16,
> +	GFX9_V_CMP_EQ_U16,
> +	GFX9_V_CMP_LE_U16,
> +	GFX9_V_CMP_GT_U16,
> +	GFX9_V_CMP_NE_U16,
> +	GFX9_V_CMP_GE_U16,
> +	GFX9_V_CMP_T_U16,
> +	GFX9_V_CMPX_F_I16,
> +	GFX9_V_CMPX_LT_I16,
> +	GFX9_V_CMPX_EQ_I16,
> +	GFX9_V_CMPX_LE_I16,
> +	GFX9_V_CMPX_GT_I16,
> +	GFX9_V_CMPX_NE_I16,
> +	GFX9_V_CMPX_GE_I16,
> +	GFX9_V_CMPX_T_I16,
> +	GFX9_V_CMPX_F_U16,
> +	GFX9_V_CMPX_LT_U16,
> +	GFX9_V_CMPX_EQ_U16,
> +	GFX9_V_CMPX_LE_U16,
> +	GFX9_V_CMPX_GT_U16,
> +	GFX9_V_CMPX_NE_U16,
> +	GFX9_V_CMPX_GE_U16,
> +	GFX9_V_CMPX_T_U16,
> +	GFX9_V_CMP_F_I32,
> +	GFX9_V_CMP_LT_I32,
> +	GFX9_V_CMP_EQ_I32,
> +	GFX9_V_CMP_LE_I32,
> +	GFX9_V_CMP_GT_I32,
> +	GFX9_V_CMP_NE_I32,
> +	GFX9_V_CMP_GE_I32,
> +	GFX9_V_CMP_T_I32,
> +	GFX9_V_CMP_F_U32,
> +	GFX9_V_CMP_LT_U32,
> +	GFX9_V_CMP_EQ_U32,
> +	GFX9_V_CMP_LE_U32,
> +	GFX9_V_CMP_GT_U32,
> +	GFX9_V_CMP_NE_U32,
> +	GFX9_V_CMP_GE_U32,
> +	GFX9_V_CMP_T_U32,
> +	GFX9_V_CMPX_F_I32,
> +	GFX9_V_CMPX_LT_I32,
> +	GFX9_V_CMPX_EQ_I32,
> +	GFX9_V_CMPX_LE_I32,
> +	GFX9_V_CMPX_GT_I32,
> +	GFX9_V_CMPX_NE_I32,
> +	GFX9_V_CMPX_GE_I32,
> +	GFX9_V_CMPX_T_I32,
> +	GFX9_V_CMPX_F_U32,
> +	GFX9_V_CMPX_LT_U32,
> +	GFX9_V_CMPX_EQ_U32,
> +	GFX9_V_CMPX_LE_U32,
> +	GFX9_V_CMPX_GT_U32,
> +	GFX9_V_CMPX_NE_U32,
> +	GFX9_V_CMPX_GE_U32,
> +	GFX9_V_CMPX_T_U32,
> +	GFX9_V_CMP_F_I64,
> +	GFX9_V_CMP_LT_I64,
> +	GFX9_V_CMP_EQ_I64,
> +	GFX9_V_CMP_LE_I64,
> +	GFX9_V_CMP_GT_I64,
> +	GFX9_V_CMP_NE_I64,
> +	GFX9_V_CMP_GE_I64,
> +	GFX9_V_CMP_T_I64,
> +	GFX9_V_CMP_F_U64,
> +	GFX9_V_CMP_LT_U64,
> +	GFX9_V_CMP_EQ_U64,
> +	GFX9_V_CMP_LE_U64,
> +	GFX9_V_CMP_GT_U64,
> +	GFX9_V_CMP_NE_U64,
> +	GFX9_V_CMP_GE_U64,
> +	GFX9_V_CMP_T_U64,
> +	GFX9_V_CMPX_F_I64,
> +	GFX9_V_CMPX_LT_I64,
> +	GFX9_V_CMPX_EQ_I64,
> +	GFX9_V_CMPX_LE_I64,
> +	GFX9_V_CMPX_GT_I64,
> +	GFX9_V_CMPX_NE_I64,
> +	GFX9_V_CMPX_GE_I64,
> +	GFX9_V_CMPX_T_I64,
> +	GFX9_V_CMPX_F_U64,
> +	GFX9_V_CMPX_LT_U64,
> +	GFX9_V_CMPX_EQ_U64,
> +	GFX9_V_CMPX_LE_U64,
> +	GFX9_V_CMPX_GT_U64,
> +	GFX9_V_CMPX_NE_U64,
> +	GFX9_V_CMPX_GE_U64,
> +	GFX9_V_CMPX_T_U64,
> +};
> +
> +#define GFX9_VOPC_ENCODING			0x3e
> +#define GFX9_VOPC_SRC_SGPR_BASE			0
> +#define GFX9_VOPC_SRC_VCC_LO			106
> +#define GFX9_VOPC_SRC_VCC_HI			107
> +#define GFX9_VOPC_SRC_TTPM_BASE			108
> +#define GFX9_VOPC_SRC_M0			124
> +#define GFX9_VOPC_SRC_NULL			125
> +#define GFX9_VOPC_SRC_EXEC_LO			126
> +#define GFX9_VOPC_SRC_EXEC_HI			127
> +#define GFX9_VOPC_SRC_INTEGER_0			128
> +#define GFX9_VOPC_SRC_INTEGER_MINUS_1		193
> +#define GFX9_VOPC_SRC_SHARED_BASE		235
> +#define GFX9_VOPC_SRC_SHARED_LIMIT		236
> +#define GFX9_VOPC_SRC_PRIVATE_BASE		237
> +#define GFX9_VOPC_SRC_PRIVATE_LIMIT		238
> +#define GFX9_VOPC_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_VOPC_SRC_SDWA			249
> +#define GFX9_VOPC_SRC_DDP16			250
> +#define GFX9_VOPC_SRC_VCCZ			251
> +#define GFX9_VOPC_SRC_EXECZ			252
> +#define GFX9_VOPC_SRC_SCC			253
> +#define GFX9_VOPC_SRC_LITERAL_CONST		255
> +#define GFX9_VOPC_SRC_VGPR_BASE			256
> +
> +struct amdgcn_gfx9_vop3a {
> +	u64 vdst:8;
> +	u64 abs:3;
> +	u64 op_sel:4;
> +	u64 clmp:1;
> +	u64 op:10;
> +	u64 encoding:6;
> +	u64 src0:9;
> +	u64 src1:9;
> +	u64 src2:9;
> +	u64 omod:2;
> +	u64 neg:3;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_vop3a_opcode {
> +	GFX9_V_MAD_LEGACY_F32 = 448,
> +	GFX9_V_MAD_F32,
> +	GFX9_V_MAD_I32_I24,
> +	GFX9_V_MAD_U32_U24,
> +	GFX9_V_CUBEID_F32,
> +	GFX9_V_CUBESC_F32,
> +	GFX9_V_CUBETC_F32,
> +	GFX9_V_CUBEMA_F32,
> +	GFX9_V_BFE_U32,
> +	GFX9_V_BFE_I32,
> +	GFX9_V_BFI_B32,
> +	GFX9_V_FMA_F32,
> +	GFX9_V_FMA_F64,
> +	GFX9_V_LERP_U8,
> +	GFX9_V_ALIGNBIT_B32,
> +	GFX9_V_ALIGNBYTE_B32,
> +	GFX9_V_MIN3_F32,
> +	GFX9_V_MIN3_I32,
> +	GFX9_V_MIN3_U32,
> +	GFX9_V_MAX3_F32,
> +	GFX9_V_MAX3_I32,
> +	GFX9_V_MAX3_U32,
> +	GFX9_V_MED3_F32,
> +	GFX9_V_MED3_I32,
> +	GFX9_V_MED3_U32,
> +	GFX9_V_SAD_U8,
> +	GFX9_V_SAD_HI_U8,
> +	GFX9_V_SAD_U16,
> +	GFX9_V_SAD_U32,
> +	GFX9_V_CVT_PK_U8_F32,
> +	GFX9_V_DIV_FIXUP_F32,
> +	GFX9_V_DIV_FIXUP_F64 = 479,
> +	GFX9_V_DIV_FMAS_F32 = 482,
> +	GFX9_V_DIV_FMAS_F64,
> +	GFX9_V_MSAD_U8,
> +	GFX9_V_QSAD_PK_U16_U8,
> +	GFX9_V_MQSAD_PK_U16_U8,
> +	GFX9_V_MQSAD_U32_U8 = 487,
> +	GFX9_V_MAD_LEGACY_F16 = 490,
> +	GFX9_V_MAD_LEGACY_U16,
> +	GFX9_V_MAD_LEGACY_I16,
> +	GFX9_V_PERM_B32,
> +	GFX9_V_FMA_LEGACY_F16,
> +	GFX9_V_DIV_FIXUP_LEGACY_F16,
> +	GFX9_V_CVT_PKACCUM_U8_F32,
> +	GFX9_V_MAD_U32_U16,
> +	GFX9_V_MAD_I32_I16,
> +	GFX9_V_XAD_U32,
> +	GFX9_V_MIN3_F16,
> +	GFX9_V_MIN3_I16,
> +	GFX9_V_MIN3_U16,
> +	GFX9_V_MAX3_F16,
> +	GFX9_V_MAX3_I16,
> +	GFX9_V_MAX3_U16,
> +	GFX9_V_MED3_F16,
> +	GFX9_V_MED3_I16,
> +	GFX9_V_MED3_U16,
> +	GFX9_V_LSHL_ADD_U32,
> +	GFX9_V_ADD_LSHL_U32,
> +	GFX9_V_ADD3_U32,
> +	GFX9_V_LSHL_OR_B32,
> +	GFX9_V_AND_OR_B32,
> +	GFX9_V_OR3_B32,
> +	GFX9_V_MAD_F16,
> +	GFX9_V_MAD_U16,
> +	GFX9_V_MAD_I16,
> +	GFX9_V_FMA_F16,
> +	GFX9_V_DIV_FIXUP_F16 = 519,
> +	GFX9_V_INTERP_P1LL_F16 = 628,
> +	GFX9_V_INTERP_P1LV_F16,
> +	GFX9_V_INTERP_P2_LEGACY_F16,
> +	GFX9_V_INTERP_P2_F16 = 631,
> +	GFX9_V_ADD_F64 = 640,
> +	GFX9_V_MUL_F64,
> +	GFX9_V_MIN_F64,
> +	GFX9_V_MAX_F64,
> +	GFX9_V_LDEXP_F64,
> +	GFX9_V_MUL_LO_U32,
> +	GFX9_V_MUL_HI_U32,
> +	GFX9_V_MUL_HI_I32,
> +	GFX9_V_LDEXP_F32,
> +	GFX9_V_READLANE_B32,
> +	GFX9_V_WRITELANE_B32,
> +	GFX9_V_BCNT_U32_B32,
> +	GFX9_V_MBCNT_LO_U32_B32,
> +	GFX9_V_MBCNT_HI_U32_B32 = 653,
> +	GFX9_V_LSHLREV_B64 = 655,
> +	GFX9_V_LSHRREV_B64,
> +	GFX9_V_ASHRREV_I64,
> +	GFX9_V_TRIG_PREOP_F64,
> +	GFX9_V_BFM_B32,
> +	GFX9_V_CVT_PKNORM_I16_F32,
> +	GFX9_V_CVT_PKNORM_U16_F32,
> +	GFX9_V_CVT_PKRTZ_F16_F32,
> +	GFX9_V_CVT_PK_U16_U32,
> +	GFX9_V_CVT_PK_I16_I32,
> +	GFX9_V_CVT_PKNORM_I16_F16,
> +	GFX9_V_CVT_PKNORM_U16_F16 = 666,
> +	GFX9_V_ADD_I32 = 668,
> +	GFX9_V_SUB_I32,
> +	GFX9_V_ADD_I16,
> +	GFX9_V_SUB_I16,
> +	GFX9_V_PACK_B32_F16,
> +};
> +
> +enum amdgcn_gfx9_vop3a_abs {
> +	GFX9_VOP3A_ABS_SRC0,
> +	GFX9_VOP3A_ABS_SRC1,
> +	GFX9_VOP3A_ABS_SRC2,
> +};
> +
> +#define GFX9_VOP3A_ENCODING			0x34
> +#define GFX9_VOP3A_SRC_SGPR_BASE		0
> +#define GFX9_VOP3A_SRC_VCC_LO			106
> +#define GFX9_VOP3A_SRC_VCC_HI			107
> +#define GFX9_VOP3A_SRC_TTPM_BASE		108
> +#define GFX9_VOP3A_SRC_M0			124
> +#define GFX9_VOP3A_SRC_NULL			125
> +#define GFX9_VOP3A_SRC_EXEC_LO			126
> +#define GFX9_VOP3A_SRC_EXEC_HI			127
> +#define GFX9_VOP3A_SRC_INTEGER_0		128
> +#define GFX9_VOP3A_SRC_INTEGER_MINUS_1		193
> +#define GFX9_VOP3A_SRC_SHARED_BASE		235
> +#define GFX9_VOP3A_SRC_SHARED_LIMIT		236
> +#define GFX9_VOP3A_SRC_PRIVATE_BASE		237
> +#define GFX9_VOP3A_SRC_PRIVATE_LIMIT		238
> +#define GFX9_VOP3A_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_VOP3A_SRC_SDWA			249
> +#define GFX9_VOP3A_SRC_DDP16			250
> +#define GFX9_VOP3A_SRC_VCCZ			251
> +#define GFX9_VOP3A_SRC_EXECZ			252
> +#define GFX9_VOP3A_SRC_SCC			253
> +#define GFX9_VOP3A_SRC_LITERAL_CONST		255
> +#define GFX9_VOP3A_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx9_vop3b {
> +	u64 vdst:8;
> +	u64 sdst:7;
> +	u64 clmp:1;
> +	u64 op:10;
> +	u64 encoding:6;
> +	u64 src0:9;
> +	u64 src1:9;
> +	u64 src2:9;
> +	u64 omod:2;
> +	u64 neg:3;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_vop3b_opcode {
> +	GFX9_V_DIV_SCALE_F64 = 481,
> +	GFX9_V_MAD_U64_U32 = 488,
> +	GFX9_V_MAD_I64_I32 = 489,
> +};
> +
> +#define GFX9_VOP3B_ENCODING			0x34
> +#define GFX9_VOP3B_SRC_SGPR_BASE		0
> +#define GFX9_VOP3B_SRC_VCC_LO			106
> +#define GFX9_VOP3B_SRC_VCC_HI			107
> +#define GFX9_VOP3B_SRC_TTPM_BASE		108
> +#define GFX9_VOP3B_SRC_M0			124
> +#define GFX9_VOP3B_SRC_NULL			125
> +#define GFX9_VOP3B_SRC_EXEC_LO			126
> +#define GFX9_VOP3B_SRC_EXEC_HI			127
> +#define GFX9_VOP3B_SRC_INTEGER_0		128
> +#define GFX9_VOP3B_SRC_INTEGER_MINUS_1		193
> +#define GFX9_VOP3B_SRC_SHARED_BASE		235
> +#define GFX9_VOP3B_SRC_SHARED_LIMIT		236
> +#define GFX9_VOP3B_SRC_PRIVATE_BASE		237
> +#define GFX9_VOP3B_SRC_PRIVATE_LIMIT		238
> +#define GFX9_VOP3B_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_VOP3B_SRC_SDWA			249
> +#define GFX9_VOP3B_SRC_DDP16			250
> +#define GFX9_VOP3B_SRC_VCCZ			251
> +#define GFX9_VOP3B_SRC_EXECZ			252
> +#define GFX9_VOP3B_SRC_SCC			253
> +#define GFX9_VOP3B_SRC_LITERAL_CONST		255
> +#define GFX9_VOP3B_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx9_vop3p {
> +	u64 vdst:8;
> +	u64 neg_hi:3;
> +	u64 op_sel:3;
> +	u64 op_sel_hi2:1;
> +	u64 clmp:1;
> +	u64 op:7;
> +	u64 encoding:9;
> +	u64 src0:9;
> +	u64 src1:9;
> +	u64 src2:9;
> +	u64 op_sel_hi:2;
> +	u64 neg:3;
> +	u32 literal;
> +};
> +
> +enum amdgcn_gfx9_vop3p_opcode {
> +	GFX9_V_PK_MAD_I16,
> +	GFX9_V_PK_MUL_LO_U16,
> +	GFX9_V_PK_ADD_I16,
> +	GFX9_V_PK_SUB_I16,
> +	GFX9_V_PK_LSHLREV_B16,
> +	GFX9_V_PK_LSHRREV_B16,
> +	GFX9_V_PK_ASHRREV_I16,
> +	GFX9_V_PK_MAX_I16,
> +	GFX9_V_PK_MIN_I16,
> +	GFX9_V_PK_MAD_U16,
> +	GFX9_V_PK_ADD_U16,
> +	GFX9_V_PK_SUB_U16,
> +	GFX9_V_PK_MAX_U16,
> +	GFX9_V_PK_MIN_U16,
> +	GFX9_V_PK_FMA_F16,
> +	GFX9_V_PK_ADD_F16,
> +	GFX9_V_PK_MUL_F16,
> +	GFX9_V_PK_MIN_F16,
> +	GFX9_V_PK_MAX_F16 = 18,
> +	GFX9_V_MAD_MIX_F32 = 32,
> +	GFX9_V_MAD_MIXLO_F16,
> +	GFX9_V_MAD_MIXHI_F16,
> +};
> +
> +#define GFX9_VOP3P_ENCODING			0x1a7
> +#define GFX9_VOP3P_SRC_SGPR_BASE		0
> +#define GFX9_VOP3P_SRC_VCC_LO		106
> +#define GFX9_VOP3P_SRC_VCC_HI		107
> +#define GFX9_VOP3P_SRC_TTPM_BASE		108
> +#define GFX9_VOP3P_SRC_M0			124
> +#define GFX9_VOP3P_SRC_NULL			125
> +#define GFX9_VOP3P_SRC_EXEC_LO		126
> +#define GFX9_VOP3P_SRC_EXEC_HI		127
> +#define GFX9_VOP3P_SRC_INTEGER_0		128
> +#define GFX9_VOP3P_SRC_INTEGER_MINUS_1	193
> +#define GFX9_VOP3P_SRC_SHARED_BASE		235
> +#define GFX9_VOP3P_SRC_SHARED_LIMIT		236
> +#define GFX9_VOP3P_SRC_PRIVATE_BASE		237
> +#define GFX9_VOP3P_SRC_PRIVATE_LIMIT		238
> +#define GFX9_VOP3P_SRC_POPS_EXITING_WAVE_ID	239
> +#define GFX9_VOP3P_SRC_SDWA			249
> +#define GFX9_VOP3P_SRC_DDP16			250
> +#define GFX9_VOP3P_SRC_VCCZ			251
> +#define GFX9_VOP3P_SRC_EXECZ			252
> +#define GFX9_VOP3P_SRC_SCC			253
> +#define GFX9_VOP3P_SRC_VGPR_BASE		256
> +
> +struct amdgcn_gfx9_sdwa {
> +	u32 src0:8;
> +	u32 dst_sel:3;
> +	u32 dst_u:2;
> +	u32 clmp:1;
> +	u32 omod:2;
> +	u32 src0_sel:3;
> +	u32 src0_sext:1;
> +	u32 src0_neg:1;
> +	u32 src0_abs:1;
> +	u32 dummy1:1;
> +	u32 s0:1;
> +	u32 src1_sel:3;
> +	u32 src1_sext:1;
> +	u32 src1_neg:1;
> +	u32 src1_abs:1;
> +	u32 dummy2:1;
> +	u32 s1:1;
> +};
> +
> +struct amdgcn_gfx9_sdwab {
> +	u32 src0:8;
> +	u32 sdst:7;
> +	u32 sd:1;
> +	u32 src0_sel:3;
> +	u32 src0_sext:1;
> +	u32 src0_neg:1;
> +	u32 src0_abs:1;
> +	u32 dummy1:1;
> +	u32 s0:1;
> +	u32 src1_sel:3;
> +	u32 src1_sext:1;
> +	u32 src1_neg:1;
> +	u32 src1_abs:1;
> +	u32 dummy2:1;
> +	u32 s1:1;
> +};
> +
> +struct amdgcn_gfx9_dpp16 {
> +};
> +
> +struct amdgcn_gfx9_dpp8 {
> +};
> +
> +/* Vector Parameter Interpolation Format */
> +struct amdgcn_gfx9_vintrp {
> +};
> +
> +/* LDS and GDS Format */
> +struct amdgcn_gfx9_ds {
> +	u64 offset0:8;
> +	u64 offset1:8;
> +	u64 gds:1;
> +	u64 op:9;	/* bits [25:17] */
> +	u64 encoding:6;	/* bits [31:26] = 0x36 */
> +	u64 addr:8;
> +	u64 data0:8;
> +	u64 data1:8;
> +	u64 vdst:8;
> +};
> +
> +enum amdgcn_gfx9_ds_opcode {
> +	GFX9_DS_ADD_U32,
> +	GFX9_DS_SUB_U32,
> +	GFX9_DS_RSUB_U32,
> +	GFX9_DS_INC_U32,
> +	GFX9_DS_DEC_U32,
> +	GFX9_DS_MIN_I32,
> +	GFX9_DS_MAX_I32,
> +	GFX9_DS_MIN_U32,
> +	GFX9_DS_MAX_U32,
> +	GFX9_DS_AND_B32,
> +	GFX9_DS_OR_B32,
> +	GFX9_DS_XOR_B32,
> +	GFX9_DS_MSKOR_B32,
> +	GFX9_DS_WRITE_B32,
> +	GFX9_DS_WRITE2_B32,
> +	GFX9_DS_WRITE2ST64_B32,
> +	GFX9_DS_CMPST_B32,
> +	GFX9_DS_CMPST_F32,
> +	GFX9_DS_MIN_F32,
> +	GFX9_DS_MAX_F32,
> +	GFX9_DS_NOP,
> +	GFX9_DS_ADD_F32 = 21,
> +	GFX9_DS_WRITE_ADDTID_B32 = 29,
> +	GFX9_DS_WRITE_B8,
> +	GFX9_DS_WRITE_B16,
> +	GFX9_DS_ADD_RTN_U32,
> +	GFX9_DS_SUB_RTN_U32,
> +	GFX9_DS_RSUB_RTN_U32,
> +	GFX9_DS_INC_RTN_U32,
> +	GFX9_DS_DEC_RTN_U32,
> +	GFX9_DS_MIN_RTN_I32,
> +	GFX9_DS_MAX_RTN_I32,
> +	GFX9_DS_MIN_RTN_U32,
> +	GFX9_DS_MAX_RTN_U32,
> +	GFX9_DS_AND_RTN_B32,
> +	GFX9_DS_OR_RTN_B32,
> +	GFX9_DS_XOR_RTN_B32,
> +	GFX9_DS_MSKOR_RTN_B32,
> +	GFX9_DS_WRXCHG_RTN_B32,
> +	GFX9_DS_WRXCHG2_RTN_B32,
> +	GFX9_DS_WRXCHG2ST64_RTN_B32,
> +	GFX9_DS_CMPST_RTN_B32,
> +	GFX9_DS_CMPST_RTN_F32,
> +	GFX9_DS_MIN_RTN_F32,
> +	GFX9_DS_MAX_RTN_F32,
> +	GFX9_DS_WRAP_RTN_B32,
> +	GFX9_DS_ADD_RTN_F32,
> +	GFX9_DS_READ_B32,
> +	GFX9_DS_READ2_B32,
> +	GFX9_DS_READ2ST64_B32,
> +	GFX9_DS_READ_I8,
> +	GFX9_DS_READ_U8,
> +	GFX9_DS_READ_I16,
> +	GFX9_DS_READ_U16,
> +	GFX9_DS_SWIZZLE_B32,
> +	GFX9_DS_PERMUTE_B32,
> +	GFX9_DS_BPERMUTE_B32,
> +	GFX9_DS_ADD_U64,
> +	GFX9_DS_SUB_U64,
> +	GFX9_DS_RSUB_U64,
> +	GFX9_DS_INC_U64,
> +	GFX9_DS_DEC_U64,
> +	GFX9_DS_MIN_I64,
> +	GFX9_DS_MAX_I64,
> +	GFX9_DS_MIN_U64,
> +	GFX9_DS_MAX_U64,
> +	GFX9_DS_AND_B64,
> +	GFX9_DS_OR_B64,
> +	GFX9_DS_XOR_B64,
> +	GFX9_DS_MSKOR_B64,
> +	GFX9_DS_WRITE_B64,
> +	GFX9_DS_WRITE2_B64,
> +	GFX9_DS_WRITE2ST64_B64,
> +	GFX9_DS_CMPST_B64,
> +	GFX9_DS_CMPST_F64,
> +	GFX9_DS_MIN_F64,
> +	GFX9_DS_MAX_F64,
> +	GFX9_DS_WRITE_B8_D16_HI,
> +	GFX9_DS_WRITE_B16_D16_HI,
> +	GFX9_DS_READ_U8_D16,
> +	GFX9_DS_READ_U8_D16_HI,
> +	GFX9_DS_READ_I8_D16,
> +	GFX9_DS_READ_I8_D16_HI,
> +	GFX9_DS_READ_U16_D16,
> +	GFX9_DS_READ_U16_D16_HI = 91,
> +	GFX9_DS_ADD_RTN_U64 = 96,
> +	GFX9_DS_SUB_RTN_U64,
> +	GFX9_DS_RSUB_RTN_U64,
> +	GFX9_DS_INC_RTN_U64,
> +	GFX9_DS_DEC_RTN_U64,
> +	GFX9_DS_MIN_RTN_I64,
> +	GFX9_DS_MAX_RTN_I64,
> +	GFX9_DS_MIN_RTN_U64,
> +	GFX9_DS_MAX_RTN_U64,
> +	GFX9_DS_AND_RTN_B64,
> +	GFX9_DS_OR_RTN_B64,
> +	GFX9_DS_XOR_RTN_B64,
> +	GFX9_DS_MSKOR_RTN_B64,
> +	GFX9_DS_WRXCHG_RTN_B64,
> +	GFX9_DS_WRXCHG2_RTN_B64,
> +	GFX9_DS_WRXCHG2ST64_RTN_B64,
> +	GFX9_DS_CMPST_RTN_B64,
> +	GFX9_DS_CMPST_RTN_F64,
> +	GFX9_DS_MIN_RTN_F64,
> +	GFX9_DS_MAX_RTN_F64 = 115,
> +	GFX9_DS_READ_B64 = 118,
> +	GFX9_DS_READ2_B64 = 119,
> +	GFX9_DS_READ2ST64_B64 = 120,
> +	/* ISA opcodes 121-125 are reserved gaps. */
> +	GFX9_DS_CONDXCHG32_RTN_B64 = 126,
> +	/* ISA opcode 127 is a reserved gap. */
> +	GFX9_DS_ADD_SRC2_U32 = 128,
> +	GFX9_DS_SUB_SRC2_U32,
> +	GFX9_DS_RSUB_SRC2_U32,
> +	GFX9_DS_INC_SRC2_U32,
> +	GFX9_DS_DEC_SRC2_U32,
> +	GFX9_DS_MIN_SRC2_I32,
> +	GFX9_DS_MAX_SRC2_I32,
> +	GFX9_DS_MIN_SRC2_U32,
> +	GFX9_DS_MAX_SRC2_U32,
> +	GFX9_DS_AND_SRC2_B32,
> +	GFX9_DS_OR_SRC2_B32,
> +	GFX9_DS_XOR_SRC2_B32 = 139,
> +	GFX9_DS_WRITE_SRC2_B32 = 141,
> +	GFX9_DS_MIN_SRC2_F32 = 146,
> +	GFX9_DS_MAX_SRC2_F32 = 147,
> +	GFX9_DS_ADD_SRC2_F32 = 149,
> +	GFX9_DS_GWS_SEMA_RELEASE_ALL = 152,
> +	GFX9_DS_GWS_INIT,
> +	GFX9_DS_GWS_SEMA_V,
> +	GFX9_DS_GWS_SEMA_BR,
> +	GFX9_DS_GWS_SEMA_P,
> +	GFX9_DS_GWS_BARRIER = 157,
> +	GFX9_DS_READ_ADDTID_B32 = 182,
> +	GFX9_DS_CONSUME = 189,
> +	GFX9_DS_APPEND,
> +	GFX9_DS_ORDERED_COUNT,
> +	GFX9_DS_ADD_SRC2_U64,
> +	GFX9_DS_SUB_SRC2_U64,
> +	GFX9_DS_RSUB_SRC2_U64,
> +	GFX9_DS_INC_SRC2_U64,
> +	GFX9_DS_DEC_SRC2_U64,
> +	GFX9_DS_MIN_SRC2_I64,
> +	GFX9_DS_MAX_SRC2_I64,
> +	GFX9_DS_MIN_SRC2_U64,
> +	GFX9_DS_MAX_SRC2_U64,
> +	GFX9_DS_AND_SRC2_B64,
> +	GFX9_DS_OR_SRC2_B64,
> +	GFX9_DS_XOR_SRC2_B64 = 203,
> +	GFX9_DS_WRITE_SRC2_B64 = 205,
> +	GFX9_DS_MIN_SRC2_F64 = 210,
> +	GFX9_DS_MAX_SRC2_F64 = 211,
> +	GFX9_DS_WRITE_B96 = 222,
> +	GFX9_DS_WRITE_B128 = 223,
> +	GFX9_DS_READ_B96 = 254,
> +	GFX9_DS_READ_B128 = 255,
> +};
> +
> +#define GFX9_DS_ENCODING		0x36
> +#define GFX9_DS_GDS			1
> +#define GFX9_DS_LDS			0
> +
> +////////////////////////////////////////////////////
> +/* Vector Memory Buffer Formats */
> +struct amdgcn_gfx9_mtbuf {
> +	u64 offset:12;
> +	u64 offen:1;
> +	u64 idxen:1;
> +	u64 glc:1;
> +	u64 op:4;
> +	u64 dfmt:4;
> +	u64 nfmt:3;
> +	u64 encoding:6;
> +	u64 vaddr:8;
> +	u64 vdata:8;
> +	u64 srsrc:5;
> +	u64 dummy:1;
> +	u64 slc:1;
> +	u64 tfe:1;
> +	u64 soffset:8;
> +};
> +
> +enum amdgcn_gfx9_mtbuf_opcode {
> +	GFX9_TBUFFER_LOAD_FORMAT_X,
> +	GFX9_TBUFFER_LOAD_FORMAT_XY,
> +	GFX9_TBUFFER_LOAD_FORMAT_XYZ,
> +	GFX9_TBUFFER_LOAD_FORMAT_XYZW,
> +	GFX9_TBUFFER_STORE_FORMAT_X,
> +	GFX9_TBUFFER_STORE_FORMAT_XY,
> +	GFX9_TBUFFER_STORE_FORMAT_XYZ,
> +	GFX9_TBUFFER_STORE_FORMAT_XYZW,
> +	GFX9_TBUFFER_LOAD_FORMAT_D16_X,
> +	GFX9_TBUFFER_LOAD_FORMAT_D16_XY,
> +	GFX9_TBUFFER_LOAD_FORMAT_D16_XYZ,
> +	GFX9_TBUFFER_LOAD_FORMAT_D16_XYZW,
> +	GFX9_TBUFFER_STORE_FORMAT_D16_X,
> +	GFX9_TBUFFER_STORE_FORMAT_D16_XY,
> +	GFX9_TBUFFER_STORE_FORMAT_D16_XYZ,
> +	GFX9_TBUFFER_STORE_FORMAT_D16_XYZW,
> +};
> +
> +#define GFX9_MUBUF_ENCODING				0x38
> +#define GFX9_MUBUF_SOFFSET_SGPR_BASE			0
> +#define GFX9_MUBUF_SOFFSET_VCC_LO			106
> +#define GFX9_MUBUF_SOFFSET_VCC_HI			107
> +#define GFX9_MUBUF_SOFFSET_TTPM_BASE			108
> +#define GFX9_MUBUF_SOFFSET_M0				124
> +#define GFX9_MUBUF_SOFFSET_NULL			125
> +#define GFX9_MUBUF_SOFFSET_EXEC_LO			126
> +#define GFX9_MUBUF_SOFFSET_EXEC_HI			127
> +#define GFX9_MUBUF_SOFFSET_INTEGER_0			128
> +#define GFX9_MUBUF_SOFFSET_INTEGER_MINUS_1		193
> +#define GFX9_MUBUF_SOFFSET_SHARED_BASE			235
> +#define GFX9_MUBUF_SOFFSET_SHARED_LIMIT		236
> +#define GFX9_MUBUF_SOFFSET_PRIVATE_BASE		237
> +#define GFX9_MUBUF_SOFFSET_PRIVATE_LIMIT		238
> +#define GFX9_MUBUF_SOFFSET_POPS_EXITING_WAVE_ID	239
> +#define GFX9_MUBUF_SOFFSET_VCCZ			251
> +#define GFX9_MUBUF_SOFFSET_EXECZ			252
> +#define GFX9_MUBUF_SOFFSET_SCC				253
> +
> +struct amdgcn_gfx9_mubuf {
> +	u64 offset:12;
> +	u64 offen:1;
> +	u64 idxen:1;
> +	u64 glc:1;
> +	u64 dummy1:1;
> +	u64 lds:1;
> +	u64 slc:1;
> +	u64 op:7;
> +	u64 dummy2:1;
> +	u64 encoding:6;
> +	u64 vaddr:8;
> +	u64 vdata:8;
> +	u64 srsrc:5;
> +	u64 dummy3:2;
> +	u64 tfe:1;
> +	u64 soffset:8;
> +};
> +
> +enum amdgcn_gfx9_mubuf_opcode {
> +	GFX9_BUFFER_LOAD_FORMAT_X,
> +	GFX9_BUFFER_LOAD_FORMAT_XY,
> +	GFX9_BUFFER_LOAD_FORMAT_XYZ,
> +	GFX9_BUFFER_LOAD_FORMAT_XYZW,
> +	GFX9_BUFFER_STORE_FORMAT_X,
> +	GFX9_BUFFER_STORE_FORMAT_XY,
> +	GFX9_BUFFER_STORE_FORMAT_XYZ,
> +	GFX9_BUFFER_STORE_FORMAT_XYZW,
> +	GFX9_BUFFER_LOAD_FORMAT_D16_X,
> +	GFX9_BUFFER_LOAD_FORMAT_D16_XY,
> +	GFX9_BUFFER_LOAD_FORMAT_D16_XYZ,
> +	GFX9_BUFFER_LOAD_FORMAT_D16_XYZW,
> +	GFX9_BUFFER_STORE_FORMAT_D16_X,
> +	GFX9_BUFFER_STORE_FORMAT_D16_XY,
> +	GFX9_BUFFER_STORE_FORMAT_D16_XYZ,
> +	GFX9_BUFFER_STORE_FORMAT_D16_XYZW,
> +	GFX9_BUFFER_LOAD_UBYTE,
> +	GFX9_BUFFER_LOAD_SBYTE,
> +	GFX9_BUFFER_LOAD_USHORT,
> +	GFX9_BUFFER_LOAD_SSHORT,
> +	GFX9_BUFFER_LOAD_DWORD,
> +	GFX9_BUFFER_LOAD_DWORDX2,
> +	GFX9_BUFFER_LOAD_DWORDX3,
> +	GFX9_BUFFER_LOAD_DWORDX4,
> +	GFX9_BUFFER_STORE_BYTE,
> +	GFX9_BUFFER_STORE_BYTE_D16_HI,
> +	GFX9_BUFFER_STORE_SHORT,
> +	GFX9_BUFFER_STORE_SHORT_D16_HI,
> +	GFX9_BUFFER_STORE_DWORD,
> +	GFX9_BUFFER_STORE_DWORDX2,
> +	GFX9_BUFFER_STORE_DWORDX3,
> +	GFX9_BUFFER_STORE_DWORDX4,
> +	GFX9_BUFFER_LOAD_UBYTE_D16,
> +	GFX9_BUFFER_LOAD_UBYTE_D16_HI,
> +	GFX9_BUFFER_LOAD_SBYTE_D16,
> +	GFX9_BUFFER_LOAD_SBYTE_D16_HI,
> +	GFX9_BUFFER_LOAD_SHORT_D16,
> +	GFX9_BUFFER_LOAD_SHORT_D16_HI,
> +	GFX9_BUFFER_LOAD_FORMAT_D16_HI_X,
> +	GFX9_BUFFER_STORE_FORMAT_D16_HI_X = 39,
> +	GFX9_BUFFER_STORE_LDS_DWORD = 61,
> +	GFX9_BUFFER_WBINVL1,
> +	GFX9_BUFFER_WBINVL1_VOL,
> +	GFX9_BUFFER_ATOMIC_SWAP,
> +	GFX9_BUFFER_ATOMIC_CMPSWAP,
> +	GFX9_BUFFER_ATOMIC_ADD,
> +	GFX9_BUFFER_ATOMIC_SUB,
> +	GFX9_BUFFER_ATOMIC_SMIN,
> +	GFX9_BUFFER_ATOMIC_UMIN,
> +	GFX9_BUFFER_ATOMIC_SMAX,
> +	GFX9_BUFFER_ATOMIC_UMAX,
> +	GFX9_BUFFER_ATOMIC_AND,
> +	GFX9_BUFFER_ATOMIC_OR,
> +	GFX9_BUFFER_ATOMIC_XOR,
> +	GFX9_BUFFER_ATOMIC_INC,
> +	GFX9_BUFFER_ATOMIC_DEC = 76,
> +	GFX9_BUFFER_ATOMIC_SWAP_X2 = 96,
> +	GFX9_BUFFER_ATOMIC_CMPSWAP_X2,
> +	GFX9_BUFFER_ATOMIC_ADD_X2,
> +	GFX9_BUFFER_ATOMIC_SUB_X2,
> +	GFX9_BUFFER_ATOMIC_SMIN_X2,
> +	GFX9_BUFFER_ATOMIC_UMIN_X2,
> +	GFX9_BUFFER_ATOMIC_SMAX_X2,
> +	GFX9_BUFFER_ATOMIC_UMAX_X2,
> +	GFX9_BUFFER_ATOMIC_AND_X2,
> +	GFX9_BUFFER_ATOMIC_OR_X2,
> +	GFX9_BUFFER_ATOMIC_XOR_X2,
> +	GFX9_BUFFER_ATOMIC_INC_X2,
> +	GFX9_BUFFER_ATOMIC_DEC_X2,
> +};
> +
> +/* Vector Memory Image Format */
> +struct amdgcn_gfx9_mimg {
> +};
> +
> +#define GFX9_FLAT_ENCODING			0x37
> +#define GFX9_FLAT_SADDR_SGPR_BASE		0
> +#define GFX9_FLAT_SADDR_VCC_LO			106
> +#define GFX9_FLAT_SADDR_VCC_HI			107
> +#define GFX9_FLAT_SADDR_TTPM_BASE		108
> +#define GFX9_FLAT_SADDR_M0			124
> +#define GFX9_FLAT_SADDR_NULL			125
> +#define GFX9_FLAT_SADDR_EXEC_LO			126
> +#define GFX9_FLAT_SADDR_EXEC_HI			127
> +#define GFX9_FLAT_SADDR_INTEGER_0		128
> +#define GFX9_FLAT_SADDR_INTEGER_MINUS_1		193
> +#define GFX9_FLAT_SADDR_SHARED_BASE		235
> +#define GFX9_FLAT_SADDR_SHARED_LIMIT		236
> +#define GFX9_FLAT_SADDR_PRIVATE_BASE		237
> +#define GFX9_FLAT_SADDR_PRIVATE_LIMIT		238
> +#define GFX9_FLAT_SADDR_POPS_EXITING_WAVE_ID	239
> +#define GFX9_FLAT_SADDR_VCCZ			251
> +#define GFX9_FLAT_SADDR_EXECZ			252
> +#define GFX9_FLAT_SADDR_SCC			253
> +
> +/*
> + * Scalar SGPR that provides an offset address. To disable, set this field to
> + * 0x7F. Meaning of this field is different for Scratch and Global:
> + * Flat: Unused.
> + * Scratch: Use an SGPR (instead of VGPR) for the address.
> + * Global: Use the SGPR to provide a base address; the VGPR provides a
> + *         32-bit offset.
> + */
> +#define GFX9_FLAT_SADDR_DISABLE			0x7f
> +#define GFX9_FLAT_SEG_FLAT			0
> +#define GFX9_FLAT_SEG_SCRATCH			1
> +#define GFX9_FLAT_SEG_GLOBAL			2
> +
> +/* Flat Formats */
> +struct amdgcn_gfx9_flat {
> +	u64 offset:13;
> +	u64 lds:1;
> +	u64 seg:2;
> +	u64 glc:1;
> +	u64 slc:1;
> +	u64 op:7;
> +	u64 dummy:1;
> +	u64 encoding:6;
> +	u64 addr:8;
> +	u64 data:8;
> +	u64 saddr:7;
> +	u64 nv:1;
> +	u64 vdst:8;
> +};
> +
> +enum amdgcn_gfx9_global_opcode {
> +	GFX9_GLOBAL_LOAD_UBYTE = 16,
> +	GFX9_GLOBAL_LOAD_SBYTE,
> +	GFX9_GLOBAL_LOAD_USHORT,
> +	GFX9_GLOBAL_LOAD_SSHORT,
> +	GFX9_GLOBAL_LOAD_DWORD,
> +	GFX9_GLOBAL_LOAD_DWORDX2,
> +	GFX9_GLOBAL_LOAD_DWORDX3,
> +	GFX9_GLOBAL_LOAD_DWORDX4,
> +	GFX9_GLOBAL_STORE_BYTE,
> +	GFX9_GLOBAL_STORE_BYTE_D16_HI,
> +	GFX9_GLOBAL_STORE_SHORT,
> +	GFX9_GLOBAL_STORE_SHORT_D16_HI,
> +	GFX9_GLOBAL_STORE_DWORD,
> +	GFX9_GLOBAL_STORE_DWORDX2,
> +	GFX9_GLOBAL_STORE_DWORDX3,
> +	GFX9_GLOBAL_STORE_DWORDX4,
> +	GFX9_GLOBAL_LOAD_UBYTE_D16,
> +	GFX9_GLOBAL_LOAD_UBYTE_D16_HI,
> +	GFX9_GLOBAL_LOAD_SBYTE_D16,
> +	GFX9_GLOBAL_LOAD_SBYTE_D16_HI,
> +	GFX9_GLOBAL_LOAD_SHORT_D16,
> +	GFX9_GLOBAL_LOAD_SHORT_D16_HI = 37,
> +	GFX9_GLOBAL_ATOMIC_SWAP = 64,
> +	GFX9_GLOBAL_ATOMIC_CMPSWAP,
> +	GFX9_GLOBAL_ATOMIC_ADD,
> +	GFX9_GLOBAL_ATOMIC_SUB,
> +	GFX9_GLOBAL_ATOMIC_SMIN,
> +	GFX9_GLOBAL_ATOMIC_UMIN,
> +	GFX9_GLOBAL_ATOMIC_SMAX,
> +	GFX9_GLOBAL_ATOMIC_UMAX,
> +	GFX9_GLOBAL_ATOMIC_AND,
> +	GFX9_GLOBAL_ATOMIC_OR,
> +	GFX9_GLOBAL_ATOMIC_XOR,
> +	GFX9_GLOBAL_ATOMIC_INC,
> +	GFX9_GLOBAL_ATOMIC_DEC = 76,
> +	GFX9_GLOBAL_ATOMIC_SWAP_X2 = 96,
> +	GFX9_GLOBAL_ATOMIC_CMPSWAP_X2,
> +	GFX9_GLOBAL_ATOMIC_ADD_X2,
> +	GFX9_GLOBAL_ATOMIC_SUB_X2,
> +	GFX9_GLOBAL_ATOMIC_SMIN_X2,
> +	GFX9_GLOBAL_ATOMIC_UMIN_X2,
> +	GFX9_GLOBAL_ATOMIC_SMAX_X2,
> +	GFX9_GLOBAL_ATOMIC_UMAX_X2,
> +	GFX9_GLOBAL_ATOMIC_AND_X2,
> +	GFX9_GLOBAL_ATOMIC_OR_X2,
> +	GFX9_GLOBAL_ATOMIC_XOR_X2,
> +	GFX9_GLOBAL_ATOMIC_INC_X2,
> +	GFX9_GLOBAL_ATOMIC_DEC_X2,
> +};
> +
> +/* Export Format */
> +struct amdgcn_gfx9_exp {
> +};
> +
> +union amdgcn_gfx9_insn {
> +	struct amdgcn_gfx9_sop2 sop2;
> +	struct amdgcn_gfx9_sopk sopk;
> +	struct amdgcn_gfx9_sop1 sop1;
> +	struct amdgcn_gfx9_sopc sopc;
> +	struct amdgcn_gfx9_sopp sopp;
> +	struct amdgcn_gfx9_smem smem;
> +	struct amdgcn_gfx9_vop2 vop2;
> +	struct amdgcn_gfx9_vop1 vop1;
> +	struct amdgcn_gfx9_vopc vopc;
> +	struct amdgcn_gfx9_vop3a vop3a;
> +	struct amdgcn_gfx9_vop3b vop3b;
> +	struct amdgcn_gfx9_vop3p vop3p;
> +	struct amdgcn_gfx9_sdwa sdwa;
> +	struct amdgcn_gfx9_sdwab sdwab;
> +	struct amdgcn_gfx9_dpp16 dpp16;
> +	struct amdgcn_gfx9_dpp8 dpp8;
> +	struct amdgcn_gfx9_vintrp vintrp;
> +	struct amdgcn_gfx9_ds ds;
> +	struct amdgcn_gfx9_mtbuf mtbuf;
> +	struct amdgcn_gfx9_mubuf mubuf;
> +	struct amdgcn_gfx9_mimg mimg;
> +	struct amdgcn_gfx9_flat flat;
> +	struct amdgcn_gfx9_exp exp;
> +};
> +
> +/* Cast macro - convert u32 *buf position to GFX9 insn union pointer. */
> +#define I9(buf, n)	((union amdgcn_gfx9_insn *)&(buf)[(n)])
> +
> +inline u32 gfx9_get_param_base(struct amdgcn_param32 param)
> +{
> +	return gfx9_param_base[param.type];
> +}
> +
> +inline u32 emit_gfx9_s_load_dwordx2(union amdgcn_gfx9_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src, int offset)
> +{
> +	/* s_load_dwordx2 <dst/sdata>, <src/sbase>, <offset>
> +	 * sdata: register, load to.
> +	 * sbase: sgpr-pair, load from.
> +	 * offset: offset of kernarg_address in the hsa_kernel_dispatch_packet.
> +	 *
> +	 * sdata = *(sbase + offset);
> +	 * param = (__global struct _knod_bpf_param *)pkt.kernarg_address;
> +	 */
> +
> +	insn->smem.sbase = KNOD_AMDGPU_REG_PAIR(src.v);
> +	insn->smem.sdata = dst.v;
> +	insn->smem.dummy1 = 0;
> +	insn->smem.soe = 0;
> +	insn->smem.nv = 0;
> +	insn->smem.glc = 0;
> +	insn->smem.imm = 1;
> +	insn->smem.op = GFX9_S_LOAD_DWORDX2;
> +	insn->smem.encoding = GFX9_SMEM_ENCODING;
> +	insn->smem.offset = offset;
> +	insn->smem.dummy2 = 0;
> +	insn->smem.soffset = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_bfe_i32(union amdgcn_gfx9_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1,
> +			       struct amdgcn_param32 src2)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_BFE_I32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_bfe_u32(union amdgcn_gfx9_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1,
> +			       struct amdgcn_param32 src2)
> +{
> +	/* v_bfe_u32 v0, v0, 8
> +	 * <dst>: destination vgpr.
> +	 * <src>: initialized to workitem in first bitfields.
> +	 * 8: bitfield size to extract from.
> +	 *
> +	 * extract workitem ID from <src>
> +	 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_BFE_U32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_bfi_b32(union amdgcn_gfx9_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1,
> +			       struct amdgcn_param32 src2)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_BFI_B32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_lshl_add_u32(union amdgcn_gfx9_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1,
> +				    struct amdgcn_param32 src2)
> +{
> +	/* v_lshl_add_u32 <dst>, <src0>, <src1>, <src2>
> +	 *
> +	 * <dst> = (<src0> << <src1>) + <src2>;
> +	 */
> +
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_LSHL_ADD_U32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_lshl_or_b32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1,
> +				   struct amdgcn_param32 src2)
> +{
> +	/* v_lshl_or_b32 <dst>, <src0>, <src1>, <src2>
> +	 *
> +	 * D.u = (S0.u << S1.u[4:0]) | S2.u
> +	 */
> +
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_LSHL_OR_B32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_mad_u64_u32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param64 vdst,
> +				   struct amdgcn_param32 sdst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1,
> +				   struct amdgcn_param64 src2)
> +{
> +	/* v_mad_u64_u32 <dst>, <dst2>, <src0_imm>, <src1>, <src2>
> +	 * <vdst>: destination vgpr.
> +	 * <sdst>: destination sgpr.
> +	 * <src0>: source vgpr.
> +	 * <src1>: source vgpr.
> +	 * <src2>: source vgpr.
> +	 *
> +	 * {vcc_out, D.u64} = S0.u32 * S1.u32 + S2.u64.
> +	 * ctx = &param->sub[idx].ctx;
> +	 */
> +
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.hi.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3b.vdst = vdst.lo.v;
> +	insn->vop3b.sdst = sdst.v;
> +	insn->vop3b.clmp = 0;
> +	insn->vop3b.op = GFX9_V_MAD_U64_U32;
> +	insn->vop3b.encoding = GFX9_VOP3B_ENCODING;
> +	insn->vop3b.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3b.src2 = gfx9_get_param_base(src2.lo) + src2.lo.v;
> +	insn->vop3b.omod = 0;
> +	insn->vop3b.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3b.src0 = gfx9_get_param_base(src0);
> +		insn->vop3b.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3b.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_s_mov_b32(union amdgcn_gfx9_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src)
> +{
> +	if (src.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->sop1.ssrc0 = gfx9_get_param_base(src);
> +		insn->sop1.literal = src.v;
> +	} else {
> +		insn->sop1.ssrc0 = gfx9_get_param_base(src) + src.v;
> +	}
> +	insn->sop1.op = GFX9_S_MOV_B32;
> +	insn->sop1.sdst = gfx9_get_param_base(dst) + dst.v;
> +	insn->sop1.encoding = GFX9_SOP1_ENCODING;
> +
> +	if (src.type == AMDGCN_PARAM_TYPE_LITERAL_CONST)
> +		return 8;
> +	return 4;
> +}
> +
> +/*
> + * v_readfirstlane_b32 sdst, vsrc
> + * Copies VGPR[vsrc] from the first active lane to SGPR[sdst].
> + * VOP1 encoding, dst = SGPR (not VGPR).
> + */
> +inline u32 emit_gfx9_v_readfirstlane_b32(union amdgcn_gfx9_insn *insn,
> +					  u8 sdst, u8 vsrc)
> +{
> +	insn->vop1.encoding = GFX9_VOP1_ENCODING;
> +	insn->vop1.vdst = sdst;
> +	insn->vop1.op = GFX9_V_READFIRSTLANE_B32;
> +	insn->vop1.src0 = GFX9_SRC_VGPR_BASE + vsrc;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_mov_b32_e32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	if (dst.type != AMDGCN_PARAM_TYPE_VGPR)
> +		WARN_ON_ONCE(1);
> +	insn->vop1.encoding = GFX9_VOP1_ENCODING;
> +	insn->vop1.vdst = dst.v;
> +	insn->vop1.op = GFX9_V_MOV_B32;
> +	if (src.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop1.src0 = GFX9_VOP1_SRC_LITERAL_CONST;
> +		insn->vop1.literal = src.v;
> +
> +		return 8;
> +	}
> +	insn->vop1.src0 = gfx9_get_param_base(src) + src.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_add_co_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_ADD_CO_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_add_u32(union amdgcn_gfx9_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_ADD_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_sub_u32(union amdgcn_gfx9_insn *insn,
> +			       struct amdgcn_param32 dst,
> +			       struct amdgcn_param32 src0,
> +			       struct amdgcn_param32 src1)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_SUB_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_addc_co_u32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_ADDC_CO_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		WARN_ON_ONCE(1);
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_xor_b32_e32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_XOR_B32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_or_b32_e32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_OR_B32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cndmask_b32_e32(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src0,
> +				       struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_CNDMASK_B32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_and_b32_e32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_AND_B32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_sub_co_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1)
> +{
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_SUB_CO_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_subrev_co_u32(union amdgcn_gfx9_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1)
> +{
> +	/* D.u = S1.u - S0.u; */
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_SUBREV_CO_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_subbrev_co_u32(union amdgcn_gfx9_insn *insn,
> +				     struct amdgcn_param32 dst,
> +				     struct amdgcn_param32 src0,
> +				     struct amdgcn_param32 src1)
> +{
> +	/* D.u = S1.u - S0.u; */
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_SUBBREV_CO_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_subb_co_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1)
> +
> +{
> +	/* dst = src0 - src1 */
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_SUBB_CO_U32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_mul_lo_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_MUL_LO_U32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +/* v_mbcnt_lo_u32_b32 vdst, src0, vsrc1
> + * vdst = popcount(src0 & ((1 << lane_id[4:0]) - 1)) + vsrc1
> + */
> +inline u32 emit_gfx9_v_mbcnt_lo_u32_b32(union amdgcn_gfx9_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src0,
> +					 struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_MBCNT_LO_U32_B32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +
> +	return 8;
> +}
> +
> +/* v_mbcnt_hi_u32_b32 vdst, src0, vsrc1
> + * vdst = popcount(src0 & ((1 << lane_id[5]) - 1)) + vsrc1
> + */
> +inline u32 emit_gfx9_v_mbcnt_hi_u32_b32(union amdgcn_gfx9_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src0,
> +					 struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_MBCNT_HI_U32_B32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_mul_hi_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src0,
> +				  struct amdgcn_param32 src1)
> +{
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_MUL_HI_U32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_lshlrev_b64(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src0,
> +				   struct amdgcn_param64 src1)
> +{
> +	/* dst = s1 << s0 */
> +	insn->vop3a.vdst = dst.lo.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_LSHLREV_B64;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1.lo) + src1.lo.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0.lo);
> +		insn->vop3a.literal = src0.lo.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0.lo) + src0.lo.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_lshlrev_b32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	/* dst = s1 << s0 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_LSHLREV_B32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_lshrrev_b32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	/* dst = s1 << s0 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_LSHRREV_B32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_lshrrev_b64(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src0,
> +				   struct amdgcn_param64 src1)
> +{
> +	/* dst = s1 >> s0 */
> +	insn->vop3a.vdst = dst.lo.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_LSHRREV_B64;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1.lo) + src1.lo.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0.lo);
> +		insn->vop3a.literal = src0.lo.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0.lo) + src0.lo.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_ashrrev_i64(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param64 dst,
> +				   struct amdgcn_param64 src0,
> +				   struct amdgcn_param64 src1)
> +{
> +	/* dst = s1 >> s0 */
> +	insn->vop3a.vdst = dst.lo.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_ASHRREV_I64;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1.lo) + src1.lo.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.lo.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0.lo);
> +		insn->vop3a.literal = src0.lo.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0.lo) + src0.lo.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_ashrrev_i32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src0,
> +				   struct amdgcn_param32 src1)
> +{
> +	/* dst = s1 >> s0 */
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	/*
> +	 * VOP2 ops encoded in VOP3A use opcode 0x100 + vop2_op (V_ASHRREV_I32
> +	 * is a VOP2 instruction). Without the +0x100 the op field decodes as a
> +	 * different VOP3A instruction, so the arithmetic shift (used for 64-bit
> +	 * sign-extension, e.g. bpf_xdp_adjust_head's delta) produced garbage.
> +	 */
> +	insn->vop3a.op = GFX9_V_ASHRREV_I32 + 0x100;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	/* 128: src2=0 reads s0 on gfx9 */
> +	insn->vop3a.src2 = GFX9_SRC_INTEGER_0;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_alignbit_b32(union amdgcn_gfx9_insn *insn,
> +				    struct amdgcn_param32 dst,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1,
> +				    struct amdgcn_param32 src2)
> +{
> +	/* D.u = ({S0,S1} >> S2.u[4:0]) & 0xffffffff. */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_ALIGNBIT_B32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop3a.src0 = gfx9_get_param_base(src0);
> +		insn->vop3a.literal = src0.v;
> +		return 12;
> +	}
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_perm_b32(union amdgcn_gfx9_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1,
> +				struct amdgcn_param32 src2)
> +{
> +	/*
> +	 * v_perm_b32: D.u[31:24] = src[sel[14:12]],
> +	 *             D.u[23:16] = src[sel[10:8]], ...
> +	 * For bswap32: sel = 0x00010203 reverses bytes.
> +	 */
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	/* VOP3 does not support literal constants on GFX9 */
> +	WARN_ON(src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src1.type == AMDGCN_PARAM_TYPE_LITERAL_CONST ||
> +		src2.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	insn->vop3a.vdst = dst.v;
> +	insn->vop3a.abs = 0;
> +	insn->vop3a.op_sel = 0;
> +	insn->vop3a.clmp = 0;
> +	insn->vop3a.op = GFX9_V_PERM_B32;
> +	insn->vop3a.encoding = GFX9_VOP3A_ENCODING;
> +	insn->vop3a.src0 = gfx9_get_param_base(src0) + src0.v;
> +	insn->vop3a.src1 = gfx9_get_param_base(src1) + src1.v;
> +	insn->vop3a.src2 = gfx9_get_param_base(src2) + src2.v;
> +	insn->vop3a.omod = 0;
> +	insn->vop3a.neg = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_eq_u64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 == S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_EQ_U64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_eq_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/*
> +	 * VOPC src0 supports SGPR/inline/VGPR but NOT literal
> +	 * (no 8-byte path)
> +	 */
> +	WARN_ON(dst.type == AMDGCN_PARAM_TYPE_LITERAL_CONST);
> +	WARN_ON(src.type != AMDGCN_PARAM_TYPE_VGPR);
> +	/* VCC = S0 == S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_EQ_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_gt_u64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 > S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_GT_U64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_gt_i64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 > S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_GT_I64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_ge_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 >= S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_GE_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_gt_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 > S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_GT_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_lt_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 < S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_LT_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_le_u32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 <= S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_LE_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_gt_i32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 > S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_GT_I32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_ge_i32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 >= S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_GE_I32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_lt_i32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 < S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_LT_I32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_le_i32(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param32 dst,
> +				  struct amdgcn_param32 src)
> +{
> +	/* VCC = S0 <= S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMP_LE_I32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmpx_lt_u32(union amdgcn_gfx9_insn *insn,
> +				   struct amdgcn_param32 dst,
> +				   struct amdgcn_param32 src)
> +{
> +	/* EXEC &= (S0 < S1) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst) + dst.v;
> +	insn->vopc.vsrc1 = src.v;
> +	insn->vopc.op = GFX9_V_CMPX_LT_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_ge_u64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 >= S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_GE_U64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_ge_i64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 >= S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_GE_I64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_lt_u64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 < S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_LT_U64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_lt_i64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 < S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_LT_I64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_le_u64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 <= S1 */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_LE_U64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_v_cmp_le_i64(union amdgcn_gfx9_insn *insn,
> +				  struct amdgcn_param64 dst,
> +				  struct amdgcn_param64 src)
> +{
> +	/* VCC = S0 <= S1 (signed) */
> +	insn->vopc.src0 = gfx9_get_param_base(dst.lo) + dst.lo.v;
> +	insn->vopc.vsrc1 = src.lo.v;
> +	insn->vopc.op = GFX9_V_CMP_LE_I64;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_buffer_load_ubyte(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src,
> +				       short off)
> +{
> +	/* buffer_load_ubyte <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.op = GFX9_BUFFER_LOAD_UBYTE;
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.encoding = GFX9_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy3 = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX9_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_buffer_load_ushort(union amdgcn_gfx9_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src,
> +					short off)
> +{
> +	/* buffer_load_ushort <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.op = GFX9_BUFFER_LOAD_USHORT;
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.encoding = GFX9_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy3 = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX9_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_buffer_load_dword(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src,
> +				       short off)
> +{
> +	/* buffer_load_dword <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.op = GFX9_BUFFER_LOAD_DWORD;
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.encoding = GFX9_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy3 = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX9_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_buffer_load_dwordx2(union amdgcn_gfx9_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src,
> +					 short off)
> +{
> +	/* buffer_load_dwordx2 <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.op = GFX9_BUFFER_LOAD_DWORDX2;
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.encoding = GFX9_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy3 = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX9_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_buffer_load_dwordx4(union amdgcn_gfx9_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src,
> +					 short off)
> +{
> +	/* buffer_load_dwordx4 <dst>, <src>, s[0:3], 0 offen offset:<off> */
> +	insn->mubuf.offset = off;
> +	insn->mubuf.offen = 1;
> +	insn->mubuf.idxen = 0;
> +	insn->mubuf.glc = 0;
> +	insn->mubuf.dummy1 = 0;
> +	insn->mubuf.lds = 0;
> +	insn->mubuf.op = GFX9_BUFFER_LOAD_DWORDX4;
> +	insn->mubuf.dummy2 = 0;
> +	insn->mubuf.encoding = GFX9_MUBUF_ENCODING;
> +	insn->mubuf.vaddr = src.v;
> +	insn->mubuf.vdata = dst.v;
> +	insn->mubuf.srsrc = 0; /* s[0:3] */
> +	insn->mubuf.dummy3 = 0;
> +	insn->mubuf.tfe = 0;
> +	insn->mubuf.soffset = GFX9_MUBUF_SOFFSET_INTEGER_0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_load_ubyte(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src,
> +				       short off)
> +{
> +	/* global_load_ubyte <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_LOAD_UBYTE;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0; /* ignored? */
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_load_ushort(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src,
> +				       short off)
> +{
> +	/* global_load_ushort <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_LOAD_USHORT;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0; /* ignored? */
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_load_dword(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src,
> +				       short off)
> +{
> +	/* global_load_dword <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_LOAD_DWORD;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0; /* ignored? */
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_load_dwordx2(union amdgcn_gfx9_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src,
> +					 short off)
> +{
> +	/* global_load_dwordx2 <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_LOAD_DWORDX2;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0; /* ignored? */
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_load_dwordx4(union amdgcn_gfx9_insn *insn,
> +					 struct amdgcn_param32 dst,
> +					 struct amdgcn_param32 src,
> +					 short off)
> +{
> +	/* global_load_dwordx4 <dst>, <srcs>, off offset:<off> */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_LOAD_DWORDX4;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0; /* ignored? */
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_load_dwordx4_glc(union amdgcn_gfx9_insn *insn,
> +					      struct amdgcn_param32 dst,
> +					      struct amdgcn_param32 src,
> +					      short off)
> +{
> +	/* global_load_dwordx4 <dst>, <srcs>, off offset:<off> glc slc
> +	 * GLC=1: bypass L1 (TCP). SLC=1: bypass L2 (TCC).
> +	 * Both needed for VRAM written by external DMA (NIC via PCIe)
> +	 * since L2 is not invalidated on external writes.
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 1;
> +	insn->flat.slc = 1;
> +	insn->flat.op = GFX9_GLOBAL_LOAD_DWORDX4;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = src.v;
> +	insn->flat.data = 0;
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = dst.v;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_store_byte(union amdgcn_gfx9_insn *insn,
> +				       struct amdgcn_param32 dst,
> +				       struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_byte <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_STORE_BYTE;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_store_short(union amdgcn_gfx9_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_short <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_STORE_SHORT;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_store_dword(union amdgcn_gfx9_insn *insn,
> +					struct amdgcn_param32 dst,
> +					struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_dword <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_STORE_DWORD;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +/* global_atomic_add vdst, addr, data, off  (GLC=1: return old value)
> + * old_val = *(u32 *)(addr + off); *(u32 *)(addr + off) += data; vdst = old_val
> + */
> +/* GFX9 global atomic: opcode only differs, all else identical */
> +#define DEFINE_GFX9_GLOBAL_ATOMIC(name, opcode)				\
> +inline u32 emit_gfx9_global_atomic_##name(union amdgcn_gfx9_insn *insn,\
> +					   struct amdgcn_param32 vdst,	\
> +					   struct amdgcn_param32 addr,	\
> +					   struct amdgcn_param32 data,	\
> +					   int off, int glc)		\
> +{									\
> +	insn->flat.offset = off;					\
> +	insn->flat.lds = 0;						\
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;				\
> +	insn->flat.glc = glc;						\
> +	insn->flat.slc = 0;						\
> +	insn->flat.op = (opcode);					\
> +	insn->flat.dummy = 0;						\
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;			\
> +	insn->flat.addr = addr.v;					\
> +	insn->flat.data = data.v;					\
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;			\
> +	insn->flat.nv = 0;						\
> +	insn->flat.vdst = vdst.v;					\
> +	return 8;							\
> +}
> +
> +DEFINE_GFX9_GLOBAL_ATOMIC(add, GFX9_GLOBAL_ATOMIC_ADD)
> +DEFINE_GFX9_GLOBAL_ATOMIC(and, GFX9_GLOBAL_ATOMIC_AND)
> +DEFINE_GFX9_GLOBAL_ATOMIC(or, GFX9_GLOBAL_ATOMIC_OR)
> +DEFINE_GFX9_GLOBAL_ATOMIC(xor, GFX9_GLOBAL_ATOMIC_XOR)
> +DEFINE_GFX9_GLOBAL_ATOMIC(swap, GFX9_GLOBAL_ATOMIC_SWAP)
> +DEFINE_GFX9_GLOBAL_ATOMIC(cmpswap, GFX9_GLOBAL_ATOMIC_CMPSWAP)
> +DEFINE_GFX9_GLOBAL_ATOMIC(add_x2, GFX9_GLOBAL_ATOMIC_ADD_X2)
> +DEFINE_GFX9_GLOBAL_ATOMIC(and_x2, GFX9_GLOBAL_ATOMIC_AND_X2)
> +DEFINE_GFX9_GLOBAL_ATOMIC(or_x2, GFX9_GLOBAL_ATOMIC_OR_X2)
> +DEFINE_GFX9_GLOBAL_ATOMIC(xor_x2, GFX9_GLOBAL_ATOMIC_XOR_X2)
> +DEFINE_GFX9_GLOBAL_ATOMIC(swap_x2, GFX9_GLOBAL_ATOMIC_SWAP_X2)
> +DEFINE_GFX9_GLOBAL_ATOMIC(cmpswap_x2, GFX9_GLOBAL_ATOMIC_CMPSWAP_X2)
> +
> +inline u32 emit_gfx9_global_store_dwordx2(union amdgcn_gfx9_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_dwordx2 <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_STORE_DWORDX2;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_global_store_dwordx4(union amdgcn_gfx9_insn *insn,
> +					  struct amdgcn_param32 dst,
> +					  struct amdgcn_param32 src, int off)
> +{
> +	/* global_store_dwordx4 <src>, <dst>, off offset:<off>
> +	 * *(char *)(dst + off) = src;
> +	 */
> +	insn->flat.offset = off;
> +	insn->flat.lds = 0;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.glc = 0;
> +	insn->flat.slc = 0;
> +	insn->flat.op = GFX9_GLOBAL_STORE_DWORDX4;
> +	insn->flat.dummy = 0;
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.addr = dst.v;
> +	insn->flat.data = src.v;
> +	insn->flat.saddr = GFX9_FLAT_SADDR_DISABLE;
> +	insn->flat.nv = 0;
> +	insn->flat.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_read2_b64(union amdgcn_gfx9_insn *insn,
> +				  int dst, int src, short off0, short off1)
> +{
> +	/*
> +	 * ds_read2_b64 v[<dst>+3:<dst>], v<src> off
> +	 * offset0:<off0> offset1:<off1>
> +	 */
> +
> +	insn->ds.offset0 = off0;
> +	insn->ds.offset1 = off1;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.op = GFX9_DS_READ2_B64;
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.addr = src;
> +	insn->ds.data0 = 0;
> +	insn->ds.data1 = 0;
> +	insn->ds.vdst = dst;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_read_b64(union amdgcn_gfx9_insn *insn,
> +				 int dst, int src, short off)
> +{
> +	/* ds_read_b64 v[<dst>+1:<dst>], v<src> offset:<off> */
> +
> +	insn->ds.offset0 = off & 0xff;
> +	insn->ds.offset1 = off >> 8;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.op = GFX9_DS_READ_B64;
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.addr = src;
> +	insn->ds.data0 = 0;
> +	insn->ds.data1 = 0;
> +	insn->ds.vdst = dst;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_read_b32(union amdgcn_gfx9_insn *insn,
> +				 int dst, int src, short off)
> +{
> +	/* ds_read_b32 v<dst>, v<src> offset:<off> */
> +
> +	insn->ds.offset0 = off & 0xff;
> +	insn->ds.offset1 = off >> 8;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.op = GFX9_DS_READ_B32;
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.addr = src;
> +	insn->ds.data0 = 0;
> +	insn->ds.data1 = 0;
> +	insn->ds.vdst = dst;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_read_u16(union amdgcn_gfx9_insn *insn,
> +				 int dst, int src, short off)
> +{
> +	/* ds_read_u16 v<dst>, v<src> offset:<off> */
> +
> +	insn->ds.offset0 = off & 0xff;
> +	insn->ds.offset1 = off >> 8;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.op = GFX9_DS_READ_U16;
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.addr = src;
> +	insn->ds.data0 = 0;
> +	insn->ds.data1 = 0;
> +	insn->ds.vdst = dst;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_read_u8(union amdgcn_gfx9_insn *insn,
> +				 int dst, int src, short off)
> +{
> +	/* ds_read_u8 v<dst>, v<src> offset:<off> */
> +
> +	insn->ds.offset0 = off & 0xff;
> +	insn->ds.offset1 = off >> 8;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.op = GFX9_DS_READ_U8;
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.addr = src;
> +	insn->ds.data0 = 0;
> +	insn->ds.data1 = 0;
> +	insn->ds.vdst = dst;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_write2_b64(union amdgcn_gfx9_insn *insn,
> +				   int dst, int src0, int src1,
> +				   short off0, short off1)
> +{
> +	/*
> +	 * ds_write2_b64 v[<dst>+3:<dst>], v<src> off
> +	 * offset0:<off0> offset1:<off1>
> +	 */
> +
> +	insn->ds.offset0 = off0;
> +	insn->ds.offset1 = off1;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.op = GFX9_DS_WRITE2_B64;
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.addr = dst;
> +	insn->ds.data0 = src0;
> +	insn->ds.data1 = src1;
> +	insn->ds.vdst = 0;
> +
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_s_branch(union amdgcn_gfx9_insn *insn,
> +			       short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_BRANCH;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_cbranch_vccz(union amdgcn_gfx9_insn *insn,
> +				     short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_CBRANCH_VCCZ;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_cbranch_vccnz(union amdgcn_gfx9_insn *insn,
> +				      short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_CBRANCH_VCCNZ;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_branch_fixup(union amdgcn_gfx9_insn *insn,
> +				  short off)
> +{
> +	WARN_ON(insn->sopp.op != GFX9_S_BRANCH &&
> +		insn->sopp.op != GFX9_S_CBRANCH_SCC0 &&
> +		insn->sopp.op != GFX9_S_CBRANCH_VCCZ &&
> +		insn->sopp.op != GFX9_S_CBRANCH_VCCNZ &&
> +		insn->sopp.op != GFX9_S_CBRANCH_EXECZ &&
> +		insn->sopp.op != GFX9_S_CBRANCH_EXECNZ);
> +	insn->sopp.simm16 = off;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_waitcnt_lgkmcnt(union amdgcn_gfx9_insn *insn)
> +{
> +	struct amdgcn_gfx9_sopp_vmcnt vmcnt;
> +	u16 simm16;
> +	/* s_waitcnt lgkmcnt (0)
> +	 * wait for memory
> +	 */
> +	vmcnt.vmcnt1 = -1;
> +	vmcnt.vmcnt2 = -1;
> +	vmcnt.expcnt = -1;
> +	vmcnt.dummy1 = 0;
> +	vmcnt.dummy2 = 0;
> +	vmcnt.lgkmcnt = 0;
> +	memcpy(&simm16, &vmcnt, sizeof(u16));
> +	insn->sopp.simm16 = simm16;
> +	insn->sopp.op = GFX9_S_WAITCNT;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_waitcnt_vmcnt(union amdgcn_gfx9_insn *insn)
> +{
> +	struct amdgcn_gfx9_sopp_vmcnt vmcnt;
> +	u16 simm16;
> +	/* s_waitcnt lgkmcnt (0)
> +	 * wait for memory
> +	 */
> +	vmcnt.vmcnt1 = 0;
> +	vmcnt.vmcnt2 = 0;
> +	vmcnt.expcnt = -1;
> +	vmcnt.dummy1 = 0;
> +	vmcnt.dummy2 = 0;
> +	vmcnt.lgkmcnt = -1;
> +	memcpy(&simm16, &vmcnt, sizeof(u16));
> +	insn->sopp.simm16 = simm16;
> +	insn->sopp.op = GFX9_S_WAITCNT;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_waitcnt_vmcnt_lgkmcnt(union amdgcn_gfx9_insn *insn)
> +{
> +	struct amdgcn_gfx9_sopp_vmcnt vmcnt;
> +	u16 simm16;
> +	/* s_waitcnt lgkmcnt (0)
> +	 * wait for memory
> +	 */
> +	vmcnt.vmcnt1 = 0;
> +	vmcnt.vmcnt2 = 0;
> +	vmcnt.expcnt = -1;
> +	vmcnt.dummy1 = 0;
> +	vmcnt.dummy2 = 0;
> +	vmcnt.lgkmcnt = 0;
> +	memcpy(&simm16, &vmcnt, sizeof(u16));
> +	insn->sopp.simm16 = simm16;
> +	insn->sopp.op = GFX9_S_WAITCNT;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_nop(union amdgcn_gfx9_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX9_S_NOP;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_endpgm(union amdgcn_gfx9_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX9_S_ENDPGM;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_icache_inv(union amdgcn_gfx9_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX9_S_ICACHE_INV;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* Structurized CFG instructions.
> + * These use raw SGPR indices for 64-bit pair operations involving
> + * EXEC (126) and VCC (106) special registers.
> + */
> +
> +/* s_and_saveexec_b64 s[sdst:sdst+1], s[ssrc:ssrc+1]
> + * sdst = EXEC; EXEC &= ssrc; SCC = (EXEC != 0)
> + */
> +inline u32 emit_gfx9_s_and_saveexec_b64(union amdgcn_gfx9_insn *insn,
> +					 u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX9_S_AND_SAVEEXEC_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX9_SOP1_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_bcnt1_i32_b64 sdst, s[ssrc:ssrc+1]
> + * sdst = popcount(ssrc). SCC = (sdst != 0)
> + */
> +inline u32 emit_gfx9_s_bcnt1_i32_b64(union amdgcn_gfx9_insn *insn,
> +				      u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX9_S_BCNT1_I32_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX9_SOP1_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_mov_b64 s[sdst:sdst+1], s[ssrc:ssrc+1] (or special src like 0) */
> +inline u32 emit_gfx9_s_mov_b64(union amdgcn_gfx9_insn *insn,
> +				u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX9_S_MOV_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX9_SOP1_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_and_b64 s[sdst:sdst+1], s[ssrc0:ssrc0+1], s[ssrc1:ssrc1+1] */
> +inline u32 emit_gfx9_s_and_b64(union amdgcn_gfx9_insn *insn,
> +				u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_AND_B64;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_or_b64 s[sdst:sdst+1], s[ssrc0:ssrc0+1], s[ssrc1:ssrc1+1] */
> +inline u32 emit_gfx9_s_or_b64(union amdgcn_gfx9_insn *insn,
> +			       u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_OR_B64;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_andn2_b64 s[sdst:sdst+1], s[ssrc0:ssrc0+1], s[ssrc1:ssrc1+1]
> + * sdst = ssrc0 & ~ssrc1
> + */
> +inline u32 emit_gfx9_s_andn2_b64(union amdgcn_gfx9_insn *insn,
> +				  u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_ANDN2_B64;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_and_b32 s[sdst], s[ssrc0], s[ssrc1] */
> +inline u32 emit_gfx9_s_and_b32(union amdgcn_gfx9_insn *insn,
> +				u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_AND_B32;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_or_b32 s[sdst], s[ssrc0], s[ssrc1] */
> +inline u32 emit_gfx9_s_or_b32(union amdgcn_gfx9_insn *insn,
> +			       u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_OR_B32;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_andn2_b32 s[sdst], s[ssrc0], s[ssrc1]
> + * sdst = ssrc0 & ~ssrc1
> + */
> +inline u32 emit_gfx9_s_andn2_b32(union amdgcn_gfx9_insn *insn,
> +				  u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_ANDN2_B32;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_cbranch_execz off - branch if EXEC == 0 */
> +inline u32 emit_gfx9_s_cbranch_execz(union amdgcn_gfx9_insn *insn,
> +				      short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_CBRANCH_EXECZ;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_cbranch_execnz off - branch if EXEC != 0 */
> +inline u32 emit_gfx9_s_cbranch_execnz(union amdgcn_gfx9_insn *insn,
> +				       short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_CBRANCH_EXECNZ;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_sub_u32 sdst, ssrc0, ssrc1 - sdst = ssrc0 - ssrc1; SCC = borrow */
> +inline u32 emit_gfx9_s_sub_u32(union amdgcn_gfx9_insn *insn,
> +				u8 sdst, u8 ssrc0, u8 ssrc1)
> +{
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.op = GFX9_S_SUB_U32;
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +
> +	return 4;
> +}
> +
> +/* s_cbranch_scc0 off - branch if SCC == 0 (no borrow) */
> +inline u32 emit_gfx9_s_cbranch_scc0(union amdgcn_gfx9_insn *insn,
> +				     short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_CBRANCH_SCC0;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +
> +	return 4;
> +}
> +
> +static inline void __emit_gfx9_sop2(union amdgcn_gfx9_insn *insn,
> +				     int op, int sdst, int ssrc0, int ssrc1)
> +{
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;
> +	insn->sop2.op = op;
> +	insn->sop2.sdst = sdst;
> +	insn->sop2.ssrc0 = ssrc0;
> +	insn->sop2.ssrc1 = ssrc1;
> +}
> +
> +static inline void __emit_gfx9_sop1(union amdgcn_gfx9_insn *insn,
> +				     int op, int sdst, int ssrc0)
> +{
> +	insn->sop1.encoding = GFX9_SOP1_ENCODING;
> +	insn->sop1.op = op;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.ssrc0 = ssrc0;
> +}
> +
> +static inline void __emit_gfx9_sopp(union amdgcn_gfx9_insn *insn,
> +				     int op, u16 simm16)
> +{
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +	insn->sopp.op = op;
> +	insn->sopp.simm16 = simm16;
> +}
> +
> +static inline void __emit_gfx9_sopc(union amdgcn_gfx9_insn *insn,
> +				     int op, int ssrc0, int ssrc1)
> +{
> +	insn->sopc.encoding = GFX9_SOPC_ENCODING;
> +	insn->sopc.op = op;
> +	insn->sopc.ssrc0 = ssrc0;
> +	insn->sopc.ssrc1 = ssrc1;
> +}
> +
> +static inline void __emit_gfx9_vop1(union amdgcn_gfx9_insn *insn,
> +				     int op, int vdst, int src0)
> +{
> +	insn->vop1.encoding = GFX9_VOP1_ENCODING;
> +	insn->vop1.op = op;
> +	insn->vop1.vdst = vdst;
> +	insn->vop1.src0 = src0;
> +}
> +
> +static inline void __emit_gfx9_vop2(union amdgcn_gfx9_insn *insn,
> +				     int op, int vdst, int vsrc1, int src0)
> +{
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	insn->vop2.op = op;
> +	insn->vop2.vdst = vdst;
> +	insn->vop2.vsrc1 = vsrc1;
> +	insn->vop2.src0 = src0;
> +}
> +
> +static inline void __emit_gfx9_vopc(union amdgcn_gfx9_insn *insn,
> +				     int op, int vsrc1, int src0)
> +{
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +	insn->vopc.op = op;
> +	insn->vopc.vsrc1 = vsrc1;
> +	insn->vopc.src0 = src0;
> +}
> +
> +static inline void __emit_gfx9_smem(union amdgcn_gfx9_insn *insn,
> +				     int op, int sdata, int sbase_pair,
> +				     u32 offset)
> +{
> +	insn->smem.encoding = GFX9_SMEM_ENCODING;
> +	insn->smem.op = op;
> +	insn->smem.sdata = sdata;
> +	insn->smem.sbase = sbase_pair;
> +	insn->smem.imm = 1;
> +	insn->smem.offset = offset;
> +	insn->smem.soffset = GFX9_SRC_NULL;
> +}
> +
> +static inline void __emit_gfx9_ds(union amdgcn_gfx9_insn *insn,
> +				   int op, int addr, int data0, int vdst,
> +				   int off0, int off1)
> +{
> +	insn->ds.encoding = GFX9_DS_ENCODING;
> +	insn->ds.op = op;
> +	insn->ds.gds = GFX9_DS_LDS;
> +	insn->ds.addr = addr;
> +	insn->ds.data0 = data0;
> +	insn->ds.vdst = vdst;
> +	insn->ds.offset0 = off0;
> +	insn->ds.offset1 = off1;
> +}
> +
> +static inline void __emit_gfx9_global(union amdgcn_gfx9_insn *insn,
> +				       int op, int vdst, int vaddr,
> +				       int vdata, int saddr, int offset)
> +{
> +	insn->flat.encoding = GFX9_FLAT_ENCODING;
> +	insn->flat.seg = GFX9_FLAT_SEG_GLOBAL;
> +	insn->flat.op = op;
> +	insn->flat.vdst = vdst;
> +	insn->flat.addr = vaddr;
> +	insn->flat.data = vdata;
> +	insn->flat.saddr = saddr;
> +	insn->flat.offset = offset;
> +}
> +
> +/* ======================================================================
> + * GFX9 Param-Aware Emit Functions
> + *
> + * Used by shader-emitters (aesgcm_shader.h, ipsec_fused_gfx9.h, ...) that
> + * construct param32 operands via P_S/P_V/P_I/P_L helpers.  Paired with
> + * the GFX10 equivalents in knod_gfx10_insn.h.
> + * ======================================================================
> + */
> +
> +static inline int __p2e9(struct amdgcn_param32 p)
> +{
> +	if (p.type == AMDGCN_PARAM_TYPE_LITERAL_CONST)
> +		return gfx9_get_param_base(p);
> +	return gfx9_get_param_base(p) + p.v;
> +}
> +
> +/* --- SOP2 family (param32 version) --- */
> +
> +#define DEFINE_GFX9_SOP2_P(name, opcode)				\
> +inline u32 emit_gfx9_##name(union amdgcn_gfx9_insn *insn,		\
> +			     struct amdgcn_param32 dst,			\
> +			     struct amdgcn_param32 src0,		\
> +			     struct amdgcn_param32 src1)		\
> +{									\
> +	insn->sop2.sdst = __p2e9(dst);					\
> +	insn->sop2.ssrc0 = __p2e9(src0);				\
> +	insn->sop2.ssrc1 = __p2e9(src1);				\
> +	insn->sop2.op = opcode;					\
> +	insn->sop2.encoding = GFX9_SOP2_ENCODING;			\
> +	if (knod_param_is_literal(src0)) {			\
> +		insn->sop2.literal = src0.v;				\
> +		return 8;						\
> +	}								\
> +	if (knod_param_is_literal(src1)) {			\
> +		insn->sop2.literal = src1.v;				\
> +		return 8;						\
> +	}								\
> +	return 4;							\
> +}
> +
> +DEFINE_GFX9_SOP2_P(s_add_u32,  GFX9_S_ADD_U32)
> +DEFINE_GFX9_SOP2_P(s_sub_u32_p,  GFX9_S_SUB_U32)
> +DEFINE_GFX9_SOP2_P(s_addc_u32, GFX9_S_ADDC_U32)
> +DEFINE_GFX9_SOP2_P(s_subb_u32, GFX9_S_SUBB_U32)
> +DEFINE_GFX9_SOP2_P(s_and_b32_p,  GFX9_S_AND_B32)
> +DEFINE_GFX9_SOP2_P(s_lshl_b32, GFX9_S_LSHL_B32)
> +DEFINE_GFX9_SOP2_P(s_lshr_b32, GFX9_S_LSHR_B32)
> +DEFINE_GFX9_SOP2_P(s_mul_i32,  GFX9_S_MUL_I32)
> +DEFINE_GFX9_SOP2_P(s_xor_b32,  GFX9_S_XOR_B32)
> +
> +#undef DEFINE_GFX9_SOP2_P
> +
> +/* --- SOPC family (param32 version) --- */
> +
> +#define DEFINE_GFX9_SOPC_P(name, opcode)				\
> +inline u32 emit_gfx9_##name(union amdgcn_gfx9_insn *insn,		\
> +			     struct amdgcn_param32 src0,		\
> +			     struct amdgcn_param32 src1)		\
> +{									\
> +	insn->sopc.ssrc0 = __p2e9(src0);				\
> +	insn->sopc.ssrc1 = __p2e9(src1);				\
> +	insn->sopc.op = opcode;					\
> +	insn->sopc.encoding = GFX9_SOPC_ENCODING;			\
> +	if (knod_param_is_literal(src0)) {			\
> +		insn->sopc.literal = src0.v;				\
> +		return 8;						\
> +	}								\
> +	if (knod_param_is_literal(src1)) {			\
> +		insn->sopc.literal = src1.v;				\
> +		return 8;						\
> +	}								\
> +	return 4;							\
> +}
> +
> +DEFINE_GFX9_SOPC_P(s_cmp_eq_u32, GFX9_S_CMP_EQ_U32)
> +DEFINE_GFX9_SOPC_P(s_cmp_lg_u32, GFX9_S_CMP_LG_U32)
> +DEFINE_GFX9_SOPC_P(s_cmp_ge_u32, GFX9_S_CMP_GE_U32)
> +DEFINE_GFX9_SOPC_P(s_cmp_lt_u32, GFX9_S_CMP_LT_U32)
> +
> +#undef DEFINE_GFX9_SOPC_P
> +
> +/* --- SOPP family --- */
> +
> +inline u32 emit_gfx9_s_barrier(union amdgcn_gfx9_insn *insn)
> +{
> +	insn->sopp.simm16 = 0;
> +	insn->sopp.op = GFX9_S_BARRIER;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +	return 4;
> +}
> +
> +/* waitcnt with arbitrary vm/lgkm */
> +#define GFX9_WAITCNT(vm, lgkm)	(((lgkm) << 8) | (7 << 4) | (vm))
> +
> +inline u32 emit_gfx9_s_waitcnt(union amdgcn_gfx9_insn *insn,
> +				int vm, int lgkm)
> +{
> +	insn->sopp.simm16 = GFX9_WAITCNT(vm, lgkm);
> +	insn->sopp.op = GFX9_S_WAITCNT;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +	return 4;
> +}
> +
> +inline u32 emit_gfx9_s_cbranch_scc1(union amdgcn_gfx9_insn *insn,
> +				     short off)
> +{
> +	insn->sopp.simm16 = off;
> +	insn->sopp.op = GFX9_S_CBRANCH_SCC1;
> +	insn->sopp.encoding = GFX9_SOPP_ENCODING;
> +	return 4;
> +}
> +
> +/* --- SOP1 family --- */
> +
> +inline u32 emit_gfx9_s_not_b64(union amdgcn_gfx9_insn *insn,
> +				u8 sdst, u8 ssrc)
> +{
> +	insn->sop1.ssrc0 = ssrc;
> +	insn->sop1.op = GFX9_S_NOT_B64;
> +	insn->sop1.sdst = sdst;
> +	insn->sop1.encoding = GFX9_SOP1_ENCODING;
> +	return 4;
> +}
> +
> +/* --- VOPC (v_cmp_ne_u32 param variant) --- */
> +
> +inline u32 emit_gfx9_v_cmp_ne_u32(union amdgcn_gfx9_insn *insn,
> +				    struct amdgcn_param32 src0,
> +				    struct amdgcn_param32 src1)
> +{
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +	insn->vopc.vsrc1 = src1.v;
> +	insn->vopc.op = GFX9_V_CMP_NE_U32;
> +	insn->vopc.encoding = GFX9_VOPC_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vopc.src0 = gfx9_get_param_base(src0);
> +		insn->vopc.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vopc.src0 = gfx9_get_param_base(src0) + src0.v;
> +	return 4;
> +}
> +
> +/* --- SMEM family (param32 version) --- */
> +
> +#define DEFINE_GFX9_SMEM_P(name, opcode)				\
> +inline u32 emit_gfx9_##name(union amdgcn_gfx9_insn *insn,		\
> +			     struct amdgcn_param32 dst,			\
> +			     struct amdgcn_param32 src, int offset)	\
> +{									\
> +	insn->smem.sdata = dst.v;					\
> +	insn->smem.sbase = src.v / 2;					\
> +	insn->smem.op = opcode;					\
> +	insn->smem.imm = 1;						\
> +	insn->smem.offset = offset;					\
> +	insn->smem.encoding = GFX9_SMEM_ENCODING;			\
> +	return 8;							\
> +}
> +
> +DEFINE_GFX9_SMEM_P(s_load_dword,   GFX9_S_LOAD_DWORD)
> +DEFINE_GFX9_SMEM_P(s_load_dwordx4, GFX9_S_LOAD_DWORDX4)
> +DEFINE_GFX9_SMEM_P(s_load_dwordx8, GFX9_S_LOAD_DWORDX8)
> +
> +#undef DEFINE_GFX9_SMEM_P
> +
> +/* s_dcache_inv - no operands, just opcode + encoding */
> +inline u32 emit_gfx9_s_dcache_inv(union amdgcn_gfx9_insn *insn)
> +{
> +	insn->smem.sdata = 0;
> +	insn->smem.sbase = 0;
> +	insn->smem.op = GFX9_S_DCACHE_INV;
> +	insn->smem.imm = 0;
> +	insn->smem.offset = 0;
> +	insn->smem.encoding = GFX9_SMEM_ENCODING;
> +	return 8;
> +}
> +
> +/* --- SOPK: s_getreg_b32 --- */
> +
> +/*
> + * HWREG encoding for s_getreg_b32 simm16:
> + *   bits[5:0]   = hwreg_id
> + *   bits[10:6]  = offset (bit position)
> + *   bits[15:11] = size - 1 (in bits)
> + */
> +#define GFX9_HWREG(id, off, sz)	(((sz) - 1) << 11 | (off) << 6 | (id))
> +#define GFX9_HW_REG_LDS_ALLOC	6
> +
> +inline u32 emit_gfx9_s_getreg_b32(union amdgcn_gfx9_insn *insn,
> +				   int sdst, u16 hwreg)
> +{
> +	insn->sopk.encoding = GFX9_SOPK_ENCODING;
> +	insn->sopk.op = GFX9_S_GETREG_B32;
> +	insn->sopk.sdst = sdst;
> +	insn->sopk.simm16 = hwreg;
> +	return 4;
> +}
> +
> +/* --- DS family --- */
> +
> +inline u32 emit_gfx9_gds_write_b32(union amdgcn_gfx9_insn *insn,
> +				    int addr, int data0)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_WRITE_B32, addr, data0, 0, 0, 0);
> +	insn->ds.gds = GFX9_DS_GDS;
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_gds_read_b32(union amdgcn_gfx9_insn *insn,
> +				   int vdst, int addr, int offset)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_READ_B32, addr, 0, vdst, offset, 0);
> +	insn->ds.gds = GFX9_DS_GDS;
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_write_b32(union amdgcn_gfx9_insn *insn,
> +				    int addr, int data0)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_WRITE_B32, addr, data0, 0, 0, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_write_b32_off(union amdgcn_gfx9_insn *insn,
> +					int addr, int data0, int offset)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_WRITE_B32, addr, data0, 0, offset, 0);
> +	return 8;
> +}
> +
> +inline u32 emit_gfx9_ds_read_b32_off(union amdgcn_gfx9_insn *insn,
> +				       int vdst, int addr, int offset)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_READ_B32, addr, 0, vdst, offset, 0);
> +	return 8;
> +}
> +
> +/* ds_write_b128 v<addr>, v[<data>:<data>+3] - write 128 bits to LDS */
> +inline u32 emit_gfx9_ds_write_b128(union amdgcn_gfx9_insn *insn,
> +				    int addr, int data0)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_WRITE_B128, addr, data0, 0, 0, 0);
> +	return 8;
> +}
> +
> +/* ds_read_b128 v[<vdst>:<vdst>+3], v<addr> - read 128 bits from LDS */
> +inline u32 emit_gfx9_ds_read_b128(union amdgcn_gfx9_insn *insn,
> +				   int vdst, int addr)
> +{
> +	__emit_gfx9_ds(insn, GFX9_DS_READ_B128, addr, 0, vdst, 0, 0);
> +	return 8;
> +}
> +
> +/* v_max_i32 vdst, src0, vsrc1 - VOP2 */
> +inline u32 emit_gfx9_v_max_i32(union amdgcn_gfx9_insn *insn,
> +				struct amdgcn_param32 dst,
> +				struct amdgcn_param32 src0,
> +				struct amdgcn_param32 src1)
> +{
> +	WARN_ON(dst.type != AMDGCN_PARAM_TYPE_VGPR);
> +	WARN_ON(src1.type != AMDGCN_PARAM_TYPE_VGPR);
> +
> +	insn->vop2.vsrc1 = src1.v;
> +	insn->vop2.vdst = dst.v;
> +	insn->vop2.op = GFX9_V_MAX_I32;
> +	insn->vop2.encoding = GFX9_VOP2_ENCODING;
> +	if (src0.type == AMDGCN_PARAM_TYPE_LITERAL_CONST) {
> +		insn->vop2.src0 = gfx9_get_param_base(src0);
> +		insn->vop2.literal = src0.v;
> +		return 8;
> +	}
> +	insn->vop2.src0 = gfx9_get_param_base(src0) + src0.v;
> +
> +	return 4;
> +}
> +
> +#endif

