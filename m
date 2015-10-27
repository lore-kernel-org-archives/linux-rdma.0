From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 23/23] staging/rdma/hfi1: Update driver version string
 to 0.9-294
Date: Wed, 28 Oct 2015 06:15:37 +0900
Message-ID: <20151027211537.GB18879@kroah.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
 <1445869729-7507-24-git-send-email-ira.weiny@intel.com>
 <20151027084641.GA16795@kroah.com>
 <20151027210021.GC32118@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151027210021.GC32118@phlsvsds.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "ira.weiny" <ira.weiny@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, dledford@redhat.com, Jubin John <jubin.john@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 05:00:22PM -0400, ira.weiny wrote:
> On Tue, Oct 27, 2015 at 05:46:41PM +0900, Greg KH wrote:
> > On Mon, Oct 26, 2015 at 10:28:49AM -0400, ira.weiny@intel.com wrote:
> > > From: Jubin John <jubin.john@intel.com>
> > > 
> > > Signed-off-by: Jubin John <jubin.john@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > ---
> > >  drivers/staging/rdma/hfi1/common.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
> > > index 7809093eb55e..5dd92720faae 100644
> > > --- a/drivers/staging/rdma/hfi1/common.h
> > > +++ b/drivers/staging/rdma/hfi1/common.h
> > > @@ -205,7 +205,7 @@
> > >   * to the driver itself, not the software interfaces it supports.
> > >   */
> > >  #ifndef HFI1_DRIVER_VERSION_BASE
> > > -#define HFI1_DRIVER_VERSION_BASE "0.9-248"
> > > +#define HFI1_DRIVER_VERSION_BASE "0.9-294"
> > 
> > Patches like this make no sense at all, please drop it and only use the
> > kernel version.
> 
> What do you mean by "only use the kernel version"?  Do you mean
> 
> #define HFI1_DRIVER_VERSION_BASE UTS_RELEASE
>      
> Or just remove the macro entirely?

Remove it entirely, it's pointless and makes no sense for in-kernel
code.

> > Trust me, it's going to get messy really fast (hint, it
> > already did...)
> 
> Did I base this on the wrong tree?  Not sure how this could have messed you up.

Nope, the patch applied just fine, but think about it, I didn't take all
of the patches you sent me, so what exactly does that version number now
represent?  Hint, absolutely nothing, or even worse, something
completely wrong :)

thanks,

greg k-h
