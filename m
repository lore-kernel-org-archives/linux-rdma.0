From: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Subject: Re: Upstream support for multicast IBoE
Date: Tue, 24 Jan 2012 09:11:05 -0600
Message-ID: <20120124151105.GA2178@BohrerMBP.rgmadvisors.com>
References: <20111122223812.GB2131@BohrerMBP.rgmadvisors.com>
 <CAL1RGDVF5FuVuToN56pmue1cUvHRw9kjaKC9xLOt51zeDJwMag@mail.gmail.com>
 <CAJZOPZ+mdMYqMZKYNmVas=cAUYiQRw_r=8ty7j5wB2mXJSs5bw@mail.gmail.com>
 <20120111145924.GA2296@BohrerMBP.rgmadvisors.com>
 <CAJZOPZJL11-psmSEwUz2xa4eK4sFEkuYA5D9oEKD7m6P+O6Ffw@mail.gmail.com>
 <20120112170157.GA2324@BohrerMBP.rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120112170157.GA2324-uiVi7NQFpn/F3E+8IioSZGvqpqeGGIMLAL8bYrjMMd8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

On Thu, Jan 12, 2012 at 11:01:58AM -0600, Shawn Bohrer wrote:
> On Wed, Jan 11, 2012 at 09:49:25PM +0200, Or Gerlitz wrote:
> > Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org> wrote:
> > > Is there any estimate on when we might see something like this upstream?
> > 
> > Could you elaborate a little on your use case for multicast IBoE
> > traffic? e.g how the setup looks like and how are your Ethernet
> > switches act to route that traffic.
> 
> I'm not sure exactly what you are asking here.  We do what I would
> imagine is a typical one to many UD multicast.  We code directly to
> libibvers and librdmacm, and everything is sent IBoE.
> 
> The hosts are in a spine/leaf configuration and all traffic is sent
> over vlans.  My understanding is that the multicast IBoE traffic is
> simply sent as broadcast and that the adapters do the necessary
> filtering.
> 
> Really from my point of view OFED already does what we want, but I
> would really like to see this supported upstream.

Is this something you are working on adding to upstream libibverbs?
I'd be happy to help with testing or whatever else might be needed.

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
