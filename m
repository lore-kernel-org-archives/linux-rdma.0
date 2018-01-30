From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 16:33:19 -0500
Message-ID: <1517347999.15224.2.camel@redhat.com>
References: <1517256713.27592.241.camel@redhat.com>
         <20180130033436.GA17053@ziepe.ca> <20180130091654.GD2055@mtr-leonro.local>
         <034101d399de$01183730$0348a590$@opengridcomputing.com>
         <20180130155643.GC17053@ziepe.ca>
         <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
         <20180130163330.GE17053@ziepe.ca> <1517339252.2589.34.camel@wdc.com>
         <20180130194639.GJ17053@ziepe.ca> <1517344962.2589.39.camel@wdc.com>
         <20180130204840.GK17053@ziepe.ca> <1517347322.2589.58.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517347322.2589.58.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-01-30 at 21:22 +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 13:48 -0700, Jason Gunthorpe wrote:
> > Ok, I think that is the only likely thing recently..
> > 
> > But your print above must be caused by this line, right:
> > 
> > static struct srp_fr_pool *srp_create_fr_pool(struct ib_device
> > *device,
> >                                               struct ib_pd *pd, int
> > pool_size,
> >                                               int
> > max_page_list_len)
> > {
> >         ret = -ENOMEM;
> >         pool = kzalloc(sizeof(struct srp_fr_pool) +
> >                        pool_size * sizeof(struct srp_fr_desc),
> > GFP_KERNEL);
> >         if (!pool)
> >                 goto err;
> > 
> > Since you didn't report the ib_alloc_mr() print it can't be the
> > other
> > ENOMEM case?
> > 
> > Hard to see how that interesects with resource tracking.. Are you
> > thinking memory corruption?
> 
> Hello Jason,
> 
> I don't see any reason to suspect memory corruption. kmemleak isn't
> reporting
> any memory leaks. Maybe memory fragmentation has increased?
> 
> Thanks,
> 
> Bart.NrybXǧv^)޺{.n+{ٚ{ay
ʇڙ,jfhz
w
j:+vwjmzZ+ݢj"!

Hi Bart, 

Can I take your tree and see if this fails for me too,
Your last tree was fine, so did not have this latest stuff.
Can I just pull to what I have

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
