From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Fix build warnings
Date: Thu, 31 Oct 2013 15:28:59 -0400
Message-ID: <1383247739.2110.7.camel@haswell.thedillows.org>
References: <1383236511-4337-1-git-send-email-ogerlitz@mellanox.com>
	 <1383236511-4337-2-git-send-email-ogerlitz@mellanox.com>
	 <52728D2F.4020301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52728D2F.4020301-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2013-10-31 at 10:02 -0700, Bart Van Assche wrote:
> On 31/10/2013 9:21, Or Gerlitz wrote:
> > --- a/drivers/infiniband/core/sysfs.c
> > +++ b/drivers/infiniband/core/sysfs.c
> > @@ -104,7 +104,7 @@ static ssize_t state_show(struct ib_port *p, struct port_attribute *unused,
> >   		return ret;
> >
> >   	return sprintf(buf, "%d: %s\n", attr.state,
> > -		       attr.state >= 0 && attr.state < ARRAY_SIZE(state_name) ?
> > +		       attr.state < ARRAY_SIZE(state_name) ?
> >   		       state_name[attr.state] : "UNKNOWN");
> >   }

> I agree that removing unused variables is good because it makes source 
> code easier to read. However, removing the "attr.state >= 0" check from 
> state_show() looks dangerous to me. If the type of that variable would 
> ever be changed from unsigned to signed then that would break 
> state_show() in a very subtle way. It could take a long time before such 
> breakage is detected. How about modifying the behavior of W=1 such that 
> it doesn't warn about comparisons that are always true (-Wno-type-limits) ?

We want to know about those comparisons, because they often indicate a
bug -- either in one's thinking, or in the code they've written.
Changing attr.state from unsigned to signed is unlikely to ever happen,
as a massive audit would be needed -- this is not an uncommon pattern in
the kernel.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
