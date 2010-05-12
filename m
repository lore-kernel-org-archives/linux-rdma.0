From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 18/52] IB/qib: Add qib_iba7322.c (serdes parameters)
Date: Wed, 12 May 2010 10:22:26 -0700
Message-ID: <alpine.LFD.1.10.1005121021200.350@topaz.mv.qlogic.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com> <20100507000026.3441.87902.stgit@chromite.mv.qlogic.com> <adad3x3xt6q.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.1005110837180.7212@topaz.mv.qlogic.com>
 <adad3x2w1c3.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adad3x2w1c3.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 11 May 2010, Roland Dreier wrote:
|  > Sorry for exposing all the ugliness.  If you see it as a serious issue,
|  > we can try to accelerate the cleanup effort.
| 
| OK.  Yes, I do see this as a serious issue -- getting rid of the bogus
| interface which is exposed as a user-visible interface is very painful
| once we've merged it.  So I would really really prefer to just have the
| good interface upstream.
| 
| We're probably ~1 week away from 2.6.34 final, and the merge window will
| be two weeks after that.  So if you could get some form of this finished
| in the next 3 weeks, that would be the best way to merge qib.

OK.   I'll be working on the redone version, and at this point, expect
to have it ready by this Friday, so either Ralph or I will send it
at that time.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
