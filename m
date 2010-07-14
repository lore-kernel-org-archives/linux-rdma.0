From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IB perf test questions
Date: Wed, 14 Jul 2010 15:16:50 -0600
Message-ID: <20100714211650.GA7348@obsidianresearch.com>
References: <4C3E1DDF.1090305@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C3E1DDF.1090305-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 14, 2010 at 02:28:15PM -0600, Tom Ammon wrote:

> Also, whether I use ib_read_bw or ib_write_bw, the machine I initiate 
> the test from (in this case "taildrop") shows one of its CPU cores 
> pegged at 100% for the duration of the test, but I see no CPU 
> utilization at all on the receiving node. Can someone explain to me 
> what's going on under the hood, here? I would think that read_bw would 
> load up the sending host but that write_bw would load up the receiving 
> host (or maybe vice versa), so this seems counterintuitive to me. when I 
> use the -b flag to do a bidirectional test, a single CPU core on both 
> machines pegs at 100%.

In all cases the master machine sits in a CPU bound loop waiting for
completions so it can issue more RDMA operations. The difference
between write and read is simply the RDMA op that is issued.

The slave side just sits there and the NIC does all the work.

Bi-directional mode runs a master operation on both sides..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
