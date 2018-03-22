From: Casey Leedom <leedom@chelsio.com>
Subject: Re: [PATCH v4 4/6] infiniband: cxgb4: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Thu, 22 Mar 2018 22:02:52 +0000
Message-ID: <BY2PR1201MB09833C062294345C829E90A9C8A90@BY2PR1201MB0983.namprd12.prod.outlook.com>
References: <1521514068-8856-5-git-send-email-okaya@codeaurora.org>
 <201803221430.P43GJl9U%fengguang.wu@intel.com>
 <3664b253c730dbf83f4528acaedb3a88@codeaurora.org>
 <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
 <03d201d3c1eb$b71fb460$255f1d20$@opengridcomputing.com>
 <83484a3f-d3f7-d763-e4f8-e4fec3bb8cc2@codeaurora.org>
 <52cbc9d7-5a6b-5c8b-b930-058f5be62079@opengridcomputing.com>
 <BY2PR1201MB098352CB012D8AE8084882F3C8A90@BY2PR1201MB0983.namprd12.prod.outlook.com>
 <20180322201649.GC9469@ziepe.ca>
 <BY2PR1201MB098367F8F217A8BF66AE68B6C8A90@BY2PR1201MB0983.namprd12.prod.outlook.com>,<f676414b-20b7-d724-4fcd-d2b4c24259b5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f676414b-20b7-d724-4fcd-d2b4c24259b5@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: SWise OGC <swise@opengridcomputing.com>, 'kbuild test robot' <lkp@intel.com>, "kbuild-all@01.org" <kbuild-all@01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "sulrich@codeaurora.org" <sulrich@codeaurora.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Steve Wise <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Werner <werner@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

  Okay, thanks Sinan.  I ~think~ we're on the same page here.

  Our guy Michael Werner is carefully going through our drivers with Steve
Wise.  I'd like to let them work on the changes with a lot of thought and
testing before diving in too far.

  We had thought that we could get around the lack of a real Relaxed
Ordering Write on the PowerPC via the __raw_write*() API, but that isn't
really part of the defined API and various platforms define that API
differently (some doing PCI Byte Ordering rearrangements and some not).  I
think that we're going to have to work with the PowerPC platform folks to
get a real Relaxed Ordering Write.

Casey
