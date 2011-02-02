From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] [PATCH] IB/core: Control number of retries for SA to
 leave an MCG
Date: Wed, 2 Feb 2011 09:26:30 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC0C1E13@orsmsx501.amr.corp.intel.com>
References: <4D4973B2.9070300@Voltaire.COM>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A20A5E98F@MNEXMB1.qlogic.org>
 <4D497B35.2010901@Voltaire.COM>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A20A5E993@MNEXMB1.qlogic.org>
 <4D49848B.6090206@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D49848B.6090206-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org" <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The worst thing is that there is no indication to the user about this state

There can be multiple users of the same group.  Only the last one leaving causes the leave request to be sent.  Notifying that one user of the group doesn't help.  All they can do is ask for the leave request to be retried anyway, which has to be coordinated with potential new users.

> (a host is joined without no one to ever try and make it leave)
> The patch I sent also puts a message in the kernel log so users can read
> and react.

IMO, this is always a possibility and something that the SA must be able to handle.  If a node, switch, link, etc. go down, there's no guarantee that any leave request will be generated, let alone make it to the SA.

Architecturally, I think the only currently available option is for the SA to ask a client to reregister.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
