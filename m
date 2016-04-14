From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Thu, 14 Apr 2016 14:42:01 -0400
Message-ID: <20160414184200.GA10416@phlsvsds.ph.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com> <20160414164550.GC6247@obsidianresearch.com> <20160414174830.GA11641@rhel.sc.intel.com> <20160414180540.GA12554@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160414180540.GA12554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 12:05:40PM -0600, Jason Gunthorpe wrote:
>There are some pretty obvious paths to make this saner that could only
>be a few weeks away, we haven't even had the first conversations
>yet. I think you are completely wrong there is no 'line of sight'
>
>It certainly can't be years.

Does fixing the current write()/writev() problem have any real impact on how 
we proceed for the "1 char dev to rule them all" idea?

>There is some rational for a very driver specific thing, but EEPROM
>and snoop? Seriously?

That's the thing, I think these are very driver specific [1]. I'm not dead 
set that the eprom needs to be its own device, it made sense to me, but if 
others feel the handling should be back in the hfi1 char device I'm fine 
with that.

As for the snoop stuff, perhaps that would be better in rdmavt?

[1] http://marc.info/?l=linux-rdma&m=146065638629146&w=2

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
