From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/core: Enforce PKey security on QPs
Date: Fri, 30 Jun 2017 10:53:19 +0300
Message-ID: <20170628131532.y5vjpbbxvm2762hy@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Daniel Jurgens,

The patch d291f1a65232: "IB/core: Enforce PKey security on QPs" from
May 19, 2017, leads to the following static checker warning:

	drivers/infiniband/core/security.c:127 check_qp_port_pkey_settings()
	error: uninitialized symbol 'pkey'.

drivers/infiniband/core/security.c
   112  static int check_qp_port_pkey_settings(struct ib_ports_pkeys *pps,
   113                                         struct ib_qp_security *sec)
   114  {
   115          u64 subnet_prefix;
   116          u16 pkey;
   117          int ret = 0;
   118  
   119          if (!pps)
   120                  return 0;
   121  
   122          if (pps->main.state != IB_PORT_PKEY_NOT_VALID) {
   123                  get_pkey_and_subnet_prefix(&pps->main,
   124                                             &pkey,
                                                   ^^^^^
Can get_pkey_and_subnet_prefix() fail?  None of the callers seem to be
error checked so my static checker complains a lot.

   125                                             &subnet_prefix);
   126  
   127                  ret = enforce_qp_pkey_security(pkey,
   128                                                 subnet_prefix,
   129                                                 sec);
   130          }
   131          if (ret)
   132                  return ret;

Also:

drivers/infiniband/core/device.c
   362  static void ib_policy_change_task(struct work_struct *work)
   363  {
   364          struct ib_device *dev;
   365  
   366          down_read(&lists_rwsem);
   367          list_for_each_entry(dev, &device_list, core_list) {
   368                  int i;
   369  
   370                  for (i = rdma_start_port(dev); i <= rdma_end_port(dev); i++) {
   371                          u64 sp;
   372                          int ret = ib_get_cached_subnet_prefix(dev,
   373                                                                i,
   374                                                                &sp);
   375  
   376                          WARN_ONCE(ret,
   377                                    "ib_get_cached_subnet_prefix err: %d, this should never happen here\n",
   378                                    ret);
   379                          ib_security_cache_change(dev, i, sp);
                                                                 ^^
Potentially uninitialized.

   380                  }
   381          }
   382          up_read(&lists_rwsem);
   383  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
