From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Fri, 12 Jan 2018 09:34:02 -0600
Message-ID: <20180112153402.GA12452@ctung-MOBL3.amr.corp.intel.com>
References: <20180112055842.23125-1-leon@kernel.org>
 <20180112141524.GA16256@ctung-MOBL3.amr.corp.intel.com>
 <20180112150602.GN15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112150602.GN15760-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 05:06:02PM +0200, Leon Romanovsky wrote:
> On Fri, Jan 12, 2018 at 08:15:24AM -0600, Chien Tin Tung wrote:
> > On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> > > Hi,
> > >
> > > There is small set of fixes targeted for rdma-rc.
> >
> > For RC?  Are these fixing regressions?  We are already in RC7.
> 
> Jason was clear last time, he wants to work like Dave, fixes go always
> without any relation to -RC.

I won't claim to know Dave's process since I don't drectly submit
patches to Netdev.  However given Dave's history with the kernel,
I highly doubt he would accept patches late in RC cycle that would
jeopardize a kernel release.

I would like to hear directly from Doug and Jason on this and so 
we are clear on the policy to be enforced with infiniband subsystem.

In the meantime, I will quote the official documentation from kernel.org
(https://www.kernel.org/doc/html/v4.10/process/howto.html)



4.x kernel tree

[...]

        After two weeks a -rc1 kernel is released and the focus is on making
the new kernel as rock solid as possible. Most of the patches at this point
should fix a regression. Bugs that have always existed are not regressions, so
only push these kinds of fixes if they are important. Please note that a whole
new driver (or filesystem) might be accepted after -rc1 because there is no risk
of causing regressions with such a change as long as the change is self-contained
and does not affect areas outside of the code that is being added. git can be
used to send patches to Linus after -rc1 is released, but the patches need to
also be sent to a public mailing list for review.



Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
