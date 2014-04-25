From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/cma: Make timeout dependent on the subnet timeout
Date: Fri, 25 Apr 2014 19:47:18 +0200
Message-ID: <535A9FA6.4020207@acm.org>
References: <53566BB5.5030203@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com> <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F32A2@ORSMSX109.amr.corp.intel.com> <5358BF9D.4030409@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373992F4F6E@ORSMSX109.amr.corp.intel.com> <535A8BA6.4090603@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F50A6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373992F50A6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/25/14 18:56, Hefty, Sean wrote:
> Btw, up til now most of the requests regarding CM timeouts has been to
> increase it.  We need to make sure that we don't end up breaking that.
> Even if we set this timeout to 0, the total timeout for a connection
> request is 2 x packet lifetime x # retries.  With a 1 second packet
> lifetime, that's still 30 seconds.  What timeout range are you looking
> for?  The app could always set a separate timer and cancel the request
> as well.

What I had noticed is that with the current timeout settings after a
cable pull it can take really long before a cm_id object reaches
TimeWait exit state. Timeout settings that are between 1/4th and 1/8th
of the current settings result in more reasonable behavior.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
