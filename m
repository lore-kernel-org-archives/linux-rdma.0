Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DA854CF48;
	Tue, 22 Sep 2026 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091858; cv=none; b=gZPkHSnXz28vhF6f6w9i8Xbe2TGX/coz58evPNLUsrvnA+vpgeXYx9ycpwspCZjWBQcUkQ1rXBNMoaAgPXuV6tDZ0LnfImY7OWjYFDK9WBF+pH+NgdbtNbF7NbUZN7U0tqqKKTe5cDURkWbCvtAvnumFNSSeyLiDHd6yOeKxpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091858; c=relaxed/simple;
	bh=H2LQm10GMuQayO/rov7YPEEWZioZkR4PzepRTqfC9VI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=uc/W8YWWrntShBk4/4VyZFGm5oddWGSl+CUNQX+fZJeCsbckD+vN1iFc/qR6d3rEaAmLJFncsZ1+qxsjVESHcp+DTC00V4+ZtNmhLaHqppdMIy30zyBtJ8tydq3DkQrqlZlmSEfpIUyqaf27pfSdQSVIqTMMAoQg4gL9NoYF2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=GSm4x/DT; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="GSm4x/DT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=CWnSk7EHPwZAKsC2qnExgWJIw09V8t9KapKe+fGyacY=; b=GSm4x/DTZBhqYrTlypLXxe4dWy
	9y0sKMPb064RvrGUTmasLfAtfG82W1NGKWo/+xT03P6Oh8PevDkvjUF+Chntkj38pPm6H5lSpW00n
	14O4Dpzm0kR1kCBBt6AmxVZk4MZUVOwj5r2wnDpgZW8eoYS9DAM7xK79NREGkU6auzxdUBhjGuiJU
	ijdiVxaHh9h2MKQWZntFWWZPJw+ThxEHQC72rUwJ+Nmhz3sNlRxYQuIQDNpuRwFiwZMJQ5hWueLbT
	h4CWHqhJq+VkZA3OU+lTvTGaBB/oZn2MtwfwF77vBEpGxIfjjB8HIJOzz6yj/Om+EkgOwRsWHoW3c
	3sCFOc9A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1x92fD-0000000FjgX-1I9v;
	Tue, 22 Sep 2026 09:44:12 -0600
Message-ID: <be735e17-0948-4940-a6c9-862466f986b3@deltatee.com>
Date: Tue, 22 Sep 2026 09:43:56 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
 <20260920-fix-p2p-acs-v4-0-v7-15-ca0828ab697c@nvidia.com>
 <85bb90f0-5a02-4e35-9ed6-ad7e67c1c0d8@deltatee.com>
 <20260922092754.GC563127@unreal>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260922092754.GC563127@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, bhelgaas@google.com, kch@nvidia.com, gregkh@linuxfoundation.org, axboe@kernel.dk, alex@shazbot.org, ankita@nvidia.com, jgg@ziepe.ca, corbet@lwn.net, skhan@linuxfoundation.org, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, rdunlap@infradead.org, sumit.semwal@linaro.org, christian.koenig@amd.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, iommu@lists.linux.dev, tdave@nvidia.com, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v7 15/19] PCI/P2PDMA: Document TLP-class routing
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-09-22 03:27, Leon Romanovsky wrote:
> On Mon, Sep 21, 2026 at 04:16:56PM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 2026-09-20 05:41, Leon Romanovsky wrote:
>>> +A path is bus addressable only where both directions route directly, so with
>>> +nothing enabled every class is.
>>
>> I don't understand the sentence.
> 
> I tried to say that we need both Requests and Completions route
> directly.
> 
> Claude suggested something like that:
> ---------------------------------------------------------------------------
> Combining the two tables gives the mapping type: a class is bus addressable
> when its Request and its Completions both route directly, a blocked Request
> is not supported because Translation Blocking rejects the Address Type
> wherever the Request is addressed, and anything else goes through the host
> bridge. With no ACS control set anywhere, every class routes directly.
> ---------------------------------------------------------------------------

That's much more understandable. Thanks.

Logan
