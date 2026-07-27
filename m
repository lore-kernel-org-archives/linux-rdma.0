Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ABF3C3F73;
	Mon, 27 Jul 2026 22:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785192595; cv=none; b=OUWUzX15hfvv26qW5h+OfVKwoyGSfzSoGtHOqiATTiiaRdKXSnwkANQcgYnX+l8S1mqZDGAhlOlsbKHvFdYEpOpYsP4J2wtOvrxaSThnHQK3unWj/DxznoyGZ9AY+crES9Jg4Q5ARH/+AMBR8SRnX6byb6WeQnA64MaJGiMg6i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785192595; c=relaxed/simple;
	bh=9/LD9KmUIsgQa4UaaYOguZKLjz1HT1ML/iINejg/C5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDO45wgtwcz/fafPfZul+7gntgmwwfIL+LlwVa+lz04UCzUYcmurGagnFVOZR4A6y7BYFG5rFkqKHbJcu3O7JDZfIfhwrGeDZRH89BjZerIINd9F5znZdw8UpEEpM24+LDGX43Yhk//02/ujZv1qFf6pSigHaXaO5RVeNyB55iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfpytil7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfpytil7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675731F000E9;
	Mon, 27 Jul 2026 22:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785192593;
	bh=AAOEmKEUmsDH772XBAIKvJ1k3WT6vXFxK7dKwjhuJ/I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kfpytil7h6PMy2ST91o/pezejX/+miEjKeBV6EUR6uQJ1eGaqbcwh12Z5RWwz0phQ
	 QxAUhEAc1DPTouneDGW9+y5fqu8768NS+WyHOfp3UAAwFyEZQ/8bEV3pxGs9UollWs
	 vOtD0emm7UTgi2/uUqlDkEIwwcvyuHxyFoGOmFIkvyV/5zvfDLwbDBkDVXqIH9uI0l
	 YpeVClLTBGUoYaR7vBANUszOlK6tCJgM0s2ZFs9SWqT0ggWVNZ0LFcPVUUkkJuw2Cb
	 Yymy9gwB8VlMD1Zokj16VLIndOcPXbzjtMvK6Zxi7Fgz0w3FO+C+I8LVD+fJ+hd8b/
	 lgEaQLx80LmFw==
Date: Mon, 27 Jul 2026 15:49:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com, leon@kernel.org
Subject: Re: [PATCH net-next 0/3] net/rds: Bug fix ports
Message-ID: <20260727154952.0bc24e1a@kernel.org>
In-Reply-To: <e770554d9ca05784abb3c9d1ccd378295f46fa08.camel@kernel.org>
References: <20260725082939.2546624-1-achender@kernel.org>
	<e770554d9ca05784abb3c9d1ccd378295f46fa08.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Jul 2026 09:25:21 -0700 Allison Henderson wrote:
> Apologies, this should have been a v2.  Let me know if folks want the
> resend for the book keeping or would rather forgo the spam.

All good, Sashiko has a comment -- 
https://sashiko.dev/#/patchset/20260725082939.2546624-3-achender@kernel.org

I'm guessing that nothing can get queued at the point where we call
flush? Since it's late in the exit path?
