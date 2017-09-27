From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/cxgb3: remove redundant first assignement of sqp
Date: Wed, 27 Sep 2017 09:11:26 -0400
Message-ID: <1506517886.82712.9.camel@redhat.com>
References: <20170911114231.22893-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170911114231.22893-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Steve Wise <swise@chelsio.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-09-11 at 12:42 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> sqp is being initialised when it is being declared and then updated
> a little later on making the first initialization redundant. Clean
> this up by initializing ptr and sqp at their declaration.
> 
> Cleans up warning: "warning: Value stored to 'sqp' during its
> initialization is never read"
> 
> Fixes: a58e58fafdff ("RDMA/cxgb3: Wrap the software send queue
> pointer as needed on flush")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
