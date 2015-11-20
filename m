From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 10:58:41 -0500
Message-ID: <20151120155840.GB31037@phlsvsds.ph.intel.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com> <564F3F1C.4020508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <564F3F1C.4020508@redhat.com>
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
Cc: linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 10:41:16AM -0500, Doug Ledford wrote:
> On 11/19/2015 05:23 PM, Dennis Dalessandro wrote:
> > On Thu, Nov 12, 2015 at 04:13:18PM -0500, Dennis Dalessandro wrote:
> >> The major todo for the hfi1 driver in staging is getting rid of the
> >> verbs code duplication between ipath, qib, and now hfi1. The ipath
> >> driver has been deprecated and is going to be deleted soon. So that
> >> leaves qib and hfi. To address this we have proposed rdmavt which will
> >> be a common kmod that provides software RDMA verbs support. qib and
> >> hfi1 will both use this as well as other forthcoming drivers such as
> >> soft-roce. See this thread for some details:
> >> http://www.spinics.net/lists/linux-rdma/msg29922.html.
> >>
> >> Since that initial RFC we have been accumulating patches in a GitHub
> >> repo for an early look at the development. At some point soon we want
> >> to actually start posting the patches to the mailing list. This is
> >> where it gets tricky.  The code basically not only adds a new driver
> >> but it modifies two existing ones, heavily. To make it more murky one
> >> driver is in staging the other is in the usual drivers/infiniband tree.
> >>
> >> The question is, how do we go about this logistically due to the 2
> >> drivers being in separate sub-trees?
> >>
> >> Greg, Doug,
> >> As the maintainers of the two trees involved we'd kind of like to get
> >> your thoughts on this.
> > 
> > Hi Greg and Doug,
> > 
> > Just wanted to ping you guys again in case my mail last week slipped
> > through the cracks. We are at the point now where we have some patches
> > we can start posting. Looking for some logistical guidance.
> 
> Sorry, I've been out for a while now with the birth of my second child.
>  Things have settled down enough around here that I should be able to
> get things going again (at least well enough to be more responsive to
> email anyway).

Congratulations!

> 
> So, as to the hfi1/qib/rxe transport library.  The qib driver is in the
> rdma tree, and we aren't going to move it to staging just because it
> depends on something in staging, so we need to start adding the library
> in the core tree to avoid dependency issues.  As for the hfi1 driver,
> I'm of the opinion that putting it in staging because of the code
> duplication issue was probably not the right thing to do.  It's
> benefited from the extra eyes on it to help make it a better driver, but
> I think I'm ready to move it to the main RDMA tree and start working on
> it from there where there won't be any cross tree dependency issues.
> 
> To that end, I've opened my 4.4-rc branch and deleted the three
> deprecated drivers from staging and moved hfi1 to the rdma tree.  I've
> sent an email to Linus to see if he's ok taking those changes, and if
> so, I'll get them submitted and then open up my for-4.5 branch early to
> be able to start taking for-next patches.

I agree this is the correct way to go.

However, we have patches which are either in staging-next, staging-testing, or
in flight.

How should we handle those?  I propose.

Greg can ignore the patches in flight.  We have reworks on them anyway.  Those
which just went in to staging-testing can get dropped and we will resubmit
them.

For those which are in staging-next we can submit revert patches to avoid
merge conflicts and resubmit those as well.  This is the item I am not sure
about?

Or is there a better more standard way of handling this?

Ira
