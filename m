From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 17:17:01 -0600
Message-ID: <20170801231701.GA10239@obsidianresearch.com>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <20170801195840.GC31205@obsidianresearch.com>
 <20170801203815.GA4620@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801203815.GA4620-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 03:38:15PM -0500, Chien Tin Tung wrote:

> > Presumably the iwpmd kernel side is designed to handle the locking
> > right to avoid deadlocks.
> 
> Please stop using the word deadlock in relation to usage of 1-shot
> retry in ibnl_unicast.  It does not and will not cause deadlock period.
> It will wait for a buffer within timeout value but that's it.

I think you are arguing semantics here.

My understanding with netlink (and it has been years since I've
looked) is that there is way for netlink callbacks to be run within
the context of the user thread calling send(). In this case calling
blocking netlink_unicast within such a callback will 'deadlock', as
netlink_unicast waits for the current thread to call recv(), which can
never happen.

We still call this a deadlock even though the sndtimer rescues
the overall system, as the system was in a deadlocked state for
a time.

> > Leon is also right that every other user of netlink_unicast in rdma
> > should be using the non-blocking version.
> 
> In Mustafa's patch, there are calls to both versions of ibnl_unicast.
> There are situations where the retry version of ibnl_unicast
> is not desirable, note I didn't say wrong.

I haven't studied closely, but if any of those blocking
netlink_unicasts are in netlink callbacks, it would need very
careful inspection to determine if that is OK.

> buffers available.  If a buffer does not become available within
> timeout parameter, you have bigger problems.

Well.. It is problematic to create that situation in the first place.

Usually you would never run unsolicited netlink traffic and
request/response traffic over the same socket. Having the kernel
randomly drop responses because the sndbuf is full of unsolicited
traffic is really problematic.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
