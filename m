From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/8] opensm/complib: define "if" statements with branch
 prediction hints
Date: Tue, 14 Aug 2012 15:54:13 -0600
Message-ID: <20120814215413.GA29245@obsidianresearch.com>
References: <502AC3DC.9090102@mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237346A892A4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A892A4-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 14, 2012 at 09:39:23PM +0000, Hefty, Sean wrote:
> > +#define if_PF(cond)		if(CL_PREDICT_FALSE(cond))
> > +#define if_PT(cond)		if(CL_PREDICT_TRUE(cond))
> 
> If CL_PREDICT_TRUE/FALSE are too long, why not just shorten those,
> rather than abstract if statements behind a macro?

If you are typing these so often (ie more than in some datastructure
kernels) that the length is a problem then you really should be using
profile guided optimization instead...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
