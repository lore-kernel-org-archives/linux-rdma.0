From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 01:38:35 +0300
Message-ID: <20131211223834.GA3955@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Upinder Malhi,

The patch b1819c455542: "IB/usnic: Add Cisco VIC low-level hardware
driver" from Sep 10, 2013, leads to the following static checker
warning:
	drivers/infiniband/hw/usnic/usnic_uiom.c:47 usnic_uiom_alloc_pd()
	warn: passing zero to 'PTR_ERR'"

drivers/infiniband/hw/usnic/usnic_uiom.c
   469          pd->domain = domain = iommu_domain_alloc(&pci_bus_type);
                                      ^^^^^^^^^^^^^^^^^^^
This function returns NULL on error not error pointers.

   470          if (IS_ERR_OR_NULL(domain)) {
   471                  usnic_err("Failed to allocate IOMMU domain with err %ld\n",
   472                                  PTR_ERR(pd->domain));
   473                  kfree(pd);
   474                  return ERR_PTR(domain ? PTR_ERR(domain) : -ENOMEM);
   475          }

Similar harmless but crappy slop in:

vers/infiniband/hw/usnic/usnic_ib_main.c
   249          us_ibdev = (struct usnic_ib_dev *)ib_alloc_device(sizeof(*us_ibdev));
   250          if (IS_ERR_OR_NULL(us_ibdev)) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^
   251                  usnic_err("Device %s context alloc failed\n",
   252                                  netdev_name(pci_get_drvdata(dev)));
   253                  return ERR_PTR(us_ibdev ? PTR_ERR(us_ibdev) : -EFAULT);
   254          }
   255  
   256          us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
   257          if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   258                  usnic_err("Failed to alloc ufdev for %s with err %ld\n",
   259                                  pci_name(dev), PTR_ERR(us_ibdev->ufdev));
   260                  goto err_dealloc;
   261          }

The general confusing about what return values are leads to a bug later
on:

vers/infiniband/hw/usnic/usnic_ib_main.c
   462          pf = usnic_ib_discover_pf(vf->vnic);
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This function returns ERR_PTRs.  Also it has a bug and can return freed
pointers.  Oops...  :(

   463          if (!pf) {
   464                  usnic_err("Failed to discover pf of vnic %s with err%d\n",
   465                                  pci_name(pdev), err);
   466                  goto out_clean_vnic;
   467          }
   468  
   469          vf->pf = pf;
   470          spin_lock_init(&vf->lock);
   471          mutex_lock(&pf->usdev_lock);

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
