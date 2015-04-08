From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Wed, 8 Apr 2015 16:03:22 +0300
Message-ID: <CAJ3xEMj-ueR3WVm9_Ny85auZggQOXKeLE9APmxOcsYuaTZvsgw@mail.gmail.com>
References: <20150330.233602.155832546277570456.davem@davemloft.net>
	<CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
	<CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com>
	<20150331.114824.651005354305268415.davem@davemloft.net>
	<1828884A29C6694DAF28B7E6B8A82373A8FBB790@ORSMSX109.amr.corp.intel.com>
	<CAJ3xEMgm+6t1OSMZFJ41Hr4=8B1cKP+5svwc38Lg0wfpCZMO=g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FBBCE3@ORSMSX109.amr.corp.intel.com>
	<CAJ3xEMgptECgnWXfW7wN8sjqRfUvzF3tCN=Lj8MZtdOG8yg3jQ@mail.gmail.com>
	<20150402223135.GA12588@phlsvsds.ph.intel.com>
	<CAJ3xEMgsHAFJomuCN+EzMcYaxTOTQqHuDdr9zztuO9pH9QicXw@mail.gmail.com>
	<CAG4TOxOv98YjNOi9MbKHiHg6aLw75XRfasMaScdRccRitiE3-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxOv98YjNOi9MbKHiHg6aLw75XRfasMaScdRccRitiE3-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 5, 2015 at 5:51 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sat, Apr 4, 2015 at 10:15 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Indeed. No maintainer voice makes it kind of impossible for
>> discussions to converge. What happens over the last years is that when
>> there's no easy consensus on matter Y, everyone stops breathing and
>> wait to see what happens on the rc1 night, b/c Roland doesn't spell
>> his view/preference (nor exposes his for-next branch till the last
>> minute, see now) many times it seems more as coin flipping.
>
> To me this attitude shows a failure of the community.  If I need to
> make every decision, then that doesn't scale.  People can ask
> questions a lot more easily than I can answer them.
>
> In general if a consensus emerges, I'm pretty likely to trust it.  In
> particular, as Sean mentioned, I tend to trust vendors about low-level
> drivers, although of course I sometimes catch mistakes even then.
>
> But for changes that touch the core, when there's a disagreement, you
> can't expect me to be the one who always solves it.  I might have an
> opinion, but in a lot of cases, both sides might have a point and the
> only way forward is to come up with a new idea that works for
> everyone.  And I'm not smart enough to come up with that solution every time.

To make it a little more clear, my rc1 night note came to describe
situations where
not only that you didn't do the essential part of subsystem maintainer
job of dropping
a note on how you see things and where yo think the solution should be
going etc --
you went ahead and kind of randomly applied patch series for which there was no
consensus or bunch of open reviewer comments unanswered by the
submitters to your
for-next branch which you didn't post publicly and in < 12h sent pull
request to Linus, crazy!!

BTW as we speak now (after rc7), the patches you already have for 4.1
(and there are such, as you acked
@ least one series on the list {BTW about 5y ago you stopped for 90%
of the cases to ack pactches
on the list, which is very frustrating for developers too}) aren't
public, you have a private clone which isn't
reflected at kernel.org

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
