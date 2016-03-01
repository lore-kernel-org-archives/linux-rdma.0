From: Christoph Hellwig <hch@lst.de>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Tue, 1 Mar 2016 08:16:57 +0100
Message-ID: <20160301071657.GA32453@lst.de>
References: <56C0A6C3.3010903@redhat.com> <1456630639.19657.47.camel@haakon3.risingtidesystems.com> <1456647963.19657.135.camel@haakon3.risingtidesystems.com> <56D31CC9.7000609@sandisk.com> <1456692183.19657.151.camel@haakon3.risingtidesystems.com> <56D392D4.2000105@sandisk.com> <20160229060504.GA6024@lst.de> <1456814998.19657.223.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456814998.19657.223.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 29, 2016 at 10:49:58PM -0800, Nicholas A. Bellinger wrote:
> Btw, is original ib_create_cq() usage a incompatible with chain RDMA
> READ/WRITE requests, or was that an extra improvement..?

Old-style CQs can be used for chained requests, see the iser target
for an example.  It's just a lot more painful.
