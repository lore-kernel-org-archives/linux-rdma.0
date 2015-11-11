From: Christoph Hellwig <hch@infradead.org>
Subject: Re: srp state in current mainline
Date: Wed, 11 Nov 2015 07:46:17 -0800
Message-ID: <20151111154617.GA3754@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <56436053.7030201@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56436053.7030201@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 07:35:47AM -0800, Bart Van Assche wrote:
> On 11/10/2015 09:15 AM, Christoph Hellwig wrote:
> >This is a simply xfstests run using XFS on a remote LIO ramdisk.
> 
> Hello Christoph,
> 
> Which version of the kernel and LIO were installed at the target side ?

I've tried a couple different one from 4.1-rc3 to latest Linus tree
from yesterday, and the target side doesn't matter.

I've also bisected things down on the initiator side and the changes to
enable prefer_fr and register_always seem to be the culprit at least as
far as 4.3 is concerned.  If I disable both 4.3 is working fine, but
enabling either one causes frequent map failures.  Just rebuilding
a new Linus current tree to see if the options help there as well.
