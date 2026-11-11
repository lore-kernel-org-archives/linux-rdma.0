Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424325;
	b=P8i2LE/MxenK3FUBUSkv2qyLIPam7J81Rq6CKjcT8k71YHPuCHBnt1eUgRv+mZj/YY7N
	 rIuXiTZsYy1hg7+yfXd/sBmJX4PqVMPFZrYu4d+qzDNDS450pOUIPPSWTrgkmaLFJlIM+
	 Xun7vScazdq4HirRQS455ZZIsFewZJA6BMJK+Y4DgFHZxBCldLKRi+4LQuVTk7f+na/sh
	 Nas86raHUy0b6lNEa/oHOaG/keY4kcmY6SVZtOLr+Rm2smiG6CTu7CFIJbXjZOQUmJQSA
	 P/XCHC0biQZSojhmampokMQSGh62RulZfgwMufVpnibVb2QKAB/hOBR7qOhXVzUFagg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424325;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=GWPCe/ldRNhLGb02fnB2WOPB4LQypi+fk7L8hqeqjmQ=;
	b=tXnBefUvPZ1rgzK2gy2Ne7XH8X8Kg+YN6C+sNf1A5zz+GhE54BUYasmYtg/APv2jQRSE
	 lGRHSg5wo1a9+gvgTbOkDD+zgdGafiMYgjo6lknTLtt/N55bzewaNVJqW3NrgwVoLWPkG
	 LWOUgpdmV1JSqXrPFUp3TAvS1YGPd7Ja5mUqR+Pio7YxhJAxu2mnKpaghU1wyL9isOC71
	 m81oOWlYb5WfipRejB8xUos38+O19+Avnnv82JbJz5HfKfSMyGTPFAHjfrsW+BDiQE0qP
	 sceLgVzILakS+gN0BIJyxF0cvJsKJyCcyGnYQO+WCXuzW0hr0oc7oxjmrrMxEgmveoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0kegdlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04BA606A326;
	Wed, 11 Nov 2026 19:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0kegdlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EB81F00A0E;
	Wed, 11 Nov 2026 19:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424325;
	bh=GWPCe/ldRNhLGb02fnB2WOPB4LQypi+fk7L8hqeqjmQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T0kegdlgrk9PoSsp6PKx1X6Eg7xnnT9E2j03QTnOPQFAvCZaAl59irhKAtg/5mTDq
	 bgx0yE7dltZJxE/ev1qf4BkMLr8jTnUg/OYU70/6onc0JUjeGAGFcsu4vhzMdkXCwt
	 KKhGj+9nN1lXEel9NJ4CeL/Y8lQpAM6VrN/c8AmjrFbaHjeDOp5hajPKSCKfj01xnz
	 UYlDxbj269iKs9ymtbOEB10OzsVRJUS6gg1DGrPA5hZJt9UPZZBeQ3r5iTadG3nPEp
	 ylGhdgQ6QZYY45YZFz8oG8ckmis67EfbB125QqnZKUuWLeprAhxtcxUa9kv1VakR02
	 TRYwbJ+Ih+Hfw==
Subject: Re: [PATCH net-next 04/10] net/mlx5e: TC, refuse a tunnel key wider
 than the VNI
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
 bharat@chelsio.com, donald.hunter@gmail.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, dsahern@kernel.org,
 idosch@nvidia.com, shuah@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, oss-drivers@corigine.com
Date: Wed, 11 Nov 2026 19:12:03 +0000
Message-ID: <179442432378.2199510.219572665710096354@kernel.org>
In-Reply-To: <20261109131039.959438-5-acassen@corp.free.fr>
References: <20261109131039.959438-5-acassen@corp.free.fr>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says this is a fix for a bug that exists
  today: "An exact key above bit 23 already selects the wrong VNI." The…

--

net/mlx5e: TC, refuse a tunnel key wider than the VNI

This patch makes mlx5e_tc_tun_parse_vxlan() and
mlx5e_tc_tun_parse_geneve_vni() reject an enc_key_id whose key does not
fit in the 24 bit VNI match field. Such rules now fail with -EOPNOTSUPP
and an extack message. The 32 bit GRE key handling is left as is.

> VXLAN and GENEVE flows truncate the key and the mask of enc_key_id to a 24
> bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
> is about to accept partial masks. A mask that only covers bits above 23
> would then match any VNI. Refuse a key that no VNI can match. GRE keeps
> its 32 bit key.

[ ... ]

> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

[Severity: Low]
The commit message says the problem exists today ("An exact key above bit
23 already selects the wrong VNI"). Should the patch carry a Fixes: tag,
and maybe go through net?

The truncation does look reachable in the current tree. Flower parses
TCA_FLOWER_KEY_ENC_KEY_ID with TCA_FLOWER_UNSPEC as the mask type, so every
enc_key_id rule is an exact 32 bit match. The parsers then write the key
into 24 bit fields:

mlx5e_tc_tun_parse_vxlan() {
    ...
	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni,
		 be32_to_cpu(enc_keyid.key->keyid));
    ...
}

mlx5e_tc_tun_parse_geneve_vni() {
    ...
	MLX5_SET(fte_match_set_misc, misc_v, geneve_vni, be32_to_cpu(enc_keyid.key->keyid));
    ...
}

In mlx5_ifc.h, vxlan_vni and geneve_vni are 0x18 bits wide, so MLX5_SET()
masks off bits 24-31.

The VXLAN-GBP path in mlx5e_tc_tun_parse_vxlan() also loses those bits. It
shifts the key left by 8 into the 32 bit tunnel_header_1:

	MLX5_SET(fte_match_set_misc5, misc_v, tunnel_header_1,
		 be32_to_cpu(enc_keyid.key->keyid) << 8);

As a result, a skip_sw rule with enc_key_id 0x01000001 is offloaded as a
match on VNI 1. Software never matches that rule.

Because this fixes a mismatch that already exists, a Fixes: tag would tell
backporters which stable trees are affected. These look like the
candidate targets:

  9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows
  offload") for the geneve_vni MLX5_SET()

  the original en_tc.c commit that added VXLAN VNI matching, for the
  vxlan_vni MLX5_SET(). d386939a327d ("net/mlx5e: Rearrange tc tunnel code
  in a modular way") later moved that code into tc_tun_vxlan.c.

  eacc77a73275 ("net/mlx5e: Use custom tunnel header for vxlan gbp") for
  the tunnel_header_1 path

Would it also make sense to send this to net as a standalone fix, rather
than untagged as part of the net-next series that adds flower partial
masks?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
