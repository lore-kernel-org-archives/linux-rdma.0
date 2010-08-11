From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Update proposal for handling BUSY responses from the SA/SM
Date: Wed, 11 Aug 2010 12:44:03 -0500
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA816BB467C46@MNEXMB2.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A43@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96016FF@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A87@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601761@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601761-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason
List-Id: linux-rdma@vger.kernel.org

> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> 
> > The problem is that none of the apps **do** handle BUSY - at all -
> and your
> > proposal still requires the apps to be changed to stop them from
> degrading
> > the fabric.
> 
> Yes - the apps are busted, so I do believe that the fixes are required
> there and not in the kernel.  If you want to fix them by applying a
> work-around in a user space library, that's still doable.  Take the
> timeout/retry values provided by the app, calculate the total timeout,
> and pass that into the kernel.
> 
> - Sean

Coding IB applications is hard enough, let's not require it to be harder.  We need a solution that fixes all the apps and makes it easy for future applications to have a sensible default behavior.  

I think Mike's approach does that, minimizes risk, addresses 3rd party apps which may not be part of OFA, and has a path toward allowing sophisticated applications to control the behavior (few if any apps will really want to do that).

I look at this as analogous to TCP sockets and the getopt/setopt calls.  They allow a lot of fine grained control, however for applications which chose not to use them, the defaults provide good network friendly behaviors.

Having the capability in the kernel is needed so that all kernel ULPs behave well, including ones not under OFA control (such as Lustre and other filesystems).

Mike's approach also allows for the addition of more sophisticated algorithms, such as random backoff, to be easily added and selected in the future.

Todd Rimmer



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
