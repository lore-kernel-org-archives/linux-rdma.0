From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Mon, 12 Aug 2013 17:43:21 -0600
Message-ID: <20130812234321.GA18341@obsidianresearch.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
 <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
 <20130521205713.GB11318@obsidianresearch.com>
 <1375989856.27609.10.camel@localhost.localdomain>
 <20130812190545.GA7968@obsidianresearch.com>
 <8d276f12593ddc79233fa41abdaf0d41@meuh.org>
 <20130812203935.GA8990@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA54FE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA54FE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 12, 2013 at 08:59:10PM +0000, Hefty, Sean wrote:

> This is slightly off topic, but what is the underlying reason for
> having the libibverbs config directory?  Is it simply to support the
> library name being different than the device name, or is there
> something more?

I use it quite frequently to setup ibverbs to use non-system paths to
find the libaries.

It seems to me the whole idea of this system is that a vendor could
ship a binary interface blob in /opt/foo/lib/ and just drop one file
into libibverbs.d to configure that blob.

Frankly, I'm not really sure there is much value in this whole
loadable mechanism. I'm unaware of people actually using the dynamic
load in a meaningful way and it seems many of the drivers would be
better maintained if they were part of verbs directly...

The realities of the kernel GPL seem to preclude having a binary
user-space, and drivers are not really being shipped separately from
verbs..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
