From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] [RFC] rdma/cm: support option to allow manually
	setting IB path
Date: Thu, 22 Oct 2009 12:36:36 -0600
Message-ID: <20091022183636.GA14520@obsidianresearch.com>
References: <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com> <20091022165414.GH26003@obsidianresearch.com> <1438C87E89284364A56E08A40DFE199E@amr.corp.intel.com> <20091022181101.GY14520@obsidianresearch.com> <67280F81CB6F417DA6EEE22448ED5500@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <67280F81CB6F417DA6EEE22448ED5500-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 11:28:11AM -0700, Sean Hefty wrote:

> I don't like the idea of the kernel silently ignoring the alternate path.
> Returning an error seems like a better idea.

Then provide a way for userspace to know WTF to do. Without a
negotiation process this is now an 'impossible to use right' API.

There are other kernel protocols that work like this, some netlink
stuff works like this for instance. The notion of providing multiple
options and having the kernel pick the ones it supports is a standard
technique for forward API compatability.

How about a compromise. Add a IB_PATH_MUST or something, if the kernel
skips over an entry marked like that due to no support then it returns
-ENOSYS. Userspace that really cares can use that flag. I expect most
cases won't care..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
