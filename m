Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C793F256C6C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Mar 2026 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772995619; cv=none; b=amyjZJKCq9szy7YmUvNjyfOaUEuvRD+sz/CS5b5LyVvIoNvMvrtBvjAZ477YBczXRStjvCxhzMbmKThh2cpvzYPkgzRRP23r+7F0Z7rTOlHI9BAumEe9L6lglOhlftSukB18zG62swgCCz9qNVOhVcj7zsdAaJZKg5Lps1HWT1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772995619; c=relaxed/simple;
	bh=UKfaroNAOBjz/L6mYPyMoaiAFLSmDJu5WUvhMH17iSU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QrhMvMkq/XLCLFhxJSPChmcml/QCdL7Odk/sPfReunpRvSNanp+ttag5z7JiPASlROZUdqCgvSedMJAbYL6xPLztIpWqr7Sj2cHt0CxSS5f5+lYdgM8hMa5FGXYP1A2mrta0v7dgGVcrSoIYvWhKOeDhnZKAcTyLHzLUMhNCftU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CepnNnGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CepnNnGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01505C116C6;
	Sun,  8 Mar 2026 18:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772995619;
	bh=UKfaroNAOBjz/L6mYPyMoaiAFLSmDJu5WUvhMH17iSU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=CepnNnGl8ip1mWX3+NUE5AZ8xdfBbeOB7EdjIoahNbZiU0UY4qdt4zQRYmbTJbQ17
	 J7BUFMXUY4X9Ahq1RsZP+1+FXOBNpxXTzwzAHWj+KkUJNN46akkUGcuhitH2k9wjTA
	 TcQ/eSX4ucD2ujnP4/Ll73FQxHDQ5hu2ZNqA060adS3HkLm01Ff1EPfx2LOCApzy8a
	 n7vXf83ZzAo0Fy/q12um8sTidHsKLJHvjetxijgfiBeOxexpsJm6qcqTwdzjTY1d/0
	 8KMCjQvNAQo1TAhW7PSwmd0VJyG6I0+KIawTZdDVw5mV8dhEyZLkrbr3JAhUkf6T4g
	 ENt4+t4IVxeew==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yonatan Nachum <ynachum@amazon.com>
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com, 
 gal.pressman@linux.dev, Daniel Kranzdorf <dkkranzd@amazon.com>
In-Reply-To: <20260308165350.18219-1-ynachum@amazon.com>
References: <20260308165350.18219-1-ynachum@amazon.com>
Subject: Re: [PATCH for-rc] RDMA/efa: Fix use of completion ctx after free
Message-Id: <177299561651.1490664.18278346291895911609.b4-ty@kernel.org>
Date: Sun, 08 Mar 2026 14:46:56 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 08 Mar 2026 16:53:50 +0000, Yonatan Nachum wrote:
> On admin queue completion handling, if the admin command completed with
> error we print data from the completion context. The issue is that we
> already freed the completion context in polling/interrupts handler which
> means we print data from context in an unknown state (it might be
> already used again).
> Change the admin submission flow so alloc/dealloc of the context will be
> symmetric and dealloc will be called after any potential use of the
> context.
> 
> [...]

Applied, thanks!

[1/1] RDMA/efa: Fix use of completion ctx after free
      https://git.kernel.org/rdma/rdma/c/ef3b06742c8a20

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

