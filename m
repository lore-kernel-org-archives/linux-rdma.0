From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 05/13] IB/cm: Share listening CM IDs
Date: Tue, 28 Jul 2015 11:25:42 +0300
Message-ID: <55B73C86.30608@mellanox.com>
References: <1437924832-18327-1-git-send-email-haggaie@mellanox.com>
 <1437924832-18327-6-git-send-email-haggaie@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A901F86B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A901F86B-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/07/2015 22:04, Hefty, Sean wrote:
>> +struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
>> > +				     ib_cm_handler cm_handler,
>> > +				     __be64 service_id, __be64 service_mask)
>> > +{
>> > +	struct cm_id_private *cm_id_priv;
>> > +	struct ib_cm_id *cm_id;
>> > +	unsigned long flags;
>> > +	int err = 0;
>> > +
>> > +	/* Create an ID in advance, since the creation may sleep */
>> > +	cm_id = ib_create_cm_id(device, cm_handler, NULL);
>> > +	if (IS_ERR(cm_id))
>> > +		return cm_id;
>> > +
>> > +	spin_lock_irqsave(&cm.lock, flags);
>> > +
>> > +	if (service_id == IB_CM_ASSIGN_SERVICE_ID)
>> > +		goto new_id;
>> > +
>> > +	/* Find an existing ID */
>> > +	cm_id_priv = cm_find_listen(device, service_id, NULL);
>> > +	if (cm_id_priv) {
> The service_mask is being ignored through this code path.

Thanks.

I think it would be better just to remove the service_mask parameter
from this function, right? rdma_cm makes no use of the service mask.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
