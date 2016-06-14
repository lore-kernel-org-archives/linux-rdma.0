From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target driver
Date: Tue, 14 Jun 2016 10:14:06 -0500
Message-ID: <00e901d1c64f$64d0da20$2e728e60$@opengridcomputing.com>
References: <1465248215-18186-1-git-send-email-hch@lst.de> <1465248215-18186-5-git-send-email-hch@lst.de> <5756B75C.9000409@lightbits.io> <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com> <20160614143132.GA17800@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160614143132.GA17800@infradead.org>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Sagi Grimberg' <sagi@lightbits.io>, 'Christoph Hellwig' <hch@lst.de>, axboe@kernel.dk, keith.busch@intel.com, 'Ming Lin' <ming.l@ssi.samsung.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 'Jay Freyensee' <james.p.freyensee@intel.com>, 'Armen Baloyan' <armenx.baloyan@intel.com>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Jun 09, 2016 at 06:03:51PM -0500, Steve Wise wrote:
> > The above nvmet cm event handler, nvmet_rdma_cm_handler(), calls
> > nvmet_rdma_queue_connect() for CONNECT_REQUEST events, which calls
> > nvmet_rdma_alloc_queue (), which, if it encounters a failure (like creating
> > the qp), calls nvmet_rdma_cm_reject () which calls rdma_reject().  The
> > non-zero error, however, gets returned back here and this function returns
> > the error to the RDMA_CM which will also reject the connection as well as
> > destroy the cm_id.  So there are two rejects happening, I think.  Either
> > nvmet should reject and destroy the cm_id, or it should do neither and
> > return non-zero to the RDMA_CM to reject/destroy.
> 
> Can you just send a patch?

Yes, I'll send it out in a separate email.
