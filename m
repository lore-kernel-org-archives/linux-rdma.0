From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Fri, 31 Jul 2015 12:03:48 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507311147200.13467@east.gentwo.org>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com> <20150630060631.GA21105@infradead.org> <CANjDDBh3pxLFe2o08KzAtw8dtVq94GK04x4YZ0nXA+YnVh5Bng@mail.gmail.com> <20150701072120.GB31381@infradead.org>
 <CANjDDBinTi43KTt14C7cJ0Uo=Do8Vt3G6bXutLbsViUFUG=jRg@mail.gmail.com> <2807E5FD2F6FDA4886F6618EAC48510E110A880D@CRSMSX101.amr.corp.intel.com> <20150703155234.GA6099@infradead.org> <CANjDDBh1C8Hh_MN9P1=N-g9tvwa-GF0h387_SHiE12cNVKfH2Q@mail.gmail.com>
 <20150708080108.GB5668@infradead.org> <559D7FA9.1040200@redhat.com> <20150708200212.GA28030@infradead.org> <alpine.DEB.2.11.1507310930240.12455@east.gentwo.org> <55BB9C03.1030103@redhat.com> <55BBA0D6.3070604@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BBA0D6.3070604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 31 Jul 2015, Doug Ledford wrote:

> > Everyone on that Cc: list (and I note in particular that your name is
> > *not* on that list) has been contacted and gave permission to
> > Avagotech/Emulex to go ahead and change the copyright on the code.  As
> > such, it is their *right* to make that change if they see fit.  There
> > will be no revert, period.
>
> Also, just as a general rule, don't *EVER* come to me trying to assert
> copyright control on code you haven't even donated one line of effort to.

I have not asserted any copyright on the particular files.

But I have extensively contributed to core kernel code for 20 years with
the understanding that the license for the kernel code as a whole is under
the GPL and that others will contribute like I did under the GPL. It
certainly is a surprise to me that someone can change the license of parts
of the kernel to allow non-GPL licensing. Never seen that before.

I will assert that the modifications of the IB stack that I have
contributed over the years (mostly in passes over the kernel to
change functions globally) are under GPL only. In this case you are lucky
that I never touched those files.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
