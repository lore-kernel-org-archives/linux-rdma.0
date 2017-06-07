From: "Thomas Rosenstein" <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Subject: Re: iSER Connection via LIO not working
Date: Wed, 07 Jun 2017 20:46:59 +0200
Message-ID: <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
 <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_MailMate_8E709BDE-BEBC-400D-ABF1-564D996D3831_="
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=_MailMate_8E709BDE-BEBC-400D-ABF1-564D996D3831_=
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

lio config (extract - .json file attached)

o- iscsi =

=2E......................................................................=
=2E................... =

[1-way disc auth, Targets: 1]
   | o- iqn.2017-01.at.cf-it.at-storage-01 =

=2E......................................................................=
=2E........ =

[TPGs: 1]
   |   o- tpg1 =

=2E......................................................................=
=2E.................. =

[no-gen-acls, auth per-acl]
   |     o- acls =

=2E......................................................................=
=2E.................................. =

[ACLs: 1]
   |     | o- iqn.2017-01.at.cf-it.kubernetes.db-1 =

=2E.................................................... [1-way auth, =

Mapped LUNs: 1]
   |     |   o- mapped_lun0 =

=2E..................................................................... =

[lun0 fileio/kubernetes_db_1 (rw)]
   |     o- luns =

=2E......................................................................=
=2E.................................. =

[LUNs: 1]
   |     | o- lun0 .......................................... =

[fileio/kubernetes_db_1 (/data/kubernetes_storage/kubernetes_db_1.img)]
   |     o- portals =

=2E......................................................................=
=2E............................ =

[Portals: 1]
   |       o- 0.0.0.0:3260 =

=2E......................................................................=
=2E........................... =

[iser]

at-storage-01 modules:

ib_isert               49152  4
iscsi_target_mod      294912  8 ib_isert
ib_iser                49152  0
libiscsi               57344  1 ib_iser
scsi_transport_iscsi    98304  2 ib_iser,libiscsi
target_core_mod       352256  43 =

iscsi_target_mod,ib_isert,target_core_iblock,ib_srpt,target_core_user,tar=
get_core_file,target_core_pscsi
rdma_cm                53248  4 ib_iser,ib_isert,rpcrdma,rdma_ucm
ib_core               208896  15 =

ib_iser,ib_cm,rdma_cm,ib_umad,ib_srp,ib_isert,ib_uverbs,rpcrdma,ib_ipoib,=
iw_cm,ib_srpt,ib_ucm,rdmavt,ib_qib,rdma_ucm

at-host-18 modules:

ib_isert               49152  0
iscsi_target_mod      299008  1 ib_isert
ib_iser                49152  0
libiscsi               57344  1 ib_iser
scsi_transport_iscsi    98304  3 ib_iser,libiscsi
target_core_mod       352256  3 iscsi_target_mod,ib_isert,ib_srpt
rdma_cm                53248  4 ib_iser,ib_isert,rpcrdma,rdma_ucm
ib_core               208896  15 =

ib_iser,ib_cm,rdma_cm,ib_umad,ib_srp,ib_isert,ib_uverbs,rpcrdma,ib_ipoib,=
iw_cm,ib_srpt,ib_ucm,rdmavt,ib_qib,rdma_ucm


Commands to initialize iscsiadm:

iscsiadm -m discovery -t st -p 10.0.13.3:3260 -I iser

iscsiadm -m node -P 1
Target: iqn.2017-01.at.cf-it.at-storage-01
	Portal: 10.0.13.3:3260,1
		Iface Name: iser

iscsiadm -m node -l

->> creates the logs


@deleted and recreated, multiple times
ib_isert and ib_iser are loaded on both servers

BR
Thomas

On 7 Jun 2017, at 20:35, Robert LeBlanc wrote:

> Can you post the config for lio and the iscsiadm commands you are
> using? Have you deleted the record from the discoverydb and
> rediscovered? You need to be sure the enable_iser boolean is set on
> the target and that the modules (ib_isert and ib_iser) are loaded.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Wed, Jun 7, 2017 at 12:15 PM, Thomas Rosenstein
> <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org> wrote:
>> Hello,
>>
>> i have setup a lio with 1 LUN on kernel 4.9.11, works fine via iSCSI, =

>> but
>> when switching to iSER the message logs are spammed with:
>>
>> Jun  7 17:59:57 at-host-18 kernel: iser: iser_fast_reg_fmr:
>> ib_fmr_pool_map_phys failed: -22
>> Jun  7 17:59:57 at-host-18 kernel: iser: iser_prepare_read_cmd: =

>> Failed to
>> set up Data-IN RDMA
>> Jun  7 17:59:57 at-host-18 kernel: iser: iser_send_command: conn
>> ffff88239eaf3b30 failed task->itt 127 err -22
>>
>> Based on the error I found that there was a bug in 4.5.x rc Kernels =

>> and
>> therefore tried 4.4.71, 4.9.31 and 4.9.27 but all of them have =

>> exactly the
>> same behaviour.
>>
>> I got HP DL160 (SE316) with QLogic Infiniband Adapters connected via =

>> a HP
>> Voltair switch.
>>
>> ibnetdiag says everything is fine.
>> Network via ib0 works without issues (can mount the iSCSI via that).
>> rdma_server and rdma_client both are successful (end 0)
>>
>> ib_read_bw 10.0.13.3
>> ----------------------------------------------------------------------=
-----------------
>> Device not recognized to implement inline feature. Disabling it
>> ----------------------------------------------------------------------=
-----------------
>>                     RDMA_Read BW Test
>>  Dual-port       : OFF          Device         : qib0
>>  Number of qps   : 1            Transport type : IB
>>  Connection type : RC           Using SRQ      : OFF
>>  TX depth        : 128
>>  CQ Moderation   : 100
>>  Mtu             : 4096[B]
>>  Link type       : IB
>>  Outstand reads  : 16
>>  rdma_cm QPs     : OFF
>>  Data ex. method : Ethernet
>> ----------------------------------------------------------------------=
-----------------
>>  local address: LID 0x04 QPN 0x0017 PSN 0xd20eae OUT 0x10 RKey =

>> 0x2d2d300
>> VAddr 0x007f892ea78000
>>  remote address: LID 0x13 QPN 0x0d7d PSN 0x66ee4e OUT 0x10 RKey =

>> 0x070800
>> VAddr 0x007fcf485ee000
>> ----------------------------------------------------------------------=
-----------------
>>  #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]
>> MsgRate[Mpps]
>>  65536      1000             3256.60            3156.37            =

>> 0.050502
>> ----------------------------------------------------------------------=
-----------------
>>
>> ib_send_bw 10.0.13.3
>> ----------------------------------------------------------------------=
-----------------
>>                     Send BW Test
>>  Dual-port       : OFF          Device         : qib0
>>  Number of qps   : 1            Transport type : IB
>>  Connection type : RC           Using SRQ      : OFF
>>  TX depth        : 128
>>  CQ Moderation   : 100
>>  Mtu             : 4096[B]
>>  Link type       : IB
>>  Max inline data : 0[B]
>>  rdma_cm QPs     : OFF
>>  Data ex. method : Ethernet
>> ----------------------------------------------------------------------=
-----------------
>>  local address: LID 0x04 QPN 0x0019 PSN 0xae4e4c
>>  remote address: LID 0x13 QPN 0x0d89 PSN 0xd25041
>> ----------------------------------------------------------------------=
-----------------
>>  #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]
>> MsgRate[Mpps]
>>  65536      1000             3232.96            3232.92            =

>> 0.051727
>> ----------------------------------------------------------------------=
-----------------
>>
>> ib_read and ib_send also look fine. (Throughput as expected with 3.2 =

>> GB/s -
>> 40 Gbit/s QDR)
>>
>> Also srpt is working, but I need iSCSI.
>>
>>
>>
>>
>> Does anyone know what the issue could be, or how I can better analyze =

>> what's
>> happening there?
>>
>> Thanks
>> BR
>> Thomas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =

>> in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=_MailMate_8E709BDE-BEBC-400D-ABF1-564D996D3831_=
Content-Disposition: attachment; filename=saveconfig.json
Content-Type: application/json
Content-Transfer-Encoding: base64

ewogICJmYWJyaWNfbW9kdWxlcyI6IFsKICAgIHsKICAgICAgImRpc2NvdmVyeV9lbmFibGVfYXV0
aCI6IHRydWUsIAogICAgICAiZGlzY292ZXJ5X3Bhc3N3b3JkIjogImt1YmVybmV0ZXMiLCAKICAg
ICAgImRpc2NvdmVyeV91c2VyaWQiOiAia3ViZXJuZXRlcyIsIAogICAgICAibmFtZSI6ICJpc2Nz
aSIKICAgIH0KICBdLCAKICAic3RvcmFnZV9vYmplY3RzIjogWwogICAgewogICAgICAiYXR0cmli
dXRlcyI6IHsKICAgICAgICAiYmxvY2tfc2l6ZSI6IDUxMiwgCiAgICAgICAgImVtdWxhdGVfM3Bj
IjogMSwgCiAgICAgICAgImVtdWxhdGVfY2F3IjogMSwgCiAgICAgICAgImVtdWxhdGVfZHBvIjog
MSwgCiAgICAgICAgImVtdWxhdGVfZnVhX3JlYWQiOiAxLCAKICAgICAgICAiZW11bGF0ZV9mdWFf
d3JpdGUiOiAxLCAKICAgICAgICAiZW11bGF0ZV9tb2RlbF9hbGlhcyI6IDEsIAogICAgICAgICJl
bXVsYXRlX3Jlc3RfcmVvcmQiOiAwLCAKICAgICAgICAiZW11bGF0ZV90YXMiOiAxLCAKICAgICAg
ICAiZW11bGF0ZV90cHUiOiAwLCAKICAgICAgICAiZW11bGF0ZV90cHdzIjogMCwgCiAgICAgICAg
ImVtdWxhdGVfdWFfaW50bGNrX2N0cmwiOiAwLCAKICAgICAgICAiZW11bGF0ZV93cml0ZV9jYWNo
ZSI6IDEsIAogICAgICAgICJlbmZvcmNlX3ByX2lzaWRzIjogMSwgCiAgICAgICAgImZvcmNlX3By
X2FwdHBsIjogMCwgCiAgICAgICAgImlzX25vbnJvdCI6IDAsIAogICAgICAgICJtYXhfdW5tYXBf
YmxvY2tfZGVzY19jb3VudCI6IDEsIAogICAgICAgICJtYXhfdW5tYXBfbGJhX2NvdW50IjogODE5
MiwgCiAgICAgICAgIm1heF93cml0ZV9zYW1lX2xlbiI6IDQwOTYsIAogICAgICAgICJvcHRpbWFs
X3NlY3RvcnMiOiAxNjM4NCwgCiAgICAgICAgInBpX3Byb3RfZm9ybWF0IjogMCwgCiAgICAgICAg
InBpX3Byb3RfdHlwZSI6IDAsIAogICAgICAgICJxdWV1ZV9kZXB0aCI6IDEyOCwgCiAgICAgICAg
InVubWFwX2dyYW51bGFyaXR5IjogMSwgCiAgICAgICAgInVubWFwX2dyYW51bGFyaXR5X2FsaWdu
bWVudCI6IDAsIAogICAgICAgICJ1bm1hcF96ZXJvZXNfZGF0YSI6IDAKICAgICAgfSwgCiAgICAg
ICJkZXYiOiAiL2RhdGEvYXRfaG9zdF8wMi5pbWciLCAKICAgICAgIm5hbWUiOiAiQVRfSE9TVF8w
MiIsIAogICAgICAicGx1Z2luIjogImZpbGVpbyIsIAogICAgICAic2l6ZSI6IDEwNzM3NDE4MjQw
MDAsIAogICAgICAid3JpdGVfYmFjayI6IHRydWUsIAogICAgICAid3duIjogIjI1MDhlMjY0LTY2
ZjYtNDBlYS05MTNjLTAzOTVkMTQ4MmFkOSIKICAgIH0sIAogICAgewogICAgICAiYXR0cmlidXRl
cyI6IHsKICAgICAgICAiYmxvY2tfc2l6ZSI6IDUxMiwgCiAgICAgICAgImVtdWxhdGVfM3BjIjog
MSwgCiAgICAgICAgImVtdWxhdGVfY2F3IjogMSwgCiAgICAgICAgImVtdWxhdGVfZHBvIjogMSwg
CiAgICAgICAgImVtdWxhdGVfZnVhX3JlYWQiOiAxLCAKICAgICAgICAiZW11bGF0ZV9mdWFfd3Jp
dGUiOiAxLCAKICAgICAgICAiZW11bGF0ZV9tb2RlbF9hbGlhcyI6IDEsIAogICAgICAgICJlbXVs
YXRlX3Jlc3RfcmVvcmQiOiAwLCAKICAgICAgICAiZW11bGF0ZV90YXMiOiAxLCAKICAgICAgICAi
ZW11bGF0ZV90cHUiOiAwLCAKICAgICAgICAiZW11bGF0ZV90cHdzIjogMCwgCiAgICAgICAgImVt
dWxhdGVfdWFfaW50bGNrX2N0cmwiOiAwLCAKICAgICAgICAiZW11bGF0ZV93cml0ZV9jYWNoZSI6
IDEsIAogICAgICAgICJlbmZvcmNlX3ByX2lzaWRzIjogMSwgCiAgICAgICAgImZvcmNlX3ByX2Fw
dHBsIjogMCwgCiAgICAgICAgImlzX25vbnJvdCI6IDAsIAogICAgICAgICJtYXhfdW5tYXBfYmxv
Y2tfZGVzY19jb3VudCI6IDEsIAogICAgICAgICJtYXhfdW5tYXBfbGJhX2NvdW50IjogODE5Miwg
CiAgICAgICAgIm1heF93cml0ZV9zYW1lX2xlbiI6IDQwOTYsIAogICAgICAgICJvcHRpbWFsX3Nl
Y3RvcnMiOiAxNjM4NCwgCiAgICAgICAgInBpX3Byb3RfZm9ybWF0IjogMCwgCiAgICAgICAgInBp
X3Byb3RfdHlwZSI6IDAsIAogICAgICAgICJxdWV1ZV9kZXB0aCI6IDEyOCwgCiAgICAgICAgInVu
bWFwX2dyYW51bGFyaXR5IjogMSwgCiAgICAgICAgInVubWFwX2dyYW51bGFyaXR5X2FsaWdubWVu
dCI6IDAsIAogICAgICAgICJ1bm1hcF96ZXJvZXNfZGF0YSI6IDAKICAgICAgfSwgCiAgICAgICJk
ZXYiOiAiL2RhdGEvYXQtaG9zdC0wMi5pbWciLCAKICAgICAgIm5hbWUiOiAiZGF0YS1hdC1ob3N0
LTAyLmltZyIsIAogICAgICAicGx1Z2luIjogImZpbGVpbyIsIAogICAgICAic2l6ZSI6IDEwOTk1
MTE2Mjc3NzYsIAogICAgICAid3JpdGVfYmFjayI6IHRydWUsIAogICAgICAid3duIjogIjg5MWZj
MThhLTkzYTQtNGMwNy05MDM0LWI3MzA3NTM4ZDk5NyIKICAgIH0sIAogICAgewogICAgICAiYXR0
cmlidXRlcyI6IHsKICAgICAgICAiYmxvY2tfc2l6ZSI6IDUxMiwgCiAgICAgICAgImVtdWxhdGVf
M3BjIjogMSwgCiAgICAgICAgImVtdWxhdGVfY2F3IjogMSwgCiAgICAgICAgImVtdWxhdGVfZHBv
IjogMSwgCiAgICAgICAgImVtdWxhdGVfZnVhX3JlYWQiOiAxLCAKICAgICAgICAiZW11bGF0ZV9m
dWFfd3JpdGUiOiAxLCAKICAgICAgICAiZW11bGF0ZV9tb2RlbF9hbGlhcyI6IDEsIAogICAgICAg
ICJlbXVsYXRlX3Jlc3RfcmVvcmQiOiAwLCAKICAgICAgICAiZW11bGF0ZV90YXMiOiAxLCAKICAg
ICAgICAiZW11bGF0ZV90cHUiOiAwLCAKICAgICAgICAiZW11bGF0ZV90cHdzIjogMCwgCiAgICAg
ICAgImVtdWxhdGVfdWFfaW50bGNrX2N0cmwiOiAwLCAKICAgICAgICAiZW11bGF0ZV93cml0ZV9j
YWNoZSI6IDEsIAogICAgICAgICJlbmZvcmNlX3ByX2lzaWRzIjogMSwgCiAgICAgICAgImZvcmNl
X3ByX2FwdHBsIjogMCwgCiAgICAgICAgImlzX25vbnJvdCI6IDAsIAogICAgICAgICJtYXhfdW5t
YXBfYmxvY2tfZGVzY19jb3VudCI6IDEsIAogICAgICAgICJtYXhfdW5tYXBfbGJhX2NvdW50Ijog
ODE5MiwgCiAgICAgICAgIm1heF93cml0ZV9zYW1lX2xlbiI6IDQwOTYsIAogICAgICAgICJvcHRp
bWFsX3NlY3RvcnMiOiAxNjM4NCwgCiAgICAgICAgInBpX3Byb3RfZm9ybWF0IjogMCwgCiAgICAg
ICAgInBpX3Byb3RfdHlwZSI6IDAsIAogICAgICAgICJxdWV1ZV9kZXB0aCI6IDEyOCwgCiAgICAg
ICAgInVubWFwX2dyYW51bGFyaXR5IjogMSwgCiAgICAgICAgInVubWFwX2dyYW51bGFyaXR5X2Fs
aWdubWVudCI6IDAsIAogICAgICAgICJ1bm1hcF96ZXJvZXNfZGF0YSI6IDAKICAgICAgfSwgCiAg
ICAgICJkZXYiOiAiL2RhdGEvYXQtaG9zdC0wMi1kb2N1bWVudHMuaW1nIiwgCiAgICAgICJuYW1l
IjogImRhdGEtYXQtaG9zdC0wMi1kb2N1bWVudHMiLCAKICAgICAgInBsdWdpbiI6ICJmaWxlaW8i
LCAKICAgICAgInNpemUiOiAxMDk5NTExNjI3Nzc2LCAKICAgICAgIndyaXRlX2JhY2siOiB0cnVl
LCAKICAgICAgInd3biI6ICJjNzU0Zjg4My1mZDFlLTQxNzEtOTQyNy0zZTc3NmVkMTRmNmEiCiAg
ICB9LCAKICAgIHsKICAgICAgImF0dHJpYnV0ZXMiOiB7CiAgICAgICAgImJsb2NrX3NpemUiOiA1
MTIsIAogICAgICAgICJlbXVsYXRlXzNwYyI6IDEsIAogICAgICAgICJlbXVsYXRlX2NhdyI6IDEs
IAogICAgICAgICJlbXVsYXRlX2RwbyI6IDEsIAogICAgICAgICJlbXVsYXRlX2Z1YV9yZWFkIjog
MSwgCiAgICAgICAgImVtdWxhdGVfZnVhX3dyaXRlIjogMSwgCiAgICAgICAgImVtdWxhdGVfbW9k
ZWxfYWxpYXMiOiAxLCAKICAgICAgICAiZW11bGF0ZV9yZXN0X3Jlb3JkIjogMCwgCiAgICAgICAg
ImVtdWxhdGVfdGFzIjogMSwgCiAgICAgICAgImVtdWxhdGVfdHB1IjogMCwgCiAgICAgICAgImVt
dWxhdGVfdHB3cyI6IDAsIAogICAgICAgICJlbXVsYXRlX3VhX2ludGxja19jdHJsIjogMCwgCiAg
ICAgICAgImVtdWxhdGVfd3JpdGVfY2FjaGUiOiAxLCAKICAgICAgICAiZW5mb3JjZV9wcl9pc2lk
cyI6IDEsIAogICAgICAgICJmb3JjZV9wcl9hcHRwbCI6IDAsIAogICAgICAgICJpc19ub25yb3Qi
OiAwLCAKICAgICAgICAibWF4X3VubWFwX2Jsb2NrX2Rlc2NfY291bnQiOiAxLCAKICAgICAgICAi
bWF4X3VubWFwX2xiYV9jb3VudCI6IDgxOTIsIAogICAgICAgICJtYXhfd3JpdGVfc2FtZV9sZW4i
OiA0MDk2LCAKICAgICAgICAib3B0aW1hbF9zZWN0b3JzIjogMTYzODQsIAogICAgICAgICJwaV9w
cm90X2Zvcm1hdCI6IDAsIAogICAgICAgICJwaV9wcm90X3R5cGUiOiAwLCAKICAgICAgICAicXVl
dWVfZGVwdGgiOiAxMjgsIAogICAgICAgICJ1bm1hcF9ncmFudWxhcml0eSI6IDEsIAogICAgICAg
ICJ1bm1hcF9ncmFudWxhcml0eV9hbGlnbm1lbnQiOiAwLCAKICAgICAgICAidW5tYXBfemVyb2Vz
X2RhdGEiOiAwCiAgICAgIH0sIAogICAgICAiZGV2IjogIi9kYXRhL2RhdGEtYXQtaG9zdC0wMi10
ZW1wb3JhcnlkYi5pbWciLCAKICAgICAgIm5hbWUiOiAiZGF0YS1hdC1ob3N0LTAyLXRlbXBvcmFy
eWRiIiwgCiAgICAgICJwbHVnaW4iOiAiZmlsZWlvIiwgCiAgICAgICJzaXplIjogMjE5OTAyMzI1
NTU1MiwgCiAgICAgICJ3cml0ZV9iYWNrIjogdHJ1ZSwgCiAgICAgICJ3d24iOiAiZjhlYjA1MGYt
OWI0MS00NDc0LWIyOTEtYWRhMGMxOTlkY2JmIgogICAgfSwgCiAgICB7CiAgICAgICJhdHRyaWJ1
dGVzIjogewogICAgICAgICJibG9ja19zaXplIjogNTEyLCAKICAgICAgICAiZW11bGF0ZV8zcGMi
OiAxLCAKICAgICAgICAiZW11bGF0ZV9jYXciOiAxLCAKICAgICAgICAiZW11bGF0ZV9kcG8iOiAx
LCAKICAgICAgICAiZW11bGF0ZV9mdWFfcmVhZCI6IDEsIAogICAgICAgICJlbXVsYXRlX2Z1YV93
cml0ZSI6IDEsIAogICAgICAgICJlbXVsYXRlX21vZGVsX2FsaWFzIjogMSwgCiAgICAgICAgImVt
dWxhdGVfcmVzdF9yZW9yZCI6IDAsIAogICAgICAgICJlbXVsYXRlX3RhcyI6IDEsIAogICAgICAg
ICJlbXVsYXRlX3RwdSI6IDAsIAogICAgICAgICJlbXVsYXRlX3Rwd3MiOiAwLCAKICAgICAgICAi
ZW11bGF0ZV91YV9pbnRsY2tfY3RybCI6IDAsIAogICAgICAgICJlbXVsYXRlX3dyaXRlX2NhY2hl
IjogMSwgCiAgICAgICAgImVuZm9yY2VfcHJfaXNpZHMiOiAxLCAKICAgICAgICAiZm9yY2VfcHJf
YXB0cGwiOiAwLCAKICAgICAgICAiaXNfbm9ucm90IjogMCwgCiAgICAgICAgIm1heF91bm1hcF9i
bG9ja19kZXNjX2NvdW50IjogMSwgCiAgICAgICAgIm1heF91bm1hcF9sYmFfY291bnQiOiA4MTky
LCAKICAgICAgICAibWF4X3dyaXRlX3NhbWVfbGVuIjogNDA5NiwgCiAgICAgICAgIm9wdGltYWxf
c2VjdG9ycyI6IDE2Mzg0LCAKICAgICAgICAicGlfcHJvdF9mb3JtYXQiOiAwLCAKICAgICAgICAi
cGlfcHJvdF90eXBlIjogMCwgCiAgICAgICAgInF1ZXVlX2RlcHRoIjogMTI4LCAKICAgICAgICAi
dW5tYXBfZ3JhbnVsYXJpdHkiOiAxLCAKICAgICAgICAidW5tYXBfZ3JhbnVsYXJpdHlfYWxpZ25t
ZW50IjogMCwgCiAgICAgICAgInVubWFwX3plcm9lc19kYXRhIjogMAogICAgICB9LCAKICAgICAg
ImRldiI6ICIvZGF0YS9rdWJlcm5ldGVzX3N0b3JhZ2Uva3ViZXJuZXRlc19kYl8xLmltZyIsIAog
ICAgICAibmFtZSI6ICJrdWJlcm5ldGVzX2RiXzEiLCAKICAgICAgInBsdWdpbiI6ICJmaWxlaW8i
LCAKICAgICAgInNpemUiOiAxMDczNzQxODI0MDAwLCAKICAgICAgIndyaXRlX2JhY2siOiB0cnVl
LCAKICAgICAgInd3biI6ICI3ZjgwZmY2OC00NDU5LTQ4NDUtOGI1ZS01YTIwZTBhYTRhMzQiCiAg
ICB9LCAKICAgIHsKICAgICAgImF0dHJpYnV0ZXMiOiB7CiAgICAgICAgImJsb2NrX3NpemUiOiA1
MTIsIAogICAgICAgICJlbXVsYXRlXzNwYyI6IDEsIAogICAgICAgICJlbXVsYXRlX2NhdyI6IDEs
IAogICAgICAgICJlbXVsYXRlX2RwbyI6IDEsIAogICAgICAgICJlbXVsYXRlX2Z1YV9yZWFkIjog
MSwgCiAgICAgICAgImVtdWxhdGVfZnVhX3dyaXRlIjogMSwgCiAgICAgICAgImVtdWxhdGVfbW9k
ZWxfYWxpYXMiOiAxLCAKICAgICAgICAiZW11bGF0ZV9yZXN0X3Jlb3JkIjogMCwgCiAgICAgICAg
ImVtdWxhdGVfdGFzIjogMSwgCiAgICAgICAgImVtdWxhdGVfdHB1IjogMCwgCiAgICAgICAgImVt
dWxhdGVfdHB3cyI6IDAsIAogICAgICAgICJlbXVsYXRlX3VhX2ludGxja19jdHJsIjogMCwgCiAg
ICAgICAgImVtdWxhdGVfd3JpdGVfY2FjaGUiOiAxLCAKICAgICAgICAiZW5mb3JjZV9wcl9pc2lk
cyI6IDEsIAogICAgICAgICJmb3JjZV9wcl9hcHRwbCI6IDAsIAogICAgICAgICJpc19ub25yb3Qi
OiAwLCAKICAgICAgICAibWF4X3VubWFwX2Jsb2NrX2Rlc2NfY291bnQiOiAxLCAKICAgICAgICAi
bWF4X3VubWFwX2xiYV9jb3VudCI6IDgxOTIsIAogICAgICAgICJtYXhfd3JpdGVfc2FtZV9sZW4i
OiA0MDk2LCAKICAgICAgICAib3B0aW1hbF9zZWN0b3JzIjogMTYzODQsIAogICAgICAgICJwaV9w
cm90X2Zvcm1hdCI6IDAsIAogICAgICAgICJwaV9wcm90X3R5cGUiOiAwLCAKICAgICAgICAicXVl
dWVfZGVwdGgiOiAxMjgsIAogICAgICAgICJ1bm1hcF9ncmFudWxhcml0eSI6IDEsIAogICAgICAg
ICJ1bm1hcF9ncmFudWxhcml0eV9hbGlnbm1lbnQiOiAwLCAKICAgICAgICAidW5tYXBfemVyb2Vz
X2RhdGEiOiAwCiAgICAgIH0sIAogICAgICAiZGV2IjogIi9kYXRhL2NoYXB0ZXN0IiwgCiAgICAg
ICJuYW1lIjogImNoYXAtdGVzdCIsIAogICAgICAicGx1Z2luIjogImZpbGVpbyIsIAogICAgICAi
c2l6ZSI6IDEwNzM3NDE4MjQsIAogICAgICAid3JpdGVfYmFjayI6IHRydWUsIAogICAgICAid3du
IjogIjAyYzg0NGUxLTRlZDEtNDU5Yy04ODdmLTBjZjM3OTRmM2RkYiIKICAgIH0KICBdLCAKICAi
dGFyZ2V0cyI6IFsKICAgIHsKICAgICAgImZhYnJpYyI6ICJpc2NzaSIsIAogICAgICAidHBncyI6
IFsKICAgICAgICB7CiAgICAgICAgICAiYXR0cmlidXRlcyI6IHsKICAgICAgICAgICAgImF1dGhl
bnRpY2F0aW9uIjogMSwgCiAgICAgICAgICAgICJjYWNoZV9keW5hbWljX2FjbHMiOiAwLCAKICAg
ICAgICAgICAgImRlZmF1bHRfY21kc25fZGVwdGgiOiA2NCwgCiAgICAgICAgICAgICJkZWZhdWx0
X2VybCI6IDAsIAogICAgICAgICAgICAiZGVtb19tb2RlX2Rpc2NvdmVyeSI6IDEsIAogICAgICAg
ICAgICAiZGVtb19tb2RlX3dyaXRlX3Byb3RlY3QiOiAxLCAKICAgICAgICAgICAgImZhYnJpY19w
cm90X3R5cGUiOiAwLCAKICAgICAgICAgICAgImdlbmVyYXRlX25vZGVfYWNscyI6IDAsIAogICAg
ICAgICAgICAibG9naW5fdGltZW91dCI6IDE1LCAKICAgICAgICAgICAgIm5ldGlmX3RpbWVvdXQi
OiAyLCAKICAgICAgICAgICAgInByb2RfbW9kZV93cml0ZV9wcm90ZWN0IjogMCwgCiAgICAgICAg
ICAgICJ0MTBfcGkiOiAwLCAKICAgICAgICAgICAgInRwZ19lbmFibGVkX3NlbmR0YXJnZXRzIjog
MQogICAgICAgICAgfSwgCiAgICAgICAgICAiY2hhcF9wYXNzd29yZCI6ICJrdWJlcm5ldGVzIiwg
CiAgICAgICAgICAiY2hhcF91c2VyaWQiOiAia3ViZXJuZXRlcyIsIAogICAgICAgICAgImVuYWJs
ZSI6IHRydWUsIAogICAgICAgICAgImx1bnMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAg
ICAiaW5kZXgiOiAwLCAKICAgICAgICAgICAgICAic3RvcmFnZV9vYmplY3QiOiAiL2JhY2tzdG9y
ZXMvZmlsZWlvL2t1YmVybmV0ZXNfZGJfMSIKICAgICAgICAgICAgfQogICAgICAgICAgXSwgCiAg
ICAgICAgICAibm9kZV9hY2xzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImF0dHJp
YnV0ZXMiOiB7CiAgICAgICAgICAgICAgICAiZGF0YW91dF90aW1lb3V0IjogMywgCiAgICAgICAg
ICAgICAgICAiZGF0YW91dF90aW1lb3V0X3JldHJpZXMiOiA1LCAKICAgICAgICAgICAgICAgICJk
ZWZhdWx0X2VybCI6IDAsIAogICAgICAgICAgICAgICAgIm5vcGluX3Jlc3BvbnNlX3RpbWVvdXQi
OiAzMCwgCiAgICAgICAgICAgICAgICAibm9waW5fdGltZW91dCI6IDE1LCAKICAgICAgICAgICAg
ICAgICJyYW5kb21fZGF0YWluX3BkdV9vZmZzZXRzIjogMCwgCiAgICAgICAgICAgICAgICAicmFu
ZG9tX2RhdGFpbl9zZXFfb2Zmc2V0cyI6IDAsIAogICAgICAgICAgICAgICAgInJhbmRvbV9yMnRf
b2Zmc2V0cyI6IDAKICAgICAgICAgICAgICB9LCAKICAgICAgICAgICAgICAiY2hhcF9wYXNzd29y
ZCI6ICJrdWJlcm5ldGVzIiwgCiAgICAgICAgICAgICAgImNoYXBfdXNlcmlkIjogImt1YmVybmV0
ZXMiLCAKICAgICAgICAgICAgICAibWFwcGVkX2x1bnMiOiBbCiAgICAgICAgICAgICAgICB7CiAg
ICAgICAgICAgICAgICAgICJpbmRleCI6IDAsIAogICAgICAgICAgICAgICAgICAidHBnX2x1biI6
IDAsIAogICAgICAgICAgICAgICAgICAid3JpdGVfcHJvdGVjdCI6IGZhbHNlCiAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgXSwgCiAgICAgICAgICAgICAgIm5vZGVfd3duIjogImlxbi4y
MDE3LTAxLmF0LmNmLWl0Lmt1YmVybmV0ZXMuZGItMSIKICAgICAgICAgICAgfQogICAgICAgICAg
XSwgCiAgICAgICAgICAicGFyYW1ldGVycyI6IHsKICAgICAgICAgICAgIkF1dGhNZXRob2QiOiAi
Q0hBUCIsIAogICAgICAgICAgICAiRGF0YURpZ2VzdCI6ICJDUkMzMkMsTm9uZSIsIAogICAgICAg
ICAgICAiRGF0YVBEVUluT3JkZXIiOiAiWWVzIiwgCiAgICAgICAgICAgICJEYXRhU2VxdWVuY2VJ
bk9yZGVyIjogIlllcyIsIAogICAgICAgICAgICAiRGVmYXVsdFRpbWUyUmV0YWluIjogIjIwIiwg
CiAgICAgICAgICAgICJEZWZhdWx0VGltZTJXYWl0IjogIjIiLCAKICAgICAgICAgICAgIkVycm9y
UmVjb3ZlcnlMZXZlbCI6ICIwIiwgCiAgICAgICAgICAgICJGaXJzdEJ1cnN0TGVuZ3RoIjogIjY1
NTM2IiwgCiAgICAgICAgICAgICJIZWFkZXJEaWdlc3QiOiAiQ1JDMzJDLE5vbmUiLCAKICAgICAg
ICAgICAgIklGTWFya0ludCI6ICJSZWplY3QiLCAKICAgICAgICAgICAgIklGTWFya2VyIjogIk5v
IiwgCiAgICAgICAgICAgICJJbW1lZGlhdGVEYXRhIjogIlllcyIsIAogICAgICAgICAgICAiSW5p
dGlhbFIyVCI6ICJZZXMiLCAKICAgICAgICAgICAgIk1heEJ1cnN0TGVuZ3RoIjogIjI2MjE0NCIs
IAogICAgICAgICAgICAiTWF4Q29ubmVjdGlvbnMiOiAiMSIsIAogICAgICAgICAgICAiTWF4T3V0
c3RhbmRpbmdSMlQiOiAiMSIsIAogICAgICAgICAgICAiTWF4UmVjdkRhdGFTZWdtZW50TGVuZ3Ro
IjogIjgxOTIiLCAKICAgICAgICAgICAgIk1heFhtaXREYXRhU2VnbWVudExlbmd0aCI6ICIyNjIx
NDQiLCAKICAgICAgICAgICAgIk9GTWFya0ludCI6ICJSZWplY3QiLCAKICAgICAgICAgICAgIk9G
TWFya2VyIjogIk5vIiwgCiAgICAgICAgICAgICJUYXJnZXRBbGlhcyI6ICJMSU8gVGFyZ2V0Igog
ICAgICAgICAgfSwgCiAgICAgICAgICAicG9ydGFscyI6IFsKICAgICAgICAgICAgewogICAgICAg
ICAgICAgICJpcF9hZGRyZXNzIjogIjAuMC4wLjAiLCAKICAgICAgICAgICAgICAiaXNlciI6IHRy
dWUsIAogICAgICAgICAgICAgICJwb3J0IjogMzI2MAogICAgICAgICAgICB9CiAgICAgICAgICBd
LCAKICAgICAgICAgICJ0YWciOiAxCiAgICAgICAgfQogICAgICBdLCAKICAgICAgInd3biI6ICJp
cW4uMjAxNy0wMS5hdC5jZi1pdC5hdC1zdG9yYWdlLTAxIgogICAgfSwgCiAgICB7CiAgICAgICJm
YWJyaWMiOiAic3JwdCIsIAogICAgICAidHBncyI6IFsKICAgICAgICB7CiAgICAgICAgICAiYXR0
cmlidXRlcyI6IHsKICAgICAgICAgICAgInNycF9tYXhfcmRtYV9zaXplIjogNjU1MzYsIAogICAg
ICAgICAgICAic3JwX21heF9yc3Bfc2l6ZSI6IDI1NiwgCiAgICAgICAgICAgICJzcnBfc3Ffc2l6
ZSI6IDQwOTYKICAgICAgICAgIH0sIAogICAgICAgICAgImVuYWJsZSI6IHRydWUsIAogICAgICAg
ICAgImx1bnMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAiaW5kZXgiOiAzLCAKICAg
ICAgICAgICAgICAic3RvcmFnZV9vYmplY3QiOiAiL2JhY2tzdG9yZXMvZmlsZWlvL2RhdGEtYXQt
aG9zdC0wMi5pbWciCiAgICAgICAgICAgIH0sIAogICAgICAgICAgICB7CiAgICAgICAgICAgICAg
ImluZGV4IjogNCwgCiAgICAgICAgICAgICAgInN0b3JhZ2Vfb2JqZWN0IjogIi9iYWNrc3RvcmVz
L2ZpbGVpby9kYXRhLWF0LWhvc3QtMDItZG9jdW1lbnRzIgogICAgICAgICAgICB9LCAKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICJpbmRleCI6IDAsIAogICAgICAgICAgICAgICJzdG9yYWdl
X29iamVjdCI6ICIvYmFja3N0b3Jlcy9maWxlaW8vZGF0YS1hdC1ob3N0LTAyLXRlbXBvcmFyeWRi
IgogICAgICAgICAgICB9CiAgICAgICAgICBdLCAKICAgICAgICAgICJub2RlX2FjbHMiOiBbCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAibWFwcGVkX2x1bnMiOiBbXSwgCiAgICAgICAgICAg
ICAgIm5vZGVfd3duIjogImliLjAwMDAwMDAwMDAwMDAwMDAwMDExNzUwMDAwNzliZjYyIgogICAg
ICAgICAgICB9LCAKICAgICAgICAgICAgewogICAgICAgICAgICAgICJtYXBwZWRfbHVucyI6IFsK
ICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgImluZGV4IjogMCwgCiAgICAgICAg
ICAgICAgICAgICJ0cGdfbHVuIjogMywgCiAgICAgICAgICAgICAgICAgICJ3cml0ZV9wcm90ZWN0
IjogZmFsc2UKICAgICAgICAgICAgICAgIH0sIAogICAgICAgICAgICAgICAgewogICAgICAgICAg
ICAgICAgICAiaW5kZXgiOiAxLCAKICAgICAgICAgICAgICAgICAgInRwZ19sdW4iOiA0LCAKICAg
ICAgICAgICAgICAgICAgIndyaXRlX3Byb3RlY3QiOiBmYWxzZQogICAgICAgICAgICAgICAgfSwg
CiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICJpbmRleCI6IDIsIAogICAgICAg
ICAgICAgICAgICAidHBnX2x1biI6IDAsIAogICAgICAgICAgICAgICAgICAid3JpdGVfcHJvdGVj
dCI6IGZhbHNlCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgXSwgCiAgICAgICAgICAg
ICAgIm5vZGVfd3duIjogImliLjAwMDAwMDAwMDAwMDAwMDAwMDExNzUwMDAwNzljNjA2IgogICAg
ICAgICAgICB9CiAgICAgICAgICBdLCAKICAgICAgICAgICJwb3J0YWxzIjogW10sIAogICAgICAg
ICAgInRhZyI6IDEKICAgICAgICB9CiAgICAgIF0sIAogICAgICAid3duIjogImliLmZlODAwMDAw
MDAwMDAwMDAwMDExNzUwMDAwNzliZmEwIgogICAgfQogIF0KfQo=
--=_MailMate_8E709BDE-BEBC-400D-ABF1-564D996D3831_=--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
