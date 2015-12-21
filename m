From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v2 0/5] Clean up SDMA engine code
Date: Mon, 21 Dec 2015 18:48:03 -0500
Message-ID: <20151221234803.GL3860@phlsvsds.ph.intel.com>
References: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 05:10:08PM -0500, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Various improvements to the SDMA engine code.

Greg,

Thanks for reviewing and accepting our patches to staging-testing.  I apologize
for the conflicts we had between the 3 of us submitting.  However, in
attempting to rework an internal branch to ensure this does not happen again I
believe there were more conflicts than their should have been due to patches
being accepted out of order.

For example, I found the following error in your staging tree below.

This series you applied in the following order which causes a build failure on
the middle commit -- a0d4069.

483119a staging/rdma/hfi1: Unconditionally clean-up SDMA queues
def8228 staging/rdma/hfi1: Convert to use get_user_pages_fast
a0d4069 staging/rdma/hfi1: Add page lock limit check for SDMA requests
faa98b8 staging/rdma/hfi1: Clean-up unnecessary goto statements
6a5464f staging/rdma/hfi1: Detect SDMA transmission error early

The order as submitted was:

staging/rdma/hfi1: Convert to use get_user_pages_fast
staging/rdma/hfi1: Unconditionally clean-up SDMA queues
staging/rdma/hfi1: Clean-up unnecessary goto statements
staging/rdma/hfi1: Detect SDMA transmission error early
staging/rdma/hfi1: Add page lock limit check for SDMA requests



Do I need to resolve this somehow?  Or is this something you resolve while the
patches are in staging-testing?

Is there something we need to do in the cover letter of a patch series to
ensure order?  Perhaps my cover letter implied these were not ordered?  If so,
I again apologize.

Thanks,
Ira

> 
> ---
> Changes from V1:
> 	Fix off by one error in the last patch
> 
> Mitko Haralanov (5):
>   staging/rdma/hfi1: Convert to use get_user_pages_fast
>   staging/rdma/hfi1: Unconditionally clean-up SDMA queues
>   staging/rdma/hfi1: Clean-up unnecessary goto statements
>   staging/rdma/hfi1: Detect SDMA transmission error early
>   staging/rdma/hfi1: Add page lock limit check for SDMA requests
> 
>  drivers/staging/rdma/hfi1/file_ops.c   |  11 +-
>  drivers/staging/rdma/hfi1/hfi.h        |   4 +-
>  drivers/staging/rdma/hfi1/user_pages.c |  97 +++-------
>  drivers/staging/rdma/hfi1/user_sdma.c  | 319 +++++++++++++++++++--------------
>  drivers/staging/rdma/hfi1/user_sdma.h  |   2 +
>  5 files changed, 222 insertions(+), 211 deletions(-)
> 
> -- 
> 1.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
