Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC083911D5
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251572; cv=none; b=p5q91PdXeylNBdxfn+9O/2w3aUQ4sI6xCP99ZpT95Tgy3SJnyZcT+pDbf5uTHgCF1B6jEzIA8BNn4J7IZkJbK7FDbzfKaDvhSJmGdHqdu44oH8vL3N3xI1S78Z4E2Zogx3MzA5eAo3FO0CLTlViGjsB1/pCr+f9jFRdXdCN3O3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251572; c=relaxed/simple;
	bh=0Hzfg5B6gzQqsapSj1cia6XaF6zKJMoQR70ohGLmUfw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hSyHtCBjmi0gYb2qc4e69KyMvl+GafbH4clDp09xLNSBwNwYxraOD9v2wzaZ3kQSVe1u/Non0OteR1jxztje5drvD+ppQXoIKPwirSKOlNioSmERevWJ4/Nu93+YZO6A6VbBnmfpS+xiYuZESxc+12REIlggaOfiKVbym/bGYwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jmba+DXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jmba+DXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4451F000C4;
	Sat, 17 Oct 2026 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251570;
	bh=0Hzfg5B6gzQqsapSj1cia6XaF6zKJMoQR70ohGLmUfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jmba+DXVRKU4ZFylm3sEf2MFsazlVCpP1OD6VwatWQnjHtEaaQ8AKTvGQllh52pc4
	 gNvG7gMjpI9uZjtbPpzEhQSNs/vCx1RZzChgr1wLxfddo7dK6gE9kW2MxkBHlmAvTd
	 7uE/+hvk9diIZQWcWfK7yt/V33+CwVomgtS5ej+9mVfPvrzGU4E15zq42eDpD7s7Af
	 3HgeoGzGIrk1kzI0NMgRrtiYHJ8HpOPO3jtQ3uYzswJvvhwfiKm2RlUCU91mzs4+p2
	 S8g4RzOYo6BMvs/GE8+exafdXLox+ycIHF+N40jOIPS1Wu8PtdrOrOGX4yo8J1bSvf
	 kjk9ZsfKiEvvw==
Message-ID: <sashiko-outbox-175610@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 10/13] net: mana: release EQs left idle by a
 channel-count reduction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <a237256aa7aeb9441014005d3e07c340c60d1878.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <a237256aa7aeb9441014005d3e07c340c60d1878.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:29 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Release EQs above the live queue count after retiring queues are freed
> or replacement allocation fails. All CQs using those EQs must be gone.
> Return their vector allocations to the pool; IRQ registrations remain.
>=20
> Store each EQ's debugfs dentry in apc->eqs[] rather than a stack copy so
> shrinking can remove individual EQ directories.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D10

