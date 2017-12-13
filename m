From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [v2] RDMA/iwpm: Fix uninitialized error code in
 iwpm_send_mapinfo()
Date: Wed, 13 Dec 2017 11:19:39 -0700
Message-ID: <20171213181939.GC5984@ziepe.ca>
References: <1511945253-29296-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511945253-29296-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, Roland Dreier <roland@purestorage.com>, Doug Ledford <dledford@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 29, 2017 at 09:47:33AM +0100, Geert Uytterhoeven wrote:
> With gcc-4.1.2:
> 
>     drivers/infiniband/core/iwpm_util.c: In function ‘iwpm_send_mapinfo’:
>     drivers/infiniband/core/iwpm_util.c:647: warning: ‘ret’ may be used uninitialized in this function
> 
> Indeed, if nl_client is not found in any of the scanned has buckets, ret
> will be used uninitialized.
> 
> Preinitialize ret to -EINVAL to fix this.
> 
> Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper user space service")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
> v2:
>   - Use -EINVAL instead of zero,
>   - Move the preinitialization to just before the loop, to catach future
>     early offenders,
>   - Drop RFC state.
>  drivers/infiniband/core/iwpm_util.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks applied to -next.

Jason
