Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22FD389455
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790411342; cv=none; b=UYSXpjs4AcogmtSu1hNwKa7F9G8gneIsoFyDVVFvaBedM1cCXgcPGKh1QDhe52C+TGHVJV5v5x/dhmLJyA6VEX8gLwz/NQoXuv15eD3lhpb8n5sFkSWv52iSQPT7bfg9vl6mH7brxpSxcy29pB+zKwAzz43iQn4k5RkjFvY6B9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790411342; c=relaxed/simple;
	bh=LpeOABtVXZdsxRdFP1bHtJcUKvEn8+RzXO668BrRDrY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IaPYBg/0dLGdvBCh/04fTcmfQGC0XAPqiVJiNGQSfhaFSqJQtdGrsOenbboiBLPihIbmVW1LAboBBhkLWM7Pqkyy3YzIJkF/5KnTkb+tI0iyWd1okPeGzh7aXpm/VTURKfCDVgZ+xX7c5XFT7T7hT9JVcWhutFqby8BhakaaeiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fgo7og4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fgo7og4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BE91F00893;
	Sat, 26 Sep 2026 08:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790411341;
	bh=LpeOABtVXZdsxRdFP1bHtJcUKvEn8+RzXO668BrRDrY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fgo7og4gKYhY2kpq3Wdf8ey+CGsHt2Qwr7OR2xuRxnbOMLlDEaHbfAtUSDiaQq2ba
	 g036puiT+HOupT/tzw9VDI3h2Ihr7fVq5YngtAi5w9BtG0tfjaJuY6BkwqaGMCbzkp
	 vNR8SuElLCiINBPhnH4AAMX+5ZkFRlDt2iBkIPFi95QE0pb6LT5NlzVbEWgHjHVxVQ
	 4LAcivLlPo8KNh7tMLdE6eMElDddGJc05fMu8RyLl1WuHHEsWvlxJwCaEYS30rb5zi
	 VL1QnrhPTWQwovzqLlONW1GK1NLYi9KnzrWs8r8jrUDJOZAkb+4EKouh5Ace0eBlA4
	 k6osLrn+yLS1w==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v3 1/5] net: ionic: Fetch qid allocation and SRQ
 capability from firmware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925082802.2675902-2-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
 <20260925082802.2675902-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 08:29:01 +0000
Message-Id: <20260926082901.89BE91F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925082802.2675=
902-1-abhijit.gangurde@amd.com?part=3D1

