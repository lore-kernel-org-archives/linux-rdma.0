From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Tue, 10 May 2016 10:46:08 -0600
Message-ID: <20160510164608.GA29825@obsidianresearch.com>
References: <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04A390@ORSMSX109.amr.corp.intel.com>
 <20160509200507.GA23911@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04A40A@ORSMSX109.amr.corp.intel.com>
 <0c0801d1aacd$280e52e0$782af8a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0c0801d1aacd$280e52e0$782af8a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Bodong Wang' <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 10, 2016 at 10:03:48AM -0500, Steve Wise wrote:

> I've been trying to follow this thread, and there has been comments that other
> device owners should speak up.  But I'm not sure what LSO would do for an iWARP
> RC QP connection.  Can someone give me a quick summary?  

It is unlikely someone would use LSO and an iWarp RC QP together.

However, an iWarp NIC may want to expose the raw ethernet QP style of
feature, which would probably also want to include the LSO, RSS,
timestamping etc features.

Most likely iWarp cards already include LSO features in their
netdevice drivers? In that instance I'd say, imagine that same LSO
feature works on a verbs QP and ask if the patch covers the way it
works.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
