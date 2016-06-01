From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] IB/hfi1: Fix hard lockup due to not using save/restore
 spin lock
Date: Wed, 1 Jun 2016 16:25:53 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25B27BEA@fmsmsx120.amr.corp.intel.com>
References: <20160601143812.26872.85826.stgit@phlsvslse11.ph.intel.com>
 <20160601154440.GH7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160601154440.GH7477@leon.nu>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "leon@kernel.org" <leon@kernel.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Jun 01, 2016 at 10:38:12AM -0400, Mike Marciniszyn wrote:
> > Upstream commit 7049de65c9e5 into 4.6.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Is it part of the commit message?
> 

Yes per Documentation/stable_kernel_rules.txt:

   --- Option 3 ---

   Send the patch, after verifying that it follows the above rules, to
   stable@vger.kernel.org.  You must note the upstream commit ID in the
   changelog of your submission, as well as the kernel version you wish
   it to be applied to.

Mike
