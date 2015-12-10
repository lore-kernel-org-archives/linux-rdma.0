From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] staging/rdma/hfi1: Fix for module parameter
 hdrq_entsize when it's 0
Date: Fri, 11 Dec 2015 09:42:27 +1100
Message-ID: <20151211094227.08afd20d@canb.auug.org.au>
References: <20151210210249.2436.56776.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20151210210249.2436.56776.stgit@phlsvslse11.ph.intel.com>
Sender: linux-next-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Mike,

On Thu, 10 Dec 2015 16:02:49 -0500 Mike Marciniszyn <mike.marciniszyn@intel.com> wrote:
>
> From: Sebastian Sanchez <sebastian.sanchez@intel.com>

linux-nxt doesn't really need to be informed about random changes to
stuff in staging unless it fixes a linux-next specific problem.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
