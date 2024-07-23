Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606D613BAD5;
	Tue, 23 Jul 2024 23:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776938; cv=none; b=OSVoG2S9P+/fuToDbwcjyRkVJoBUb0t5itx/JriPtsj7RPs0UCRkIXLuR2+yCfG90NcgoQ8UwiOxGiusfzJpfF79wrYaQjly2ix9CPePRyjM8XHFk61oLHitB12nCdxRyFRpeBqXK8j95oyUM8mpBB7GiVhi5WGpa8pNBRp09ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776938; c=relaxed/simple;
	bh=7+LXOFK55u86NuJ5VxKM0mKtRBrL9q7DICTeXMyyzuQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=t50exFz54hNTTCvr2Ztnfo9uZvThAqbbudPxT4Pg73pH0ioi/CRLXt/coTNY1HjLojp1wp9qC0XuNVHaL7yIA4c5d0fF45E4Otxa6KfXEikcJ9L4XPIGzisn+YxQqyRNLJr8SiedTlHzy038l0S8a1K6VqInTMkgciP3BLyPFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLJO7kTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLJO7kTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622DAC4AF09;
	Tue, 23 Jul 2024 23:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721776937;
	bh=7+LXOFK55u86NuJ5VxKM0mKtRBrL9q7DICTeXMyyzuQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=GLJO7kTWTGd5icCOkvusnuVpoCDNLHGgTJdZkfz9mQnXYu3ReHQKarYHc3i1OtUVi
	 lTa/G79+JhnoDS70LwtXIC3mcF8xRaGRFMmcnqDpIaJBXhAddlLybINhEJ3rwMrViF
	 vvglIC2NnLAft8/0067CGCvkwluZSyak+rDrfmqpwf/BFQ6e+d0nsmDoucvRY7COOn
	 LJ+ivhB08jOv+McL4pjoL/LM19XCSrRGejUOqZp+ziLWp4yJQ0l0bJMJIIK+Gg47To
	 6MMKDFZ61G/ayPkyumN8o45HG8tWRwQWnjvu5H7kTKbKOl4LN3+nsgZkF373zV8AC1
	 Yrp3FDmJBS6dg==
Date: Wed, 24 Jul 2024 01:22:14 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Dan Williams <dan.j.williams@intel.com>, ksummit@lists.linux.dev, 
    linux-cxl@vger.kernel.org, linux-rdma@vger.kernel.org, 
    netdev@vger.kernel.org, jgg@nvidia.com
Subject: Re: [MAINTAINERS SUMMIT] Device Passthrough Considered Harmful?
In-Reply-To: <1e82a5c97e915144e01dd65575929c15bc0db397.camel@HansenPartnership.com>
Message-ID: <nycvar.YFH.7.76.2407240119140.11380@cbobk.fhfr.pm>
References: <668c67a324609_ed99294c0@dwillia2-xfh.jf.intel.com.notmuch> <nycvar.YFH.7.76.2407231320210.11380@cbobk.fhfr.pm> <1e82a5c97e915144e01dd65575929c15bc0db397.camel@HansenPartnership.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 23 Jul 2024, James Bottomley wrote:

> That's not entirely true.  FIDO tokens (the ones Konstantin is
> recommending for kernel.org access) are an entire class of devices that
> use hidraw and don't have a kernel driver.  There's an array of
> manufacturers producing them, but the CTAP specification and its
> conformance is what keeps a single user mode driver (which is now
> present as a separate implementation in all web browsers and the
> userspace libfido2) for all of them.  

Agreed, but that pretty much underlines my point though.

The ecosystem didn't get shattered as a result of me having created 
hidraw.

libfido2 is on pretty much everyone's machine now (at least for those who 
need it), and people are using that all the time to authenticate to 
kernel.org/Google/Okta/whatnot. No workflow got broken in the process.

-- 
Jiri Kosina
SUSE Labs

