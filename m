From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 5 Jun 2015 20:53:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE54EC@ORSMSX109.amr.corp.intel.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
 <20150604201953.GA7227@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB4FD7@CRSMSX101.amr.corp.intel.com>
 <20150605170521.GB7776@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150605170521.GB7776-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yes, I saw Sean's comment, and I am glad we all understand there are
> only 3 callers. And looking at the callers there are only a small
> number of elements being used:
> 
> rdma cm:
>  IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
>                     IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
>                     IB_SA_PATH_REC_REVERSIBLE | IB_SA_PATH_REC_SERVICE_ID;
>  IB_SA_PATH_REC_QOS_CLASS;
>  IB_SA_PATH_REC_TRAFFIC_CLASS
> 
> ipoib:
>                                    IB_SA_PATH_REC_DGID          |
>                                    IB_SA_PATH_REC_SGID          |
>                                    IB_SA_PATH_REC_NUMB_PATH     |
>                                    IB_SA_PATH_REC_TRAFFIC_CLASS |
>                                    IB_SA_PATH_REC_PKEY,
> 
> srp:
>                                                IB_SA_PATH_REC_SERVICE_ID |
>                                                IB_SA_PATH_REC_DGID       |
>                                                IB_SA_PATH_REC_SGID       |
>                                                IB_SA_PATH_REC_NUMB_PATH  |
>                                                IB_SA_PATH_REC_PKEY,
> 
> So, rather than a SA mad in netlink, I'd suggest actually using
> extensible netlink here and define the query cleanly using nested
> attributes:
> 
> RDMA_OP_RESOLVE (request)
>   GIDS
>   SERVICE_ID
>   QOS/TCLASS
>   PKEY
>   QP TYPE (aka reversible)
> 
> RDMA_OP_RESOLVE (reply)
>   IB_PATH
>   IB_PATH
>   IB_PATH

I thought you were asking to move the hook site.  This approach seems reasonable.  We should just need to add a check against the compmask.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
