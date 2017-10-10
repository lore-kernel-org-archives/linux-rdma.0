From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core] iwpmd: Return existing mapping if port reused on active side
Date: Tue, 10 Oct 2017 12:24:19 -0500
Message-ID: <039901d341ec$9b4d2d50$d1e787f0$@opengridcomputing.com>
References: <20171008233429.16348-1-tatyana.e.nikolova@intel.com> <20171010171017.GF2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010171017.GF2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Tatyana Nikolova' <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ram Amrani' <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Sun, Oct 08, 2017 at 06:34:28PM -0500, Tatyana Nikolova wrote:
> > From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Port-mapper returns a duplicate mapping error and no
> > mapped port if an attempt is made to add a mapping for
> > a new connection which re-uses the local port on active side.
> > Fix this by finding the existing  mapping for the re-used
> > local port and return the mapped port. Also, change ref_cnt
> > in struct iwpm_port to be atomic and use it to track the
> > references to a mapping.
> >
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  iwpmd/iwarp_pm.h        |  5 ++---
> >  iwpmd/iwarp_pm_helper.c | 27 ++++-----------------------
> >  iwpmd/iwarp_pm_server.c | 47
+++++++++++++++++++++--------------------------
> >  3 files changed, 27 insertions(+), 52 deletions(-)
> >
> 
> Any feedback from iWARP crowd?
> 

Yes.

How is a new connection re-using the local port exactly?  Is there a test case
that reproduces this?

Other than that, 

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
