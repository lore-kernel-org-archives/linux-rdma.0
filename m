Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D71836B907
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579844; cv=none; b=KK7svPxlvm9zb7leB8uPTpLPIDmuIaJHqhVXj1/D1U/GOhYc51MkQGwjdPG7Edfv9Qiy2ZyVGLJynU4zQNaj+h9SiJE6MerUt5Ln6G1bRn4/bYKml0PXRrKW88JtqXfBHiub2b7YxSdUSYs2JatMODxZxaFAe98Ub2/0FUdrLX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579844; c=relaxed/simple;
	bh=8YVUMkA8Oz0L4Qnr2bURZgdxqlw5BfOxePEuWE0GOdI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=We/wqkGrpqLnG+WW7fs/KEHA0W8YX8944rP+61RlPck+PISHChQAVqtiupRWJ4VaPZ0NS5b/Yw3T5GqNZ0mRm5e9BEanMJ4Ij0mURXe1nyzhJqV7u6bCuF7fpmtHmZ/DlTIjzE3gn6eAKH/UGpl3EXx43WpHKPR0ZiTQ4Zca7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khY/4M0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khY/4M0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C8B1F000FF;
	Fri,  9 Oct 2026 21:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579842;
	bh=ktw4isPussffvf3zg7H/FNhg2iyZ60DBUB9rlpHNVAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=khY/4M0vZjihjUgvzdEMx0Vv02E9P1wrUXeAKuvfbgwlYgOYtz/BwoUv1BGFdZCcQ
	 VHLWyJexxFtb5KGJQyXdAvYvCJ+7DEHHYX23OuQZefRBXdVRf0ESZm6qFyIJtB/w7W
	 ZmMBK3t2G5544/UYc+YL8TAd1jnge2iv8judqlAOA4Tk5DSK4hnuGpEYoW76HB+7k9
	 XkNgRAcnZ6P6/K/DucP7Z2qex8CH77qatIgR0Qk6bFN+cIkz4O7FHu/bLeGSOUEif2
	 pOfDe+KIN/ocIsoARu8BrE40sQWv9sQHm4KYMJKxTgIwho31YNBQ+hfHN+Ep4cgHSe
	 shc2vZz8Rs3GA==
Message-ID: <sashiko-outbox-166074@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 07/10] e1000e: use pskb_may_pull() in the
 82571/2/3 TSO workaround
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-7-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-7-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:04:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> e1000_xmit_frame() uses __pskb_pull_tail() to pull up to 4 bytes of
> payload into the head when the head holds only the TSO headers.  It
> already checks the result.  Switch to pskb_may_pull(), which takes the
> length the head should end up with and checks it against the skb, so
> this driver no longer calls __pskb_pull_tail() directly.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D7

