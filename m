From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/bnxt_re: QPLIB: Add and use #define dev_fmt(fmt)
 "QPLIB: " fmt
Date: Wed, 5 Sep 2018 15:37:12 -0600
Message-ID: <20180905213712.GA17698@ziepe.ca>
References: <fe07a1dbe1f6699b4a64444505ae2dbacc2155cc.1533926549.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fe07a1dbe1f6699b4a64444505ae2dbacc2155cc.1533926549.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 10, 2018 at 11:42:46AM -0700, Joe Perches wrote:
> Consistently use the "QPLIB: " prefix for dev_<level> logging.
> 
> Miscellanea:
> 
> o Add missing newlines to avoid possible message interleaving
> o Coalesce consecutive dev_<level> uses that emit a message header to
>   avoid < 80 column lengths and mistakenly output on multiple lines
> o Reflow modified lines to use 80 columns where appropriate
> o Consistently use "%s: " where __func__ is output
> o QPLIB: is now always output immediately after the dev_<level> header
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 130 +++++++++++------------------
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  51 ++++++-----
>  drivers/infiniband/hw/bnxt_re/qplib_res.c  |  29 ++++---
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c   |  57 ++++++-------
>  4 files changed, 116 insertions(+), 151 deletions(-)

Applied to for-next, thanks

Jason
