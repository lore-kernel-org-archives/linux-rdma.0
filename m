From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] ib_uverbs: Support for kernel implementation of XRC
Date: Fri, 02 Sep 2016 09:55:54 +0200
Message-ID: <1472802954.3975.22.camel@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
         <1472774969-18997-9-git-send-email-knut.omang@oracle.com>
         <20160902021640.GD30057@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902021640.GD30057-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-01 at 20:16 -0600, Jason Gunthorpe wrote:
> On Fri, Sep 02, 2016 at 02:09:28AM +0200, Knut Omang wrote:
> 
> > +++ b/include/uapi/rdma/ib_user_verbs.h
> > @@ -725,6 +725,8 @@ struct ib_uverbs_send_wr {
> >  			__u32 reserved;
> >  		} ud;
> >  	} wr;
> > +	__u32 xrc_remote_srq_num;
> > +	__u32 reserved;
> >  };
> 
> Hum, how does compat work here? Isn't send_wr usually an array?

Thanks for pointing that out - you are quite right - this has the same issue as
the other 32 bit padding addition.

As the two patch set stands, both libibverbs and the kernel needs to be updated 
at the same time due to these end alignment issues.

Can we agree on that the patch itself is necessary to support vendor specific
extensions, and that the misaligment I fix here is a bug fix?

Then people can continue to evaluate the patch set assuming 
I can propose a solution to the  

old libibverbs - new kernel or
new libiverbs, old kernel

situations?

Thanks for the reviews!
Knut

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
