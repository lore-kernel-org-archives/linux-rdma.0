From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 03:03:15 +0000
Message-ID: <7E785E0E-85C8-498D-9269-46C95110BF53@cisco.com>
References: <20131211224019.GC3955@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131211224019.GC3955-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Content-Language: en-US
Content-ID: <8F0F73BC8A6A134988230E3D992D26CE-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Why not?  

We can switch to WARN_ON.  The kernel provides this macro - assert_spin_locked - which does asserts via BUG_ON that spin_is_locked, which makes me think that using BUG_ON in conjunction with spin_is_locked is legal.  We should use this macro instead of manually asserting, unless that it is not legal, in which case WARN_ON will do.

Upinder

On Dec 11, 2013, at 2:40 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Hello Upinder Malhi,
> 
> The patch b1819c455542: "IB/usnic: Add Cisco VIC low-level hardware
> driver" from Sep 10, 2013, leads to the following Smatch
> warning:
> 	drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c:467
> 	usnic_ib_qp_grp_create()
> 	error: scheduling with locks held: 'spin_lock:lock'
> 
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
>   449          BUG_ON(!spin_is_locked(&vf->lock));
>                        ^^^^^^^^^^^^^^^^^^^^^^^^
> Holding lock.
> Don't call BUG_ON(), use WARN_ON()?
> 
>   450  
>   451          err = usnic_vnic_res_spec_satisfied(&min_transport_spec[transport],
>   452                                                  res_spec);
>   453          if (err) {
>   454                  usnic_err("Spec does not meet miniumum req for transport %d\n",
>   455                                  transport);
>   456                  log_spec(res_spec);
>   457                  return ERR_PTR(err);
>   458          }
>   459  
>   460          port_num = usnic_transport_rsrv_port(transport, 0);
>   461          if (!port_num) {
>   462                  usnic_err("Unable to allocate port for %s\n",
>   463                                  netdev_name(ufdev->netdev));
>   464                  return ERR_PTR(-EINVAL);
>   465          }
>   466  
>   467          qp_grp = kzalloc(sizeof(*qp_grp), GFP_KERNEL);
>                                                  ^^^^^^^^^^
> Sleeping allocation.
> 
>   468          if (!qp_grp) {
>   469                  usnic_err("Unable to alloc qp_grp - Out of memory\n");
>   470                  return NULL;
>   471          }
> 
> regards,
> dan carpenter
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
