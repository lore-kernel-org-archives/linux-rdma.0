From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 16:41:08 +0200
Message-ID: <20091125144108.GA18088@mtls03>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
 <20091125001136.GP6188@obsidianresearch.com>
 <4B0D3982.2040408@mellanox.co.il>
 <7127F20E-2307-492D-B929-A6ACA5A74D14@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7127F20E-2307-492D-B929-A6ACA5A74D14-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2009 at 09:30:40AM -0500, Jeff Squyres wrote:
> 
> In practice, we have seen that applications *do* need to query the
> transport type -- at least (real) IB vs. iWARP.  It is your
> expectation that IB and IBoE will function identically?
> 
> Can you discuss the "transport" vs. "transport_type" questions?
> 

The reason for identifying each specific port with its own transport
is to allow devices which may configure each port differently to be
distinhishable. ConnectX is one such device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
