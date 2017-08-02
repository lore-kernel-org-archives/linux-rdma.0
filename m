From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: rdma-core build environment enabling out-of-core providers
Date: Wed, 2 Aug 2017 08:55:06 -0500
Message-ID: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently there is no way to build an out-of-rdma-core provider on a system
installed with rdma-core.  It would be useful to have rdma-core install the
needed headers and libs (ie the ccan stuff) as part of its install.  This would
be similar to previous releases of libibverbs that included the headers needed
for providers to build.   I would like to implement this for rdma-core, but
wanted feedback on this approach.  Maybe an rdma-core-devel type package?  I
guess I'm thinking this would be analogous to building out-of-kernel modules,
which is available for kernel developers. 

Thoughts?

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
