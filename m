From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Thu, 26 May 2016 11:22:44 -0600
Message-ID: <20160526172244.GC27115@obsidianresearch.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
 <20160524210132.GB7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
 <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 06:18:02PM +0300, Matan Barak wrote:
> The proposal treat every pointer as a typed pointer (which pretty much
> resembles the netlink style of doing things, but instead of
> serializing it into the buffer, we just scatter it to multiple
> buffers).

Yes

> I'm not sure it makes the parsing and validations easier.

It means less parsing work, you don't need to validate message
structure for instance, the header can be copy'd without allocation,
size validation can be deferred to the reader, we don't need alignment
padding complexity.

It also means less parsing work in user space because the reply
message is already fully scattered where the caller wants it, so it
doesn't need to parse netlink stuff in the reply either.

The downside is that for the most part the reply structure must be
known in advance

> Actually, I was thinking about ditching the common response buffer and
> just overwriting the command buffer.

The sgl approach allows this by letting user-space set the in and out
pointers to the same thing, without having problems with specifying
the out length or requiring user space to parse netlink to find the
reply.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
