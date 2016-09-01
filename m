From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add padding to get proper end alignment
 of ibv_reg_mr_resp
Date: Thu, 01 Sep 2016 11:07:40 +0200
Message-ID: <1472720860.27437.16.camel@oracle.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
         <1472713193-22397-3-git-send-email-knut.omang@oracle.com>
         <6ce4a2f9-64ee-29af-72e8-1c8844436a20@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6ce4a2f9-64ee-29af-72e8-1c8844436a20-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-01 at 11:56 +0300, Yishai Hadas wrote:
> On 9/1/2016 9:59 AM, Knut Omang wrote:
> > 
> > The user/kernel level API requires all parameter blocks to be
> > 64 bit end aligned.
> > 
> > Also clean up some valgrind/memory initialization issues.
> > 
> > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/infiniband/kern-abi.h | 1 +
> >  src/cmd.c                     | 5 ++++-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/infiniband/kern-abi.h
> > b/include/infiniband/kern-abi.h
> > index f70fa44..8bdeef5 100644
> > --- a/include/infiniband/kern-abi.h
> > +++ b/include/infiniband/kern-abi.h
> > @@ -367,6 +367,7 @@ struct ibv_reg_mr_resp {
> >  	__u32 mr_handle;
> >  	__u32 lkey;
> >  	__u32 rkey;
> > +	__u32 reserved;
> >  };
> > 
> >  struct ibv_rereg_mr {
> > diff --git a/src/cmd.c b/src/cmd.c
> > index 12d8640..a418ee1 100644
> > --- a/src/cmd.c
> > +++ b/src/cmd.c
> > @@ -1470,6 +1470,7 @@ int ibv_cmd_create_ah_ex(struct ibv_pd *pd,
> > struct ibv_ah *ah, struct ibv_ah_att
> >  	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_AH, resp,
> > resp_size);
> >  	cmd->user_handle            = (uintptr_t) ah;
> >  	cmd->pd_handle              = pd->handle;
> > +	cmd->reserved               = 0;
> >  	cmd->attr.dlid              = attr->dlid;
> >  	cmd->attr.sl                = attr->sl;
> >  	cmd->attr.src_path_bits     = attr->src_path_bits;
> > @@ -1480,12 +1481,14 @@ int ibv_cmd_create_ah_ex(struct ibv_pd *pd,
> > struct ibv_ah *ah, struct ibv_ah_att
> >  	cmd->attr.grh.sgid_index    = attr->grh.sgid_index;
> >  	cmd->attr.grh.hop_limit     = attr->grh.hop_limit;
> >  	cmd->attr.grh.traffic_class = attr->grh.traffic_class;
> > +	cmd->attr.grh.reserved      = 0;
> > +	cmd->attr.reserved          = 0;
> How those changes relate to this patch's subject ? seems that those
> and 
> below relate to previous ibv_cmd_create_ah_ex patch.

These are fixing valgrind complaints in the original code, but because
that code got rewritten by the previous patch, it might look that way.

The initial idea was that this whole patch fixes trivial bugs/issues in
the current libibverbs, while the other two provides new functionality.
I can split this out as a separate patch for the valgrind part, if
necessary.

Knut

> 
> > 
> >  	memcpy(cmd->attr.grh.dgid, attr->grh.dgid.raw, 16);
> > 
> >  	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
> >  		return errno;
> > 
> > -	(void) VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
> > +	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
> > 
> >  	ah->handle  = resp->handle;
> >  	ah->context = pd->context;
> > 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
