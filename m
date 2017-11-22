From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: QPN re-use?  was RE: rstream application
Date: Wed, 22 Nov 2017 17:34:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB1AD065@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB1AC922@ORSMSX109.amr.corp.intel.com>
 <CY1PR0701MB201272A9D57012EB34E9E08188200@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB201272A9D57012EB34E9E08188200-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks, Sean. This makes sense. So are you suggesting and additional
> API between CM And driver to notify when a QPN can be re-used ?

This was what I was suggesting, but the point you make below may mean that it won't help that much.  :/

> Just to emphasize though, the problem could still occur if on client
> side the QPN is released After timewait, but timewait didn't pass on
> server-side. (this is similar to the case here, The QPN re-use was
> on the client side, where the connection was no longer in time-wait,
> but Existed in the server side remote-qp tables ).

IMO, the best solution is for drivers to cycle through qpn space before attempting to re-use any.  Otherwise, this problem is more likely to occur.

I can't easily think of a great alternative.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
