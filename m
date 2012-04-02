From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value
 returned when the port is down
Date: Mon, 2 Apr 2012 12:47:25 -0600
Message-ID: <20120402184725.GB1311@obsidianresearch.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
 <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com>
 <4F79D558.1000908@dev.mellanox.co.il>
 <4F79D826.9070605@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823734519A40B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519A40B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 02, 2012 at 06:39:36PM +0000, Hefty, Sean wrote:
> > On 4/2/2012 7:35 PM, Hal Rosenstock wrote:
> > > Rather than always overwriting active_speed in this case, wouldn't it
> > > be better to only do that for invalid values?
> > 
> > Yes, I have thought about that, however, spotting invalid values would
> > make the code a bit ugly, so I took this approach, Roland?
> 
> Does the active speed even make sense if the port is down?  If not,
> should we assume that any value returned by the FW is correct?

Force returning SDR makes sense to me. The link width probably has a
similar problem too... Returning EINVAL from any sysfs query is really
unfriendly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
