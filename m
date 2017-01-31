From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Tue, 31 Jan 2017 12:37:58 -0800
Message-ID: <20170131203758.GB32458@infradead.org>
References: <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126202330.GX6005@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB0E15AD@ORSMSX109.amr.corp.intel.com>
 <20170127010452.GA7826@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0E1609@ORSMSX109.amr.corp.intel.com>
 <41e74ed7-fd8d-89cf-2c79-b99a8d786fac@redhat.com>
 <A4803088-726E-4B88-B421-CE1969B6E25B@ccn-mail.lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A4803088-726E-4B88-B421-CE1969B6E25B-K3XgeB3KlJxL3NSqSJqx7PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 06:37:58PM +0000, Coulter, Susan K wrote:
> This is happening now - not in the future.
> LANL and other DOE labs already have OPA and IB/mlnx on the same host.

And have setups with up to three different providers :)

But the whole point is that the new rdma-core setup gives us a sane
way to handle this:  patch your rdma-core tree with whatever vendor
updates you need, same as the kernel.  The current model where vendors
supply a new libibverbs that has all kinds of incompatible hacks is
simply not sustainable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
