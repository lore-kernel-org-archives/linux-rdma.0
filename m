Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563684052A3;
	Thu, 30 Jul 2026 10:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408687; cv=none; b=lIBXOdWi7nZWy58/JdiQxphyRTm0JJpklbYKBiO7grgHm2gjOQLG2Of9FWFcOhZKMBqrzCqqpt11GzMViLgdBxA7cRgf8b9ZdlQF2ni299oWSflcnJ09qETZ5uLDUW+GslkS3o4cMEZtFAxVACp/cptVANPD4LnSutncpZ7oo6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408687; c=relaxed/simple;
	bh=sjFu9a7KwrOdxR7PsoWjyAxDs3b7rTgPphoDEJm0j1U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ReHHort5U1mgZcjzBHywr4jewSdLqAAtONXX8UM9gRYIzPCxcBf8kQzVyM+6gXkPX8WoGVT2uxGP+CW314uJaULeG7aB3Bgktu5CdB0BUfDusZ23HQs1JO2ujG/mD3dTJNvWnDtrMFxhnR1KWFuxncnoabYXZG+uifOLGFfqD2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ahzeq/N+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ahzeq/N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFB51F000E9;
	Thu, 30 Jul 2026 10:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408686;
	bh=XS0roQG9e23lI33icLzOb7g3SyAPvOzFG6Gl+it/vUU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ahzeq/N+FYD3m2S0nQc9D2XBbh/gcc+PuQ77VDiw2iZmnPktE5YwKCAXO2saH+Acf
	 Ba3vPnH0QRVRzkfXfmgGd0wHM0nvFr03stHAt7PVq96IDxUF4juVJMJ16XaREQr5Yd
	 FZuv0D4Zr9wx55DhNFHdxA7+K0N48vYLH9jvVEQ6FnH4agOzyrEz5yXSt/CLyWzu/i
	 L9RxJhpFSbh4oUvcCCgx8kEKF8jVA7u7ForkBCJ+jVnJXtjAbpCMVADGTGys+7PoR5
	 UiHnF3R2SbsaRminBmq7PL6Z+cAUwkxbLQnr/Omt763q7A/W1CwWmkjQuSjfdSgLeM
	 iOFflLBc4MzKA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260728183403.1136827-1-rdunlap@infradead.org>
References: <20260728183403.1136827-1-rdunlap@infradead.org>
Subject: Re: [PATCH] IB/mad: cleanup all kernel-doc comments
Message-Id: <178540868330.2279429.11880483505961800526.b4-ty@kernel.org>
Date: Thu, 30 Jul 2026 06:51:23 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 28 Jul 2026 11:34:03 -0700, Randy Dunlap wrote:
> Add a leading "struct" keyword to struct descriptions:
> Warning: ../include/uapi/rdma/ib_user_mad.h:72 cannot understand function prototype: 'struct ib_user_mad_hdr_old'
> Warning: ../include/uapi/rdma/ib_user_mad.h:116 cannot understand function prototype: 'struct ib_user_mad_hdr'
> Warning: ../include/uapi/rdma/ib_user_mad.h:143 cannot understand function prototype: 'struct ib_user_mad'
> Warning: ../include/uapi/rdma/ib_user_mad.h:184 cannot understand function prototype: 'struct ib_user_mad_reg_req'
> Warning: ../include/uapi/rdma/ib_user_mad.h:216 cannot understand function prototype: 'enum'
> 
> [...]

Applied, thanks!

[1/1] IB/mad: cleanup all kernel-doc comments
      https://git.kernel.org/rdma/rdma/c/43598807f71ac1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

