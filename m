From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Wed, 16 Aug 2017 12:52:52 -0400
Message-ID: <1502902372.33760.17.camel@redhat.com>
References: <1501590709.2725.10.camel@redhat.com>
         <20170802054512.GW13672@mtr-leonro.local>
         <1501761459.117042.5.camel@redhat.com>
         <20170816080523.GG24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816080523.GG24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-16 at 11:05 +0300, Leon Romanovsky wrote:
> On Thu, Aug 03, 2017 at 07:57:39AM -0400, Doug Ledford wrote:
> > On Wed, 2017-08-02 at 08:45 +0300, Leon Romanovsky wrote:
> > > On Tue, Aug 01, 2017 at 08:31:49AM -0400, Doug Ledford wrote:
> > > > Here's the information from the tag:
> > > > 
> > > > tag v15-rc1
> > > > Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > Date:   Tue Aug 1 08:18:05 2017 -0400
> > > > 
> > > > rdma-core-15-rc1
> > > 
> > > Isn't the release supposed to be without "-rc1?
> > 
> > It is.  This is an rc, the release should follow soon.
> 
> Doug,
> 
> Did the RDMA cluster return to operation?

Mostly.  All of the easy fixes have been done.  Now we are down to
debugging/fixing the things that aren't so easy.  For instance, if you
have an older ConnectX-2 card in IB/Eth mode, and you are using PFC on
two different no-drop priorities, and have two separate vlans with one
egress priority map on one vlan and another egress priority map on the
other vlan, then the second vlan will refuse to work.  This is true for
one of our card models we have in the test lab:

Model:	MHQH29B-XTR
PSID:	MT_0D80120009

Latest firmware available at Mellanox.com (without a support login):
	2_9_1000

That firmware is broken for this test case.  It didn't show up prior to
the cluster move as the card was plugged into a different switch
(different brand, entirely different switch OS) and the prior switch
allowed this card to get away with whatever it isn't doing right.  I
was able to isolate the problem down to specifically being that when
you add the egress mapping to the second vlan, that second vlan doesn't
work, but if you remove the egress mapping on that second vlan but
otherwise leave the vlan intact, then it starts working (albeit minus
your egress mapping so you won't actually get PFC on that vlan like you
should).  Some time ago, I used my Mellanox provided support login to
get the latest unofficial/unreleased OEM firmware kit, so I built a new
firmware for the card out of that unreleased stuff and that solved the
problem.

So, it's progressing, and we are slowly marking machines back as fully
operational, but you know the saying, the first 90% takes 10% of the
time and the last 10% takes 90% of the time, and that's how things are
playing out here.  I was working on it as my main focus Monday and
Tuesday, I'm going to refocus on patch processing today while a few
hardware changes are being made, and go from there.  My first priority
today is the -rc pull request and getting it ready.  After that I want
to get some more -next stuff pulled in.

And I know this particular thread is in reference to the rdma-core
package, I haven't forgotten it, I just haven't had a chance to test it
yet :-/.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
