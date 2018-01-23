From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: RE: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Tue, 23 Jan 2018 17:23:31 +0000
Message-ID: <OF34749881.4216E578-ON0025821E.005F897C-0025821E.005F8983@notes.na.collabserv.com>
References: <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>,<20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-4-bmt@zurich.ibm.com>
 <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
 <20180123164316.GC30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



---
Bernard Metzler, PhD
Tech. Leader High Performance I/O, Principal Research Staff
IBM Zurich Research Laboratory
Saeumerstrasse 4
CH-8803 Rueschlikon, Switzerland
+41 44 724 8605

-----"Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote: -----

>To: "'Jason Gunthorpe'" <jgg-uk2M96/98Pc@public.gmane.org>
>From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>Date: 01/23/2018 05:58PM
>Cc: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
><linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>Subject: RE: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>> 
>> On Tue, Jan 23, 2018 at 10:33:48AM -0600, Steve Wise wrote:
>> 
>> > > +/* Restrict usage of GSO, if hardware peer iwarp is unable to
>process
>> > > + * large packets. gso_seg_limit = 1 lets siw send only packets
>up to
>> > > + * one real MTU in size, but severly limits maximum bandwidth.
>> > > + * gso_seg_limit = 0 makes use of GSO (and more than doubles
>throughput
>> > > + * for large transfers).
>> > > + */
>> > > +const int gso_seg_limit;
>> > > +
>> >
>> > The GSO configuration needs to default to enable interoperation
>with all
>> > vendors (and comply with the RFCs).  So make it 1 please.
>> 
>> The thing we call GSO in the netstack should be totally transparent
>on
>> the wire, so at the very least this needs some additional
>elaboration.
>> 
>
>From:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__tools.ietf.org_h
>tml_rfc5041-23section-2D5.2&d=DwICAg&c=jf_iaSHvJObTbx-siA1ZOg&r=2TaYX
>Q0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=maNYrMpuQjDoXG0NADT5M-LhIwmL
>KrmFzWtWh4J3sAc&s=ZDYAQqhyaTuRtFqQpA95k0oT6ildygWkkmJ3fqIWNzU&e=
>
>"At the Data Source, the DDP layer MUST segment the data contained in
>   a ULP message into a series of DDP Segments, where each DDP
>Segment
>   contains a DDP Header and ULP Payload, and MUST be no larger than
>the
>   MULPDU value Advertised by the LLP."

TCP advertises 64k on the kernel socket ;)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
