Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316266;
	b=J0MQU6FEIp7NeLd2lHIhUt0yvei7cVQ/95LFi9la3kV6xGcfNX0QoID/qY06Pourgpqa
	 WmJaTO0ZjysYNjKebgGAatvxuE6gmeLPtaGfdx33p7tYefLHaiyE+xsdHZLo+YTWwOMAO
	 BfRx4XY1EX7a7JP8BGlS64KLyVVtdXlgCaV31irjbB/D/5VHdzasBtvrbp3JWAp5UxmXr
	 u7QDue9iaVhfscSb7SfXHdgBitrc2fr4qoJBbOsyUiigCaoRyS6rFjduqdftlHqnXuDL/
	 dSVYGQX9j4bnv+cOcqPbDSRhpV5oBMwyIdGxI9dNgd/DX7XThap9aZYLROUCpOkd4tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316266;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c94+piXRRFFXQkWGPHdJGcel3DpMhivr2KRedKsbaOI=;
	b=yt0sTh2q4dIkr2JN4A/A+OxtclBumueRyRVJiTx0lF95n3TiP6kJ6lk+ZwQ3LLEiO0M0
	 78ObZXFniP9A0cs2eHErXCosi9nohQWWYkSBqeBChNmnHzMUP4x/edtY81sUZmmN6AFV3
	 5av6r3ne1aXWTvJmlL8+EwMvirtpSVcdhI+queTq4SDDRBAq8Ia53d30YJnG4wkBLajsu
	 u55a2AAAVRNydH3EtfEifdnAtQ/ovc6HdakB8FRy4/5AWNb/3hiHQcLbTVNB2RZ+o94B1
	 PIPSeBrfiSe3/NhIEfWJdecPIZvDTtWHeUhX3dj/jL+H342TXboLV6W0y/dkWxNTzRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqHVMiqc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D6606A7EF
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqHVMiqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79711F008BF;
	Tue, 10 Nov 2026 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316266;
	bh=c94+piXRRFFXQkWGPHdJGcel3DpMhivr2KRedKsbaOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IqHVMiqcHq/cpC3ixhNJ01qfaqjZi4C5yH3txd18HYoPU3SC6Mf4q8oxVsg7U+S2n
	 UkcagLGR9bwX6PtPNjqFejoLWU1MmMEXpkTHLjn1kP05vtaMzI5ruhi5E33Uvycug7
	 ymTzEuAIuB8peRD8bnyVq8XtMQiyjKnmUoSWsa0Dt4mJEgfn4M05g2iq93xVTfpRNQ
	 JKbYs5qLomYqrKw9fdo8NDNRFkWqQFUH8VhEbNKmdCyi2H6NFLEnf264oDel51ULZy
	 nAO6fYsf0h2kH3Eaj7FUDAQEr1MwYWnZUyyGBGqwgvzu0nEf+fQ75gFO6zm/DEEvKk
	 DHaiIYHSaDW1w==
Message-ID: <sashiko-outbox-207099@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 10/10] docs: networking: describe tunnel key
 partitioning in TC queue filtering
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-11-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-11-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Tunnel key partitioning steers blocks of tunnel flows to RX queues with a
> mask on enc_key_id. Document this use and what enc_key_id means on a
> physical port of mlx5. Also document what happens to such a filter when
> its queue goes away.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D10

