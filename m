From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] net/mlx5: add a missing tab
Date: Tue, 29 Aug 2017 08:29:26 -0400
Message-ID: <1504009766.52034.26.camel@redhat.com>
References: <20170801110101.mf2i5e2mes4ftmkj@mwanda>
         <1503961787.52034.6.camel@redhat.com>
         <20170829083741.7txp3kvb6se5ek5u@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829083741.7txp3kvb6se5ek5u@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-29 at 12:14 +0300, Dan Carpenter wrote:
> On Mon, Aug 28, 2017 at 07:09:47PM -0400, Doug Ledford wrote:
> > On Tue, 2017-08-01 at 14:01 +0300, Dan Carpenter wrote:
> > > The code works as intended, but the indenting is confusing.
> > > 
> > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > You didn't include netdev on this patch, and I haven't seen a note
> > from
> > janitors that they took it, so I decided to send it on
> > through.  It's
> > minor enough it shouldn't be an issue conflicting with Dave's tree
> > I
> > would think.  I'll know I was wrong if I get yelled at.
> > 
> 
> Ooo...  Wow.  Don't do that.  You're going to get me yelled at too.
> 
> I guess I thought this went through the RDMA tree but looking at it
> now
> it's obvioulsy net.

Fortunately for us, I only pushed this to github last night, so I can
still drop this out of my branch before pushing to k.o.  I'll let you
submit it to the proper place :-)

--- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
