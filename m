Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5E22D5957;
	Fri, 20 Feb 2026 08:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771574658; cv=none; b=AwbVybLox1fgGm64a4OIiCNes2fcWIysZePMvGJFQBhbiBHBTX8PKugBAeDay8nWPhh6T9jbkOj1Z38ItaAUH4IyTfo3dGJ1Uqg50NCmpVGEqQkh4MJ97EXsgAe2UI81c0hfAUR2i3hKPCrg806j6X1vGuC5rCU9PbvPlYola0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771574658; c=relaxed/simple;
	bh=FRyY/r346yBZhlAlgpCTjZ+rp4eaAOsttUduuv+reQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edYzkQINvKZE8XFfIxBUwMoa7ByEYX+gUABeCB+rPDWbaItm9uicrnmjnWI9kUjawacJ69g37yU91lrp6MWTxJzadbUiJ2pPM5m0jQzbc+EwtXVahZZBXaJyXSg0apf+HwnSWc5cX+Pe07MM6ZK/zGWi8qe0UQTuiOsS/nXc3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=secq5QqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="secq5QqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E23C116C6;
	Fri, 20 Feb 2026 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771574657;
	bh=FRyY/r346yBZhlAlgpCTjZ+rp4eaAOsttUduuv+reQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=secq5QqS/QF4T1JdKbA85X+uM+AHQjLvQzvvm8IcxkSxFF3WQxsB3DL8XzMBrqvtx
	 sFztKk84VRx4SOv8Z22OALpRoKxlmKWAcHw1UQej6ysL3pKS8jJokSsN+JdlGc0Wtd
	 bkQog5ZAokkA8SfqcIqgwERTGrQWG+MijWS101sSXtkAykhO0PKPN6//l9S2ZYvDz8
	 FEbWmkViJlcc5lgAr9WZcJE8e0RGxksTBEKmRfUa/p9ZFf+9NRTdSUlTCQwdBD6yWQ
	 1MCusH7+fvppR/oYVMkTGgXolmsgb18aPeoNQ0QxaBLNbQAzP584sKQp2+X7TDc8DB
	 qpbe1Jn9nps+w==
Date: Fri, 20 Feb 2026 10:04:13 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Amir Tzin <amirtz@nvidia.com>
Subject: Re: [PATCH V2] driver core: auxiliary bus: Fix sysfs creation on bind
Message-ID: <20260220080413.GB10607@unreal>
References: <20260219210435.1769394-1-tariqt@nvidia.com>
 <DGJCHYS3SKIQ.1TIHQCMEOCRC@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DGJCHYS3SKIQ.1TIHQCMEOCRC@kernel.org>

On Fri, Feb 20, 2026 at 12:59:45AM +0100, Danilo Krummrich wrote:
> On Thu Feb 19, 2026 at 10:04 PM CET, Tariq Toukan wrote:
> > +/**
> > + * auxiliary_device_sysfs_irq_dir_init - initialize the IRQ sysfs directory
> > + * @auxdev: auxiliary bus device to initialize the sysfs directory.
> > + *
> > + * This function should be called by drivers to initialize the IRQ directory
> > + * before adding any IRQ sysfs entries. The driver is responsible for ensuring
> > + * this function is called only once and for handling any concurrency control
> > + * if needed.
> > + *
> > + * Drivers must call auxiliary_device_sysfs_irq_dir_destroy() to clean up when
> > + * done.
> > + *
> > + * Return: zero on success or an error code on failure.
> > + */
> > +int auxiliary_device_sysfs_irq_dir_init(struct auxiliary_device *auxdev)
> >  {
> > -	int ret = 0;
> > -
> > -	guard(mutex)(&auxdev->sysfs.lock);
> > -	if (auxdev->sysfs.irq_dir_exists)
> > -		return 0;
> > +	int ret;
> >  
> > -	ret = devm_device_add_group(&auxdev->dev, &auxiliary_irqs_group);
> > +	ret = sysfs_create_group(&auxdev->dev.kobj, &auxiliary_irqs_group);
> >  	if (ret)
> >  		return ret;
> >  
> > -	auxdev->sysfs.irq_dir_exists = true;
> >  	xa_init(&auxdev->sysfs.irqs);
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL_GPL(auxiliary_device_sysfs_irq_dir_init);
> > +
> > +/**
> > + * auxiliary_device_sysfs_irq_dir_destroy - destroy the IRQ sysfs directory
> > + * @auxdev: auxiliary bus device to destroy the sysfs directory.
> > + *
> > + * This function should be called by drivers to clean up the IRQ directory
> > + * after all IRQ sysfs entries have been removed. The driver is responsible
> > + * for ensuring all IRQs are removed before calling this function.
> > + */
> > +void auxiliary_device_sysfs_irq_dir_destroy(struct auxiliary_device *auxdev)
> > +{
> > +	xa_destroy(&auxdev->sysfs.irqs);
> > +	sysfs_remove_group(&auxdev->dev.kobj, &auxiliary_irqs_group);
> > +}
> > +EXPORT_SYMBOL_GPL(auxiliary_device_sysfs_irq_dir_destroy);
> >  
> >  /**
> >   * auxiliary_device_sysfs_irq_add - add a sysfs entry for the given IRQ
> > @@ -45,7 +70,8 @@ static int auxiliary_irq_dir_prepare(struct auxiliary_device *auxdev)
> >   * @irq: The associated interrupt number.
> >   *
> >   * This function should be called after auxiliary device have successfully
> > - * received the irq.
> > + * received the irq. The driver must call auxiliary_device_sysfs_irq_dir_init()
> > + * before calling this function for the first time.
> 
> I'm not convinced by this approach. This adds two new sources of bugs for
> drivers.
> 
>   1. Drivers can now forget to call auxiliary_device_sysfs_irq_dir_init()
>      *before* auxiliary_device_sysfs_irq_add().
> 
>   2. Drivers can forget to call auxiliary_device_sysfs_irq_dir_destroy().

This init->add->remove->destroy pattern follows standard Linux kernel practice.
I expect all current review tools to flag any missing function call
among these three.

Drivers already call auxiliary_device_sysfs_irq_add() and
auxiliary_device_sysfs_irq_remove(). It seems unlikely that they would
intentionally omit half of the required callbacks.

<...>

> There may only be multiple concurrent calls to auxiliary_device_sysfs_irq_add()
> itself, and in this case irq_dir_exists can just be an atomic.
> 
> Yes, we're still stuck with an atomic for irq_dir_exists, but the driver API
> remains much simpler and less error prone.

It is not, atomic is not a replacement for locking and this hunk is
going to be racy as hell:

   25 static int auxiliary_irq_dir_prepare(struct auxiliary_device *auxdev)
   26 {
   ...
   30         if (auxdev->sysfs.irq_dir_exists)
   31                 return 0;
   32
   33         ret = devm_device_add_group(&auxdev->dev, &auxiliary_irqs_group);
   34         if (ret)
   35                 return ret;
   36
   37         auxdev->sysfs.irq_dir_exists = true;

In the proposed patch, locking is handled by the driver, which understands the
flow far better than the driver core.

Thanks

> 
> - Danilo
