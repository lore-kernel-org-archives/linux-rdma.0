From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch] IB/hfi1: checking for NULL instead of IS_ERR
Date: Mon, 21 Sep 2015 09:48:46 -0700
Message-ID: <20150921164846.GB27380@kroah.com>
References: <20150916062220.GC21542@mwanda> <55FC32ED.1000404@redhat.com>
 <20150919030153.GA30373@kroah.com> <56002564.6000100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <56002564.6000100@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 21, 2015 at 11:42:28AM -0400, Doug Ledford wrote:
> On 09/18/2015 11:01 PM, Greg Kroah-Hartman wrote:
> > On Fri, Sep 18, 2015 at 11:51:09AM -0400, Doug Ledford wrote:
> >> On 09/16/2015 02:22 AM, Dan Carpenter wrote:
> >>> __get_txreq() returns an ERR_PTR() but this checks for NULL so it would
> >>> oops on failure.
> >>>
> >>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >>
> >> Thanks, applied.
> > 
> > Applied to what?  Should I just ignore these types of patches and not
> > take them in my tree and you will send them on later on?  I don't
> > remember what we agreed to do, sorry.
> 
> My understanding was that I would handle everything in the staging/rdma
> area.  To that end, I tried to make it explicit so that people would
> know that via the following things:
> 
> From MAINTAINERS:
> 
> INFINIBAND SUBSYSTEM
> M:      Doug Ledford <dledford@redhat.com>
> M:      Sean Hefty <sean.hefty@intel.com>
> M:      Hal Rosenstock <hal.rosenstock@gmail.com>
> L:      linux-rdma@vger.kernel.org
> W:      http://www.openfabrics.org/
> Q:      http://patchwork.kernel.org/project/linux-rdma/list/
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> S:      Supported
> F:      Documentation/infiniband/
> F:      drivers/infiniband/
> F:      drivers/staging/rdma/
> F:      include/uapi/linux/if_infiniband.h
> F:      include/uapi/rdma/
> F:      include/rdma/
> 
> 
> And from drivers/staging/rdma/Kconfig:
> 
> menuconfig STAGING_RDMA
>         bool "RDMA staging drivers"
> 	depends on INFINIBAND
> 	depends on PCI || BROKEN
> 	depends on HAS_IOMEM
> 	depends on NET
> 	depends on INET
>         default n
>         ---help---
>           This option allows you to select a number of RDMA drivers that
> 	  fall into one of two categories: deprecated drivers being held
> 	  here before finally being removed or new drivers that still need
> 	  some work before being moved to the normal RDMA driver area.
> 
>           If you wish to work on these drivers, to help improve them, or
>           to report problems you have with them, please use the
> 	  linux-rdma@vger.kernel.org mailing list.
> 
>           If in doubt, say N here.
> 
> I was hoping those two items would be sufficient to keep people from
> flooding devel@ and yourself personally with fixups for these items and
> instead they would send them through linux-rdma@.

But, that's already not happening, as is obvious by my inbox.

So, how about you forward on what you have so far to me, and I'll keep
these.  Otherwise you will end up with nasty merge issues very quickly
as people will continue to send stuff to me.

thanks,

greg k-h
