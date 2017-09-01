From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/5] verbs: Use ccan list.h instead of open
 coding lists
Date: Fri, 1 Sep 2017 09:05:33 +0200
Message-ID: <b4255929-e0bc-d779-7190-f38fea24395e@suse.de>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 31/08/2017 à 22:50, Jason Gunthorpe a écrit :
> For ibv_sysfs_dev, ibv_driver_name and ibv_driver internal structs. ccan
> lists are easier to understand and use than the open coded versions.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libibverbs/init.c | 62 +++++++++++++++++++++++++------------------------------
>  1 file changed, 28 insertions(+), 34 deletions(-)
>
> diff --git a/libibverbs/init.c b/libibverbs/init.c
[...]
> @@ -156,7 +156,8 @@ static int find_sysfs_devs(struct ibv_sysfs_dev **tmp_sysfs_dev_list)
>  		else
>  			sysfs_dev->abi_ver = 0;
>  
> -		*tmp_sysfs_dev_list = sysfs_dev;
> +		list_node_init(&sysfs_dev->entry);
> +		list_add(tmp_sysfs_dev_list, &sysfs_dev->entry);

I don't think you need to init the node.
According to the header file: " * The new list_node does not need to be initialized; it will be overwritten."

>  		sysfs_dev      = NULL;
>  	}
>  
> @@ -181,13 +182,9 @@ void verbs_register_driver(const char *name,
>  
>  	driver->name            = name;
>  	driver->verbs_init_func = verbs_init_func;
> -	driver->next            = NULL;
>  
> -	if (tail_driver)
> -		tail_driver->next = driver;
> -	else
> -		head_driver = driver;
> -	tail_driver = driver;
> +	list_node_init(&driver->entry);
> +	list_add_tail(&driver_list, &driver->entry);

Same here

>  }
>  
>  static void load_driver(const char *name)
> @@ -261,9 +258,7 @@ static void load_drivers(void)
>  		}
>  	}
>  
> -	for (name = driver_name_list, next_name = name ? name->next : NULL;
> -	     name;
> -	     name = next_name, next_name = name ? name->next : NULL) {
> +	list_for_each_safe(&driver_name_list, name, next_name, entry) {
>  		load_driver(name->name);
>  		free(name->name);
>  		free(name);
> @@ -314,8 +309,8 @@ static void read_config_file(const char *path)
>  				continue;
>  			}
>  
> -			driver_name->next = driver_name_list;
> -			driver_name_list  = driver_name;
> +			list_node_init(&driver_name->entry);
> +			list_add(&driver_name_list, &driver_name->entry);

And here


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
