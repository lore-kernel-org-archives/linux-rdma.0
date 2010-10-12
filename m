From: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 12 Oct 2010 18:29:53 +0200
Message-ID: <1286900993.31931.4.camel@alst60.voltaire.com>
References: <4CAB4D49.9090107@voltaire.com>
	<20101005162833.GC5967@obsidianresearch.com>
	<alpine.DEB.2.00.1010051410370.7065@router.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1595360084=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1010051410370.7065-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--===============1595360084==
Content-Type: multipart/alternative; boundary="=-Wbm23kuh5QFHgUP2vSmY"


--=-Wbm23kuh5QFHgUP2vSmY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-10-05 at 14:12 -0500, Christoph Lameter wrote:

> On Tue, 5 Oct 2010, Jason Gunthorpe wrote:
>=20
> > On Tue, Oct 05, 2010 at 06:07:37PM +0200, Aleksey Senin wrote:
> > > When using slow SM allow more packets to be buffered before answer
> > > comming back. This patch based on idea of Christoph Lameter.
> > >
> > > http://lists.openfabrics.org/pipermail/general/2009-June/059853.html
> >
> > IMHO, I think it is better to send multicasts to the broadcast MLID tha=
n to
> > queue them.. More like ethernet that way.
>=20
> I agree. We had similar ideas. However, the kernel does send igmp
> reports to the MC address not to 244.0.0.2. We would have to redirect at
> the IB layer until multicast via MLID becomes functional. We cannot tell
> when that will be the case.
>=20
>=20


But what if it will not be available from some reason? How long should
we wait? Do we need implement another queue/counter/timeout?=20

--=-Wbm23kuh5QFHgUP2vSmY
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; CHARSET=3DUTF-8">
  <META NAME=3D"GENERATOR" CONTENT=3D"GtkHTML/3.28.2">
</HEAD>
<BODY>
On Tue, 2010-10-05 at 14:12 -0500, Christoph Lameter wrote:
<BLOCKQUOTE TYPE=3DCITE>
<PRE>
On Tue, 5 Oct 2010, Jason Gunthorpe wrote:

&gt; On Tue, Oct 05, 2010 at 06:07:37PM +0200, Aleksey Senin wrote:
&gt; &gt; When using slow SM allow more packets to be buffered before answe=
r
&gt; &gt; comming back. This patch based on idea of Christoph Lameter.
&gt; &gt;
&gt; &gt; <A HREF=3D"http://lists.openfabrics.org/pipermail/general/2009-Ju=
ne/059853.html">http://lists.openfabrics.org/pipermail/general/2009-June/05=
9853.html</A>
&gt;
&gt; IMHO, I think it is better to send multicasts to the broadcast MLID th=
an to
&gt; queue them.. More like ethernet that way.

I agree. We had similar ideas. However, the kernel does send igmp
reports to the MC address not to 244.0.0.2. We would have to redirect at
the IB layer until multicast via MLID becomes functional. We cannot tell
when that will be the case.


</PRE>
</BLOCKQUOTE>
<BR>
But what if it will not be available from some reason? How long should we w=
ait? Do we need implement another queue/counter/timeout?=20
</BODY>
</HTML>

--=-Wbm23kuh5QFHgUP2vSmY--

--===============1595360084==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============1595360084==--
