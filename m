From: Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Wed, 07 Jul 2010 01:19:45 +0300
Message-ID: <4C33AC01.5090705@dev.mellanox.co.il>
References: <4C2312F0.8020308@dev.mellanox.co.il>	<20100705181143.GG22860@me>	<AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>	<20100705184144.GH22860@me> <20100706140335.81e25f4c.weiny2@llnl.gov>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100706140335.81e25f4c.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07-Jul-10 12:03 AM, Ira Weiny wrote:
> On Mon, 5 Jul 2010 11:41:44 -0700
> Sasha Khapyorsky<sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  wrote:
>
>> On 14:30 Mon 05 Jul     , Hal Rosenstock wrote:
>>> On Mon, Jul 5, 2010 at 2:11 PM, Sasha Khapyorsky<sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>  wrote:
>>>> On 11:10 Thu 24 Jun     , Yevgeny Kliteynik wrote:
>>>>> Event API should have been able to be used by libraries
>>>>> written both in C and C++.
>>>>
>>>> I don't know about such requirement.
>>>
>>> Are you saying it isn't a valid requirement to allow OpenSM plugins to
>>> be C++ based ? If so, why not ?
>>
>> I'm saying that there is no requirement for plugin API to support C++ -
>> obviously (following method names) plugin API was never developed for
>> using it in C++.
>
> Actually IMO this is not correct.  The use of "delete" was introduced
> by commit a5963f93fa3d4514cc526e4ad029b036724b8167.  I was at fault to
> not have objected back then.  The use of "extern C" in all of the header
> files below implies a desire to support C++.

Couldn't agree more.

-- Yevgeny

> 10:28:14>  pwd; grep "BEGIN_C_DECLS extern" *
> /home/weiny2/OpenIB/git-trees/management/opensm/include/opensm
> osm_attrib_req.h:#  define BEGIN_C_DECLS extern "C" {
> osm_base.h:#  define BEGIN_C_DECLS extern "C" {
> osm_console.h:#  define BEGIN_C_DECLS extern "C" {
> osm_console_io.h:#  define BEGIN_C_DECLS extern "C" {
> osm_db.h:#  define BEGIN_C_DECLS extern "C" {
> osm_db_pack.h:#  define BEGIN_C_DECLS extern "C" {
> osm_event_plugin.h:#  define BEGIN_C_DECLS extern "C" {
> osm_helper.h:#  define BEGIN_C_DECLS extern "C" {
> osm_inform.h:#  define BEGIN_C_DECLS extern "C" {
> osm_lid_mgr.h:#  define BEGIN_C_DECLS extern "C" {
> osm_log.h:#  define BEGIN_C_DECLS extern "C" {
> osm_mad_pool.h:#  define BEGIN_C_DECLS extern "C" {
> osm_madw.h:#  define BEGIN_C_DECLS extern "C" {
> osm_mcast_tbl.h:#  define BEGIN_C_DECLS extern "C" {
> osm_mcm_port.h:#  define BEGIN_C_DECLS extern "C" {
> osm_msgdef.h:#  define BEGIN_C_DECLS extern "C" {
> osm_mtree.h:#  define BEGIN_C_DECLS extern "C" {
> osm_multicast.h:#  define BEGIN_C_DECLS extern "C" {
> osm_node.h:#  define BEGIN_C_DECLS extern "C" {
> osm_opensm.h:#  define BEGIN_C_DECLS extern "C" {
> osm_partition.h:#  define BEGIN_C_DECLS extern "C" {
> osm_path.h:#  define BEGIN_C_DECLS extern "C" {
> osm_perfmgr_db.h:#  define BEGIN_C_DECLS extern "C" {
> osm_pkey.h:#  define BEGIN_C_DECLS extern "C" {
> osm_port.h:#  define BEGIN_C_DECLS extern "C" {
> osm_port_profile.h:#  define BEGIN_C_DECLS extern "C" {
> osm_prefix_route.h:#  define BEGIN_C_DECLS extern "C" {
> osm_remote_sm.h:#  define BEGIN_C_DECLS extern "C" {
> osm_router.h:#  define BEGIN_C_DECLS extern "C" {
> osm_sa.h:#  define BEGIN_C_DECLS extern "C" {
> osm_sa_mad_ctrl.h:#  define BEGIN_C_DECLS extern "C" {
> osm_service.h:#  define BEGIN_C_DECLS extern "C" {
> osm_sm.h:#  define BEGIN_C_DECLS extern "C" {
> osm_sm.h.orig:#  define BEGIN_C_DECLS extern "C" {
> osm_sm_mad_ctrl.h:#  define BEGIN_C_DECLS extern "C" {
> osm_stats.h:#  define BEGIN_C_DECLS extern "C" {
> osm_subnet.h:#  define BEGIN_C_DECLS extern "C" {
> osm_subnet.h.orig:#  define BEGIN_C_DECLS extern "C" {
> osm_switch.h:#  define BEGIN_C_DECLS extern "C" {
> osm_ucast_cache.h:#  define BEGIN_C_DECLS extern "C" {
> osm_ucast_mgr.h:#  define BEGIN_C_DECLS extern "C" {
> osm_vl15intf.h:#  define BEGIN_C_DECLS extern "C" {
> st.h:#  define BEGIN_C_DECLS extern "C" {
>
> Ira
>
>>
>> Why not is another question - for instance in order to not deal with
>> C/C++ compatibility issues (such as castings, function names limitation,
>> linking mess, etc.)
>>
>> Sasha
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
