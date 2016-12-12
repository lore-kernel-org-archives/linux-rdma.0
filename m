From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add port state cache
Date: Mon, 12 Dec 2016 13:31:11 +0100
Message-ID: <CAMGffEnjVjEEFM8+vFKZMvyFwgaUjp03Opo42V+OsQHN8Fz5BA@mail.gmail.com>
References: <CAMGffE=gytHRs+SVOmNPCkWX6tZ9hkeFznqeQQs-TFJMMJi97g@mail.gmail.com>
 <6b60d6b1-96ce-3710-7716-0df4b1895c44@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6b60d6b1-96ce-3710-7716-0df4b1895c44-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 12, 2016 at 1:11 PM, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi,
>
> On 12/12/2016 1:43 PM, Jinpu Wang wrote:
>> From fc80c1730d94a38934c5c60f9b9561745723dfd9 Mon Sep 17 00:00:00 2001
>> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Date: Mon, 12 Dec 2016 09:52:42 +0100
>> Subject: [PATCH 1/4] IB/core: add port state cache
>>
>> We need a port state cache in ib_core, later we will use in rdma_cm.
>>
>> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/cache.c | 9 ++++++++-
>>  include/rdma/ib_verbs.h         | 1 +
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/c=
ache.c
>> index 1a2984c..025db27 100644
>> --- a/drivers/infiniband/core/cache.c
>> +++ b/drivers/infiniband/core/cache.c
>> @@ -1109,6 +1109,8 @@ static void ib_cache_update(struct ib_device *devi=
ce,
>>      }
>>
>>      device->cache.lmc_cache[port - rdma_start_port(device)] =3D tprops-=
>lmc;
>> +    device->cache.port_state_cache[port - rdma_start_port(device)] =3D
>> +        tprops->state;
>>
>>      write_unlock_irq(&device->cache.lock);
>>
>> @@ -1168,7 +1170,11 @@ int ib_cache_setup_one(struct ib_device *device)
>>                        (rdma_end_port(device) -
>>                         rdma_start_port(device) + 1),
>>                        GFP_KERNEL);
>> -    if (!device->cache.pkey_cache ||
>> +    device->cache.port_state_cache =3D kmalloc(sizeof
>> *device->cache.port_state_cache *
>> +                      (rdma_end_port(device) -
>> +                       rdma_start_port(device) + 1),
>> +                      GFP_KERNEL);
>> +    if (!device->cache.pkey_cache || !device->cache.port_state_cache ||
> Looking at the code, I see we can leak memory here.
> if pkey_cache is allocated but lms_cache is not, we will return without f=
reeing pkey_cache (or the other way around)
> your code adds port_state_cache to the mix but with the same issue.
> I guess that should be fixed.
>
Hi Mark,

Not really. The release was done by ib_dealloc_device() when put the
last ref of kobj,
dev_release -> ib_device_release -> ib_cache_release_one, driver was suppos=
ed
to use it to destroy the device when register failed.

Cheers,
Jinpu

>>          !device->cache.lmc_cache) {
>>          pr_warn("Couldn't allocate cache for %s\n", device->name);
>>          return -ENOMEM;
>> @@ -1213,6 +1219,7 @@ void ib_cache_release_one(struct ib_device *device=
)
>>      gid_table_release_one(device);
>>      kfree(device->cache.pkey_cache);
>>      kfree(device->cache.lmc_cache);
>> +    kfree(device->cache.port_state_cache);
>>  }
>>
>>  void ib_cache_cleanup_one(struct ib_device *device)
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 5ad43a4..a167ae0 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -1761,6 +1761,7 @@ struct ib_cache {
>>      struct ib_pkey_cache  **pkey_cache;
>>      struct ib_gid_table   **gid_cache;
>>      u8                     *lmc_cache;
>> +    enum ib_port_state     *port_state_cache;
>>  };
>>
>>  struct ib_dma_mapping_ops {
>>
>
> Mark.



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
