From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Tue, 24 May 2016 22:08:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05027E@ORSMSX109.amr.corp.intel.com>
References: <20160522140351.GA10696@phlsvsds.ph.intel.com>
 <20160522175715.GD25500@leon.nu>
 <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
 <b9dc4ac8-cfa2-d66e-7e36-f28116f23e59@redhat.com>
 <20160524175409.GI25500@leon.nu>
 <a4477030-c966-636e-e395-96857454c7de@redhat.com>
 <20160524201317.GK25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB050188@ORSMSX109.amr.corp.intel.com>
 <20160524205425.GA7950@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524205425.GA7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Ioctl commands are naturally scoped per open file.  Unless the
> > opened file supports ioctls directed to every piece of hardware, I
> > don't see why there's an obsession with command space.
> 
> The kernel standard is to have ioctl numbers be globally unique, even
> though technically you are right and they are scoped to a file.

I thought the reason behind that was so that an app that sent an ioctl to the wrong file would get an error, rather than unspecified behavior.  If so, collapsing all ioctls to a single command doesn't really solve the issue.  It's kind of like using a write interface instead of an ioctl interface to avoid using ioctls.  :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
