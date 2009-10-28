From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3] [RFC] rdma/cm: support option to allow manually
	setting IB path
Date: Wed, 28 Oct 2009 16:24:35 -0600
Message-ID: <20091028222435.GO14520@obsidianresearch.com>
References: <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com> <DC0770A17FDC4DACAC0251A3362CE87A@amr.corp.intel.com> <adaiqdzs81h.fsf@cisco.com> <20091028191454.GL14520@obsidianresearch.com> <5082D185D95A4389BC9EEA666CAEBA66@amr.corp.intel.com> <20091028202545.GM14520@obsidianresearch.com> <24B14DCC9C3645FB92194300C8F5D441@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <24B14DCC9C3645FB92194300C8F5D441-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 02:41:15PM -0700, Sean Hefty wrote:
> >Does a DGID returning API already exist?
> 
> yes - query_route returns the following information: SGID, DGID, pkey, source
> address, destination address, and path records (max of 2).  Not all of the
> information is valid, depending on the state of the rdma cm id.  The librdmacm
> already invokes this after rdma_resolve_addr completes.

Great, I didn't realize that was there. No further comments from me then

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
