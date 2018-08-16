From: Selvin Xavier <selvin.xavier@broadcom.com>
Subject: Re: [PATCH] RDMA/bnxt_re: QPLIB: Add and use #define dev_fmt(fmt)
 "QPLIB: " fmt
Date: Thu, 16 Aug 2018 16:00:22 +0530
Message-ID: <CA+sbYW2bHrV_Tx6rMYj1h9f3i_sJ=7zPMDbrfWWx229CNeQc2g@mail.gmail.com>
References: <fe07a1dbe1f6699b4a64444505ae2dbacc2155cc.1533926549.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fe07a1dbe1f6699b4a64444505ae2dbacc2155cc.1533926549.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 11, 2018 at 12:12 AM Joe Perches <joe@perches.com> wrote:
>
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

Thanks for the patch, Joe.

Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
