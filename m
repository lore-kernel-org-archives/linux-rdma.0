Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45233998;
	Tue, 15 Sep 2026 11:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472684; cv=none; b=YH1LcIS4Ka2FhH54NU29JvoTwD2jtYovLzOdXz3m3paHLfZMhRcOb9OObA8J4KK5YtVX2I6cNmpElKtf0oULjBHowBbRHOgdxT1rO8YouBDoAYgOPrN9lOHcdjjULZxQlK0CZetjM2rXOTLnTQc/9vIsJGhcYdphkA47A4COddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472684; c=relaxed/simple;
	bh=wghdYHLgF49iOSv1BcQouzkPMO8R7Cf+IFB5xxH7+cY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Vw7lJW9QljKtME3ocmgX9PvrY+FBgLGq74GaO/XF1u/hGh/pAroCYie/qDQh0ZtAXsISLP7RpmlHJJRdI74YhLqzOGhVQcY4KeNwNcMAe9Vd4DAHCN94YhOkPAIS3yig941Iyw+bCYwwD7qVa2ELAeDRkpi38butsePTHuJJy5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+c45Hdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+c45Hdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E89D1F00893;
	Tue, 15 Sep 2026 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472683;
	bh=QOnRdB5Pu7XQxgmbCLsyauGkNUcsbisBP+7S3kwFiCk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f+c45HdzuX+C22h+D7UBHIxx/RZVV4zw8f67mZZ6lXuBje5TK7N31L6itrjzfoem5
	 VsLSKrZT1Sj2e/NNHFEOXQdfDNP0VQkM7F4Wc0xMB0lj4H3UDK6midA7EZ9f78CjAE
	 1Xb2WdLfDe0IYMqkXSOvptdfZ+ni330GhMBQEVg2jvEDmryuTCP0VMKg7h3cmG0qgs
	 CAE/PmPnHmNsEkOkaF6MqpmFKrxEN91eK3njBcTHz75tm6BSRfzZt890gSQedRg673
	 blJYcA21NUApD1gz8QioIbnn9Bef2bVIzCPdIfO6QDkWQmY771yThgALmiPbxHFQvl
	 +GZh9eQQXHFoQ==
From: Leon Romanovsky <leon@kernel.org>
To: bvanassche@acm.org, Serhat Kumral <serhatkumral1@gmail.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260914130536.19769-1-serhatkumral1@gmail.com>
References: <20260914130536.19769-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/srpt: Fix srp_sq_size documentation
Message-Id: <178947268036.1248043.16131946397026766852.b4-ty@kernel.org>
Date: Tue, 15 Sep 2026 07:44:40 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 14 Sep 2026 16:05:36 +0300, Serhat Kumral wrote:
> Replace "Shared receive queue (SRQ)" with "Send queue".

Applied, thanks!

[1/1] RDMA/srpt: Fix srp_sq_size documentation
      https://git.kernel.org/rdma/rdma/c/6334cdf33fc3c4

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

