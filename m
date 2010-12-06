From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Mon, 6 Dec 2010 14:27:59 -0700
Message-ID: <20101206212759.GB16788@obsidianresearch.com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
 <4CFD4BEE.5070205@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CFD4BEE.5070205-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 06, 2010 at 09:47:42PM +0100, Jabe wrote:

> Technologies MT25204 [InfiniHost III Lx HCA]; and dual E5430 xeon
> (not nehalem).

Newer Mellanox cards have most of the offloads you see for ethernet so
they get better performance. Plus > Nehalem is just better at TCP in
the first place..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
