Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E8E4B1263
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824285; cv=none; b=WcmgdLi6/okFZHz9nQnhCQeRDIB4urBZhpMSMJcbfUsA9CP5koDn52GSD98+ww16gMer5rw0oZZ3Q6dNtf2gst+t4WLkE21Rmm/bDIwEj7Ed+qvyMJTNiTTXm3npEQrS2tVPsrB5AVtleK65ySO65V+/xK1fAL9wtHIkG2MRu8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824285; c=relaxed/simple;
	bh=939dvhKfW1org1O+6FXJwJ37YGtUdAlZk9F2rzHH6DU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Xxe9LvTIIzCVMPde+7U/OOLZfP351QloM0PPbnIlvrGnu6vuWDco7xygrYyH+90sTraiDyB6ncmXxFMDcA2CBVXfLQnbwD645ap5G25k+7DySQ9mms+Vww2wCG5VxaWjIv70OYCIT+J8Zq9BRQDmqiyiSVmgakgR2j45X34nZeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ks+cH18/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ks+cH18/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506ED1F0089C;
	Mon, 12 Oct 2026 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791824278;
	bh=939dvhKfW1org1O+6FXJwJ37YGtUdAlZk9F2rzHH6DU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ks+cH18/YAeI5akF1kwLnyIpmA5idPpGSvw/XkzhTVu6xov49ryWKJlRUgPgnhwyV
	 YcyAxeYCY7cYlIxmPJOZKo6mSdawuGTjywcsSn8F5LKqjp3TLhjhI/MaZp/1LVqDMs
	 JFMWDZWy2kIY6BZyALLNqy18ZyQaBVqsKG0oxTGgnxgxauTEK9ctSUe55ZV3RspnjF
	 tG3MJDZ1UBB++IQIthRHykoiZf552UaYE42b3YIACUZWhvv+7MUgrgXxXcj+FGJfrP
	 gKY5eyDP0/fobfW3XlUGXBFjlZa2501PS0P6o9LSWw7u25wYDQouSo9FtMQvovJhFz
	 aRygAlPzeAcFw==
Message-ID: <sashiko-outbox-168440@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2] RDMA/efa: Fix race between admin command
 timeout and completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yonatan Nachum" <ynachum@amazon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012165113.576899-1-ynachum@amazon.com>
References: <20261012165113.576899-1-ynachum@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 16:57:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> An admin command that times out can race with the interrupt handler
> processing its completion, in two ways.
>=20
> The timeout path releases the completion context without synchronizing
> against the handler. A handler that has already seen the command as
> submitted then copies the CQE into the caller's response buffer after
> the waiter returned and that buffer went out of scope.
>=20
> The waiter can also observe the command as completed before the CQE was
> copied, since the status is published first. It decodes its own
> uninitialized response buffer, returns success with garbage contents and
> leaks stack data to the caller. Both wait paths read the status without
> the CQ lock.
>=20
> Add a timed-out state and publish it under the CQ lock in both wait
> paths before returning, so the handler, which only completes commands in
> submitted state, cannot act on an abandoned context. In the interrupt
> wait path test the return value of the wait instead of the status: the
> handler signals the completion after copying the CQE, so a successful
> wait implies a valid response. Read the status in the polling wait path
> inside the critical section that drains the CQ, which also lets a
> completion arriving on the last iteration be honored instead of reported
> as a timeout.
>=20
> Fixes: 0420e542569b ("RDMA/efa: Implement functions that submit and compl=
ete admin commands")
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Reviewed-by: Tom Sela <tomsela@amazon.com>
> Signed-off-by: Yonatan Nachum <ynachum@amazon.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012165113.5768=
99-1-ynachum@amazon.com?part=3D1

