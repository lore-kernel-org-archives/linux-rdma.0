From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/{cma, ucma}: Refactor to have
 transport specific checks
Date: Thu, 11 Jan 2018 11:53:04 -0700
Message-ID: <20180111185304.GD1309@ziepe.ca>
References: <20180108150448.29069-1-leon@kernel.org>
 <20180108150448.29069-5-leon@kernel.org>
 <20180110233748.GS4518@ziepe.ca>
 <20180111060537.GO7368@mtr-leonro.local>
 <20180111165622.GB1309@ziepe.ca>
 <20180111185004.GD15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111185004.GD15760-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 08:50:04PM +0200, Leon Romanovsky wrote:
> On Thu, Jan 11, 2018 at 09:56:22AM -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 11, 2018 at 08:05:37AM +0200, Leon Romanovsky wrote:
> >
> > > > If anything should be fixed here, it is to move the degradation closer
> > > > to the actual copy_to_user.
> > > >
> > > > Why was it put here anyhow? I don't see a uapi boundary?
> >
> > Actually, looking again, in the morning, it seems placed OK. This is
> > about as close to the copy_to_user as possible in this flow..
> 
> So, are you going to pick up?

I ment the current code is OK as is and the sa_covert_path is as close
to the copy_to/from_user as it can be.

What is wrong about this patch is moving the uapi translation further from
the uapi boundary. So still dropped.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
