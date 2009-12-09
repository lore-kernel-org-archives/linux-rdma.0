From: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: End user documentation for Infiniband?
Date: Wed, 9 Dec 2009 09:55:36 -0800
Message-ID: <4B1FE498.3030001@nasa.gov>
References: <7b160d240912090614j7ac3c126r5fec5a1516d6f91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2061060387=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <7b160d240912090614j7ac3c126r5fec5a1516d6f91-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Ross Smith <myxiplx-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--===============2061060387==
Content-Type: multipart/alternative;
	boundary="------------020307030001000807000008"

--------------020307030001000807000008
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 12/09/2009 06:14 AM, Ross Smith wrote:
> Hi guys,
>
> Sorry if this is a bit of a newbie question, or posted to the wrong
> place, but I've been struggling to find any documentation for
> configuring infiniband, and the openfabrics mailing lists appear well
> and truly dead.
>   

The Enterprise Working Group List (ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org) is the
list for end users. Thanks.

-jeff

> I have a very basic network running now, with three hosts, ipoib and
> opensm.  It's running at 2.5Gbps which I understand is the default,
> but I cannot for the life of me find any documentation on how to
> configure it to run at higher speeds.
>
> Any network benchmarks are peaking at around 290MB/s, so just under 2.5Gbps.
> ibstat tells me that the link is running at 20.
> ibdiagnet tells me that the ipoib subnet is configured for 10Gbps, but
> that it has no members.
>
> I'm guessing that I need to configure the ipoib subnet for 20Gbps, and
> join the machines to it.  However I can't find documentation on how to
> do either of these.
>
> Can anybody help, or point me in the direction of some documentation?
>
> thanks,
>
> Ross
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


--------------020307030001000807000008
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
</head>
<body text="#000000" bgcolor="#ffffff">
On 12/09/2009 06:14 AM, Ross Smith wrote:
<blockquote
 cite="mid:7b160d240912090614j7ac3c126r5fec5a1516d6f91-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org"
 type="cite">
  <pre wrap="">Hi guys,

Sorry if this is a bit of a newbie question, or posted to the wrong
place, but I've been struggling to find any documentation for
configuring infiniband, and the openfabrics mailing lists appear well
and truly dead.
  </pre>
</blockquote>
<br>
<big><big>The Enterprise Working Group List (<a class="moz-txt-link-abbreviated" href="mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org">ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org</a>)
is the list for end users. Thanks.<br>
<br>
-jeff<br>
<br>
</big></big>
<blockquote
 cite="mid:7b160d240912090614j7ac3c126r5fec5a1516d6f91-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org"
 type="cite">
  <pre wrap="">
I have a very basic network running now, with three hosts, ipoib and
opensm.  It's running at 2.5Gbps which I understand is the default,
but I cannot for the life of me find any documentation on how to
configure it to run at higher speeds.

Any network benchmarks are peaking at around 290MB/s, so just under 2.5Gbps.
ibstat tells me that the link is running at 20.
ibdiagnet tells me that the ipoib subnet is configured for 10Gbps, but
that it has no members.

I'm guessing that I need to configure the ipoib subnet for 20Gbps, and
join the machines to it.  However I can't find documentation on how to
do either of these.

Can anybody help, or point me in the direction of some documentation?

thanks,

Ross
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to <a class="moz-txt-link-abbreviated" href="mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a>
More majordomo info at  <a class="moz-txt-link-freetext" href="http://vger.kernel.org/majordomo-info.html">http://vger.kernel.org/majordomo-info.html</a>
  </pre>
</blockquote>
<br>
</body>
</html>

--------------020307030001000807000008--

--===============2061060387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============2061060387==--
