From: "Suresh Shelvapille" <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: Qperf and APM
Date: Wed, 13 Mar 2013 18:43:53 -0400
Message-ID: <74591EB782934BB7AF174B177BA3BE35@md.baymicrosystems.com>
References: <1358891797-14625-1-git-send-email-sean.hefty@intel.com> <1358891797-14625-2-git-send-email-sean.hefty@intel.com> <1828884A29C6694DAF28B7E6B8A8237368B99D59@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A823736F35600F@ORSMSX101.amr.corp.intel.com> <82EBBE0B04D4427381C29144BE078F2B@md.baymicrosystems.com> <4AF12E8016D2BF46BCDFCE8FAA77A3580394D479@fmsmsx109.amr.corp.intel.com> <58D79FF01489431AB6D87CD4977F2E45@md.baymicrosystems.com> <4AF12E8016D2BF46BCDFCE8FAA77A3580394D4FB@fmsmsx109.amr.corp.intel.com> <8AF67C8E913E4EE49D65CABA83E3DEBF@md.baymicrosystems.com> <4AF12E8016D2BF46BCDFCE8FAA77A3580394F46B@fmsmsx109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A3580394F46B-96pTJSsuoYQd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Luick, Dean'" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dean:

The difference is, you got a BW number where as I don't! So, I don't know whether the test was successful or not. Do you
have a Mellanox dual port card?

Mellanox folks: have you guys tried this on your dual port cards?

Thanks,
Suri

> -----Original Message-----
> From: Luick, Dean [mailto:dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, March 13, 2013 6:25 PM
> To: Suresh Shelvapille; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: Qperf and APM
> 
> Using QLogic dual port HCAs, this works for me when I disable port 1 on the client, server, or both
> while the test is running:
> 
> # qperf <server ipaddr> -ap 2 -t 30 rc_bw
> rc_bw:
> warning: -ap set but not used in test rc_bw
>     bw  =  272 MB/sec
> 
> The warning can be ignored.  Using -ap is equivalent to using -rap and -lap with the same port.
> 
> The "failed to receive results" is qperf saying that once the test finished, the server did not
> contact the client.
> 
> 
> Dean
> 
> > -----Original Message-----
> > From: Suresh Shelvapille [mailto:suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org]
> > Sent: Wednesday, March 06, 2013 4:24 PM
> > To: Luick, Dean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: Qperf and APM
> >
> > I can see the packets going on the alternate path when the first link fails, but
> > at the end of the test, the result is a
> > failure, so I am not sure!
> > I tried this with both '-ap' and "-lap -rap" options. I am assuming they are
> > equivalent.
> >
> > ------------------------------
> > [root]# qperf <server-ipaddr> -ap 2 -t 30 rc_bw
> > rc_bw:
> > warning: -ap set but not used in test rc_bw
> > failed to receive results: timed out
> >
> >
> >
> > -------------------------
> > [root]# qperf <server-ipaddr> -lap 2 -rap 2 -t 30 rc_bw
> > rc_bw:
> > warning: -lap set but not used in test rc_bw
> > warning: -rap set but not used in test rc_bw
> > failed to receive results: timed out
> >
> > thanks,
> > Suri
> >
> > > -----Original Message-----
> > > From: Luick, Dean [mailto:dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> > > Sent: Wednesday, March 06, 2013 3:57 PM
> > > To: Suresh Shelvapille; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Subject: RE: Qperf and APM
> > >
> > > Have you tried ignoring the warning and checking of the alternate port
> > works?  The qperf code looks
> > > to be using the alternate port, but incorrectly fails to mark the argument as
> > used.
> > >
> > > Dean
> > >
> > > > -----Original Message-----
> > > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Suresh Shelvapille
> > > > Sent: Wednesday, March 06, 2013 1:00 PM
> > > > To: Luick, Dean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Subject: RE: Qperf and APM
> > > >
> > > > This is the error I see on the client(the same warning is seen with -lap and
> > -
> > > > rap options):
> > > >
> > > > ------------------------------
> > > > qperf <server-ip-addr> -ap 2 rc_bw
> > > > rc_bw:
> > > > warning: -ap set but not used in test rc_bw
> > > >     bw  =  3.39 GB/sec
> > > >
> > > > > -----Original Message-----
> > > > > From: Luick, Dean [mailto:dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> > > > > Sent: Wednesday, March 06, 2013 1:52 PM
> > > > > To: Suresh Shelvapille; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > Cc: Hefty, Sean
> > > > > Subject: RE: Qperf and APM
> > > > >
> > > > > Hi,
> > > > >
> > > > > Can you be more specific?  What are you running and how is it failing?
> > > > >
> > > > > Thanks,
> > > > > Dean
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > > > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Suresh Shelvapille
> > > > > > Sent: Wednesday, March 06, 2013 9:40 AM
> > > > > > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > Cc: Hefty, Sean
> > > > > > Subject: Qperf and APM
> > > > > >
> > > > > > Folks:
> > > > > > The qperf utility has -ap, -lap, -rap options in support of APM.
> > > > Unfortunately
> > > > > > they don't seem to work. Is there a way
> > > > > > to make this work, or if you have any other ideas on testing failover
> > using
> > > > > > rdma please let me know. I have successfully
> > > > > > used tcp_bw tests for this purpose already.
> > > > > >
> > > > > > Thanks,
> > > > > > Suri
> > > > > >
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in
> > > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-
> > info.html
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
