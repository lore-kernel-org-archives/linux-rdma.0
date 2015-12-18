From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Save the device attributes on the device structure
Date: Fri, 18 Dec 2015 00:16:32 -0500
Message-ID: <20151218051632.GE13023@phlsvsds.ph.intel.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com> <1450358340-19361-2-git-send-email-ogerlitz@mellanox.com> <5672BC33.9050606@dev.mellanox.co.il> <20151217174138.GB26015@obsidianresearch.com> <5672FF78.40401@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5672FF78.40401-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2015 at 07:31:20PM +0100, Bart Van Assche wrote:
> On 12/17/2015 06:41 PM, Jason Gunthorpe wrote:
> >On Thu, Dec 17, 2015 at 03:44:19PM +0200, Sagi Grimberg wrote:
> >>
> >>>+	ret = ib_query_device(device, &device->attrs);
> >>>+	if (ret) {
> >>>+		printk(KERN_WARNING "Couldn't query the device 
> >>>attributes\n");
> >>>+		goto out;
> >>>+	}
> >>>+
> >>
> >>I thought we're all for removing the call altogether aren't we?
> >>
> >>I'd say just call device->query_device() instead.
> >
> >Christoph's patch even got rid of device->query_device(), which, IHMO,
> >I prefer to see over this. It re-enforces that these values are
> >constants and drivers cannot change them on the fly.
> 
> I also would like to see the query_device() implementations to be 
> removed from the hw drivers.

As do I.  More than anything what I hate is all the places that allocate struct
ib_device_attr just to free it after the query call.

We discussed this patch ages ago and decided against it and FWIW It does not
hurt my feelings at all to drop it.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
