Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BEA362120;
	Thu, 10 Sep 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079130; cv=none; b=iFZWZl/+Z+y1/h6JUAEaY5JENdD4jMNztzPXQNda7PsNnQ7y7jdX4YAZjPQU3wwBiVEJBpiGQIrXFCEl40gWy1g5Vj+JtXGRPt5Pq7Fil69DEkFKTY/s5vgaJ9duCx10GQYpRnuNVwjbfwBfwReJjYjhiycv6NrMSMs5IwRNGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079130; c=relaxed/simple;
	bh=QUgFNKYglcoAQMQ8Pu4IJiXtLqXQQC0HjMebEJ7yu8U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oRRs5b+VWL2RgW3LPtyIKuH60/r2tEMlTj1AAAmdkg5OpX28BC1rLyuS1HsqphHMr4Tgyvb1zevEeSoOqXcNODKh7YvX4zH9bsuphhuDlUzI2YW+bGa/y0fvbeVlAsK9KDWDl5Rq1Yk8aCQ8AMCC4XBcWbNwXacUVcJhlzr7pnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zfzyhm6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zfzyhm6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B14B1F00899;
	Thu, 10 Sep 2026 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079127;
	bh=QUgFNKYglcoAQMQ8Pu4IJiXtLqXQQC0HjMebEJ7yu8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zfzyhm6lZZrLYgfMiqQutMxIpwUZgU7sZfby/qTqcgrAe8vijjb4chnU16HB5x71L
	 VzpLdCdMG/fSB43a4BTQSlHBMi0et00b+IYUTjaA8oidGKyTEIq5uRKvQvEeSRU2BN
	 k3CpgbrkEDSgAHpyeNJA/5Ubmlq2/pMwSOEeQs2flgIsqEYxyu4mWGIwLxKW0u+8Fq
	 bEs93CI3wmUwW4T+0tdLayzmpNPMfdnSbDt/1O2zVyOYXo6F/5iNOP9Bie0h4b1K2Z
	 TvCV1VaUZE3REP0omNtTLzBDQkt3IggpJrH2s3OYRHkOaA89tpyBf4KFp2NdZG6ilD
	 0+9q3Hwqu21vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 13/13] net: mana: keep the existing queues
 when the channel count is raised
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-14-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-14-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:26 +0000
Message-Id: <20260910222527.3B14B1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Keep existing queues and allocate only the added tail. Growing N to M
> now needs M SQ/RQ pairs at peak, rather than N + M.
>=20
> Track the fresh queues separately for failure cleanup and XDP references.
> Wait for TX-selection readers before freeing old containers, and clear
> slots during partial teardown. Full rebuilds now keep the current count.
>=20
> Advertise in-driver resize recovery after converting the live resize
> paths. Failed rollback still requires recovery.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D13

