From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_lid_mgr.c: Allow switch lids to be non LMC
 aligned
Date: Wed, 30 Jun 2010 17:44:48 +0300
Message-ID: <4C2B5860.8020306@gmail.com>
References: <4C29F9E5.6030905@gmail.com> <AANLkTinrGhtz0ZKCnvW4d4GmN18QQnEI8ewLZ-vc1PVD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinrGhtz0ZKCnvW4d4GmN18QQnEI8ewLZ-vc1PVD-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock wrote:
> On Tue, Jun 29, 2010 at 9:49 AM, Eli Dorfman (Voltaire)
> <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Fixes a bug of failover between SM's that are running on a switch.
>> Both have lids below LMC start lid (equals to 2^LMC - 1)
>> In case of failover the LID range between 1 and start lid was considered not free
>> and their (switch's) lids were changed.
> 
> Was the problem case for this when LMC > 0 but num_lids is 1 ?

yes, it was for SM running on a switch.

> 
>> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> ---
>>  opensm/opensm/osm_lid_mgr.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
>> index 97b1de6..5d0247a 100644
>> --- a/opensm/opensm/osm_lid_mgr.c
>> +++ b/opensm/opensm/osm_lid_mgr.c
>> @@ -563,10 +563,6 @@ static boolean_t lid_mgr_is_range_not_persistent(IN osm_lid_mgr_t * p_mgr,
>>                                                 IN uint16_t num_lids)
>>  {
>>        uint16_t i;
>> -       uint8_t start_lid = (uint8_t) (1 << p_mgr->p_subn->opt.lmc);
>> -
>> -       if (lid < start_lid)
>> -               return FALSE;
> 
> I think eliminating this test can cause other breakage.
> 
> Shouldn't it be the following:
> 
> if (num_lids > 1 && lid < start_lid)
>     return FALSE;

This could be ok, but even without this test it should work since this function is called only 
if ((min_lid & lmc_mask) == min_lid)

So this would be false for any lid below start_lid.

right?


Eli
> 
> -- Hal
> 
>>        for (i = lid; i < lid + num_lids; i++)
>>                if (p_mgr->used_lids[i])
>> --
>> 1.5.3.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
