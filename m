From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] RDMA/bnxt_re: remove redundant initialization of rc to
 zero
Date: Fri, 17 Feb 2017 18:59:34 +0300
Message-ID: <20170217155934.GE4108@mwanda>
References: <20170217153522.30988-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170217153522.30988-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

drivers/infiniband/hw/bnxt_re/ib_verbs.c
  2817  int bnxt_re_dereg_mr(struct ib_mr *ib_mr)
  2818  {
  2819          struct bnxt_re_mr *mr = container_of(ib_mr, struct bnxt_re_mr, ib_mr);
  2820          struct bnxt_re_dev *rdev = mr->rdev;
  2821          int rc = 0;

It's weird that it would complain about this because initializing
variables to bogus values is a prefered style for some people.  It's
bad style obviously, yes, but it's common and it seems like it would
lead to a lot of false postives.

  2822  
  2823          if (mr->npages && mr->pages) {
  2824                  rc = bnxt_qplib_free_fast_reg_page_list(&rdev->qplib_res,
  2825                                                          &mr->qplib_frpl);

And then it doesn't complain about this one which seems like a legit
bug.

  2826                  kfree(mr->pages);
  2827                  mr->npages = 0;
  2828                  mr->pages = NULL;
  2829          }
  2830          rc = bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
  2831  
  2832          if (!IS_ERR(mr->ib_umem) && mr->ib_umem)
  2833                  ib_umem_release(mr->ib_umem);
  2834  
  2835          kfree(mr);
  2836          atomic_dec(&rdev->mr_count);
  2837          return rc;
  2838  }

regards,
dan carpenter
