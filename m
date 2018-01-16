From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Tue, 16 Jan 2018 11:43:49 +0200
Message-ID: <20180116114349.000004c3@dev.mellanox.co.il>
References: <20180112055842.23125-1-leon@kernel.org>
        <20180112170228.GD15974@ziepe.ca>
        <20180114191502.00001940@dev.mellanox.co.il>
        <20180114182256.GA9088@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180114182256.GA9088-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 14 Jan 2018 11:22:56 -0700
Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:

> On Sun, Jan 14, 2018 at 07:15:02PM +0200, jackm wrote:
> > On Fri, 12 Jan 2018 10:02:28 -0700
> > Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> >   
> > > On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> > > 
> > > So, my take on the for-rc8-ness, based on the commit messages
> > > alone:  
> 
> > > > Jack Morgenstein (1):
> > > >   IB/mlx4: Fix incorrectly releasing steerable UD QPs when have
> > > > only ETH ports    
> > > 
> > > No, only supresses an annoying warning  
> > 
> > It does not "suppress" the warning, it fixes the bug which caused
> > the warning to be written in the log.
> > 
> > It is true that at present the annoying (and worrisome) warning in
> > the log is the only problem resulting from this bug  
> 
> Well, that is what I was trying to say.
> 
> > -- but it is still a bug, and needs to be fixed.  
> 
> And it will be fixed, the only question here is if it should be fixed
> in 4.15 or 4.16

Agree for submitting to 4.16 -- this is not a critical fix.
> 
> I think Linus would yell at Doug and I if we sent a patch whose only
> outcome was to remove a warning at this point in the cycle. Does
> anyone know differently?
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
