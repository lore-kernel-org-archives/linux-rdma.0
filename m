From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Tue, 10 Jan 2017 10:54:14 -0700
Message-ID: <20170110175414.GA11593@obsidianresearch.com>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
 <a1b3f6cc-2de0-8a19-18dd-182f2cb7d3e1@dev.mellanox.co.il>
 <1484069764.2149.18.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484069764.2149.18.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 10, 2017 at 12:36:04PM -0500, Doug Ledford wrote:
> file that needs the memory barriers defined in the headers, and when
> you include the header, the compile error returns. ??The proper fix is
> just to get 32bit arm defines in place.

It is a little worse than that, 32 bit ARM is not DMA coherent at all
so it simply cannot work. The fix is to not compile providers that
require DMA coherence on arches that cannot provide it.

Bit tricky, but almost done..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
