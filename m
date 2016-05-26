From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Thu, 26 May 2016 17:36:12 -0600
Message-ID: <20160526233612.GA4396@obsidianresearch.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
 <20160524210132.GB7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
 <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05BB5D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 10:53:35PM +0000, Hefty, Sean wrote:
> Ideally, the number of calls to copy to/from user should be minimized.

I'd say we should avoid memory allocation first and if that takes more
copy calls then so be it. Our existing model uses many copy from user
calls and that is considered OK. Memory allocation is clearly more
expensive than a few copy setups.

I would be very sad if our new API required allocations on every
ioctl.

The idea with a sgl is that the core would check it with access_ok,
just like we do today, and then the implementation would
copy_from_user directly to the stack, like how the header scheme vs
data scheme works today. The attraction is we can keep with an
attribute type model without having to copy the whole buffer to parse
the attribute structure.

The main problem with the current scheme is that it is hard to add
variable sized things like addresses without opencoding that
everywhere. It is also hard to express what the kernel supports, and
doesn't well support 'optional' things.

This is where I see the attraction of the attribute id labeled buffer.

If we don't want to have attributes, then copy the basic current
scheme of single shared in/out buffer..

Or maybe do both <shrug>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
