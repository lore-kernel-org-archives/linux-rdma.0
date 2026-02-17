Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FF636B06B;
	Tue, 17 Feb 2026 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771335275; cv=none; b=XomvRduNJaQV/gHtlg8BnzN6cDEfXU94qARDIV+QsAki4v7+fdQ/EgiPTbiI14+weQsRNRx066FsTXGxsa+qiJ2SY59hvlV/dSv2jwywoWuioCDy7FFH4GseqqMZKdsWG/tvtrDEGUmABuKwz3DJQa4zD3pnIOPFn/IXiNCaf1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771335275; c=relaxed/simple;
	bh=5Ve2lFhJ0cDQLZhhoB8VGy9HpsXLE/NXmcWc43kIado=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQHiBT5ehS98fCljY6XGIQ/JJLiurL2j4nbOhyZk0tsj2jt/xeBAHBPjCHhq7vdMPqu5/DHQcyC1KIcAuUTs4E5+lHt4wRckg+qjLrmjiYeAo/CZ2VIz+71Am9gUyPTHu1wQlFV9+gNioITP0Cpsy0db9A3PtbwMSTA7uE/qM9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9hIeX24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9hIeX24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DEAC19423;
	Tue, 17 Feb 2026 13:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771335274;
	bh=5Ve2lFhJ0cDQLZhhoB8VGy9HpsXLE/NXmcWc43kIado=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z9hIeX24hquUJ4wdZrCAVMv/v+w7DswfB9yd2z01qBeU9SwSfFcRLINuYxFLbTbWy
	 nCaHOAy2bOHsxsSLnW36or7B1egpaZTiFbaplu1tu9fczmu8yYgPRzu0HEQQjipBKj
	 wF7yVRXjtqgUQEAKhMvSCNQYs0EgfDfTt4ZgnPiQ253vkvearAzcMUCmugprktCoY4
	 15q3WwfNIPyVkj8jz85EqiJL+k1gvJaO43mU0XhZYY+dC/maR+PBJXZAnxCGK+V3Yq
	 go65AH1Vp25BN4+5W6xdN9xTmNgn8I6z9KxJG8Ld2oDvMIelDF5KLf34AawQ3xnki3
	 M3MQrm9ffvLfw==
Date: Tue, 17 Feb 2026 15:34:31 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Simona Vetter <simona@ffwll.ch>, Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260217133431.GN12989@unreal>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260217080206.GJ12989@unreal>
 <0aa8147c-254d-4a1c-89ee-9dc4d4b6b022@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0aa8147c-254d-4a1c-89ee-9dc4d4b6b022@amd.com>

On Tue, Feb 17, 2026 at 10:52:25AM +0100, Christian König wrote:
> On 2/17/26 09:02, Leon Romanovsky wrote:
> > On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
> >> Changelog:
> >> v7:
> >>  * Fixed messed VFIO patch due to rebase.
> > 
> > <...>
> > 
> > Christian,
> > 
> > What should be my next step? Should I resubmit it?
> 
> No, the patches are fine as they are. I'm just waiting for the backmerge of upstream to apply them.

Thanks
