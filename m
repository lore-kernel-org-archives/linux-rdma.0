From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.1 GA is available
Date: Thu, 25 Mar 2010 10:01:19 +0200
Message-ID: <4BAB184F.3060406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040903030304010600080907"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040903030304010600080907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I am pleased to announce that OFED-1.5.1 GA release is done

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5.1/release/OFED-1.5.1.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.1

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

   Main Changes from OFED 1.5
============================
1. Added RoCEE support - see RoCEE_README.txt
2. Added enhanced atomic operations to ConnectX (kernel only).
     See mlx4_release_notes.txt.
3. Updated Open MPI to rev 1.4.1-2ofed
4. Updated MVAPICH2 to rev 1.4.1
5. Updated DAPL to rev 2.0.27
6. Updated libnes to rev 1.0.1
7. Updated librdmacm to rev 1.0.11
8. Removed tvflash RPM
9. NFS-RDMA is not supported on SLES10 SP3
10. Fixed IPv6 support and IPv4 routing corner cases for RDMA CM
11. Bug fixes
        See attached.




--------------040903030304010600080907
Content-Type: text/csv;
 name="bugs-2010-03-24.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2010-03-24.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxMzgsIm5v
cm1hbCIsIlAyIiwiQWxsIiwibXN0QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhF
RCIsImdldHBlZXJuYW1lLCBhZnRlciBvdGhlciBzaWRlIGNsb3NlcywgZmFpbHMsIHdoaWNo
IGlzIG5vdCB0aGUgYmVoYXZpb3Igb2YgVENQIgo1OTIsIm5vcm1hbCIsIlAzIiwiT3RoZXIi
LCJqaW1AbWVsbGFub3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsImxpYnNkcCBtZW1vcnkg
bGVhayIKNjY4LCJjcml0aWNhbCIsIlAyIiwiQWxsIiwiZGF2ZS5vbHNvbkBxbG9naWMuY29t
IiwiUkVTT0xWRUQiLCJGSVhFRCIsImlQYXRoIFNNQSBkb2VzIG5vdCBnZW5lcmF0ZSB0cmFw
cyIKNzc5LCJub3JtYWwiLCJQMyIsIk90aGVyIiwiamltQG1lbGxhbm94LmNvbSIsIlJFU09M
VkVEIiwiRklYRUQiLCJzZHAgc2VydmVyIGFjY2VwdDogQlVHOiBzY2hlZHVsaW5nIHdoaWxl
IGF0b21pYzogaWJfY20uLi4iCjgyOCwibm9ybWFsIiwiUDMiLCJSSEVMIDUiLCJqaW1AbWVs
bGFub3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlNEUCBhY2NlcHQoKSBmYWlscyB3aXRo
IENPTkZJR19QUkVFTVBUIGtlcm5lbCIKODMzLCJub3JtYWwiLCJQMyIsIk90aGVyIiwiamFj
a21AZGV2Lm1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIklQb2liIGhhbmdv
dXQgd2hpbGUgcnVubmluZyBzZHAgd2l0aCBtdWx0aXBsZSIKODM4LCJub3JtYWwiLCJQMyIs
IlJIRUwgNSIsImppbUBtZWxsYW5veC5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiY29ubmVj
dGlvbiByZWZ1c2UiCjg5NCwibWFqb3IiLCJQMiIsIlNMRVMgMTAiLCJqaW1AbWVsbGFub3gu
Y29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIklQb0lCIGNvbm5lY3Rpdml0eSBsb3N0IGR1cmlu
ZyBoZWF2eSB0ZXN0aW5nIG9uIG1lbWZyZWUiCjkxMiwibm9ybWFsIiwiUDMiLCJSSEVMIDQi
LCJqaW1AbWVsbGFub3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIldoZW4gcmVtb3RlIHNp
ZGUgaXMgbm90IGFjY3Nlc3NpYmxlIGFuZCBzb2NrZXQgYmFzZWQgYXBwbGljYXRpb24gaXMg
cnVubmluZyBvdmVyIFNEUCByZWZlcmVuY2UgY291bnQgaXMgaGlnaCIKOTY5LCJub3JtYWwi
LCJQMyIsIlJIRUwgNCIsImppbUBtZWxsYW5veC5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwi
SFRUUCBvdmVyIFNEUCB3aXRoIDIwMCAgY29ubmVjdGlvbiBjYXVzZSB0byBrZXJuZWwgcGFu
aWMgaW4gY2xpZW50IHNpZGUiCjk3Nywibm9ybWFsIiwiUDMiLCJBbGwiLCJqaW1AbWVsbGFu
b3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsImJpbmRpbmcgMiBzb2NrZXRzIHRvIHRoZSBz
YW1lIGFkZHJlc3MgZmFpbHMgd2l0aCB0aGUgd3JvbmcgZXJybm8iCjk5OCwibm9ybWFsIiwi
UDMiLCJPdGhlciIsImppbUBtZWxsYW5veC5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiaW50
ZXJtaXR0ZW50IFNEUCBCVUcgb24gcHBjNjQiCjEwODcsIm1pbm9yIiwiUDUiLCJTTEVTIDEw
IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwicmVjb3Zlcnkg
ZnJvbSByZG1hX2NyZWF0ZV9xcCgpICBpcyBiYWQiCjEyNDIsIm5vcm1hbCIsIlAyIiwiUkhF
TCA0IiwiZGF2ZS5vbHNvbkBxbG9naWMuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsImtlcm5l
bCBwYW5pYyB3aGlsZSBydW5uaW5nIG1waTIwMDcgYWdhaW5zdCBvZmVkMS40IC0tIGliX2lw
YXRoOiBpcGF0aF9zZG1hX3ZlcmJzX3NlbmQiCjEzMTAsIm5vcm1hbCIsIlAzIiwiT3RoZXIi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJzdHJlc3NfY29u
bmVjdCBjcmFzaCBzb21ldGltZXMgb24gU1cyMjAvU1cyMjEiCjEzMzQsIm5vcm1hbCIsIlAz
IiwiT3RoZXIiLCJ0aW5hLnlhbmdAb3JhY2xlLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJw
b3NzaWJsZSBsb2NrIG9yZGVyaW5nIGlzc3VlIgoxMzkzLCJtaW5vciIsIlAzIiwiU0xFUyAx
MCIsImFuZHkuZ3JvdmVyQG9yYWNsZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiRG1lc2cg
ZXJyb3JzIGFmdGVyIHJ1bm5pbmcgcmRzLWdlbi9zaW5rIHRlc3RzIgoxMzk3LCJub3JtYWwi
LCJQMyIsIlNMRVMgMTAiLCJwYXNoYUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklY
RUQiLCJFZ2xlIFNEUiBhZ2FpbnMgRmFsY29uIFFEUiBkb27igJl0IHJ1biB3aXRoIG5ldyBt
dmFwaWNoLTEuMS4wIgoxNDI3LCJub3JtYWwiLCJQMyIsIkFsbCIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsInJ1bm5pbmcgbmV0cGVyZiBvbiBwcGM2NCwg
cmVzdWx0cyBpbiBwcmVsb2FkIGVycm9yIGFuZCBjYXVzZXMgdGhlIGNsaWVudCBtYWNoaW5l
IHRvIGhhbmciCjE0NDAsImJsb2NrZXIiLCJQMyIsIkFsbCIsIm9yZW5rQGRldi5tZWxsYW5v
eC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJtc3R2cGQgaGFuZ3Mgb24gUURSIEhDQXMi
CjE0NDUsIm5vcm1hbCIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNP
TFZFRCIsIkZJWEVEIiwicmVtb3ZpbmcgYSB0ZXN0IG1vZHVsZSB3aGljaCBpcyB1c2luZyB0
aGUga2VybmVsIHNvY2tldCBhcGkgb3ZlciBzZHAsIGNhdXNlcyB0aGUgbWFjaGluZSB0byBo
YW5nIgoxNDUzLCJtaW5vciIsIlAzIiwiT3RoZXIiLCJhbmR5Lmdyb3ZlckBvcmFjbGUuY29t
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIlJEUyB1c2Ugb2YgUVBEX1NRRCBzdGF0ZSBjYXVzZXMg
cHJvYmxlbXMgZm9yIENvbm5lY3RYIEhDQXMiCjE1MDIsIm5vcm1hbCIsIlAzIiwiT3RoZXIi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCIyLjYuMTYuNDYt
MC4xMi1TTEVSVC0xMC0xNTogc2NoZWR1bGluZyB3aGlsZSBhdG9taWMiCjE1MTksIm5vcm1h
bCIsIlAzIiwiT3RoZXIiLCJhbmR5Lmdyb3ZlckBvcmFjbGUuY29tIiwiUkVTT0xWRUQiLCJG
SVhFRCIsIlJEUyBtYXkgYmUgZG9pbmcgdG8gbXVjaCBhdCBpbnRlcnJ1cHQgbGV2ZWwiCjE1
NTIsIm5vcm1hbCIsIlAzIiwiUkhFTCA0IiwiYW5keS5ncm92ZXJAb3JhY2xlLmNvbSIsIlJF
U09MVkVEIiwiRklYRUQiLCJzcHVyaW91cyByZWFkIGV2ZW50cyBvbiAgUkRTIHNvY2tldCIK
MTU5MCwibm9ybWFsIiwiUDMiLCJPdGhlciIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIlVubmVjZXNzYXJ5IHNvY2tfaG9sZCBpbiBzZHBfcmVzZXRfc2so
KSIKMTYxMiwibm9ybWFsIiwiUDMiLCJSSEVMIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIs
IlJFU09MVkVEIiwiRklYRUQiLCJraWxsaW5nIHN0cmVzc19jb25uZWN0IHRlc3QgcmVzdWx0
cyBpbiBLZXJuZWwgQlVHIG9uIHBwYzY0IG1hY2hpbmUiCjE2ODIsIm5vcm1hbCIsIlAzIiwi
T3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJMb3cg
cGVyZm9ybWFuY2Ugb24gb2ZlZC0xLjUiCjE3MTQsIm5vcm1hbCIsIlAzIiwiUkhFTCA1Iiwi
am9uQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJSSEVMNS4z
IGhvc3Qgc2hvd3MgdHJhY2ViYWNrIGFmdGVyIHRoZSBuZnMtcmRtYSBzZXJ2ZXIgaXMgcmVz
dGFydGVkIgoxNzE2LCJub3JtYWwiLCJQMyIsIlJIRUwgNSIsImFuZHkuZ3JvdmVyQG9yYWNs
ZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiUG9vciBwZXJmb3JtYW5jZSB3aXRoIFJEUyAx
LjQuMSBvciAxLjQuMiIKMTcxOSwibm9ybWFsIiwiUDMiLCJPdGhlciIsInRvbUBvcGVuZ3Jp
ZGNvbXB1dGluZy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiUmVjb25uZWN0IHBhdGggaW4g
TGludXggY2xpZW50IGNhbiBsb29wIGluZGVmaW5pdGVseSIKMTc0Miwibm9ybWFsIiwiUDMi
LCJSSEVMIDUiLCJ0aW5hLnlhbmdAb3JhY2xlLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJJ
bnRlcnJ1cHQgYmFsYW5jaW5nIGFjcm9zcyBDUFVzIGRvZXMgbm90IHdvcmsgd2l0aCBSRFMg
MS40LjIiCjE3NjEsIm5vcm1hbCIsIlAzIiwiUkhFTCA1IiwiYW5keS5ncm92ZXJAb3JhY2xl
LmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJSRFMgdHJhZmZpYyBzdGFsbHMgd2l0aCAxLjQu
MiB3aGVuIHRoZXJlIGlzIGNvbmdlc3Rpb24iCjE3NzQsImNyaXRpY2FsIiwiUDMiLCJTTEVT
IDExIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlZFUklGSUVEIiwiRklYRUQiLCJJbnN0YWxs
aW5nIE9GRUQxLjUgUkMxIG9uIFNMRVMxMSBvbiBtYWNoaW5lIHdpdGggT0ZFRC1kaXN0cm8g
ZG9lcyBub3QgcmVtb3ZlIG9mZWQta21wIgoxODAwLCJjcml0aWNhbCIsIlAzIiwiUkhFTCA1
IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJWRVJJRklFRCIsIkZJWEVEIiwiaXBlcmYgc2Rw
IG9uIHBwYyBjYXVzZSB0byBjbGllbnQgbWFjaGluZSB0byBkZWFkIGxvY2siCjE4MDgsIm5v
cm1hbCIsIlAzIiwiUkhFTCA1IiwibW9uaXNAdm9sdGFpcmUuY29tIiwiVkVSSUZJRUQiLCJG
SVhFRCIsIkJvbmRpbmc6IEVycm9yIGluIG5ldHdvcmsgcmVzdGFydCBvdXRwdXQgYWZ0ZXIg
Y29uZmlndXJlIGNvbnNpc3RlbnQgY29uZmlndXJhdGlvbiBvZiBib25kaW5nIgoxODIxLCJt
YWpvciIsIlAzIiwiUkhFTCA1IiwibW9uaXNAdm9sdGFpcmUuY29tIiwiUkVTT0xWRUQiLCJG
SVhFRCIsIkNyYXNoIGluIGJvbmRpbmciCjE4MjYsImNyaXRpY2FsIiwiUDMiLCJPdGhlciIs
ImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIklwZXJmIHNkcCB3
aXRoIG1vcmUgdGhhbiA1MCBjb25uZWN0aW9ucyBjYXVzZSB0byBjYWxsIHRyYWNlIG9uIGNs
aWVudCBzaWRlIChSSDUgdXA0KSIKMTgyOCwibm9ybWFsIiwiUDMiLCJBbGwiLCJlbGlAbWVs
bGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiaWJ2X3F1ZXJ5X3BvcnQgbWFuIHBh
Z2Ugc2hvdWxkIGJlIHVwZGF0ZWQiCjE4NDAsImNyaXRpY2FsIiwiUDEiLCJBbGwiLCJ0b21A
b3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlNvbWUgTkZTIGxh
cmdlIHRyYW5zZmVycyBzdGFsbCIKMTg1MSwibWFqb3IiLCJQMyIsIkNlbnRPUyA1IiwidG9t
QG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJDcmFzaCB3aGVu
IHJ1bm5pbmcgZnN0cmVzcyB3aXRoIGEgbGFyZ2UgbnVtYmVyIG9mIHRocmVhZHMiCjE4NTks
Im5vcm1hbCIsIlAyIiwiQWxsIiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklY
RUQiLCJJUE9JQiBDYW4gbWlzcyBhIGNoYW5nZSBpbiBkZ2lkIgoxODY1LCJub3JtYWwiLCJQ
MSIsIk90aGVyIiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk1p
eGVkIHBvcnQgY29uZmlndXJhdGlvbiBkb2VzIG5vdCB3b3JrLiIKMTg2Niwibm9ybWFsIiwi
UDMiLCJPdGhlciIsImVsaUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJy
cGluZyBvb3BzIGluIG1peGVkIGNvbmZpZ3VyYXRpb24iCjE4NzMsIm1ham9yIiwiUDMiLCJS
SEVMIDUiLCJlbGlAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiSVBvSUIg
ZXJyb3JzIGZvdW5kIGluIGxvZyIKMTg3OCwibm9ybWFsIiwiUDMiLCJPdGhlciIsImFtaXJ2
QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlNEUCAxLjUgLSBzbWFsbCBw
YWNrZXRzIG11bHRpIHN0cmVhbSBnaXZlcyBiYWQgcGVyZm9ybWFuY2UiCjE4NzksIm5vcm1h
bCIsIlAzIiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklY
RUQiLCJNU0dfUEVFSyBpcyBub3Qgc3Bwb3J0ZWQgb24gWkNvcHkiCjE4ODcsIm5vcm1hbCIs
IlAzIiwiQWxsIiwiam9oYW5uQGdlb3JnZXgub3JnIiwiUkVTT0xWRUQiLCJGSVhFRCIsInFw
ZXJmIGRvZXNuJ3Qgc3VwcG9ydCBvcGVyYXRpb24gYmV0d2VlbiBERFIgYW5kIFFEUiBzZXJ2
ZXJzIgoxODk1LCJibG9ja2VyIiwiUDIiLCJBbGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIs
IlJFU09MVkVEIiwiRklYRUQiLCJzZHAgdGhyb3dzIHVwICIiIHNkcF9hbGxvY19mbXIgIiIg
ZXJyb3Igd2hpbGUgcnVubmluZyBxcGVyZiB0ZXN0cyIKMTg5Nywibm9ybWFsIiwiUDMiLCJB
bGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTZW5kIGRh
dGEgZmFpbGVkIGluIGJvdGggZGlyZWN0aW9ucywgYXQgdGhlIHNhbWUgdGltZSwgYnkgWmNv
cHkuIgoxODk5LCJtYWpvciIsIlAzIiwiUkhFTCA0IiwiYW1pcnZAbWVsbGFub3guY28uaWwi
LCJSRVNPTFZFRCIsIkZJWEVEIiwiR2V0dGluZyB0aW1lciByZWxhdGVkIHdhcm5pbmdzIHdo
ZW4gcnVubmluZyBzZHAgdGVzdHMgb24gUkhFTCA0LjgiCjE5MDAsIm5vcm1hbCIsIlAzIiwi
QWxsIiwiamFja21AbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiVGhlIGV4
YW1wbGUgdGVzdCBJYnZfc3JxX3Bpbmdwb25nIGFsd2F5cyBmYWlsIHdoZW4gcnVuIG92ZXIg
SUIgbGluayIKMTkwOCwibWFqb3IiLCJQMyIsIlJIRUwgNSIsImFuZHkuZ3JvdmVyQG9yYWNs
ZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiUnVubmluZyDigJhyZHMtdG9vbHMvcmRzLWdl
biDigJNsIDQwOTbigJkgb3ZlciBSb0NFRSByZXN1bHRzIGluIGtlcm5lbCBwYW5pYyIKMTkx
MCwibWFqb3IiLCJQMyIsIkFsbCIsImVsaUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
RklYRUQiLCJSdW5uaW5nIHVjbWF0b3NlIG92ZXIgUm9DRUUgcmVzdWx0cyBpbiBLZXJuZWwg
cGFuaWMiCjE5MTIsImJsb2NrZXIiLCJQMSIsIlNMRVMgMTEiLCJhbWlydkBtZWxsYW5veC5j
by5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTRFAgZG9lc24ndCB3b3JrIG9uIFBQQzY0IFNM
RVMxMSIKMTkxNSwibm9ybWFsIiwiUDMiLCJSSEVMIDUiLCJtb25pc0B2b2x0YWlyZS5jb20i
LCJSRVNPTFZFRCIsIkZJWEVEIiwiQm9uZGluZzogUmVtb3ZpbmcgdmxhbiBvZiBib25kMSAo
ZXRoKSBjYXVzZSB0byBrZXJuZWwgcGFuaWMiCjE5MTcsImNyaXRpY2FsIiwiUDMiLCJSSEVM
IDUiLCJzaGlyaWZAdm9sdGFpcmUuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlJ1bmluZyBp
cGVyZiBhbmQgbmV0cGVyZiBvdmVyIFNEUCBmb3IgbG9uZyB0aW1lIGNhdXNlIHRvIGNhbGwg
dHJhY2UgKG9uIGtlcm5lbCAyLjYuMjQpIgoxOTE4LCJibG9ja2VyIiwiUDEiLCJBbGwiLCJz
ZWFuLmhlZnR5QGludGVsLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJSRE1BLUNNIGFsbG93
cyBiaW5kcyB0byAxMjcuMC4wLjEgd2hpY2gga2lsbHMgb3Blbm1waSBvdmVyIGl3YXJwIgox
OTIwLCJjcml0aWNhbCIsIlAzIiwiQWxsIiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xW
RUQiLCJGSVhFRCIsIk9GRURfMV81XzEgZG9lc24ndCBzdXBwb3J0IERyZXhsZXIncyBkZXZp
Y2UgSURzIgoxOTI0LCJtYWpvciIsIlAxIiwiUkhFTCA0IiwiZWxpQG1lbGxhbm94LmNvLmls
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9wZW4gbXBpIHRlc3Qgb3ZlciBSb0NFRSBjYXVzZSBr
ZXJuZWwgb29wcyBpbiBjbWFfcmVzb2x2ZV9yb2NlZV9yb3V0ZSIKMTkyNiwibm9ybWFsIiwi
UDMiLCJSSEVMIDQiLCJlbGlAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwi
bXVsdGljYXN0IGxlYWthZ2Ugd2hlbiB1bmxvYWRpbmcgaWJfaXBvaWIiCjE5NDUsIm1pbm9y
IiwiUDMiLCJTTEVTIDEwIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklY
RUQiLCJJbnRlcmFjdGl2ZSBpbnN0YWxsZXIgZ2VuZXJhdGVzIGZhdWx0eSBvZmVkLmNvbmYi
CjE5NTEsImNyaXRpY2FsIiwiUDMiLCJBbGwiLCJlbGlAbWVsbGFub3guY28uaWwiLCJSRVNP
TFZFRCIsIkZJWEVEIiwiT3BlbnNtIGZhaWxzIHRvIG1vdmUgdGhlIHBvcnQgdG8gQWN0aXZl
IChyZW1haW5zIEFybWVkKSIKMTk1NSwibm9ybWFsIiwiUDEiLCJSSEVMIDUiLCJhbWlydkBt
ZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTRFAgY29ubmVjdGlvbiByZXNl
dCIKMTk1OSwiY3JpdGljYWwiLCJQMyIsIlJIRUwgNSIsInRvbUBvcGVuZ3JpZGNvbXB1dGlu
Zy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiW09GRUQtMS41LjEgLU5GU292ZXJSRE1BXSAt
IE5GU292ZXJSRE1BIGNsaWVudCBoaXRzIGtlcm5lbCBwYW5pYyAgd2hpbGUgcnVubmluZyAi
Imlvem9uZSB0ZXN0ICIiIG9uIE5GUyBjbGllbnQgIGFsb25nIHdpdGggICIiaW50ZXJmYWNl
IHRvZ2dsZSB0ZXN0ICIiIG9uIE5GUyBzZXJ2ZXIgY29udGlub3VzbHkgaW4gYSBsb29wIgox
OTYyLCJibG9ja2VyIiwiUDEiLCJPdGhlciIsInRvbUBvcGVuZ3JpZGNvbXB1dGluZy5jb20i
LCJSRVNPTFZFRCIsIkZJWEVEIiwibmZzcmRtYSBjYXVzZSByZWd1bGFyIE5GUyBtb3VudHMg
dG8gaGFuZyAoT0ZFRC0xLjUuMS0yMDEwMDIyMy0wNzQwKSIKMTk2NCwiYmxvY2tlciIsIlAz
IiwiQWxsIiwic3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhF
RCIsImN4Z2IzIGZhaWxzIG9wZW5tcGkgYnJhbmRpbmciCjE5NjUsIm1ham9yIiwiUDMiLCJS
SEVMIDUiLCJ5ZXZnZW55cEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJC
b25kaW5nIG1seDRfZW46IHBpbmcgZG9lcyBub3QgcmVzdW1lIGFmdGVyIGZhaWxvdmVyIGJl
dHdlZW4gMTBHIHBvcnRzIgoxOTc4LCJtYWpvciIsIlAxIiwiUkhFTCA1IiwidnVAbWVsbGFu
b3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIktlcm5lbCBQYW5pYyB3aGVuIHVubG9hZGlu
ZyBpYl9zcnAiCjE5ODgsIm1ham9yIiwiUDIiLCJBbGwiLCJzd2lzZUBvcGVuZ3JpZGNvbXB1
dGluZy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiW09GRUQtMS41LjEtcmM0XSAtIFNvZnRp
cnEgc2VlbiBvbiBvbmUgb2YgdGhlIG5vZGVzIGFmdGVyIH40OCBob3VycyB3aGlsZSBydW5u
aW5nIDIgaW5zdGFuY2VzIGVhY2ggb2YgSU1CLU1QSTErIE9TVStQcmVzdGEgdGVzdCB0b2dl
dGhlciBvbiA2NCBiaXQgcGxhdGZvcm1zIgoxOTg5LCJjcml0aWNhbCIsIlAyIiwiT3RoZXIi
LCJrbGl0ZXluQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIltSRUddT0ZF
RC0xLjUuMSA6IE9GRUQtMS41LjEtMjAxMDAzMTctMDgwNiBpbnN0YWxsdGlvbiBmYWlscyB3
aGlsZSBidWlsZGluZyBpYnV0aWxzIFJQTSBvbiBSSEVMNFU4IDMyIGJpdCIKMTk5NSwiY3Jp
dGljYWwiLCJQMSIsIk90aGVyIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
RklYRUQiLCJbUkVHXU9GRUQtMS41LjEgOiBPRkVELTEuNS4xLTIwMTAwMzE4LTA2MDAgaW5z
dGFsbHRpb24gZmFpbHMgb24gMi42LjMwXzMyIGJpdCBrZXJuZWwgd2hpbGUgdW5pbnN0YWxs
aW5nIHByZXZpb3VzIHZlcnNpb24gb2YgT0ZFRC4i
--------------040903030304010600080907
Content-Type: text/plain;
 name="OFED_release_notes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="OFED_release_notes.txt"

	    Open Fabrics Enterprise Distribution (OFED)
	               Version 1.5.1
   	               Release Notes
	                March 2010


===============================================================================
Table of Contents
===============================================================================
1. Overview, which includes:
	- OFED Distribution Rev 1.5.1 Contents
	- Supported Platforms and Operating Systems
	- Supported HCA and RNIC Adapter Cards and Firmware Versions
	- Tested Switch Platforms
	- Third party Test Packages
	- OFED sources
2. Main Changes from OFED 1.4.2
3. Main Changes from OFED 1.5
4. Known Issues


===============================================================================
1. Overview
===============================================================================
These are the release notes of OpenFabrics Enterprise Distribution (OFED)
release 1.5.1. The OFED software package is composed of several software modules,
and is intended for use on a computer cluster constructed as an InfiniBand
subnet or iWARP network. 

Note: If you plan to upgrade the OFED package on your cluster, please upgrade
all of its nodes to this new version.


1.1 OFED 1.5.1 Contents
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
1. iSER Target and NFS-RDMA are of Beta quality.
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
	- RedHat EL5 up5 (beta)	2.6.18-186.el5
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
The following third party packages have been tested with OFED 1.5.1:
- Intel MPI, Version 3.2.2
- Intel MPI, Version 4.0 beta 

1.6 OFED Sources
----------------
All sources are located under git://git.openfabrics.org/
Kernel sources: git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
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
	  See BUILD_ID for exact locations
	o Qlogic moved the low level driver from ipath to qib.

    2.2 SDP
	o Performance improvements
	o Zero copy in beta level

    2.3 uDAPL
	o New UCM provider (ofa-v2-mlx4_0-1u) with IB UD-based CM per process.
          It is more scalable than rdma_cm (cma) or socket cm (scm). 
	o Common code base with WinOF 2.1
	o Bug fixes


    2.4 perftest
	o Renamed tests:
	  ib_rdma_bw  -> rdma_bw
	  ib_rdma_lat -> rdma_lat

    2.5 Management 
	o OpenSM
	  - Support for Mesh Analysis for LASH routing algorithm
          - Reloadable OpenSM configuration (preliminary implementation)
          - Routing paths sorted balancing (for UpDown and MinHops)
          - Weighted LID matrices calculation (for UpDown, MinHop and DOR)
          - I/O nodes connectivity (for FatTree)

    2.6 MPI:
	a. OSU MVAPICH 1.2.0
	b. Open MPI 1.4
	c. OSU MVAPICH2 1.4
	d. MPI tests 3.2

    2.7 iSER:
	o Available only on kernel.org 2.6.30, 2.6.31 and 2.6.32

    2.8 NFS-RDMA
	o Added support for RHEL5.4, SLES10 SP3, kernel.org 2.6.25 and 2.6.30.
	  Kernels 2.6.26 and 2.6.27 are not supported
	o NFS-RDMA is in Beta level

===============================================================================
3. Main Changes from OFED 1.5
===============================================================================
1. Added RoCEE support - see RoCEE_README.txt
2. Added enhanced atomic operations to ConnectX (kernel only).
   See mlx4_release_notes.txt.
3. Updated Open MPI to rev 1.4.1-2ofed
4. Updated MVAPICH2 to rev 1.4.1
5. Updated DAPL to rev 2.0.27
6. Updated libnes to rev 1.0.1
7. Updated librdmacm to rev 1.0.11
8. Removed tvflash RPM
9. NFS-RDMA is not supported on SLES10 SP3
10. Fixed IPv6 support and IPv4 routing corner cases for RDMA CM
11. Bug fixes


===============================================================================
4. Known Issues
===============================================================================
The following is a list of general limitations and known issues of the various
components of the OFED 1.5.1 release.

1. When upgrading from an earlier OFED version, the installation script does
   not stop the earlier OFED version prior to uninstalling it. 
   Workaround: Stop the old OFED stack (/etc/init.d/openibd stop) before 
   upgrading to OFED 1.5.1 or reboot the server after OFED installation.
2. Memory registration by the user is limited according to administrator
   setting. See "Pinning (Locking) User Memory Pages" in OFED_tips.txt for
   system configuration.
3. Fork support from kernel 2.6.12 and above is available provided
   that applications do not use threads. fork() is supported as long as the
   parent process does not run before the child exits or calls exec().
   The former can be achieved by calling wait(childpid), and the latter can be
   achieved by application specific means.  The Posix system() call is
   supported.
4. The qib driver is supported only on 64-bit platforms.
5. When installing OFED on OpenSuse or Ubuntu, use the --without-depcheck
   option of the install.pl script.
6. IPoIB: brctl utilities do not work on IPoIB interfaces. The reason for that
   is that these utilities support devices of type Ethernet only.
7.  "openibd stop" can sometime fail with the error: 
        Unloading ib_cm                                            [FAILED]
        ERROR: Module ib_cm is in use by ib_ipoib 
    Workaround: run "openibd stop" again or remove ib_ipoib aliases from 
                /etc/modprobe.conf.
8. When working with ISCSI over IPoIB or mlx4_en, you must disable LRO (even
   if IPoIB is set to connected mode). This is due to a bug in older kernels
   which causes a kernel panic.
9. On SLES11, and in case uninstall is failing, check the error log and remove
   the remaining RPMs manually using 'rpm -e <rpms list>'.
10. On SLES11, set allow_unsupported_modules parameter to 1 in file:
    /etc/modprobe.d/unsupported-modules. Without this the modules will not
    load.
11. iSER is supported on kernel.org 2.6.30, 2.6.31 and 2.6.32 only.
    OFED-1.5 will not install iSER on other kernels, and the original iSER
    module that comes with the Linux distribution will stop working due to a
    mismatch in the symbols version.
12. On SLES10 SP3, the kernel 2.6.16.60-0.54.5 should be updated to
    2.6.16.60-0.59.1 or later. The original kernel may cause kernel panic
    during '/etc/init.d/openibd restart'.

Note: See the release notes of each component for additional issues.



--------------040903030304010600080907--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
