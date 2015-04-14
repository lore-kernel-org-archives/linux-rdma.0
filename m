From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Tue, 14 Apr 2015 13:43:11 -0400
Message-ID: <20150414174311.GA28111@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB5AC.6050101@profitbricks.com> <20150413192701.GA19112@obsidianresearch.com> <20150413194602.GA21467@phlsvsds.ph.intel.com> <20150413200138.GC19112@obsidianresearch.com> <20150414141806.GA7354@phlsvsds.ph.intel.com> <20150414172514.GB7682@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150414172514.GB7682-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 14, 2015 at 11:25:15AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 14, 2015 at 10:18:07AM -0400, ira.weiny wrote:
> 
> > After more thought and reading other opinions, I must agree we should not
> > have cap_foo_dev.
> 
> I looked at it a bit, and I think Sean has also basically said, CM
> does not support certain mixed port combinations. iWarp and IB simply
> cannot be mixed with the current CM and it doesn't look easy to fix
> that. We can fix a few point areas simply, but not all of it.
> 
> So we have to have the _dev tests, only to fill the CM's need and they
> must have the all true/all false/BUG semantics CM demands.
> 
> Verify on register.
> 
> > While the ports in ib_sa and ib_umad probably can be orthogonal the current
> > implementation does not support that and this patch series obscures that a bit.
> 
> Really? Do you see any bugs/missed things? Both were made port
> orthogonal when RoCEE was added, because RoCEE needs that.

They are not completely orthogonal:

A failure to init port 2 ends up ends up "killing" port 1 and releasing the
device associated resources.

static void ib_umad_add_one(struct ib_device *device)
{
...
                if (ib_umad_init_port(device, i, umad_dev,
                                      &umad_dev->port[i - s]))
                        goto err;
...

err:
        while (--i >= s) {
                if (!cap_ib_mad(device, i))
                        continue;

                ib_umad_kill_port(&umad_dev->port[i - s]);
        }

        kobject_put(&umad_dev->kobj);
}

> 
> CM wasn't because RoCEE and IB seem to use almost the same code,
> though I wonder if mixing really works 100%..

The support can (and should) be orthogonal but the implementation is
incomplete.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
