From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: infiniband-diags/perfquery.c: Use ib_types.h defines for
 CapabilityMask
Date: Thu, 28 Apr 2011 10:14:56 -0700
Message-ID: <20110428101456.8f9ac048.weiny2@llnl.gov>
References: <4DB97DF4.3020004@dev.mellanox.co.il>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3A02@orsmsx501.amr.corp.intel.com>
	<4DB995CE.8070203@dev.mellanox.co.il>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3AB8@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3AB8-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Apr 2011 09:36:49 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Also, there are other infiniband-diags (and library) including
> > ib_types.h (e.g. saquery and libibnetdisc).
> 
> I have a set of patches that I created as part of trying to support AF_IB and ACM that move a lot of the MAD definitions into libibumad include files.  I don't remember if I ever submitted these, since I was waiting on the acceptance of the kernel patches.  It would take me a while to pull them back out and update them, but I can submit those.  They would help eliminate some of the duplicate definitions that exist between the different libraries (such as libibverbs, librdmacm, and ibacm), and should remove ib-diags from depending on opensm.
> 
> I know we've discussed this sort of change before, but would these be acceptable to everyone?

Oh yes, I was just codeing along and added the define where the others were.  I would very much like the diags to not depend on opensm.  Please do resubmit your patches.

For now I am going to accept this patch which will mark perfquery as something which needs to transition.

Ira

> 
> - Sean


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
