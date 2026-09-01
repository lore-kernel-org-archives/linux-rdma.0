Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590A3955EF;
	Tue,  1 Sep 2026 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257688; cv=none; b=XkfTFPdgRSN0tBWtIVAXGMiDUrPnb98+raKG29Ot5SZNgvSw/AZ0zyq7Rbw6N0XuVqV2AA3ahbGgU1j6FSzrQT7og5a5wE1HfHddvlq0pKYA0kySmoMgR1B53jeiYJ3THf37CyKvw7JiEsEwD2pcYZPd1Cc9UD5z9G+3GVFJo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257688; c=relaxed/simple;
	bh=8LJ5IHK7srxyG7/OvcE1afSvRXd77Y4RyMUhIjVtw6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtIqcaEUGGhh26iHWNEJ0Rm4kiuXK2a+vOkNccIFeX6D/83XH5U5HIqRbcYdWohc5VUtwRisyuf8jBPNJ1mFcMepeet00cfPcRKyVVtZRGl0S8sIhvEQRdIGoHDkBuW4YEhpRGnVTfT9GPlJZ2o1hCeLbESTXQPb/qBaBgzKPJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTrlNlaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTrlNlaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA3D1F000E9;
	Tue,  1 Sep 2026 10:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788257686;
	bh=d8m+G8oHFY7VK4rnInM97O9c1SPNfC9y8hgvKfvLGQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LTrlNlaZ3qXqliRvO55tAPy4p4pOBLZbGp6enQbk1pKHV2Ua+b17hpcsPOZCHf6PT
	 1xDeTv+ZCiSAaJmP4cJlUJ9BWUI1OVTbxQbmffAm9+KgmjnAXDtyIoLLAlzBbCe/Un
	 zh5pDSC0LP9S421EySQc8olQmZyJ3Ep1Pxf8Ya9T/8c4lCN5FOopZz66dzC4TgtUat
	 uFycrA294rR1ItQDUZCu1JwuHqOrm4SyAFSzSAVSmne7S0OOnxcZ2fp71p1EAEw6vG
	 qkTERrZEEW+U/D3yEg4ZhVnrBO0DrYvN+VT3J3nQjRbWAYNv/P87vOnoeQCgjNAJnS
	 bOljXKQEtIkOQ==
Date: Tue, 1 Sep 2026 13:14:41 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: brett.creeley@amd.com, Andrew Lunn <andrew+netdev@lunn.ch>,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	allen.hubbe@amd.com, nikhil.agarwal@amd.com,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260901101441.GH24140@unreal>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
 <20260814102413.5a26bf8b@kernel.org>
 <c565fa0c-08e7-60b9-90e9-07daa4777a48@amd.com>
 <20260820130817.43317368@kernel.org>
 <a9a9d118-fe06-654c-68a2-75d6c1ce875a@amd.com>
 <4b766824-5d60-4298-89c8-8d48c6f52827@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b766824-5d60-4298-89c8-8d48c6f52827@app.fastmail.com>

On Fri, Aug 28, 2026 at 12:22:26PM +0300, Leon Romanovsky wrote:
> 
> 
> On Fri, Aug 28, 2026, at 12:02, Abhijit Gangurde wrote:
> > On 8/21/26 01:38, Jakub Kicinski wrote:
> >> On Mon, 17 Aug 2026 12:35:52 +0530 Abhijit Gangurde wrote:
> >>> On 8/14/26 22:54, Jakub Kicinski wrote:
> >>>> On Thu, 13 Aug 2026 16:19:52 +0530 Abhijit Gangurde wrote:
> >>>>> Patch 1 extends the net/ionic firmware identity structure to expose the
> >>>>> rcq_sign_bit field from the RDMA LIF identity.
> >>>> I asked for a PR, based on a tag from Linus's tree with that patch.
> >>>> Did you send that?
> >>>>
> >>>> I only see a PR for rdma-core here
> >>> Hi Jakub,
> >>>
> >>> I have the PR ready on Linus's v7.2 tag.
> >>>
> >>> The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533bc5019f:
> >>>
> >>>     Linux 7.2 (2026-08-16 14:32:26 -0700)
> >>>
> >>> are available in the Git repository at:
> >>>
> >>>     https://github.com/abhijitG-xlnx/linux.git ionic_rcq_shared
> >>>
> >>> for you to fetch changes up to bb23acfd05f0399f33dae000df2ef4a88787b7d0:
> >>>
> >>>     net: ionic: Fetch RCQ sign bit from firmware (2026-08-17 10:58:31 +0530)
> >> Thanks! Pulled
> >>
> >>
> > Hi Jason/Leon,
> >
> > Can RDMA patches also be merged?
> 
> We are in merge window now and don't take any next material during that period.

I applied RDMA patch as well.

Thanks

> 
> Thanks 
> 
> >
> > Abhijit
> 
