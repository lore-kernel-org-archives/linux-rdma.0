From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCHv2 1/4] IB/core: add port state cache
Date: Wed, 4 Jan 2017 12:58:17 +0100
Message-ID: <CAMGffE=kYTioNBqScgz0kaz4O3XKXkp=FGm=+Kg2fjxMo0xdQA@mail.gmail.com>
References: <CAMGffEmYeYeRVk84GY1CWekNHF7_V4Lo4PDxoGb5wAd8-Tnn7Q@mail.gmail.com>
 <20170103191850.GD26706@obsidianresearch.com> <CAMGffE=FWBZWKCo7X7EA70Hx+jpvMt_E0_WZo-TsHFemCzcaeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=FWBZWKCo7X7EA70Hx+jpvMt_E0_WZo-TsHFemCzcaeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 4, 2017 at 9:50 AM, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wr=
ote:
> On Tue, Jan 3, 2017 at 8:18 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Mon, Jan 02, 2017 at 01:17:36PM +0100, Jinpu Wang wrote:
>>> +++ b/include/rdma/ib_verbs.h
>>> @@ -1781,6 +1781,7 @@ struct ib_cache {
>>>      struct ib_pkey_cache  **pkey_cache;
>>>      struct ib_gid_table   **gid_cache;
>>>      u8                     *lmc_cache;
>>> +    enum ib_port_state     *port_state_cache;
>>>  };
>>
>> I think at this point the these per-port arrays should be moved into a
>> struct..
>>
>> Jason
>
> Ok, I will create a struct ib_port_cache, which contains lmc_cache and
> port_state_cache.
>
> Will submit later today.
>
> Thanks, Jason
>
Hi Jason,

I looked a bit deeper, looks all these four elements are per port
cache, it will take some time,
and I have other more urgent task to do, can we do it later, after
this bug fix patchset merged,
I will put the cleanup task on my TODO list, will address it later.

Thanks,

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
