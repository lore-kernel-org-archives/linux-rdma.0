From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] IB/qib: use rb_entry()
Date: Tue, 20 Dec 2016 19:34:12 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2F374E48@fmsmsx120.amr.corp.intel.com>
References: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
 <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH] IB/qib: use rb_entry()
> 
> To make the code clearer, use rb_entry() instead of container_of() to deal
> with rbtree.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Thanks for the patch!

Mike

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
