From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Handling busy responses from the SA
Date: Mon, 7 Jun 2010 10:41:42 -0600
Message-ID: <20100607164142.GA32504@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org> <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C@orsmsx501.amr.corp.intel.com> <20100604225739.GK15969@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0D@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0D-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 07, 2010 at 11:02:10AM -0500, Mike Heinz wrote:
> > But, I also agree with Roland.. having the SA return busy when it is
> > under load seems insane :) 
> 
> In that case, what is the purpose of the BUSY response? 

I would say to indicate that the SA is internally busy (ie computing
routing tables, etc) and that the client should sit back and wait.

Too busy to handle the request load should just rely on timeouts.

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
