From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] RDMA/iwpm: Adjustments for three function implementations
Date: Sat, 27 Jan 2018 22:17:59 +0100
Message-ID: <b1df0889-b967-97ae-3a3d-0dde0d7258cd@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Doug Ledford <dledford@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jan 2018 22:12:34 +0100

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in iwpm_create_nlmsg()
  Adjust a variable initialisation in iwpm_create_nlmsg()
  Improve a size determination in two functions

 drivers/infiniband/core/iwpm_util.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

-- 
2.16.1
