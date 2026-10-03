Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D8326D4C3;
	Sat,  3 Oct 2026 01:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790992030; cv=none; b=IkOl8ymaJUoxEGxp0lOCXgZR4f9wjAWdR3NY5Sufps6sQkzizPe5fcwaSa3OBoFCfJnt/WBt4ff5en9KSLPCjbSAmyVSuMii1262ArEs6ZJ+7iy4oYEc2YEJpgVOFXDqXVVA0hcHyLPYHFB8HLTNVrMsOJcImISH/D3Mx6tHPWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790992030; c=relaxed/simple;
	bh=q5XpWqmJWPGuDB1QB+D5maGSBu449Wra/8VoBwyZTIU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dgpey1jtlxtphgowp20sn+bOVWluPRbgnT6kandv5otHWkNDCwoITl2pHFjM9m1jlMi4/pKO270SKTfLHHxntcvfsuetoMGGsdS/o03XZ8+aPxKMYIA2uTtLjbEC6iaVcKp3ATosbEBG6PW4gWsKzL/H07gTC7ngb74W5Twvy1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IazBaSaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IazBaSaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FEB1F000FF;
	Sat,  3 Oct 2026 01:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790992029;
	bh=w1HUasz2Fa3z987AdOhJ5Db4ltOfBpYE9jYpiwaU7JM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IazBaSaSV3dgQmEZvzctGh9O+0ijxCRZlNyfL/3BzAN0YvgJC1tiM6HSn8zzYE796
	 pzqz2k/X8L3fQQSzQvR38INMGnZB0VScqPVxIdeX2P7J5m3JgTUJqvhQLe/Dgv5F//
	 4n4loWfKNLC/6ZfXbunULGcbZc0TcE07Ph20HEUfkD93s5hwzXazujSGxXO9uzuceO
	 gSdPjAAEB/7Ol2lJZjUQo6RQidbYvDGLO6yuP+RfxevBnhNOFSlx2AdELO2Jiljycu
	 d35mOx1CuHDbd4zQD5m/egXJ49JPB4Eoj8XOecqYPM/E1XM8jN7mxFZET2RftyOkou
	 D4MbTuFdXI5ag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net: mana: reserve RX buffer headroom to fix
 forwarding performance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hamza Mahfooz" <hamzamahfooz@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com>
References: <20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:47:08 +0000
Message-Id: <20261003014709.07FEB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
> instead of full pages to improve memory efficiency.") started handing
> out RX buffers with zero headroom so that two buffers fit into one page
> at the default MTU.
>=20
> The MANA TX path, however, stores the per scatter-gather entry DMA
> mappings in `struct mana_skb_head` at skb->head, and mana_start_xmit()
> therefore calls skb_cow_head(skb, MANA_HEADROOM). The port advertises
> this requirement as ndev->needed_headroom =3D MANA_HEADROOM.
>=20
> As a result every packet that is received and then forwarded out of a
> MANA port fails the skb_cow() in ip_forward() and gets reallocated and
> copied by pskb_expand_head(). This is invisible to a plain RX or TX
> workload, but it puts a full skb reallocation plus memcpy on the hot
> path of every single forwarded packet, which is exactly what a
> [ ... ]
>   after               0.94%         0.64%         gone
>=20
> Cc: stable@vger.kernel.org
> Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers i=
nstead of full pages to improve memory efficiency.")
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003013647.2051=
416-1-hamzamahfooz@linux.microsoft.com?part=3D1

