From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Mon, 14 Jan 2019 10:46:14 +0100
Message-ID: <20190114094614.GA29604@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com> <20190112183752.GC16457@mellanox.com> <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Yong Zhi <yong.zhi@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Tian Shu Qiu <tian.shu.qiu@intel.com>, Jian Xu Zheng <jian.xu.zheng@intel.com>, Sinclair Yeh <syeh@vmware.com>, Thomas Hellstrom <thellstrom@vmware.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 12, 2019 at 01:03:05PM -0600, Shiraz Saleem wrote:
> Well I was trying convert the RDMA drivers to use your new iterator variant
> and saw the need for it in locations where we need virtual address of the pages
> contained in the SGEs.

As far as i can tell that pg_arr[i] value is only ever used for
the case where we do an explicit dma coherent allocation,  so you
should not have to fill it out at all.
