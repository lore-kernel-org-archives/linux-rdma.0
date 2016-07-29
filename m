From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iSER-Target: Release connection resources properly
 when receiving RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Fri, 29 Jul 2016 23:33:11 +0300
Message-ID: <22568e6b-e764-bdd4-eec9-dc53a258b371@grimberg.me>
References: <20160727191511.18122-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727191511.18122-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> When the low level driver exercises the hot unplug they would call
> rdma_cm cma_remove_one which would fire DEVICE_REMOVAL event to all cma
> consumers. Now, if consumer doesn't make sure they destroy all IB
> objects created on that IB device instance prior to finalizing all
> processing of DEVICE_REMOVAL callback, rdma_cm will let the lld to
> de-register with IB core and destroy the IB device instance. And if the
> consumer calls (say) ib_dereg_mr(), it will crash since that dev object
> is NULL.

Yea... this used to work but sort of broke somewhere...

Thanks Raju, the patch looks good,

Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Doug,

Can you add a stable tag to this when picking it up?

Thanks,
Sagi
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
