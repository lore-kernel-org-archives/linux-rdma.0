From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Thu, 14 Apr 2016 13:52:44 -0400
Message-ID: <20160414175243.GA9310@phlsvsds.ph.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com> <20160414164550.GC6247@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414164550.GC6247@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
>On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
>> This patch series removes the write() interface for user access in favor of an
>> ioctl() based approach. This is in response to the complaint that we had
>> different handlers for write() and writev() doing different things and expecting
>> different types of data. See:
>
>I think we should wait on applying these patches until we globally sort out
>what to do with the rdma uapi.

Perhaps there is a broader change to make to the rdma subsystem, but until 
that is fleshed out this patch set achieves our goal of fixing the 
write()/writev() problem and should be sufficient to let the driver come out 
of staging for 4.7?

>A second char dev for the eeprom? How is that OK? Why aren't you using
>the I2C layer for this?

I moved it because it is totally different in terms of functionality. The 
hfi1 device is for send/recv of packets across the wire. The eprom device is
for low level programming of the eprom on the chip. We do not use i2c for 
this because the eprom is directly attached to the chip and not accessible 
via i2c, requires register access.

>Why is there a snoop interface in here? How is that not something that
>belongs in a the core code?

The snoop interface is a low level diagnostic for the hfi. The intent is to 
grab packets before they are handed up to the verbs layer. It also lets us 
send all sorts of debug/diagnostic packets for testing.

-Denny
