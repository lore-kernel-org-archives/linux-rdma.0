From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH for-4.3 14/15] qib: Support ib_alloc_mr verb
Date: Fri, 7 Aug 2015 14:47:31 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577AF8F@fmsmsx120.amr.corp.intel.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
 <1438241568-3685-15-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438241568-3685-15-git-send-email-sagig@mellanox.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH for-4.3 14/15] qib: Support ib_alloc_mr verb
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>

This did require repair of the to-be-rebased/for-4.3 branch to
"revert IB/core: Guarantee that a local_dma_lkey is available" and replace with
a corrected version.

Tested-by: Vinit Agnihotri <vinit.abhay.agnihotri@intel.com>
Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
