From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Thu, 16 Jan 2014 14:06:08 -0800
Message-ID: <1389909968.5567.688.camel@haakon3.risingtidesystems.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	 <52CD1C68.4050406@mellanox.com>
	 <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	 <1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	 <1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	 <20140116213717.GA24718@kroah.com>
	 <CAJZOPZ+75yOyxrcu4s=dSxv4Ya27UyotbRWLqwC3bbh3wieihg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+75yOyxrcu4s=dSxv4Ya27UyotbRWLqwC3bbh3wieihg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2014-01-16 at 23:42 +0200, Or Gerlitz wrote:
> On Thu, Jan 16, 2014 at 11:37 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Thu, Jan 16, 2014 at 01:14:12PM -0800, Nicholas A. Bellinger wrote:
> >> On Thu, 2014-01-16 at 12:13 -0800, Roland Dreier wrote:

<SNIP>

> >> > I haven't really had a chance to look at the new API and decide if it
> >> > makes sense as the way to expose these features.  Have you looked at
> >> > the new kernel API?  Any thoughts?
> >>
> >> I've reviewed the API from the perspective of what's required for
> >> implementing protection support in iser, and currently don't have any
> >> recommendations or objections beyond what has been proposed by Sagi & Co
> >> in PATCH-v4 code.
> >>
> >> > How does it compare with how other subsystems have exposed protection
> >> > info?
> >> >
> >>
> >> So there is not a interface in SCSI land for interacting (directly) with
> >> hardware protection support, as it's primarily just telling SCSI what
> >> protection modes are supported while the rest is implemented in vendor
> >> specific firmware interfaces.  (CC'ing MKP)
> >>
> >> > Right now I'm dealing with fixing the fallout from picking up the "IP
> >> > addressing for IBoE" and other patch sets that were supposedly "ready
> >> > to merge for a long time" so I'm not sure I'll get to the protection
> >> > changes in time for 3.14.
> >> >
> >>
> >> Pretty please for v3.14..?
> >
> > It's _really_ late in the development cycle for new stuff for 3.14.  My
> > trees have been closed for almost a week now, for major stuff, and for
> > anything else for a few days now.  It would be good if you could get
> > your patchsets into the 0-day testing bot earlier to shake out any build
> > issues that might happen with them, please work with that developer to
> > help make the merging of the code easier.
> 
> Greg,
> 
> The T10 patches were posted whole three months ago (V0 Oct 15th). I
> don't see why another cycle should get lost just because there was no
> maintainer feedback on them throughout this whole period. There's
> enough time for us to fix things that will show up in the testing bot
> before Roland sends his pull request over the two weeks merge window.
> 

So as Greg noted, it's still useful to get this into the 0-day build
testing now.

That said, pushing the -v4 series into target-pending/rdma-dif, and
Fengguang's scripts should be picking it up shortly.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
