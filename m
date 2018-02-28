From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/3] RDMA/iwpm: Delete an error message for a failed
 memory allocation in iwpm_create_nlmsg()
Date: Wed, 28 Feb 2018 14:14:05 -0700
Message-ID: <20180228211405.GB13394@ziepe.ca>
References: <b1df0889-b967-97ae-3a3d-0dde0d7258cd@users.sourceforge.net>
 <ac5f9bdd-4924-2613-f074-0dd285427604@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac5f9bdd-4924-2613-f074-0dd285427604@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Doug Ledford <dledford@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Johannes Berg <johannes.berg@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 27, 2018 at 10:19:05PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 27 Jan 2018 21:48:01 +0100
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>  drivers/infiniband/core/iwpm_util.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

applied to for-next

Jason
