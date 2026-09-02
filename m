Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10563264C2;
	Wed,  2 Sep 2026 07:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335819; cv=none; b=r6vg9ILW4ERXRxgblGtws14C3jPZll01cLM6x0pYRjlyIV287xPjMKr2CuZ/iaRbZWcJaN9irbbxDFLnBpgwzHk9aY1W46LsaIwMIuO06qPfXr+Bl0j+zloXSUIFvAVUsKQ+63d4upRkt6nXM1nq7Oa6SCTEcYlR2Spn+gHNQCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335819; c=relaxed/simple;
	bh=di/0XyP/axSGEY1GTyFzlDteqybhE8FTbzpPZ2XA0qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jmJ3dHubJDY0mS+z8iYKnkbNch1oa4pHJ3LRj2cVGUYxMmgggPXk6jiex9RiI2EI2RN3MsFd+vplBLKt0G0dFPeJnykKycovXhiOYkI3RfTd1jPcGeHvtrXJgUPqY/qyaWALgrDkOF42ltCpCy2j5ekJk2x8C7P1mDuc9jnwsOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rp2T5mpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rp2T5mpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F8D1F000E9;
	Wed,  2 Sep 2026 07:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335817;
	bh=LlS6WptXFYmw4bxd0+YZEKg/kMaFVKt7tLZqARxHEMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rp2T5mpIz89wNIiSwvpQtAbhewh8JG7dmyTqFED86nJihbpT9sju9HZUdVBIbuqvS
	 bYm/qSjPGBIYVaaZEVnto5b/coYrflbQoFXppQCU+JwzY+ts7uq1ilciskN25dfyum
	 qyWlBc5TnQiIpvqFPipX7MDRCDlsBRf4VQmnai/bTOYCU8J52sdWI3HAWPEZevZ7jP
	 PyW6IMnl7tW7WgJa1NM6YdQCdUuOiYKpAVmzir4G5TEgb/2EKegUnp8aaIxzO1sEX7
	 /r7VzDQu6KN3AwrbhcJXMpXweTzeEoT3RExeVs4SxtWVh10zm+steh325c2oALcxPo
	 4uE+JGZ/wEc5Q==
Date: Wed, 2 Sep 2026 10:56:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@nvidia.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Fix use-after-free when netns exit races
 compat dev removal
Message-ID: <20260902075653.GS24140@unreal>
References: <20260818080920.13555-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818080920.13555-1-serhatkumral1@gmail.com>

On Tue, Aug 18, 2026 at 11:09:20AM +0300, Serhat Kumral wrote:
> A compat device is removed from two places: disable_device() during the
> ib device unregistration, and rdma_dev_exit_net() when the netns it
> belongs to dies. remove_one_compat_dev() lets the xa_erase() decide
> which of the two performs the removal, but drops compat_devs_mutex
> before device_del(), so the caller that finds nothing to erase returns
> without waiting for the removal the other one is running.
> 
> When that caller is rdma_dev_exit_net(), cleanup_net() carries on while
> the compat device is still alive. Its kobject is tagged with the dying
> net, so the device_del() still in progress dereferences net->uevent_sock
> after uevent_net_exit() has freed it:
> 
>  CPU0 (ib-unreg-wq)                CPU1 (netns wq)
>  ------------------                ---------------
>  __ib_unregister_device()
>    disable_device()
>      remove_compat_devs()
>        remove_one_compat_dev()
>          xa_erase()
>          device_del(cdev)
>          ...
>                                    cleanup_net()
>                                      rdma_dev_exit_net()
>                                        remove_one_compat_dev()
>                                          xa_erase()
>                                        // returns without waiting
>                                      uevent_net_exit()
>                                        kfree(net->uevent_sock)
>          kobject_uevent_env()
>            net->uevent_sock->sk    // UAF
> 
>   BUG: KASAN: slab-use-after-free in kobject_uevent_env+0xb6f/0xc80
>   Read of size 8 at addr ffff888103806490 by task kworker/u16:1/41
>   Workqueue: ib-unreg-wq ib_unregister_work
>   Call Trace:
>    kobject_uevent_env+0xb6f/0xc80
>    device_del+0x737/0xc10
>    disable_device+0x1ad/0x230
>    __ib_unregister_device+0x229/0x3f0
>   Freed by task 12:
>    kfree+0x1b3/0x550
>    ops_undo_list+0x273/0x8c0
>    cleanup_net+0x3b3/0x720

Please don't trim kernel panic logs. Please post the full output,
including the steps required to reproduce the issue.

Thanks

> 
> Fix by holding compat_devs_mutex across the whole removal, so that once
> remove_one_compat_dev() returns the compat device is gone no matter
> which caller removed it.
> 
> Fixes: 4e0f7b907072 ("RDMA/core: Implement compat device/sysfs tree in net namespace")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
> With this patch applied the report no longer shows up.
> 
>  drivers/infiniband/core/device.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index d954eda63134..a80ac69ef986 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1005,14 +1005,20 @@ static void remove_one_compat_dev(struct ib_device *device, u32 id)
>  {
>  	struct ib_core_device *cdev;
>  
> +	/*
> +	 * Hold the lock across device_del(): the other remover may have won
> +	 * the xa_erase() and still be inside device_del(), and the netns exit
> +	 * path has to wait for it instead of letting cleanup_net() free the
> +	 * netns state the compat device is still tagged with.
> +	 */
>  	mutex_lock(&device->compat_devs_mutex);
>  	cdev = xa_erase(&device->compat_devs, id);
> -	mutex_unlock(&device->compat_devs_mutex);
>  	if (cdev) {
>  		ib_free_port_attrs(cdev);
>  		device_del(&cdev->dev);
>  		put_device(&cdev->dev);
>  	}
> +	mutex_unlock(&device->compat_devs_mutex);
>  }
>  
>  static void remove_compat_devs(struct ib_device *device)
> -- 
> 2.53.0
> 
