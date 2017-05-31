From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next] Revert "IB/core: Add flow control to the portmapper netlink calls"
Date: Wed, 31 May 2017 12:46:22 -0500
Message-ID: <03c501d2da35$d10a22f0$731e68d0$@opengridcomputing.com>
References: <20170529082423.1180-1-leon@kernel.org> <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com> <20170531040437.GE5406@mtr-leonro.local> <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531174245.GA16304-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Shiraz Saleem' <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Mustafa Ismail' <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > 4. Reverting is a common practice in Linux kernel. Patches are not
> > carved in stones.
> 
> Reverting a patch that's introduced during RC cycle is fine, introducing
> regression is NOT and that is what you are doing by simply proposing to revert
> this patch.  Reverting this patch will introduce a REGRESSION error with
respect to
> port mapping functionality for all iWARP vendors.
> 
> > 5. I proposed a solution -> go and fix your user space program.
> This is a kernel patch you are trying to revert, you are breaking existing
> kernel functionality.  Nothing to do with user space.
> 
> Bottom line, come up with a solution that will address both port mapper
> functionality and your issue.

Hey Leon,

I would hate to introduce an iwarp regression vs solving your issue w/o
reverting.  If I recall, the flow control is need so as to not drop messages
flowing from the kernel to the iwpmd.  I'm not sure how that could be fixed in
the user daemon?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
