From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [bug report] IB/core: Enforce PKey security on QPs
Date: Fri, 30 Jun 2017 10:18:41 -0500
Message-ID: <33c88f11-808a-be7f-e103-1fa845beebcb@mellanox.com>
References: <20170628131532.y5vjpbbxvm2762hy@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628131532.y5vjpbbxvm2762hy@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/30/2017 2:53 AM, Dan Carpenter wrote:
>    122          if (pps->main.state != IB_PORT_PKEY_NOT_VALID) {
>    123                  get_pkey_and_subnet_prefix(&pps->main,
>    124                                             &pkey,
>                                                    ^^^^^
> Can get_pkey_and_subnet_prefix() fail?  None of the callers seem to be
> error checked so my static checker complains a lot.

The only way it could fail is if some memory corruption happened, because the port number is checked and must be valid before this could happen.  I submitted a patch for it though, it's definitely not clear it can't fail in that case.

>
>    125                                             &subnet_prefix);
>    126  
>    127                  ret = enforce_qp_pkey_security(pkey,
>    128                                                 subnet_prefix,
>    129                                                 sec);
>    130          }
>    131          if (ret)
>    132                  return ret;
>
> Also:
>
> drivers/infiniband/core/device.c
>    362  static void ib_policy_change_task(struct work_struct *work)
>    363  {
>    364          struct ib_device *dev;
>    365  
>    366          down_read(&lists_rwsem);
>    367          list_for_each_entry(dev, &device_list, core_list) {
>    368                  int i;
>    369  
>    370                  for (i = rdma_start_port(dev); i <= rdma_end_port(dev); i++) {
>    371                          u64 sp;
>    372                          int ret = ib_get_cached_subnet_prefix(dev,
>    373                                                                i,
>    374                                                                &sp);
>    375  
>    376                          WARN_ONCE(ret,
>    377                                    "ib_get_cached_subnet_prefix err: %d, this should never happen here\n",
>    378                                    ret);
>    379                          ib_security_cache_change(dev, i, sp);
>                                                                  ^^
> Potentially uninitialized.

This in the only check that can fail in ib_get_cached_subnet_prefix:

        if (port_num < rdma_start_port(device) ||
            port_num > rdma_end_port(device))
                return -EINVAL;

So this one won't even fail if memory is corrupted.  I submitted a patch for it though, to resolve your warning, and in case that ever changes.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
