From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Update proposal for handling BUSY responses from the SA/SM
Date: Wed, 11 Aug 2010 14:04:02 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493ACD@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A43@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96016FF@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A87@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601761@orsmsx501.amr.corp.intel.com>
 <5AEC2602AE03EB46BFC16C6B9B200DA816BB467C46@MNEXMB2.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96017FE@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4493AC5@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493AC5-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland
List-Id: linux-rdma@vger.kernel.org

Sean,

What if we reversed the sense of your idea - if the app or ulp provides a positive timeout number, apply the combined time-out concept, but if it provides a negative number, force it to handle BUSY itself? This would provide a good quality default behavior.

Also - it still makes sense to me that we take the approach of not doing anything that requires immediate changes to ABIs and APIs but rather set up the underlying architecture to allow the change to be propagated over time.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
