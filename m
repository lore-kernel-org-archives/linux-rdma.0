From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Fri, 22 Apr 2016 16:35:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0447A6@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160421172428.GA5102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> ** And to answer my own question: there is actually a good reason to
>    continue the 'common' API - internally the uverbs/drivers use the
>    kAPI to do most of the work. An incremental API transformation
>    requires us to continue to provide that basic flow or face a
>    daunting task of radically upgrading every single driver!

I could not make the ofvwg call this week, so I missed this conversation.  But I agree that we can't have radical driver upgrades.


> Your observation that uAPI users don't need the kapi struct ib_qp is
> along the same lines and very valid. Could the driver build a more
> efficient struct?

I would add that there are efficiencies that we can gain if we support higher level of abstractions.  For example, there's no technical reason why connection establishment couldn't be done entirely in the kernel, versus making multiple user to kernel transitions to modify the qp.  And this would provide additional security that the app doesn't modify the path record.


> I'm guessing some hybrid is going to be best, eg simple objects like a
> verbs PD could be handled through common code calling the kAPI for all
> drivers and complex very driver-specific objects like MRs, AHs or QPs
> are better routed directly to the driver without using the kapi.

I agree, and I think this may fall out naturally.


> I'm also very concerned to give driver authors a 'free reign' to
> design their driver-specific uAPIs, because historically it has been
> proven across the kernel that driver authors do a bad job of that kind
> of work :( Thus encouraging drivers to stick with the #1 approach as
> much as possible should be encouraged, and all examples of #2 has to
> be reviewed by the core maintainer group (eg to ensure someone doesn't
> try to access EEPROM over this interface :P )

I agree here too.  The main criticism I've read against ioctl's is that they allowed drivers to implement poorly designed interfaces.  Trying to fix that by using write didn't really address the issue...


> We already have to maintain it exactly as is (with write) for a long
> time, adding another copy that is ioctl based and has to live forever
> doesn't seem great :( Maybe the compromise is to use this scheme to
> carry the existing struct as the base attribute?

I was assuming that the write uABI would be replaced with the ioctl path, so I was looking at a way to minimize that transition.  If that's not necessary, I'm sure I could come up with all sorts of other ideas.  :)

It's taking me longer to work through the ioctl details because of, let's call it, significant work distractions.  But I'll comment on your proposals separately once I analyze them more.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
