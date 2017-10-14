From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH 0/1] Request for Comments on SoftiWarp
Date: Sat, 14 Oct 2017 00:54:09 +0000
Message-ID: <OF5FB4A7F2.2BCF122E-ON002581B9.00047C88-002581B9.0004F527@notes.na.collabserv.com>
References: <1507303666.2602.5.camel@wdc.com>,<20171005132659.25930-1-bmt@zurich.ibm.com>
         <c948ef76-8007-7fa4-8899-c3cbbafead86@opengridcomputing.com>
         <1507227589.2758.9.camel@wdc.com>
         <OFAD8C5230.833C37A3-ON002581B1.00442FF3-C12581B1.00445387@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507303666.2602.5.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-----linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote: -----

>To: "BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Bart Van Assche 
>Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Date: 10/06/2017 05:27PM
>Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
>"swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>Subject: Re: [PATCH 0/1] Request for Comments on SoftiWarp
>
>On Fri, 2017-10-06 at 14:26 +0200, Bernard Metzler wrote:
>> Sorry. Yes, done now, will resend!
>
>Hello Bernard,
>
>On Linux kernel mailing lists it is expected that replies are posted
>below the
>original e-mail instead of above. Please follow that style.
>
>Another convention you may not be aware of is that every cover letter
>for v2 and
>later versions of a patch series is expected to include a changelog
>that explains
>what changes have been made in each version.
>
>Regarding checkpatch and the soft-iWarp driver, checkpatch still
>reports a large
>number of complaints against v2 of which I think most are easy to
>address. A few
>examples:
>
>WARNING: 'vaild' may be misspelled - perhaps 'valid'?
>#1281: FILE: drivers/infiniband/sw/siw/siw_verbs.c:1052:
>+               /* make SQE only vaild after completely written */
>
>ERROR: trailing whitespace
>#2422: FILE: include/uapi/rdma/siw_user.h:133:
>+enum siw_wqe_flags { $
>
>
>Please also make yourself familiar with the static analyzer called
>'sparse'. That
>static analyzer reports a large number of complaints about the
>soft-iWarp driver,
>complaints of which I think these should be addressed. A few
>examples:
>
>
>$ make M=drivers/infiniband/sw/siw C=2
>[ ... ]
>drivers/infiniband/sw/siw/siw_cm.c:207:6: warning: symbol
>'siw_sk_assign_rtr_upcalls' was not declared. Should it be static?
>drivers/infiniband/sw/siw/siw_cm.c:464:23: warning: incorrect type in
>assignment (different base types)
>drivers/infiniband/sw/siw/siw_cm.c:464:23:    expected restricted
>__be32 [addressable] [usertype] term_ctrl
>drivers/infiniband/sw/siw/siw_cm.c:464:23:    got unsigned int
>drivers/infiniband/sw/siw/siw_cm.c:466:25: warning: cast from
>restricted __be32
>drivers/infiniband/sw/siw/siw_cm.c:466:25: warning: incorrect type in
>argument 1 (different base types)
>drivers/infiniband/sw/siw/siw_cm.c:466:25:    expected unsigned int
>[unsigned] [usertype] val
>drivers/infiniband/sw/siw/siw_cm.c:466:25:    got restricted __be32
>[addressable] [usertype] term_ctrl
>[ ... ]
>
>Thanks,
>
>Bart.

Thank you, Bart. This is very useful information. Sorry I did not follow
the conventions. I will definitively improve on that!

I was not aware of 'sparse'. I will use it and fix what it tells me.
Currently I am out in the jungle with very limited connectivity, and
I am just able to reply to comments from time to time. When back, I 
will work on the code.

Thanks very much,
Bernard.
I will be back in 10 days

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
