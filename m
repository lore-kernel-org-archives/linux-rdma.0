From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4 1.3.0 is released
Date: Wed, 03 Apr 2013 10:18:42 -0500
Message-ID: <515C4852.3080606@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8309885234073671054=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--===============8309885234073671054==
Content-Type: multipart/alternative;
 boundary="------------050009030907080703090203"

This is a multi-part message in MIME format.
--------------050009030907080703090203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


The libcxgb4 package contains a userspace driver for Chelsio T4 and T5 
iWARP RNICs.  It is a plug-in module for libibverbs that allows programs 
to use Chelsio hardware directly from userspace.

A new stable release is available from:

http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.0.tar.gz

with MD5Sum:

765fd7c08879a12c765edd360d7ef805

The git tree is available at:

git://www.openfabrics.org/~swise/libcxgb4 
<http://git.openfabrics.org/git?p=%7Eswise/libcxgb4.git;a=summary>

The tag is 'v1.3.0'.

This release contains critical T4 bug fixes and support for the new T5 
hardware.

Shortlog from 1.2.0:

Steve Wise (11):
       Disable strict aliasing warnings.
       Remove useless dma_addr_t define.
       Silently eat unsignaled read response cqes.
       flush bug can cause application crash
       Add new T4 device IDs.
       zero out r3 and r4 fields of fw_ri_send_wr messages.
       Add T5 support.
       Query device to get the max supported stags, qps, and cqs.
       libcxgb4: unmap the correct udb/ugts address.
       Remove aclocal.m4.
       Spin release 1.3.0


Cheers,

Steve.

--------------050009030907080703090203
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <br>
    The libcxgb4 package contains a userspace driver for Chelsio T4 and
    T5 iWARP RNICs.&nbsp; It is a plug-in module for libibverbs that allows
    programs to use Chelsio hardware directly from userspace.<br>
    <br>
    A new stable release is available from:<br>
    <br>
    <a class="moz-txt-link-freetext" href="http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.0.tar.gz">http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.0.tar.gz</a><br>
    <br>
    with MD5Sum:<br>
    <br>
    765fd7c08879a12c765edd360d7ef805<br>
    <br>
    The git tree is available at:<br>
    <br>
    <a
      href="http://git.openfabrics.org/git?p=%7Eswise/libcxgb4.git;a=summary">git://www.openfabrics.org/~swise/libcxgb4</a><br>
    <br>
    The tag is 'v1.3.0'.<br>
    <br>
    This release contains critical T4 bug fixes and support for the new
    T5 hardware.<br>
    <br>
    Shortlog from 1.2.0:<br>
    <br>
    Steve Wise (11):<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Disable strict aliasing warnings.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Remove useless dma_addr_t define.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Silently eat unsignaled read response cqes.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; flush bug can cause application crash<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Add new T4 device IDs.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zero out r3 and r4 fields of fw_ri_send_wr messages.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Add T5 support.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Query device to get the max supported stags, qps, and cqs.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; libcxgb4: unmap the correct udb/ugts address.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Remove aclocal.m4.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Spin release 1.3.0<br>
    <br>
    <br>
    Cheers,<br>
    <br>
    Steve.<br>
  </body>
</html>

--------------050009030907080703090203--

--===============8309885234073671054==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============8309885234073671054==--
