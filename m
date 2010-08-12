From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 22:26:32 -0600
Message-ID: <20100812042632.GA27925@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com> <4C61BF26.9060003@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com> <20100811231017.GD10271@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601D3C@orsmsx501.amr.corp.intel.com> <20100812015531.GA22548@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601DF1@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601DF1-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 11, 2010 at 08:30:53PM -0700, Hefty, Sean wrote:
> > Even so, the point of passing it into rdma_getaddrinfo is to restrict
> > the device rdma_getaddrinfo selects, it doesn't matter that you can get
> > back to the PD from the addrinfo if that PD doesn't have the resources
> > you need attached to it. Again, I'm thinking from the app perspective
> > where juggling multiple PDs isn't really done, and thus multiple
> > connections on different HCAs are not supported by the app. This model
> > should be supportable without introducing random failures when
> > rdma_getaddrinfo returns things that use other devices.
> 
> But why select the PD as the restriction, rather than just the device?

Well.. That is ok too, but I feel the PD is more general, for instance
with soft iwarp/iboe there is no reason the PD is tied to a single
device - devices are tied to netdevs, but the PD can be shared between
them all.

There are some missing APIs here and there that muddle this (ie there
is no API to set the device a QP is associated with), but I'd rather
not see more added :)

> If rdma_getaddrinfo calls into a service to obtain some of its
> information, then at some point an address must be sufficient.  What
> about just passing in a device guid as the ai_src_addr?

Again, the PD is more general..

There are lots of things rdma_getaddrinfo can support, mapping to a
guid seems restrictive - not sure how guid mapping works with
iwarp/etc when you consider vlans, for instance.

> or, I guess we could add the device to rdma_getaddrinfo:

I'd rather see it in hints, but it isn't a bad idea to have something
like that, even if it is in addition to the PD.

> >  - Create the TGT QP on the initiator side and pass its info in the
> >    private message and do a double QP setup. More complex - does
> >    rdmacm provide hooks to do this?
> 
> I thought about this as well.  The librdmacm could steal more of the
> private data for this - just giving less to the user when connecting
> using XRC.  Right now, the rdma_cm doesn't provide anything to help
> connect XRC QPs, so we can do what makes the most sense.  I still
> don't know how the apps exchange SRQs, which is really part of the
> entire connection process...

Well, whatever it is, the whole private data thing has to be optional,
because it is really protocol specific.

I assume the typical model for XRC would be demand-started peer-peer.

So.. app A starts, looks for friends, finds none, goes to sleep. app B
starts, find A, setups up a channel from B->A and sends 'hello! Here
are my SRQs..'. app A gets the message, builds a reply, looks at the
destination of app B, finds no existing XRC send channel so it sets
one up, sends 'hello! here are my SRQs', and the ack'ing reply to B's
hello, and preseto, bi-directional communication, peer-peer
initiation.

I'm assuming a single SRQ is exchanged during the CM process, and the
total number of SRQs exceeds the size of the CM private data - but I
could also imagine packing them all in the private data if an app
wanted. I guess the key thing is that only a single SRQ is necessary
to start, and the target side switches to an initiator role to setup
its side of the connection.

It is actually pretty good if peer-peer is your app design.. If you
tried to do the same with duplex channels you'd end up with races
creating duplicate send sides that you'd want to tear down to save
resources.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
