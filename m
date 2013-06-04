From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH libmlx4 v6 1/2] libmlx4: Infra-structure changes to support
 verbs extensions
Date: Tue, 04 Jun 2013 14:39:52 -0500
Message-ID: <51AE4288.4010505@opengridcomputing.com>
References: <1364332591-22866-1-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364332591-22866-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/26/2013 4:16 PM, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

<snip>

> @@ -236,23 +235,30 @@ found:
>   		return NULL;
>   	}
>   
> -	dev = malloc(sizeof *dev);
> +	dev = calloc(1, sizeof(*dev));
>   	if (!dev) {
>   		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
>   			uverbs_sys_path);
>   		return NULL;
>   	}
>   
> -	dev->ibv_dev.ops = mlx4_dev_ops;
>   	dev->page_size   = sysconf(_SC_PAGESIZE);
> -
> -	return &dev->ibv_dev;
> +	dev->verbs_dev.sz = sizeof(*dev);
> +	dev->verbs_dev.size_of_context =
> +		sizeof(struct mlx4_context) - sizeof(struct ibv_context);
> +	 /* mlx4_init_context will initialize provider calls */
> +	dev->verbs_dev.init_context = mlx4_init_context;
> +	dev->verbs_dev.uninit_context = mlx4_uninit_context;
> +
> +	return &dev->verbs_dev;
>   }
>   
> +
>   #ifdef HAVE_IBV_REGISTER_DRIVER
>   static __attribute__((constructor)) void mlx4_register_driver(void)
>   {
> -	ibv_register_driver("mlx4", mlx4_driver_init);
> +	verbs_register_driver("mlx4", mlx4_driver_init);
> +
>   }
>   #else

Shouldn't ibv_register_driver() need to be called in the lib constructor 
function if HAVE_IBV_REGISTER_DRIVER is not defined?


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
