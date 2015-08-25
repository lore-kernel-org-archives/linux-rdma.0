From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Tue, 25 Aug 2015 10:55:08 +0200
Message-ID: <20150825085508.GC31630@lst.de>
References: <1440002254-795-1-git-send-email-hch@lst.de> <HE1PR05MB13557ADB8FA73865B659C6D0C1640@HE1PR05MB1355.eurprd05.prod.outlook.com> <20150822082516.GC1857@lst.de> <55DABF1E.2050804@mellanox.com> <20150824065501.GA31990@lst.de> <55DACED9.4060603@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55DACED9.4060603@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 24, 2015 at 10:59:21AM +0300, Haggai Eran wrote:
> > It looks odd to me as well, but it's not really something I want to
> > change in this series.  Note that sparse annoted types like __be32
> > aren't really common in userspace, but with a bit of effort they can
> > be supported.  We have them and regularly run sparse for xfsprogs for
> > example.
> 
> I have to try it with libibverbs sometime. It doesn't use uapi yet
> though IIRC - it has its own version of the header files.

Yes, I noticed that.  And the WR opcodes aren't even exported in the
uapi header, and use a shared namespace with the in-kernel only ones.

It's all a giant mess unfortunately.
