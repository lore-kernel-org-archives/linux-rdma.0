From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Mon, 05 Jun 2017 10:29:19 -0400
Message-ID: <1496672959.7171.148.camel@redhat.com>
References: <20170529082423.1180-1-leon@kernel.org>
         <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
         <20170531040437.GE5406@mtr-leonro.local>
         <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
         <1496261429.2608.15.camel@sandisk.com>
         <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
         <20170604053635.GD6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170604053635.GD6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-06-04 at 08:36 +0300, Leon Romanovsky wrote:
> On Fri, Jun 02, 2017 at 11:28:49AM -0500, Shiraz Saleem wrote:
> > 
> > On Wed, May 31, 2017 at 02:10:31PM -0600, Bart Van Assche wrote:
> > > 
> > > On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > > > 
> > > > > 
> > > > > 5. I proposed a solution -> go and fix your user space
> > > > > program.
> > > > 
> > > > This is a kernel patch you are trying to revert, you are
> > > > breaking existing
> > > > kernel functionality.  Nothing to do with user space.
> > > > 
> > > > Bottom line, come up with a solution that will address both
> > > > port mapper
> > > > functionality and your issue.
> > > 
> > > Hello Shiraz,
> > > 
> > > Sorry that this means additional work for you, but I agree with
> > > Leon that
> > > user space software should not assume that netlink sockets are a
> > > reliable
> > > communication mechanism.
> > 
> > Hi Bart - Thank you for your response.
> > 
> > The original problem was that ibnl_unicast, which is used to send
> > nl messages from
> > portmapper kernel space to user-space, would occasionally and
> > momentarily fail under stress.
> > We could have retried the call for a certain amount of time, but
> > since netlink_unicast has a
> > nonblock/block parameter, we chose to use the blocking option with
> > a timeout. So we thought we
> > did account for deadlocks with this timeout.
> 
> Not really, you just reduced the chances. In very large scale, you
> will
> have a very large chances of such deadlocks.

Since it has a timeout, it's not a deadlock, it's a state consistency
failure.  Once it happens, the user space and kernel space port maps
will no longer be in sync.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
