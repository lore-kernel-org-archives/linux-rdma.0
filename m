Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF44839A04D
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251573; cv=none; b=e2l/wtadSebG7LRFACb5liA/ytc0ij6JMBDsL3RG3/S789RzboIWvZP9WBoCCdElGU2ZgoFw0apdJfu2kKoJRBAjFTvyxD5RlJKTu+iGV8za6sNMmKBj/mPeRau87NjpF57ibt/IDv5JgdT3Ycxcg1eLeG00kMVaYW2Q5WHB15U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251573; c=relaxed/simple;
	bh=c3O1QpSywTMYZ3N2P5NwYBLt1Sx6zeGifBYCdo7KCs0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=r0pMGcCuZtn8n9hIZeKEYmZ42rQ6Y2bYTqjR53IyJM9mLor/E7iW9vFHpR5qnEfCWCrv+RUjjoNrN4vZwZrIe/6/n7b2rsALMfUgeEFtPb+pPveEbbVNTJ+VJECrsbgwTV/0GCsqvKT02anG0S+MuYCv+8r73c37rdKsTmjn9eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyIZcsBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyIZcsBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873861F000C4;
	Sat, 17 Oct 2026 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251572;
	bh=c3O1QpSywTMYZ3N2P5NwYBLt1Sx6zeGifBYCdo7KCs0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JyIZcsBrw4PeONK/+uEF+FGAyIPOx+uT8fL+6vgjcmtrSqlfj2A9vsOwKsjjlm6sA
	 lrFqIVD72L9JTuF1NpslvsTreFf4+0d7t1jbmclJALzjmZoGOzjqj/twmJXe2jXtpT
	 6jptcMzY27uNCuH8LbKbH/+cfhPIbK9MpcQ4dnxFv7t1RXg/IRsLSZeZVMzu+WvON1
	 CB8Y88XdqotUIVs0bE034v6I51TtoPqD1h98VpeXispE3YX/v/62AokpqBwJFtnNp5
	 JO+EPt91T7akS10QZEs8IhOgfNpvYRANHi+GTqcC8WyBey4sLidDv7nyO5dBcGJWd2
	 ojlVK3V/r5lYg==
Message-ID: <sashiko-outbox-175613@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 13/13] net: mana: keep the existing queues
 when the channel count is raised
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <73d87e454e79867ce3f2c685c9a06250cf6bd0c7.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <73d87e454e79867ce3f2c685c9a06250cf6bd0c7.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
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
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D13

