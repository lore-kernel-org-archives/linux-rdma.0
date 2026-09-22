Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C2935B634
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039288; cv=none; b=ParnzhVdof3Hb+oA1lbaAR4kqhpgSUWAbw0URPgMzGOqEk8//fbkd91m0osVxCrZUumfLoF1YfO98chDY4nuNVoEcXLHLi3rM1LIxbi6/O3nb9xBwzQ3R/M19SxExlmtnXCFPsPmgF0y2TQG9k+TSvYYuJyxFEAj2QjDtcv8xPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039288; c=relaxed/simple;
	bh=qJfMEGbhOG6TDJy7qzRTWUcdydGTp4NCTc/aOiVNplQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u2QldqYorr11XeebE6L0kjNBBd8eWALwSs60oN3/y+yddT+Yj+4/wJFSG1Ng/RcTPfh5oJa7rofu/m8H4Qvai5t8LgZE8SiB0yMf7ZttrP9Id2JYd/8K4uCCtZRUUY45ApWi5gWuHctXEexXJNRbh5X9bObOqzjPI1quK4JAJ0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ka1R6bmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ka1R6bmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117981F000FF;
	Tue, 22 Sep 2026 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790039287;
	bh=qJfMEGbhOG6TDJy7qzRTWUcdydGTp4NCTc/aOiVNplQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ka1R6bmIvRMdiIlI9UsY+YcocLS58ISaTqSu/N8858QiHthtVTeC4sJPf9qvoh1dK
	 j7hQUF8XmAStD1FiFtSSgl7XJeS9cTXhKDPNwGnE8FEfZ7bJ4xdv++Oqpe2W3czcbp
	 4cEb0HGS7x4MmJt8RUVAl1WbszaEa+K8RQGL4ZlPCEXCkk/KMfn21hLeN3MvsyWiGx
	 mNLV3gkvEjgaQ3VgX34FUMd0sIjOrL9V7Aki3JEi79wT26rBIMos64gdUM9Pq++2tx
	 Rjx42PBDb5dbNK6kCHpT2Fsr8LXCk9/PKRhJ9EisZ6bwqOBq3iviV03p1/ywBmtnHM
	 +ob8nNXDTR6HQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 2/8] RDMA/bnxt_re: Detect wrong sge_len passed
 for inline
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-3-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-3-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:08:06 +0000
Message-Id: <20260922010807.117981F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Avoid handling wrong sge_len by adding extra check
> to see if the passed length is more than the inline
> size supported.
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D2

