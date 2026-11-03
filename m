Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704032;
	b=wkDxwYLcrafhQNN6l2Dd2Q2uF3Fm5JI/Ay0xB3T3T78wuHAAbtq3wyi+lnOojf2m5zCd
	 klDzkmn6VDk6FxRWE0SOoWzSHfWO6tkE1BI8j2sccLgy3tcznSNBl+iQFhjlZxfC54aL5
	 IFbehQjuaGRME4YD+y/8+K1GV9PSn9AWLck1CRBc2H2wPkdWVuhkZ2Fw6jQlk+g515So4
	 7hDjug0onSGEzg+r5Qx1PgEyY+A2XbzQPrwlIo3cyU2K2yEbDLrIt9/UMHWF/Kz9jVcOi
	 Np2aDTcAj82041olgMlKRf//j5EgzIA6VdwRPG1yuvNazkO7hD0Ew81s6PBa8FVqaAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704032;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VufiRBhB7eiuNM6tbNQyIOaETyuiGMibcekOp0wf2tU=;
	b=Doz9GS/wC8KXRq9tHRaZOShMsj8ZET1tasLGeqkw/FcWz6ht2CNQYMQnivLYEvcZvd/1
	 3uu9p+jg1JCN0/fvLc3ZDIRWFZK5LOLy1sxrUU7gzjFj1o8tKpfm5Kt8FmLBJD5WiCC/U
	 zPeh/voPEmhg8NPE/W5VgKgh6vpI83kchel80BJFw1DhaUGNXmMPsDyiTWYGK3eyUz8dO
	 pAaFPhGn0nxvlfhesBWV/V2YwSw/NHQCNnpYrQYUis0OIGyBtUUynOED/C8VcGdzn66O5
	 G0JoqQH5tM11G9HrMTTe012o+8istIfBxDULypXo/CT70ULYxy9a8AjnetgrHhxANbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TO0ClN/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FE36083627;
	Tue,  3 Nov 2026 11:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TO0ClN/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D801F00A1A;
	Tue,  3 Nov 2026 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704031;
	bh=VufiRBhB7eiuNM6tbNQyIOaETyuiGMibcekOp0wf2tU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TO0ClN/SjUHbftbHB7HjlAMa6Rr795JjSDfBLQp06b4khgmEe4GZFr+krjj5G+/Sr
	 JdWCyXmFCWgKxUS7805ncPDhNNvne4+wwMzBjlibSO8ldFpSnambbew0BjPM0zUAj8
	 Dou/IM7emLf5H6/9C2ldzDfywSivRUJSh3OLwCYO0YRH0gVSSEM0zsIL45eIlPcrsj
	 a2pJy/H8UPmMmS73RUKPuJ+ElUGpCtVEgjcQdchzyMVCXQwEo+U+xzZquVmx7YS0Le
	 SCHX/xG5MvqbG3sC3gxqg7adSABWVTa/BjtWnFf9VYTzGwnGgulJrKqDAbkmxp4tGH
	 ntxxwlqnvCCeQ==
Message-ID: <sashiko-outbox-195109@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 14/19] PCI/P2PDMA: Test the ACS P2P routing walk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-14-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-14-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:07:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Routing depends on which ports share each path, not just individual ACS
> registers. Sibling functions without internal peer routes must use the ho=
st
> bridge even when redirect controls read as zero.
>=20
> Drive the walk over fabricated switch and multifunction topologies with
> fake configuration space. Cover directional controls, nested ports, TLP
> attributes, hardwired isolation, ARI, PF/VF paths, forwarding failures,
> translation blocking, host allowlisting and packed cache values. Keep
> external peers and self-DMA independent of sibling routing restrictions.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D14

