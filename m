From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMA patches for 4.1
Date: Thu, 16 Apr 2015 13:34:01 +0300
Message-ID: <552F9019.6000303@mellanox.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FC0120@ORSMSX109.amr.corp.intel.com>
	 <1428858993.3470.12.camel@dworkin>
	 <20150413164238.GB17521@obsidianresearch.com>
	 <4EC214DA-97F8-4BCD-AEA6-6FB539E820F1@redhat.com>
	 <20150414234258.GA25810@phlsvsds.ph.intel.com>
	 <232BEA5DF26EF54583B8B332938DD0B84BB8E335@CMEXMB1.ad.emulex.com>
	 <F6B0F954-1E60-4CE9-AF39-7A6E8C8EC47B@redhat.com>
	 <552E6D7E.3090002@mellanox.com>
	 <CAG4TOxO=z3_KLy+_86BS29-ZByuJbj6dWte14bi5oasinkbtzA@mail.gmail.com>
	 <F6310773-5388-49B0-99F5-30D18AA335D5@redhat.com>
	 <CAG4TOxNr8BxeyYatROudxFbVGyKnCoCTN7g71C5jUGRSRiLfLQ@mail.gmail.com>
 <1429130738.2980.402.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429130738.2980.402.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/15/2015 11:45 PM, Doug Ledford wrote:
> On Wed, 2015-04-15 at 12:38 -0700, Roland Dreier wrote:
>> On Wed, Apr 15, 2015 at 11:16 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> He has patches that don't conflict available. I can rebase my tree to that if you want. I just can't do it for a couple more hours (appt I couldn't skip).
>>
>> Not sure I follow.  I thought the new patches were just rebased on top
>> of net-next?
> I've pushed an updated tree with Or's redone patchset, and that picks up
> the mlx5 page mask fix from Honggang Li.  Local compile test passed, but
> run tests are impossible at the moment as my cluster is down while the
> head node undergoes hardware updates.
>

Doug - I don't think now is the time to run lengthy run tests, we made 
all these runs throughout the development phase and this is what the 
merge window is about - get it there and sign rc1. If something 
breaks/bug-s we will fix.

I still didn't hear clear response from Roland confirming that he's 
gonna send pull request with these bits.

Roland, please confirm that you are taking this and if not, Dave can you 
help us here? copied linux-rdma.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
