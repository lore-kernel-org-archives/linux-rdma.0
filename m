From: "Hebenstreit, Michael" <michael.hebenstreit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: problems with offloading checksums
Date: Tue, 4 Feb 2014 16:20:27 +0000
Message-ID: <B4E6F7EB08816A4692C7420D7E8F8CBD866FCB99@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hardware: Intel EP server with 2x "Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.=
70GHz"
IB cards: =A0QLogic Corp. IBA7322 QDR InfiniBand HCA (rev 02) , Mellano=
x Technologies MT27500 Family [ConnectX-3]

OS: Redhat 6.4, kernel updated to latest RH supplied kernel via KSplice=
 technology
InfiniBand Software: tried IntelIB-IFS.RHEL6-x86_64.7.2.1.1.22 (based o=
n OFED 1.5.4.1) or OFED-3.5-MIC-alpha1

Problem - offloading checksumming does not work, although the Kernel do=
cumentation indicates it does

       [root@eha001 ~]# ethtool -K ib0 tx on
       Cannot set device tx-checksumming settings: Operation not suppor=
ted

IPoIB connected mode is switched of:

       SET_IPOIB_CM=3Dno

This problem exists on both Mellanox/Qlogic cards with either SW stack =
mentioned. Could anyone advise on this problem?

Thanks
Michael

-----------------------------------------------------------------------=
-
Michael Hebenstreit=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Sen=
ior Cluster Architect
Intel Corporation, MS: RR1-105/H14=A0 Software and Services Group/DCE
4100 Sara Road=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=
=A0 Tel.:=A0=A0 +1 505-794-3144=20
Rio Rancho, NM 87124
UNITED STATES=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 E-mail: michael.hebenstreit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
