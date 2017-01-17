From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Tue, 17 Jan 2017 22:33:16 +0000
Message-ID: <1484692382.2729.23.camel@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
         <1484338667.2679.15.camel@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF78@CRSMSX102.amr.corp.intel.com>
         <1484344759.2679.26.camel@sandisk.com>
         <F3529576D8E232409F431C309E29399336C6006C@CRSMSX102.amr.corp.intel.com>
         <1484689709.2729.6.camel@sandisk.com> <1484690386.2729.8.camel@sandisk.com>
         <20170117222747.GA11409@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170117222747.GA11409@obsidianresearch.com>
Content-Language: en-US
Content-ID: <0D372AF60612904FAC68C37E41BF322B@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "alex.estrin@intel.com" <alex.estrin@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-01-17 at 15:27 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 17, 2017 at 10:00:00PM +0000, Bart Van Assche wrote:
> > +	/*
> > +	 * qib and hfi1 use two sets of DMA operations:
> > +	 * - The DMA operations of the PCIe device for SDMA.
> > +	 * - dma_virt_ops for users of the qib and hfi1 drivers.
> > +	 * The only purpose of @dma_device is to provide a struct device that
> > +	 * provides dma_virt_ops.
> > +	 */
> > +	struct device dma_device;
>=20
> Creating a struct device, not calling device_initialize() and then
> passing it around it other places is pretty ugly and potentially
> dangerous.
>=20
> Is there some other way?
>=20
> Can you setup ibdev to be the 'dma device' for the user side?

Hello Jason,

The only member of this struct device that is used is dma_ops so this appro=
ach
should be fine as an interim solution. My plan is, if this patch is suffici=
ent
to unbreak the hfi1 driver, to remove the struct device cited in your e-mai=
l
again and also the dma_device pointer from struct ib_device. Since the
dev.dma_ops pointer in struct ib_device is not yet used dev.dma_ops can be =
used
instead of the dma_device pointer.

Bart.=
