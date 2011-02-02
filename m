From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: [ewg] [PATCH] IB/core: Control number of retries for SA to leave
 an MCG
Date: Wed, 02 Feb 2011 18:21:31 +0200
Message-ID: <4D49848B.6090206@Voltaire.COM>
References: <4D4973B2.9070300@Voltaire.COM> <4C2744E8AD2982428C5BFE523DF8CDCB4A20A5E98F@MNEXMB1.qlogic.org> <4D497B35.2010901@Voltaire.COM> <4C2744E8AD2982428C5BFE523DF8CDCB4A20A5E993@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A20A5E993-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org" <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike Heinz wrote:
> It was discussed in the Linux-RDMA list for many months. You can find a list of the archived messages here:
> 
> http://www.mail-archive.com/search?q=SA+Busy&l=linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> The most recent version of the patch is here:
> 
> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg06644.html
> 
> Basically, the spec permits an SM to reply "busy" instead of simply tossing packets on the floor, but OFED does not handle this case right now.
> 
I took a look and I'm not sure that your patch solves the issue I was trying to handle.
Nothing will prevent from number of retries to reach zero and no one will report the upper layer (e.g IPoIB)
that leaving the multicast group had failed.
The worst thing is that there is no indication to the user about this state (a host is joined without no one to ever try and make it leave)
The patch I sent also puts a message in the kernel log so users can read and react.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
