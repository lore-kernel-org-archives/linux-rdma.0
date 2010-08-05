From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: How to know if SRQ is being used in SRP?
Date: Thu, 05 Aug 2010 11:16:02 -0700
Message-ID: <adar5id3oyl.fsf@roland-alpha.cisco.com>
References: <201008031602.37294.bvanassche@acm.org>
	<4C59C34F.2000400@vlnb.net> <adak4o66rir.fsf@roland-alpha.cisco.com>
	<AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ@mail.gmail.com>
	<8BAAFD34FEF6492A8E3B43698E454B3D@md.baymicrosystems.com>
	<1281030129.7414.16.camel@chromite.mv.qlogic.com>
	<D8F95421ED674F1DAC3A9A471854A748@md.baymicrosystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D8F95421ED674F1DAC3A9A471854A748-+IkoAhRkys/CbFgIbBqbbjGjJy/sRE9J@public.gmane.org> (Suresh
	Shelvapille's message of "Thu, 5 Aug 2010 14:05:56 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: 'Ralph Campbell' <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > I am told that the customer has modified the SRP code, which is why I cannot go by the ib_srp.c code. 

Can you not ask the customer??  Or if you have the object code, look for
calls to srq functions in the binary??

  > 1. Would the Syndrome field show CC INVALID if SRQ were being used?
  > If so, in which IB message would it show---RDMA read response, or in
  > an initial RC SEND message or both?

As I said before, the implication is only one way.  If end-to-end flow
control is not used, that does not imply anything -- the CM protocol
allows flow control to be turned off even if an SRQ is not used.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
