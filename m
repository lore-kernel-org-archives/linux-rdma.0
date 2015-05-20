From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Wed, 20 May 2015 05:05:06 -0400
Message-ID: <20150520090505.GA19896@phlsvsds.ph.intel.com>
References: <1431975616-23529-4-git-send-email-kaike.wan@intel.com> <555AC36D.5050904@mellanox.com> <3F128C9216C9B84BB6ED23EF16290AFB0CAB243E@CRSMSX101.amr.corp.intel.com> <CAJ3xEMhkpYYtzrsOw=8JQOekpVT6xQC9P2itH3H3oAjjPfWrng@mail.gmail.com> <3F128C9216C9B84BB6ED23EF16290AFB0CAB2677@CRSMSX101.amr.corp.intel.com> <CAJ3xEMj8zmqj_3=ms9CXxrFVmmk7ZHHtcPXGJcAO24n1U_MSiQ@mail.gmail.com> <2807E5FD2F6FDA4886F6618EAC48510E11082B44@CRSMSX101.amr.corp.intel.com> <20150519192141.GS18675@obsidianresearch.com> <20150519192614.GA31717@phlsvsds.ph.intel.com> <20150519192842.GB23612@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150519192842.GB23612-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 01:28:42PM -0600, Jason Gunthorpe wrote:
> On Tue, May 19, 2015 at 03:26:15PM -0400, ira.weiny wrote:
> 
> > The best use case is the desire to have the user space cache issue the query to
> > the SA on behalf of this request, cache the data, and return the response.
> 
> > This means the Netlink timeout needs to be longer than the SA direct timeout.
> 
> By how much?

It depends on the fabric size, SA load, userspace implementation etc.  The last
of which is potentially the most important.

In general I would say we could take SubnetTimeOut + 1 sec as a good starting
point if the userspace implementation were to issue individual PR queries.

If it attempted some sort of bulk update of its cache in anticipation of
additional queries it could be more.  IBSSA for example may detect an epoch
change and download a significant number of PRs when this query occurs.  How
long this takes is a function of that cache and not anything kernel space can
or should know.

> 
> The SA timeout is already huge and has lots of slack, adding another
> timeout without an actual need seems premature..
> 

Define huge?  If I'm doing my math right the max subnet timeout is > 8,000
seconds.  None of the kernel users actually use the subnet timeout and most are
no where near that max, only 9P seems "huge".

iser:
        ret = rdma_resolve_route(cma_id, 1000); <=== 1 second

9P:
#define P9_RDMA_TIMEOUT         30000           /* 30 seconds */

rds:
#define RDS_RDMA_RESOLVE_TIMEOUT_MS     5000 <=== 5 seconds

NFSoRDMA:
#define RDMA_RESOLVE_TIMEOUT    (5000)  /* 5 seconds */

IPoIB:


                ib_sa_path_rec_get(&ipoib_sa_client, priv->ca, priv->port,
                                   &path->pathrec,
                                   IB_SA_PATH_REC_DGID          |
                                   IB_SA_PATH_REC_SGID          |
                                   IB_SA_PATH_REC_NUMB_PATH     |
                                   IB_SA_PATH_REC_TRAFFIC_CLASS |
                                   IB_SA_PATH_REC_PKEY,
1 second ==================>       1000, GFP_ATOMIC,
                                   path_rec_completion,
                                   path, &path->query);

SRP:
        SRP_PATH_REC_TIMEOUT_MS = 1000,   <=== 1 second



The other issue is that each caller in the kernel specifies a different
timeout.  Defining this in 1 central place and allowing user space to control
the policy of that timeout is much better than allowing the kernel clients to
specify the timeout as they do now.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
