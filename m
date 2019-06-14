From: Colin Ian King <colin.king@canonical.com>
Subject: re: RDMA: Clean destroy CQ in drivers do not return errors
Date: Fri, 14 Jun 2019 14:59:32 +0100
Message-ID: <68d62660-902c-ca49-20fd-32e92830faa7@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, Gal Pressman <galpress@amazon.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Static analysis with Coverity reported an issue with the following commit:

commit a52c8e2469c30cf7ac453d624aed9c168b23d1af
Author: Leon Romanovsky <leonro@mellanox.com>
Date:   Tue May 28 14:37:28 2019 +0300

    RDMA: Clean destroy CQ in drivers do not return errors

In function bnxt_re_destroy_cq() contains the following:

        if (!cq->umem)
                ib_umem_release(cq->umem);

Coverity detects this as a deference after null check on the null
pointer cq->umem:

"var_deref_model: Passing null pointer cq->umem to ib_umem_release,
which dereferences it"

Is the logic inverted on that null check?

Colin
