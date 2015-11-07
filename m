From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 5/9] staging/rdma/hfi1: Add function stubs for TID
 caching
Date: Fri, 6 Nov 2015 17:02:35 -0800
Message-ID: <20151107010235.GA24586@kroah.com>
References: <1446245928-12675-1-git-send-email-ira.weiny@intel.com>
 <1446245928-12675-6-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1446245928-12675-6-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: ira.weiny@intel.com
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, dennis.dalessandro@intel.com, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 30, 2015 at 06:58:44PM -0400, ira.weiny@intel.com wrote:
> From: Mitko Haralanov <mitko.haralanov@intel.com>
> 
> Add mmu notify helper functions and TID caching function stubs in preparation
> for the TID caching implementation.
> 
> TID caching makes use of the MMU notifier to allow the driver to respond to the
> user freeing memory which is allocated to the HFI.
> 
> This patch implements the basic MMU notifier functions to insert, find and
> remove buffer pages from memory based on the mmu_notifier being invoked.
> 
> In addition it places stubs in place for the main entry points by follow on
> code.
> 
> Follow up patches will complete the implementation of the interaction with user
> space and makes use of these functions.

This patch adds warnings to the build, which isn't ok, so I've stopped
here in this series and just applied the first 4.  Please fix up and
resend the remaining ones.

thanks,

greg k-h
