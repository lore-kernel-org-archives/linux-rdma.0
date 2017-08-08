From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] IB/core: fix memory leak on ah on error return path
Date: Tue, 8 Aug 2017 14:59:27 +0200
Message-ID: <20170808125927.GK3926@linux-x5ow.site>
References: <20170808101054.13800-1-colin.king@canonical.com>
 <20170808102026.GG3926@linux-x5ow.site>
 <866a49ab-6f7b-4b46-062b-6230e48da725@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <866a49ab-6f7b-4b46-062b-6230e48da725@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 08, 2017 at 11:28:16AM +0100, Colin Ian King wrote:
> I was using the same subject start as the patch that introduced the
> memory leak and touched the same portion of code. I can resend if necessary.

I think having the hns prefix makes it clearer, as the patch doesn't touch IB
core code but hns code. The reference to the patch which introduced the leak
is given byu the fixes line.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
