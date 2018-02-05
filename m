From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 14:53:23 -0600
Message-ID: <026a01d39ec3$5cc48270$164d8750$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <20180201084944.GH2055@mtr-leonro.local> <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com> <20180204150553.GH27780@mtr-leonro.local> <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com> <20180205200020.GH11446@mellanox.com> <026201d39ebf$d1f087a0$75d196e0$@opengridcomputing.com> <20180205203608.GJ11446@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205203608.GJ11446-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > > For userspace, a tuple of the filehandle and existing the per-file
> > > handle # would make some sense as a unique ID, but userspace is going
> > > to have a pointer not necessarily the handle number :(
> >
> > I'm not following you here.  Who does filehandle/handle# pertain to
rdmatool
> > fetching objects via netlnk and possibly setting them?
> 
> It is the other side of the question - when rdmatool presents me an
> object how do I figure out what it is in 'my world' as userspace.
> 
> Like a PD for instance.. If I have two in a process how do I know
> which is which compared to a dump?

You don't. :)  As it stands now, you can tell only if a given PD is in your
process or not based on the process id.

Even if we create a device-unique ID for each restrack object, to make it
useful to for userspace analysis would require exposing that ID in the
various user object structures (or via query methods).   EG having
pd->res_id, cq->res_id, etc...

Steve. 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
