From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 18/52] IB/qib: Add qib_iba7322.c (serdes parameters)
Date: Tue, 11 May 2010 14:55:08 -0700
Message-ID: <adad3x2w1c3.fsf@roland-alpha.cisco.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
	<20100507000026.3441.87902.stgit@chromite.mv.qlogic.com>
	<adad3x3xt6q.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.1005110837180.7212@topaz.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.1.10.1005110837180.7212-vxnkQ4oxbxUi9g6yJnKVd0EOCMrvLtNR@public.gmane.org> (Dave
	Olson's message of "Tue, 11 May 2010 08:49:12 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I've implemented a newer interface (it's in the same set of patches),
 > but we've not yet converted over the userland.  The new interface is unit
 > and port specific.  It's not separate files per serdes setting, though.
 > 
 > It takes a string with a default (global) index, followed by optional
 > unit and port-specific tuples, like this:
 > 
 > 	10 0,1=8 1,2=7 ...
 > 
 > The newer interface has the values readable as well as writable.
 > 
 > When we had stuff like this in the port-specific directories, people
 > dinged us on it.   We also had people who wanted to be able to set
 > it as a module parameter to modprobe  The newer interface is the
 > cable_atten module parameter, and it just selects an index into a table of
 > parameters in the driver.
 > 
 > The new interface needs to have a table extended a bit more to replace
 > the setup_qme and setup_qmh functions (once again, time constraints for
 > our internal release cycles caused the incomplete implementation).
 > 
 > Sorry for exposing all the ugliness.  If you see it as a serious issue,
 > we can try to accelerate the cleanup effort.

OK.  Yes, I do see this as a serious issue -- getting rid of the bogus
interface which is exposed as a user-visible interface is very painful
once we've merged it.  So I would really really prefer to just have the
good interface upstream.

We're probably ~1 week away from 2.6.34 final, and the merge window will
be two weeks after that.  So if you could get some form of this finished
in the next 3 weeks, that would be the best way to merge qib.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
