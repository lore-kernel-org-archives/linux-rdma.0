From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH][rdma-next] RDMA/hns: remove redundant assignment to
 variable j
Date: Fri, 29 Sep 2017 11:27:54 -0400
Message-ID: <1506698874.2919.21.camel@redhat.com>
References: <20170929135227.8343-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170929135227.8343-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-29 at 14:52 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable j is being assigned to loop_j and then later being
> assigned to a new value in for loops. The first initialization
> is therefore redundant and can be removed.
> 
> Cleans up clang warning:
> warning: Value stored to 'j' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
