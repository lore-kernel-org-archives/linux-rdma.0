From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Thu, 03 Aug 2017 08:42:39 -0400
Message-ID: <1501764159.117042.9.camel@redhat.com>
References: <20170801120536.540-1-leon@kernel.org>
         <20170801120536.540-2-leon@kernel.org>
         <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
         <1501696661.109555.6.camel@redhat.com>
         <20170802185405.GE13672@mtr-leonro.local>
         <1501719575.117042.4.camel@redhat.com>
         <20170803051032.GF13672@mtr-leonro.local>
         <1501762973.117042.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501762973.117042.7.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-03 at 08:22 -0400, Doug Ledford wrote:
> On Thu, 2017-08-03 at 08:10 +0300, Leon Romanovsky wrote:
> > 
> > Because, I truly believe that they proposed the nasty hack, which
> > doesn't fix the real problem - inability to deal with losses of
> > netlink
> > messages.
> 
> In so much as the iwpmd needs to be modified to do a resync, I agree
> with you.  But, the fix they made caused the system to be "reliable
> enough" that the problem more or less disappeared.  It is true that,
> given enough load, the problem could resurface, but that hasn't
> happened yet in the real world.
> 
> However, iwpmd is part of rdma-core now, so *anyone* can fix it to do
> the resyncs as needed (and I don't know, maybe it does, I just did a
> quick grep for ENOBUFS to see if they capture that error and do a
> resync on it, and saw no hits for that with grep).

And in case this didn't sink in from the above statement, allow me to
make it explicit:

Does it not strike you how much of a failure it was on your part to
submit a kernel patch that breaks iwpmd, code that is now part of rdma-
core, FOR WHICH YOU ARE COMAINTAINER, without the corresponding patches
to rdma-core to fix the real issue?  You don't get to tell Chien to "go
fix his software" because his software is part of rdma-core for which
you are co-maintainer and ultimately you bear responsibility for rdma-
core as a whole whether Chien fixes his stuff or not!  Your job is to
make sure that rdma-core is never broken in the way you were going to
break it.  You had a conflict of interest here between your kernel work
and your user space responsibilities and you did not choose well how to
resolve that conflict.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
