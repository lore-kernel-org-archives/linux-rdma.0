From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 19 Jun 2017 11:21:34 -0600
Message-ID: <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
References: <33e2cc35-f147-d4a4-9a42-8f1245e35842@mellanox.com>
 <DE927C68B458BE418D582EC97927A92855088C6F@ORSMSX113.amr.corp.intel.com>
 <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me> <20170515133122.GG3616@mtr-leonro.local>
 <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me> <20170515143632.GH3616@mtr-leonro.local>
 <20170515145952.GA7871@infradead.org> <20170515170506.GK3616@mtr-leonro.local>
 <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu> <20170518133439.GD3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518133439.GD3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I ran into this with 4.9.32 when I rebooted the target. I tested
4.12-rc6 and this particular error seems to have been resolved, but I
now get a new one on the initiator. This one doesn't seem as
impactful.

[Mon Jun 19 11:17:20 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
[Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:20 2017] 00000000 93005204 0a0001bd 45c8e0d2
[Mon Jun 19 11:17:20 2017] iser: iser_err_comp: command failure: local
protection error (4) vend_err 52
[Mon Jun 19 11:17:20 2017]  connection3:0: detected conn error (1011)
[Mon Jun 19 11:17:31 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
[Mon Jun 19 11:17:31 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
[Mon Jun 19 11:17:31 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:31 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:31 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:31 2017] 00000000 93005204 0a0001e7 45dd82d2
[Mon Jun 19 11:17:31 2017] iser: iser_err_comp: command failure: local
protection error (4) vend_err 52
[Mon Jun 19 11:17:31 2017]  connection4:0: detected conn error (1011)
[Mon Jun 19 11:17:31 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:31 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:31 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:31 2017] 00000000 93005204 0a0001f4 004915d2
[Mon Jun 19 11:17:31 2017] iser: iser_err_comp: command failure: local
protection error (4) vend_err 52
[Mon Jun 19 11:17:31 2017]  connection3:0: detected conn error (1011)
[Mon Jun 19 11:17:44 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
[Mon Jun 19 11:17:44 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:44 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:44 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:17:44 2017] 00000000 93005204 0a0001f6 004519d2
[Mon Jun 19 11:17:44 2017] iser: iser_err_comp: command failure: local
protection error (4) vend_err 52
[Mon Jun 19 11:17:44 2017]  connection3:0: detected conn error (1011)
[Mon Jun 19 11:18:55 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
[Mon Jun 19 11:18:55 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:18:55 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:18:55 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:18:55 2017] 00000000 93005204 0a0001f7 01934fd2
[Mon Jun 19 11:18:55 2017] iser: iser_err_comp: command failure: local
protection error (4) vend_err 52
[Mon Jun 19 11:18:55 2017]  connection3:0: detected conn error (1011)
[Mon Jun 19 11:20:25 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
[Mon Jun 19 11:20:25 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:20:25 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:20:25 2017] 00000000 00000000 00000000 00000000
[Mon Jun 19 11:20:25 2017] 00000000 93005204 0a0001f8 0274edd2
[Mon Jun 19 11:20:25 2017] iser: iser_err_comp: command failure: local
protection error (4) vend_err 52
[Mon Jun 19 11:20:25 2017]  connection3:0: detected conn error (1011)

I'm going to try to cherry-pick the fix to 4.9.x and do some testing there.

Thanks,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, May 18, 2017 at 7:34 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, May 17, 2017 at 02:56:36PM +0200, Marta Rybczynska wrote:
>> > On Mon, May 15, 2017 at 07:59:52AM -0700, Christoph Hellwig wrote:
>> >> On Mon, May 15, 2017 at 05:36:32PM +0300, Leon Romanovsky wrote:
>> >> > I understand you and both Max and me are feeling the same as you. For more
>> >> > than 2 months, we constantly (almost on daily basis) asked for a solution from
>> >> > architecture group, but received different answers. The proposals were
>> >> > extremely broad from need for strong fence for all cards to no need for
>> >> > strong fence at all.
>> >>
>> >> So let's get the patch to do a strong fence everywhere now, and relax
>> >> it later where possible.
>> >>
>> >> Correntness before speed..
>> >
>> > OK, please give me and Max till EOW to stop this saga. One of the two
>> > options will be: Max will resend original patch, or Max will send patch
>> > blessed by architecture group.
>> >
>>
>> Good luck with this Max & Leon! It seems to be a complicated problem.
>> Just an idea: in our case it *seems* that the problem started appearing
>> after a firmware upgrade, older ones do not seem to have the same
>> behaviour. Maybe it's a hint for you.
>
> OK, we came to the agreement which capability bits we should add. Max
> will return to the office at the middle of the next week and we will
> proceed with the submission of proper patch once our shared code will
> be accepted.
>
> In the meantime, i put the original patch to be part of our regression.
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=testing/queue-next&id=a40ac569f243db552661e6efad70080bb406823c
>
> Thank you for your patience.
>
>>
>> Thanks!
>> Marta
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
