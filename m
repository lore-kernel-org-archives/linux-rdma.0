Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47354FD267
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 09:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846663; cv=none; b=b1FBDhYGNIBRqZZ4e8/qPCAwEwzE0FIHSHyrjbo1DlUIGX4rN6lBZgBkxZH+bKnnWU9onmkiEti4EluGu7x5iTPiaJa+ztm81LXXN2/l/TEJDQiqx/WF2tu4Ou92m+83yyhJcYfElmyugjUmAfL2Fav/ynI6o0FVWVR4Vnxq6O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846663; c=relaxed/simple;
	bh=QZQ3T8JiiNzQqTCb5CL/oLbaJxiV9FjYFHW+d48gfJ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aqGVXshAkf61eae6apU3UqIf0rYBtJP9zQe6hmiUNQm/1WCob2yAUIanQli5RuQiRHPqhJjFAxaEBshzFLu3X/mxCgPWn8VY/dprQU3jT4Yer88WQ0GWHxtlTHZlTaJeX1M8vSbVzVkNkVnRDzi0UMj89sywo5kNOp2SL5Jo4As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQRMx0ar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQRMx0ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B475C1F00899;
	Thu,  1 Oct 2026 09:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790846658;
	bh=QZQ3T8JiiNzQqTCb5CL/oLbaJxiV9FjYFHW+d48gfJ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dQRMx0arN7uQFW9LYIJK+3EDJYACt8Azqqqd1QJsXrO034VRmbUBjixSpXxqMXX+j
	 xBwEx+3+TvTbGNo5kGNqpqDBbn3bh2N1A2CWWdXJWGCpPAe6HKaQG1BCTcVqkmc77A
	 ozq8cTSYu/H0rjvfzjc1Km9zKj5JeIxUt4gY5x4iPMHIqqPU5WLRkzZy++LjE/0FBF
	 ChwlbSQlkH7jEtnyUt4vCsv4eTXjHRDE6P0f4pMVbIiQB0MnZ8GukOc5z67ndK9KcA
	 7NKTIhnmMCvaSN+3dzJd1PtC6uXJpo8tbGhmxYrcyUbor/oOpzyfT0S+qDPnzgusxe
	 g42qmSx4oBTUQ==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 1/5] net: ionic: Fetch qid allocation and SRQ
 capability from firmware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930092111.3176738-2-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
 <20260930092111.3176738-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:24:18 +0000
Message-Id: <20261001092418.B475C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Read the qid allocation and SRQ capability from the RDMA LIF identity
> reported by firmware.
>=20
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930092111.3176=
738-1-abhijit.gangurde@amd.com?part=3D1

