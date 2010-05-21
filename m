From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 13:45:52 -0600
Message-ID: <20100521194552.GY15969@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org> <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org> <20100521165018.GA8856@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D181@MNEXMB1.qlogic.org> <20100521172026.GW15969@obsidianresearch.com> <9EAF4B21EF0A4B0AB50AF7790DE2C046@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9EAF4B21EF0A4B0AB50AF7790DE2C046-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Mike Heinz' <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 21, 2010 at 10:57:17AM -0700, Sean Hefty wrote:

> IMO, someone needs to propose a specific user space API that provides this
> capability.  Personally, I don't think MADs provide the desired interface.

My thinking was sort of:

fd = open("/dev/..umad..");
ioctl(fd, SUBSCRIBE_TRAP, &trap_description)
read(fd..); // Events arrive
close(fd);  // Event is unsubscribed

The reason this fits nicely with umad is that you really actually want
the GMP trap, not some processed version.. So this is like a multicast
subscribe in IP.

So.. The main question is how to do formulate a SUBSCRIBE_TRAP
operation that:
 1) Can describe GSI traps for multiple managers, not just SA
 2) Specifies how to filter incoming GMPs
 3) Lets the kernel send and refcount the trap subscribe message
 4) Lets the kernel send an unsubscribe message.
 5) Lets the kernel send a single repress message if necessary

The first two seem easy, use the trap ID, class ID, and possibly LID
as well.

I think the latter three are not too bad, the subscribes/unsubscribe
messages are pretty uniform. Tricky bit might be the ref counting?

Mostly just reading the spec to see..

> I suggested looking at the libibverbs async events, but I didn't
> take the time to look at the details of how well that API would fit.
> It's used to report client_reregister events, so using it to report
> notifications doesn't seem too out of line.

This seems reasonable to me for some high level notices that are
commonly used and shouldn't require privilege to access. But if you
want to access raw trap/notices then umad seems a better bet.

To me, if it is OK for the kernel to always subscribe to the
trap/notice then async events seem to be a good choice. I'm not sure
the kernel should unconditionally subscribe to things like gid in/out
of service, etc..

> Isn't access to the umad interface usually privileged?  If so, is that
> acceptable for the anticipated usage?

Subscribing to an arbitary trap should be privileged.. IHMO.

But I agree, is there a single specific trap you are trying to access
with ib_usa??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
