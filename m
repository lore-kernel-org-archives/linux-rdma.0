From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [hch-jcswGhMUV9g@public.gmane.org: Re: CQ and RDMA READ/WRITE APIs]
Date: Mon, 16 May 2016 14:48:38 +0200
Message-ID: <20160516124838.GA1896@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry, forgot linux-rdma.  Please reply on the main thread on linux-ker=
nel
instead of here.

----- Forwarded message from Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> -----

Date: Mon, 16 May 2016 13:49:26 +0200
=46rom: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: CQ and RDMA READ/WRITE APIs
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[adding Linus and linux-kernel to Cc]

On Fri, May 13, 2016 at 08:04:17PM -0400, Doug Ledford wrote:
> You submitted new files into the subsystem under GPL only license in
> contrast to the rest of the subsystem.  This presents a problem.  I'm=
 in
> the position where I need to either revert them, or I need your
> permission to make them dual license GPL/BSD to match the rest of the
> subsystem.  Were you intentionally trying to make the OFED work illeg=
al,
> or just an oversight?

Hi Doug,

the RDMA code was developed for a GPLed driver and moved to the code,
and lots of people contributed to it under the GPL, as they assumed
Linux code in genral is.  =D0=86f dual-licensing is possible at all it =
would
require a lot of work, which I don't think is worth it.  If you don't
want GPL code in the core rdma.ko module we can move it to a rdma-gpl.k=
o
module, but that would be a little bit odd.

----- End forwarded message -----
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
