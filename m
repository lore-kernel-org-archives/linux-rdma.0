From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling busy responses from the SA
Date: Tue, 08 Jun 2010 14:20:37 -0700
Message-ID: <adazkz5mday.fsf@roland-alpha.cisco.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DADA@MNEXMB1.qlogic.org>
	<AANLkTinEhSe7IjdzLPp6DLWGcgJd_iQuVeFvr0-HSCb-@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0C@MNEXMB1.qlogic.org>
	<AANLkTiknVS0abJVMLSZd0GOBeKvHukzbN7A1xZQDFPmD@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DCCA@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F578B7A@orsmsx501.amr.corp.intel.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DCE8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DCE8-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
	(Mike Heinz's message of "Tue, 8 Jun 2010 11:43:22 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Is there case where we would ever want to treat BUSY responses
 > differently from timeouts?

If there isn't then it's silly for the SA to ever send a BUSY response.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
