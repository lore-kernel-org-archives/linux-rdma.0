From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/2] IB: add const to bin_attribute structures
Date: Fri, 18 Aug 2017 14:08:14 -0400
Message-ID: <1503079694.2598.34.camel@redhat.com>
References: <1501668090-22662-1-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501668090-22662-1-git-send-email-bhumirks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-02 at 15:31 +0530, Bhumika Goyal wrote:
> Declare bin_attribute structures as const. 
> Done using Coccinelle.
> 
> Bhumika Goyal (2):
>   IB/qib: add const to bin_attribute structures
>   IB/hfi1: add const to bin_attribute structures
> 
>  drivers/infiniband/hw/hfi1/sysfs.c    | 4 ++--
>  drivers/infiniband/hw/qib/qib_sysfs.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Thanks, series applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
