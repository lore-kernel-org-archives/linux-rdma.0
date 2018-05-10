From: "Raju  Rangoju" <rajur@chelsio.com>
Subject: Backport commit b7363e67 to stable 4.9.y
Date: Thu, 10 May 2018 06:41:17 +0000
Message-ID: <CY1PR12MB0774AE97D2837E07B12129AEBC980@CY1PR12MB0774.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, SWise OGC <swise@opengridcomputing.com>, Raju Rangoju <rajur@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

Hi Greg,

Could you please backport the below commit to 4.9 stable tree. With a CPU b=
ounded workqueue we see much lower cpu utilization and the same IOPs perfor=
mance.=20

commit b7363e67b23e04c23c2a99437feefac7292a88bc
Author: Sagi Grimberg <sagi@grimberg.me>
Date:   Wed Mar 8 22:03:17 2017 +0200

    IB/device: Convert ib-comp-wq to be CPU-bound

Thanks,
Raju
