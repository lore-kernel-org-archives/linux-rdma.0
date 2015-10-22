From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 07/22] staging/rdma/hfi1: Fix sparse error in sdma.h
 file
Date: Thu, 22 Oct 2015 13:01:25 +0300
Message-ID: <20151022100125.GK7340@mwanda>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
 <1445307097-8244-8-git-send-email-ira.weiny@intel.com>
 <20151021141231.GJ7340@mwanda>
 <2807E5FD2F6FDA4886F6618EAC48510E1CBCD931@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CBCD931@CRSMSX101.amr.corp.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "Dalessandro,
 Dennis" <dennis.dalessandro@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "Vishwanathapura,
 Niranjana" <niranjana.vishwanathapura@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 04:29:35PM +0000, Weiny, Ira wrote:
> > 
> > On Mon, Oct 19, 2015 at 10:11:22PM -0400, ira.weiny@intel.com wrote:
> > > From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
> > >
> > > Use NULL instead of 0 for pointer argument to fix the sparse error.
> > >
> > > Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > > Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > > Signed-off-by: Niranjana Vishwanathapura
> > > <niranjana.vishwanathapura@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > This should have just been folded in with the previous patch.  Don't introduce
> > problems and fix them in the patchset.
> 
> My bad, I will fix in v3.

I don't think it's worth redoing the patchset over because it's just a
Sparse warning, not a bug.  But for the future.

regards,
dan carpenter
