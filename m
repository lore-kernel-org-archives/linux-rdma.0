From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3 v2] opensm SA DB dump/restore: dump SA DB only if
 modified
Date: Mon, 11 Jan 2010 10:07:53 +0200
Message-ID: <4B4ADC59.1070301@dev.mellanox.co.il>
References: <4AF15EF0.6050903@dev.mellanox.co.il> <20091126141519.GB28564@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091126141519.GB28564@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On 26/Nov/09 16:15, Sasha Khapyorsky wrote:
> On 13:01 Wed 04 Nov     , Yevgeny Kliteynik wrote:
>> Optimizing SA DB dump - added "dirty" flag to denote
>> that the SA DB was modified, so that the DB will be
>> dumped only when the flag is on.
>>
>> [v2 - no changes, just rebased and resolved conflicts]

[snip]

>> +
>> +	subn->p_osm->sa.dirty = TRUE;
>>   }
>
> In general I don't like an idea of spreading this global "dirty" flag
> over various OpenSM areas (it makes the code dirty). But even if it is
> needed couldn't we minimize number of such occurrences?

See below

> For example those specific ones in osm_multicast.c are duplicated in
> osm_sa_mcmember_record.c

This is fixed in the new patch

> (and also will cause 'dirty' flag setup on the
> SA DB from file loading).

Fixed - the flag is cleared at the end of loading SA DB

> Could we consolidate all multicast related
> cases with re-routing requesting for example?

SA DB contains 3 types of data:
  - informinfo records
  - service records
  - mcmember records

So the "dirty" flag (or "modified", if you wish) must be set
in 6 places:
  - add/remove informinfo record
  - add/remove service records
  - add/remove mcmember records

Another possible place for setting this flag is mcgroup
create/delete (this is what's sometimes duplicated by the
add/remove mcmember records), but I think that this is not
needed:

The mcgroups w/o mcmembers can be created in two ways:

1. By creating well-known mcgroup for a partition.
    In this case when new instance of OSM is launched,
    the same mcgroup should be creted anyway from the
    partition configuration, so no need to force its
    duplication in the SA DB file.

2. By loading mcgroup from SA DB file.
    In this case it's either mcgroup w/o members, which
    is what's handled by (1), or it's mcgroup with members,
    butthe members just weren't loaded yet.

So in both cases, no need to force SA DB dump.

I'll post a new patch shortly - please review and let me
know if you have better ideas.

-- Yevgeny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
