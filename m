From: Christoph Hellwig <hch@infradead.org>
Subject: Re: srp state in current mainline
Date: Sun, 15 Nov 2015 10:06:21 -0800
Message-ID: <20151115180621.GA24488@infradead.org>
References: <20151110171509.GA27781@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151110171509.GA27781@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

FYI, I sent a patch for the zero S/G length issue.  With this xfstests
does fine for ext4 and btrfs.  With XFS I still run into corruption
warnings for the slab use after free poison pattern.  I suspect that
issue might be related to uniqueue XFS I/O patterns.  One thing that
might be related is that XFS can submit bios backed by kmalloced memory.

I've also tested XFS on various other storage devices on the same kernel
and didn't see an issue like that just to be sure.
