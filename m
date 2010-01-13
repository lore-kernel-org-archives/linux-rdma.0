From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: [PATCHv7 0/9] RoCEE support to Infiniband
Date: Wed, 13 Jan 2010 23:08:30 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD026854EA@mtlexch01.mtl.com>
References: <20100105103213.GB31480@mtls03> <ada7hrnp7rr.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <ada7hrnp7rr.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCEE was chosen for these patches in accordance with the terminology
used in the proposal discussed by the OFA.  We have no problem
resubmitting these patches using "iboe" so that you can push them into
2.6.34.  We will need to stay aware of any future name recommendations
by relevant industry bodies.
--Liran
 

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Tuesday, January 12, 2010 7:12 PM
To: Eli Cohen
Cc: Linux RDMA list
Subject: Re: [PATCHv7 0/9] RoCEE support to Infiniband


 > RoCEE (pronounced 'rocky') allows running the IB transport protocol
> using Ethernet frames, enabling the deployment of IB semantics on  >
lossless Ethernet fabrics.

Just starting to review this, but let me say at the start that I really
don't like the term "RoCEE" for this stuff.  The OFED 1.5 release you
guys did was called "RDMAoE" but I really think "IBoE" is the best term.

Taking the two halves of "RoCEE": The "CEE" acronym doesn't seem
appropriate, since the standard is really called "DCB" and in any case
these patches (as far as I can tell) don't use any DCB features.  "E"
for Ethernet would make more sense.  And "R" or "RDMA" seems
insufficiently descriptive -- the whole point of this protocol is that
it uses the IB transport layer rather than iWARP or something else, so
it seems much clearer to call this "IB".  Plain "R" is really opaque --
who would ever guess that "R" stands for "RDMA".

Furthermore, it makes sense to me to take advantage of all the marketing
and exposition that we did for FCoE -- which was not called "SCSIoDCB".
The parallels are nearly exact, and being able to say that "IBoE does is
to IB transport as FCoE is to Fibre Channel" is a very clear analogy.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
