From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: ib mad definitions
Date: Tue, 19 Oct 2010 09:53:42 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D45E42EF@MNEXMB1.qlogic.org>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Works for me.

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
Sent: Monday, October 18, 2010 6:25 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Sasha Khapyorsky
Subject: ib mad definitions

This has probably been discussed before, but is there a strong reason why ib_types.h can't be moved from opensm/include/iba to libibumad/include/infiniband?

This appears to be the only place where IB MAD definitions are available for user space applications, and having them available at the libibumad level makes sense to me.

(I'm trying to port madeye to user space as a diag, and want all IB MAD definitions.)

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
