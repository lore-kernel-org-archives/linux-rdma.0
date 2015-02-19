From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/core: Add support for extended query device
 caps
Date: Thu, 19 Feb 2015 11:27:50 -0700
Message-ID: <20150219182750.GA30093@obsidianresearch.com>
References: <1424244364-6242-1-git-send-email-haggaie@mellanox.com>
 <1424244364-6242-2-git-send-email-haggaie@mellanox.com>
 <CAAKD3BAPL82RC5u5uxJg9QPgiM+05TcnURzO14Y5OKYxhYrmqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BAPL82RC5u5uxJg9QPgiM+05TcnURzO14Y5OKYxhYrmqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 19, 2015 at 02:30:29PM +0200, Matan Barak wrote:

> I think we should all agree about the extension verbs mechanism before
> taking it further.
> IMHO, using comp_mask only for fields that their valid value != 0 is confusing.
> For example, an old kernel should support a command if:
> (a) it knows all its valid bits
> (b) all fields after the size it knows is 0
> 
> In the old schema, the kernel only needs to look at the comp_mask
> bits and execute the command or reject it.

It doesn't really change anything, the kernel still has to go field by
field to check, all that happens is

if ((comp_mask & BIT) && offsetof(field..) < size)
  // field is valid

becomes

if (offsetof(field..) < size && field != 0)
  // field is valid

> Furthermore, ibv_create_flow and ibv_destroy_flow were already
> accepted using the old schema.

IIRC they didn't have values that could meaningfully be 0?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
