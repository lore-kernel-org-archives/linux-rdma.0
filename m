From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] {net,IB}/{rxe,usnic}: Utilize generic mac to eui32
 function
Date: Mon, 6 Mar 2017 13:54:02 +0200
Message-ID: <20170306115401.GA5230@yuval-lap>
References: <1488574145-27179-1-git-send-email-yuval.shaia@oracle.com>
 <20170305074650.GH14379@mtr-leonro.local>
 <20170305081244.GJ14379@mtr-leonro.local>
 <20170305194919.GA2078@yuval-lap>
 <20170306051529.GN14379@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170306051529.GN14379-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > > >
> > > > >  	/*
> > > > >  	 * The zSeries OSA network cards can be shared among various
> > > > > @@ -128,11 +137,8 @@ static inline int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
> > > > >  	if (dev->dev_id) {
> > > > >  		eui[3] = (dev->dev_id >> 8) & 0xFF;
> > > > >  		eui[4] = dev->dev_id & 0xFF;
> > > > > -	} else {
> > > > > -		eui[3] = 0xFF;
> > > > > -		eui[4] = 0xFE;
> > > > > -		eui[0] ^= 2;
> > > >
> > > > Sorry, but NAK.
> > > > You missed the assignment below. In original code it WASN'T for dev->dev_id != NULL, and now it is.
> > >
> > > s/below/above
> >
> > I'm sorry but which assignment is missing? Default values for 0, 3 and 4
> > are set in genaddrconf_ifid_eui48 then override here in case dev->dev_id is
> > set.
> 
> Not really, in original code of addrconf_ifid_eui48(), the eui[0] is set
> conditionally to be "eui[0] ^= 2" or stays without change. In your
> proposed code, eui[0] will be always changed to be "eui[0] ^= 2".

Thanks!
I was confused by the "missing", you should have used "extra assignment" or
even "wrong extra assignment" in your first comment.

Appreciate if you can review v2 which will reset eui[0] to default if
dev_id is used.

> 
> 
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
