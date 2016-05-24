From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Tue, 24 May 2016 20:29:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB050188@ORSMSX109.amr.corp.intel.com>
References: <20160521162301.GA16770@phlsvsds.ph.intel.com>
 <20160522120129.GC25500@leon.nu>
 <20160522140351.GA10696@phlsvsds.ph.intel.com>
 <20160522175715.GD25500@leon.nu>
 <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
 <b9dc4ac8-cfa2-d66e-7e36-f28116f23e59@redhat.com>
 <20160524175409.GI25500@leon.nu>
 <a4477030-c966-636e-e395-96857454c7de@redhat.com>
 <20160524201317.GK25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524201317.GK25500-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Let's assume that you are planning to provide block of 20 ioctls per
> device. Right now, there are 10 (or 8 if we count driver families) drivers in
> drivers/infiniband/hw/ + 1 is coming (HSI) + uverbs (approximately 40)
> => 8 * 20 + 20 + 40 = 220 ioctls => we already in shortage without room
> to expansion.

Ioctl commands are naturally scoped per open file.  Unless the opened file supports ioctls directed to every piece of hardware, I don't see why there's an obsession with command space.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
