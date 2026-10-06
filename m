Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD9D4FB9C8;
	Tue,  6 Oct 2026 23:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330330; cv=none; b=KP0SMubPUKJCzOybl1fwFoJPr6UB8d47dCpyBwqkfnfH9rT041KWyUyIM4/oytIHywd6KFtvvOBhB8A77p5ReFIjH34r8KUZqao264SZCegYYk30FUcq8qHYkVi2ND/hgl4HvUzd2u1DumgH+WaxOYooPVq4WzPX4g51/4dJqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330330; c=relaxed/simple;
	bh=YI36dYov2yqyHKq9VNi0fUudfxq5/13WFd4plBuuECo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RD9WKvkojT6N61jirR+zS4G1fZq5QS4LPSOcguaYBweaVjyHstSpWmwamL8eHgQq3E4SjQ5DEJdnW55uEbn9P64jwKr5ISRCRm8CFu1aQ9jQblOMt/utw52wyD8Z+E5rxyWxYMEyJ4+2WkNux1Tp8fYm7dLpiMFdn4U/29K56QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzvrsLbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzvrsLbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F098E1F0089B;
	Tue,  6 Oct 2026 23:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330326;
	bh=YI36dYov2yqyHKq9VNi0fUudfxq5/13WFd4plBuuECo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HzvrsLbfqVmiPtjvRw+cBGJg9k+ddH/VN4IMz7+Mavo7weB8jocVzqZr9SVxLBTd0
	 rljhgP/7FSQFu61R1GUig4ybm7kzj5OjWhnDbl7sNbWaMZfTm2hssFOL4Pi30fVRoY
	 9DdcKhAhesKSbLjYade9JRB5Y9dxSvAqXVTKvrgBrheuuhC93XR1VSyAKcqyB3Riqy
	 9URA1Vkmuue7m+HzSP3XG09bW0bBYa8i7Bteq2f2vKmCaFvzVTPd8lUxt7s8CMerx1
	 isA6hwbDubaf8bfLM5IMT9vbJiBhowIQ1d9ZPFkdX1D9GNYRRiqdNUP4Et4NAd1jY8
	 2oeeMioIv//tA==
Message-ID: <sashiko-outbox-162520@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 5/8] nfs: tag READ/WRITE RPCs carrying P2PDMA
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: "Jeff Layton" <jlayton@kernel.org>, linux-rdma@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, linux-pci@vger.kernel.org, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261006233248.705086-6-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-6-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:45:25 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A transport must know when an RPC's payload pages are P2PDMA memory,
> so it can move them by DMA or refuse the RPC.
>=20
> Check each page as nfs_generic_pgio() builds the page array, and
> record the result in nfs_pgio_args. The READ and WRITE encoders of
> every NFS version then set XDRBUF_P2PDMA on the buffer holding the
> payload.
>=20
> Additionally, avoid using READ_PLUS when the pages are P2PDMA memory.
>=20
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D5

