From: "Suresh Shelvapille" <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: Qperf and APM
Date: Wed, 6 Mar 2013 13:59:38 -0500
Message-ID: <58D79FF01489431AB6D87CD4977F2E45@md.baymicrosystems.com>
References: <1358891797-14625-1-git-send-email-sean.hefty@intel.com> <1358891797-14625-2-git-send-email-sean.hefty@intel.com> <1828884A29C6694DAF28B7E6B8A8237368B99D59@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A823736F35600F@ORSMSX101.amr.corp.intel.com> <82EBBE0B04D4427381C29144BE078F2B@md.baymicrosystems.com> <4AF12E8016D2BF46BCDFCE8FAA77A3580394D479@fmsmsx109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A3580394D479-96pTJSsuoYQd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Luick, Dean'" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is the error I see on the client(the same warning is seen with -lap and -rap options):

------------------------------
qperf <server-ip-addr> -ap 2 rc_bw
rc_bw:
warning: -ap set but not used in test rc_bw
    bw  =  3.39 GB/sec

> -----Original Message-----
> From: Luick, Dean [mailto:dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, March 06, 2013 1:52 PM
> To: Suresh Shelvapille; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Hefty, Sean
> Subject: RE: Qperf and APM
> 
> Hi,
> 
> Can you be more specific?  What are you running and how is it failing?
> 
> Thanks,
> Dean
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Suresh Shelvapille
> > Sent: Wednesday, March 06, 2013 9:40 AM
> > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Hefty, Sean
> > Subject: Qperf and APM
> >
> > Folks:
> > The qperf utility has -ap, -lap, -rap options in support of APM. Unfortunately
> > they don't seem to work. Is there a way
> > to make this work, or if you have any other ideas on testing failover using
> > rdma please let me know. I have successfully
> > used tcp_bw tests for this purpose already.
> >
> > Thanks,
> > Suri
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
