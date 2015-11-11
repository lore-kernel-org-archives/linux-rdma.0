From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Wed, 11 Nov 2015 10:39:46 -0700
Message-ID: <20151111173946.GB843@obsidianresearch.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org>
 <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
 <20151110182546.GI12667@obsidianresearch.com>
 <56425AFB.30202@talpey.com>
 <20151110211716.GA21631@obsidianresearch.com>
 <56430972.8080703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56430972.8080703-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 11:25:06AM +0200, Sagi Grimberg wrote:
> For RDMA READs, a HCA will perform the memory scatters when on the RX
> path, when receiving the read responses containing the data. This means
> that the HCA needs to perform a lookup of the relevant scatter entries
> upon each read response. Due to that, modern HCAs keep a dedicate cache
> for this type of RX-path lookup (which is limited in size naturally).

There is always a memory scatter, and MR setup overheads and table
reads are not zero. There is nothing architectural in the verbs or IBA
that would require a HCA to run slower for SGL than MR...

As you say, another choice the ULP should not be making.. Even
selecting the optimal SGL list len is not something the ULP should
do, in that case.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
