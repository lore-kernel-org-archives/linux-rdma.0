Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C42C29C33F;
	Tue, 28 Jul 2026 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785202107; cv=none; b=BrT0lNSbm7za07uSgI6Hbq8BSI/sI2Cr2F6VW2ba7/8a5t1TZFzOqi8EfyALrT2ZWdRLYsHZbaNxyDSKQ9MontFSpJC23ItE4qf08mk3SJcn69CKyxkhBylnvV8hLAsjlvxqJdCytgHB6YWQKkf0mSKIqEvlsBlAht9l81A5W14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785202107; c=relaxed/simple;
	bh=yl7tdAlkLxb4nHPXWKhhhyCSKW1pONa/Anek/0CGPFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LwriQ7yn+5xuL6w/Jt/Gk9Op5ZTG07HQYN4Su8KUeKtufs9RYG9RomTSMO8rZs0oxwY9Q0C1NlSdZfrigypLLSq1cCxAeCsJGzo5PFlsHSUl487HYBTXKn47eSrWy9nyRqO4dupIWILM984rPe2VWJe2fKUKM2S9gjlPXQFHcf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcJ07vFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcJ07vFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6D01F000E9;
	Tue, 28 Jul 2026 01:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785202106;
	bh=pKS3kFVmD08ac66anXosXH/WX+Z+k2O5yJaZF4brlwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XcJ07vFtP3Yl8ecaxpys/jUObz7urFum51lGux9VrwfOdD7ws6yQ2wlg16Yt1wuzZ
	 C+ClQ13QtI+SdDjvdMO6Etz3SUDD8783U/vXYZPQm7tvjJBDaCPOvRdhyQ21hNVrT2
	 kH8saGQrsQs8QH6pxBQ6VMIp68g6huwWFCCCWFBlLRzkTif4nqMn7zEOAue8VC5N/p
	 CKayPQ6jHPVY8V909pLhFXDe24mqS1OVIoYuGvZg9tSfnBg/56AK86Wbn0u5htGr4j
	 Je7vv5nRBmcpJ1Ns3OOP6Edu/uFMGujjrNyP6Lj4IiBt8zzHYpeoVFDKTj3qkDs8gz
	 2pEnPPOWHlGgQ==
Date: Mon, 27 Jul 2026 18:28:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
 <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260727182825.7b9bdffe@kernel.org>
In-Reply-To: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Jul 2026 17:40:32 +0530 Abhijit Gangurde wrote:
> Patch 1 extends the net/ionic firmware identity structure to expose the
> rcq_sign_bit field from the RDMA LIF identity.

Can you apply this on a linux/master tag and send a PR so that
both networking and RDMA can pull?
-- 
pw-bot: nap
