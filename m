From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: opensm with multiple IB subnets
Date: Thu, 22 Apr 2010 17:38:38 +0300
Message-ID: <4BD05F6E.3010606@dev.mellanox.co.il>
References: <k2s2d0a59b21004201413ia115ae29u661f8df428d5ad08@mail.gmail.com>
	<u2q2d0a59b21004201707gecf7f978pa585ada342ccb9b6@mail.gmail.com>
	<4BCF1215.7070601@dev.mellanox.co.il> <4BD05BD2.9000600@salasaga.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BD05BD2.9000600-oNuxUQfTmABg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Clift <justin-oNuxUQfTmABg9hUCZPvPmw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/22/2010 5:23 PM, Justin Clift wrote:
> We should really put this on the wiki. :)

Good idea :)

-- Yevgeny
  
>
> On 04/22/2010 12:56 AM, Yevgeny Kliteynik wrote:
> <snip>
>> OpenSM dumps various files to /var/log and /var/cache/opensm folders.
>> When you have more than one OpenSM process, they will all dump the
>> same files, which is probably not a good idea.
>>
>> To change the output directories, set the OSM_TMP_DIR and
>> OSM_CACHE_DIR env. variables to some other place.
>> In addition, you need to make sure that each SM instance
>> prints its log in a different place. You need to do
>> something like this:
>>
>> foreach guid in guid_list
>> export OSM_TMP_DIR=/tmp/osm_dump_dir${guid}
>> export OSM_CACHE_DIR=/tmp/osm_dump_dir${guid}
>> opensm --log_file /tmp/osm_dump_dir${guid}/osm.log -g ${guid} [your
>> other options]
>>
>> -- Yevgeny
> <snip>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
