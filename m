From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 10:57:17 -0700
Message-ID: <9EAF4B21EF0A4B0AB50AF7790DE2C046@amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org> <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org> <20100521165018.GA8856@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D181@MNEXMB1.qlogic.org> <20100521172026.GW15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100521172026.GW15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Mike Heinz' <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>verbs? Why verbs?
>
>umad. The only thing that is needed is to subscribe to a GSI
>notification, replicate incoming notifications and route them as
>normal mads over the umad interface to all subscribers..

IMO, someone needs to propose a specific user space API that provides this
capability.  Personally, I don't think MADs provide the desired interface.

I suggested looking at the libibverbs async events, but I didn't take the time
to look at the details of how well that API would fit.  It's used to report
client_reregister events, so using it to report notifications doesn't seem too
out of line.

What's missing is a mechanism to register for the event, which does map better
to umad.  Maybe the kernel user_mad module snoops MADs and reacts accordingly.

Isn't access to the umad interface usually privileged?  If so, is that
acceptable for the anticipated usage?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
