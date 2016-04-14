From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 10:45:50 -0600
Message-ID: <20160414164550.GC6247@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> This patch series removes the write() interface for user access in favor of an
> ioctl() based approach. This is in response to the complaint that we had
> different handlers for write() and writev() doing different things and expecting
> different types of data. See:

I think we should wait on applying these patches until we globally sort out
what to do with the rdma uapi.

It just doesn't make alot of sense for drivers to have their own personal
char devices. :(

A second char dev for the eeprom? How is that OK? Why aren't you using
the I2C layer for this?

Why is there a snoop interface in here? How is that not something that
belongs in a the core code?

Jason
