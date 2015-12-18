From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Save the device attributes on the
 device structure
Date: Fri, 18 Dec 2015 09:49:09 -0700
Message-ID: <20151218164909.GA7354@obsidianresearch.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com>
 <1450358340-19361-2-git-send-email-ogerlitz@mellanox.com>
 <5672BC33.9050606@dev.mellanox.co.il>
 <20151217174138.GB26015@obsidianresearch.com>
 <5673BF09.7050200@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5673BF09.7050200-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 18, 2015 at 10:08:41AM +0200, Or Gerlitz wrote:
> On 12/17/2015 7:41 PM, Jason Gunthorpe wrote:
> >On Thu, Dec 17, 2015 at 03:44:19PM +0200, Sagi Grimberg wrote:
> >>>+	ret = ib_query_device(device, &device->attrs);
> >>>+	if (ret) {
> >>>+		printk(KERN_WARNING "Couldn't query the device attributes\n");
> >>>+		goto out;
> >>>+	}
> >>>+
> >>I thought we're all for removing the call altogether aren't we?
> >>
> >>I'd say just call device->query_device() instead.
> >Christoph's patch even got rid of device->query_device(),
> 
> Wrong.

Not really, lots of hunks in Christoph's patch are removing
query_device ie:

@@ -1305,7 +1299,6 @@  int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.phys_port_cnt        = dev->limits.num_ports;
 	dev->ib_dev.num_comp_vectors     = 1;
 	dev->ib_dev.dma_device           = &dev->pdev->dev;
-	dev->ib_dev.query_device         = mthca_query_device;
 	dev->ib_dev.query_port           = mthca_query_port;

Sure, it sticks around in a couple places but it isn't 'query_device'
anymore, it is 'query_device_udata' which is reasonable.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
