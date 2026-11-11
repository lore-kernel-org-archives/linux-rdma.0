Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424330;
	b=gIrsbZoNTu1XA59hba1Vb3SZ0ngQ1o5gOfxhJ3u1/C8CL4Q/qC7b2x8y1628O4uRiHlW
	 82fWNsyBg4t3rxXfQWkXBxDFGi/r33O5HmKu3fYPmcmDunoHij1OBvtp3Y0GTi1rR80Bv
	 J6M9+FOomUNYrlkZs//46CVNAgOdOBunUicWUgjdGg7bq23NrmAIwRnLt8TK6VE+rQN8i
	 UUtaah7UJ9ktBAQPFxfWF+lKOFZRAqtht83WXCvTblAd7v1EJECFURzNdcUGyRwG+amCF
	 4oL+DOIfhtMPuG7QaICdavEcn8kUC8o+lAVgdFlzf4efXX+9JTNG930AIojDDeFEMDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424330;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=nCP5ZM0Xh8+yWU/AcUsqoA4PfWxdOwn0jfBwhfBlWIg=;
	b=r89KR1QkLuGkyD8N07OU4m7UTV4uh3grqFecAtx8dJ+Sl76EhljAUTGZ+PBWR0NtWqgw
	 7D5fB1kK2h7LRuUXY4ny9jiGWieyiOdVgiRB1xsX79K8GjyiMvXDcX6dIa2T+fSwpb+Wk
	 h3ms6VHsLHufs6pAkDLSZYbxZCaoBl+SLqnYuoRJV0I0HTbDSDf0LTG4aZBHlawaTri6P
	 vUoT7PmyJZA+l4xz4XRWP2X6TDApRA5ZlPAuExXouYUQBTFVvBA+gaUZkdPRGd9N/UmEz
	 u2w9IrNViIuISAuAXAgNilxA5kZpMym625vmeFB2qmNwsKRHmOqYSJRJOx0vKYZUxNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1njNFm9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC960A380A;
	Wed, 11 Nov 2026 19:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1njNFm9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F521F00A05;
	Wed, 11 Nov 2026 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424329;
	bh=nCP5ZM0Xh8+yWU/AcUsqoA4PfWxdOwn0jfBwhfBlWIg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=P1njNFm9CRjRcoY78wDe+gQnFM13wyxX4hF9YC52ds+gnKJfA5TMZYMUkVzyg6LnT
	 CNmoMJSkBZqUxLOVbd/fZ9YKB1V4e2+Uw3SObRxGfTISzZehuxHXRa+VFdZA1udbsX
	 lVRtYDvA2ZZLYKm9XaJQjjYYmJTVKDbpoayFboV/T4E9lZjcpMCAcp/Hl3HEbGQgwI
	 obDBUK5AnpJ0nd2gu99KIvt0nfxjiPx2vezLD369jDQvS71ltcIFvCXzKwKvI5AyCb
	 99obRQurWy4slj9X4SRTnlQby1+83OwF7E92Lsp6khnHauOeibSpbN+bfmjW8EGwoX
	 hAwZOIRe9Phzg==
Subject: Re: [PATCH net-next 06/10] net/sched: cls_flower: add enc_key_id mask
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
Date: Wed, 11 Nov 2026 19:12:07 +0000
Message-ID: <179442432794.2199510.1364864921481333835@kernel.org>
In-Reply-To: <20261109131039.959438-7-acassen@corp.free.fr>
References: <20261109131039.959438-7-acassen@corp.free.fr>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] net/sched: cls_flower: 24-bit VNI mask truncation in
  fl_set_key() offload

Pre-existing issues:
- [Medium] i40e and iavf accept an enc_key_id match but never program the
  tenant ID into hardware.

--

net/sched: cls_flower: add enc_key_id mask

This adds an optional TCA_FLOWER_KEY_ENC_KEY_ID_MASK attribute to flower,
so one filter can match a block of tunnel keys. When no mask is given, the
enc_key_id match stays exact. The new attribute is also added to the policy,
the dump path and the tc.yaml netlink spec.

> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 23eba4a00a947..dd248a335402a 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c

[ ... ]

> @@ -2110,7 +2111,7 @@ static int fl_set_key(struct net *net, struct nlattr *tca_opts,
>  	}
>  
>  	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
> -		       &mask->enc_key_id.keyid, TCA_FLOWER_UNSPEC,
> +		       &mask->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID_MASK,
>  		       sizeof(key->enc_key_id.keyid));

[Severity: Medium]
The commit message says truncating the mask to a 24 bit VNI is correct
when the key fits the VNI. The earlier patches in the series only check
the key. Doesn't that miss a mask with no bits set in the low 24 bits?

Take enc_key_id 0x0/0xff000000. It passes the check in
cxgb4_validate_flow_match(), because be32_to_cpu(match.key->keyid) >>
ENCAP_VNI_BITWIDTH is 0. cxgb4_process_flow_match() then stores
be32_to_cpu(match.mask->keyid) into the 24 bit fs->mask.vni field, which
ends up as 0.

fs->val.encap_vld and fs->mask.encap_vld are only set under
if (fs->mask.vni). So the rule is programmed without the encapsulation
qualifier, and t4_alloc_encap_mac_filt() is skipped. The hardware filter
can then match non-encapsulated traffic on the port, which the user
never asked for.

mlx5e_tc_tun_parse_vxlan() has the same shape. It only bails out when
enc_keyid.mask->keyid is zero, and only checks the key against
MLX5E_TC_TUN_N_VNI. It then writes the truncated mask into vxlan_vni in
misc_c. That gives a zero VNI mask while MLX5_MATCH_MISC_PARAMETERS is
still set in spec->match_criteria_enable, so the VNI is no longer
constrained at all. The same applies to
mlx5e_tc_tun_parse_outer_key_vxlan(), added earlier in this series.

Before this patch the mask was always all ones whenever enc_key_id was
present, so the low 24 bits could never be zero. This patch is what
makes the mismatch reachable from userspace.

Should these drivers reject a mask whose low 24 bits are all zero? Or
should cxgb4 base encap_vld on the full 32 bit mask rather than the
truncated fs->mask.vni? Either way, it looks like the "key fits the VNI"
checks from the earlier patches need to look at the mask as well.

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. With
this change, partial masks can now reach i40e and iavf. Neither driver
programs the tenant ID into hardware, yet both report the offload as
successful.

In i40e_parse_cls_flower(), any non-zero mask, including a partial one,
sets the tenant ID field flag:

drivers/net/ethernet/intel/i40e/i40e_main.c:i40e_parse_cls_flower() {
    ...
	if (match.mask->keyid != 0)
		field_flags |= I40E_CLOUD_FIELD_TEN_ID;

	filter->tenant_id = be32_to_cpu(match.key->keyid);
    ...
}

But i40e_set_cld_element() memsets the AQ element and never writes
cld->tenant_id:

drivers/net/ethernet/intel/i40e/i40e_main.c:i40e_set_cld_element() {
    ...
	/* tenant_id is not supported by FW now, once the support is enabled
	 * fill the cld->tenant_id with cpu_to_le32(filter->tenant_id)
	 */
	if (filter->tenant_id)
		return;
}

iavf_parse_cls_flower() has the same problem. It sets
IAVF_CLOUD_FIELD_TEN_ID for any non-zero mask but never sends a tenant ID
value to the PF.

As a result, the hardware filter installed on these drivers does not match
the requested tunnel key, whether the mask is exact or partial. An exact key
is ignored in the same way today, so a partial mask does not add a new kind
of mismatch.

The commit message already says this accurately:

  "i40e and iavf never program the value of enc_key_id, with or without
  this patch."

Should i40e_parse_cls_flower() and iavf_parse_cls_flower() reject an
enc_key_id match with -EOPNOTSUPP, at least until firmware support for the
tenant ID exists? That would stop the offload from appearing to succeed
while ignoring the key. It would probably fit best as a separate fix.

>  
>  	fl_set_key_val(tb, &key->enc_tp.src, TCA_FLOWER_KEY_ENC_UDP_SRC_PORT,

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
