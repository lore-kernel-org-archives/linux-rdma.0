From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
 available
Date: Thu, 17 Dec 2015 15:28:06 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512171527060.22782@east.gentwo.org>
References: <20151217195255.334854705@linux.com> <20151217195312.334770847@linux.com> <567316F7.9030707@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567316F7.9030707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 17 Dec 2015, Hal Rosenstock wrote:

> > -	ret = sysfs_create_group(&p->kobj, &pma_group);
> > +	ret = sysfs_create_group(&p->kobj,
> > +		port_check_extended_counters(device) ?
> > +			&pma_group_ext :
>
> Would be nice to populate 2 different groups based on whether PMA
> supports full extended counters or extended counters without the IETF
> ones (no [uni mcast] [rcv xmit] pkt counters) in sysfs.

So port_check_extended_counters need to return another value for this.
The IETF ones are the uni/mcast xxx counters?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
