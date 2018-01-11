From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP information
Date: Thu, 11 Jan 2018 09:17:56 -0600
Message-ID: <00d901d38aef$5b993360$12cb9a20$@opengridcomputing.com>
References: <20180102081832.5264-1-leon@kernel.org> <20180102081832.5264-8-leon@kernel.org> <20180109200917.GF4518@ziepe.ca> <20180110071722.GF7368@mtr-leonro.local> <20180110225622.GQ4518@ziepe.ca> <016201d38a6a$ca49d880$5edd8980$@opengridcomputing.com> <20180111054141.GM7368@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111054141.GM7368-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > >
> > > > I personally have no plans to fix CMA netlink code and for my
opinion it
> > > > should be removed, instead of beating that dead horse.
> > >
> > > What is so wrong with it you can't use it anyhow?
> > >
> >
> > We certainly need to be able to get detailed cm_id information.  At
least
> > cm_id bound device, cm_id state, port num, qp-id associated with this
cm_id,
> > and src/dst ipaddrs/ports.  However, it could be fetched and added to qp
> > attributes.  Ala iw_cxgb4's debugfs "qps" file:
> >
> > [root@stevo3 stevo]# cat /sys/kernel/debug/iw_cxgb4/0000\:04\:00.4/qps
> > rc qp sq id 1136 rq id 1137 state 1 onchip 0 ep tid 12028 state 7
> > 172.16.4.3:58725/58725->172.16.4.4:7174/7174
> >
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> It can be one option, another is to add new RDMA_RESTRACK_CMA object and
> expose all relevant information with rdmatool, e.g. "rdma resoruce cma
link
> cxgb4/1".
> 

I like the idea of RDMA_RESTRACK_CMA.  I think cm_id's are important objects
like qps, cqs, pds, and mrs.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
