From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH v2 3/5] IB/hfi1: Add ioctl() interface for user commands
Date: Fri, 13 May 2016 10:33:47 -0400
Message-ID: <20160513143346.GA6665@phlsvsds.ph.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com> <20160512171846.6198.31415.stgit@scvm10.sc.intel.com> <20160512174332.GB13553@obsidianresearch.com> <20160512192726.GB15146@phlsvsds.ph.intel.com> <20160512194006.GA6364@obsidianresearch.com> <f96bfe93-6bcc-7d55-8f7a-1792d12d41d9@redhat.com> <20160512212821.GC6545@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512212821.GC6545@obsidianresearch.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 03:28:21PM -0600, Jason Gunthorpe wrote:
>On Thu, May 12, 2016 at 03:48:16PM -0400, Doug Ledford wrote:
>> were going to rip out the EEPROM code.  In any case, the best fix would
>> be to rebase the two series that are remaining and move any "rip out
>> things like eeprom support" patches to prior to the ioctl patches and
>> make it so that they rip out the write interface version of it instead,
>> and then squash a second copy of the ioctl removal into this patch.
>
>Yes, this would look best

The end result will end up being the exact same code so I don't have a 
problem doing that. 

Perhaps it would be better if I just combine the two patch sets into one 
series? I still need to look more into the kobj stuff about the cdev, if 
needed I'll add a patch for that as well.

-Denny
