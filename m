Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FD64AA005;
	Sat, 10 Oct 2026 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643328; cv=none; b=NSQ1yI4AbbIl9ajfIsv5GTEehD5meBwpb9gVwhKcCI4cbEf2mI0FKb0RVKWWhTFfhq6/OSMxPcOVg2zxkk1TbrrrPT/UUMbHMwKKXcdNTDSBbwze+O5aKxLyyPOCISaW3HHnIgN10nynvEUOo5hV2zhxzzsiXxEem3wG6TiC2KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643328; c=relaxed/simple;
	bh=Lnqjs4TEoCv2GEaU0DNTw9vOD/5ONfZSryE5caGXuqg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pMsUJfrdOLVT1bHwcsfO2sox6xLVsP8ilkoH5z/aNtlmuxVx+eSeEy69PQhlMf52azL7cS4RJAFKR025CkyAy4BlP1ax3aUVp/oGkgnojFMVmHNyfE0pM+MqvVB8fuevugiyNjyroFw5DzdlWvLwCIm7eUTUj6yY9VUJQ4VYu64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1VPSH+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1VPSH+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B9C1F00893;
	Sat, 10 Oct 2026 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643327;
	bh=Lnqjs4TEoCv2GEaU0DNTw9vOD/5ONfZSryE5caGXuqg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n1VPSH+kXFe/6L/IaqowIYwZs7SqXY//aKXe6UGxq12zn0MMSNzmSKNQh7NwZ03mb
	 ZBpMTc5ZvUI/LjuEmj3Negmvpo5eE0H499Vp128UDX7ZfakeQ3Oz6Ic9jHzGs8Dd7P
	 v41eekZFz4SyxFjC8llNCntCKN5TzpkjqCwATHPhg13gaUtP+oUWPgEqnV428WjRlI
	 Q+NwoGfKFRjr/g9jjAhqHE8RcIphLYcsj7eOPASe7ynQQoQUrovaMX2BgQ8BAfifxj
	 gomwn/b3ySmI2VHmRXDopPIIXy7wD16tHntCYZOJURIeOgNBW2Ftjlk1tP2lXuqF/D
	 klVzpxz0IgZwQ==
Message-ID: <sashiko-outbox-166661@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 10/13] net: mana: release EQs left idle by a
 channel-count reduction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <6e4516ff65217677f0179ee4921752c3f86379ee.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <6e4516ff65217677f0179ee4921752c3f86379ee.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:06 +0000
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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D10

