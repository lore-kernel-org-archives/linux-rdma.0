From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 17:19:45 -0500
Message-ID: <4D7E9481.5060606@opengridcomputing.com>
References: <4D7E27E4.7060606@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612@orsmsx501.amr.corp.intel.com> <4D7E3568.7010406@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39DF3@orsmsx501.amr.corp.intel.com> <4D7E8A25.8010701@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39E12@orsmsx501.amr.corp.intel.com> <4D7E8F60.7030006@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39EAF@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39EAF-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/14/2011 05:12 PM, Hefty, Sean wrote:
>> When you say 'client must then determine', do you mean the client
>> application?  So the IB CM really just passes along
>> these values and doesn't really enforce any semantics?
> Yes and yes.  (The ib cm is probably a bit brain dead on this, but the librdmacm does check for this error.)  From the IB spec (sections intentionally reversed) see the two areas marked *****:
>
> 12.7.30 INITIATOR DEPTH
> The maximum number of outstanding RDMA Read/Atomic operations the
> sender will have to the remote QP/EEC. This value may be zero. The
> maximum number that the HCA can support for a QP/EEC can be determined
> using the Query HCA verb. See section 11.2.1.2 Query HCA.
> InfiniBandTM Architecture Release 1.2.1 Communication Management November 2007
>
> *****The recipient of the REQ message should try to choose a number of local
> Responder Resources that is greater than or equal to the Initiator Depth
> in the REQ message. If it is unwilling or unable to do so, it may send a
> REP message containing fewer Responder Resources than the Initiator
> Depth in the REQ message.*****
>
> 12.7.29 RESPONDER RESOURCES
> The maximum number of outstanding RDMA Read/Atomic operations the
> sender will support from the remote QP/EEC. This value may be zero. The
> maximum number that the HCA can support for a QP/EEC can be determined
> using the Query HCA verb. See section 11.2.1.2 Query HCA.
>
> The recipient of the REQ message shall choose a local Initiator Depth that
> does not exceed the Responder Resources offered in the REQ. If the recipient
> of the REQ message is unwilling or unable to do so, it shall send a
> REJ message to discontinue the connection establishment.
>
> *****The recipient of the REP message shall decide whether the Responder
> Resources offered in the REP are sufficient for the Initiator Depth the recipient
> of the REP wishes to use.***** If not, it shall send a REJ message to
> discontinue the connection establishment.
>
>
>> The reason I'm asking is we're reviewing the IETF ID that extends MPA
>> connection setup to allow negotiating ORD/IRD.
>> And I think we should not diverge from the way its done in IB.  IE: the
>> RDMACM semantics should be the same IMO.
> What does iwarp do now?

The current IETF specs leave it up to the applications/ULPs to deal with it.  Neither ORD or IRD are exchanged as part 
of MPA or other iWARP protocol negotiations.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
