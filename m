From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 09:31:10 -0700
Message-ID: <91D2572C3FA443CA9CC632F4AEDFFD6E@amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org> <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Mike Heinz' <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Would it be better to omit the multicast support from ib_usa and simply add it
>as a way to handle notifications?

I think so, since it limits the number of interfaces and libraries that a user
needs to learn.

I'm not sure of the best userspace interface for notifications.  Maybe there's a
way to extend the async event reporting in libibverbs?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
