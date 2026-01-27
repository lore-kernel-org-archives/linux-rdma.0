Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8B6338584;
	Tue, 27 Jan 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769507917; cv=none; b=I96HquQ+Vxq1oYZEyfdAE4hl/TxpJpjUOqFVYcEsY5816nxw2gQJnahWW4Hv31KMBfQiGkMkhcKmK5mDXpdDJk0Q0Y6Aqr4H5GK8veeLVTBDEci4YOJLurwau3J7WQlVSpSBQItryQi1VWJqRic3RqOSEVOM13xkwolWky8hQ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769507917; c=relaxed/simple;
	bh=e43WCMmXKqoQ1viplvp1q9BvjTcDlq2o9m6+FYicNOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQBUW8SMEsilQTNppVvtXka4e1MyXdSxxgb2gqUmopjEB01GtOjj7I23KAHqaO/T9lXXiPh/qmHNGSuFp83OQu0hqyA7C6iDYeOO7SBv3dQTF4yEoTlJGjaNO5znmEmenI3SKGK2XsWz06PuvdFRb93I9YyyStMC0GEbSuhIJ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXyeIUrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXyeIUrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6682CC116C6;
	Tue, 27 Jan 2026 09:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769507917;
	bh=e43WCMmXKqoQ1viplvp1q9BvjTcDlq2o9m6+FYicNOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nXyeIUrwYH9Bvocj5q0H1KwuQq1u/sKXPPVIw9K2PpvUG9LoSqsRH6xT3lsT4xr+c
	 9y8emVYoVXxF3LwoCELy+invYwnX6zrkTk8R+d4CKR0mOVEMciyCy8BMUnrTC4KNj6
	 wdsO0lOvxpF6uI6g0uapcxuA0/8EZtzYAOupfFrf9C3S9aB8yRSbZ6DmR7hO4du9i+
	 QKRbzayg5NAafG3KIt7x2i73nJnOMWFOFi2hWGbKkXaCIbn4d2cfK6YZNTMJ/1qj17
	 Ooquo9YVpyBgYu3vzrWdY/ETm3IIOGXeiP+EUsNCvPgRA/cVf0jujyumqucigd0Fit
	 w5UegsPWQTs/w==
Date: Tue, 27 Jan 2026 11:58:31 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: Re: [PATCH v5 3/8] dma-buf: Always build with DMABUF_MOVE_NOTIFY
Message-ID: <20260127095831.GR13967@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-3-f98fca917e96@nvidia.com>
 <0d2ec2d6-c999-45d8-a2bd-b5b21883db47@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d2ec2d6-c999-45d8-a2bd-b5b21883db47@amd.com>

On Tue, Jan 27, 2026 at 10:26:26AM +0100, Christian König wrote:
> On 1/24/26 20:14, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > DMABUF_MOVE_NOTIFY was introduced in 2018 and has been marked as
> > experimental and disabled by default ever since. Six years later,
> > all new importers implement this callback.
> > 
> > It is therefore reasonable to drop CONFIG_DMABUF_MOVE_NOTIFY and
> > always build DMABUF with support for it enabled.
> > 
> > Suggested-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Reviewed-by: Christian König <christian.koenig@amd.com>
> 
> As long as nobody starts screaming in the last second or I encounter some other problem I'm going to push the first three patches to drm-misc-next now.

How do you see progress of other patches?
Can they be queued for that tree as well?

Thanks

> 
> They are basically just cleanups we should have done a long time ago.
> 
> Regards,
> Christian.
> 
