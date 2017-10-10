From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core] iwpmd: Return existing mapping if port reused
 on active side
Date: Tue, 10 Oct 2017 14:34:49 -0500
Message-ID: <20171010193449.GA29720@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171008233429.16348-1-tatyana.e.nikolova@intel.com>
 <20171010171017.GF2106@mtr-leonro.local>
 <039901d341ec$9b4d2d50$d1e787f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <039901d341ec$9b4d2d50$d1e787f0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Tatyana Nikolova' <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ram Amrani' <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 10, 2017 at 12:24:19PM -0500, Steve Wise wrote:
> > 
> > On Sun, Oct 08, 2017 at 06:34:28PM -0500, Tatyana Nikolova wrote:
> > > From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > Port-mapper returns a duplicate mapping error and no
> > > mapped port if an attempt is made to add a mapping for
> > > a new connection which re-uses the local port on active side.
> > > Fix this by finding the existing  mapping for the re-used
> > > local port and return the mapped port. Also, change ref_cnt
> > > in struct iwpm_port to be atomic and use it to track the
> > > references to a mapping.
> > >
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  iwpmd/iwarp_pm.h        |  5 ++---
> > >  iwpmd/iwarp_pm_helper.c | 27 ++++-----------------------
> > >  iwpmd/iwarp_pm_server.c | 47
> +++++++++++++++++++++--------------------------
> > >  3 files changed, 27 insertions(+), 52 deletions(-)
> > >
> > 
> > Any feedback from iWARP crowd?
> > 
> 
> Yes.
> 
> How is a new connection re-using the local port exactly?  Is there a test case
> that reproduces this?
> 
> Other than that, 
> 
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 

Hi Steve,

A new connection can reuse a local port if one of destination port, destination address
or source address differs from an existing connection. 

This optimization for port reuse was added in kernel in 
commit 19b752a19dce ("IB/cma: Allow port reuse for rdma_id")

https://patchwork.kernel.org/patch/9499071/

We saw the port-mapper "duplicate mapping error" during Open MPI scale up testing.

Shiraz


 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
