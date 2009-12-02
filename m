From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 39/53] IB/qib: Add qib_trace.c
Date: Wed, 02 Dec 2009 09:52:25 -0800
Message-ID: <adaskbtuuue.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119234021.30356.77098.stgit@chromite.mv.qlogic.com>
	<ada63966oip.fsf@roland-alpha.cisco.com>
	<1259712618.992.637.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1259712618.992.637.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Tue, 01 Dec 2009 16:10:18 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > 1) It requires CONFIG_TRACING to be set which compiles code -pg
 >    so that function prologue code calls mcount. What Linux
 >    distributions will have this configured as the default?

I would assume all relevant distros with a kernel that contains ftrace
will enable this.  It's a pretty fundamental debugging features.  (By
the way, ftrace uses binary patching to NOP out the calls to mcount when
tracing is turned off at runtime, which makes the overhead pretty minimal)

The only stock kernel have at the moment is Fedora 12, and that
definitely has all the ftrace stuff turned on.  I guess you could check
what enterprise kernels do, but I'd be surprised if they turned it off.

 > 2) We have to backport the ftrace code to whatever OFED kernels
 >    will be supported for OFED-1.6 which could be painful.

Backport however your want ... patch back in your own tracing subsystem
if you want.  For upstream I don't think a 1000+ line driver-private
tracing subsystem is acceptable when a better alternative exists
already.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
