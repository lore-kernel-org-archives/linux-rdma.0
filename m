From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Mon, 16 Nov 2009 21:51:58 -0700
Message-ID: <20091117045158.GA14055@obsidianresearch.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.BSF.2.00.0911161835230.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2009 at 06:38:40PM -1000, Jeff Roberson wrote:

> >To get hitless switching to the passive backup pass you need to use
> >the IB APM feature.
> 
> Is there an opensource example of using APM?  When I call ib_cm_send_lap() 
> the QP goes to some error state and my connections die.  Do I need to set 
> some QP attributes first?  I found a paper that describes the process but 
> does not contain sample code or any real details.

The only person I know of who ever got this to work is demoing it here
at SC|09, I'll try to ask him this week :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
