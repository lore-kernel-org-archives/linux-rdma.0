From: richard Croucher <Richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Subject: Re: [ANNOUNCE] OFED 4.8-rc2 release is available
Date: Fri, 05 May 2017 08:43:21 +0100
Message-ID: <1493970201.27669.19.camel@informatix-sol.com>
References: <590096A3.5090107@dev.mellanox.co.il>
 <20170427070657.GA13585@infradead.org>
 <20170504084933.GA1359@infradead.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7E953FA6@ORSMSX115.amr.corp.intel.com>
 <20170504153003.GA854@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1199FA@ORSMSX109.amr.corp.intel.com>
 <e982e074-4a0a-397f-fbe2-63ff0232c56d@llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1129413274075505437=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <e982e074-4a0a-397f-fbe2-63ff0232c56d-i2BcT+NCU+M@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
 <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
 <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Sender: "ewg" <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--===============1129413274075505437==
Content-Type: multipart/alternative; boundary="=-r0YNfouxIfM74a97bty/"


--=-r0YNfouxIfM74a97bty/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

I could not echo this point more.  I principally work with Enterprise
clients.  None use custom kernels and all are dependent on the support
provided from their Linux distro vendors.  
We have repeatedly ended up in finger pointing exercises where RDMA
 vendors insist on us using their drivers and the Linux distro vendor
want us to use there's.   The customer always loses in these
situations.
Only as an absolute last resort we will use proprietary drivers,
 modules  and system libraries because we know it will compromise
support and may hit us later.
Certain vendors try to do this under the radar  now replacing all sorts
of distro system libraries when you innocently install their Ethernet
driver.  Doing it surreptitiously rather than blatantly is not the
answer.   Get your code into mainline and work with the major distro
vendors on the backports and updates.
I continually face resistance from Enterprise accounts in adopting RDMA
in a more widespread manner.   It's the perception of the risk raised
by the Linux SA's in supporting these systems.    I needs to just
'work' running only the standard distro installers to add it if it is
not there by default. 
On Thu, 2017-05-04 at 20:42 -0700, Jim Foraker wrote:
> On 05/04/2017 10:34 AM, Hefty, Sean wrote:
> > 
> > > 
> > > This is exactly why we so strongly discourage this out of tree
> > > stuff - getting something unmergable in OFED is *NOT* Job Done,
> > > Time to Go Home. Down this path just creates another Lustre mess.
> > Actually, this may be 'job done'.  No individual or company is
> > obligated to provide upstream software for any of their hardware.
> > OFA decides what to ship in their software products, not the
> > greater
> > linux kernel community.  Individual companies can decide if out of
> > tree maintenance is more cost effective than trying to merge code
> > upstream.  Because that's what this ultimately comes down to.
> > 
> > IMO, the only people who have legitimate complaints here are those
> > people running Xeon Phi with Mellanox HCAs who are being forced to
> > use OFED, rather than upstream code.
>       Apparently we've experimented with doing just this, so I'll
> bite. 
> And I will say the same thing we've told every vendor repeatedly:
> "get 
> your code upstream!"
>       A vendor may weigh the cost of maintaining out-of-tree code
> versus 
> upstreaming it, but as a customer, I'm more concerned about the 
> annoyance and time wasted having to run N different software stacks
> on N 
> different hardware types versus being able to use the RDMA stack from
> my 
> preferred linux distribution everywhere.  And the best way to get
> your 
> code into the distributions is to get it upstream.
>       I have no particular opinion on whether or not the xeon-phi
> driver 
> belongs in OFED.  But cloaking this conversation in talk of
> obligations 
> and framers' intent misses a bigger point, which is that any code
> not 
> fully upstreamed, and hence likely to be found in your user's
> distro, 
> inconveniences them, increases their support costs, and makes it
> less 
> likely that they will adopt your product.
> 
>       Jim
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/mailman/listinfo/ewg
-- 

Richard Croucher
www.informatix-sol.com


--=-r0YNfouxIfM74a97bty/
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode:=
 space; -webkit-line-break: after-white-space;"><div>I could not echo this =
point more. &nbsp;I principally work with Enterprise clients. &nbsp;None us=
e custom kernels and all are dependent on the support provided from their L=
inux distro vendors. &nbsp;</div><div><br></div><div>We have repeatedly end=
ed up in finger pointing exercises where RDMA &nbsp;vendors insist on us us=
ing their drivers and the Linux distro vendor want us to use there's. &nbsp=
; The customer always loses in these situations.</div><div><br></div><div>O=
nly as an absolute last resort we will use proprietary drivers, &nbsp;modul=
es &nbsp;and system libraries because we know it will compromise support an=
d may hit us later.</div><div><br></div><div>Certain vendors try to do this=
 under the radar &nbsp;now replacing all sorts of distro system libraries w=
hen you innocently install their Ethernet driver. &nbsp;Doing it surreptiti=
ously rather than blatantly is not the answer. &nbsp; Get your code into ma=
inline and work with the major distro vendors on the backports and updates.=
</div><div><br></div><div>I continually face resistance from Enterprise acc=
ounts in adopting RDMA in a more widespread manner. &nbsp; It's the percept=
ion of the risk raised by the Linux SA's in supporting these systems. &nbsp=
; &nbsp;I needs to just 'work' running only the standard distro installers =
to add it if it is not there by default.&nbsp;</div><div><br></div><div>On =
Thu, 2017-05-04 at 20:42 -0700, Jim Foraker wrote:</div><blockquote type=3D=
"cite"><pre>On 05/04/2017 10:34 AM, Hefty, Sean wrote:
<blockquote type=3D"cite">
<blockquote type=3D"cite">
This is exactly why we so strongly discourage this out of tree
stuff - getting something unmergable in OFED is *NOT* Job Done,
Time to Go Home. Down this path just creates another Lustre mess.
</blockquote>

Actually, this may be 'job done'.  No individual or company is
obligated to provide upstream software for any of their hardware.
OFA decides what to ship in their software products, not the greater
linux kernel community.  Individual companies can decide if out of
tree maintenance is more cost effective than trying to merge code
upstream.  Because that's what this ultimately comes down to.

IMO, the only people who have legitimate complaints here are those
people running Xeon Phi with Mellanox HCAs who are being forced to
use OFED, rather than upstream code.
</blockquote>

      Apparently we've experimented with doing just this, so I'll bite.=20
And I will say the same thing we've told every vendor repeatedly: "get=20
your code upstream!"
      A vendor may weigh the cost of maintaining out-of-tree code versus=
=20
upstreaming it, but as a customer, I'm more concerned about the=20
annoyance and time wasted having to run N different software stacks on N=
=20
different hardware types versus being able to use the RDMA stack from my=
=20
preferred linux distribution everywhere.  And the best way to get your=20
code into the distributions is to get it upstream.
      I have no particular opinion on whether or not the xeon-phi driver=
=20
belongs in OFED.  But cloaking this conversation in talk of obligations=20
and framers' intent misses a bigger point, which is that any code not=20
fully upstreamed, and hence likely to be found in your user's distro,=20
inconveniences them, increases their support costs, and makes it less=20
likely that they will adopt your product.

      Jim
_______________________________________________
ewg mailing list
<a href=3D"mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org">ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org</a>
<a href=3D"http://lists.openfabrics.org/mailman/listinfo/ewg">http://lists.=
openfabrics.org/mailman/listinfo/ewg</a></pre></blockquote><div><span>-- <b=
r>


  <meta http-equiv=3D"Content-Type" content=3D"text/html; CHARSET=3DUTF-8">
  <meta name=3D"GENERATOR" content=3D"GtkHTML/4.6.6">


<br>
Richard Croucher<br>
<a href=3D"http://www.informatix-sol.com">www.informatix-sol.com</a><br>
<br>


</span></div></body></html>
--=-r0YNfouxIfM74a97bty/--


--===============1129413274075505437==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZXdnIG1haWxp
bmcgbGlzdApld2dAbGlzdHMub3BlbmZhYnJpY3Mub3JnCmh0dHA6Ly9saXN0cy5vcGVuZmFicmlj
cy5vcmcvbWFpbG1hbi9saXN0aW5mby9ld2c=

--===============1129413274075505437==--
