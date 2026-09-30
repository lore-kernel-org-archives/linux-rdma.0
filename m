Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0733B9D8D;
	Wed, 30 Sep 2026 12:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769644; cv=none; b=KQdQOjymqat1/Uv3GNKFku5M1WUOnufv+yPR6MX7smQ9QRnkekyt/QvQ0a0Kcj73Tpm3yIsMAIzEARZCSR/Ubd1RBizlalCitFfBIzqSTCRBMZktyh24qH0tsVVDiX9fL2BZTwiap6/JpYwcIiBqf6Ti/GTBryLeLBzBPlZfnTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769644; c=relaxed/simple;
	bh=wszQkN1GJqDwPiLZzvHAvrJVpaCUtN+auewvBQyY7Ic=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m4Dtu3e30DvcurjyEaxmIEh7ko1+pNXHONyM3vuxOpQqGFRQHTdTOCTzrq14p5HBfj20GMrzMFqJcO42+Z1jcpgcA0+j+LxyLJ7SjSWYIhbUN4sLyP8Xvsnrb7FaGI7tH9g5+Hw4p17xs1mDbWDCpUfMhEuSdWzP1AQ1v8Fdmgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6+SBTTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6+SBTTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE6A1F000FF;
	Wed, 30 Sep 2026 12:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769643;
	bh=rCXPgRht0qSLZf0OgWnuc60RKYdtwcJbAZyGAof2KhM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=c6+SBTTIXMk9pXdKjNAO6FBvlPYZV98G7Y0mBQYyNovlBDrz6nPAYuhCV08Oi02nk
	 Y3Ndixhyvw866RSJz+OpkPx+5r7FvGEYymNIk4qA5OHZoqYCGZswN3ir62+nWgqeZo
	 2bVP5hOx4CCIe2xjuC2wYa7PF5Nwu3MIwQEKbOcaERFlNfaAMGn8IVfFYK/jdXcUuq
	 8cqsBVSvDWLbsprilRiMbGKi4KVRZhJkKuvpwRHdinWw4f4bnaFySVsJ5FbiwRPEKr
	 3NDFKuzvh5hqbef7Lkp1OI3diLiTXi4o2yW13rWbJD4XIEo0NRafODG7BCoUav8MK7
	 CqOiOLVsmaSfA==
From: Leon Romanovsky <leon@kernel.org>
To: dennis.dalessandro@cornelisnetworks.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Hongyan Xu <getshell@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 jianhao.xu@seu.edu.cn, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260928134151.1213-1-getshell@seu.edu.cn>
References: <20260928134151.1213-1-getshell@seu.edu.cn>
Subject: Re: [PATCH] RDMA/hfi1: shut down the trap timer before
 unregistering
Message-Id: <179076964043.226697.10963286150621176370.b4-ty@kernel.org>
Date: Wed, 30 Sep 2026 08:00:40 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 28 Sep 2026 21:41:51 +0800, Hongyan Xu wrote:
> MAD processing arms a trap timer embedded in each hfi1_ibport. Device
> unregistration does not stop the timer, so its callback can run after
> the port and its containing hfi1_devdata have been released.
> 
> Shut down every port timer before unregistering the IB device. The
> shutdown form also prevents a concurrent path from rearming the timer.
> 
> [...]

Applied, thanks!

[1/1] RDMA/hfi1: shut down the trap timer before unregistering
      https://git.kernel.org/rdma/rdma/c/23baaac7287bd6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

