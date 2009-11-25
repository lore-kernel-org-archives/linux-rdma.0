From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 10:39:17 -0700
Message-ID: <20091125173917.GK1966@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <4B0D3982.2040408@mellanox.co.il> <7127F20E-2307-492D-B929-A6ACA5A74D14@cisco.com> <20091125144108.GA18088@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091125144108.GA18088@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2009 at 04:41:08PM +0200, Eli Cohen wrote:
> On Wed, Nov 25, 2009 at 09:30:40AM -0500, Jeff Squyres wrote:
> > 
> > In practice, we have seen that applications *do* need to query the
> > transport type -- at least (real) IB vs. iWARP.  It is your
> > expectation that IB and IBoE will function identically?
> > 
> > Can you discuss the "transport" vs. "transport_type" questions?
> > 
> 
> The reason for identifying each specific port with its own transport
> is to allow devices which may configure each port differently to be
> distinhishable. ConnectX is one such device.

As far as I can tell there is no reason for a multi-port device to
be represented through verbs as a single device with multiple
protocols.

If you have a single physical chip with two ports and they are running
different protocols it seems much cleaner to me to report it to verbs
apps as two devices.

Doing this avoids creating compatability problems.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
