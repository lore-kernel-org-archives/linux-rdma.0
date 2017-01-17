From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Tue, 17 Jan 2017 15:50:42 -0700
Message-ID: <20170117225042.GA11768@obsidianresearch.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
 <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
 <1484338667.2679.15.camel@sandisk.com>
 <F3529576D8E232409F431C309E29399336C5FF78@CRSMSX102.amr.corp.intel.com>
 <1484344759.2679.26.camel@sandisk.com>
 <F3529576D8E232409F431C309E29399336C6006C@CRSMSX102.amr.corp.intel.com>
 <1484689709.2729.6.camel@sandisk.com>
 <1484690386.2729.8.camel@sandisk.com>
 <20170117222747.GA11409@obsidianresearch.com>
 <1484692382.2729.23.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484692382.2729.23.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "alex.estrin@intel.com" <alex.estrin@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 10:33:16PM +0000, Bart Van Assche wrote:

> again and also the dma_device pointer from struct ib_device. Since the
> dev.dma_ops pointer in struct ib_device is not yet used dev.dma_ops can be used
> instead of the dma_device pointer.

okay great

Jason
