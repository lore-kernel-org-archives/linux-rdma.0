From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/28] IB/Verbs: Implement new callback query_transport()
Date: Wed, 15 Apr 2015 16:39:47 -0400
Message-ID: <20150415203947.GB15877@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB4FA.5000109@profitbricks.com> <552EAF9D.8050400@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FC1C7C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC1C7C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 15, 2015 at 01:29:31PM -0600, Hefty, Sean wrote:
> > libibverbs also exposes transport at the device level. Isn't a change to
> > make transport per port rather than per device needed there as well to
> > be consistent with these proposed kernel changes ? If so, would the
> > additional IBoE transport be exposed ? We also need to worry about
> > backward compatibility for existing applications.
> 
> Libibverbs probably can't change without bumping the major version number.  If the kernel attribute structures change, this is probably something that the user_verbs module would need to handle to avoid breaking the ABI.
>

Transport is not directly sent thought the kernel ABI.  It is fabricated when
the HCA provider driver is loaded.

static struct ibv_device *try_driver(struct ibv_driver *driver,
                                     struct ibv_sysfs_dev *sysfs_dev)
{
...
        switch (dev->node_type) {
        case IBV_NODE_CA:
        case IBV_NODE_SWITCH:
        case IBV_NODE_ROUTER:
                dev->transport_type = IBV_TRANSPORT_IB;
                break;
        case IBV_NODE_RNIC:
                dev->transport_type = IBV_TRANSPORT_IWARP;
                break;
        case IBV_NODE_USNIC:
                dev->transport_type = IBV_TRANSPORT_USNIC;
                break;
        case IBV_NODE_USNIC_UDP:
                dev->transport_type = IBV_TRANSPORT_USNIC_UDP;
                break;
        default:
                dev->transport_type = IBV_TRANSPORT_UNKNOWN;
                break;
        }
...
}

I'm not sure how to fix this once we get to the user space problem.  But I
don't think it affects this set of patches.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
