From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 11:43:09 -0600
Message-ID: <20100521174309.GX15969@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org> <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org> <20100521165018.GA8856@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D181@MNEXMB1.qlogic.org> <20100521172026.GW15969@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D186@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D186-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 21, 2010 at 12:29:31PM -0500, Mike Heinz wrote:

>> umad. The only thing that is needed is to subscribe to a GSI
>> notification, replicate incoming notifications and route them as
>> normal mads over the umad interface to all subscribers..

> However - you're wrong about "the only thing needed" being to
> subscribe to a GSI notification; notifications are sent to ports,
> not to individual queue pairs or processes - that's why the ib_sa
> module has a mechanism for for managing notifications. Like ib_umad,
> ib_usa is the mechanism for extending ib_sa into user space.

To be fair I had two things in that statement..

umad instances are per-port. You do an ioctl or something on the umad
FD to register for the notification, and the umad module replicates an
incoming notification GMP to all registrants. This seems totally
straightforward to me..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
