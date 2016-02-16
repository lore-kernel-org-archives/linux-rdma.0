From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Tue, 16 Feb 2016 11:22:12 -0700
Message-ID: <20160216182212.GA21071@obsidianresearch.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
 <56C08EC8.10207@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <56C08EC8.10207@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: Kovalyov Artemy <artemyko@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "leon@leon.ro" <leon@leon.ro>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 14, 2016 at 04:27:20PM +0200, Haggai Eran wrote:
> [apologies: sending again because linux-mm address was wrong]
> 
> On 11/02/2016 21:18, Jason Gunthorpe wrote:
> > Resubmit those parts under the mm subsystem, or another more
> > appropriate place.
> 
> We want the feedback from linux-mm, and they are now Cced.

Resubmit to mm means put this stuff someplace outside
drivers/infiniband in the tree and don't try and inappropriately send
memory management stuff through Doug's tree.

Jason

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
