From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] [v2] IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL
 usage
Date: Wed, 27 Sep 2017 09:09:42 -0400
Message-ID: <1506517782.82712.7.camel@redhat.com>
References: <20170906213521.1845893-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170906213521.1845893-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-06 at 23:34 +0200, Arnd Bergmann wrote:
> We get a harmless warning about the fact that we use the result of a
> multiplication as a condition:
> 
> drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_write':
> drivers/infiniband/core/uverbs_main.c:787:40: error: '*' in boolean
> context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/infiniband/core/uverbs_main.c:787:117: error: '*' in boolean
> context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/infiniband/core/uverbs_main.c:790:50: error: '*' in boolean
> context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/infiniband/core/uverbs_main.c:790:151: error: '*' in boolean
> context, suggest '&&' instead [-Werror=int-in-bool-context]
> 
> This avoids the problem by using an inline function in place of
> the macro.
> 
> Fixes: a96e4e2ffe43 ("IB/uverbs: New macro to set pointers to NULL if
> length is 0 in INIT_UDATA()")
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Link: https://patchwork.kernel.org/patch/9940777/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
