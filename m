Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26A843CEFE;
	Thu,  6 Aug 2026 10:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786013409; cv=none; b=JUKmvpkvDvzXySFhuf2vVwyQw5b3igPQhqeiXMsDNvcflHiJqMd8ADizlyrfGtsiTkM6iQmdR+mM86bKnFbfD9yYRHgwo73CridLIlVqxePOUSiXKmUXG8CcjiIc22Qjxf8vT9vfDrQOv8dC1xJBp3AlMGs0MJo9bReW9vjiDTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786013409; c=relaxed/simple;
	bh=5UQswLgK6HqJ1goKsFZ939tELQW0R/cuQOcxzRbiFkI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EBoX9iBSVe6PpflfXUDWwXbc5m7u7jJhDnrkX4Cy8D7fahro4fsobiqqdAWO/qOAHhlg0PwHRXwHPeEYQ+tBf8WdxjJSiGwRlo+zag3dNKFFT4MSzTHqeqno7nlehN1hJcsqfe/qejtBXSxfUwZpGb/mudzlL8AXbn25Ji9v5YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mem+JSSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mem+JSSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46161F00A3A;
	Thu,  6 Aug 2026 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786013408;
	bh=UXnHgOx55fdAPZ9Mlna3rEbBhu2ldxnu49cwRRx0PUk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mem+JSSRZE/H0lhA0xlkuGMSfQCONZo1ppA6ChzpoYYXz+xT1nGINLUbtVgzrcHVU
	 01nASHk+XL4SIIUy1VwTChWgeRvqH32oiiR/ktN0DefbIIWZz4wu5UNt/wb2zaXoHf
	 +3D/ElDNfhRpRuEgsxGbl02oY+vNyW+oTKSorPqsQ+6qIuQ5+ICM9nn17WwAp4/BfR
	 0cB9gy0INz5qI2b8GL5qbbB3YeGg3BXrylIAS/z58gs7/d3/LEnX5BFcR/Zg+TL7DC
	 mmFLfK159lHneDu3s2iUSpEvNqIBtAn8RQv3Uz4epfZ6hcrfp3SgAFQF97iUqgtJui
	 F7VPnEb7Np6KA==
From: Leon Romanovsky <leon@kernel.org>
To: bernard.metzler@linux.dev, jgg@ziepe.ca, 
 Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260801213632.1086548-1-shuangpeng.kernel@gmail.com>
References: <20260801213632.1086548-1-shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH] RDMA/siw: Fix use-after-free in siw_accept()
Message-Id: <178601340535.515060.9252272236389995348.b4-ty@kernel.org>
Date: Thu, 06 Aug 2026 06:50:05 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 01 Aug 2026 17:36:32 -0400, Shuangpeng Bai wrote:
> siw_accept() looks up the QP supplied by userspace. If that QP is
> already in RTS, the function jumps to error cleanup before associating
> the incoming CEP with it.
> 
> The cleanup tests whether qp->cep is non-NULL and assumes the current
> call installed the association. However, qp->cep can point to the CEP
> of an existing connection. The cleanup then drops a reference from the
> incoming cep, not qp->cep. Once the incoming endpoint loses its
> remaining references, this can free it before the subsequent cep->qp
> store, causing a use-after-free. It also clears the existing QP
> association.
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Fix use-after-free in siw_accept()
      https://git.kernel.org/rdma/rdma/c/a9394971825933

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

