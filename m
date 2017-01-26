From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Thu, 26 Jan 2017 10:13:25 -0700
Message-ID: <20170126171325.GA16562@obsidianresearch.com>
References: <1485446147.4194.4.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485446147.4194.4.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 04:55:47PM +0100, Benjamin Drung wrote:
> the rmda-core commit 683e55aa5d291c8fda338dae565fbdae0c0000b5 "ibverbs:
> Allow vendor data response in create_ah command" breaks the ABI of the
> libibverbs library: The symbol ibv_cmd_create_ah@IBVERBS_1.0 is replaced
> by ibv_cmd_create_ah@IBVERBS_1.4. Please bring back ibv_cmd_create_ah@IB
> VERBS_1.0 to restore the ABI. Otherwise the version of the soname needs
> to be bumped from 1 to 2.

The ibv_cmd_* family of symbols are now considered private internal
symbols only for use between libibverbs and the included plugin libraries.

The decision was made to stop supporting providers outside of
rdma-core, so the library SONAME only reflects the public facing ABI.

I missed asking for this when the ibv_cmd_create_ah@IBVERBS_1.4 patch
was merged, but before we release 13 we need to drop all the ibv_cmd_*
entry points from the public headers so that nothing outside rdma-core
can link to these symbols.

AFAIK this is an accepted way to build a library that works with
private loadable plugins.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
