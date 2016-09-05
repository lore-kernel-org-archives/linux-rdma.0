From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add new call ibv_cmd_create_ah_ex which
 supports extra parameters
Date: Mon, 05 Sep 2016 16:55:13 +0200
Message-ID: <1473087313.26625.66.camel@oracle.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
         <1472713193-22397-2-git-send-email-knut.omang@oracle.com>
         <09e67035-0c8a-9b44-fa84-08413dd6ac46@dev.mellanox.co.il>
         <1473076411.3975.87.camel@oracle.com>
         <50c8e0ab-f7f4-85b1-09f7-a930ad445ee0@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50c8e0ab-f7f4-85b1-09f7-a930ad445ee0-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-09-05 at 17:05 +0300, Yishai Hadas wrote:
> On 9/5/2016 2:53 PM, Knut Omang wrote:
> > On Thu, 2016-09-01 at 11:34 +0300, Yishai Hadas wrote:
> > > On 9/1/2016 9:59 AM, Knut Omang wrote:
> > > > 
> > > > The original call ibv_cmd_create_ah does not allow vendor specific request or
> > > > response parameters to be defined and passed through to kernel space.
> > > > 
> > > > To keep backward compatibility, introduce a new extended call which accepts
> > > > cmd and resp parameters similar to other parts of the API.
> > > > Reimplement the old call to just use the new extended call.
> > > > 
> > > > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  include/infiniband/driver.h |  4 ++++
> > > >  src/cmd.c                   | 50 +++++++++++++++++++++++++--------------------
> > > >  src/libibverbs.map          |  1 +
> > > >  3 files changed, 33 insertions(+), 22 deletions(-)
> > > > 
> > > > diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
> > > > index 65fa44f..c46c55f 100644
> > > > --- a/include/infiniband/driver.h
> > > > +++ b/include/infiniband/driver.h
> > > > @@ -229,6 +229,10 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
> > > >  			  struct ibv_recv_wr **bad_wr);
> > > >  int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> > > >  		      struct ibv_ah_attr *attr);
> > > > +int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah,
> > > > +			struct ibv_ah_attr *attr,
> > > > +			struct ibv_create_ah *cmd, size_t cmd_size,
> > > > +			struct ibv_create_ah_resp *resp, size_t resp_size);
> > > >  int ibv_cmd_destroy_ah(struct ibv_ah *ah);
> > > >  int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
> > > >  int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
> > > > diff --git a/src/cmd.c b/src/cmd.c
> > > > index cb9e34c..12d8640 100644
> > > > --- a/src/cmd.c
> > > > +++ b/src/cmd.c
> > > > @@ -1463,38 +1463,44 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
> > > >  	return ret;
> > > >  }
> > > > 
> > > > -int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> > > > -		      struct ibv_ah_attr *attr)
> > > > +int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah, struct ibv_ah_attr *attr,
> > > > +			 struct ibv_create_ah *cmd, size_t cmd_size,
> > > > +			 struct ibv_create_ah_resp *resp, size_t resp_size)
> > > >  {
> > > > -	struct ibv_create_ah      cmd;
> > > > -	struct ibv_create_ah_resp resp;
> > > > -
> > > > -	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_AH, &resp, sizeof resp);
> > > > -	cmd.user_handle            = (uintptr_t) ah;
> > > > -	cmd.pd_handle              = pd->handle;
> > > > -	cmd.attr.dlid              = attr->dlid;
> > > > -	cmd.attr.sl                = attr->sl;
> > > > -	cmd.attr.src_path_bits     = attr->src_path_bits;
> > > > -	cmd.attr.static_rate       = attr->static_rate;
> > > > -	cmd.attr.is_global         = attr->is_global;
> > > > -	cmd.attr.port_num          = attr->port_num;
> > > > -	cmd.attr.grh.flow_label    = attr->grh.flow_label;
> > > > -	cmd.attr.grh.sgid_index    = attr->grh.sgid_index;
> > > > -	cmd.attr.grh.hop_limit     = attr->grh.hop_limit;
> > > > -	cmd.attr.grh.traffic_class = attr->grh.traffic_class;
> > > > -	memcpy(cmd.attr.grh.dgid, attr->grh.dgid.raw, 16);
> > > > +	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_AH, resp, resp_size);
> > > You should start with a patch extending the kernel part while supporting
> > > backwards compatibility, later on when patch applied come with a
> > > matching user space patch for a review.
> > > 
> > > In addition, if you supply an extended command you should work with the
> > > extended macros for issuing a command to fully enable future extensions
> > > (e.g IBV_INIT_CMD_RESP_EX_V) and with a specific EX command as done in
> > > other cases (e.g CREATE_QP_EX).
> > 
> > Having looked at the details, I tend to think that what I am adding here is not
> > an extended command, it is more of a fix for a missing feature of
> > the original ibv_cmd_create_ah,
> 
> You want to extend the user->kernel API to get some extra data while 
> maintaining BW compatibility. Usually you need for that an extra command 
> which better be extended from day one. Can it be done in the kernel side 
> without a new command ? 

Yes, as we do not really change the core part of the protocol, we just
makes sure that provider specific fields can be transferred.

> please send pointer to the matching kernel patch.

This is the related patch, which basically allows drivers to make use of
the information sent from user space, by giving the create_ah callback access 
to udata, if available:

https://www.spinics.net/lists/linux-rdma/msg39879.html

> > Maybe I can rename it to ibv_cmd_create_ah_v2 (or v3?) to avoid associating it
> > with the extended command set?
> 
> In case you need a new command, let's add it in an extended mode so that 
> future extensions will use it instead of having later v3/v4, etc.

As I don't need a new command on the kernel side, 
I assume you mean v2 is ok, that way we avoid unnecessary cruft in my opinion.

Thanks,
Knut

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
