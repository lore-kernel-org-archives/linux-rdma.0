From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 12:49:54 -0600
Message-ID: <20150610184954.GA26404@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com>
 <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
 <557852EE.5030107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <557852EE.5030107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 06:08:30PM +0300, Matan Barak wrote:
> >It isn't really a cleanup because the whole gid table is new code and
> >has latent elements for rocev2 - this is why it is so much bigger than
> >it should be.
> 
> I disagree. Could you please point on anything that is RoCE V2 specific?
> The essence of RoCE V2 in the previous series was the gid_type part.
> This is now completely removed.

Sure gid_type is gone, but I didn't say roceve2 specific, I said
latent elements. ie I'm assuming reasons for the scary locking are
because the ripped out rocev2 code needed it?  And some of the
complexity that looks pointless now was supporting ripped out rocev2
elements? That is not necessarily bad, but the code had better be good
quailty and working..

But then I look at the patches, and the very first locking I test out
looks wrong. I see call_rcu/synchronize_rcu being used without a
single call to rcu_read_lock. So this fails #2 of the RCU review
checklist (Seriously? Why am I catching this?)

I stopped reading at that point.

I think you've got the right basic idea for a cleanup series here. It
is time to buckle down and execute it well. Do an internal mellanox
kernel team review of this series. Audit and fix all the locking,
evaluate the code growth and design. Audit to confirm there is no
functional change that is not documented in a commit message. Tell me
v6 is the best effort *team Mellanox* can put forward.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
