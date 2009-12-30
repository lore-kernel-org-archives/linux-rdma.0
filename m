From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OFED-1.5 GA is available
Date: Wed, 30 Dec 2009 18:24:02 +0200
Message-ID: <4B3B7EA2.4060605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080908070609010406070905"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080908070609010406070905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,
I am pleased to announce that OFED-1.5 GA release is done

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5.tgz
Or
http://69.55.239.13/builds/ofed-1.5/release/OFED-1.5.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5

Vladimir & Tziporet

========================================================================


Release information:
--------------------
Linux Operating Systems:
         - RedHat EL4 up7        2.6.9-78.ELsmp
         - RedHat EL4 up8        2.6.9-89.ELsmp
         - RedHat EL5 up3        2.6.18-128.el5
         - RedHat EL5 up4        2.6.18-164.el5
         - SLES10 SP2            2.6.16.60-0.21-smp
         - SLES10 SP3            2.6.16.60-0.54-smp
         - SLES11                2.6.27.19-5-default
         - OEL 4 up7             2.6.9-78.ELsmp
         - OEL 4 up8             2.6.9-89.ELsmp
         - CentOS5.3             2.6.18-128.el5
         - CentOS5.4             2.6.18-164.el5
         - Fedora Core12         2.6.31.5-127.fc12    *
         - OpenSuSE 11.2         2.6.31.5-0.1-default *
         - kernel.org            2.6.29, 2.6.30,
                                 2.6.31 and 2.6.32    *

        * Minimal QA for these versions

Systems:
        * x86_64
        * x86
        * ia64
        * ppc64



Main Changes from OFED-1.4.2
============================
1. General changes
         o Kernel code based on 2.6.30
         o libraries location - all userspace libraries can be downloaded from
           http://www.openfabrics.org/downloads/
           See BUILD_ID for exact location
         o Qlogic replaced low level driver from ipath to qib.

- SDP
         o Performance improvements
         o Zero copy in beta level

- uDAPL
         o New UCM provider (ofa-v2-mlx4_0-1u)  with IB UD based CM per process. More
           scalable then rdma_cm (cma) or socket cm (scm).
         o Common code base with WinOF 2.1.
         o Bug fixes.


- perftest
         o Renamed tests:
           ib_rdma_bw  -> rdma_bw
           ib_rdma_lat -> rdma_lat

- Management
         o OpenSM
           - Mesh Analysis for LASH routing algorithm.
           - Reloadable OpenSM configuration (preliminary implemented)
           - Routing paths sorted balancing (for UpDown and MinHops)
           - Weighted Lid Matrices calculation (for UpDown, MinHop and DOR).
           - I/O nodes connectivity (for FatTree).
           - MGID to MLID compression - infrastructure for many MGIDs to single MLID
             compression.
	* OpenSM release notes are not updated in the OFED-1.5 docs. Please refer
           to opensm_release_notes-3.3.txt coming with opensm RPM

- MPI:
         a. OSU MVAPICH 1.2.0
         b. Open MPI 1.4
         c. OSU MVAPICH2 1.4
         d. MPI tests 3.2

- iSER:
         o Available only on kernel.org 2.6.30, 2.6.31 and 2.6.32

- NFS-RDMA
         o Added support for RHEL5.4, SLES10 SP3, kernel.org 2.6.25 and 2.6.30.
           kernels 2.6.26 and 2.6.27 are not supported
         o NFS-RDMA is in beta level. Will be GA in OFED-1.5.1

2. Bug fixes
      See attached.


--------------080908070609010406070905
Content-Type: text/csv;
 name="bugs-2009-12-30.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2009-12-30.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxNzIwLCJt
YWpvciIsIlAzIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIs
IkZJWEVEIiwiQ3Jhc2ggdW5sb2FkaW5nIGliX3NkcCIKMTcyNCwibm9ybWFsIiwiUDMiLCJB
bGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJRUCBjcmVh
dGlvbiBzb21ldGltZXMgZmFpbCBkdWUgdG8gdW5zdXBwb3J0ZWQgY2FwYWJpbGl0aWVzIgox
NzI5LCJub3JtYWwiLCJQMyIsIkFsbCIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xW
RUQiLCJGSVhFRCIsIkRyaXZlciByZXN0YXJ0LCBhZnRlciBydW5uaW5nIHNkcCB0ZXN0cywg
cmVzdWx0cyBpbiBrZXJuZWwgcGFuaWMiCjE3MzIsIm5vcm1hbCIsIlAzIiwiV2luZG93cyBY
UCIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlBhcmFsbGVs
IGV4ZWN1dGlvbiBvZiBTRFAgYW5kIE1QSSAoUFNNKSBnaXZlcyDigJxzZHBfYnpfY2xlYW51
cOKAnSBtZXNzYWdlcyIKMTc5NiwiY3JpdGljYWwiLCJQMyIsIkFsbCIsImFtaXJ2QG1lbGxh
bm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlJ1bm5pbmcgaXBlcmYtMi4wLjQgd2l0
aCAxSyBidWZmZXIgY29uc3VtZXMgdG9vIG11Y2ggbWVtb3J5IG9uIHRoZSBzZXJ2ZXIgbWFj
aGluZSIKMTg0NSwiYmxvY2tlciIsIlAzIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28u
aWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiSXBlcmYgbXVsdGkgc3RyZWFtIFpDb3B5IGNvcnJ1
cHQgc2VydmVyJ3MgbWVtb3J5IgoxODQ2LCJtYWpvciIsIlAzIiwiQWxsIiwiYW1pcnZAbWVs
bGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiTWVtb3J5IGxlYWsgaW4gZXJzL2lu
ZmluaWJhbmQvdWxwL3NkcC9zZHBfcnguYyIKMTg1NSwibm9ybWFsIiwiUDMiLCJSSEVMIDUi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTRFAgbmV0cGVy
ZiBnb3QgYSBrZXJuZWwgZXhjZXB0aW9uIG9uIE9GRUQxLjVyYzMgYW5kIFJIRUw1LjQiCjE3
NDcsIm5vcm1hbCIsIlAzIiwiUkhFTCA1IiwiYW5keS5ncm92ZXJAb3JhY2xlLmNvbSIsIlJF
U09MVkVEIiwiRklYRUQiLCJDYW50IGJ1aWxkIDEuNSBvbiBSSEVMIDUuNCBHQSIKMTgwNCwi
bWFqb3IiLCJQMyIsIlJIRUwgNSIsImFuZHkuZ3JvdmVyQG9yYWNsZS5jb20iLCJSRVNPTFZF
RCIsIkZJWEVEIiwiUkRTIHBhbmljIgoxNjkxLCJtYWpvciIsIlAzIiwiQWxsIiwiYXJsaW4u
ci5kYXZpc0BpbnRlbC5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiZGFwbC11dGlscyBSUE0g
Y29uZmxpY3RzIHdpdGggY29tcGF0LWRhcGwtdXRpbHMgb24gU0xFUzExIGJ1dCBub3Qgb24g
U0xFUzEwIG9yIFJIRUw1IgoxNzA3LCJub3JtYWwiLCJQMyIsIlNMRVMgMTAiLCJqYWNrbUBt
ZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJJbnN0YWxsYXRpb24gZmFpbHMg
b24gUFBDNjQgd2l0aCBTTEVTMTAuMiIKMTcwOSwibWFqb3IiLCJQMyIsIlNMRVMgMTEiLCJq
YWNrbUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJrZXJuZWwgcGFuaWMg
YWZ0ZXIgcnVubmluZyBkZCB0cmFmZmljIG92ZXIgYSBuZnMtcmRtYSB2b2x1bWUuIgoxNzEx
LCJub3JtYWwiLCJQMyIsIk90aGVyIiwiamFja21AbWVsbGFub3guY28uaWwiLCJSRVNPTFZF
RCIsIkZJWEVEIiwibmZzcmRtYSBtb3VudCBmYWlsdXJlIG9uIDIuNi4zMC40IgoxNzYwLCJu
b3JtYWwiLCJQMyIsIlJIRUwgNSIsImphY2ttQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQi
LCJGSVhFRCIsImRlYWRsb2NrIHdoZW4gcnVubmluZyBGTVIgdGVzdCIKMTgwNiwibm9ybWFs
IiwiUDMiLCJPdGhlciIsImphY2ttQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhF
RCIsIklCX0NRX1ZFQ1RPUl9MRUFTVF9BVFRBQ0hFRCBub3QgZGVmaW5lZCIKMTc0MSwibm9y
bWFsIiwiUDMiLCJTTEVTIDEwIiwiam9uQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09M
VkVEIiwiRklYRUQiLCJBdHRlbXB0aW5nIHRvIGZpbmQgZmlsZXMgb24gTkZTIG1vdW50IGdp
dmVzIGEgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIgoxODEwLCJjcml0aWNhbCIsIlAzIiwi
UkhFTCA1Iiwiam9uQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQi
LCJPRkVELTEuNS0gTkZTb3ZlclJETUEtICIiTG9jayB0ZXN0cyIiIG9mIENvbm5lY3RhdGhv
biBmYWlscyB0byBydW4gb24gUkhFTDVVMi0zMiBiaXQgcGxhdGZvcm0iCjE4MjIsIm5vcm1h
bCIsIlAzIiwiU0xFUyAxMSIsImpvbkBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJSRVNPTFZF
RCIsIkZJWEVEIiwiQ29tcGlsYXRpb24gZXJyb3IgYnVpbGRpbmcgb2ZhX2tlcm5lbC0xLjUv
ZnMvbmZzL2ZpbGUuYyIKMTg1Miwibm9ybWFsIiwiUDMiLCJDZW50T1MgNSIsImpvbkBvcGVu
Z3JpZGNvbXB1dGluZy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiTkZTb1JETUE6IENhbid0
IHJlc3RhcnQgTkZTIHNlcnZlciIKMTgyMSwibWFqb3IiLCJQMyIsIlJIRUwgNSIsIm1vbmlz
QHZvbHRhaXJlLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJDcmFzaCBpbiBib25kaW5nIgox
NjYzLCJibG9ja2VyIiwiUDMiLCJSSEVMIDUiLCJvcmVua0BkZXYubWVsbGFub3guY28uaWwi
LCJSRVNPTFZFRCIsIkZJWEVEIiwibXN0ZmxpbnQgY3Jhc2hpbmcgb24gSFAgZ2VuNiBob3N0
cyBydW5uaW5nIFJIRUwgNSAtIEhDQXMgY2Fubm90IGJlIHVzZWQgYXQgYWxsLiIKMTY3NCwi
bm9ybWFsIiwiUDMiLCJPdGhlciIsInN3aXNlQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJF
U09MVkVEIiwiRklYRUQiLCJ1Y21hdG9zZSBzdGFsbHMgb24gY3hnYjMgZHVlIHRvIHVuc2ln
bmFsZWQgV1JzIgoxNzYzLCJibG9ja2VyIiwiUDMiLCJSSEVMIDUiLCJzd2lzZUBvcGVuZ3Jp
ZGNvbXB1dGluZy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiT0ZFRC0xLjUtIFVuYWJsZSB0
byBhZGQgQ2hlbHNpbyBpbnRlcmZhY2VzIHRvIFZMQU4iCjE3NjgsImNyaXRpY2FsIiwiUDMi
LCJTTEVTIDEwIiwic3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJG
SVhFRCIsIk9GRUQtMS41LUFmdGVyIHJlY29tcGlsYXRpb24gb2Ygb2ZhX2tlcm5lbC0xLjUg
c2luZ2xlIGluc3RhbmNlIG9mIElNQiB0ZXN0IHdpdGggT1BFTk1QSSBvbiBTTEVTMTBTUDIt
eDg2XzY0IGJpdCBnaXZlcyBhIHNvZnRsb2NrdXAiCjE3NDgsIm5vcm1hbCIsIlAzIiwiT3Ro
ZXIiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkluc3RhbGxl
ciBkb2VzIG5vdCBidWlsZCBRTG9naWMgaWJfcWliIG1vZHVsZSIKMTc2NywiYmxvY2tlciIs
IlAzIiwiU0xFUyAxMSIsInZsYWRAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVE
IiwiT0ZFRC0xLjUtIE9GRUQxLTEuNS0yMDA5MTAwNS0wNjAwIGRvZXMgbm90IGdldCBpbnN0
YWxsIG9uIFNMRVMxMS14ODZfNjQgYml0IGlmIHRoZSBpbmJveCBPRkVEIHRoYXQgY29tZXMg
d2l0aCBTTEVTIDExIHg4Nl82NCBiaXQgaXMgYWxyZWFkeSBpbnN0YWxsZWQuIgoxNzc0LCJj
cml0aWNhbCIsIlAzIiwiU0xFUyAxMSIsInZsYWRAbWVsbGFub3guY28uaWwiLCJSRVNPTFZF
RCIsIkZJWEVEIiwiSW5zdGFsbGluZyBPRkVEMS41IFJDMSBvbiBTTEVTMTEgb24gbWFjaGlu
ZSB3aXRoIE9GRUQtZGlzdHJvIGRvZXMgbm90IHJlbW92ZSBvZmVkLWttcCIKMTgzNiwiYmxv
Y2tlciIsIlAzIiwiT3RoZXIiLCJ5ZXZnZW55cEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVE
IiwiRklYRUQiLCJFcnJvcnMgbG9hZGluZyBtbHg0X2liLCByZWdyZXNzaW9uIHNpbmNlIDEu
NS1yYzIiCjE2NzEsImJsb2NrZXIiLCJQMSIsIk90aGVyIiwiam9uQG9wZW5ncmlkY29tcHV0
aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJORlNSRE1BIGJhY2twb3J0IGhlYWRlcnMg
YmVpbmcgdXNlZCBldmVuIHdoZW4gTkZTUkRNQSBpcyBub3QgYmVpbmcgdXNlZCIKMTgzOCwi
YmxvY2tlciIsIlAxIiwiT3RoZXIiLCJqb25Ab3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIltSRUddT0ZFRC0xLjUgOiBPRkVELTEuNS0yMDA5MTExOS0wOTE1
IGluc3RhbGx0aW9uIGZhaWxzIHdoaWxlIGluc3RhbGxpbmcgcm5mcy11dGlscyBSUE0uIgox
ODI5LCJibG9ja2VyIiwiUDEiLCJSSEVMIDUiLCJrbGl0ZXluQG1lbGxhbm94LmNvLmlsIiwi
UkVTT0xWRUQiLCJGSVhFRCIsIltSRUddT0ZFRC0xLjUgLU9GRUQtMS41LTIwMDkxMTE2LTA2
MDAgaW5zdGFsbGF0aW9uIGZhaWxzIHdoaWxlIGJ1aWxkaW5nIGlidXRpbHMgUlBNIG9uIFJI
RWwgNXUzIDY0IGJpdCIKMTgzMCwiYmxvY2tlciIsIlAxIiwiUkhFTCA1IiwicGVya2luam9A
Y3NlLm9oaW8tc3RhdGUuZWR1IiwiUkVTT0xWRUQiLCJGSVhFRCIsIlJFR11PRkVELTEuNSAt
T0ZFRC0xLjUtMjAwOTExMTUtMDYwMCBpbnN0YWxsdGlvbiBmYWlscyB3aGlsZSBidWlsZGlu
ZyBtdmFwaWNoMl9nY2MtMS40IFJQTSBvbiBSSEVsIDV1MyA2NCBiaXQiCjE4NjcsImJsb2Nr
ZXIiLCJQMSIsIk90aGVyIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklY
RUQiLCJJUG9JQiBleHBvcnRzIGxyb19mbHVzaF9hbGwoKSB3aGljaCBjb25mbGljdHMgd2l0
aCBpZ2Igb24gUkhFTCA0IFU4IgoxODU5LCJub3JtYWwiLCJQMiIsIkFsbCIsImVsaUBtZWxs
YW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJJUE9JQiBDYW4gbWlzcyBhIGNoYW5n
ZSBpbiBkZ2lkIgoxNzU2LCJtYWpvciIsIlAyIiwiU0xFUyAxMCIsIkplZmZyZXkuQy5CZWNr
ZXJAbmFzYS5nb3YiLCJSRVNPTFZFRCIsIkZJWEVEIiwiTkZTIElub2RlIHJlZmVyZW5jZSBl
cnJvciIKMTc1OCwibm9ybWFsIiwiUDIiLCJPdGhlciIsIkplZmZyZXkuQy5CZWNrZXJAbmFz
YS5nb3YiLCJSRVNPTFZFRCIsIkZJWEVEIiwiSGFuZyBpbiBhZGRyX3Jlc29sdmVfbG9jYWwo
KSB3aXRoIGlwdjYgYWRkcmVzcy4iCjE4MjMsIm1ham9yIiwiUDIiLCJTTEVTIDExIiwidnVA
bWVsbGFub3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LXJjMiBvcGVuc20g
ZmFpbHMgdG8gZGlzY292ZXIgU1JQIGRpcmVjdCBjb25uZWN0IHRhcmdldHMiCjE3NjUsImNy
aXRpY2FsIiwiUDQiLCJSSEVMIDUiLCJzd2lzZUBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJS
RVNPTFZFRCIsIkZJWEVEIiwiT0ZFRC0xLjUtS2VybmVsIHBhbmljIG9uIHRoZSBzZXJ2ZXIg
c2lkZSB3aGlsZSBydW5uaW5nIGtycGluZyB0ZXN0ICBvbiAgUzMyMEUtQ1IgY2FyZHMiCjE4
MjAsImJsb2NrZXIiLCJQNSIsIlNMRVMgMTAiLCJqb25Ab3BlbmdyaWRjb21wdXRpbmcuY29t
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LU5GU292ZXJSRE1BLVVuYWJsZSB0byBt
b3VudCB0aGUgTkZTb3ZlclJETUEgc2hhcmVkIGRpcmVjdG9yeSB3aXRoIE5GUyBDbGllbnQg
YXMgU0xFUzEwU1AyLXg4NiBiaXQgYW5kIE5GUyBTZXJ2ZXIgYXMgUkhFTC01dTMteDg2IGJp
dCBwbGF0Zm9ybSIKMTY2NCwiY3JpdGljYWwiLCJQMyIsIlNMRVMgMTEiLCJtb25pc0B2b2x0
YWlyZS5jb20iLCJWRVJJRklFRCIsIkZJWEVEIiwiQm9uZGluZzogTXVsdGljYXN0IG92ZXIg
Ym9uZCBpbnRlcmZhY2Ugbm90IHdvcmtpbmcgb24gU0xFUzExIgoxNzYyLCJjcml0aWNhbCIs
IlAzIiwiT3RoZXIiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIs
IkZhaWxlZCB0byBjb21waWxlIGRhaWx5IG9mZWQgKDQtMTAtMDkpIG9uIHNsZXMxMCBzcDMi
CjE3NzYsImNyaXRpY2FsIiwiUDMiLCJTTEVTIDExIiwidmxhZEBtZWxsYW5veC5jby5pbCIs
IlZFUklGSUVEIiwiRklYRUQiLCJBZnRlciBpbnN0YWxsaW5nIE9GRUQxLjUgUkMxIHdpdGgg
Y3VzdG9taXplIHRvIGxvYWQgTUxYNF9FTiBvcGVuaWJkIHJlc3RhcnQgZmFpbGVkIgoxNzgx
LCJibG9ja2VyIiwiUDMiLCJPdGhlciIsInZsYWRAbWVsbGFub3guY28uaWwiLCJWRVJJRklF
RCIsIkZJWEVEIiwiRmFpbGVkIGNvIGNvbXBpbGUgT0ZFRDEuNSBSQzEgb24gaWE2NCB3aXRo
IHNsZXMxMCBzcDMiCjE3ODIsImJsb2NrZXIiLCJQMyIsIk90aGVyIiwidmxhZEBtZWxsYW5v
eC5jby5pbCIsIlZFUklGSUVEIiwiRklYRUQiLCJGYWlsZWQgdG8gY29tcGlsZSBPRkVEMS41
IFJDMSBvbiBwcGMgd2l0aCBzbGVzMTAgc3AzIgoxNzkxLCJibG9ja2VyIiwiUDMiLCJSSEVM
IDQiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIk9GRUQxLjUt
cmMxIGNvbXBpbGF0aW9uIG9uIFJINCB1cDggZmFpbGVkIgoxNzkyLCJibG9ja2VyIiwiUDMi
LCJTTEVTIDEwIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlZFUklGSUVEIiwiRklYRUQiLCJP
RkVEMS41LXJjMSBjb21waWxhdGlvbiBvbiBTTEVTMTAgVVAzIGZhaWxlZCIKMTczNywiYmxv
Y2tlciIsIlA1IiwiUkhFTCA0Iiwic3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29tIiwiVkVS
SUZJRUQiLCJGSVhFRCIsInJwaW5nIGZhaWxzIHRvIHN0YXJ0IG9uIHJoZWw0dTcteDg2XzY0
IGJpdCIKMTc3MCwiY3JpdGljYWwiLCJQMyIsIlJIRUwgNCIsImVsaUBtZWxsYW5veC5jby5p
bCIsIkNMT1NFRCIsIkZJWEVEIiwib3BlbmliZCByZXN0YXJ0IGFmdGVyIGNvbmZpZ3VyZSBw
a2V5IG9uIFJINCB1cDggY2F1c2UgdG8ga2VybmVsIHBhbmljIgoxODMxLCJjcml0aWNhbCIs
IlAzIiwiUkhFTCA1IiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJv
ZmVkLTEuNXJjMiBjcmFzaGVkIFJIRUw1LjQgbGludXgga2VybmVsIHJ1bm5pbmcgSVBvSUIg
YmktZGlyZWN0aW9uYWwgVUQgdGVzdCIKMTc4MywiYmxvY2tlciIsIlAzIiwiT3RoZXIiLCJ2
bGFkQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJtaXNtYXRjaCBidHdlZW4g
ZGV2aWNlIG1jYXN0IGxpc3QgYW5kIGlwb2liIG1jYXN0IGxpc3QiCjE3NDYsIm5vcm1hbCIs
IlAyIiwiU0xFUyAxMSIsImpvbkBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJDTE9TRUQiLCJG
SVhFRCIsIkNhbnQgYnVpbGQgMS41IG9uIFNMRVMxMSI=
--------------080908070609010406070905
Content-Type: text/plain;
 name="OFED_release_notes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="OFED_release_notes.txt"

	    Open Fabrics Enterprise Distribution (OFED)
	              Version 1.5
	            Release Notes
	            December 2009


===============================================================================
Table of Contents
===============================================================================
1. Overview, which includes:
	- OFED Distribution Rev 1.5 Contents
	- Supported Platforms and Operating Systems
	- Supported HCA and RNIC Adapter Cards and Firmware Versions
	- Tested Switch Platforms
	- Third party Test Packages
	- OFED sources
4. Main Changes from OFED 1.4.2
5. Known Issues


===============================================================================
1. Overview
===============================================================================
These are the release notes of OpenFabrics Enterprise Distribution (OFED)
release 1.5. The OFED software package is composed of several software modules,
and is intended for use on a computer cluster constructed as an InfiniBand
subnet or iWARP network. 

Note: If you plan to upgrade the OFED package on your cluster, please upgrade
all of its nodes to this new version.


1.1 OFED 1.5 Contents
-----------------------
The OFED package contains the following components:
 - OpenFabrics core and ULPs:
	- IB HCA drivers (mthca, mlx4, qib, ehca)
	- iWARP RNIC driver (cxgb3, nes)
	- core
	- Upper Layer Protocols: IPoIB, SDP, SRP Initiator and target, iSER 
	  Initiator and target, RDS, uDAPL, qlgc_vnic and NFS-RDMA.
 - OpenFabrics utilities:
	- OpenSM (OSM): InfiniBand Subnet Manager
	- Diagnostic tools
	- Performance tests
 - MPI:
	- OSU MPI stack supporting the InfiniBand and iWARP interface
	- Open MPI stack supporting the InfiniBand and iWARP interface
	- OSU MVAPICH2 stack supporting the InfiniBand and iWARP interface
	- MPI benchmark tests (OSU benchmarks, Intel MPI benchmarks, Presta)
 - Extra packages:
	- open-iscsi: open-iscsi initiator with iSER support
	- ib-bonding: Bonding driver for IPoIB interface
 - Sources of all software modules (under conditions mentioned in the modules'
   LICENSE files)
 - Documentation

Notes:
1. iSER target and NFS-RDMA is of Beta quality.
2. All other OFED components are of production quality.
3. See release notes for each package in the docs directory.
4. Any Topspin copyright belongs to Cisco Systems, Inc.

1.2 Supported Platforms and Operating Systems
---------------------------------------------
  o   CPU architectures:
	- x86_64
	- x86
	- ppc64
	- ia64
	
  o   Linux Operating Systems:
	- RedHat EL4 up7	2.6.9-78.ELsmp 
	- RedHat EL4 up8	2.6.9-89.ELsmp 
	- RedHat EL5 up3	2.6.18-128.el5
	- RedHat EL5 up4	2.6.18-164.el5
	- SLES10 SP2 		2.6.16.60-0.21-smp  
	- SLES10 SP3 		2.6.16.60-0.54-smp  
	- SLES11 		2.6.27.19-5-default
	- OEL 4 up7		2.6.9-78.ELsmp
	- OEL 4 up8		2.6.9-89.ELsmp
	- CentOS5.3     	2.6.18-128.el5
	- CentOS5.4     	2.6.18-164.el5
	- Fedora Core12 	2.6.31.5-127.fc12    *
	- OpenSuSE 11.2		2.6.31.5-0.1-default *
	- kernel.org		2.6.29, 2.6.30,
                                2.6.31 and 2.6.32    *

      * Minimal QA for these versions
	
1.3 HCAs and RNICs Supported
----------------------------
This release supports IB HCAs by Mellanox Technologies, Qlogic and IBM as
well as iWARP RNICs by Chelsio Communications and Intel.

  o   Mellanox Technologies HCAs (SDR, DDR and QDR Modes are Supported):
	- InfiniHost (fw-23108 Rev 3.5.000)
	- InfiniHost III Ex (MemFree: fw-25218 Rev 5.3.000 
	                     with memory: fw-25208 Rev 4.8.200)
	- InfiniHost III Lx (fw-25204 Rev 1.2.000)
	- ConnectX IB (fw-25408 Rev 2.7.000)

	For official firmware versions please see:
	http://www.mellanox.com/content/pages.php?pg=firmware_download

  o   Qlogic HCAs:
	- QHT7140 QLogic InfiniPath SDR HTX HCA
	- QLE7140 QLogic InfiniPath SDR PCIe HCA
	- QLE7240 QLogic InfiniPath DDR x8 PCIe HCA
	- QLE7280 QLogic IniniPath DDR x16 PCIe HCA

  o   IBM HCAs:
	- GX Dual-port SDR 4x IB HCA
	- GX Dual-port SDR 12x IB HCA
	- GX Dual-port DDR 4x IB HCA
	- GX Dual-port DDR 12x IB HCA

  o   Chelsio RNICs:
	- S310/S320 10GbE Storage Accelerators
	- R310/R320 10GbE iWARP Adapters

  o   Intel RNICs:
	- NE020 10Gb iWARP Adapter


1.4 Switches Supported
----------------------
This release was tested with switches and gateways provided by the following
companies:
	- Voltaire
	- Qlogic
	- Flextronics
	- Sun
	- Mellanox

1.5 Third Party Packages
------------------------
The following third party packages have been tested with OFED 1.5:
- Intel MPI, Version 3.2.2
- Intel MPI, Version 4.0 beta 

1.6 OFED Sources
----------------
All sources are located under git://git.openfabrics.org/
Kernel sources: git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel
User level Sources are downloaded from http://www.openfabrics.org/downloads/
as written in the BUILD_ID

The kernel sources are based on Linux 2.6.30 mainline kernel. Its patches
are included in the OFED sources directory.
For details see HOWTO.build_ofed.

===============================================================================
2. Main Changes from OFED 1.4.2
===============================================================================
Note: For details regarding the various changes,  please see the release notes
for each package in the docs directory.

    2.1 General changes
	o Kernel code based on 2.6.30
	o libraries location - all userspace libraries can be downloaded from
	  http://www.openfabrics.org/downloads/
	  See BUILD_ID for exact location
	o Qlogic replaced low level driver from ipath to qib.

    2.2 SDP
	o Performance improvements
	o Zero copy in beta level

    2.3 uDAPL
	o New UCM provider (ofa-v2-mlx4_0-1u)  with IB UD based CM per process. More
	  scalable then rdma_cm (cma) or socket cm (scm). 
	o Common code base with WinOF 2.1. 
	o Bug fixes.


    2.4 perftest
	o Renamed tests:
	  ib_rdma_bw  -> rdma_bw
	  ib_rdma_lat -> rdma_lat

    2.5 Management 
	o OpenSM
	  - Mesh Analysis for LASH routing algorithm.
	  - Reloadable OpenSM configuration (preliminary implemented)
	  - Routing paths sorted balancing (for UpDown and MinHops)
	  - Weighted Lid Matrices calculation (for UpDown, MinHop and DOR).
	  - I/O nodes connectivity (for FatTree).

	o Diagnostic tools:

    2.6 MPI:
	a. OSU MVAPICH 1.2.0
	b. Open MPI 1.4
	c. OSU MVAPICH2 1.4
	d. MPI tests 3.2

    2.7 iSER:
	o Available only on kernel.org 2.6.30, 2.6.31 and 2.6.32

    2.8 NFS-RDMA
	o Added support for RHEL5.4, SLES10 SP3, kernel.org 2.6.25 and 2.6.30.
	  kernels 2.6.26 and 2.6.27 are not supported
	o NFS-RDMA is in beta level. Will be GA in OFED-1.5.1

===============================================================================
3. Known Issues
===============================================================================
The following is a list of general limitations and known issues of the various
components of the OFED 1.5 release.

1. When upgrading from an earlier OFED version, the installation script does not
   stop the earlier OFED version prior to uninstalling it. 
   Workaround: Stop the old OFED stack (/etc/init.d/openibd stop) before 
   upgrading to OFED 1.5.
2. Memory registration by the user is limited according to administrator
   setting. See "Pinning (Locking) User Memory Pages" in OFED_tips.txt for
   system configuration.
3. Fork support from kernel 2.6.12 and above is available provided
   that applications do not use threads. The fork() is supported as long
   as the parent process does not run before the child exits or calls exec().
   The former can be achieved by calling wait(childpid), and the latter can be
   achieved by application specific means.  The Posix system() call is
   supported.
4. The qib driver is supported only on 64-bit platforms.
5. When installing OFED on OpenSuse or Ubuntu one should use the 
   --without-depcheck option of the install.pl script
6. IPoIB: brctl utilities do not work on IPoIB interfaces. The reason for that
   is that these utilities support devices of type Ethernet only.
7.  "openibd stop" can sometime fail with the error: 
        Unloading ib_cm                                            [FAILED]
        ERROR: Module ib_cm is in use by ib_ipoib 
    Workaround: run "openibd stop" again.
8.  When working with ISCSI over IPoIB or mlx4_en, you must disable LRO (even
    if IPoIB is set to connected mode). This is because there is a bug in older
    kernels which causes a kernel panic.
9. On SLES11 in case that uninstall is failing, need to look at the error log 
    and remove the RPMs manually using 'rpm -e <rpms list>'
10. On SLES11 one should set allow_unsupported_modules parameter to 1 in file:
    /etc/modprobe.d/unsupported-modules. Without this the modules will not
    load.
11. iSER is supported on kernel.org: 2.6.30, 2.6.31 and 2.6.32 only
    OFED-1.5 will not install iSER on other kernels and original iSER
    module coming with Linux Distribution will stop working because of
    mismatch in symbols version.

Note: See the release notes of each component for additional issues.

--------------080908070609010406070905--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
