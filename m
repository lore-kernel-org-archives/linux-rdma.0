From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Fri, 2 Jun 2017 11:28:49 -0500
Message-ID: <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496261429.2608.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496261429.2608.15.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 31, 2017 at 02:10:31PM -0600, Bart Van Assche wrote:
> On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > > 5. I proposed a solution -> go and fix your user space program.
> > 
> > This is a kernel patch you are trying to revert, you are breaking existing
> > kernel functionality.  Nothing to do with user space.
> > 
> > Bottom line, come up with a solution that will address both port mapper
> > functionality and your issue.
> 
> Hello Shiraz,
> 
> Sorry that this means additional work for you, but I agree with Leon that
> user space software should not assume that netlink sockets are a reliable
> communication mechanism.

Hi Bart - Thank you for your response.

The original problem was that ibnl_unicast, which is used to send nl messages from 
portmapper kernel space to user-space, would occasionally and momentarily fail under stress. 
We could have retried the call for a certain amount of time, but since netlink_unicast has a 
nonblock/block parameter, we chose to use the blocking option with a timeout. So we thought we 
did account for deadlocks with this timeout.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
