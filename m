From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V5 5/5] RDMA/isert: Limit read depth based on the device max_sge_rd capability
Date: Tue, 14 Jul 2015 09:41:00 -0500
Message-ID: <001201d0be43$1a240980$4e6c1c80$@opengridcomputing.com>
References: <20150705174353.10042.39648.stgit@build2.ogc.int> <20150705174505.10042.28442.stgit@build2.ogc.int> <20150714082721.GA30072@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714082721.GA30072-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Christoph Hellwig
> Sent: Tuesday, July 14, 2015 3:27 AM
> To: Steve Wise
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH V5 5/5] RDMA/isert: Limit read depth based on the device max_sge_rd capability
> 
> On Sun, Jul 05, 2015 at 12:45:06PM -0500, Steve Wise wrote:
> > Use the device's max_sge_rd capability to compute the target's read sge
> > depth.  Save both the read and write max_sge values in the isert_conn
> > struct, and use these when creating RDMA_WRITE/READ work requests.
> 
> Btw, any hance to make the NFS client use these values as well instead
> of the current rdma_read_max_sge() hack?

Chuck, can you add this to your cleanup list?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
