From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Wed, 17 May 2017 14:56:36 +0200 (CEST)
Message-ID: <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
References: <33e2cc35-f147-d4a4-9a42-8f1245e35842@mellanox.com> <DE927C68B458BE418D582EC97927A92855088C6F@ORSMSX113.amr.corp.intel.com> <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me> <20170515133122.GG3616@mtr-leonro.local> <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me> <20170515143632.GH3616@mtr-leonro.local> <20170515145952.GA7871@infradead.org> <20170515170506.GK3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515170506.GK3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Mon, May 15, 2017 at 07:59:52AM -0700, Christoph Hellwig wrote:
>> On Mon, May 15, 2017 at 05:36:32PM +0300, Leon Romanovsky wrote:
>> > I understand you and both Max and me are feeling the same as you. For more
>> > than 2 months, we constantly (almost on daily basis) asked for a solution from
>> > architecture group, but received different answers. The proposals were
>> > extremely broad from need for strong fence for all cards to no need for
>> > strong fence at all.
>>
>> So let's get the patch to do a strong fence everywhere now, and relax
>> it later where possible.
>>
>> Correntness before speed..
> 
> OK, please give me and Max till EOW to stop this saga. One of the two
> options will be: Max will resend original patch, or Max will send patch
> blessed by architecture group.
> 

Good luck with this Max & Leon! It seems to be a complicated problem.
Just an idea: in our case it *seems* that the problem started appearing
after a firmware upgrade, older ones do not seem to have the same
behaviour. Maybe it's a hint for you.

Thanks!
Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
