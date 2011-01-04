From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/24] various fixes for QIB driver
Date: Tue, 4 Jan 2011 11:02:34 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888837F70149@AVEXMB1.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
 <adahbdoijgn.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbdoijgn.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Understood on the volume.   We hadn't had any fixes for a bit, there was a considerable backlog.

Mike

-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Tuesday, January 04, 2011 1:59 PM
To: Mike Marciniszyn
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 0/24] various fixes for QIB driver

 > The following patches (ordered first to last) are for various bug fixes found
 > during internal testing.

OK, but in the future please send patches in smaller sets (say, no more
than 10 at a time).  It's hard to review and apply big patch bombs.

Also when I apply all this stuff, you will be listed as the author of
all the patches.  If there's someone else you want to give credit too,
you can put a line like

From: X Y Z <x.y.z-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

as the first line of the body of your email.  (Since you are sending the
emails, your signed-off-by should be the last line before the "---")

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
