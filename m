From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Thu, 17 Dec 2015 12:54:46 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512171252200.2954@east.gentwo.org>
References: <20151211182532.332343651@linux.com> <20151211182543.329283794@linux.com> <20151211235630.GG7855@phlsvsds.ph.intel.com> <20151212000047.GA9961@obsidianresearch.com> <566EEE69.5080906@dev.mellanox.co.il> <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com> <5670717F.9090701@dev.mellanox.co.il> <20151215212035.GD28167@obsidianresearch.com> <alpine.DEB.2.20.1512161000150.17457@east.gentwo.org> <alpine.DEB.2.20.1512161332200.10147@east.gentwo.org>
 <5672F47F.9060806@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5672F47F.9060806-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 17 Dec 2015, Hal Rosenstock wrote:

> > + * Get a MAD block of data.
>
> Nit: Get PerfMgt MAD block of data

Ok.

> > + * Returns error code or the number of bytes retrieved.
> > + */
> > +static int get_mad(struct ib_device *dev, int port_num, int attr,
>
> Nit: Maybe this is too verbose but better name might be get_perf_mad

Ok.

> > +static int port_check_extended_counters(struct ib_device *dev, int port)
> > +{
> > +	int ret = 0;
> > +	struct ib_class_port_info cpi;
> > +
> > +	ret = get_mad(dev, port, IB_PMA_CLASS_PORT_INFO, &cpi, 40, sizeof(cpi));
>
> ClassPortInfo is per class not per class per port so need to indicate to
> get_mad whether a port is supplied or not or conditionalize based on
> attr ID.

I thought a port is always supplied since we get the info for a particular
port and the directory only exists if there is a port?

> > -	ret = sysfs_create_group(&p->kobj, &pma_group);
> > +	ret = sysfs_create_group(&p->kobj,
> > +		port_check_extended_counters(device, port_num) ?
> > +			&pma_group_ext :
> > +			&pma_group);
>
> PortExtendedCounters does not have all the error counters in
> PortCounters so this isn't an either or. When extended port counters are
> supported should still include the original port counters with the
> exception of the [xmit rcv] [pkts data] which should come from the
> extended counters.

The original port counters are still included. The _ext table refers to
both extended and regular counters.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
