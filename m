From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 15 Sep 2009 07:57:56 -0700
Message-ID: <ada7hw0gsqz.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <20090915113434.GF1328@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090915113434.GF1328-+ZI9xUNit7I@public.gmane.org> (Pavel Machek's message of "Tue,
	15 Sep 2009 13:34:34 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I don't remember seeing discussion of this on lkml. Yes it  is in
 > -next...

eg http://lkml.org/lkml/2009/7/31/197 and followups, or search for v2
and earlier patches.

 > Basically it allows app to 'trace itself'? ...with interesting mmap()
 > interface, exporting int to userspace, hoping it behaves atomically...? 

Yes, it allows app to trace what the kernel does to memory mappings.  I
don't believe there's any real issue to atomicity of mmap'ed memory,
since userspace really just tests whether read value is == to old read
value or not.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
