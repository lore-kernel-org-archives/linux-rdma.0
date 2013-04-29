From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH for-next 6/9] IB/core: Add receive Flow Steering support
Date: Mon, 29 Apr 2013 14:16:55 -0500
Message-ID: <517EC727.7070204@opengridcomputing.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com> <1366811932-28199-7-git-send-email-ogerlitz@mellanox.com> <CAJZOPZLLxetr5muxWdQZxBZBNf8fUt5ZthTMaVt=Dh9UZ3Uc1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLLxetr5muxWdQZxBZBNf8fUt5ZthTMaVt=Dh9UZ3Uc1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/29/2013 2:02 PM, Or Gerlitz wrote:
> On Wed, Apr 24, 2013 at 4:58 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> The RDMA stack allows for applications to create IB_QPT_RAW_PACKET QPs,
>> for which plain Ethernet packets are used, specifically packets which
>> don't carry any QPN to be matched by the receiving side.
>>
>> Applications using these QPs must be provided with a method to
>> program some steering rule with the HW so packets arriving at
>> the local port can be routed to them.
> Any feedback? we've added RAW PACKET QPs support back on 3.5 or 3.6
> but without RX flow steering APIs applications can only send packets,
> but not receive them, which is a bit of a problem for production... so
> here's a concrete && working suggestion, waiting to be reviewed and
> hopefully accepted.
>
> Or.

Hey Or,  This looks good at first glance.  I must confess I cannot tell 
yet if this will provide everything we need for chelsio's RAW packet 
requirements.  But I think we should move forward on this, and enhance 
as needed.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
