Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187389;
	b=pKxGIdCLJIlex/dSMZsBDyPx57ScZo/in3XZTA8i02LO2u8pLxdpVoIm5P51LC1dOsry
	 BCy8DeV+ylOzyQkaU+jfkrkppHLY8334I5qcSzDsuLvwElHS/TxkJD/m8sgt8jhpueAwp
	 jIEUSBo2mtie6jXNIV9qer3SiZoU4VNV4aArn5uP1gKFWgZ4g/CMVk9fWCUJq+THokTtL
	 ClfBYna/xUd1XalvPVMeNBMS2wyIcWJjnSJU/wzUPJIIo3W4LovDhK/OLUNbcxFa3LaVy
	 42ZTSOj/zImalLDiAkvG8n61zrAVShc/YHYKePTpveV3zucDdGkHeT1bwXKQ9cTU5RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187389;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=v2Yor7+qFezh8HPF9vAVfh7/7aqNEEqI/kVoUGNY7E0=;
	b=UhiSjAOuEZ0g9bL+YN/9R9iD3jhILGNwq1PiUokNVYggMHfM9jSBRWm1V3BNToaH1APb
	 QiE/wl/wtdsu5ps3/FdoXAAUNmf/KWs9fia3HwV69F4EqBQZqKSFJAuN7eeFArjGggGAM
	 nYAiLmfaQeJQximpV3RzBt3zu8Y3Ld3e/SK6BEPgBAKmeR4SnjwwUMZcEygwHhI78pIMw
	 aGIDrOykfHyfIiT+mamekbf4aCtcsNDty+/KnuRRtmT207M877VK//bw0RC98qqciMjyt
	 vJRJxBj5eojy5Lo+nkrJoeEbK5DxE2sfY6YabgDMBlOzsmjP7xH59oT40E1yS0Jxcdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPDmP7q+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6C8606A33B;
	Mon,  9 Nov 2026 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPDmP7q+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189F31F008A2;
	Mon,  9 Nov 2026 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187389;
	bh=v2Yor7+qFezh8HPF9vAVfh7/7aqNEEqI/kVoUGNY7E0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KPDmP7q+cqrQ5L2vC+h+pU3wreyiS/8hHVEVyTfGf9pkaAaKcTH1vpCQO4TzkhfYF
	 bQgFuO2nCiTjanS0objgxeQ1Dum2tozdEnWxhO7FX1QCd8GPRrV3OPF4f62gPaKHIo
	 NNRxMVB/5kC14RHA2cwoG6hHRtohDZ7lIxQGLzhJ2Hxabvpq+JLZdJHKGBYZkqKjN8
	 U+o98dRaZYIZu04FDcKqqm/RGihUPyqBAWkTjY/xpesD9OWokWlgfe7ZwApVPtLV+G
	 6pusbAtMmaWa6TdZXIhi4qMrY0SfeHcVc7zB7tquiS9cQsRAU9mqGqCX35mgB2Sf7X
	 OmOeJRaKGrIoA==
Subject: Re: [PATCH net-next v3 9/9] selftests: drv-net: devmem: TX from a
 hugepage-backed dmabuf
From: netdev-bot+sashiko@kernel.org
To: sdf.kernel@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
Date: Mon, 09 Nov 2026 01:23:06 +0000
Message-ID: <179418738661.994134.1386581650492985196@kernel.org>
In-Reply-To: <20261105222058.944293-10-sdf@fomichev.me>
References: <20261105222058.944293-10-sdf@fomichev.me>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit author is "Stanislav Fomichev <sdf.kernel@gmail.com>"
  but the only Signed-off-by is "Stanislav Fomichev <sdf@fomichev.me>".

--

selftests: drv-net: devmem: TX from a hugepage-backed dmabuf

This commit adds a -H option to ncdevmem that backs the udmabuf with 2MB
hugepages. It also adds a TX test that sends a 3MB buffer from that
dmabuf, so frags end at the 2MB net_iov boundary and continue past it.
The payload repeats every 7 bytes so that offset errors are caught.

> Author: Stanislav Fomichev <sdf.kernel@gmail.com>
> ...
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

[Severity: Low]
This isn't a bug, but the author address doesn't match the Signed-off-by
address. The author is sdf.kernel@gmail.com, and the only sign-off is from
sdf@fomichev.me.

checkpatch.pl reports this as FROM_SIGN_OFF_MISMATCH ("From:/Signed-off-by:
email address mismatch"), and the netdev automated checks will flag it too.

Could a Signed-off-by be added for the author address? Alternatively, an
in-body "From: Stanislav Fomichev <sdf@fomichev.me>" line would make the
author match the sign-off.

Every commit in the series has the same mismatch, from "bnxt_en: let the
stack segment GSO skbs with too many frags" through this one. It probably
comes from how the series was sent, so the fix would need to go into every
patch.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
