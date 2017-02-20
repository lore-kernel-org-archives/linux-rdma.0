From: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: iSER fails to release rdma resources (WRs) if iw_cxgb4 is
 unloaded while IO is in progress
Date: Mon, 20 Feb 2017 12:46:34 +0000
Message-ID: <AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0@AM4PR0501MB2786.eurprd05.prod.outlook.com>
References: <CY1PR12MB077405C1FA5279D200AD3089BC4D0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <49223bb6-e2a1-eee7-cf4e-701957e6727f@mellanox.com>
 <CY1PR12MB07749731AC32F7BE065CC51DBC4C0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <c0a53feb-8c15-54af-c443-fbc4f3d5ec0e@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="_002_AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0AM4PR0501MB2786_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c0a53feb-8c15-54af-c443-fbc4f3d5ec0e-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0AM4PR0501MB2786_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Raju,
Try this patch that solve this problem, it checked with our tests.
Thanks,
Vladimir


-----Original Message-----
From: Max Gurtovoy=20
Sent: Sunday, February 19, 2017 11:23 AM
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>; Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>; lin=
ux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>; Potnuri Bharat Teja <bharat@ch=
elsio.com>; Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is unlo=
aded while IO is in progress

Adding Vladimir that was debugging this issue.

Sagi,
there is a comment that was added in commit 3a940daf6fa1 "IB/iser:=20
Protect tasks cleanup in case IB device was already released"
that "DEVICE_REMOVAL event might have already released the device"
but it is possible and this is the case now, that not all the tasks where c=
leaned up. We actually destroy the low level structures but the upper layer=
 (iscsi) still has some tasks that should be cleaned.
Also we need to think about the case of the absence of the iscsid and this =
makes the situation more difficult.

Vladimir,
please add your patch for Raju to check and let's start thinking of pushing=
 this fix to main code.

Max.


On 2/2/2017 7:09 AM, Raju  Rangoju wrote:
> Hi Max,
>
> I have tried the patch, but no luck. Issue is still seen.
>
> -Raju
>
> -----Original Message-----
> From: Max Gurtovoy [mailto:maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: 01 February 2017 20:48
> To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>; Sagi Grimberg=20
> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>; Potnuri Bharat Teja=20
> <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is=20
> unloaded while IO is in progress
>
> hi Raju,
> please apply the attached patch I want to push soon (still haven't find t=
he chance to test it).
> I'm not sure it will solve your problem but let's try it.
>
> thanks,
> Max.
>
> On 2/1/2017 11:08 AM, Raju  Rangoju wrote:
>>
>> Hello Sagi,
>>
>> I intermittently see an issue with iser when unloading the iw_cxgb4 modu=
le while traffic is running. Apparently the rdma resources are not getting =
released when the iser receives RDMA_CM_EVENT_DEVICE_REMOVAL event while th=
e IO in progress. iser_cma_handler() upon receiving the DEVICE_REMOVAL even=
t, destroys the device by calling iser_cleanup_handler(). iser_free_ib_conn=
_res() destroys the qp and calls iser_free_fastreg_pool() to free the Memor=
y Regions in the fastreg_pool list, and then it calls ib_dealloc_pd.
>>
>> Issue:
>>
>> iSCSI uses its .xmit_task and .cleanup_task callbacks to get/put MRs fro=
m iser fr_pool(fastreg_pool) during the normal IO, at this point if the DEV=
ICE_REMOVAL event is received, iser_cma_handler()->iser_cleanup_handler() i=
t simply releases the available MRs in the fr_pool list (some MRs may have =
been moved to running task list) and eventually calls ib_dealloc_pd, which =
ends up hitting kernel panic as some registered MRs are not freed up.
>>
>> iser_free_fastreg_pool() complains about the registered regions; "pool s=
till has %d regions registered"
>>
>> Trace:
>>
>> iser: iser_free_fastreg_pool: pool still has 1 regions registered
>> iser: iser_device_try_release: device ffff880508660080 refcount 0=20
>> iw_cxgb4:c4iw_destroy_cq ib_cq ffff8803f3addc00=20
>> iw_cxgb4:c4iw_wait_for_reply add wr_waitp ffffc9000dd83a28=20
>> ------------[ cut here ]------------
>> WARNING: CPU: 7 PID: 14790 at drivers/infiniband/core/verbs.c:305
>> ib_dealloc_pd+0x87/0xd0 [ib_core] Modules linked in: rdma_ucm ib_uverbs =
iw_cxgb4(OE-) autofs4 target_core_iblock target_core_file target_core_pscsi=
 target_core_mod bnx2fc fcoe libfcoe 8021q libfc garp stp llc scsi_transpor=
t_fc cpufreq_ondemand be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcx=
gbi iw_cxgb3 cxgb3 mdio libcxgb ib_iser rdma_cm ib_cm iw_cm ib_core configf=
s ipv6 crc_ccitt iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi uinpu=
t ppdev iTCO_wdt iTCO_vendor_support serio_raw pcspkr parport_pc parport tp=
m_infineon sg i2c_i801 i2c_core lpc_ich mfd_core e1000e acpi_cpufreq i7core=
_edac edac_core ioatdma dca ext4(E) mbcache(E) jbd2(E) sd_mod(E) pata_acpi(=
E) ata_generic(E) ata_piix(E) floppy(E) cxgb4(OE) ptp(E) pps_core(E) dm_mir=
ror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
>> CPU: 7 PID: 14790 Comm: rmmod Tainted: G           OE   4.10.0-rc4+ #22
>> Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0        07/29/10
>> Call Trace:
>> dump_stack+0x51/0x78
>> __warn+0xfd/0x120
>> warn_slowpath_null+0x1d/0x20
>> ib_dealloc_pd+0x87/0xd0 [ib_core]
>> ? ib_unregister_event_handler+0x6d/0x80 [ib_core] ?
>> mutex_lock+0x16/0x40
>> iser_device_try_release+0x81/0x120 [ib_iser] ?
>> iser_free_rx_descriptors+0xd3/0xf0 [ib_iser]
>> iser_free_ib_conn_res+0x75/0xb0 [ib_iser]
>> iser_cleanup_handler+0x41/0x70 [ib_iser]
>> iser_cma_handler+0x1c9/0x220 [ib_iser]
>> cma_remove_id_dev+0x8f/0xa0 [rdma_cm]
>> cma_process_remove+0x127/0x170 [rdma_cm] ? kobject_cleanup+0x82/0x1b0=20
>> ? kobject_release+0xd/0x10
>> cma_remove_one+0x6f/0x90 [rdma_cm]
>> ib_unregister_device+0xe7/0x190 [ib_core]
>> c4iw_unregister_device+0x79/0x90 [iw_cxgb4] c4iw_remove+0x45/0x6c=20
>> [iw_cxgb4]
>> c4iw_exit_module+0x31/0x75 [iw_cxgb4]
>> SyS_delete_module+0x183/0x1d0
>> ? syscall_trace_enter+0x154/0x1f0
>> ? SyS_munmap+0x6e/0x90
>> do_syscall_64+0x6c/0x160
>> entry_SYSCALL64_slow_path+0x25/0x25
>> RIP: 0033:0x37d22e8ee7
>> RSP: 002b:00007ffedd1877b8 EFLAGS: 00000206 ORIG_RAX:=20
>> 00000000000000b0
>> RAX: ffffffffffffffda RBX: 00007ffedd1877c0 RCX: 00000037d22e8ee7
>> RDX: 00007ffedd1877af RSI: 0000000000000880 RDI: 00007ffedd1877c0
>> RBP: 00007ffedd187810 R08: 00007f0120b48700 R09: 0000000000000100
>> R10: 0000000000000011 R11: 0000000000000206 R12: 0000000000000880
>> R13: 00007ffedd188735 R14: 0000000000000000 R15: 0000000000000001=20
>> ---[ end trace 9bdbdddd5759d7e6 ]---
>>
>>
>> Steps to reproduce:
>> 1. Bring up the iser target setup
>> 2. Bring up the iser initiator setup
>> 3. From DUT(initiator) login to all the Targets and start IOzone traffic=
 on all the mounted luns.
>> 4. Now unload iw_cxgb4 module on the iser initiator setup.
>>
>>
>> This is a generic issue, seen with other vendors also.
>>
>> Could you give me a few pointers on how to debug it further to address t=
his issue?
>> I am happy to provide any details further.
>>
>> Thank you for any help you can provide, -Raju
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=20
>> info at  http://vger.kernel.org/majordomo-info.html
>>

--_002_AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0AM4PR0501MB2786_
Content-Type: application/octet-stream;
	name="0001-B-iser-Fix-leak-of-fast-regmem-descriptors.patch"
Content-Description: 0001-B-iser-Fix-leak-of-fast-regmem-descriptors.patch
Content-Disposition: attachment;
	filename="0001-B-iser-Fix-leak-of-fast-regmem-descriptors.patch"; size=3361;
	creation-date="Mon, 20 Feb 2017 12:32:48 GMT";
	modification-date="Mon, 20 Feb 2017 10:13:06 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwMGVkMGM1NzA4MjljMWY4ZjVlZDc0NGFhNGQxMzdhZDkxYzBiNDg4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiByb290IDx2bGFkaW1pcm5AbWVsbGFub3guY29tPgpEYXRlOiBN
b24sIDIwIEZlYiAyMDE3IDEyOjA2OjM3ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gQi9pc2VyOiBG
aXggbGVhayBvZiBmYXN0IHJlZ21lbSBkZXNjcmlwdG9ycwoKV2hlbiBJQiBwb3J0IGlzIGRvd24g
aXNlciBnZXQgZXZlbnQgREVWSUNFX1JFTU9WQUwgZnJvbSByZG1hLgpUaGlzIGV2ZW50IGNsZWFu
dXAgYWxsIHJlc291cmNlcyBhbGxvY2F0ZWQgdG8gcmRtYSBjb25uZWN0aW9uLgpCdXQgaXNjc2kg
ZGFlbW9uIHNlbmQgMiBjb21tYW5kIEVQX0RJU0NPTk5FQ1QgYW5kIEVQX0NPTk5FQ1RJT05fU1RP
UAp0aGF0IGRvIHNhbWUgdGhpbmdzIGFzIERFVklDRV9SRU1PVkFMLiBJZiBwb3J0IGdvZXMgZG93
biBkdXJpbmcgSU8KYW5kIERFVklDRV9SRU1PVkFMIGZpbmlzaCBpdCB3b3JrIGFuZCB0cnkgdG8g
Y2xlYW51cCByZXNvdWNlcywgbm90IGFsbApJT3MgZmluaXNoZWQgYW5kIHdlIGdldCB3YXJuaW5n
LiBFUF9DT05ORUNUSU9OX1NUT1AgdHJ5IHRvIHJlbGVhc2UgbGFzdCBJT3MKaW4gZnVuY3Rpb24g
aXNjc2lfaXNlcl9jbGVhbnVwX3Rhc2sgYnV0IGlzZXIgZGV2aWNlIGFscmVhZHkgY2xvc2VkIGFu
ZApmYXN0IG1lbW9yeSByZWdpc3RyYXRpb24gZGVzY3JpcHRvcnMgd2FzIG5vdCByZXR1cm5lZCB0
byBmcmVlIHBvbGwgaW4KaXNlciBtb2R1bGUuIEkgYWRkZWQgYWRkaXRpb25hbCBmdWxsIGxpbmsg
bGlzdCBvZiBmYXN0IG1lbXJlZyBkZXNjcmlwdG9ycy4gSQphZGRlZCB0byB0aGlzIGxpc3QgYWxs
IGRlc2NyaXB0b3JzLiBERVZJQ0VfUkVNT1ZBTCBmcmVlIGFsbCBkZXNjcmlwdG9ycyBmcm9tCm9y
aWdpbmFsIGxpc3QgYW5kIGZyb20gZnVsbCBsaXN0LiBBbmQgaWYgb3JpZ2luYWwgbGlzdCBub3Qg
Y29udGFpbiBhbGwKZGVzY3JpcHRvcnMgd2UgY29udGludWUgdG8gZnJlZSBkZXNjcmlwdG9ycyBm
cm9tIGZ1bGwgbGlzdC4KClNpZ25lZC1vZmYtYnk6IHJvb3QgPHZsYWRpbWlybkBtZWxsYW5veC5j
b20+Ci0tLQogZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VyL2lzY3NpX2lzZXIuaCB8ICAyICsr
CiBkcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl92ZXJicy5jIHwgMTYgKysrKysrKysr
KysrKystLQogMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2NzaV9pc2VyLmgg
Yi9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNjc2lfaXNlci5oCmluZGV4IDlkMGIyMmEu
LmQ2MWExYmEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2NzaV9p
c2VyLmgKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VyL2lzY3NpX2lzZXIuaApAQCAt
NDMwLDYgKzQzMCw3IEBAIHN0cnVjdCBpc2VyX2ZyX2Rlc2MgewogCXN0cnVjdCBsaXN0X2hlYWQJ
CSAgbGlzdDsKIAlzdHJ1Y3QgaXNlcl9yZWdfcmVzb3VyY2VzCSAgcnNjOwogCXN0cnVjdCBpc2Vy
X3BpX2NvbnRleHQJCSAqcGlfY3R4OworCXN0cnVjdCBsaXN0X2hlYWQgICAgICAgICAgICAgICAg
ICBwb29sX2xpc3Q7CiB9OwogCiAvKioKQEAgLTQ0Myw2ICs0NDQsNyBAQCBzdHJ1Y3QgaXNlcl9m
cl9wb29sIHsKIAlzdHJ1Y3QgbGlzdF9oZWFkICAgICAgICBsaXN0OwogCXNwaW5sb2NrX3QgICAg
ICAgICAgICAgIGxvY2s7CiAJaW50ICAgICAgICAgICAgICAgICAgICAgc2l6ZTsKKwlzdHJ1Y3Qg
bGlzdF9oZWFkCXBvb2xfbGlzdDsKIH07CiAKIC8qKgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZp
bmliYW5kL3VscC9pc2VyL2lzZXJfdmVyYnMuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNl
ci9pc2VyX3ZlcmJzLmMKaW5kZXggNmE5ZDFjYi4uMjYxYjM2NyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9pbmZpbmliYW5kL3VscC9pc2VyL2lzZXJfdmVyYnMuYworKysgYi9kcml2ZXJzL2luZmluaWJh
bmQvdWxwL2lzZXIvaXNlcl92ZXJicy5jCkBAIC0zNjIsNiArMzYyLDcgQEAgaW50IGlzZXJfYWxs
b2NfZmFzdHJlZ19wb29sKHN0cnVjdCBpYl9jb25uICppYl9jb25uLAogCWludCBpLCByZXQ7CiAK
IAlJTklUX0xJU1RfSEVBRCgmZnJfcG9vbC0+bGlzdCk7CisJSU5JVF9MSVNUX0hFQUQoJmZyX3Bv
b2wtPnBvb2xfbGlzdCk7CiAJc3Bpbl9sb2NrX2luaXQoJmZyX3Bvb2wtPmxvY2spOwogCWZyX3Bv
b2wtPnNpemUgPSAwOwogCWZvciAoaSA9IDA7IGkgPCBjbWRzX21heDsgaSsrKSB7CkBAIC0zNzMs
NiArMzc0LDcgQEAgaW50IGlzZXJfYWxsb2NfZmFzdHJlZ19wb29sKHN0cnVjdCBpYl9jb25uICpp
Yl9jb25uLAogCQl9CiAKIAkJbGlzdF9hZGRfdGFpbCgmZGVzYy0+bGlzdCwgJmZyX3Bvb2wtPmxp
c3QpOworCQlsaXN0X2FkZF90YWlsKCZkZXNjLT5wb29sX2xpc3QsICZmcl9wb29sLT5wb29sX2xp
c3QpOwogCQlmcl9wb29sLT5zaXplKys7CiAJfQogCkBAIC0zOTksNiArNDAxLDcgQEAgdm9pZCBp
c2VyX2ZyZWVfZmFzdHJlZ19wb29sKHN0cnVjdCBpYl9jb25uICppYl9jb25uKQogCiAJbGlzdF9m
b3JfZWFjaF9lbnRyeV9zYWZlKGRlc2MsIHRtcCwgJmZyX3Bvb2wtPmxpc3QsIGxpc3QpIHsKIAkJ
bGlzdF9kZWwoJmRlc2MtPmxpc3QpOworCQlsaXN0X2RlbCgmZGVzYy0+cG9vbF9saXN0KTsKIAkJ
aXNlcl9mcmVlX3JlZ19yZXMoJmRlc2MtPnJzYyk7CiAJCWlmIChkZXNjLT5waV9jdHgpCiAJCQlp
c2VyX2ZyZWVfcGlfY3R4KGRlc2MtPnBpX2N0eCk7CkBAIC00MDYsOSArNDA5LDE4IEBAIHZvaWQg
aXNlcl9mcmVlX2Zhc3RyZWdfcG9vbChzdHJ1Y3QgaWJfY29ubiAqaWJfY29ubikKIAkJKytpOwog
CX0KIAotCWlmIChpIDwgZnJfcG9vbC0+c2l6ZSkKLQkJaXNlcl93YXJuKCJwb29sIHN0aWxsIGhh
cyAlZCByZWdpb25zIHJlZ2lzdGVyZWRcbiIsCisJaWYgKGkgPCBmcl9wb29sLT5zaXplKSB7CisJ
CWlzZXJfd2FybigiZnJlZWluZyAlZCByZWdpc3RlcmVkIHJlZ2lvbnMgZnJvbSBmdWxsIGZyIHBv
b2xcbiIsCiAJCQkgIGZyX3Bvb2wtPnNpemUgLSBpKTsKKworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5
X3NhZmUoZGVzYywgdG1wLCAmZnJfcG9vbC0+cG9vbF9saXN0LCBwb29sX2xpc3QpIHsKKwkJCWxp
c3RfZGVsKCZkZXNjLT5wb29sX2xpc3QpOworCQkJaXNlcl9mcmVlX3JlZ19yZXMoJmRlc2MtPnJz
Yyk7CisJCQlpZiAoZGVzYy0+cGlfY3R4KQorCQkJCWlzZXJfZnJlZV9waV9jdHgoZGVzYy0+cGlf
Y3R4KTsKKwkJCWtmcmVlKGRlc2MpOworCQl9CisJfQogfQogCiAvKioKLS0gCjEuOC40LjMKCg==

--_002_AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0AM4PR0501MB2786_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
