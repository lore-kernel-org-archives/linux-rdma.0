From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/hfi1: constify vm_operations_struct
Date: Mon, 28 Aug 2017 19:17:37 -0400
Message-ID: <1503962257.52034.10.camel@redhat.com>
References: <8fa5bd3197b755de927ef5c3ae431e588a3a7d91.1503894254.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8fa5bd3197b755de927ef5c3ae431e588a3a7d91.1503894254.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-28 at 09:59 +0530, Arvind Yadav wrote:
> vm_operations_struct are not supposed to change at runtime.
> vm_area_struct structure working with const vm_operations_struct.
> So mark the non-const vm_operations_struct structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
