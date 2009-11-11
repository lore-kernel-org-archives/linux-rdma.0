From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Wed, 11 Nov 2009 15:06:03 -0800
Message-ID: <ada639gvezo.fsf@roland-alpha.cisco.com>
References: <4AF9CACE.8070700@Sun.COM>
	<adaskclvta4.fsf@roland-alpha.cisco.com> <4AFB2EA5.4030804@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AFB2EA5.4030804-UdXhSnd/wVw@public.gmane.org> (David Brean's message of "Wed, 11 Nov
	2009 16:37:41 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > I decided to minimize the impact of an API change on the class of
 > applications that use the current verbs interface because those
 > applications can safely run on platforms that deliver optimal
 > performance using weak ordering for data buffers.  New binaries aren't
 > required for this class of application.
 > 
 > I thought it would be more appropriate to put the burden of added
 > complexity on the class of applications that bypass the verbs to
 > access special features in the hardware.  In fact, those applications
 > are selective about memory regions that need this special handling and
 > would register lots of memory without the "strong ordering' bit.  How
 > applications determine that the platform is capable of performing the
 > request would be beyond the scope of the verbs, however, I suppose
 > that the verbs framework could check and return an error.
 > 
 > If there are applications that expect the hardware to support "strong
 > ordering" and don't check the hardware, then these might be a problem.
 > Do any of these exists?
 > 
 > By the way, if I had proposed this bit several years ago, then I would
 > have chosen a "weak ordering" flag.  Instead, I decided to try
 > protecting the existing base of verbs-based software.

I can't really follow this.  Right now Open MPI et al assume that if
they see a Mellanox adapter, they get the "last byte of RDMA becomes
visible last" behavior.  And there is not a way that I know of to turn
this off at all, let alone get any performance difference.  The
exception being the Cell processor system that started the previous
discussion, where weak ordering at the platform level helped things.

But given that current software does seem to rely on ordering, it seems
that opting into weak ordering would break fewer applications.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
