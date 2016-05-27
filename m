From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Fri, 27 May 2016 00:46:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
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
 <20160526233612.GA4396@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160526233612.GA4396-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I would be very sad if our new API required allocations on every
> ioctl.

Are you referring to kernel or user space allocations?

For the kernel, I declared a small amount of data on the stack, and allocate memory only if the ioctl length is larger.  We can probably adjust the stack size to support most operations.

For user space, do we have a guess wrt the common number of sgl entries that would be used as input data?  Knowing an expected number of objects also seems needed to come up with an optimal design here.

> The idea with a sgl is that the core would check it with access_ok,
> just like we do today, and then the implementation would
> copy_from_user directly to the stack, like how the header scheme vs
> data scheme works today. The attraction is we can keep with an
> attribute type model without having to copy the whole buffer to parse
> the attribute structure.
> 
> The main problem with the current scheme is that it is hard to add
> variable sized things like addresses without opencoding that
> everywhere. It is also hard to express what the kernel supports, and
> doesn't well support 'optional' things.

If the sgl contained offsets from the start of the memory buffer, rather than pointers to different buffers, we could support variable sized attributes without needing to fetch multiple buffers.

As it stands, I don't see how we get away from calling copy from user twice in most circumstances.  Keeping most ioctls to this requires some sort of trade off.  But I think we can keep enough flexibility to support everything we want.

> This is where I see the attraction of the attribute id labeled buffer.

I like the idea of an attribute id labeled buffer myself.  But I think the processing of the ioctl data is better handled by the kernel client, rather than the framework.  The framework just needs to know enough to copy the data efficiently into/out from the kernel, and I don't know what's the optimal design here.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
