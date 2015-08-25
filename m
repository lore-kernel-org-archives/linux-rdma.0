From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/ipoib: Suppress warning for send only join
 failures
Date: Tue, 25 Aug 2015 10:28:56 -0600
Message-ID: <20150825162856.GC4425@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1440200053-18890-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DC66A1.9040207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DC66A1.9040207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 25, 2015 at 08:59:13AM -0400, Hal Rosenstock wrote:
> > -		if (mcast->logcount++ < 20) {
> > -			if (status == -ETIMEDOUT || status == -EAGAIN) {
> > +		bool silent_fail =
> > +		    test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
> > +		    status == -EINVAL;
> 
> Aren't there other reasons that send only join might have EINVAL
> indicated ?

Not sure, the layers below all eat the detailed error code. Hopefully
EINVAL isn't re-used.

> Maybe it's better to be overly silent rather than overly
> verbose as to not spam the log but it seems like it would make debug of
> such cases harder.

It makes debugging harder to have worthless messages because they
obscure what is going on. The first time I saw this I assumed there
was an issue, but it turns out to be an expected failure.

The other issue is the way the rate limiting works:

> > +		if (mcast->logcount < 20) {
> > +			if (status == -ETIMEDOUT || status == -EAGAIN ||
> > +			    silent_fail) {
> >  				ipoib_dbg_mcast(priv, "%smulticast join failed for %pI6, status %d\n",
> >  						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
> >  						mcast->mcmember.mgid.raw, status);

So wasting logcount with expected failures just results in eating
unexpected failures...

> ipoib_dbg_mcast logging is conditionalized on CONFIG_INFINIBAND_IPOIB_DEBUG

Most distros turn this off so the change only impacts people trying to
debug this stuff.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
