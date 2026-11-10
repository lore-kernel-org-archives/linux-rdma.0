Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316263;
	b=tHO3gPvi6bY+O4DSEsqD3HbvQ10PpCIL3023ujJFO5kaGaWbxqTVOJB1O2isPD+RAlyR
	 SNzezgxVt7Kgid18G8pEdTLQ9/ymQjERZyw78sRxX8YQnxIIgANqZv6GKxMx58vArWi/n
	 e/Nn4WHh7oO27UftOn/gN7y1Br2f5ri8o4E+xf30qwJ9MoW2D+TgVmvLZ0vVQc+mYkhY3
	 cDxxG7CjDF/c1gsJKVtIBG7vHH2OJlrTGVeN54tFnRTLMiR79SjJsRb3AfyFnmw0RXnwq
	 fmFGt8JGA0W1SwIZj5zDNyp6EiR+Y/H4t7j8bRPlRu/A9hkK94MvULQPYi0G9fJVmQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316263;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NsjfH+4XB123QrJ+WNx8IZ8S8m9zXyvV4fnL9vJx20c=;
	b=sgoxxafE1OQJYAW6Z48p55HAxcaW1bTs2LFtuSRr2jaBbC0lzQtmoHRShL74rMC3LGKg
	 nF0sVIteAeXe2xds8oXxroOj3tsfK12hM1ka7+R/rdgClQj09g4xxUl/oEPhzAPp/fkjx
	 Rdo7s4qu9PLSX2GI1H6NrjsWWe320uHd/EdsAL2mh3dQNPNUjAJvPvoqdOff5uNKOokKj
	 14dOiTfyiSE5/DF1NkpkLNoJqknGaFgBjvBPIhLmJvMNgcbvXkwORXqeiKiogvD7BjYs0
	 uYKyuy6y+6Ir+KRVHQT0daF3FJB9FAQaraY/yN5FtHBYEfl3a/C/3bUaDH/xp0LwD9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgJdUEqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74583606A7D6
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgJdUEqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AA31F00926;
	Tue, 10 Nov 2026 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316263;
	bh=NsjfH+4XB123QrJ+WNx8IZ8S8m9zXyvV4fnL9vJx20c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jgJdUEqzuiO5Il791TkFQarc0rYEQ4vaCE36meWUF27kRaduE9XWMQrOREMo7zb2j
	 bMc58VRSVbHSG1c62WN92ZVSuGGTQVEZ9xQuPzS1D8XQ+AD3w4QCMo7saIu2MC877z
	 MDosVlxNNdHN/toryg63O9W3OeoCXAj7RTZ05+AfsCkOGCA4h8FGAALht2t/g+2Xi3
	 D4JV2Z1ogggMKuTU/Np9AfHqBvAedL7vHyEyB+Cz0shXketUSTrNcPW+dKLirgULZ6
	 kcF9SLHQJl7ddozpNe3MLbiMwWNXIvekJ7XMjrJkS3A6pFqQKPEReldpoLyXOqICj9
	 j/185LNbBtudA==
Message-ID: <sashiko-outbox-207095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 06/10] net/sched: cls_flower: add enc_key_id
 mask
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-7-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-7-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/sched: cls_flower: 24-bit VNI mask truncation in
  fl_set_key() offload
--

commit 3a83a862ed7b57be4e00c4d6825ecaf80ce19865
Author: Alexandre Cassen <acassen@corp.free.fr>

net/sched: cls_flower: add enc_key_id mask

This commit adds TCA_FLOWER_KEY_ENC_KEY_ID_MASK so flower filters can match
tunnel keys with an optional 32-bit mask instead of only exact matches.

> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 23eba4a00a947..dd248a335402a 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c

[ ... ]

> @@ -2110,7 +2111,7 @@ static int fl_set_key(struct net *net, struct nlatt=
r *tca_opts,
>  	}
> =20
>  	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
> -		       &mask->enc_key_id.keyid, TCA_FLOWER_UNSPEC,
> +		       &mask->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID_MASK,
>  		       sizeof(key->enc_key_id.keyid));

[Severity: Medium]
Can a filter with a 24-bit key and a mask that only has bits 24..31 set (su=
ch
as enc_key_id 0x0/0xff000000) truncate the hardware VNI mask to zero in cxg=
b4
and mlx5?

Commit "cxgb4: flower: refuse a tunnel key wider than the VNI" and commit
"net/mlx5e: TC, refuse a tunnel key wider than the VNI" only check that
match.key->keyid fits in 24 bits, so key 0 with mask 0xff000000 passes
validation.  In cxgb4, truncating match.mask->keyid to the 24-bit fs->mask.=
vni
field yields 0 and skips setting encap_vld, programming a rule that matches
non-encapsulated traffic on the port:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c:cxgb4_process_flow_mat=
ch() {
	...
		fs->val.vni =3D be32_to_cpu(match.key->keyid);
		fs->mask.vni =3D be32_to_cpu(match.mask->keyid);
		if (fs->mask.vni) {
			fs->val.encap_vld =3D 1;
			fs->mask.encap_vld =3D 1;
		}
	...
}

In mlx5e_tc_tun_parse_vxlan(), enc_keyid.mask->keyid is non-zero, so it
truncates the 24-bit vxlan_vni mask in misc_c to 0 while still setting
MLX5_MATCH_MISC_PARAMETERS in spec->match_criteria_enable.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D6
