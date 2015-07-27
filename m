From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 05/13] IB/cm: Share listening CM IDs
Date: Mon, 27 Jul 2015 19:04:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A901F86B@ORSMSX109.amr.corp.intel.com>
References: <1437924832-18327-1-git-send-email-haggaie@mellanox.com>
 <1437924832-18327-6-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437924832-18327-6-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +/**
> + * Create a new listening ib_cm_id and listen on the given service ID.
> + *
> + * If there's an existing ID listening on that same device and service
> ID,
> + * return it.
> + *
> + * @device: Device associated with the cm_id.  All related communication
> will
> + * be associated with the specified device.
> + * @cm_handler: Callback invoked to notify the user of CM events.
> + * @service_id: Service identifier matched against incoming connection
> + *   and service ID resolution requests.  The service ID should be
> specified
> + *   network-byte order.  If set to IB_CM_ASSIGN_SERVICE_ID, the CM will
> + *   assign a service ID to the caller.
> + * @service_mask: Mask applied to service ID used to listen across a
> + *   range of service IDs.  If set to 0, the service ID is matched
> + *   exactly.  This parameter is ignored if %service_id is set to
> + *   IB_CM_ASSIGN_SERVICE_ID.
> + *
> + * Callers should call ib_destroy_cm_id when done with the listener ID.
> + */
> +struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
> +				     ib_cm_handler cm_handler,
> +				     __be64 service_id, __be64 service_mask)
> +{
> +	struct cm_id_private *cm_id_priv;
> +	struct ib_cm_id *cm_id;
> +	unsigned long flags;
> +	int err = 0;
> +
> +	/* Create an ID in advance, since the creation may sleep */
> +	cm_id = ib_create_cm_id(device, cm_handler, NULL);
> +	if (IS_ERR(cm_id))
> +		return cm_id;
> +
> +	spin_lock_irqsave(&cm.lock, flags);
> +
> +	if (service_id == IB_CM_ASSIGN_SERVICE_ID)
> +		goto new_id;
> +
> +	/* Find an existing ID */
> +	cm_id_priv = cm_find_listen(device, service_id, NULL);
> +	if (cm_id_priv) {

The service_mask is being ignored through this code path.


> +		if (cm_id->cm_handler != cm_handler || cm_id->context) {
> +			/* Sharing an ib_cm_id with different handlers is not
> +			 * supported */
> +			spin_unlock_irqrestore(&cm.lock, flags);
> +			return ERR_PTR(-EINVAL);
> +		}
> +		atomic_inc(&cm_id_priv->refcount);
> +		++cm_id_priv->listen_sharecount;
> +		spin_unlock_irqrestore(&cm.lock, flags);
> +
> +		ib_destroy_cm_id(cm_id);
> +		cm_id = &cm_id_priv->id;
> +		return cm_id;
> +	}
> +
> +new_id:
> +	/* Use newly created ID */
> +	err = __ib_cm_listen(cm_id, service_id, service_mask, NULL, false);
> +
> +	spin_unlock_irqrestore(&cm.lock, flags);
> +
> +	if (err) {
> +		ib_destroy_cm_id(cm_id);
> +		return ERR_PTR(err);
> +	}
> +	return cm_id;
> +}
> +EXPORT_SYMBOL(ib_cm_insert_listen);
> +
>  static __be64 cm_form_tid(struct cm_id_private *cm_id_priv,
>  			  enum cm_msg_sequence msg_seq)
>  {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
