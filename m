Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695483;
	b=hcFCzH0TY5QrPFKlMNzaXpeO+AGKllTX+xwJx9RYq7xdgBT1ujoFFiU0vpha5olFGWbP
	 BfwTXovdAJ4dMV/QAh/JOkMS6Xk9TQ5R93Pg05m9OLuqP8FgtRmPKcDdaz9HdDJGPLdd3
	 s9Pb842EkisWo5rw99woGBapUoiQXX6BENV8QY6Yps+axtl5/jLAx3aehhK1Af7lsqQ5M
	 OSqrpM1JreJpW24xqe99xI5JzPH3OZeWn+n0cQh36zEO5NpfQaxI0yZNUD5wWdSr+yPJ6
	 u8r7grfw0wtw6yxc6RDSXu+/P0vk2h1XmZGdpMJLTYsHTYS0Hrf1dm9ScOB4RTCc3Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695483;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=PS7PSHtqOkpJCiWY6ZWwLrcNTeyjRBncMWEQHa5lM/c=;
	b=U5FArGEiMNarwxcqtRTvjUPrE9qGPce7fC8QqKUzTlO9Der2JVYHHi1iDNeI/AY6UIUM
	 iUIIUJrswKtvERqbeXSC7MaE/5pZDIsB24VZyHVOUTPk7Ky9/wzfl+hTd4ANph/DoL4Qz
	 8GPbWTuLmDIezXQnuYYHMB+2l8KzlynhD09rC3ipioRz8c6Eim4QY1/0urJ47BUSgOBa/
	 uQv8ilRpCVfMlv3PKnoi+cjMJjSvns9EK4b+mMuRvvJjqOG4wP0/8BNfgI46P+FY1fFpw
	 GmnFq/YekwZuTwzkRKi2/8iCYIYNaUG/SqZ80XR5ub+P6PYUzZ2pYG3UP2mBWp5nx/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lSwPIgyA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4287606A31C;
	Thu, 26 Nov 2026 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lSwPIgyA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789201F000CF;
	Thu, 26 Nov 2026 12:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695483;
	bh=PS7PSHtqOkpJCiWY6ZWwLrcNTeyjRBncMWEQHa5lM/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lSwPIgyAcLSz0W3hs3jRjrPjhy/xRVtl5/M/H9ylb9yY+9mQ8r5VHx6mxFkvRG1h5
	 znxv6Vu5JV5L5jLyRSUu+rSckC0pUViMRNzoFvIgi1/iowXR6Ov52CIUf/U/XeUy+U
	 zMfDJFsWTfCiJ+GGvGrOwNFf3GcJymmZA3m0qSOFhXvA8QwiOxDCenL2QtL9DMwevx
	 VIdOvmkuKFS7kE1p9AOxZGpNT3+ozYKXLG/uqASn1MapVmcNcckQTi9mPwZ8SIheRK
	 SdzFnlJIyln0RKyRfwoetfGwMPkvUJqlu1MNmEFe8V1sLa09CBH/KEj4vZk3t/F8Ax
	 2VGH7dGNrzw7Q==
Date: Thu, 26 Nov 2026 14:17:59 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Habil Eren =?iso-8859-1?Q?T=FCrker?= <habilerenturker@hotmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@nvidia.com>,
	Jiri Pirko <jiri@resnulli.us>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com" <syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com>
Subject: Re: [PATCH] RDMA/core: Fix slab-use-after-free in kernfs_find_ns()
Message-ID: <20261126121759.GK774860@unreal>
References: <20261124163151.50468-2-habilerenturker@hotmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124163151.50468-2-habilerenturker@hotmail.com>

On Tue, Nov 24, 2026 at 04:32:26PM +0000, Habil Eren Türker wrote:
> In drivers/infiniband/core/device.c, remove_one_compat_dev() unlocks
> device->compat_devs_mutex immediately after erasing cdev from
> the xarray. device_del(&cdev->dev) is performed outside the lock.
> 
> When IB device removal races with network namespace teardown
> (cleanup_net() -> rdma_dev_exit_net()), rdma_dev_exit_net() calls
> remove_one_compat_dev() and observes NULL from xa_erase(), and
> returns without waiting for device_del() to finish.

Please include the KASAN report in the commit message
and rewrite the AI-generated prose in function-ladder format.

Thanks

> 
> cleanup_net() frees struct net while device_del() is still executing,
> causing device_remove_class_symlinks() -> sysfs_delete_link() ->
> kernfs_ns_id() to read ns->ns_id from the freed struct net,
> which triggers a slab-use-after-free.
> 
> Fix this by moving mutex_unlock(&device->compat_devs_mutex) after
> device_del(&cdev->dev) finishes, while keeping put_device(&cdev->dev)
> outside the lock.
> 
> Fixes: 4e0f7b907072 ("RDMA/core: Implement compat device/sysfs tree in net namespace")
> Reported-by: syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=8c2fa00c27ecafd148f5
> Signed-off-by: Habil Eren Türker <habilerenturker@hotmail.com>
> ---
>  drivers/infiniband/core/device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 29af9fe860e2..f2a52af64718 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1030,12 +1030,13 @@ static void remove_one_compat_dev(struct ib_device *device, u32 id)
>  
>  	mutex_lock(&device->compat_devs_mutex);
>  	cdev = xa_erase(&device->compat_devs, id);
> -	mutex_unlock(&device->compat_devs_mutex);
>  	if (cdev) {
>  		ib_free_port_attrs(cdev);
>  		device_del(&cdev->dev);
> -		put_device(&cdev->dev);
>  	}
> +	mutex_unlock(&device->compat_devs_mutex);
> +	if (cdev)
> +		put_device(&cdev->dev);
>  }
>  
>  static void remove_compat_devs(struct ib_device *device)
> -- 
> 2.47.3
> 
