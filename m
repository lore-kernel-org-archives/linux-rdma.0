Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608054DAF99
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776918; cv=none; b=VO8/mK2yJ2FzwCcrdbDr3YMleTfjvyxY+2pCtfWmQ1eWa7T9jvnI1LfKLp1XHWJUuOf4jVSOWqWmBCkmynvb2/Jtc7BqNUgOCgmX4xBiqFRdOkfgCPkWFXLMv2Fowh66JePEP/tGJ576t7/GU4iXlxTdXiRAoAWZYi4QoazldUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776918; c=relaxed/simple;
	bh=FIW2P1TrBNbQa1i96SyDvBXEQ/EYAegILVGs+KDEbkU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kMb75AsL5PS8htGRvOuto1yTsIVfNBSmqiwNIjBCfFsRlozOfZk8zNiXFRDZJec7V9X57/k3w0Mf+KyZg/TmZFBHtgVpKhIyGReUEO+5+GY0rnlBi5u5hrSrMEhgCiKhVWVUP7yNWDMVUxumF9Jm6Uf/PotC7mejOpUyQkH2Ij0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TthFVIb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TthFVIb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0DF1F008A0;
	Wed, 30 Sep 2026 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790776904;
	bh=T+hO2EKfDevPHT8mbCYOgLhMFaU+i7q121/BgDyp52k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TthFVIb2BBmOD+B1RRWEm1UdFaoV9b5TTm2mNkuolpUtsCsiObrKmXnRN8KsQayxb
	 PjGDNW3wygvXA9/igEykFIPCythTzKJuZ005ATzt2HeWvT9d+THnzVoa629ULuyXpN
	 faxsBDOSG2SVppeGbOZBE6boBDzk5O11l3S8TMb9NOxW0HGQgHGc8tSXUYsOIeIteG
	 ATt3Da0Q9EuN4wJ+oPHGabCbiXppiTApggwe4fDOupfoywovBxqvdhO1NZNfovRj1M
	 IburVX/6PuQP76bbgnEWc8TiXWmQWJOaX7j0sw+qOkAKjokYGfsSzu+vsGx9nxUqjb
	 tnA29FQAnfbxQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe
 is missing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bjoern Doebel" <doebel@amazon.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930135530.881281-1-doebel@amazon.de>
References: <20260930135530.881281-1-doebel@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 14:01:43 +0000
Message-Id: <20260930140144.2E0DF1F008A0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> On a kernel built without CONFIG_RDMA_RXE the test exits 1 instead of
> skipping:
>=20
>   # modprobe: FATAL: Module rdma_rxe not found in directory ...
>   not ok 467 selftests: rdma: rxe_sent_rcvd_bytes.sh # exit=3D1
>=20
> Every other test in this directory probes with modinfo and exits
> $KSFT_SKIP. Apply the same guard, identical to the one in the otherwise
> near-identical rxe_socket_with_netns.sh.
>=20
> Fixes: c67bd973695c3 ("selftest/rxe: Add selftests for perf")
> Assisted-by: kiro:claude-opus-5
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjoern Doebel <doebel@amazon.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930135530.8812=
81-1-doebel@amazon.de?part=3D1

