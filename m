From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: iser-target: Add iSCSI Extensions for RDMA (iSER) target driver
Date: Tue, 5 Jan 2016 00:07:32 +0300
Message-ID: <20160104210732.GA8675@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Nicholas Bellinger,

The patch b8d26b3be8b3: "iser-target: Add iSCSI Extensions for RDMA
(iSER) target driver" from Mar 7, 2013, leads to the following static
checker warning:

	drivers/infiniband/ulp/isert/ib_isert.c:423 isert_device_get()
	error: passing non negative 1 to ERR_PTR

drivers/infiniband/ulp/isert/ib_isert.c
   417  
   418          device->ib_device = cma_id->device;
   419          ret = isert_create_device_ib_res(device);
   420          if (ret) {
   421                  kfree(device);
   422                  mutex_unlock(&device_list_mutex);
   423                  return ERR_PTR(ret);

The warning here is because isert_create_device_ib_res() returns either
a negative error code, zero or one.  The documentation is not clear what
that means.  AHAHAHAHAHAHAHAH.  I joke.  There is no documentation.

Anyway, it's definitely a bug and it leads to a NULL dereference in the
caller.

   424          }
   425  
   426          device->refcount++;
   427          list_add_tail(&device->dev_node, &device_list);
   428          isert_info("Created a new iser device %p refcount %d\n",
   429                     device, device->refcount);
   430          mutex_unlock(&device_list_mutex);
   431  
   432          return device;
   433  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
