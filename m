From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Tue, 1 Aug 2017 17:37:54 -0600
Message-ID: <20170801233754.GB10239@obsidianresearch.com>
References: <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170722212706.GA14714@obsidianresearch.com>
 <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170801190052.GA31205@obsidianresearch.com>
 <VI1PR0502MB3008D65E9568764C4A781230D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB3008D65E9568764C4A781230D1B30-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 10:06:14PM +0000, Parav Pandit wrote:

> > > >  Initial Condition VA=0 Data = 0
> > > >  RDMA-W VA=0 Data=1
> > > >  RDMA-R VA=0
> > > >
> > > > Spec says 1 must be returned, but sounds like this relaxed version could
> > return 0.
> > 
> > > No. Table 76 stays as is as described before.
> > 
> > How is this possible?

> I am not sure what more can I explain you Jason.
> Requester side HCA follows HCA Table-76.
> Incoming read responses are not processed until previous writes are
> ACKed implicitly (in read responses) or explicitly by ACK packets.
> Same as before described in spec. No extra description needed for
> this patchset.

But doing that pretty much destroys much of the entire point of having
a relaxed ordering :P

> > > >  RDMA-W VA=0 Data=1
> > > >  RDMA-W VA=0 Data=2
> > > >  SEND
> > > >
> > > > Sounds like with the relaxed version the app could see 1 at SEND CQ time.
> > > >
> > > > So RDMA-W -> RDMA-W degrades to a F
> > 
> > > No. Table-76 is based on  how requester sees the execution.
> > > So it stays as '#'.
> > 
> > How is this possible?
> > 
> Please don't mix requester side ordering with responder side execution.
> C9-28 on responder side is relaxed - as explained few times before.

No, I see what you are tring to say now. I disagree with
this. Table-76 and C9-28 are describing the same thing, you cannot
weaken C9-28 without also restating Table 76.

Table 76 is clearly talking about the entire system, including the
execution and memory subsystem of the completer.

> It covers only requester side.
> Send with invalidate execution on responder side is described in 9.4.1.1.1

I suppose 9.4.1.1.1 point #1 already allows the out of order behavior.

> You are proposing a different behavior and attribute which may be
> done for a HCA that support such thing.  Please submit a different
> patch for it whenever its appropriate.  Current query HCA attribute
> is bit field for future relaxation. May be what you described can be
> done.

Since you guys are hell bent on avoiding the IBTA for your new verbs
features, you do have to define them in a sensible and usefully broad
way using the community process.

> Other out of order atomics such as
> Atomic->Read
> Write->Atomic may be done in future under different attribute.

I think that is a mistake, you should start with them being out of
order and require the app to fence to bring order back, even if the
current HCAs execute them in order anyhow.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
