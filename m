Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1514BE44C
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789647087; cv=none; b=Lxa/3TipFLlt4xsz4666yPzUBytyth7Y+XlWr1Y4LwK6m/ZIalDqKSd3gIYNVxMs/ko1kndbELQdVIWY5+XLiLmpmxI4ZWGmIKSdkdKaN+AHBW6lyU3RYj3MLHtpJq9zK4OX9d3NWX9/z6XTIcxckW8IiBSoV1ye2FOCL1Tc1hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789647087; c=relaxed/simple;
	bh=u7qhWkbrj5Y0MqBTz8J2LVR/8dmS23CqHVcS7O2Y51I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GED2HBKcRncVtuH/RexvSngRapb/j/NcC9WJy7dRuqRp4SP2acnWI3ZraoM67kZU5nLW9MK6YisDNNlcPnc4Ti3gpXQTewyYPd06qqzbc+v3oMyqb/JUTGMNJeD5KQjzowPlgsxmzgc6QGCW9WZxaIX1N0dJc7Ea7oayuX32aLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtQHG0tM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtQHG0tM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0141F00893;
	Thu, 17 Sep 2026 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647070;
	bh=u7qhWkbrj5Y0MqBTz8J2LVR/8dmS23CqHVcS7O2Y51I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RtQHG0tMK+bVt4HgbL6ziCJoxAh5XSdYooRUWGIDFfZ6G4YM7mf/XllHZIwGASOcF
	 OWVTwCaN9yQPZnlRZM2sKXliD8BsFk7tP8N4SqX+dEURu9Jpdw9ivp/64Fh3oBArUK
	 7vXbCwsxV2iGydxYQ6DO5NRrAzHEArrFa4puPWEjVgJH05DypzW/RYgwxNAFbzkffL
	 +quI4RbHUB5of9dr0D0rkOmH1Fxtk8yUyHrYRc4k6HLkQPMyqIYOaNwB0u8zF3Eho2
	 s0/gnmBHDko2LbrobR8EMrzHjIYmhk++vEUcZv+w6q4nOkCYw4EpTVIVugDt5zPc8D
	 5cjq7fQhI8OEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v4 1/5] RDMA/erdma: Unwind kernel QP
 initialization failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917120459.13286-2-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
 <20260917120459.13286-2-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:11:09 +0000
Message-Id: <20260917121110.2A0141F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Allocation failures currently use the normal kernel QP teardown path.
>=20
> Unwind failures directly so free_kernel_qp() only handles complete QPs.
>=20
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917120459.1328=
6-1-chengyou@linux.alibaba.com?part=3D1

