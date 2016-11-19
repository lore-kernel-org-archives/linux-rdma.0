From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] infiniband: remove WARN that is not kernel bug
Date: Sat, 19 Nov 2016 11:57:32 -0700
Message-ID: <20161119185732.GF22775@obsidianresearch.com>
References: <1479468277-50798-1-git-send-email-dvyukov@google.com>
 <164538.1479522162@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <164538.1479522162@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Dmitry Vyukov <dvyukov@google.com>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, leon@kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 09:22:42PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 18 Nov 2016 12:24:37 +0100, Dmitry Vyukov said:
> > WARNINGs mean kernel bugs.
> > The one in ucma_write() points to user programming error
> > or a malicious attempt. This is not a kernel bug, remove it.
> 
> > -	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
> > +	if (!ib_safe_file_access(filp))
> >  		return -EACCES;
> 
> In that case, wouldn't this be better?
> 
> 	if (!ib_safe_file_access(filp)) {
> 		printk_once("Process %d (%s) tried to do something hinky", pid, comm);
> 		return _EACCESS;
> 	}
> 
> so the sysadmin becomes aware of the malicious attempt?

Yes please

Jason
