From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Hang in ib_umad when attempting to unregister.
Date: Mon, 3 May 2010 09:08:30 -0700
Message-ID: <134418B1760843CCA935A71D17114ABA@amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409EA@MNEXMB1.qlogic.org> <57C080F9018D4C488FD7F575E2CE231F@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A47409F6@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409F6-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Mike Heinz' <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, LINUX-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>This has happened on a couple of different systems in our test fabric, but the
>most recent occurrences are with RHEL5 and SLES11:
>
>RHEL5.3 2.6.18-128.el5
>SLES11 2.6.27-19-5-default

Here are a couple commits that may be relevant.  I didn't see what version they
were added, but they're both from Sept. 2009.

commit 6b2eef8fd78ff909c3396b8671d57c42559cc51d
commit 0e442afd92fcdde2cc63b6f25556b8934e42b7d2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
