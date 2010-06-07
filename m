From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Mon, 7 Jun 2010 12:55:37 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DC24@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org>
 <adask52o9p6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask52o9p6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We also have some management applications which also need these capabilities.  For those applications, the use of application RMPP control allows the application to perform some pacing of the RMPP transactions, permits some parts of the RMPP response to be built on the fly and also permits a degree of sharing of the response data between multiple requestors.

-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Friday, June 04, 2010 3:54 PM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Hal Rosenstock; Hefty, Sean
Subject: Re: [PATCH v2] allow passthrough of rmpp packets to user mad clients

 > This patch changes this behavior so that rmpp_version of 255 causes incoming rmpp packets to be passed through without alteration, instead.
 > 
 > There are IB users who have requested the ability to perform RMPP transaction handling in user space.  This was an option in old proprietary stacks and this is useful to migrate old applications to OFED while containing the scope of their application changes.  

I'm a little dubious about this.  We have an RMPP implementation in the
kernel, and it seems worthwhile to focus on stability and features
there.  Allowing alternate RMPP implementations in userspace seems a bit
iffy -- we don't have a socket option that lets us do TCP in userspace
for a given connection, for example.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
