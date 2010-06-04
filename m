From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Fri, 04 Jun 2010 12:54:13 -0700
Message-ID: <adask52o9p6.fsf@roland-alpha.cisco.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
	(Mike Heinz's message of "Fri, 4 Jun 2010 12:14:06 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
