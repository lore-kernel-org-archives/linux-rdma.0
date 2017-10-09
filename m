From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] infiniband: add MMU dependency for user_mem
Date: Mon, 09 Oct 2017 12:26:36 -0400
Message-ID: <1507566396.46071.40.camel@redhat.com>
References: <20171006071410.732275-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171006071410.732275-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-10-06 at 09:13 +0200, Arnd Bergmann wrote:
> The infiniband subsystem causes a link failure when the umem
> driver is built on MMU-less systems:
> 
> mm/mmu_notifier.o: In function `do_mmu_notifier_register':
> mmu_notifier.c:(.text+0x32): undefined reference to
> `mm_take_all_locks'
> drivers/infiniband/core/umem.o: In function `ib_umem_get':
> umem.c:(.text+0x132): undefined reference to `can_do_mlock'
> drivers/infiniband/core/umem_odp.o: In function
> `ib_umem_odp_map_dma_pages':
> umem_odp.c:(.text+0x766): undefined reference to
> `get_user_pages_remote'
> 
> This bug has existed for a while but only become apparent in ARM
> randconfig builds when the dependency on PCI was lifted, as none
> of the ARM-NOMMU targets support PCI at the moment.
> 
> We could probably get the umem driver to build by providing an
> alternative implementation 'can_do_mlock()' that returns false
> on NOMMU-systems, but then we'd still have a problem with the
> mmu-notifiers required by CONFIG_INFINIBAND_ON_DEMAND_PAGING,
> so simply forbidding umem with NOMMU seems like the simplest
> workaround.
> 
> Fixes: 931bc0d91639 ("IB: Move PCI dependency from root KConfig to
> HW's KConfigs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
