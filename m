From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: OpenSM: reporting traps 129, 130, 131
Date: Thu, 12 Nov 2009 17:42:13 +0200
Message-ID: <20091112154213.GH7192@me>
References: <4AF6D78E.6080600@dev.mellanox.co.il>
 <f0e08f230911120546q5aa0ed72oc6811cbd2471bc44@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230911120546q5aa0ed72oc6811cbd2471bc44-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08:46 Thu 12 Nov     , Hal Rosenstock wrote:
> >
> > Any particular reason why there's no reporting of these traps?
> 
> AFAIK it's been this way for at least the last 5 or 6 years.

Yes, this is what I found too tracking down git/svn history.

> A practical consideration in changing this is that these traps are the
> ones for which babbling port was implemented since they do not obey
> the trap rate so there's a large downside to adding the reports for
> these. If that is to be done, then perhaps this should be done based
> on some option.

I don't think that we need new option for this, instead we should care
that OpenSM is not overloaded by such trap floods.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
