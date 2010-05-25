From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] use macro for tmp file path
Date: Tue, 25 May 2010 08:25:50 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562F581F0@orsmsx501.amr.corp.intel.com>
References: <3F6F638B8D880340AB536D29CD4C1E192562EBBB00@orsmsx501.amr.corp.intel.com>
 <20100525110206.GO28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100525110206.GO28549@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 09:51 Fri 21 May     , Smith, Stan wrote:
>>
>> Use defined macro for tmp file path
>>
>> signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>
> The patch is whitespece-mangled.
>
>> diff --git a/opensm/opensm/st.c b/opensm/opensm/st.c
>> index ea76038..2d39117 100644
>> --- a/opensm/opensm/st.c
>> +++ b/opensm/opensm/st.c
>> @@ -174,7 +174,7 @@ static int init_st = 0;
>>
>>  static void stat_col()
>>  {
>> -       FILE *f = fopen("/var/log/osm_st_col", "w");
>> +       FILE *f = fopen( OSM_DEFAULT_TMP_DIR "osm_st_col", "w");
>
> I think it was discussed somehow in the past.
>
> Shouldn't this be:
>
>       OSM_DEFAULT_TMP_DIR "/osm_st_col"
>
> , so that trailing '/' will not be mandatory in directory define?

Currently OSM_DEFAULT_TMP_DIR is defined with a trailing directory delimiter.
Having the delimiter in the OSM_DEFAULT_TMP_DIR makes it easier to be consistent with \ or /.
Will resend this patch as I think I've figured out the mangled email story.

>
> Sasha
>
>>         fprintf(f, "collision: %d\n", collision);
>>         fclose(f);
>>  }
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
