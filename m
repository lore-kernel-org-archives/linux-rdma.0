From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Wed, 16 Jan 2019 17:06:39 +0100
Message-ID: <20190116160639.GA28619@lst.de>
References: <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com> <20190115152029.GB2325@lst.de> <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com> <20190115183133.GA12350@lst.de> <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com> <20190115205801.GA15432@lst.de> <01e5522bf88549bfdaea1430fece23cb3d1a1a55.camel@vmware.com> <8aadac80-da9b-b52a-a4bf-066406127117@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8aadac80-da9b-b52a-a4bf-066406127117@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Koenig, Christian" <Christian.Koenig@amd.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 16, 2019 at 07:28:13AM +0000, Koenig, Christian wrote:
> To summarize once more: We have an array of struct pages and want to 
> coherently map that to a device.

And the answer to that is very simple: you can't.  What is so hard
to understand about?  If you want to map arbitrary memory it simply
can't be done in a coherent way on about half of our platforms.

> If that is not possible because of whatever reason we want to get an 
> error code or even not load the driver from the beginning.

That is a bullshit attitude.  Just like everyone else makes their
drivers work you should not be lazy.

> > bool dma_streaming_is_coherent(const struct device *)
> >
> > API to help us decide when to load or not.
> 
> Yes, please.

Hell no.
