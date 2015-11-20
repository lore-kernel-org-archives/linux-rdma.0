From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/9] staging/rdma/hfi1: Add function stubs for TID caching
Date: Thu, 19 Nov 2015 17:06:30 -0800
Message-ID: <20151120010630.GA25032@kroah.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
 <1446244918-12089-6-git-send-email-ira.weiny@intel.com>
 <CAJ3xEMiLz=kgeQhx07WFWtNzcPwy2ZL9fs0SZkSpVd6+reGUVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiLz=kgeQhx07WFWtNzcPwy2ZL9fs0SZkSpVd6+reGUVA@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: devel@driverdev.osuosl.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Mitko Haralanov <mitko.haralanov@intel.com>, Doug Ledford <dledford@redhat.com>, Kamal Heib <kamalh@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2015 at 07:58:54AM +0200, Or Gerlitz wrote:
> On Sat, Oct 31, 2015 at 12:41 AM,  <ira.weiny@intel.com> wrote:
> > From: Mitko Haralanov <mitko.haralanov@intel.com>
> >
> > Add mmu notify helper functions and TID caching function stubs in preparation
> > for the TID caching implementation.
> >
> > TID caching makes use of the MMU notifier to allow the driver to respond to the
> > user freeing memory which is allocated to the HFI.
> >
> > This patch implements the basic MMU notifier functions to insert, find and
> > remove buffer pages from memory based on the mmu_notifier being invoked.
> >
> > In addition it places stubs in place for the main entry points by follow on
> > code.
> >
> > Follow up patches will complete the implementation of the interaction with user
> > space and makes use of these functions.
> 
> So this is an wholy orthogonal mechanism for memory registrations or
> de-registrations vs
> what's supported by the upstream RDMA stack to which this driver
> attempts to be a HW provider, right?
> 
> Ira, Mike - why do that?
> 
> 2. Greg - I read an earlier comment you made that a driver in staging
> need to be 1st
> and most **fixed** with patches such that the TODO items to get it out
> of staging are
> addressed. I see here every day long train of features going into this
> driver, should the
> focus need to be elsewhere, according to the staging guidelines?

I've already complained about this, supposedly these are things that are
needed to get it out of staging...

And yes, you are correct.

thanks,

greg k-h
