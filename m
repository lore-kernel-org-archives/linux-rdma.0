From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Wed, 14 Apr 2010 07:18:20 +0200
Message-ID: <06A5381F-9D03-4854-ABEB-B2025620E379@Sun.COM>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
 <adahbnfme0j.fsf@roland-alpha.cisco.com> <1271181774.4807.1868.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1271181774.4807.1868.camel@twins>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Apr 13, 2010, at 20:02 , Peter Zijlstra wrote:

>=20
> Yeah, virtual<->physical maps can change through swapping, page
> migration, memory compaction, huge-page aggregation (the latter two n=
ot
> yet being upstream).

Assuming this holds true, RDMA will not work. And with no RDMA, we do n=
ot need ummunotify. Is that your argument?

Seriously, RDMA requires the virtual to physical mapping to remain cons=
tant for a period of time. And that time period is from memory registra=
tion to de-registration. If the virtual to physical mapping changes in =
that period for the registered memory area, I can't see how an HCA can =
handle that.

=46or MPI applications, the MPI API defines that the buffers used in co=
mmunication cannot be changed or freed while a non-blocking transfer is=
 in progress. So far, we are good. But memory registration (and in part=
icular de-registration) is a costly process. Since MPI is about perform=
ance, the MPI library would like to  re-use earlier memory registration=
s for other transfers. The MPI library records earlier memory mappings =
(VA+bound) and checks if the VA+bound of a new transfer is already cont=
ained in memory revisions registered earlier.

The problem with this approach is that _normal_ activity _between_ the =
transfers changes the virtual to physical mapping and ruins previous me=
mory registrations. The problem is to catch these. I simply argue that =
they should be caught the simplest possible way; a call-back from the s=
ystem calls affecting the virtual to physical mapping.

>=20
> Even mlock() doesn't pin virtual<->physical maps.

Can you elaborate on what you mean here?


Thanks, H=E5kon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
