From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rsockets and other performance
Date: Thu, 14 Jun 2012 11:22:45 -0600
Message-ID: <20120614172245.GC6552@obsidianresearch.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FDA0233.6090409-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 14, 2012 at 08:24:35AM -0700, Pradeep Satyanarayana wrote:

> With these minimal changes IPoIB throughput reached between
> 19-20Gb/s with just 2 threads. This was really unexpected. Given
> that, we wanted to revisit the usage of checksums in IPoIB.
> So, it looks worthwhile to allow for 'checksum-less' IPoIB-CM within
> a cluster on a single subnet. From a checksum perspective, this
> would be no different from RDMA. What are your thoughts?

There have been discussions around a 'checksum-less' IPoIB operation
for a little while.

The basic notion was to enable the checksum offload mechanism, pass
the information from Linux for offload straight through to the other
side (eg via an extra header or something), have the other side
reconstruct the offload indication on RX and inject back to into the
net stack.

This would be similar to the way checksum bypass works in
virtualization (Xen/KVM) where the virtualized net TX just packages
the offload data and sends it to the hyperviser kernel which then RX's
it and restores the very same checksum offload information.

During the CM process this feature would be negotiated.

I don't think anyone ever made patches for this, but considering the
performance delta you see it really seems worthwhile.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
