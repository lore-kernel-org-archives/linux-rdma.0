From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Fix for notify send CQ failure messages
Date: Wed, 3 Jan 2018 09:06:48 -0700
Message-ID: <20180103160648.GD11348@ziepe.ca>
References: <20180102210419.26104.32513.stgit@phlsvlogin03.ph.intel.com>
 <20180102212407.GA19027@ziepe.ca>
 <CAAk-MO_ArzS5irkN-_nt_YYL3+YgL+FpM6WLvPZfM-mKexsShg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO_ArzS5irkN-_nt_YYL3+YgL+FpM6WLvPZfM-mKexsShg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 11:33:05AM +0200, Erez Shitrit wrote:
> On Tue, Jan 2, 2018 at 11:24 PM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On Tue, Jan 02, 2018 at 04:04:20PM -0500, Alex Estrin wrote:
> >> If IB_CQ_REPORT_MISSED_EVENTS flag is passed in ib_req_notify_cq()
> >> it may return positive value indicating non-empty CQ.
> >> If return code not verified the log might be flooded with false
> >> warning messages "request notify on send CQ failed".
> >>
> >> Fixes: commit 8966e28d2e40 ("IB/ipoib: Use NAPI in UD/TX flows")
> >
> > Hurm... It was right before that commit as well..
> >
> > Erez, why did you change it?
> 
> I don't think i changed it.

Okay, then it is a typo when you reworked things for NAPI that the >0
case started making warnings. I will apply this patch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
