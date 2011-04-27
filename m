From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] [PATCH] do not use the dimn_ports_file if not using dor
 routing
Date: Wed, 27 Apr 2011 13:50:05 +0300
Message-ID: <20110427105005.GA2410@calypso.voltaire.com>
References: <1303322533.21002.121.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1303322533.21002.121.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 11:02 Wed 20 Apr     , Albert Chu wrote:
> Do not use the dimn_ports_file if not using dor routing. If the
> dimn_ports_file is specified, it currently will be utilized regardless
> of the routing algorithm actually being used.
> 
> Al
> 
> -- 

I guess that dimn_ports_file option was designed to be used with DOR, however
it got me thinking whether this option could be useful for other cases too.
For instance, can you use dimn_ports_file to manually sort ports instead of
using Support-remote-guid-sorting patch you recently suggested?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
