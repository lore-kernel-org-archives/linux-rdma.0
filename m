From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] IB/core: fix memory leak on ah on error return path
Date: Tue, 8 Aug 2017 11:28:16 +0100
Message-ID: <866a49ab-6f7b-4b46-062b-6230e48da725@canonical.com>
References: <20170808101054.13800-1-colin.king@canonical.com>
 <20170808102026.GG3926@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170808102026.GG3926@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 08/08/17 11:20, Johannes Thumshirn wrote:
> Shouldn't the subject start with "IB/hns:" given it's touching
> drivers/infiniband/hw/hns/hns_roce_ah.c?

I was using the same subject start as the patch that introduced the
memory leak and touched the same portion of code. I can resend if necessary.

> 
> Byte,
> 	Johannes
> 
