From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/1] Add support for ZONE_DEVICE IO memory with
 struct pages.
Date: Thu, 17 Mar 2016 10:11:21 -0600
Message-ID: <20160317161121.GA19501@obsidianresearch.com>
References: <1457979277-26791-1-git-send-email-stephen.bates@pmcs.com>
 <20160314212344.GC23727@linux.intel.com>
 <20160314215708.GA7282@obsidianresearch.com>
 <56EACAB3.5070301@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56EACAB3.5070301-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Stephen Bates <stephen.bates-PwyqCcigF0Q@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, javier-rmLALz0KWFtWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2016 at 05:18:11PM +0200, Haggai Eran wrote:
> On 3/14/2016 11:57 PM, Jason Gunthorpe wrote:
> > The other issue is that the fencing mechanism RDMA uses to create
> > ordering with system memory is not good enough to fence peer-peer
> > transactions in the general case. It is only possibly good enough if
> > all the transactions run through the root complex.
> 
> Are you sure this is a problem? I'm not sure it is clear in the PCIe 
> specs, but I thought that for transactions that are not relaxed-ordered 
> and don't use ID-based ordering, a PCIe switch must prevent reads and 
> writes from passing writes.

Yes, that is right, and that is good enough if the PCI-E fabric is a
simple acyclic configuration (ie the common case).

There are fringe cases that are more complex, and maybe the correct
reading of the spec is to setup routing to avoid optimal paths, but it
certainly is possible to configure switches in a way that could not
guarentee global ordering.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
