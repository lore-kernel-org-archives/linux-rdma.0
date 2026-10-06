Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FDA3AB288
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791293866; cv=none; b=iuabM57qc/F68nP+aLjfQlvXTMVnWs4SAQoMjxqjk4WxdPTNkSRGdr4K65GCV0liQIC9eFQHwM4/4XOlsAm+vcu7+6eEGewB7OicKIU2nWiGmKqQh/ETMNGKZiXAaa4n34cCrAYbWC7cMRCf9J3FCkLDuZwyHVk5D/hJAqhKN4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791293866; c=relaxed/simple;
	bh=JObbdodZlnC6pk7GRpxaq7KKSMUim6qqpDSNVeh692s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFmGIJF7gVH+Hguqatr88dPgLfGxneill8+c4k+z9dVzpHdR+a8wu8bsaauk7ygMNhfNhPqHx93MT1UisPu2/NFwD0LTHtQMXYvfEumV6JhmWML0Adw1+6ZcxOGMciKylZUoxsOnsUD62JPWDJMVY33RHZakyYxWpqSJlMGAvEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwM3A+41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwM3A+41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FAC1F000FF;
	Tue,  6 Oct 2026 13:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791293863;
	bh=3rj0mP8eO2TmeXpcDj1nBLatHS3PdDhrEGr5fImp/zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iwM3A+41+6FnHZd0/m5LTDIZnmD8PBgUfS5AJKQtJ6FNYEmvQ0FxdmFYx4D/INZ8W
	 soP4Hz1VZZr3TtQhx8soX2wv92mWCqC5u9HfYunaigWTDiNAnMrPBBIkeOEuwSez4J
	 UoEKW1S9wLRelclr/wLR/Kd+plkdkujghLRRMtO2VKCOmrcPtErof4RSwVtV5+VsDe
	 OLrdphernZcjV1dyU/Cd54hRzfwVctm0dwk51sCyUpyhVXWL9g8BeUl4KyzBj+nR17
	 f188QBPK4fug1AqSs5h8GXyohw1p30YY7nAwNIuGgqTqFBRgQant9blfewCqdLSi5X
	 kz6YIiprLxxNg==
Date: Tue, 6 Oct 2026 16:37:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Clear driver_udata before destroying objects
 in rdma_core
Message-ID: <20261006133739.GA7822@unreal>
References: <20261001162628.3187887-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001162628.3187887-1-jmoroni@google.com>

On Thu, Oct 01, 2026 at 04:26:28PM +0000, Jacob Moroni wrote:
> When uobject creation fails while copying user output data (i.e.,
> after the HW object has been created), it calls
> rdma_alloc_abort_uobject() with hw_obj_valid=true which then
> invokes the object's destroy callback, but passes the
> uverbs_attr_bundle from the original creation command.
> 
> The issue is that drivers are expected to validate the udata
> and return an error if there's unexpected content, and data from
> the wrong command counts as "unexpected content", so this ends
> up causing the driver's destroy call to fail.
> 
> A similar issue exists in the rereg_mr path when a new MR
> is created and the old one is destroyed.
> 
> Fix this by clearing driver_udata before invoking the driver's
> destroy method.
> 
> Fixes: 6e0954b11c05 ("RDMA/uverbs: Allow drivers to create a new HW object during rereg_mr")
> Fixes: 0ac8903cbbe6 ("RDMA/core: Allow the ioctl layer to abort a fully created uobject")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>
> ---
>  drivers/infiniband/core/ib_core_uverbs.c | 12 ------------
>  drivers/infiniband/core/rdma_core.c      |  2 ++
>  drivers/infiniband/core/rdma_core.h      | 17 +++++++++++------
>  3 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
> index 41c84ffe8c09..1482d9b27b38 100644
> --- a/drivers/infiniband/core/ib_core_uverbs.c
> +++ b/drivers/infiniband/core/ib_core_uverbs.c
> @@ -535,18 +535,6 @@ int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs)
>  }
>  EXPORT_SYMBOL(uverbs_destroy_def_handler);
>  
> -/*
> - * When calling a destroy function during an error unwind we need to pass in
> - * the udata that is sanitized of all user arguments. Ie from the driver
> - * perspective it looks like no udata was passed.
> - */
> -struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
> -{
> -	attrs->driver_udata = (struct ib_udata){};
> -	return &attrs->driver_udata;
> -}
> -EXPORT_SYMBOL_NS_GPL(uverbs_get_cleared_udata, "rdma_core");
> -
>  /**
>   * _uverbs_alloc() - Quickly allocate memory for use with a bundle
>   * @bundle: The bundle
> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> index fd5651c003ae..fc727dbbb897 100644
> --- a/drivers/infiniband/core/rdma_core.c
> +++ b/drivers/infiniband/core/rdma_core.c
> @@ -735,6 +735,7 @@ void rdma_assign_uobject(struct ib_uobject *to_uobj, struct ib_uobject *new_uobj
>  	 * If this fails then the uobject is still completely valid (though with
>  	 * a new ID) and we leak it until context close.
>  	 */
> +	uverbs_get_cleared_udata(attrs);
>  	uverbs_destroy_uobject(to_uobj, RDMA_REMOVE_DESTROY, attrs);
>  }
>  EXPORT_SYMBOL_NS_GPL(rdma_assign_uobject, "rdma_core");
> @@ -751,6 +752,7 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
>  	int ret;
>  
>  	if (hw_obj_valid) {
> +		uverbs_get_cleared_udata(attrs);
>  		ret = uobj->uapi_object->type_class->destroy_hw(
>  			uobj, RDMA_REMOVE_ABORT, attrs);
>  		/*
> diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
> index 2b91e8527287..9de14e625dd3 100644
> --- a/drivers/infiniband/core/rdma_core.h
> +++ b/drivers/infiniband/core/rdma_core.h
> @@ -71,14 +71,19 @@ int uverbs_output_written(const struct uverbs_attr_bundle *bundle, size_t idx);
>  
>  void setup_ufile_idr_uobject(struct ib_uverbs_file *ufile);
>  
> -#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
> -struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs);
> -#else
> -static inline struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
> +/*
> + * When calling a destroy function during an error unwind we need to pass in
> + * the udata that is sanitized of all user arguments. Ie from the driver
> + * perspective it looks like no udata was passed.
> + */
> +static inline struct ib_udata *
> +uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
>  {
> -	return NULL;
> +	if (!attrs)
> +		return NULL;

I would expect changes in create_qp() too after writing this function
like you wrote.

Thanks

> +	attrs->driver_udata = (struct ib_udata){};
> +	return &attrs->driver_udata;
>  }
> -#endif
>  
>  /*
>   * This is the runtime description of the uverbs API, used by the syscall
> -- 
> 2.56.0.rc1.315.gc6ed9934b7-goog
> 
