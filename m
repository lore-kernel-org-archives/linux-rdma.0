From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 7 Apr 2015 11:12:50 -0600
Message-ID: <20150407171250.GA11441@obsidianresearch.com>
References: <20150402223135.GA12588@phlsvsds.ph.intel.com>
 <CAJ3xEMgsHAFJomuCN+EzMcYaxTOTQqHuDdr9zztuO9pH9QicXw@mail.gmail.com>
 <CAG4TOxOv98YjNOi9MbKHiHg6aLw75XRfasMaScdRccRitiE3-g@mail.gmail.com>
 <20150405.164626.1878934248335902055.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150405.164626.1878934248335902055.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 05, 2015 at 04:46:26PM -0400, David Miller wrote:
> From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Sun, 5 Apr 2015 07:51:08 -0700
> 
> > On Sat, Apr 4, 2015 at 10:15 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> Indeed. No maintainer voice makes it kind of impossible for
> >> discussions to converge. What happens over the last years is that when
> >> there's no easy consensus on matter Y, everyone stops breathing and
> >> wait to see what happens on the rc1 night, b/c Roland doesn't spell
> >> his view/preference (nor exposes his for-next branch till the last
> >> minute, see now) many times it seems more as coin flipping.
> > 
> > To me this attitude shows a failure of the community.  If I need to
> > make every decision, then that doesn't scale.  People can ask
> > questions a lot more easily than I can answer them.
> 
> No, you need to step in and be the benevolent dictator when people
> have their thumbs up their asses and can't make up their minds,
> otherwise things grind to a halt.

Agree. 

As a community we don't need the subsystem maintainer to just applies
patches that don't have any discussion. Anyone can do that. We need
someone that guides potentially good patches to success and keeps the
whole code base on track.

I don't think you understand how deep the problem Or is describing
goes.

People have no idea what you want to see, what you will accept and
everytime they ask they get silence.

Or worse - remeber this?

http://www.spinics.net/lists/linux-rdma/msg21114.html

You drive-by-NAK'd Barts's patch and then completely ignored Doug's
follow up, the entire series just died out, and that patch is
still not applied.

This isn't a failure of the community.

There is a pretty clear expectation of what a subsystem maintainer
should do. Greg KH codified some of it in this presentation:

https://github.com/gregkh/presentation-linux-maintainer/blob/master/maintainer.pdf

Start at page 119:

What I will do for you:

 So, finally, you created the perfect patch
 series, took all review into account, and sent
 it correctly, without corrupting the patch.
 What should you expect from me, the
 subsystem maintainer?

Review your patch within 1-2 weeks

 Some subsystem maintainers try to get to
 patches even faster than this, but with travel
 and different conferences, the best that I
 can normally do is about 1-2 weeks.

 If I don't respond in that time frame, just ask
 what is going on. I have no problem with
 people asking about their patch status.
 Sometimes patches end up getting dropped
 on the floor accidentally, and if I'm being
 slow I have no problem with being called on
 it, so don't feel bad about checking up on it.

 But please wait 1-2 weeks, don't be rude and
 send a patch at night, and then in the
 morning send a complaining email asking
 why it wasn't reviewed already. This
 happens more than you want to know.

Offer semi-constructive criticism

Let you know the status of your patch

 I have a set of scripts that I got from Andrew
 Morton that will email you when I apply your
 patch to one of my development trees saying
 where it has been applied and when you can
 expect to see it show up in Linus's tree. There is
 no reason that all kernel maintainers shouldn't do
 this, and it's nice to see that more and more are.

 But, I know from personal experience, there are
 maintainers in this room that I send patches to
 and I never know what happens to them. A few
 months later I will see them show up in Linus's
 tree, usually after I forgot about them.

 That's not acceptable, and you should not allow
 this, push back on your subsystem maintainer to
 use something like this, to keep you informed.
 Andrew's scripts are public, as are my variations
 of them, for everyone to use.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
