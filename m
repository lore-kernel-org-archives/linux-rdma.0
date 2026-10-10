Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D464ABBA5;
	Sat, 10 Oct 2026 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643335; cv=none; b=BxiSSk7wHKRpbRJ6ijdFaUlnupSx8G9IfV9GJ8rKd5+OWlpZjrN6Ojyn9RKYZysUpifS1Egu487TQrqljVlvl/53uEHOpclq3xd6wzAotQGSypdd64lK1i7H/dozwLZKNG+6lrqzvNiUb1KIWc7VCkJxlWuLZFcu3zxa3kyEihI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643335; c=relaxed/simple;
	bh=BwItLQWuxbxFJJfePra7BG/f+arZd1WIQT3cf5e4Jos=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mEggl4hUC/jtp7etGN+kGCFpGZV+7/OzCR+PdRhslrGkCn5pnCVTurC9znsgPzh5oFl8bGkuWjzoZpXSfc39QpGbRKXhcPNPC25Zn7knQv2KV6UZ0uARbQvJ6OxiUPy+4AZFqYsy1eFimSzPS0vKj/NLqpbn6FpXs2Ex08/pXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCL2bqIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCL2bqIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449E51F000FF;
	Sat, 10 Oct 2026 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643334;
	bh=BwItLQWuxbxFJJfePra7BG/f+arZd1WIQT3cf5e4Jos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mCL2bqIeTwwBVfG4AegChg5HPYpJioFcxjPbVlyv67mKdn1LqEyNvjycAemFxToQI
	 Z2JPENBcNW5MzPZTPxbBvcNSB3vBVtkI4pe4NgroHHKQbrYVFZVIdiIaxGM/K725bc
	 MkJdHIqmPnHuHf/Pp/RxCfRuk7+fJ+JUn4HdCLQFFQkEphEUKRcvVJWb6a7O9Lgd9C
	 Kyj4ik/zz/2pJOkTYh0YPqwXC3CMbEZyDgz+/OlIEnmkDOUS/ioEyuK9n4etz+r+m6
	 Lk3QWeGcU0r5rjwiVRTGYiM5OYsBeD1q1jqxpsUAFb9ChniVbOJVwRq3bf1SsoaeW3
	 yi5YBlsq1Zc9A==
Message-ID: <sashiko-outbox-166668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 13/13] net: mana: keep the existing queues
 when the channel count is raised
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <6243b02cc7140a9ff340dbdb8b770d22b19ddb9b.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <6243b02cc7140a9ff340dbdb8b770d22b19ddb9b.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:13 +0000
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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D13

