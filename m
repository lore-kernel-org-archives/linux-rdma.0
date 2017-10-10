From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core] iwpmd: Return existing mapping if port reused on active side
Date: Tue, 10 Oct 2017 15:19:51 -0500
Message-ID: <040901d34205$20ee3c70$62cab550$@opengridcomputing.com>
References: <20171008233429.16348-1-tatyana.e.nikolova@intel.com> <20171010171017.GF2106@mtr-leonro.local> <039901d341ec$9b4d2d50$d1e787f0$@opengridcomputing.com> <20171010193449.GA29720@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010193449.GA29720-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Shiraz Saleem' <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Tatyana Nikolova' <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ram Amrani' <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >
> > How is a new connection re-using the local port exactly?  Is there a test
case
> > that reproduces this?
> >
> > Other than that,
> >
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> 
> Hi Steve,
> 
> A new connection can reuse a local port if one of destination port,
destination
> address
> or source address differs from an existing connection.
> 
> This optimization for port reuse was added in kernel in
> commit 19b752a19dce ("IB/cma: Allow port reuse for rdma_id")
> 
> https://patchwork.kernel.org/patch/9499071/
> 
> We saw the port-mapper "duplicate mapping error" during Open MPI scale up
> testing.

Ah, I see now.  Thanks!

Steve. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
