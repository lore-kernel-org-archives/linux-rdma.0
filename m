From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Wed, 1 Sep 2010 16:23:13 +0300
Message-ID: <20100901132313.GA12172@me>
References: <4C6B9A42.9020505@voltaire.com>
 <20100824040354.GH5837@me>
 <4C73B34A.4080508@voltaire.com>
 <AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN@mail.gmail.com>
 <4C73C8BC.6010702@voltaire.com>
 <AANLkTime9OX4EPS_c+pKwnchuVfyLqeLcuX0rXDjOCgR@mail.gmail.com>
 <20100825170656.GM5837@me>
 <4C7D0F46.1030305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C7D0F46.1030305-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17:18 Tue 31 Aug     , Eli Dorfman (Voltaire) wrote:
> Sasha Khapyorsky wrote:
> > On 09:45 Tue 24 Aug     , Hal Rosenstock wrote:
> >>> What about the flag? do we still need it if we pass the output after the comment?
> >> I wouldn't think so. I also think we've made commentary changes to the
> >> ibnetdiscover output format like this before. If we wanted to be
> >> absolutely sure it wouldn't break anything, we'd keep the flag though.
> >> It's up to Sasha.
> > 
> > The '-f' flag could make sense since those information actually
> > duplicates previous 4xDDR, etc. and used by ibsim's parser only.
> > 
> > Also it would be nice to make ibsim's parser to understand both
> > possibilities: s=2 and speed=2 (Or even to parse "*x*DR" strings :))
> 
> Is it valid to assume that "*x*DR" string is always the last token?

I think that it would be better to not assume this.

Sasha

> If so, the patch should be changed
> 
> Eli
> > 
> > Sasha
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
