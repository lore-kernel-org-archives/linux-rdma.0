From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/core: Move HFI1 IOCTL declarations to common file
Date: Wed, 17 Aug 2016 14:10:51 -0400
Message-ID: <20160817181050.GC27477@phlsvsds.ph.intel.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org> <1471355123-6227-5-git-send-email-leon@kernel.org> <20160817061630.GB27477@phlsvsds.ph.intel.com> <20160817065529.GG5489@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817065529.GG5489-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 17, 2016 at 09:55:29AM +0300, Leon Romanovsky wrote:
> On Wed, Aug 17, 2016 at 02:16:31AM -0400, ira.weiny wrote:
> > On Tue, Aug 16, 2016 at 04:45:21PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > 
> > > Move HFI1 IOCTL declarations to rdma_user_ioctl.h file.
> > 
> > I have not tried with the patch but I'm 99% sure this will break the PSM2
> > library build which includes hfi1_user.h.
> > 
> > This is one of those things I have pondered in the past.  Most of the rdma
> > libraries don't actually use these definitions directly.  PSM2 does.
> 
> I'm not so convinced about it.
> "#include <rdma/rdma_user_ioctl.h>" was added to hfi1_user.h to share
> all definitions. PSM2 library will see it.

Ok I see it now.  Sorry it was late.

> 
> > 
> > I'm not sure what other libraries do.
> > 
> > In the final patch of this series you admit that the name changes in that patch
> > will break userspace which uses the defines directly.  Can we, should we, do
> > that?
> 
> I'm talking about __NUM() macros.
> 
> Do you really use __NUM(ASSIGN_CTXT) in user application? Why did you do
> it? You supposed to use HFI1_IOCTL_ASSIGN_CTXT instead.

Your commit message says "... and MAD indexes were renamed.  It has the
potential to break application which use these defines directly."

I took that at face value.  I've taken a closer look ... I see now that neither
the numbers nor the define names changed so ok, my mistake.

Ira

> 
> > 
> > To be completely pedantic I think we need to maintain the old names at least
> > for some time.  Perhaps they are best put in an rdma_user_compat_ioctl.h which
> > is included in the final rdma_user_ioctl.h?
> 
> Except __NUM() macro, there is no change in names.
> 
> > 
> > For this patch I think it would be sufficient to include rdma_user_ioctl.h in
> > hfi1_user.h but I would have to double check that.
> 
> It is already done in patches before.
> 
> > 
> > Ira
> > 
> > > 
> > > Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> > >  include/uapi/rdma/hfi/hfi1_user.h   | 55 -------------------------------------
> > >  include/uapi/rdma/rdma_user_ioctl.h | 54 ++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 54 insertions(+), 55 deletions(-)
> > > 
> > > diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
> > > index 8aa3867..8807f06 100644
> > > --- a/include/uapi/rdma/hfi/hfi1_user.h
> > > +++ b/include/uapi/rdma/hfi/hfi1_user.h
> > > @@ -58,7 +58,6 @@
> > >  
> > >  #include <linux/types.h>
> > >  #include <rdma/rdma_user_ioctl.h>
> > > -#include <rdma/hfi/hfi1_ioctl.h>
> > >  
> > >  /*
> > >   * This version number is given to the driver by the user code during
> > > @@ -114,60 +113,6 @@
> > >  #define HFI1_RCVHDR_ENTSIZE_16   (1UL << 1)
> > >  #define HFI1_RCVDHR_ENTSIZE_32   (1UL << 2)
> > >  
> > > -/* User commands. */
> > > -#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */
> > > -#define HFI1_CMD_CTXT_INFO       2	/* find out what resources we got */
> > > -#define HFI1_CMD_USER_INFO       3	/* set up userspace */
> > > -#define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
> > > -#define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
> > > -#define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
> > > -
> > > -#define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
> > > -#define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
> > > -#define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
> > > -#define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
> > > -#define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
> > > -#define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
> > > -#define HFI1_CMD_GET_VERS	 14	/* get the version of the user cdev */
> > > -
> > > -/*
> > > - * User IOCTLs can not go above 128 if they do then see common.h and change the
> > > - * base for the snoop ioctl
> > > - */
> > > -
> > > -/*
> > > - * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
> > > - */
> > > -#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)
> > > -
> > > -struct hfi1_cmd;
> > > -#define HFI1_IOCTL_ASSIGN_CTXT \
> > > -	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
> > > -#define HFI1_IOCTL_CTXT_INFO \
> > > -	_IOW(IB_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
> > > -#define HFI1_IOCTL_USER_INFO \
> > > -	_IOW(IB_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
> > > -#define HFI1_IOCTL_TID_UPDATE \
> > > -	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
> > > -#define HFI1_IOCTL_TID_FREE \
> > > -	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
> > > -#define HFI1_IOCTL_CREDIT_UPD \
> > > -	_IO(IB_IOCTL_MAGIC, __NUM(CREDIT_UPD))
> > > -#define HFI1_IOCTL_RECV_CTRL \
> > > -	_IOW(IB_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
> > > -#define HFI1_IOCTL_POLL_TYPE \
> > > -	_IOW(IB_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
> > > -#define HFI1_IOCTL_ACK_EVENT \
> > > -	_IOW(IB_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
> > > -#define HFI1_IOCTL_SET_PKEY \
> > > -	_IOW(IB_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
> > > -#define HFI1_IOCTL_CTXT_RESET \
> > > -	_IO(IB_IOCTL_MAGIC, __NUM(CTXT_RESET))
> > > -#define HFI1_IOCTL_TID_INVAL_READ \
> > > -	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
> > > -#define HFI1_IOCTL_GET_VERS \
> > > -	_IOR(IB_IOCTL_MAGIC, __NUM(GET_VERS), int)
> > > -
> > >  #define _HFI1_EVENT_FROZEN_BIT         0
> > >  #define _HFI1_EVENT_LINKDOWN_BIT       1
> > >  #define _HFI1_EVENT_LID_CHANGE_BIT     2
> > > diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
> > > index 820bf34..e9a69f0 100644
> > > --- a/include/uapi/rdma/rdma_user_ioctl.h
> > > +++ b/include/uapi/rdma/rdma_user_ioctl.h
> > > @@ -36,6 +36,7 @@
> > >  #include <linux/types.h>
> > >  #include <linux/ioctl.h>
> > >  #include <rdma/ib_user_mad.h>
> > > +#include <rdma/hfi/hfi1_ioctl.h>
> > >  
> > >  /* Documentation/ioctl/ioctl-number.txt */
> > >  #define RDMA_IOCTL_MAGIC		0x1b
> > > @@ -51,4 +52,57 @@
> > >  #define IB_USER_MAD_REGISTER_AGENT2     _IOWR(IB_IOCTL_MAGIC, 4, \
> > >  					      struct ib_user_mad_reg_req2)
> > >  
> > > +/* User commands. */
> > > +#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */
> > > +#define HFI1_CMD_CTXT_INFO       2	/* find out what resources we got */
> > > +#define HFI1_CMD_USER_INFO       3	/* set up userspace */
> > > +#define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
> > > +#define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
> > > +#define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
> > > +
> > > +#define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
> > > +#define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
> > > +#define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
> > > +#define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
> > > +#define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
> > > +#define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
> > > +#define HFI1_CMD_GET_VERS	 14	/* get the version of the user cdev */
> > > +
> > > +/*
> > > + * User IOCTLs can not go above 128 if they do then see common.h and change the
> > > + * base for the snoop ioctl
> > > + */
> > > +
> > > +/*
> > > + * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
> > > + */
> > > +#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)
> > > +
> > > +#define HFI1_IOCTL_ASSIGN_CTXT \
> > > +	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
> > > +#define HFI1_IOCTL_CTXT_INFO \
> > > +	_IOW(IB_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
> > > +#define HFI1_IOCTL_USER_INFO \
> > > +	_IOW(IB_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
> > > +#define HFI1_IOCTL_TID_UPDATE \
> > > +	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
> > > +#define HFI1_IOCTL_TID_FREE \
> > > +	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
> > > +#define HFI1_IOCTL_CREDIT_UPD \
> > > +	_IO(IB_IOCTL_MAGIC, __NUM(CREDIT_UPD))
> > > +#define HFI1_IOCTL_RECV_CTRL \
> > > +	_IOW(IB_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
> > > +#define HFI1_IOCTL_POLL_TYPE \
> > > +	_IOW(IB_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
> > > +#define HFI1_IOCTL_ACK_EVENT \
> > > +	_IOW(IB_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
> > > +#define HFI1_IOCTL_SET_PKEY \
> > > +	_IOW(IB_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
> > > +#define HFI1_IOCTL_CTXT_RESET \
> > > +	_IO(IB_IOCTL_MAGIC, __NUM(CTXT_RESET))
> > > +#define HFI1_IOCTL_TID_INVAL_READ \
> > > +	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
> > > +#define HFI1_IOCTL_GET_VERS \
> > > +	_IOR(IB_IOCTL_MAGIC, __NUM(GET_VERS), int)
> > > +
> > >  #endif /* RDMA_USER_IOCTL_H */
> > > -- 
> > > 2.7.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
