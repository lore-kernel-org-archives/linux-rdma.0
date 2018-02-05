From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 13:35:26 -0600
Message-ID: <024401d39eb8$78c89a20$6a59ce60$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <20180201084944.GH2055@mtr-leonro.local> <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com> <20180204150553.GH27780@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > > > @@ -1786,9 +1793,10 @@ static struct rdma_id_private
> > > > *cma_new_conn_id(struct rdma_cm_id *listen_id,
> > > > >  		ib_event->param.req_rcvd.primary_path->service_id;
> > > > >  	int ret;
> > > > >
> > > > > -	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
> > > > > +	id = __rdma_create_id(listen_id->route.addr.dev_addr.net,
> > > > >  			    listen_id->event_handler,
listen_id->context,
> > > > > -			    listen_id->ps,
> > > ib_event->param.req_rcvd.qp_type);
> > > > > +			    listen_id->ps, ib_event-
> >param.req_rcvd.qp_type,
> > > > > +			    listen_id->caller);
> > > >
> > > > I think the cleanest way will be to create some struct and pass
pointer to
> > > it so
> > > > you can unfold all relevant data inside of __rdma_create_id().
> > > >
> > >
> > > Why is that cleaner?  Marshall up the data into a struct, pass a ptr,
> > > unmarshall it all...
> >
> > I counted 6 arguments, and for me, it smells like something wrong.
> >
> 
> I'll look into changing this.
> 

Changing this will force changing all the applications using
rdma_create_id().  I'd rather not do that as part of this series.  It
dilutes the subject of the series.

Does anyone else care either way? 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
