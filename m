Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBCE4AB1CB;
	Sat, 10 Oct 2026 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643333; cv=none; b=R+B2TBx+9Q1IlRJDuWiWP5MCy1Ve0v0VMiZfNJ3Ny7Ghf/9KPLUM92usf6il6hhyOBAzCNpG2wxl63nRGobW/DoOHSmcEJL5fs2BR8dMY97uko7honBpSKlLqKoF2hOTPU9L4etEf1DSYLTcOvYPeBosYIWUdqxmNN5uvR3DIew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643333; c=relaxed/simple;
	bh=0LzmZAo2sfaZlGsULU3tHcoVQuRzcLVgGLjPSQNC2nM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IDBBJUwUd2yLViK/4ky7PlKlKkf9Ivuggh5f74mUBTNlSe0Dk86mNbZoOuheov2KnMKxi9hLPQBehHH/JwHqMzSh0ADm7lE1CY6Bwv4uSJVlPccFYKHBqxGgGIctPElzT8/wQ5lP/4CbRekmR0b84/aZIwibauAllV/7csr+7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQU15luh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQU15luh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619541F000FF;
	Sat, 10 Oct 2026 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643332;
	bh=0LzmZAo2sfaZlGsULU3tHcoVQuRzcLVgGLjPSQNC2nM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VQU15luhIfFxG5eHVR/9z6e4gUwN7pGK/27bqJcLmvEr/egnxQXCMMQia4SbOywNB
	 D7cOYZnssbFMhTcFSAHsnM/Nqi8oXSqxW0MGotBI5/x1JOMOATu66K1E3gLZR4WcMe
	 +mCiD1rTCls/Rpz+sP2G/I2vp6VkkE9JBcu5CCCNtvzPZm5BaSK/HsgbC3ono06INd
	 xmIx4haTCtX5XI0fQBaoZrW4qdYT0d+UsK14xiPu2FQIfoLoCU2PEjdI3NyWABpaPc
	 KoyCfF7HN/XBoRiY7wQ2WfFEhhbETc/xcLAfQYyXJUUYa/eKQHyimqMq6FBFgzUFq3
	 j2yuAFZAsKD9g==
Message-ID: <sashiko-outbox-166666@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 12/13] net: mana: keep the surviving queues
 when the channel count is reduced
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <6cd5cbe37973685f58b5cc54a598f3df8ac48e52.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <6cd5cbe37973685f58b5cc54a598f3df8ac48e52.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Split the live set into a kept prefix and a retiring tail. Reductions
> allocate only pointer arrays and steering tables, retaining the kept
> queues' page pools, buffers, NAPI state and XDP references.
>=20
> After publication, wait for TX-selection readers before freeing the old
> containers, then retire only the tail. Failed publication discards the
> new containers without freeing shared queues.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D12

