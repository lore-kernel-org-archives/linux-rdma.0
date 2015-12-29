From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/uapi: expose uverbs WC flags
Date: Tue, 29 Dec 2015 13:04:45 +0200
Message-ID: <568268CD.7040809@dev.mellanox.co.il>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-5-git-send-email-hch@lst.de>
 <20151227061545.GC8501@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151227061545.GC8501-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> +enum ib_uverbs_wc_flags {
>> +	IB_UVERBS_WC_GRH			= (1 << 0),
>> +	IB_UVERBS_WC_WITH_IMM			= (1 << 1),
>> +	IB_UVERBS_WC_WITH_INVALIDATE		= (1 << 2),
>> +	IB_UVERBS_WC_IP_CSUM_OK			= (1 << 3),
>> +	IB_UVERBS_WC_WITH_SMAC			= (1 << 4),
>> +	IB_UVERBS_WC_WITH_VLAN			= (1 << 5),
>> +	IB_UVERBS_WC_WITH_NETWORK_HDR_TYPE	= (1 << 6),
>> +};
> It will be great to add _FLAGS_ mark in the name and add _LAST too.

Don't you prefer to stay consistent with the kernel enumeration?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
