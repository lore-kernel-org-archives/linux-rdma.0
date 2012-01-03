From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Send with immediate data completion
Date: Tue, 3 Jan 2012 12:35:20 -0500
Message-ID: <9A17BA94-61E0-4176-81CF-98BE023320AF@ornl.gov>
References: <11EC89F0-2BFD-4727-BC45-AD30E0F10348@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A823732566A099@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732566A099-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jan 3, 2012, at 11:55 AM, Hefty, Sean wrote:

>> I have a question about a completion for a send with immediate data. The IB
>> spec (1.2.1) only mentions that the WC's immediate data be present at the
>> receiver. It is silent on the value on the sender at completion. It does say
>> that it is only valid if the WC's immediate data indicator is set.
> 
> Can you provide a section reference to the spec on the areas that you're looking at?  Looking quickly, section 11.4.2.1 reads like immediate data should be available in either case.
> 
> I've never checked imm data on the send wc.  I'm just trying to determine if there's an issue in the spec that should be addressed, or if this is simply a bug in the hca/driver.

There is the definition in the glossary:

Immediate Data

Data contained in a Work Queue Element that is sent along with the payload to the remote Channel Adapter and placed in a Receive Work Completion.

Section 3.7.4 Transport Layer:

The Immediate Data (IMMDT) field is optionally present in RDMA WRITE and SEND messages. It contains data that the consumer placed in the Send or RDMA Write request and the receiving QP will place that value in the current receive WQE. An RDMA Write with immediate data will consume a receive WQE even though the QP did not place any data into the receive buffer since the IMMDT is placed in a CQE that references the receive WQE and indicates that the WQE has completed.

Section 11.4.1.1 Post Send Request has:

Immediate Data Indicator. This is set if Immediate Data is to
be included in the outgoing request. Valid only for Send or
Write RDMA operations.

4-byte Immediate Data. Valid only for Send or Write RDMA operations.

11.4.2.1 Poll for Completion

Immediate data indicator. This is set if immediate data is present.

4-byte immediate data.


None specifically mention the sender's completion event.

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
