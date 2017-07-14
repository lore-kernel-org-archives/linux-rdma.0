From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core soon in Debian
Date: Fri, 14 Jul 2017 10:06:57 -0600
Message-ID: <20170714160657.GC25760@obsidianresearch.com>
References: <1500041591.3563.31.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500041591.3563.31.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 14, 2017 at 04:13:11PM +0200, Benjamin Drung wrote:
> 3) Get rid of openibd and rdma service dependencies:
> 
> $ git grep openibd
> ibacm/CMakeLists.txt:set(rdmascript "openibd")
> srp_daemon/CMakeLists.txt:set(RDMA_SERVICE "openibd" CACHE STRING

I think Bart fixed most of these issues when he added systemd support,
so I recommend removing it from SRP for init.d as well.

No idea about what is wrong with ibacm that it needs this strange
ordering. Guessing we probably needs hotplug support in verbs to fully
make it work reliably, Yishia has patches for that pending..

Ideally we would make ibacm socket activate which will ameliorate most
boot time ordering issues even if there are still hot plug bugs in
ibacm..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
