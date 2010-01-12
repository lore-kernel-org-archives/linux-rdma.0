From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv7 0/9] RoCEE support to Infiniband
Date: Tue, 12 Jan 2010 09:12:08 -0800
Message-ID: <ada7hrnp7rr.fsf@roland-alpha.cisco.com>
References: <20100105103213.GB31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105103213.GB31480@mtls03> (Eli Cohen's message of "Tue, 5
	Jan 2010 12:32:13 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > RoCEE (pronounced =E2=80=98rocky=E2=80=99) allows running the IB tra=
nsport protocol
 > using Ethernet frames, enabling the deployment of IB semantics on
 > lossless Ethernet fabrics.

Just starting to review this, but let me say at the start that I really
don't like the term "RoCEE" for this stuff.  The OFED 1.5 release you
guys did was called "RDMAoE" but I really think "IBoE" is the best term=
=2E

Taking the two halves of "RoCEE": The "CEE" acronym doesn't seem
appropriate, since the standard is really called "DCB" and in any case
these patches (as far as I can tell) don't use any DCB features.  "E"
for Ethernet would make more sense.  And "R" or "RDMA" seems
insufficiently descriptive -- the whole point of this protocol is that
it uses the IB transport layer rather than iWARP or something else, so
it seems much clearer to call this "IB".  Plain "R" is really opaque --
who would ever guess that "R" stands for "RDMA".

=46urthermore, it makes sense to me to take advantage of all the market=
ing
and exposition that we did for FCoE -- which was not called "SCSIoDCB".
The parallels are nearly exact, and being able to say that "IBoE does
is to IB transport as FCoE is to Fibre Channel" is a very clear analogy=
=2E

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
