From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB/cma: Make timeout dependent on the subnet timeout
Date: Fri, 25 Apr 2014 16:56:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F50A6@ORSMSX109.amr.corp.intel.com>
References: <53566BB5.5030203@acm.org>
 <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com>
 <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org>
 <1828884A29C6694DAF28B7E6B8A82373992F32A2@ORSMSX109.amr.corp.intel.com>
 <5358BF9D.4030409@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373992F4F6E@ORSMSX109.amr.corp.intel.com>
 <535A8BA6.4090603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <535A8BA6.4090603-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Another possible approach is to make the CM timeout configurable for
> kernel clients only. How about creating two versions of struct
> rdma_conn_param - the existing version for communication between user
> space and kernel and a second version for in-kernel clients only ? In
> that second version a field could be added that allows to specify the CM
> timeout.

A single structure with a new field is sufficient.  A value of 0 could just mean the default.  But the timeout in this instance is per request, with the number of retries set to the max for IB (15).  These are IB specific.  It sounds like you're wanting to limit the total timeout.

Btw, up til now most of the requests regarding CM timeouts has been to increase it.  We need to make sure that we don't end up breaking that.  Even if we set this timeout to 0, the total timeout for a connection request is 2 x packet lifetime x # retries.  With a 1 second packet lifetime, that's still 30 seconds.  What timeout range are you looking for?  The app could always set a separate timer and cancel the request as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
