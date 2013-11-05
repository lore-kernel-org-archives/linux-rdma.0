From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: AW: AW: AW: IPoIB GRO
Date: Tue, 5 Nov 2013 10:24:31 -0700
Message-ID: <20131105172431.GA14706@obsidianresearch.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>
 <527759C6.3070009@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>
 <52779612.9020103@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>
 <5278A757.2070406@mellanox.com>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D@EXCHANGE.collogia.de>
 <5278B0CA.9080305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5278B0CA.9080305-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 05, 2013 at 10:48:10AM +0200, Erez Shitrit wrote:

> so, to summarize:
> The HW does the work (truncates the big ip packet to series of ip
> packets, each with the relevant mtu size and increases the ip-id for
> each)
> The FW enables that work on the HW
> the FW in A0 card doesn't enable that option for the HW.

Sounds like this bug causes a performance regression, and it sounds
like it puts incorrect packets on the wire.

This should be patched, have the driver disable TSO for cards that
can't support it...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
