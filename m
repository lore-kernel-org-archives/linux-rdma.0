From: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi: Properly set permissions for user device files
Date: Thu, 17 Sep 2015 18:18:15 +0200
Message-ID: <55FAE7C7.3070003@redhat.com>
References: <1442439695-14275-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442439695-14275-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/16/2015 11:41 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> @@ -125,7 +151,20 @@ int __init dev_init(void)
>  		ret = PTR_ERR(class);
>  		pr_err("Could not create device class (err %d)\n", -ret);
>  		unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
> +		goto done;
>  	}
> +	class->devnode = hfi1_devnode;
> +
> +	user_class = class_create(THIS_MODULE, class_name_user());
> +	if (IS_ERR(user_class)) {
> +		ret = PTR_ERR(user_class);
> +		pr_err("Could not create device class for user accisble files (err %d)\n",
                                                               ^^^^^^^^
Typo in error message.

> +		       -ret);
> +		class_destroy(class);
> +		class = NULL;
> +		unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);

Missing "goto done"? Otherwise this:

> +	}
> +	user_class->devnode = hfi1_user_devnode;

... will explode.

>  
>  done:
>  	return ret;
> @@ -138,5 +177,10 @@ void dev_cleanup(void)
>  		class = NULL;
>  	}
>  
> +	if (user_class) {
> +		class_destroy(user_class);
> +		user_class = NULL;
> +	}
> +

It's actually harmless to call class_destroy(NULL). No need to check.

Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
