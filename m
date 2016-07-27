From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 05/15] IB/pvrdma: Add UAR support
Date: Wed, 27 Jul 2016 10:58:38 -0700
Message-ID: <9d3c3fa8-5468-860d-0ac9-1521d9ebe6ad@vmware.com>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-6-git-send-email-aditr@vmware.com>
 <20160718132545.GD20674@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718132545.GD20674-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 7/18/16 6:25 AM, Leon Romanovsky wrote:
>> +int pvrdma_uar_table_init(struct pvrdma_dev *dev)
>> +{
>> +	u32 num = dev->dsr->caps.max_uar;
>> +	u32 mask = num - 1;
>> +	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
>> +
>> +	/* Power of 2 */
>> +	if (num != 1 << (ffs(num) - 1))
>> +		return -EINVAL;
> 
> Can functions/macros defined in include/linux/log2.h replace the code
> above?
> 

I guess I can replace the ffs stuff with is_power_of_2 from log2.h.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
