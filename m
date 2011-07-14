From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Thu, 14 Jul 2011 09:21:29 -0700
Message-ID: <20110714092129.b29a7ca0.weiny2@llnl.gov>
References: <20110710120442.GA11284@localhost.localdomain>
	<20110712162740.29e2d7d1.weiny2@llnl.gov>
	<20110712235222.GG10216@obsidianresearch.com>
	<20110712165817.16076a3d.weiny2@llnl.gov>
	<20110713041441.GA26663@obsidianresearch.com>
	<20110713082640.GA2024@localhost.localdomain>
	<CAL1RGDVXJd7Sq0-CcYR6heN_HCsrmc1CtrkKfxLWxYe3WN=ghA@mail.gmail.com>
	<20110714161056.GB4502@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110714161056.GB4502-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 14 Jul 2011 09:10:56 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Wed, Jul 13, 2011 at 05:40:57PM -0700, Roland Dreier wrote:
> > On Wed, Jul 13, 2011 at 1:26 AM, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > > +dnl Where to place opensm.pid
> > > +piddir=/var/run
> > 
> > FWIW the future seems to be /run instead of /var/run, eg
> > http://lists.fedoraproject.org/pipermail/devel/2011-March/150031.html
> > 
> > Not sure what the best way to handle this in a way that doesn't cause
> > hassles for packagers is.
> 
> Donno, I find it still unclear if /run is just for early boot stuff
> that might start prior to /var being mounted or a general replacement
> for all /run directories - I think it is the just for early boot
> stuff, and /var/run will bind mount/symlink to it (maybe forever?)?
> 
> In any event, it is the packager's responsibility to understand details
> like this for their distribution..

It seems like the right thing to do would be to use an autoconf variable like "localstatedir".  But every reference I find seems to indicate it is not automatic to say the least...

http://www.linuxfromscratch.org/pipermail/lfs-support/2003-June/017720.html
http://openbsd.monkey.org/ports/200001/msg00065.html
http://www.spinics.net/lists/ac/msg04439.html

http://fedoraforum.org/forum/showthread.php?t=262824
https://bugzilla.redhat.com/show_bug.cgi?id=702769

:-(

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
