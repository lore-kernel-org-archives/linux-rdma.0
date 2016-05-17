From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18-2-rc2 release is available
Date: Tue, 17 May 2016 19:21:16 +0300
Message-ID: <573B44FC.1030305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5119007416169404411=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
 <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
 <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Sender: "ewg" <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--===============5119007416169404411==
Content-Type: multipart/alternative;
 boundary="------------070303010009050404040906"

This is a multi-part message in MIME format.
--------------070303010009050404040906
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED-3.18-2-rc2 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.18-2/OFED-3.18-2-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18

Release notes:
https://www.openfabrics.org/downloads/OFED/release_notes/OFED_3.18-2-rc2_release_notes

OFED-3.18-2-rc2 Main Changes from OFED 3.18-2-rc1
-------------------------------------------------------------------------------
1. Updated packages:
   - ibpd-1.0.1
   - libiwpm-1.0.5
   - mstflint-4.3.0
2. compat-rdma changes
   - IB/security: Restrict use of the write() interface
   - xeon-phi: adjust mlx5_ib bug fix releated to large memory region 
registration

Regards,
Vladimir

--------------070303010009050404040906
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
      OFED-3.18-2-rc2 is available at:<br>
<a class=3D"moz-txt-link-freetext" href=3D"https://openfabrics.org/downlo=
ads/OFED/ofed-3.18-2/OFED-3.18-2-rc2.tgz">https://openfabrics.org/downloa=
ds/OFED/ofed-3.18-2/OFED-3.18-2-rc2.tgz</a><br>
      <br>
      To get BUILD_ID run ofed_info
      <br>
      <br>
      Please report any issues in bugzilla
      <br>
      <a class=3D"moz-txt-link-freetext"
        href=3D"http://bugs.openfabrics.org/bugzilla/">http://bugs.openfa=
brics.org/bugzilla/</a>
      for OFED 3.18
      <br>
      <br>
      Release notes:<br>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.openfabrics.org/do=
wnloads/OFED/release_notes/OFED_3.18-2-rc2_release_notes">https://www.ope=
nfabrics.org/downloads/OFED/release_notes/OFED_3.18-2-rc2_release_notes</=
a><br>
      <br>
      OFED-3.18-2-rc2 Main Changes from OFED 3.18-2-rc1<br>
-------------------------------------------------------------------------=
------<br>
      1. Updated packages:<br>
      =C2=A0 - ibpd-1.0.1<br>
      =C2=A0 - libiwpm-1.0.5<br>
      =C2=A0 - mstflint-4.3.0<br>
      2. compat-rdma changes<br>
      =C2=A0 - IB/security: Restrict use of the write() interface<br>
      =C2=A0 - xeon-phi: adjust mlx5_ib bug fix releated to large memory
      region registration<br>
      <br>
      Regards,
      <br>
      Vladimir
      <br>
    </div>
  </body>
</html>

--------------070303010009050404040906--

--===============5119007416169404411==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZXdnIG1haWxp
bmcgbGlzdApld2dAbGlzdHMub3BlbmZhYnJpY3Mub3JnCmh0dHA6Ly9saXN0cy5vcGVuZmFicmlj
cy5vcmcvbWFpbG1hbi9saXN0aW5mby9ld2c=

--===============5119007416169404411==--
