From: "Woodruff, Robert J" <robert.j.woodruff@intel.com>
Subject: RE: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 17:44:48 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7DDAAE43@ORSMSX115.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com> <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel> <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160415173401.GA10868@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Leon Romanovsky <leon@leon.nu>
Cc: "Weiny, Ira" <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> I fear it's kfabrics, which is an entirely crackpot idea and a total non-starter, but for some reason Intel and their buddies keep wasting time on it.

What is being discussed her is not kfabrics. That is a totally different out of kernel pathfinding project at this point.
What is being discussed here is how to best solve the write/writev issue with the PSM interface. The code submitted was to move
to IOCTL instead, but people like Jason have suggested routing the IOCTLs through the verbs layer instead.
