From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH 00/23] Update driver to 0.9-294
Date: Mon, 19 Oct 2015 18:16:55 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CBCA641@CRSMSX101.amr.corp.intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
 <20151019165408.GA30921@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151019165408.GA30921@kroah.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "Dalessandro,
 Dennis" <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, Oct 19, 2015 at 12:43:24PM -0400, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> >
> > The following series has bug fixes and updates to the staging hfi1 driver.
> 
> Why are you adding new functionality to this driver before it is moved out of
> drivers/staging/ ?  I _REALLY_ don't like to see that, because it implies that you
> are spending time and energy on new stuff, not fixing up the known issues
> instead.

Perhaps I did not chose my words carefully enough.

The largest issue on the TODO list is the refactoring of the code to be shared between the hfi1 and qib driver.  While the hardware between hfi1 and qib is similar and thus the initial code looked similar, our performance tuning on hfi1 has revealed that some changes will be required to the hfi1 code to fully utilize the hardware.  We would like to get these updates in to make sure that the refactoring work is done properly for the 2 hardware types.

> 
> Please redo this patch series and don't add new stuff.
> 

I can do this but it will cause us to do our refactoring work 2 times in order for it to be done correctly (properly support both hardware types).  Of the 23 patches I sent only one has significant updates which don't conflict with this refactoring work.

[PATCH 15/23] staging/rdma/hfi1: Implement Expected Receive TID caching

However, without this patch users performance will be impacted.

In the interest of full disclosure we still have at least 2 more series, possibly 3 which are similar to this series, bug fixes and performance improvements.

Given the above explanation, would you find it acceptable to take these "updates"?  I can certainly rework patch 15 to separate out the code clean up as per your other email.

Ira
