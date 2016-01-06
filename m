From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: iser-target: Add iSCSI Extensions for RDMA (iSER) target driver
Date: Wed, 06 Jan 2016 10:24:25 -0800
Message-ID: <1452104665.26125.22.camel@haakon3.risingtidesystems.com>
References: <20160104210732.GA8675@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160104210732.GA8675@mwanda>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Dan,

(Adding Sagi CC')

On Tue, 2016-01-05 at 00:07 +0300, Dan Carpenter wrote:
> Hello Nicholas Bellinger,
> 
> The patch b8d26b3be8b3: "iser-target: Add iSCSI Extensions for RDMA
> (iSER) target driver" from Mar 7, 2013, leads to the following static
> checker warning:
> 
> 	drivers/infiniband/ulp/isert/ib_isert.c:423 isert_device_get()
> 	error: passing non negative 1 to ERR_PTR
> 
> drivers/infiniband/ulp/isert/ib_isert.c
>    417  
>    418          device->ib_device = cma_id->device;
>    419          ret = isert_create_device_ib_res(device);
>    420          if (ret) {
>    421                  kfree(device);
>    422                  mutex_unlock(&device_list_mutex);
>    423                  return ERR_PTR(ret);
> 
> The warning here is because isert_create_device_ib_res() returns either
> a negative error code, zero or one.  The documentation is not clear what
> that means.  AHAHAHAHAHAHAHAH.  I joke.  There is no documentation.
> 
> Anyway, it's definitely a bug and it leads to a NULL dereference in the
> caller.
> 
>    424          }
>    425  
>    426          device->refcount++;
>    427          list_add_tail(&device->dev_node, &device_list);
>    428          isert_info("Created a new iser device %p refcount %d\n",
>    429                     device, device->refcount);
>    430          mutex_unlock(&device_list_mutex);
>    431  
>    432          return device;
>    433  }
> 

Looking at the current code, AFAICT isert_alloc_comps() ->
ib_req_notify_cq() is the one case where this can happen, right..?

Here's a quick patch that I'm applying to target-pending/for-next, that
always returns negative upon isert_create_device_ib_res() failure.

Thanks Dan!

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.
index 91eb22c..8954e12 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -356,7 +356,7 @@ isert_create_device_ib_res(struct isert_device *device)
        dev_attr = &device->dev_attr;
        ret = isert_query_device(device->ib_device, dev_attr);
        if (ret)
-               return ret;
+               goto out;
 
        /* asign function handlers */
        if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
@@ -372,7 +372,7 @@ isert_create_device_ib_res(struct isert_device *device)
 
        ret = isert_alloc_comps(device, dev_attr);
        if (ret)
-               return ret;
+               goto out;
 
        device->pd = ib_alloc_pd(device->ib_device);
        if (IS_ERR(device->pd)) {
@@ -390,6 +390,9 @@ isert_create_device_ib_res(struct isert_device *device)
 
 out_cq:
        isert_free_comps(device);
+out:
+       if (ret > 0)
+               ret = -EINVAL;
        return ret;
 }
