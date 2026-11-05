Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874845;
	b=BYKIrwMcp6vAkCfmL6a4xVut0SgcdT9zU5R4E0jJi5VgDp9dDIsOBMX0fBfRdFtB92w2
	 PQjF4p3u8GZCi7G+61ZPUL+zy+B5xiPDAoXI2UP1SraUmqMKXW/lOU3SdJfDI/75H4KoY
	 dDLvaQ3rBcrYZV3AmeNYPwLUpdEHLrnTNS4QaJU583HphEe1j+8OsDQ4hNtM3EYo/Jdmo
	 JgZNoGCklDoasMIFJIJ+cdaOwW6FS2k9ZPsiYWH7n+dlXgyJ/awy5v8i05d376CWfZOCv
	 MaPhGD4Kk9yaVT2WleuyAnWihA3qlrt0rEuJ/ps5VE18YmfL1/05A1mZqPu1yWN4xHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874845;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NyAceO/MJFGJjiXlZgfUZmtye9yOWtLzL8s+YGHPOMI=;
	b=ACDMLrmamOHWmnhwqURylfOGjAkrlWPxrXHKQZMcLKhIAGpISZZlwum0WJJQU3aRFX+C
	 mwGWonwaPQRJlSF6tRGTmNI7hG5cD12yzSSPm8mRkNqkxrSNfCUA9SK8llIJBBFG5lumK
	 ISIAC9FWDyPrIg9QyVQJcFrjzH/fBnQm2KMLwWZnXKABwm+z7bkcsLzv/52FYATrSHtmT
	 6kQ1q4aOMdDztm+WmRyhAWGBMWb9W3s65NyOLMlQSLoKyjJrtTg6+OmaQcnWs4ClkjYoG
	 W013v7BApXcWvZG75KTHGUJwUnj+kUqJvwMaYXJUrivLzNdeCSsaWx2G/Bh/P/dC3WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ew5+/f08";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DF3606A31B;
	Thu,  5 Nov 2026 10:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ew5+/f08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370BA1F000C1;
	Thu,  5 Nov 2026 10:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874844;
	bh=NyAceO/MJFGJjiXlZgfUZmtye9yOWtLzL8s+YGHPOMI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ew5+/f08yk2SC1W5hOtWF459niG98EUL5CyE5fpB9mrgQH/OMKLkeOOIrjZZ4Xktb
	 98UOZ0qB3KMlHGb2Zr+YGsoPMF1k79bgzvwOlQDMSK07IAiNrRCKnS6RCxcWIUMF6w
	 nUqCa7AhaU67ig54lUQYgIZThugfyI3Y6V27QATMstkZ5iCL/M5V/6/0pVdhtNgVXK
	 nhHA7IpMm2H5hNMDChoVHAK1Au+iTe5VXC7IqlefpUtx8l1SmSgk1yroorriqyo6dF
	 uEq6DLr9b0BnbKIA0INOgJwxG1atgzVrdUj1dZfMDggzAGXxza6PWIlYPDN4yhPbvx
	 SPiIx/W2Wi9tw==
Message-ID: <sashiko-outbox-198861@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 18/19] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-18-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-18-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:34:03 +0000
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
> P2PDMA assumes every client issues Untranslated Requests. A device with
> ATS enabled may translate any address it is handed, including a bus
> address, and Translation Blocking can reject its Translated Requests on
> a route the Untranslated answer called usable.
>=20
> Unless the client declared per-mapping ATS, take the Address Type from
> its ATS Enable bit. Never hand such a client bus addresses: only an IOVA
> survives translation, and whatever it issues untranslated goes through
> the host bridge, whose route must therefore be usable. Apply this after
> the topology-only cache, and in pci_p2pdma_distance_many() too, so that
> provider selection agrees with the mapping.
>=20
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D18

