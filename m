From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP information
Date: Wed, 10 Jan 2018 17:28:58 -0600
Message-ID: <016201d38a6a$ca49d880$5edd8980$@opengridcomputing.com>
References: <20180102081832.5264-1-leon@kernel.org> <20180102081832.5264-8-leon@kernel.org> <20180109200917.GF4518@ziepe.ca> <20180110071722.GF7368@mtr-leonro.local> <20180110225622.GQ4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110225622.GQ4518-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Jan 10, 2018 at 09:17:22AM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 09, 2018 at 01:09:17PM -0700, Jason Gunthorpe wrote:
> > > On Tue, Jan 02, 2018 at 10:18:32AM +0200, Leon Romanovsky wrote:
> > >
> > > > +	/* PID == 0 means that this QP was created by kernel */
> > > > +	if (qp->res.pid && nla_put_u32(msg,
> > > > +				       RDMA_NLDEV_ATTR_RES_PID, qp-
> >res.pid))
> > >
> > > This is returning a pid in the init name space, obtained here:
> > >
> > > +		res->pid = task_pid_nr(current);
> > >
> > > And since the netlink user is not running in the init name space this
> > > will return the wrong pid #, and worse potentially pids the current
> > > name space should not see.
> > >
> > > This API also needs to filter the results and only return pids
> > > visible, and translate the pids as well..
> >
> > Correct, PID namespace wasn't taken into account, exactly as it wasn't
> > taken in CMA. So, right now, CMA netlink statistics is returning wrong
> > and unfiltered PIDs. How do you want to progress with that part of the
code?
> 
> It should be fixed or deleted.
> 
> > I personally have no plans to fix CMA netlink code and for my opinion it
> > should be removed, instead of beating that dead horse.
> 
> What is so wrong with it you can't use it anyhow?
> 

We certainly need to be able to get detailed cm_id information.  At least
cm_id bound device, cm_id state, port num, qp-id associated with this cm_id,
and src/dst ipaddrs/ports.  However, it could be fetched and added to qp
attributes.  Ala iw_cxgb4's debugfs "qps" file:

[root@stevo3 stevo]# cat /sys/kernel/debug/iw_cxgb4/0000\:04\:00.4/qps
rc qp sq id 1136 rq id 1137 state 1 onchip 0 ep tid 12028 state 7
172.16.4.3:58725/58725->172.16.4.4:7174/7174
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
