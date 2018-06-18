From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Mon, 18 Jun 2018 11:40:19 -0700
Message-ID: <CAM_iQpXq0rz7FZoRJGjw_vP7_3EDTzF_aW3CW1EDBFiWA_G=4w@mail.gmail.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com> <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
 <20180614070108.GD18426@mtr-leonro.mtl.com> <20180614142448.GC24762@mellanox.com>
 <CAM_iQpWz9b01ksW_OUHgr1=pf-bNsq_TxoNCQxuDdhUXfvoyOQ@mail.gmail.com>
 <20180614172441.GE24762@mellanox.com> <CAM_iQpXFmqcCQWkyGPmev5LrPpDoEc=wpXQVDWJx2UQWPhwb2g@mail.gmail.com>
 <20180615025739.GB29138@mellanox.com> <CAM_iQpUYWzxMDgJJazLwvD1Tx_7i4PRC0r+2JKar3Vr4bW-Q+w@mail.gmail.com>
 <20180615190833.GC5877@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615190833.GC5877@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 15, 2018 at 12:08 PM, Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> The point is, I don't care about the imbalance report.

OK, we are not on the same page.

Sorry for wasting my time.
