From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Wed, 23 Feb 2011 13:56:52 -0800
Message-ID: <20110223135652.21a77482.weiny2@llnl.gov>
References: <20110217213017.25708.95042.stgit@homer>
	<AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
	<20110219192458.GB4506@obsidianresearch.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B17@MNEXMB1.qlogic.org>
	<AANLkTi=1rmRckZz1iAXLpakf5bMuBp4koGOyO-FUDz_M@mail.gmail.com>
	<20110222234304.GA21731@obsidianresearch.com>
	<AANLkTink3ec2O8-ExPuJpJd5j_Y0UtiL=QtM0rrmZR88@mail.gmail.com>
	<20110223054151.GA2363@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110223054151.GA2363-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Feb 2011 21:41:52 -0800
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Tue, Feb 22, 2011 at 04:03:29PM -0800, Roland Dreier wrote:
> > On Tue, Feb 22, 2011 at 3:43 PM, Jason Gunthorpe
> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > > Doing it in userspace makes generating the node description changed
> > > trap simpler?
> > 
> > Hmm... how many places can do sethostname()?  Seems easier to
> > catch in the kernel than hook every place in userspace.  (Although
> > there's no kernel hook right now)  I do agree it would be good to
> > have some idea of how we could generate the "node desc changed"
> > trap at appropriate times.
> 
> Wasn't thinking about 100% perfection, just if DHCP is the concern it
> shouldn't be hard to hook that one place.

I like the idea of having a way to tie node description to the hostname.  It just makes sense.  The question in my mind is will upstream accept a hook in sethostname?  Generally it seems like a good idea, perhaps other subsystems would want to know about it.  But it does seem like it might not get accepted.

> 
> > > I just wonder if this is a big pain to do right, what about charsets, IDN,
> > > and ugly details like that?
> > 
> > Does anyone expect to care about non-ASCII node descs?
> > What can we sensibly do except take what we're given?
> 
> node desc is UTF-8, hostname is IDNA, a conversion is required, see RFC
> 3490.

For what it is worth none of the diags or OpenSM support UTF-8.  I'll add it to the list of things to do.  ;-)

I don't know much about IDNA but it seems that ASCII is a subset of IDNA as well as UTF-8.  Perhaps a check for ASCII in the hostname would suffice to at least make this work for ASCII hostnames only.  (That should cover a significant portion of the hosts out there, if not all of them.)

> 
> Does anyone care? Who knows, but very pedantically it is wrong to just copy
> the host name byte by byte. I only mention it to point out that it is 
> trivial to do what Mike did, somewhat harder to do % escaping like you
> suggest and solve the multiple HCA problem, harder still to trap
> sethostname() and generate a trap, and extra special hard to correctly
> handle character sets on top of all that. :)
> 
> So, is it still trivial to do it in the kernel?

Looking at the latest code it seems that setting the node descriptor for mlx4 and qib will result in a trap 144 being set.  A hook in sethostname which results in the regeneration of the node description and the generation of the trap seems pretty easy.  So, from a technical side I think the answer is "yes" it is pretty easy.

That said getting that hook into sethostname might be harder to get upstream than just writing the code.  I can't comment on that because I don't have any idea how hard that would be.  :-(

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
