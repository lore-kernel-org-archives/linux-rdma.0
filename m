From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 1/2] RDMA/CM: move rdma_id_private into include/rdma/rdma_cm.h
Date: Wed, 31 Jan 2018 14:50:23 -0600
Message-ID: <01e801d39ad5$1d7cb520$58761f60$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <a85bb48eb9fc8846c81118a6777ab9ccbd27e9d7.1517418595.git.swise@opengridcomputing.com> <VI1PR0502MB300809BAC31D5CBC0FA2311CD1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300809BAC31D5CBC0FA2311CD1FB0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Steve,
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> > Sent: Tuesday, January 30, 2018 10:59 AM
> > To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Subject: [PATCH RFC 1/2] RDMA/CM: move rdma_id_private into
> > include/rdma/rdma_cm.h
> >
> > So the resource tracking services in core/nldev.c can see useful
information
> > about cm_ids.
> >
> > There are other approaches.  I just moved rdma_id_private to develop
this
> > prototype quickly, and it was simple.  Other approaches include:
> >
> > 1) move the nldev cm_id dumpit functions into cma.c, and have nldev.c
call it.
> > This, however puts a ib_core->rdma_cm module dependency which makes the
> > two modules interdependent in both directions.  Thus, rdma_cm would have
to
> > be merged into ib_core.  This might not be a bad idea with all the
kernel rdma
> > ULPs now using the rdma_cm.
> >
> > 2) move the specific attributes that are being dumped from the
> rdma_id_private
> > struct to the rdma_cm_id struct, so nldev.c has access to them.
> >
> 
> I prefer to see drivers/infiniband/core/cma_priv.h to contain
> rdma_cm_id_private structure.
> This allows not to expose that to ULPs which includes
include/rdma/rdma_cm.h.
> This also includes keeping cm_id state enum within cma_priv.h.
> Core files include this new cma_priv.h.
> 
> This approach is similar to core_priv.h where structures are not place in
> include/rdma/ib_*.h.
> I actually have that cleanup patch as part of other patches that I have
been
> doing.
> But it was not worth enough as stand along patch, so didn't send it.
> But not that this RFC is present, I think it should be done in cma_priv.h.

Hey Parav,  Good idea.  That works for me.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
