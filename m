From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [PATCH v2] infiniband: i40iw: fix potential NULL pointer
 dereferences
Date: Mon, 18 Mar 2019 13:56:34 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A75387@fmsmsx124.amr.corp.intel.com>
References: <9DD61F30A802C4429A01CA4200E302A7A5A6FAA8@fmsmsx124.amr.corp.intel.com>
 <20190315065715.18249-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315065715.18249-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>Subject: [PATCH v2] infiniband: i40iw: fix potential NULL pointer dereferences

Something like "RDMA/i40iw: Handle workqueue allocation failure" is a more appropriate subject line. 
>
>alloc_ordered_workqueue may fail and return NULL.
>The fix captures the failure and handles it properly to avoid potential NULL pointer
>dereferences.
>
>Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>---
>V2: add return value to capture the error code
>---
> drivers/infiniband/hw/i40iw/i40iw.h      |  2 +-
> drivers/infiniband/hw/i40iw/i40iw_cm.c   | 19 ++++++++++++++++---
> drivers/infiniband/hw/i40iw/i40iw_main.c |  5 ++++-
> 3 files changed, 21 insertions(+), 5 deletions(-)
>
The patch itself looks ok to me now. Thanks!

Shiraz
