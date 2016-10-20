From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Test fail]//Re: some test question//Re: [For help] configure
 crossbar build tool in CMakelist.txt
Date: Thu, 20 Oct 2016 10:29:55 -0600
Message-ID: <20161020162955.GA7375@obsidianresearch.com>
References: <5805FF8C.1060902@huawei.com>
 <20161018155004.GA24189@obsidianresearch.com>
 <5806E02E.7030400@huawei.com>
 <20161019041102.GA28678@obsidianresearch.com>
 <5808772F.6050305@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5808772F.6050305-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2016 at 03:50:07PM +0800, oulijun wrote:
> 1. when set the VERBS_PROVIDER_DIR to empty, the
> sizeof(VERBS_PROVIDER_DIR) should be 0 and the branch should not be
> run

This is a mistake, sizeof('') is 1, so the if should be (> 1)' I will
fix it.

> 2. the value of so_name should be /libhisi-rdmav2.so in @1 and
> libhisi-rdmav2.so in @2.  in fact, the value of so_name is /libhisi
> and libhisi
> 
> the test print log as follows:
> 
> -rdmav2.soer, 218] so_name: /libhisi
> [load_driver, 219] so_name: -rdmav2.so
> -rdmav2.soer, 229] so_name: libhisi
> [load_driver, 230] so_name: -rdmav2.so

If you notice the -rdmav2.so has been placed at the start of the line,
this suggest you have a spurious '\r' character. This would come from
the .driver file.

Since you did not use the cmake install process you must have written
the .driver file yourself and used a DOS text editor. UNIX line
endings are required.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
