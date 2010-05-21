From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 11:20:26 -0600
Message-ID: <20100521172026.GW15969@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org> <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org> <20100521165018.GA8856@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D181@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D181-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 21, 2010 at 12:04:17PM -0500, Mike Heinz wrote:

> I have to agree that in some ways this seems a good fit with
> ibverbs. Also, without the multicast support, the whole thing is
> well under 1 kloc in the kernel, making it a good candidate for
> being combined with another module.

verbs? Why verbs?

umad. The only thing that is needed is to subscribe to a GSI
notification, replicate incoming notifications and route them as
normal mads over the umad interface to all subscribers..

With some cleverness you could probably make the subscribe/unsubscribe
fairly general..

Remember SA notifications are not the only unsolicited events that can
occure in the GSI framework.

> 1. If it's been working for a couple of years now, do we really need
> to change it?

We need to live with it forever once it is accepted..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
