From: PJ Waskiewicz <pj.waskiewicz-PrFOU5CTvK1l57MIdRCFDg@public.gmane.org>
Subject: Re: FW: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Tue, 10 Jun 2014 12:30:39 -0700
Message-ID: <CAEmgqz2BtemAi+8X=VFiu8wrLkARt9c8SjN9zJAbihSmkcXXhQ@mail.gmail.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1>
	<CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com>
	<20140609165105.GB1816@obsidianresearch.com>
	<004501cf840e$6cf0c240$46d246c0$@opengridcomputing.com>
	<20140609184207.GA534@obsidianresearch.com>
	<2ABFA3E36CBB794685BFBA191CC1964952C605CB@FMSMSX105.amr.corp.intel.com>
	<CAEmgqz2HtEJ1ho0rS4xR7ud6YgFfeAvR8uD8MgPjVhw=E9PFEg@mail.gmail.com>
	<20140610165246.GA12951@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140610165246.GA12951-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 10, 2014 at 9:52 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Jun 09, 2014 at 05:08:09PM -0700, PJ Waskiewicz wrote:
>> > > The patch set you refer to tried to _unify_ the port space and was
>> > > rejected.  The only other alternative is to pick ephemeral ports and
>> > > maintain a mapping for RDMA services.
>> >
>> > I thought both approaches were tried in kernel and NAK'd by
>> > netdev?  This looks very similar to the 2010 patchset, except the
>> > dummy socket allocation is living in userspace in this version.
>>
>> This was something I presented and discussed at NetConf 2011 with
>> David and other netdev core folks:
>> http://vger.kernel.org/netconf2011.html.  The main issue David had
>> with the original approach was the socket was being consumed by
>> something else inside the kernel.  It circumvented the TCP socket
>> allocation/reservation code, which was frowned upon.
>
> If you have/can get agreement from netdev that this is acceptable then
> I think it is OK from the RDMA side. It would be a good touch to CC
> the netdev list with the cover letter describing this mechanism
> properly, maybe referencing this discussion just so there are no
> surprises.

Bob and/or Tatyana, did you want to re-send and make sure netdev is
included?  Even though I did the initial championing of the design,
I'm no longer directly involved, and it would be better coming from
you guys.

> BTW, you can purge my jgg-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org email from your address book,
> that hasn't worked in over 10 years..

Yeah, that's my bad.  I didn't have the original email from the
thread, so I had to make "guesses" of some of the email addresses.

Cheers,
-PJ
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
