Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424321;
	b=ERYxaDyh5v/lWDqyFJfb5c+3oJwdzpr2FNxPEAnItC1B6yAaByHAzRoCoQtGEa4g4eeQ
	 SZohTrKDT+9T2vzxFERXekKOcsL6XT6c56KNagkzLVnxfJFjGSwe7I29q9RR4euL0Ol7H
	 DHP0WW7vxA/9q4i/aDU8HwhadjU64mFOIQMckPKYmE1xBFmNqtkClQsyLOqEDDAPHh1fl
	 H1leinxltYwtG3cVLnsUPaTVOK97J9ClzJCKJvIgYN/DZmexas254txAY7OllQwPBEGlA
	 cbTaCC1+HTNZU+82m/hxCvu1SZXwNcwXgycRFAVK1dyjsRxgKeN5CMaEtq9j9QmFUjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424321;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TYtcSEbeXrJzZbwSSVOIQbwHlUL+6uRNPP+QvBhwGKw=;
	b=vfhcN0i0BcZwYO0zAVG0VfQSP/uKgPf1JTr2dEkxZMi+Z3hMt8QB++1XtdZhFZoxzr0v
	 5ZKtY2guMkT3Zm1jHp45pRUdnnnb9YPFv6gzAuSn/XFV3rdy6mVapRqiE26Qgf8fjliSX
	 MORNB0PQO2fFJRXrkO/KP2ChKdn8wPRpEVWBCv6Fa7cLU5nlanKCUm+di9+KRnb3wnIlV
	 pkR0sW2jtOlNAbe0sCKLx/VewSseq78E1dAil76wHIOmHX1fBY3kiiErZHzXReojLNXNy
	 i56UMq5QJDItC1UIWQ2b1p01hTS1TjhWCTZlShmI8BXcRGX+Gbw65DhGEoPxYUvJoFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dki0UB+p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD363606A881;
	Wed, 11 Nov 2026 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dki0UB+p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109F21F00A05;
	Wed, 11 Nov 2026 19:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424321;
	bh=TYtcSEbeXrJzZbwSSVOIQbwHlUL+6uRNPP+QvBhwGKw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Dki0UB+pU+9/Xirz3xv2X3IJ+8lHbn95JE6UV7Dcbk+PtyjesMnB64E+gnYdcT/p3
	 Gihdt+S31WhdUCTKtZurtAnm30hR/+xztWYtxadxxmJDG5IfPnzG5Jeg0haph8IqMO
	 6zPowngiipoBJ03kpd9PJpp7oVz5oknKi2QquY4qQvMm29zQ4SISYh6+D+Cn2WY1kS
	 +1g0ohmkAEDSbgveD3fH+VN0GOAVqlgvleYWCEqtzkmhWO1o500zTAaiAtK1Wvmd/f
	 O1EoSkBx/QQ7pTU+LA4xAYnVGfsDqAgMcYC6bBs+eHiM7OfIaOQK0i9DG3NbOzsxgY
	 N604CpVViz/2w==
Subject: Re: [PATCH net-next 02/10] cxgb4: flower: refuse a tunnel key wider
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
Date: Wed, 11 Nov 2026 19:11:59 +0000
Message-ID: <179442431962.2199510.14986379471426017@kernel.org>
In-Reply-To: <20261109131039.959438-3-acassen@corp.free.fr>
References: <20261109131039.959438-3-acassen@corp.free.fr>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] cxgb4: unvalidated tunnel key mask in
  cxgb4_validate_flow_match()
- [Low] The commit message says the bug is already reachable today: "An
  exact key above bit 23 already selects the wrong VNI".

Pre-existing issues:
- [Medium] This bug was not introduced by this patch, but it produces the
  same symptom the commit message gives as its motivation ("The rule…

--

cxgb4: flower: refuse a tunnel key wider than the VNI

This patch adds a check to cxgb4_validate_flow_match(). Flower rules whose
enc_key_id key has bits set above bit 23 are now rejected. Before this, the
driver silently truncated such keys into the 24 bit vni bitfield.

> An exact key above bit 23 already selects the wrong VNI.

[Severity: Low]
The commit message says the truncation can already be hit today. Should
this carry a Fixes: tag, and possibly go through net?

At the baseline, cls_flower parses TCA_FLOWER_KEY_ENC_KEY_ID with
TCA_FLOWER_UNSPEC as the mask, so the mask is all ones. After that,
cxgb4_process_flow_match() stores the key and the mask into the 24 bit
fields:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c:cxgb4_process_flow_match() {
    ...
		fs->val.vni = be32_to_cpu(match.key->keyid);
		fs->mask.vni = be32_to_cpu(match.mask->keyid);
		if (fs->mask.vni) {
			fs->val.encap_vld = 1;
			fs->mask.encap_vld = 1;
		}
    ...
}

The field is declared as uint32_t vni:ENCAP_VNI_BITWIDTH in struct
ch_filter_tuple. So enc_key_id 0x01000005 becomes vni 0x5 with a vni mask
of 0xffffff. The rule's action then applies to VNI 5 traffic.

The truncation seems to date back to:

Fixes: 98f3697f8d41 ("cxgb4: add tc flower match support for tunnel VNI")

No later patch in the series touches drivers/net/ethernet/chelsio/, so
nothing else adds the tag.

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> index 3307e50426819..d9a509be5c517 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> @@ -316,6 +316,17 @@ static int cxgb4_validate_flow_match(struct netlink_ext_ack *extack,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
> +		struct flow_match_enc_keyid match;
> +
> +		flow_rule_match_enc_keyid(rule, &match);
> +		if (be32_to_cpu(match.key->keyid) >> ENCAP_VNI_BITWIDTH) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Tunnel key does not fit the 24 bit VNI");
> +			return -EOPNOTSUPP;
> +		}
> +	}

[Severity: Medium]
Does this check cover the case the commit message describes? It only
looks at match.key->keyid. The hazard named in the changelog is a mask
that only covers bits above 23.

cls_flower stores the key already ANDed with the mask. So a rule with
enc_key_id 0 and a mask of 0xff000000 reaches
cxgb4_validate_flow_match() with match.key->keyid == 0 and
match.mask->keyid == cpu_to_be32(0xff000000). Shifting the key gives 0,
and the rule is accepted.

cxgb4_process_flow_match() then does:

	fs->mask.vni = be32_to_cpu(match.mask->keyid);

This truncates into the 24 bit vni bitfield of struct
ch_filter_tuple and leaves fs->mask.vni == 0. The if (fs->mask.vni)
block is skipped, so fs->val.encap_vld and fs->mask.encap_vld stay 0.
__cxgb4_set_filter() then never reaches t4_alloc_encap_mac_filt().

The hardware filter ends up with no tunnel constraint at all. It
matches any traffic its other keys allow, including non-encapsulated
packets. That is the failure mode the commit message says this patch
prevents, and it opens up once the later patch in the series lets
flower accept partial enc_key_id masks.

Simply testing match.mask->keyid >> ENCAP_VNI_BITWIDTH would not work
either. Exact matches today arrive with an all ones mask from
TCA_FLOWER_UNSPEC, so every existing rule would be rejected.

Would it make sense to also refuse a non-zero mask whose low
ENCAP_VNI_BITWIDTH bits are all zero? Or is there a better way to
express "match any VNI" for this hardware?

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. It
causes the same symptom the commit message names ("The rule would match
any traffic its other keys allow"), but it depends on the firmware
configuration.

validate_filter() in cxgb4_filter.c checks encap_vld only against fconf
VNIC_ID_F and the chip version:

	    unsupported(fconf, VNIC_ID_F, fs->val.encap_vld,
			fs->mask.encap_vld) ||
    ...
	if (fs->val.encap_vld &&
	    CHELSIO_CHIP_VERSION(adapter->params.chip) < CHELSIO_T6)
		return -EOPNOTSUPP;

It never checks that iconf (TP_INGRESS_CONFIG) has USE_ENC_IDX_F set.

In __cxgb4_set_filter(), the VNI is programmed only in the USE_ENC_IDX_F
branch:

	iconf = adapter->params.tp.ingress_config;
	if (iconf & VNIC_F) {
		f->fs.val.ovlan = (fs->val.pf << 13) | fs->val.vf;
		f->fs.mask.ovlan = (fs->mask.pf << 13) | fs->mask.vf;
		f->fs.val.ovlan_vld = fs->val.pfvf_vld;
		f->fs.mask.ovlan_vld = fs->mask.pfvf_vld;
	} else if (iconf & USE_ENC_IDX_F) {
		if (f->fs.val.encap_vld) {
			...
			ret = t4_alloc_encap_mac_filt(adapter, pi->viid,
			...

If iconf has VNIC_F, ovlan_vld is overwritten with pfvf_vld, which is 0
for a flower rule. If iconf has neither bit, nothing is programmed.

set_filter_wr() has no VNI field, so tunnel information reaches hardware
only through ovlan/ovlan_vld. In both cases the FW_FILTER_WR is sent
without any VNI constraint.

On a T6 with such a firmware config, could a rule like "flower skip_sw
enc_key_id 5 action drop" be reported as offloaded with a VNI match, but
drop all ingress traffic on the port that matches its other keys?

Flower doesn't reach the hash filter path for these rules, since
is_filter_exact_match() returns false when fs->mask.encap_vld is set.

One possible fix would be for validate_filter() to reject encap_vld
unless (iconf & USE_ENC_IDX_F).

No later patch in the series touches drivers/net/ethernet/chelsio/.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
