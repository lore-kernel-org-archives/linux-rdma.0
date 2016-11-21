From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 09:52:53 -0700
Message-ID: <20161121165253.GA22237@obsidianresearch.com>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
 <20161121114417.GA4158@leon.nu>
 <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ@mail.gmail.com>
 <20161121121408.GC4158@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121121408.GC4158@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller <syzkaller@googlegroups.com>, Valdis.Kletnieks@vt.edu, dledford@redhat.com, sean.hefty@intel.com, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2016 at 02:14:08PM +0200, Leon Romanovsky wrote:
> >
> > In ib_ucm_write function there is a wrong prefix:
> >
> > + pr_err_once("ucm_write: process %d (%s) tried to do something hinky\n",
> 
> I did it intentionally to have the same errors for all flows.

Lets actually use a good message too please?

 pr_err_once("ucm_write: process %d (%s) changed security contexts after opening FD, this is not allowed.\n",

Jason
