From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] IB-iSER: Adjustments for three function implementations
Date: Sat, 27 Jan 2018 19:17:14 +0100
Message-ID: <00e8b16f-c856-8999-fe93-2724a2f6a56e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jan 2018 19:02:34 +0100

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in iser_send_data_out()
  Delete an unnecessary variable initialisation in iser_send_data_out()
  Combine substrings for three messages

 drivers/infiniband/ulp/iser/iser_initiator.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

-- 
2.16.1

