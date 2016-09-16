From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 8/8] ib_uverbs: Support for kernel implementation of
 XRC
Date: Fri, 16 Sep 2016 21:49:09 +0200
Message-ID: <1474055349.20134.39.camel@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
         <88ffb8c9407a71069b52e155dde308a36dfaf247.1474049924.git-series.knut.omang@oracle.com>
         <20160916193102.GB28859@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160916193102.GB28859-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-09-16 at 13:31 -0600, Jason Gunthorpe wrote:
> On Fri, Sep 16, 2016 at 08:31:19PM +0200, Knut Omang wrote:
> > +++ b/include/uapi/rdma/ib_user_verbs.h
> > @@ -725,6 +725,8 @@ struct ib_uverbs_send_wr {
> >  			__u32 reserved;
> >  		} ud;
> >  	} wr;
> > +	__u32 xrc_remote_srq_num;
> > +	__u32 reserved;
> >  };
> 
> You still need to discuss why this is OK...
> 
> Are you doing all this just to be able to use the existing post_send user
> space path in the common code? Is there a kernel XRC user planned?

Yes, with this patch, the SIF user level provider library is able to 
use either kernel verbs or user verbs on a per QP basis. This is a
very useful capability that the verbs API neatly lends itself almost 
completely to, except for this particular missing piece.

> Another approach would be to implement post_send in your driver and
> not rely on this common code path.

I agree this would be possible, but that would have been
to implement a generic feature which seems a natural completion
of what is already in there in provider specific code, something 
I would have thought from other discussions here is considered bad 
practice?

Thanks,
Knut

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
