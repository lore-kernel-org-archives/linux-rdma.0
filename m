Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9EB4E432E
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789647231; cv=none; b=qy9rVbJNtEodJtIhaDlnN0mMRrEBJbEzeNTLO7cvkmawZUWTJGszlku55HheMYCpOSIKfMx7GMeA+0KO+pzHw1zlUzEGB7IcGyp/+DxZSESZKEyexO5WRhY/3qtBRsdOMVUNtg1Fu9dw4Re2NPKpHnc5VzFHvQQk2aLk86Kkeow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789647231; c=relaxed/simple;
	bh=lrGd2w4WFvME5pn/K92IvK0/0ySg679o1zT+kCcf8HU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lxqaREvqNpHnYe77f7nU8PeQNJEAVpHwsu+yq/00IzL5gIMD0UqO39+N+oS5KE9WCW91odzQWJWCttc3A3eKs7leTdV+Q5xilFwE9JkQQz6Lenvlo/NZ7yF1bRDtze5iGNJcfF6pL0Dekx3ctmhCP7QRCkv1HAlXLKQXdiB+i60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F47W3IRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F47W3IRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F41B1F000FF;
	Thu, 17 Sep 2026 12:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647217;
	bh=lrGd2w4WFvME5pn/K92IvK0/0ySg679o1zT+kCcf8HU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F47W3IRotMDo4AT29F9BMh53f+/H3zUYBK2+7Q93gFurArKT59iNFbVkZ3eFysHRe
	 n6jKTPa/XLwFO7Mj/xE4/jV19DwbXDNWCGfUjX6AaiyU6iluTjegy7MCcCDQ2EB0lC
	 mv4LVP5Gn4ZJKFCKdlc35i4bA20/d62ujw2mwlE0+qQsYpIcXBQlrIthGJ+THIbLo4
	 HYJf5ST23KnalMnWCpW5V0KKrXRDIh1I5yz2XyJmNVuhnqUQNC6Ip4wuKK+y/fvIMj
	 /B50vOxTbISzhTOOBJrbPqqE7Z2DHvIzGoOuOk510SR9yHws7jNsxcdEw0II0nAYwn
	 QKKccKdqDB7jQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v4 4/5] RDMA/erdma: Unify userspace and kernel
 queue buffer management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917120459.13286-5-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
 <20260917120459.13286-5-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:13:37 +0000
Message-Id: <20260917121337.6F41B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Userspace and kernel space queue buffers use separate helpers despite
> sharing MTT metadata and lifetime rules. Manage both through
> erdma_mem_init() and erdma_mem_uninit(), while keeping backing allocation
> and release type-specific.
>=20
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917120459.1328=
6-1-chengyou@linux.alibaba.com?part=3D4

