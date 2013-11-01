From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC v2 01/10] IB/core: Introduce protected memory regions
Date: Fri, 01 Nov 2013 10:09:16 -0700
Message-ID: <5273E03C.3010501@acm.org>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 5:24, Sagi Grimberg wrote:
> +/**
> + * ib_mr_init_attr - Memory region init attributes passed to routine
> + *	ib_create_mr.
> + * @max_reg_descriptors: max number of registration units that
> + *   may be used with UMR work requests.
> + * @flags: MR creation flags bit mask.
> + */
> +struct ib_mr_init_attr {
> +	int	    max_reg_descriptors;
> +	int	    flags;
> +};

Is this the first patch that add the abbreviation "UMR" to a header file 
in include/rdma ? If so, I think it's a good idea not only to mention 
the abbreviation but also what UMR stands for.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
