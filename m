From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Tue, 23 Jan 2018 17:39:34 +0000
Message-ID: <OFCE810B46.0507E9FA-ON0025821E.0060B1A4-0025821E.006101E9@notes.na.collabserv.com>
References: <20180123172830.GF30670@ziepe.ca>,<20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-4-bmt@zurich.ibm.com>
 <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
 <20180123164316.GC30670@ziepe.ca>
 <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>
 <20180123170517.GE30670@ziepe.ca>
 <013a01d3946f$034683f0$09d38bd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123172830.GF30670-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote: -----

>To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
>Date: 01/23/2018 06:28PM
>Cc: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>On Tue, Jan 23, 2018 at 11:24:24AM -0600, Steve Wise wrote:
>> > 
>> > On Tue, Jan 23, 2018 at 10:58:01AM -0600, Steve Wise wrote:
>> > 
>> > > From:
>https://urldefense.proofpoint.com/v2/url?u=https-3A__tools.ietf.org_h
>tml_rfc5041-23section-2D5.2&d=DwIBAg&c=jf_iaSHvJObTbx-siA1ZOg&r=2TaYX
>Q0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=bZXyEf2ir9_OhkryeDGP_iwh7sDL
>DExD5C6xOEAgGAE&s=N-AUE48HDPRCcFKzdGiM59z8OSmoZKD9AkS1WBpnfLY&e=
>> > >
>> > > "At the Data Source, the DDP layer MUST segment the data
>contained in
>> > >    a ULP message into a series of DDP Segments, where each DDP
>Segment
>> > >    contains a DDP Header and ULP Payload, and MUST be no larger
>than the
>> > >    MULPDU value Advertised by the LLP."
>> > >
>> > > Where MULDPDU is the maximum ULP PDU that will fit in the TCP
>MSS...
>> > 
>> > But exceeding the MULPDU has nothing to do with the netstack GSO
>> > function.. right? GSO is entirely a local node optimization that
>> > should not be detectable on the wire.
>> 
>> It is not detectable by TCP on the wire, however the iWARP
>protocols that
>> impose message boundaries, among other things, require that the
>iWARP PDU
>> fits in a single TCP segment.  Since softiwarp is building the
>iwarp PDU, if
>> it builds one based on a 64K GSO advertised MSS, then the resulting
>wire
>> packets will have man TCP segments all containing parts of a single
>iWARP
>> PDU, which violates the spec I quoted.
>
>But that still has nothing to do with GSO, can't you GSS up to
>MULPDU?
>
>Isn't the issue here more that, as Bernard says, siw is totally
>broken
>since it can't control the TCP layer segmentation boundaries? :(
>

totally broken. hmm.

Not integrating siw with the TCP kernel code makes it impossible
to avoid these things. Can kernel iSCSI avoid fragmentation and
mis-alignment? No.
I wanted to avoid tweaking kernel TCP code. That would make
siw non acceptable.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
