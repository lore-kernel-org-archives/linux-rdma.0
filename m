From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Add per module logging support
Date: Tue, 05 Jun 2012 13:53:04 -0400
Message-ID: <4FCE4780.7010201@dev.mellanox.co.il>
References: <4FC6918A.9080503@dev.mellanox.co.il> <1338856118.17237.927.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338856118.17237.927.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/4/2012 8:28 PM, Jim Foraker wrote:
> 
> On Wed, 2012-05-30 at 14:30 -0700, Hal Rosenstock wrote:
>> Add _v2 APIs for osm_log, osm_log_is_active, and osm_log_msg_box
>> Also, add these to libopensm.map
>> Add _V2 forms of the various OSM_LOG macros
>      Why are the _V2 macros necessary?  It appears that the calling
> semantics/effect are the same, so why create new macros instead of
> reusing the old ones?  In particular, it seems like you could move the
> FILE_ID defines above the #includes, and then in osm_log.h say things
> like:
> 
> #ifdef FILE_ID
> #define OSM_LOG_ENTER( OSM_LOG_PTR ) \
>         osm_log_v2( OSM_LOG_PTR, OSM_LOG_FUNCS, FILE_ID, \
>                     "%s: [\n", __func__);
> #else
> #define OSM_LOG_ENTER( OSM_LOG_PTR ) \
>         osm_log( OSM_LOG_PTR, OSM_LOG_FUNCS, \
>                  "%s: [\n", __func__);
> #endif

Good idea; I'll rework the patch.

>      Or just define FILE_ID everywhere (it seems to be missing from many
> of the libvendor files) 

Most of libvendor files are historical and on verge of deprecation so it
wasn't worth the effort there.

> and make OSM_LOG* always call the v2 functions.

> It seems like this would drastically reduce the patch's footprint.

If by footprint, you mean changed lines of code (rather than object code
size), then yes, this makes sense.

>>
>> All of above pass additional parameter to identify module.
>> Each module defines a unique FILE_ID from 0-254.
>> 255 is reserved to indicate "name not found".
>> FILE_ID must match index in osm_subnet.c:module_name_str
>> table. Note also currently that subnet's
>> per_mod_log_tbl is 128 entries (which is enough
>> more than the number of modules).
>>  
>      Why are there so many magic numbers here?

There are 2 magic numbers. One is to use 255 as not found rather than
explicit status. 128 is to limit the array size but that can be
eliminated at the cost of the array size being larger.

> It seems like
> per_mod_log_tbl's size could be defined in terms of the final value in
> osm_file_ids_enum (ie, you could add a OSM_FILE_LAST_ENTRY to the enum).
> If find_module_name() is changed to return an int (which is what
> osm_log_v2() already uses as file_id's type, so consistency would be
> improved), it could return -1 on failure, making the limit at 255
> irrelevant as well.

Yes, that is an alternative to using 255 as indicating this.

>      Also, how is this expected to work with plugins?  Will plugins be
> expected to use their own logging?

Plugins still use the original/coarse logging or their own logging. In
order to use the per module logging, they'd need to reserve file IDs.

>      Would it be desirable to put FILE_ID (or better yet, module name)
> into the log messages as well?  This would make it a bit easier to find
> where the relevant code is.  We could then phase out the "ERR XXYY"
> scheme, particularly since the XX numbers do not seem to correlate at
> all with FILE_ID.

If we decide to change the ERR logs to include name all we need is __FILE__.

If we want to keep current ERR XXYY scheme, for modules with FILE_ID
that could be used as the XX in ERR XXYY. The issues with doing this are
with original logging uses where that's not the case and any conflict
between FILE_ID as the XX in the ERR and the current ERR XXs used now.
Anyhow, this seems like a follow on patch and needs more discussion/thought.

-- Hal

>      Jim
> 
>>
>> Use version 2 API (osm_log_v2) and macros (OSM_LOG_V2_xxxx)
>> in OpenSM client code
>>
>> Added options to enable/disable per module logging and
>> it's configuration file
>>
>> Config file format
>> Set of lines with module name and logging level as follows:
>> <module name><separator><logging level>
>> where:
>> module name is file name including .c
>> separator is either = , space, or tab
>> logging level is the same levels as used in the coarse/overall logging
>> as follows:
>>
>>  BIT    LOG LEVEL ENABLED
>>  ----   -----------------
>>  0x01 - ERROR (error messages)
>>  0x02 - INFO (basic messages, low volume)
>>  0x04 - VERBOSE (interesting stuff, moderate volume)
>>  0x08 - DEBUG (diagnostic, high volume)
>>  0x10 - FUNCS (function entry/exit, very high volume)
>>  0x20 - FRAMES (dumps all SMP and GMP frames)
>>  0x40 - ROUTING (dump FDB routing information)
>>  0x80 - currently unused
>>
>> Add parsing of the configuration file into table of log levels
>> indexed by FILE_ID
>>
>> Added osm_get_log_per_module routine to obtain the configured info
>> for a supplied module name. This is a new library function.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> As this patch is too large for email, please find this @
>> https://www.openfabrics.org/~halr/0001-opensm-Add-per-module-logging-support.patch
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
