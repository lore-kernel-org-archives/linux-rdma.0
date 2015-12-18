From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Save the device attributes on the
 device structure
Date: Fri, 18 Dec 2015 10:08:41 +0200
Message-ID: <5673BF09.7050200@mellanox.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com>
 <1450358340-19361-2-git-send-email-ogerlitz@mellanox.com>
 <5672BC33.9050606@dev.mellanox.co.il>
 <20151217174138.GB26015@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151217174138.GB26015-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/17/2015 7:41 PM, Jason Gunthorpe wrote:
> On Thu, Dec 17, 2015 at 03:44:19PM +0200, Sagi Grimberg wrote:
>>> +	ret = ib_query_device(device, &device->attrs);
>>> +	if (ret) {
>>> +		printk(KERN_WARNING "Couldn't query the device attributes\n");
>>> +		goto out;
>>> +	}
>>> +
>> I thought we're all for removing the call altogether aren't we?
>>
>> I'd say just call device->query_device() instead.
> Christoph's patch even got rid of device->query_device(),

Wrong.

UDATA is a mechanism added by the founders of the RDMA stack to allow 
for LL HW
driver pass data to LL HW user space library piggy backed on uverbs 
commands.

For example, mlx4 uses that to path details of the HW clock which are 
needed for libmlx4.

Christoph noted that and didn't remove the query_device entry from mlx4, he
also madethis somehow inelegant change to uverbs_cmd.c:

@@ -3624,26 +3607,29 @@ int ib_uverbs_ex_query_device(struct 
ib_uverbs_file *file,
         if (ucore->outlen < resp.response_length)
                 return -ENOSPC;

-       memset(&attr, 0, sizeof(attr));
-
-       err = ib_dev->query_device(ib_dev, &attr, uhw);
-       if (err)
-               return err;
+       if (ib_dev->query_device) {
+               int err = ib_dev->query_device(ib_dev, uhw);
+               if (err)
+                       return err;
+       } else {
+               if (uhw->inlen || uhw->outlen)
+                       return -EINVAL;
+       }


> which, IHMO, I prefer to see over this.

It would be wrong to disallow LL drivers to pass data back and forth to/from
their user space sister libraries, this is part of a 10Y old kernel UAPI.

> It re-enforces that these values are constants and drivers cannot change them on the fly.

yes, we should be looking on how to constify things, but incrementally.
I don't see why block this cleanup now as of this point.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
