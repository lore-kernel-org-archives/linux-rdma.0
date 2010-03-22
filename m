From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: "Unicast, no dst" warning from IPoIB
Date: Mon, 22 Mar 2010 18:13:08 +0200
Message-ID: <4BA79714.8030600@Voltaire.COM>
References: <Pine.LNX.4.64.1003221142430.5956@zuben.voltaire.com> <20100322122040.GA12224@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100322122040.GA12224-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Why did we get this? It could happen since the IPoIB neighbour that
> the specific instance of IPoIB CM is pointing to might have SKBs in
> its queue. When REP arrives for this connection, it will re-queue all
> the queued SKBs again but there may be no dst for them anymore.
> 
Do you mean that it ("no dst for them anymore.") happened due to aging of the neigh?
My intuition tells me that it should be a very rare scenario, if I guess your intension correctly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
