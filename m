Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213353822A9;
	Tue,  6 Oct 2026 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330455; cv=none; b=cG2jqyPyTNgn+OJly5jkd9UnfApbubG0OIrOBO0CHEbDJ7LtYoIs6+NEUPN8v6nlMn8VLsMfg3xvfzEvjHDvqkRObqliyVd4jSq60LnNMgYXYWK4Xi4Zqf3dNlqJTEw2NnyeN5WcxeptJ3R/O9QtmI+zlx0kxJo6hiU5KV91gh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330455; c=relaxed/simple;
	bh=uHH5UfacDCkNszuTG/3ZQ1jp2iVSabGnOTOXXzmYG1I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KxbrTK7OAHlt0HL//NkxX6UAdDMba4cGmkppI577pMlAHyBR7daCkXli9l96UoTiLFn2bBKlNv5CY4NxL+cl+daF0atPo/jINIQhUmrehShko7IVlutLej2SMSjusSiPMNQ/D2c0G6jMQLin3Ww1DnJxPXv1KSunL4wUL6/TXlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF4kCov4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF4kCov4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB181F0089B;
	Tue,  6 Oct 2026 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330453;
	bh=uHH5UfacDCkNszuTG/3ZQ1jp2iVSabGnOTOXXzmYG1I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aF4kCov4QuXts3+7yAqwtfk2v7CuwYZEYn72EouaqjVikV5KZCdbC61iHQ9T/uZ8p
	 cD8z/1wuJsEYS/fjvaBuji7+8yr8ijHAUKl2nZ/LKQsJZS8UYC76iYzWaFuoG3iDrD
	 n2fwwSuyv0r+zfwtAN9k+iw9YMn3gHKoaNl5Kk94a8jkfoUSrv89hqPhyLd82Hmj96
	 p4wGe4DO3s4baUkTsL/Rql3H+ELYAYvK3eANYmio/KLormyImAS0eTZ7H1e2z5jEcY
	 7S4AOOa9PC2BmqT5/GXqQ84DEHweeBKLnb4iYU2QnKBDusxXo/jWDzgA0d83DCZM9h
	 gaFWFXsFU1Emw==
Message-ID: <sashiko-outbox-162522@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 3/8] xprtrdma: move P2PDMA payloads only via
 chunks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: "Anna Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, linux-rdma@vger.kernel.org, "Jeff
 Layton" <jlayton@kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <20261006233248.705086-4-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-4-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:47:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Only chunks move a P2PDMA payload by DMA directly between the NIC
> and the device memory. The inline paths copy the payload via CPU
> accesses or DMA-map it with calls that do not handle P2PDMA pages.
>=20
> Always send a P2PDMA WRITE payload in a Read chunk, and receive a
> P2PDMA READ payload in a Write chunk, whatever its size. Return
> -EREMOTEIO when that is not possible: the NIC cannot DMA to PCI
> peer-to-peer memory (e.g. rxe, siw), the GSS service forbids direct
> data placement (krb5i, krb5p), or the rest of the READ reply does
> not fit inline.
>=20
> If a server returns READ data inline anyway, fail the RPC with
> -EREMOTEIO instead of copying the data into the P2PDMA pages.
>=20
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D3

