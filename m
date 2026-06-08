Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71CE3769EB;
	Mon,  8 Jun 2026 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780953649; cv=none; b=J1yxjog+p3SCdfn9w5gvJ8IQROKQiuCeKxi1At2o0BNcr7kaEgAoEMpe5ynmmvPaxk8oTthAtJJPDN9uuNlcwHGlKqNJm0zuKm9A52+jqBPLCkSki+0E2cT9qi8igk9VZgovxjokmD/PEor7oM+HIxNlH8EdhQiVxaiFqb/wZsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780953649; c=relaxed/simple;
	bh=xdXrA7WuZWOFV3zOKzTZwoFD9F+YW9X/LEhJKuP2uAI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YUVEGQ5miIFeoqkt4tMjpC7ra+xlpGk3yup0MRfjZiTWXjeGxwJNNMnmWHcC6xjQknoDXcv43nfs+GYO5g9Hoq5hlQNOCKJRcqUpp5ABmOhWAeQ1N3f1hmfArn7TyJIuLm2rc0ieaf6auV2cwgVCNrzQDXgrg5tmTnko2WmAA3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRdn8rAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRdn8rAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1603D1F00893;
	Mon,  8 Jun 2026 21:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780953648;
	bh=K8SFcbQD5TdWhbK/VoBNiPVzLEY9nk+UtISgZtbEMp0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JRdn8rADw7sfFQHPDSXGx3rlEOCMh4Qb5EVoW20Ysncbl3l7yAfELft2S3vrPBEjb
	 rlo2dokCX2C/lqUyYlzl4kFCSTEIgzNLThSMiwPYMfhEI0vXt4rtwnnUsOg2b7KwvV
	 zy7TnsCeFd//uNZdmStnk3n/ef3tLdv8l/ubOL9idmWO034BNXoP7I48rB7q6+2AIT
	 gYijpoYGfllhh5YjJc7SzU3ktWQqwbHvyjAvmQnltCPYXQajVXy7vnzUme4CeJpgJB
	 Lw7uZdiSNlRnDWvDy+53Sk1XhRj1GJ903HwC1SeDYsAbJB/w6D2zdgHn+Wba1DdkVD
	 8lwoBN8rXP/pQ==
Date: Mon, 8 Jun 2026 14:20:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
 <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [for-next v3 0/5] ionic: RDMA completion timestamping support
Message-ID: <20260608142047.6deff079@kernel.org>
In-Reply-To: <20260606050003.3648306-1-abhijit.gangurde@amd.com>
References: <20260606050003.3648306-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 6 Jun 2026 10:29:58 +0530 Abhijit Gangurde wrote:
> This series adds RDMA completion timestamp support for ionic.
> 
> It enables PHC registration for RDMA timestamp capability, exposes a PHC
> state page for safe user-space reads, maps that PHC state through RDMA
> ucontext mmap, and extends the RDMA CQE format to carry completion
> timestamps.
> 
> With this, user space can read completion timestamps and convert them to
> wall time with low overhead.

please CC David Woodhouse <dwmw2@infradead.org> on future versions.
Since David is working on uAPI for clocks he may have some thoughts.
