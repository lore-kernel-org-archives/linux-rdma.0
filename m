From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Date: Wed, 16 Dec 2009 09:20:01 -0800
Message-ID: <adaws0m96pq.fsf@roland-alpha.cisco.com>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
	<1260821358.19688.296.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1260821358.19688.296.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Mon, 14 Dec 2009 12:09:18 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > I understand your frustration in having to deal with a large amount
 > of code. If you included all the Mellanox firmware in the mlx4
 > driver, it would be huge too. I'm limited in what I can do given
 > the complexity of the IBTA spec.

Sure, I understand that your driver is going to be pretty big.  However,
ipath was ~38 KLoC, which qib is ~54 KLoC (after the latest cleanup --
it started over 60K if I recall correctly).  That's 40% bigger, 16 KLoC
in absolute terms -- and you dropped support for HT HCAs!

 > QLogic is not "abandoning the ipath driver as unmaintainable".
 > The thought was that trying to incrementally patch in all the changes
 > needed to support dual ports, QDR, chip register addresses, etc.
 > would result in larger patches than renaming the driver. It was a
 > chicken-and-egg problem because until the new code was fully
 > written and debugged, we couldn't post it and we couldn't patch
 > ipath until we knew all the places that needed to be changed.

We can quibble about the reason, but the end effect is that ipath is
abandonded, right?  Maybe a better approach would have been to write a
new driver for the new chip and not try to move the old devices out of
ipath.  But of course it's way too late to start over.

Anyway, we'll get qib in eventually -- but it may take some work.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
