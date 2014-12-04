From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.12-1 rc4 release is available
Date: Thu, 04 Dec 2014 14:39:44 +0200
Message-ID: <54805610.3040605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1406774515388679000=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--===============1406774515388679000==
Content-Type: multipart/alternative;
 boundary="------------070407050005000605020501"

This is a multi-part message in MIME format.
--------------070407050005000605020501
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED-3.12-1-rc4 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.12-1/OFED-3.12-1-rc4.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.12-1

Release notes: 
https://openfabrics.org/downloads/OFED/release_notes/OFED_3.12-1_rc4_release_notes 


Main Changes from OFED 3.12-1-rc3
     - compat-rdma
         IB/qib: streamline qib xeon-phi patches
         qib add RHEL7 support
         RDMA/nes: Fix for register mr with zero length
     - ofed-scripts
         install.pl: Build intel-mic-psm as needed
         uninstall.sh: Replaced by perl script
         install.pl: Remove kernel version check for qib/ipathverbs
     - libocrdma-1.0.4

Regards,
Vladimir

--------------070407050005000605020501
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>

    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dutf=
-8">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <div class=3D"moz-text-flowed" style=3D"font-family: -moz-fixed;
      font-size: 12px;" lang=3D"x-unicode">Hi,
      <br>
      OFED-3.12-1-rc4 is available at:
      <br>
      <a class=3D"moz-txt-link-freetext"
href=3D"https://openfabrics.org/downloads/OFED/ofed-3.12-1/OFED-3.12-1-rc=
2.tgz">https://openfabrics.org/downloads/OFED/ofed-3.12-1/OFED-3.12-1-rc4=
.tgz</a>
      <br>
      <br>
      To get BUILD_ID run ofed_info
      <br>
      <br>
      Please report any issues in bugzilla
      <br>
      <a class=3D"moz-txt-link-freetext"
        href=3D"http://bugs.openfabrics.org/bugzilla/">http://bugs.openfa=
brics.org/bugzilla/</a>
      for OFED 3.12-1
      <br>
      <br>
      Release notes: <a class=3D"moz-txt-link-freetext"
href=3D"https://openfabrics.org/downloads/OFED/release_notes/OFED_3.12-1_=
rc2_release_notes">https://openfabrics.org/downloads/OFED/release_notes/O=
FED_3.12-1_rc4_release_notes</a>
      <br>
      <br>
      Main Changes from OFED 3.12-1-rc3<br>
      =C2=A0=C2=A0=C2=A0 - compat-rdma<br>
      =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IB/qib: streamline qib x=
eon-phi patches<br>
      =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qib add RHEL7 support<br=
>
      =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 RDMA/nes: Fix for regist=
er mr with zero length<br>
      =C2=A0=C2=A0=C2=A0 - ofed-scripts<br>
      =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 install.pl: Build intel-=
mic-psm as needed<br>
      =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uninstall.sh: Replaced b=
y perl script<br>
      =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 install.pl: Remove kerne=
l version check for qib/ipathverbs<br>
      =C2=A0=C2=A0=C2=A0 - libocrdma-1.0.4<br>
      <br>
      Regards,
      <br>
      Vladimir
      <br>
    </div>
  </body>
</html>

--------------070407050005000605020501--

--===============1406774515388679000==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/mailman/listinfo/ewg
--===============1406774515388679000==--
