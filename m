From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/hns: Fix an error code in
 hns_roce_v2_init_eq_table()
Date: Tue, 11 Sep 2018 10:03:12 -0600
Message-ID: <20180911160312.GA23697@ziepe.ca>
References: <20180910083511.egoljxb5rr3do6ue@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180910083511.egoljxb5rr3do6ue@kili.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 10, 2018 at 11:35:11AM +0300, Dan Carpenter wrote:
> The error code isn't set on this path.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to for-next, thanks

Jason
