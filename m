From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Wed, 18 Nov 2015 06:10:23 -0800
Message-ID: <20151118141023.GA10198@infradead.org>
References: <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com>
 <564AF929.60209@dev.mellanox.co.il>
 <564AFB93.9010602@mellanox.com>
 <564B00C3.1030506@dev.mellanox.co.il>
 <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
 <564C6347.3040501@dev.mellanox.co.il>
 <CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
 <20151118135237.GA3214@infradead.org>
 <CAJ3xEMiBwowDFPEVqjKr-DMeDiWih8qbwshP2QbaH_56aNsRDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiBwowDFPEVqjKr-DMeDiWih8qbwshP2QbaH_56aNsRDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 18, 2015 at 03:58:48PM +0200, Or Gerlitz wrote:
> > Fortunately neither the iSER target or initiator ever support the
> > nightmare called bidi commands,
> 
> I honestly don't know why you call it nightmare nor what make you
> make that strong assertion. 

Beause I actually had to deal with block layer code implementing the
bidi semantics.

> I checked with Alex N. the TGT iser
> transport author and he confirmed to me that bidi's worked on TGT,
> as for the Linux upstream initiator, I thought that was the case too, but
> I never saw it my eyes, and Pete's paper states he had to change the code,
> so on that I can't be sure.

No need to trust words, we have git.  There was absolutely nothing
relating to bidi in either the initial iSER checking nor in the
changelogs since, and neither has the initial BIDI checking touched
iSER.

> that's beyond the scope of this thread, I guess..

As is iSER BIDI suppport.  Let's thank Sagi for doing a very important
performance feature for iSER instead of having this endless discussion
about a pointless fringe feature!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
