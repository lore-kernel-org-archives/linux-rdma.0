From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.3 GA is available
Date: Thu, 10 Mar 2011 23:10:31 +0200
Message-ID: <4D793E47.9030407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060707020609050904020603"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060707020609050904020603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I am pleased to announce that OFED-1.5.3 GA release is done

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5.3/release/OFED-1.5.3.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla http://bugs.openfabrics.org/  for
OFED 1.5.3

Vladimir & Tziporet

========================================================================
Release information:
--------------------
Linux Operating Systems:

         - RedHat EL5 up4        2.6.18-164.el5
         - RedHat EL5 up5        2.6.18-194.el5
         - RedHat EL5 up6        2.6.18-238.el5
         - RedHat EL6            2.6.32-71.el6
         - SLES10 SP3            2.6.16.60-0.54-smp
         - SLES11                2.6.27.19-5-default
         - SLES11 SP1            2.6.32.12-0.7-default
         - CentOS5.4             2.6.18-164.el5
         - CentOS5.5             2.6.18-194.el5
         - OpenSuSE 11.2         2.6.31.5-0.1-default *
         - kernel.org            2.6.29 - 2.6.36    *

       * Minimal QA for these versions

CPU architectures:
         - x86_64
         - x86
         - ppc64
         - ia64

Main Changes from OFED 1.5.2
============================
1. Updated packages:
    dapl-2.0.32
    librdmacm-1.0.14.1
    ibacm-1.0.4
    libibmad-1.3.7
    libibumad-1.3.7
    infiniband-diags-1.5.8
    opensm-3.3.9
    ibutils-1.5.7
    libibverbs-1.1.4-1.22.g7257cd3.tar.gz
    libmlx4-1.0.1-1.18.gb810a27.tar.gz
    libnes-1.1.1
    infinipath-psm-1.14
    libsdp-1.1.108-0.15.gd7fdb72
    mstflint-1.4-0.9.gc683022
    sdpnetstat-1.60-0.3.gb6e7425
    perftest-1.3.0-0.42.gf350d3d

    - MPI
      openmpi-1.4.3-1
      mvapich2-1.6-2

2. Added RHEL6 support
3. Added RHEL5.6 support
4. Improved RAW Ethernet QP support (requires ConnectX/ConnectX2 FW >= 2.8.0600)
5. NFSoRDMA was removed from the list of packages in the install script to
    prevent its installation by default.
    To force NFSoRDMA installation, add the following lines to the ofed.conf:
    nfsrdma=y
    rnfs-utils=y

    To get ofed.conf, run
    # ./install.pl -p

    After adding the lines above to ofed.conf, to install OFED run
    # ./install.pl -c ofed.conf
6. Bug fixes
         See attached.

--------------060707020609050904020603
Content-Type: text/csv;
 name="bugs-2011-03-10.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2011-03-10.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9kZXNjIgoyMDAwLCJjcml0aWNh
bCIsIlAzIiwiT3RoZXIiLCJlbGlAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVE
IiwiTXVsdGljYXN0ICBvdmVyIElQb0lCIC0gZG9lc24ndCBsZWF2ZSBNQyBncm91cCB3aGVu
IE1DIHNlcnZlciBlbmRzIgoyMDMxLCJtYWpvciIsIlAzIiwiQWxsIiwiZWxkYWR6QG1lbGxh
bm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIktlcm5lbCBidWcgYXQgc29mdGlycSBk
dXJpbmcga2lsbGVkIHBvbHlncmFwaCB0ZXN0IgoyMDUxLCJub3JtYWwiLCJQMyIsIkFsbCIs
InNhc2hha0B2b2x0YWlyZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiUmVncmVzc2lvbjog
T3BlblNNIG5vdyBwcm9ncmFtcyBiYXNlIFNQMCBTTDJWTCBtYXBzIgoyMDgyLCJtYWpvciIs
IlAxIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVE
IiwiU0RQIG1vZHVsZSB1bmxvYWRzIHdpdGggb3JwaGFuIGNvdW50IG1lc3NhZ2UiCjIwOTIs
Im1ham9yIiwiUDEiLCJPdGhlciIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQi
LCJGSVhFRCIsIktlcm5lbCBQYW5pYyB1bmRlciBsb25nIHJ1biBpcGVyZiBzdHJlc3MiCjIw
OTYsIm1ham9yIiwiUDMiLCJPdGhlciIsImlkb3NAZGV2Lm1lbGxhbm94LmNvLmlsIiwiVkVS
SUZJRUQiLCJGSVhFRCIsImliLXNlbmRfKiBhbmQgaWJfd3JpdGVfKiBvbiBpYTY0IGRvZXMg
bm90IHdvcmsgb24gT0ZFRDEuNS4yIFJDMyIKMjEwOSwibm9ybWFsIiwiUDMiLCJPdGhlciIs
ImphY2ttQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIlNlbmQgZmFpbHVy
ZSB3aXRoIHNlbmQgKyBtYXggaW5saW5lIDkwMCBvbiBtc2cgc2l6ZXMgb2YgJzg4NSAtIDkw
MCcgYnl0ZXMiCjIxMTksIm5vcm1hbCIsIlA0IiwiU0xFUyAxMCIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsInNlbGVjdF90ZXN0IGNhdXNlcyBzZXJ2ZXIg
dG8gaGFuZyAob3V0IG9mIG1lbW9yeSkiCjIxMjcsIm1ham9yIiwiUDEiLCJSSEVMIDUiLCJh
bWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTRFAgaW4gQlhPRkVE
LiBLZXJuZWwgUGFuaWMgZHVyaW5nIG5ldHdvcmsgc3RyZXNzIG9uIGJvdGggcG9ydHMiCjIx
MjgsIm5vcm1hbCIsIlAzIiwiT3RoZXIiLCJlbGlAbWVsbGFub3guY28uaWwiLCJWRVJJRklF
RCIsIkZJWEVEIiwiVUQgaW5saW5lIHBhY2tldHMgd2l0aCBtZXNzYWUgc2l6ZSA+IDg4NEIg
ZmFpbHMgKGFuZCBkb2VzIG5vdCBhbm5vdW5jZSBmYWlsdXJlKS4iCjIxMjksIm5vcm1hbCIs
IlA0IiwiU0xFUyAxMSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhF
RCIsImNsb3NlX3Rlc3QgZmFpbHMgb24gY2FzZSAjNCAoU0hVVERPV05fUkVDVikiCjIxMzAs
Im5vcm1hbCIsIlA0IiwiU0xFUyAxMSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xW
RUQiLCJGSVhFRCIsImxpYnNkcC5zbyBpcyBub3QgbGlua2VkIHRvIGxpYnNkcC5zby4xIgoy
MTMxLCJjcml0aWNhbCIsIlAxIiwiT3RoZXIiLCJzd2lzZUBvcGVuZ3JpZGNvbXB1dGluZy5j
b20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiTlA2NCBnYXRoZXIgcnVucyBzdGFsbCIKMjEzMiwi
Y3JpdGljYWwiLCJQMiIsIk90aGVyIiwic3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29tIiwi
UkVTT0xWRUQiLCJGSVhFRCIsIkxhcmdlIGlXQVJQIE1QSSBjbHVzdGVycyBuZWVkIHVjbWEg
bWF4IGJhY2tsb2cgc2V0IHRvIDEwMjQiCjIxMzgsIm5vcm1hbCIsIlAzIiwiUkhFTCA1Iiwi
YW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwidW5rbm93biBzeW1i
b2wgb24gUkg1LjUgMzIgYml0IC0gZHJpdmVyIGNhbid0IGxvYWQiCjIxMzksIm1ham9yIiwi
UDEiLCJPdGhlciIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIs
Iktlcm5lbCBQYW5pYyBpbiBPRUw1LjUgZHVyaW5nIFNEUCBzdHJlc3Mgb24gYm90aCBwb3J0
cyIKMjE0MiwibWFqb3IiLCJQNSIsIkNlbnRPUyA1IiwiamFja21AbWVsbGFub3guY28uaWwi
LCJSRVNPTFZFRCIsIkZJWEVEIiwiaWJfc2VuZF9idyBkb2Vzbid0IHNlbmQvcmVjZWl2ZWQg
dHJhZmZpYyIKMjE0NSwibm9ybWFsIiwiUDUiLCJBbGwiLCJhbWlydkBtZWxsYW5veC5jby5p
bCIsIlJFU09MVkVEIiwiRklYRUQiLCJTZWN1aXJ0eSB0aHJlYXQgaW4gbGlic2RwIgoyMTQ2
LCJjcml0aWNhbCIsIlA1IiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNP
TFZFRCIsIkZJWEVEIiwiU0RQIGxhdGVuY3kgZGVncmFkYXRpb24gZnJvbSBPRkVEMS41LjIg
cmMzIHRvIE9GRUQgR0EiCjIxNTAsIm1ham9yIiwiUDMiLCJTTEVTIDExIiwiYW1pcnZAbWVs
bGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiTmV0cGVyZiBzdHVjayB3aXRoIGNh
bGwgdHJhY2Ugb24gU0RQIG92ZXIgUm9DRSIKMjE2MSwibm9ybWFsIiwiUDUiLCJSSEVMIDUi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIsIkZJWEVEIiwiU0RQIGxlYXZlcyBj
b25uZWN0aW9ucyBpbiBzdGF0dXMgQ0xPU0UiCjIxNjIsIm5vcm1hbCIsIlA1IiwiQWxsIiwi
amFja21AbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiZHJpdmVyIHJlcG9y
dHMgd3JvbmcgcmF0ZSB3aXRoIENvbm5lY3RYMiBFTiIKMjE2NywiYmxvY2tlciIsIlA1Iiwi
T3RoZXIiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlNMRVMx
MVNQMSdzIHhlbiA0LjAgcmVxdWlyZXMgbmV3IGJ1aWxkIGRpcmVjdGl2ZXMgaW4gTElOVVhJ
TkNMVURFIgoyMTY4LCJjcml0aWNhbCIsIlA1IiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28u
aWwiLCJDTE9TRUQiLCJGSVhFRCIsIlNEUCBpcyBub3Qgd29ya2luZyBvbiBBcmJlbCBzaW5j
ZSBPRkVELWludGVybmFsLTEuNS4yLTIwMTAxMTEwLTExMjgiCjIxNzIsIm1pbm9yIiwiUDUi
LCJBbGwiLCJpZG9zQGRldi5tZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJp
Yl9yZWFkX2J3IGRvZXMgbm90IHdvcmsgd2l0aCBMZWdhY3kgSENBcyIKMjE3NSwiY3JpdGlj
YWwiLCJQNSIsIk90aGVyIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlZFUklGSUVEIiwiRklY
RUQiLCJDb21waWxhdGlvbiBvZiBkYWlseSBPRkVEMS41LjMgKDMwLTExLTIwMTApIG9uIFJI
NiBmYWlscyBkdWUgdG8gbWlzc2luZyBzeXN5c2ZzdXRpbHMtZGV2ZWxzZnN1dGlscy1kZXZl
bCIKMjE4MSwibWlub3IiLCJQNSIsIkFsbCIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIkJvZ3VzIGZvcGVuIGNhbGxzIGluIHNkcG5ldHN0YXQtMS42MCIK
MjE4OCwiY3JpdGljYWwiLCJQNSIsIkFsbCIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiQ0xP
U0VEIiwiRklYRUQiLCJ0aHJlc2hvbGRzX3Rlc3Qgb3ZlciBSb0NFIGNhdXNlcyBzZXJ2ZXIg
dG8gaGFuZyIKMjE4OSwiZW5oYW5jZW1lbnQiLCJQNSIsIk90aGVyIiwiYW1pcnZAbWVsbGFu
b3guY28uaWwiLCJDTE9TRUQiLCJGSVhFRCIsIkFkZCBJUHY2IHN1cHBvcnQiCjIxOTIsIm5v
cm1hbCIsIlA1IiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJDTE9TRUQiLCJGSVhF
RCIsIk1hbnkgd3JvbmcgZXJybm9zIgoyMTkzLCJtYWpvciIsIlA1IiwiT3RoZXIiLCJ2bGFk
QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIltPRkVELTEuNS4zLXJjMV0g
OiBrZXJuZWwgQUJJIHZlcnNpb24gbWlzbWF0Y2hlcyB3aXRoIGxpYmlidmVyYnMgb24gMi42
LjM0KDMyIEJpdCkga2VybmVsLiIKMjE5NywibWlub3IiLCJQNSIsIlJlZEhhdCBGZWRvcmEg
Q29yZSA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJDTE9TRUQiLCJGSVhFRCIsInR0Y3Ag
ZmFpbHMgb3BlbmluZyBjb25uZWN0aW9uIHdoaWxlIHRyYWZmaWMgZGlyZWN0ZWQgdmlhIFNE
UCBvbmx5OyBlcnJubz05NyIKMjE5OCwiZW5oYW5jZW1lbnQiLCJQNSIsIlJlZEhhdCBGZWRv
cmEgQ29yZSA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwi
ZWVlZSIKMjIwMCwiYmxvY2tlciIsIlA1IiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwi
LCJDTE9TRUQiLCJGSVhFRCIsImlwdjYgb3ZlciBpcHY0IGRvZXNuJ3Qgd29yayIKMjIwMSwi
Y3JpdGljYWwiLCJQNSIsIkFsbCIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwi
RklYRUQiLCJpcHY2IHN0cnVjdCBzb2NrYWRkcl9pbjYuc2luNl9zY29wZV9pZCBkb2Vzbid0
IHdvcmsiCjIyMDMsIm1ham9yIiwiUDEiLCJPdGhlciIsInZsYWRAbWVsbGFub3guY28uaWwi
LCJSRVNPTFZFRCIsIkZJWEVEIiwiW09GRUQtMS41LjMtcmMxXSBvZmFfa2VybmVsIGNvbXBp
bGF0aW9uIGZhaWxzIHdpdGggU0xFUzExU1AxIGFuZCBSSEVMNi4wIG9uIFBQQzY0IgoyMjA2
LCJjcml0aWNhbCIsIlA1IiwiUkhFTCA1Iiwic3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29t
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIltPRkVELTEuNS4zLXJjMV0gOiBJbnN0YWxsYXRpb24g
b2YgT0ZFRC0xLjUuMyBmYWlscyBvbiAyLjYuMzYgKCAzMiBiaXQpIGtlcm5lbC4iCjIyMDcs
Im5vcm1hbCIsIlA1IiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJDTE9TRUQiLCJG
SVhFRCIsImNvbm5lY3QoKSBmYWlscyBpZiBiaW5kKCkgaXMgZG9uZSBpbiBjbGllbnQgLSBJ
UHY2IgoyMjA4LCJtYWpvciIsIlA1IiwiUmVkSGF0IEZlZG9yYSBDb3JlIDUiLCJhbWlydkBt
ZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTRFAgLSBsaWJzZHAuY29uZiBw
YXJhbWV0ZXJzIHBhcnNpbmcgPT4gc3ltYm9sIGxvb2t1cCBlcnJvciIKMjIxMSwibm9ybWFs
IiwiUDUiLCJSZWRIYXQgRmVkb3JhIENvcmUgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwi
Q0xPU0VEIiwiRklYRUQiLCJFYWNoIHNoZWxsIGNvbW1hbmQgZXhlY3V0aW9uICh3aGlsZSBT
RFAgZW5hYmxlZCkgZm9sbG93ZWQgYnkgSlVOSyBzY3JlZW4gb3V0cHV0IgoyMjE0LCJjcml0
aWNhbCIsIlA1IiwiUkhFTCA1IiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
RklYRUQiLCJDb21waWxhdGlvbiBvZiBkYWlseSBidWlsZCBPRkVEIDEuNS4zIGluIFJIRUwg
NS41IGZhaWxzIgoyMjIyLCJtYWpvciIsIlAzIiwiT3RoZXIiLCJzd2lzZUBvcGVuZ3JpZGNv
bXB1dGluZy5jb20iLCJDTE9TRUQiLCJGSVhFRCIsIkNvbXBpbGF0aW9uIG9mIE9GQSBrZXJu
ZWwgZmFpbHMgYWZ0ZXIgYXBwbHlpbmcga3JwaW5nIHBhdGNoIG9uIDIuNi4zNCIKMjIyMywi
YmxvY2tlciIsIlAxIiwiT3RoZXIiLCJzd2lzZUBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJS
RVNPTFZFRCIsIkZJWEVEIiwiSW5zdGFsbGF0aW9uIG9mIE9GRUQtMS41LjMtcmMyIGZhaWxz
IG9uIDIuNi4zNSBrZXJuZWwiCjIyMjUsIm1ham9yIiwiUDUiLCJSZWRIYXQgRmVkb3JhIENv
cmUgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkhBIHdp
dGggYm9uZGluZyBlcnJvciAtPiBTRFAgOiBVbmV4cGVjdGVkIENNQSBldmVudDogMTQiCjIy
MjYsIm1ham9yIiwiUDUiLCJSZWRIYXQgRmVkb3JhIENvcmUgNSIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkhBIHdpdGhvdXQgYm9uZGluZyBlcnJvciAt
IGNtYV9xdWVyeV9oYW5kbGVyIGZhaWxlZCB0byBnZXQgYWx0ZXJuYXRlIHBhdGggcmVjb3Jk
IgoyMjI3LCJtYWpvciIsIlA1IiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJF
U09MVkVEIiwiRklYRUQiLCJBUE0gLSBrZXJuZWwgcGFuaWM6IGNtX3NlbmRfbGFwIGlzIGNh
bGxlZCBhZnRlciBjbSBpZCBkZXN0cm95ZWQiCjIyMjgsIm1ham9yIiwiUDUiLCJSZWRIYXQg
RmVkb3JhIENvcmUgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhF
RCIsIktlcm5lbCBvb3BzK3BhbmljIHZzLiBtYWNoaW5lIGNyYXNoIHdoaWxlIHBlcmZvcm1p
bmcgcG9ydCBVcC9Eb3duIChCWE9GRUQtMS41LjItMS4zLjkxMDApIgoyMjI5LCJjcml0aWNh
bCIsIlAyIiwiU0xFUyAxMSIsInZsYWRAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJ
WEVEIiwibW12YXBpY2gyX2djYy0xLjYvbXZhcGljaDIgb3B0aW9uIGlzIG5vdCBwcmVzZW50
IHdoaWxlIGluc3RhbGxpbmcgT0ZFRCBvbiBTTEVTICBwbGF0Zm9ybXMiCjIyMzAsIm1ham9y
IiwiUDIiLCJSSEVMIDUiLCJzd2lzZUBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJDTE9TRUQi
LCJGSVhFRCIsIlJwaW5nIHN0YWxscyBhZnRlciBmaW5pc2hpbmcgaXRzIHRyYW5zYWN0aW9u
cy4iCjIyMzUsImNyaXRpY2FsIiwiUDEiLCJPdGhlciIsImRvcm9uc0B2b2x0YWlyZS5jb20i
LCJSRVNPTFZFRCIsIkZJWEVEIiwiSW5zdGFsbGF0aW9uIG9mIE9GRUQtMS41LjMtMjAxMTAy
MDYtMDgyMCAgIGZhaWxzIGlmICAiImlzZXIgbW9kdWxlIiIgaXMgY2hvb3NlbiIKMjIzNiwi
YmxvY2tlciIsIlA1IiwiUkhFTCA1IiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVE
IiwiRklYRUQiLCJvZmEta2VybmVsIGJ1aWxkIGJyZWFrcyBvbiB2YW5pbGxhIDIuNi4zMyBh
bmQgcHBjNjQgZHVlIHRvIG1pc3Npbmcga2VybmVsIHBhdGNoIgoyMjM3LCJjcml0aWNhbCIs
IlA1IiwiQWxsIiwieWV2Z2VueXBAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVE
IiwiRHJpdmVyIEhhbmdzIGluIHVuaWNhc3QgYXR0YWNoICsgcHJvbWlzdW91cyBtb2RlIgoy
MjM4LCJub3JtYWwiLCJQNSIsIk90aGVyIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09M
VkVEIiwiRklYRUQiLCJDYW5ub3QgaW5zdGFsbCBrZXJuZWwtaWIgb24gRmVkb3JhIENvcmUg
MTMi
--------------060707020609050904020603
Content-Type: text/plain;
 name="OFED_release_notes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="OFED_release_notes.txt"

	    Open Fabrics Enterprise Distribution (OFED)
	               Version 1.5.3
	               Release Notes
	               March 2011


===============================================================================
Table of Contents
===============================================================================
1. Overview, which includes:
	- OFED Distribution Rev 1.5.3 Contents
	- Supported Platforms and Operating Systems
	- Supported HCA and RNIC Adapter Cards and Firmware Versions
	- Tested Switch Platforms
	- Third party Test Packages
	- OFED sources
2. Main Changes from OFED 1.5.2
3. Main Changes from OFED 1.5.1
4. Main Changes from OFED 1.5
5. Main Changes from OFED 1.4.2
6. Known Issues


===============================================================================
1. Overview
===============================================================================
These are the release notes of OpenFabrics Enterprise Distribution (OFED)
release 1.5.3. The OFED software package is composed of several software modules,
and is intended for use on a computer cluster constructed as an InfiniBand
subnet or iWARP network. 

Note: If you plan to upgrade the OFED package on your cluster, please upgrade
all of its nodes to this new version.


1.1 OFED 1.5.3 Contents
-----------------------
The OFED package contains the following components:
 - OpenFabrics core and ULPs:
	- IB HCA drivers (mthca, mlx4, qib, ehca)
	- iWARP RNIC driver (cxgb3, nes)
	- core
	- Upper Layer Protocols: IPoIB, SDP, SRP Initiator and target, iSER 
	  Initiator and target, RDS, uDAPL, qlgc_vnic and NFS-RDMA*.
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
	- infinipath-psm: Performance-Scaled Messaging API, an accelerated 
	  interface to QLogic HCAs
 - Sources of all software modules (under conditions mentioned in the modules'
   LICENSE files)
 - Documentation

Notes:
1. iSER Target and NFS-RDMA are of Beta quality.
2. All other OFED components are of production quality.
3. See release notes for each package in the docs directory.
4. Any Topspin copyright belongs to Cisco Systems, Inc.
5. NFS-RDMA will not be installed by default. See "Main Changes from
   OFED 1.5.2"

1.2 Supported Platforms and Operating Systems
---------------------------------------------
  o   CPU architectures:
	- x86_64
	- x86
	- ppc64
	- ia64
	
  o   Linux Operating Systems:
	- RedHat EL5 up4	2.6.18-164.el5
	- RedHat EL5 up5	2.6.18-194.el5
	- RedHat EL5 up6	2.6.18-238.el5
	- RedHat EL6		2.6.32-71.el6
	- SLES10 SP3 		2.6.16.60-0.54-smp  
	- SLES11 		2.6.27.19-5-default
	- SLES11 SP1 		2.6.32.12-0.7-default
	- CentOS5.4     	2.6.18-164.el5
	- CentOS5.5     	2.6.18-194.el5
	- OpenSuSE 11.2		2.6.31.5-0.1-default *
	- kernel.org		2.6.29 - 2.6.36    *

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
	- ConnectX IB (fw-25408 Rev 2.8.0600)

	For official firmware versions please see:
	http://www.mellanox.com/content/pages.php?pg=firmware_download

  o   Qlogic HCAs:
	- QLogic TrueScale DDR PCIe x8 and x16 HCAs
	- QLogic TrueScale QDR PCIe x8 Gen2 HCAs

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
	- Oracle (Sun)
	- Mellanox

1.5 Third Party Packages
------------------------
The following third party packages have been tested with OFED 1.5.3:
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
2. Main Changes from OFED 1.5.2
===============================================================================
1. Updated packages:
   dapl-2.0.32
   librdmacm-1.0.14.1
   ibacm-1.0.4
   libibmad-1.3.7
   libibumad-1.3.7
   infiniband-diags-1.5.8
   opensm-3.3.9
   ibutils-1.5.7
   libibverbs-1.1.4-1.22.g7257cd3.tar.gz
   libmlx4-1.0.1-1.18.gb810a27.tar.gz
   libnes-1.1.1
   infinipath-psm-1.14
   libsdp-1.1.108-0.15.gd7fdb72
   mstflint-1.4-0.9.gc683022
   sdpnetstat-1.60-0.3.gb6e7425
   perftest-1.3.0-0.42.gf350d3d

   - MPI
     openmpi-1.4.3-1
     mvapich2-1.6-2

2. Added RHEL6 support
3. Added RHEL5.6 support
4. Improved RAW Ethernet QP support (requires ConnectX/ConnectX2 FW >= 2.8.0600)
5. NFSoRDMA was removed from the list of packages in the install script to
   prevent its installation by default.
   To force NFSoRDMA installation, add the following lines to the ofed.conf:
   nfsrdma=y
   rnfs-utils=y
   
   To get ofed.conf, run 
   # ./install.pl -p
   
   After adding the lines above to ofed.conf, to install OFED run 
   # ./install.pl -c ofed.conf

===============================================================================
3. Main Changes from OFED 1.5.1
===============================================================================
1. Added RHEL5.5, SLES11 SP1 and kernel 2.6.33 support
2. /etc/modprobe.conf deprecated
   ib_ipoib use /etc/modprobe.d/ib_ipoib.conf
   ib_sdp use /etc/modprobe.d/ib_sdp.conf
   mlx4_en use /etc/modprobe.d/mlx4_en.conf
3. Added RAW Ethernet QP support in libibverbs
4. Added multicast support in perftest
5. Added new package: ibacm. See ibacm_release_notes.txt
6. Added new package infinipath-psm.
7. Updated packages:
        libibverbs to rev 1.1.4-0.14.gb6c138b
        libehca to rev 1.2.2-0.1.g69e1a88
        libmlx4 to rev 1.0-0.13.g4e5c43f
        libnes to rev 1.1.0
        librdmacm to rev 1.0.13
        dapl to rev 2.0.30
        compat-depl to rev 1.2.19
        libsdp to rev 1.1.103
        mstflint to rev 1.4-0.6.g63179f4
        perftest to rev 1.3.0-0.27
        rds-tools to rev 2.0.4
        Management:
            opensm to rev 3.3.7
            libibmad to rev 1.3.6
            libibumad to rev 1.3.6
            infiniband-diags to rev 1.5.7
        MPI:
            openmpi to rev 1.4.2-1
            mvapich2 to rev 1.5.1-2.p1
            mpitests to rev 3.2-923

===============================================================================
4. Main Changes from OFED 1.5
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
5. Main Changes from OFED 1.4.2
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
	o Available on:
          - kernel.org: 2.6.30 and higher
          - RHEL5.4

    2.8 NFS-RDMA
	o Added support for RHEL5.4, SLES10 SP3, kernel.org 2.6.25 and 2.6.30.
	  Kernels 2.6.26 and 2.6.27 are not supported
	o NFS-RDMA is in Beta level

===============================================================================
6. Known Issues
===============================================================================
The following is a list of general limitations and known issues of the various
components of the OFED 1.5.3 release.

1. When upgrading from an earlier OFED version, the installation script does
   not stop the earlier OFED version prior to uninstalling it. 
   Workaround: Stop the old OFED stack (/etc/init.d/openibd stop) before 
   upgrading to OFED 1.5.3 or reboot the server after OFED installation.
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
                /etc/modprobe.d/ib_ipoib.conf.
8. When working with ISCSI over IPoIB or mlx4_en, you must disable LRO (even
   if IPoIB is set to connected mode). This is due to a bug in older kernels
   which causes a kernel panic.
9. On SLES11, and in case uninstall is failing, check the error log and remove
   the remaining RPMs manually using 'rpm -e <rpms list>'.
10. On SLES11, set allow_unsupported_modules parameter to 1 in file:
    /etc/modprobe.d/unsupported-modules. Without this the modules will not
    load.
11. iSER is supported on kernel.org 2.6.30, 2.6.31 and 2.6.32 only.
    OFED-1.5.3 will not install iSER on other kernels, and the original iSER
    module that comes with the Linux distribution will stop working due to a
    mismatch in the symbols version.
12. On SLES10 SP3, the kernel 2.6.16.60-0.54.5 should be updated to
    2.6.16.60-0.59.1 or later. The original kernel may cause kernel panic
    during '/etc/init.d/openibd restart'.
13. ConnectX/ConnectX2 in VPI mode are not supported in PPC64

Note: See the release notes of each component for additional issues.


--------------060707020609050904020603--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
